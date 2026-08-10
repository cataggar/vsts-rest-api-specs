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

/**
 * `operationId` becomes the TypeSpec operation name, and the Zig
 * emitter derives client/method identifiers from it. Azure DevOps
 * spells them with spaces (`Repositories_Get Deleted Repositories`),
 * which forces backtick-quoted TypeSpec identifiers and leaks into
 * generated code. Collapse each `_`-separated segment to PascalCase.
 *
 * Observed in 630 of 1086 operations across the 7.2 set.
 */
export function normalizeOperationIds(document) {
  const toPascal = (segment) =>
    segment
      .replace(/[^A-Za-z0-9]+(.)?/g, (_, next) => (next ? next.toUpperCase() : ""))
      .replace(/^(.)/, (first) => first.toUpperCase());

  let renamed = 0;
  for (const item of Object.values(document.paths ?? {})) {
    for (const method of ["get", "put", "post", "patch", "delete", "head", "options"]) {
      const operation = item[method];
      if (!operation?.operationId) continue;
      const next = operation.operationId.split("_").map(toPascal).join("_");
      if (next === operation.operationId) continue;
      operation.operationId = next;
      renamed += 1;
    }
  }
  return renamed;
}

/**
 * Azure DevOps pages long collections with a continuation token: the
 * service returns it in the `x-ms-continuationtoken` response header and
 * the caller passes it back as the `continuationToken` query parameter.
 * An absent header means the last page was reached.
 *
 * The header is part of the documented contract but only 4 of the 50
 * paged operations declare it, so a generator has nothing to surface and
 * the token is unreachable from generated code. The rule below restores
 * the declaration wherever the contract implies it.
 *
 * Three cases are deliberately left alone:
 *
 *  - Operations whose token is an integer (`artifacts`, `core`), which
 *    use a batch cursor rather than the header convention.
 *  - Operations that return the token as a response *body* field
 *    (`audit`, `memberEntitlementManagement`), which page off the body.
 *  - The success response of an operation that does not declare one.
 *
 * Declarations that already exist are kept but renamed to the canonical
 * spelling: upstream writes the same header as both
 * `x-ms-continuationtoken` (git) and `X-MS-ContinuationToken` (graph),
 * and while HTTP header lookup is case-insensitive, a generator derives
 * a *field name* from the spelling. Left alone, the two casings produce
 * two different field names for one header, which defeats any generic
 * pagination helper.
 *
 * Adding the header is safe even where the service omits it: a declared
 * response header is optional, so a missing one reads back as null and
 * terminates paging, which is exactly the end-of-collection signal.
 */
export function declareContinuationTokenHeader(document) {
  const CANONICAL = "x-ms-continuationtoken";

  const resolveRef = (ref, depth) => {
    if (typeof ref !== "string" || !ref.startsWith("#/") || depth > 8) return null;
    let node = document;
    for (const part of ref.slice(2).split("/")) node = node?.[part];
    return node ?? null;
  };

  const isString = (schema, depth = 0) => {
    if (!schema || depth > 8) return false;
    if (schema.$ref) return isString(resolveRef(schema.$ref, depth), depth + 1);
    return schema.type === "string";
  };

  const hasTokenProperty = (schema, depth = 0, seen = new Set()) => {
    if (!schema || depth > 6) return false;
    if (schema.$ref) {
      if (seen.has(schema.$ref)) return false;
      seen.add(schema.$ref);
      return hasTokenProperty(resolveRef(schema.$ref, depth), depth + 1, seen);
    }
    for (const key of Object.keys(schema.properties ?? {})) {
      if (key.toLowerCase() === "continuationtoken") return true;
    }
    for (const group of ["allOf", "anyOf", "oneOf"]) {
      for (const member of schema[group] ?? []) {
        if (hasTokenProperty(member, depth + 1, seen)) return true;
      }
    }
    return hasTokenProperty(schema.items, depth + 1, seen);
  };

  let declared = 0;
  let renamed = 0;
  for (const item of Object.values(document.paths ?? {})) {
    for (const method of ["get", "post"]) {
      const operation = item[method];
      if (!operation) continue;

      const token = [...(item.parameters ?? []), ...(operation.parameters ?? [])].find(
        (parameter) =>
          parameter?.in === "query" && parameter.name?.toLowerCase() === "continuationtoken",
      );
      if (!token || !isString(token.schema)) continue;

      const success = operation.responses?.["200"];
      if (!success) continue;

      const headers = success.headers ?? {};
      const existing = Object.keys(headers).find((name) => name.toLowerCase() === CANONICAL);
      if (existing) {
        if (existing !== CANONICAL) {
          headers[CANONICAL] = headers[existing];
          delete headers[existing];
          renamed += 1;
        }
        continue;
      }

      const bodies = Object.values(success.content ?? {});
      if (bodies.some((body) => hasTokenProperty(body.schema))) continue;

      headers[CANONICAL] = {
        description:
          "A continuation token for the next page of results. Absent on the last page. " +
          "Pass it back as the `continuationToken` query parameter.",
        schema: { type: "string" },
      };
      success.headers = headers;
      declared += 1;
    }
  }
  return { declared, renamed };
}

/**
 * Azure DevOps never returns a bare JSON array. Every collection comes
 * back wrapped in an envelope — `{"count": 2, "value": [ … ]}` — but the
 * Swagger declares the response as a plain array of the item type, so a
 * generated client tries to parse the envelope as an array and fails on
 * the very first list call.
 *
 * The service is the source of truth here, so the response schema is
 * replaced with a generated `<Item>List` object holding `count` and
 * `value`. `azure-devops-rust-api` patches its specs the same way, for
 * the same reason.
 *
 * `count` is intentionally optional: it is present on most collections
 * but absent from others (`_apis/teams`, `_apis/git/repositories`).
 *
 * Only arrays whose items are a `$ref` are wrapped. That is what makes a
 * stable envelope name available, and it confines the rule to the model
 * collections the convention actually covers rather than, say, an
 * operation returning a bare array of strings.
 */
export function wrapArrayResponses(document) {
  const schemas = (document.components ??= {}).schemas ??= {};

  let wrapped = 0;
  for (const item of Object.values(document.paths ?? {})) {
    for (const method of ["get", "put", "post", "patch", "delete", "head", "options"]) {
      const operation = item[method];
      if (!operation) continue;

      for (const response of Object.values(operation.responses ?? {})) {
        for (const body of Object.values(response.content ?? {})) {
          const schema = body.schema;
          if (schema?.type !== "array") continue;
          const ref = schema.items?.$ref;
          if (typeof ref !== "string") continue;

          const itemName = ref.slice(ref.lastIndexOf("/") + 1);
          const envelopeName = `${itemName}List`;
          const existing = schemas[envelopeName];
          if (existing && existing.properties?.value?.items?.$ref !== ref) continue;

          schemas[envelopeName] ??= {
            type: "object",
            description: `A collection of \`${itemName}\` as returned by Azure DevOps.`,
            properties: {
              count: { type: "integer", format: "int32" },
              value: { type: "array", items: { $ref: ref } },
            },
          };
          body.schema = { $ref: `#/components/schemas/${envelopeName}` };
          wrapped += 1;
        }
      }
    }
  }
  return wrapped;
}

/**
 * Azure DevOps returns string enum values its own specification does not
 * declare, and it adds new ones without republishing. Project visibility
 * is the documented case: the service answers `"organization"` where the
 * Swagger lists only `private` and `public`, so a client with a closed
 * enum fails to deserialize the project list.
 *
 * Rather than chase each gap as it surfaces — `azure-devops-rust-api`
 * patches that one enum by hand — every string enum in the model schemas
 * is made *extensible*, which is how Azure data-plane enums are normally
 * modelled anyway. `anyOf: [ <the enum>, { type: "string" } ]` is the
 * shape `tsp-openapi3` converts into `"a" | "b" | string`; the compiler
 * treats that as an extensible enum, and unknown values round-trip
 * instead of being rejected.
 *
 * Scoped to `components.schemas`, so request parameters keep their
 * closed enums: those are supplied by the caller, not the service, and a
 * fixed set is both correct and easier to pass.
 */
export function makeEnumsExtensible(document) {
  let widened = 0;

  // Upstream frequently omits `type` next to `enum`, so the value kind
  // is what decides, not the declared type.
  const isStringEnum = (schema) =>
    (schema.type === undefined || schema.type === "string") &&
    Array.isArray(schema.enum) &&
    schema.enum.length > 0 &&
    schema.enum.every((value) => typeof value === "string");

  const visit = (node) => {
    if (Array.isArray(node)) {
      for (const item of node) visit(item);
      return;
    }
    if (!node || typeof node !== "object") return;

    for (const key of Object.keys(node)) {
      const value = node[key];
      if (value && typeof value === "object" && !Array.isArray(value) && isStringEnum(value)) {
        // Documentation and Autorest metadata stay on the property.
        // Left on the union arm they would render as a decorator in a
        // position TypeSpec does not accept.
        const { description, "x-ms-enum": msEnum, enum: values, type, ...rest } = value;
        node[key] = {
          ...rest,
          ...(description === undefined ? {} : { description }),
          ...(msEnum === undefined ? {} : { "x-ms-enum": msEnum }),
          anyOf: [{ type: "string", enum: values }, { type: "string" }],
        };
        widened += 1;
        continue;
      }
      visit(value);
    }
  };

  visit(document.components?.schemas ?? {});
  return widened;
}

/** Applies every patch in order and returns a summary of what changed. */
export function patchDocument(document) {
  sanitizeDocStrings(document);
  stripRootTags(document);
  const arrayResponses = wrapArrayResponses(document);
  const continuation = declareContinuationTokenHeader(document);
  const extensibleEnums = makeEnumsExtensible(document);
  return {
    duplicateProperties: dedupeAllOfProperties(document),
    pathParameters: fixPathParameterCasing(document),
    operationIds: normalizeOperationIds(document),
    arrayResponses,
    extensibleEnums,
    continuationTokenHeaders: continuation.declared,
    renamedContinuationTokenHeaders: continuation.renamed,
  };
}
