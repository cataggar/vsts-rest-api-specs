// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// patcher.mjs — normalize an Azure DevOps OpenAPI 3 document so that
// `tsp-openapi3` can convert it and the result compiles under the
// TypeSpec compiler.
//
// Each patch below exists because a specific class of upstream defect
// was observed while converting the 7.2 specification set. The
// functions are exported individually so their effect can be tested
// in isolation.

const DOC_KEYS = new Set(["description", "summary", "title"]);

/**
 * Doc strings become TypeSpec doc comments and decorator string
 * literals. Embedded newlines and unescaped double quotes terminate
 * those literals early and crash the `tsp-openapi3` formatter with
 * `Unterminated string literal` / `',' expected`.
 *
 * Observed in: git/git.json, wit/workItemTracking.json (newlines) and
 * processes/workItemTrackingProcess.json (quotes inside `x-ms-enum`
 * value descriptions).
 */
export function sanitizeDocStrings(node) {
  if (Array.isArray(node)) {
    for (const item of node) sanitizeDocStrings(item);
    return;
  }
  if (!node || typeof node !== "object") return;
  for (const key of Object.keys(node)) {
    const value = node[key];
    if (DOC_KEYS.has(key) && typeof value === "string") {
      node[key] = value
        .replace(/\r?\n/g, " ")
        .replace(/\\/g, "")
        .replace(/"/g, "'")
        .replace(/\s+/g, " ")
        .trim();
    } else {
      sanitizeDocStrings(value);
    }
  }
}

/**
 * Root-level `tags` are converted into `@tagMetadata` decorators. Tag
 * descriptions that contain `externalDocs`-style prose produce
 * single-argument `@tagMetadata` calls (no longer a valid overload) and
 * unquoted identifiers such as `CI: Build`. None of the tag metadata
 * survives into the generated client, so it is dropped.
 */
export function stripRootTags(document) {
  delete document.tags;
}

/**
 * TypeSpec models spread their bases rather than overriding them, so an
 * `allOf` child that redeclares an inherited property fails with
 * `duplicate-property`.
 *
 * Observed in: core/core.json (`WebApiConnectedService.id`),
 * notification/notification.json (many `type` properties) and
 * wit/workItemTracking.json (`IdentityReference.id`).
 */
export function dedupeAllOfProperties(document) {
  const schemas = document.components?.schemas ?? {};
  const inheritedNames = (name, seen = new Set()) => {
    const names = new Set();
    if (seen.has(name)) return names;
    seen.add(name);
    const schema = schemas[name];
    if (!schema) return names;
    for (const part of schema.allOf ?? []) {
      const ref = part.$ref?.match(/^#\/components\/schemas\/(.+)$/);
      if (ref) {
        for (const p of Object.keys(schemas[ref[1]]?.properties ?? {})) names.add(p);
        for (const p of inheritedNames(ref[1], seen)) names.add(p);
      }
      for (const p of Object.keys(part.properties ?? {})) names.add(p);
    }
    return names;
  };

  let removed = 0;
  for (const [name, schema] of Object.entries(schemas)) {
    if (!schema?.allOf || !schema.properties) continue;
    const inherited = inheritedNames(name);
    for (const property of Object.keys(schema.properties)) {
      if (!inherited.has(property)) continue;
      delete schema.properties[property];
      if (Array.isArray(schema.required)) {
        schema.required = schema.required.filter((r) => r !== property);
        if (schema.required.length === 0) delete schema.required;
      }
      removed += 1;
    }
    if (Object.keys(schema.properties).length === 0) delete schema.properties;
  }
  return removed;
}

/**
 * Some route templates spell a path parameter with different casing
 * than the declared parameter, which TypeSpec rejects with
 * `missing-uri-param`.
 *
 * Observed in: build/build.json (`{DefinitionId}` vs `definitionId`).
 */
export function fixPathParameterCasing(document) {
  let fixed = 0;
  for (const [route, item] of Object.entries(document.paths ?? {})) {
    const declared = new Set();
    const collect = (parameters) => {
      for (const p of parameters ?? []) if (p?.in === "path" && p.name) declared.add(p.name);
    };
    collect(item.parameters);
    for (const method of ["get", "put", "post", "patch", "delete", "head", "options"]) {
      collect(item[method]?.parameters);
    }
    const patched = route.replace(/\{([^}]+)\}/g, (whole, token) => {
      if (declared.has(token)) return whole;
      const match = [...declared].find((name) => name.toLowerCase() === token.toLowerCase());
      if (!match) return whole;
      fixed += 1;
      return `{${match}}`;
    });
    if (patched !== route) {
      document.paths[patched] = item;
      delete document.paths[route];
    }
  }
  return fixed;
}

/** Applies every patch in order and returns a summary of what changed. */
export function patchDocument(document) {
  sanitizeDocStrings(document);
  stripRootTags(document);
  return {
    duplicateProperties: dedupeAllOfProperties(document),
    pathParameters: fixPathParameterCasing(document),
  };
}
