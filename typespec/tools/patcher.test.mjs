import assert from "node:assert/strict";
import { test } from "node:test";
import {
  declareContinuationTokenHeader,
  dedupeAllOfProperties,
  fixPathParameterCasing,
  makeEnumsExtensible,
  normalizeOperationIds,
  sanitizeDocStrings,
  stripRootTags,
  wrapArrayResponses,
} from "./patcher.mjs";

test("sanitizeDocStrings collapses newlines and escapes quotes", () => {
  const doc = {
    components: {
      schemas: {
        Rule: {
          description: 'cherry pick into a new branch\nor commits that are\r\nassociated',
          properties: {
            actionType: {
              "x-ms-enum": {
                values: [{ description: 'Example : {"actionType":"$copyValue"}' }],
              },
            },
          },
        },
      },
    },
  };
  sanitizeDocStrings(doc);
  const schema = doc.components.schemas.Rule;
  assert.equal(schema.description, "cherry pick into a new branch or commits that are associated");
  assert.equal(
    schema.properties.actionType["x-ms-enum"].values[0].description,
    "Example : {'actionType':'$copyValue'}",
  );
});

test("stripRootTags removes only root tags", () => {
  const doc = { tags: [{ name: "Forks" }], paths: { "/a": { get: { tags: ["Forks"] } } } };
  stripRootTags(doc);
  assert.equal(doc.tags, undefined);
  assert.deepEqual(doc.paths["/a"].get.tags, ["Forks"]);
});

test("dedupeAllOfProperties drops redeclared inherited properties", () => {
  const doc = {
    components: {
      schemas: {
        Base: { properties: { id: { type: "string" } } },
        Derived: {
          allOf: [{ $ref: "#/components/schemas/Base" }],
          properties: { id: { type: "string" }, name: { type: "string" } },
          required: ["id", "name"],
        },
      },
    },
  };
  assert.equal(dedupeAllOfProperties(doc), 1);
  const derived = doc.components.schemas.Derived;
  assert.deepEqual(Object.keys(derived.properties), ["name"]);
  assert.deepEqual(derived.required, ["name"]);
});

test("dedupeAllOfProperties tolerates cyclic allOf references", () => {
  const doc = {
    components: {
      schemas: {
        A: { allOf: [{ $ref: "#/components/schemas/B" }], properties: { x: {} } },
        B: { allOf: [{ $ref: "#/components/schemas/A" }], properties: { x: {} } },
      },
    },
  };
  assert.doesNotThrow(() => dedupeAllOfProperties(doc));
});

test("fixPathParameterCasing rewrites route tokens to the declared name", () => {
  const doc = {
    paths: {
      "/build/definitions/{DefinitionId}/metrics": {
        get: { parameters: [{ in: "path", name: "definitionId" }] },
      },
    },
  };
  assert.equal(fixPathParameterCasing(doc), 1);
  assert.ok(doc.paths["/build/definitions/{definitionId}/metrics"]);
  assert.equal(doc.paths["/build/definitions/{DefinitionId}/metrics"], undefined);
});

test("fixPathParameterCasing leaves unknown tokens alone", () => {
  const doc = { paths: { "/a/{unknown}": { get: { parameters: [] } } } };
  assert.equal(fixPathParameterCasing(doc), 0);
  assert.ok(doc.paths["/a/{unknown}"]);
});

test("normalizeOperationIds collapses spaces to PascalCase per segment", () => {
  const doc = {
    paths: {
      "/a": {
        get: { operationId: "Repositories_Get Deleted Repositories" },
        post: { operationId: "Refs Favorites_Create" },
      },
      "/b": { get: { operationId: "Repositories_List" } },
    },
  };
  assert.equal(normalizeOperationIds(doc), 2);
  assert.equal(doc.paths["/a"].get.operationId, "Repositories_GetDeletedRepositories");
  assert.equal(doc.paths["/a"].post.operationId, "RefsFavorites_Create");
  assert.equal(doc.paths["/b"].get.operationId, "Repositories_List");
});

const pagedOperation = (extra = {}) => ({
  parameters: [{ name: "continuationToken", in: "query", schema: { type: "string" } }],
  responses: {
    200: {
      content: { "application/json": { schema: { type: "array", items: { type: "string" } } } },
      ...extra,
    },
  },
});

test("declareContinuationTokenHeader declares the header on paged operations", () => {
  const doc = { paths: { "/builds": { get: pagedOperation() } } };
  assert.equal(declareContinuationTokenHeader(doc).declared, 1);
  const header = doc.paths["/builds"].get.responses[200].headers["x-ms-continuationtoken"];
  assert.deepEqual(header.schema, { type: "string" });
  assert.match(header.description, /continuationToken/);
});

test("declareContinuationTokenHeader honours a path-level token parameter", () => {
  const operation = pagedOperation();
  const doc = { paths: { "/builds": { parameters: operation.parameters, get: { responses: operation.responses } } } };
  assert.equal(declareContinuationTokenHeader(doc).declared, 1);
});

test("declareContinuationTokenHeader canonicalises an existing header spelling", () => {
  const doc = {
    paths: {
      "/refs": {
        get: pagedOperation({
          headers: { "X-MS-ContinuationToken": { schema: { type: "string" } } },
        }),
      },
    },
  };
  const result = declareContinuationTokenHeader(doc);
  assert.deepEqual(result, { declared: 0, renamed: 1 });
  assert.deepEqual(Object.keys(doc.paths["/refs"].get.responses[200].headers), [
    "x-ms-continuationtoken",
  ]);
});

test("declareContinuationTokenHeader is idempotent", () => {
  const fresh = { paths: { "/builds": { get: pagedOperation() } } };
  assert.equal(declareContinuationTokenHeader(fresh).declared, 1);
  assert.deepEqual(declareContinuationTokenHeader(fresh), { declared: 0, renamed: 0 });
});

test("declareContinuationTokenHeader skips integer batch cursors", () => {
  const doc = {
    paths: {
      "/feeds": {
        get: {
          parameters: [{ name: "continuationToken", in: "query", schema: { type: "integer", format: "int64" } }],
          responses: { 200: { content: { "application/json": { schema: { type: "array" } } } } },
        },
      },
    },
  };
  assert.equal(declareContinuationTokenHeader(doc).declared, 0);
  assert.equal(doc.paths["/feeds"].get.responses[200].headers, undefined);
});

test("declareContinuationTokenHeader skips operations paging off the body", () => {
  const doc = {
    components: {
      schemas: {
        AuditLogQueryResult: {
          properties: { continuationToken: { type: "string" }, hasMore: { type: "boolean" } },
        },
      },
    },
    paths: {
      "/auditlog": {
        get: {
          parameters: [{ name: "continuationToken", in: "query", schema: { type: "string" } }],
          responses: {
            200: {
              content: {
                "application/json": {
                  schema: { $ref: "#/components/schemas/AuditLogQueryResult" },
                },
              },
            },
          },
        },
      },
    },
  };
  assert.equal(declareContinuationTokenHeader(doc).declared, 0);
});

test("declareContinuationTokenHeader resolves a referenced token parameter schema", () => {
  const doc = {
    components: { schemas: { Token: { type: "string" } } },
    paths: {
      "/alerts": {
        get: {
          parameters: [
            { name: "continuationToken", in: "query", schema: { $ref: "#/components/schemas/Token" } },
          ],
          responses: { 200: { content: { "application/json": { schema: { type: "array" } } } } },
        },
      },
    },
  };
  assert.equal(declareContinuationTokenHeader(doc).declared, 1);
});

test("declareContinuationTokenHeader ignores operations without the token parameter", () => {
  const doc = { paths: { "/projects": { get: { parameters: [], responses: { 200: {} } } } } };
  assert.equal(declareContinuationTokenHeader(doc).declared, 0);
});
const arrayResponse = (ref) => ({
  responses: { 200: { content: { "application/json": { schema: { type: "array", items: { $ref: ref } } } } } },
});

test("wrapArrayResponses replaces an array response with a count/value envelope", () => {
  const doc = {
    components: { schemas: { TeamProjectReference: { type: "object" } } },
    paths: { "/projects": { get: arrayResponse("#/components/schemas/TeamProjectReference") } },
  };
  assert.equal(wrapArrayResponses(doc), 1);
  assert.deepEqual(doc.paths["/projects"].get.responses[200].content["application/json"].schema, {
    $ref: "#/components/schemas/TeamProjectReferenceList",
  });
  const envelope = doc.components.schemas.TeamProjectReferenceList;
  assert.equal(envelope.type, "object");
  assert.deepEqual(envelope.properties.count, { type: "integer", format: "int32" });
  assert.deepEqual(envelope.properties.value, {
    type: "array",
    items: { $ref: "#/components/schemas/TeamProjectReference" },
  });
  // `count` is absent from some collections, so nothing may be required.
  assert.equal(envelope.required, undefined);
});

test("wrapArrayResponses reuses one envelope across operations", () => {
  const ref = "#/components/schemas/GitRepository";
  const doc = {
    components: { schemas: { GitRepository: { type: "object" } } },
    paths: {
      "/repos": { get: arrayResponse(ref) },
      "/repos/recycle": { get: arrayResponse(ref) },
    },
  };
  assert.equal(wrapArrayResponses(doc), 2);
  assert.equal(Object.keys(doc.components.schemas).length, 2);
});

test("wrapArrayResponses leaves arrays of primitives alone", () => {
  const doc = {
    paths: {
      "/names": {
        get: { responses: { 200: { content: { "application/json": { schema: { type: "array", items: { type: "string" } } } } } } },
      },
    },
  };
  assert.equal(wrapArrayResponses(doc), 0);
  assert.deepEqual(doc.paths["/names"].get.responses[200].content["application/json"].schema, {
    type: "array",
    items: { type: "string" },
  });
});

test("wrapArrayResponses leaves non-array responses alone", () => {
  const doc = {
    paths: {
      "/one": {
        get: { responses: { 200: { content: { "application/json": { schema: { $ref: "#/components/schemas/Project" } } } } } },
      },
    },
  };
  assert.equal(wrapArrayResponses(doc), 0);
});

test("wrapArrayResponses does not clobber a conflicting existing envelope", () => {
  const conflicting = { type: "object", properties: { value: { type: "array", items: { $ref: "#/components/schemas/Other" } } } };
  const doc = {
    components: { schemas: { Build: { type: "object" }, BuildList: conflicting } },
    paths: { "/builds": { get: arrayResponse("#/components/schemas/Build") } },
  };
  assert.equal(wrapArrayResponses(doc), 0);
  assert.equal(doc.components.schemas.BuildList, conflicting);
  assert.equal(doc.paths["/builds"].get.responses[200].content["application/json"].schema.type, "array");
});
test("makeEnumsExtensible widens a string enum into an open union", () => {
  const doc = {
    components: {
      schemas: {
        TeamProjectReference: {
          type: "object",
          properties: {
            visibility: {
              type: "string",
              description: "Project visibility.",
              enum: ["private", "public"],
            },
          },
        },
      },
    },
  };
  assert.equal(makeEnumsExtensible(doc), 1);
  assert.deepEqual(doc.components.schemas.TeamProjectReference.properties.visibility, {
    description: "Project visibility.",
    anyOf: [{ type: "string", enum: ["private", "public"] }, { type: "string" }],
  });
});

test("makeEnumsExtensible leaves non-string enums alone", () => {
  const doc = {
    components: { schemas: { A: { type: "object", properties: { n: { type: "integer", enum: [1, 2] } } } } },
  };
  assert.equal(makeEnumsExtensible(doc), 0);
  assert.deepEqual(doc.components.schemas.A.properties.n, { type: "integer", enum: [1, 2] });
});

test("makeEnumsExtensible leaves request parameters alone", () => {
  const doc = {
    components: { schemas: {} },
    paths: {
      "/builds": {
        get: { parameters: [{ in: "query", name: "order", schema: { type: "string", enum: ["asc", "desc"] } }] },
      },
    },
  };
  assert.equal(makeEnumsExtensible(doc), 0);
  assert.deepEqual(doc.paths["/builds"].get.parameters[0].schema, { type: "string", enum: ["asc", "desc"] });
});

test("makeEnumsExtensible reaches enums nested in arrays and sub-schemas", () => {
  const doc = {
    components: {
      schemas: {
        A: {
          type: "object",
          properties: {
            states: { type: "array", items: { type: "string", enum: ["new", "done"] } },
          },
        },
      },
    },
  };
  assert.equal(makeEnumsExtensible(doc), 1);
  assert.deepEqual(doc.components.schemas.A.properties.states.items, {
    anyOf: [{ type: "string", enum: ["new", "done"] }, { type: "string" }],
  });
});

test("makeEnumsExtensible is idempotent", () => {
  const doc = {
    components: { schemas: { A: { type: "object", properties: { v: { type: "string", enum: ["x"] } } } } },
  };
  assert.equal(makeEnumsExtensible(doc), 1);
  assert.equal(makeEnumsExtensible(doc), 0);
});

test("makeEnumsExtensible widens an enum that omits its type, as upstream writes them", () => {
  const doc = {
    components: {
      schemas: {
        TeamProjectReference: {
          type: "object",
          properties: {
            visibility: {
              description: "Indicates whom the project is visible to.",
              enum: ["private", "public"],
              "x-ms-enum": { name: "ProjectVisibility" },
            },
          },
        },
      },
    },
  };
  assert.equal(makeEnumsExtensible(doc), 1);
  assert.deepEqual(doc.components.schemas.TeamProjectReference.properties.visibility, {
    description: "Indicates whom the project is visible to.",
    "x-ms-enum": { name: "ProjectVisibility" },
    anyOf: [{ type: "string", enum: ["private", "public"] }, { type: "string" }],
  });
});
