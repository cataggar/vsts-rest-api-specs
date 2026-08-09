// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// group-operations.mjs — rewrite the flat operation list emitted by
// `tsp-openapi3` into TypeSpec interfaces.
//
// Azure DevOps spells every operationId as `Group_Operation`. Left flat,
// TCGC produces a single client whose methods are named
// `repositories_GetDeletedRepositories`. Grouped into interfaces it
// produces one operation group per `Group`, so a generator can emit
// `client.repositories().getDeletedRepositories()`.
//
//   @route("/…") @get
//   op Repositories_GetDeletedRepositories(...): Response;
//
// becomes
//
//   interface Repositories {
//     @route("/…") @get
//     GetDeletedRepositories(...): Response;
//   }

/**
 * Returns the `[start, end)` ranges of top-level statements in `source`.
 *
 * Comments, string literals and backtick-quoted identifiers are skipped
 * so that a brace or semicolon inside documentation cannot be mistaken
 * for the end of a statement.
 *
 * Only block declarations may be closed by `}`; an `op` is always closed
 * by `;`, because an anonymous model in its return type would otherwise
 * look like the end of the statement:
 *
 *   op Blobs_Get(): {@body body: Blob} | BlobRef;
 */
export function scanTopLevel(source) {
  const blockKeywords = new Set(["model", "interface", "namespace", "enum", "union", "scalar"]);
  const statements = [];
  let depth = 0;
  let start = null;
  let keyword = null;
  let afterAt = false;
  let i = 0;

  const finish = (end) => {
    statements.push([start, end]);
    start = null;
    keyword = null;
    afterAt = false;
  };

  while (i < source.length) {
    const c = source[i];
    const next = source[i + 1];

    if (c === "/" && next === "/") {
      const end = source.indexOf("\n", i);
      i = end === -1 ? source.length : end + 1;
      continue;
    }
    if (c === "/" && next === "*") {
      if (start === null) start = i;
      const end = source.indexOf("*/", i + 2);
      i = end === -1 ? source.length : end + 2;
      continue;
    }
    if (c === '"') {
      if (start === null) start = i;
      i += 1;
      while (i < source.length) {
        if (source[i] === "\\") i += 2;
        else if (source[i] === '"') {
          i += 1;
          break;
        } else i += 1;
      }
      continue;
    }
    if (c === "`") {
      if (start === null) start = i;
      i += 1;
      while (i < source.length && source[i] !== "`") i += 1;
      i += 1;
      continue;
    }

    if (!/\s/.test(c) && start === null) start = i;

    if (depth === 0 && /[A-Za-z_]/.test(c)) {
      let end = i;
      while (end < source.length && /[A-Za-z0-9_]/.test(source[end])) end += 1;
      const word = source.slice(i, end);
      // A decorator name follows `@` and is not the statement keyword.
      if (keyword === null && !afterAt) keyword = word;
      afterAt = false;
      i = end;
      continue;
    }

    if (c === "@") {
      // Only a decorator at statement level can hide the keyword; the
      // ones inside a model body are nested and must not be tracked.
      if (depth === 0) afterAt = true;
    } else if (c === "{" || c === "(" || c === "[") {
      depth += 1;
    } else if (c === "}" || c === ")" || c === "]") {
      depth -= 1;
      if (depth === 0 && c === "}" && start !== null && blockKeywords.has(keyword)) {
        finish(i + 1);
      }
    } else if (c === ";" && depth === 0 && start !== null) {
      finish(i + 1);
    }
    i += 1;
  }
  return statements;
}

const indent = (text, pad = "  ") =>
  text
    .split("\n")
    .map((line) => (line.trim().length === 0 ? "" : pad + line))
    .join("\n");

/**
 * Moves every `Group_Member` operation into `interface Group`.
 * Operations without a `Group_` prefix, and all other declarations, are
 * left untouched.
 *
 * Azure DevOps reuses a resource name for both a model and its operation
 * group (`model Timeline` alongside `Timeline_Get`), which TypeSpec
 * rejects as a duplicate symbol. Colliding interfaces are suffixed with
 * `Operations`; the returned `renames` map records each one.
 */
export function groupOperations(source) {
  const declared = new Set();
  const groups = new Map();
  const removals = [];

  for (const [start, end] of scanTopLevel(source)) {
    const text = source.slice(start, end);

    const declaration = text.match(
      /(?:^|\n)(?:model|enum|union|scalar|alias|interface|op)[ \t]+([A-Za-z_][A-Za-z0-9_]*)/,
    );
    if (declaration) declared.add(declaration[1]);

    // The `op` keyword must begin a line; otherwise it is a word inside
    // a doc comment or decorator argument.
    const match = text.match(/(?:^|\n)(op[ \t]+)([A-Za-z_][A-Za-z0-9_]*)[ \t]*(?=\(|is\b|<)/);
    if (!match) continue;

    const operationName = match[2];
    const separator = operationName.indexOf("_");
    if (separator <= 0) continue;
    const group = operationName.slice(0, separator);
    const member = operationName.slice(separator + 1);
    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(group)) continue;
    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(member)) continue;

    const keywordAt = match.index + (match[0][0] === "\n" ? 1 : 0);
    const head = text.slice(0, keywordAt).trimEnd();
    const rest = text.slice(keywordAt + match[1].length + operationName.length);

    if (!groups.has(group)) groups.set(group, []);
    groups.get(group).push(`${head ? `${head}\n` : ""}${member}${rest}`);
    removals.push([start, end]);
  }

  if (groups.size === 0) return { source, renames: {} };

  let remaining = "";
  let cursor = 0;
  for (const [start, end] of removals) {
    remaining += source.slice(cursor, start);
    cursor = end;
  }
  remaining += source.slice(cursor);
  remaining = remaining.replace(/\n{3,}/g, "\n\n").trimEnd();

  const renames = {};
  const interfaces = [...groups.entries()]
    .map(([name, members]) => {
      let interfaceName = name;
      while (declared.has(interfaceName)) interfaceName = `${interfaceName}Operations`;
      if (interfaceName !== name) renames[name] = interfaceName;
      declared.add(interfaceName);
      return `interface ${interfaceName} {\n${members.map((m) => indent(m)).join("\n\n")}\n}`;
    })
    .join("\n\n");

  return { source: `${remaining}\n\n${interfaces}\n`, renames };
}
