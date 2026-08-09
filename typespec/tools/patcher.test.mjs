import assert from "node:assert/strict";
import { test } from "node:test";
import {
  declareContinuationTokenHeader,
  dedupeAllOfProperties,
  fixPathParameterCasing,
  normalizeOperationIds,
  sanitizeDocStrings,
  stripRootTags,
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
  assert.equal(declareContinuationTokenHeader(doc), 1);
  const header = doc.paths["/builds"].get.responses[200].headers["x-ms-continuationtoken"];
  assert.deepEqual(header.schema, { type: "string" });
  assert.match(header.description, /continuationToken/);
});

test("declareContinuationTokenHeader honours a path-level token parameter", () => {
  const operation = pagedOperation();
  const doc = { paths: { "/builds": { parameters: operation.parameters, get: { responses: operation.responses } } } };
  assert.equal(declareContinuationTokenHeader(doc), 1);
});

test("declareContinuationTokenHeader is idempotent and casing-insensitive", () => {
  const doc = {
    paths: {
      "/refs": { get: pagedOperation({ headers: { "X-MS-ContinuationToken": { schema: { type: "string" } } } }) },
    },
  };
  assert.equal(declareContinuationTokenHeader(doc), 0);
  assert.deepEqual(Object.keys(doc.paths["/refs"].get.responses[200].headers), ["X-MS-ContinuationToken"]);

  const fresh = { paths: { "/builds": { get: pagedOperation() } } };
  assert.equal(declareContinuationTokenHeader(fresh), 1);
  assert.equal(declareContinuationTokenHeader(fresh), 0);
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
  assert.equal(declareContinuationTokenHeader(doc), 0);
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
  assert.equal(declareContinuationTokenHeader(doc), 0);
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
  assert.equal(declareContinuationTokenHeader(doc), 1);
});

test("declareContinuationTokenHeader ignores operations without the token parameter", () => {
  const doc = { paths: { "/projects": { get: { parameters: [], responses: { 200: {} } } } } };
  assert.equal(declareContinuationTokenHeader(doc), 0);
});