import assert from "node:assert/strict";
import { test } from "node:test";
import { normalizeParameters, toIdentifier } from "./normalize-parameters.mjs";

test("toIdentifier camel-cases dotted and dashed wire names", () => {
  assert.equal(toIdentifier("searchCriteria.creatorId"), "searchCriteriaCreatorId");
  assert.equal(toIdentifier("api-version"), "apiVersion");
  assert.equal(toIdentifier("$top"), "top");
  assert.equal(toIdentifier("project"), "project");
});

test("normalizeParameters moves the wire name into the decorator", () => {
  const source = [
    "interface Commits {",
    "  List(",
    "    @query(#{ explode: true }) `searchCriteria.creatorId`?: string,",
    "    @query `api-version`: string,",
    "  ): void;",
    "}",
  ].join("\n");

  const { source: result, renames } = normalizeParameters(source);
  assert.ok(result.includes('@query(#{ name: "searchCriteria.creatorId", explode: true }) searchCriteriaCreatorId?'));
  assert.ok(result.includes('@query(#{ name: "api-version" }) apiVersion: string'));
  assert.deepEqual(renames, {
    "searchCriteria.creatorId": "searchCriteriaCreatorId",
    "api-version": "apiVersion",
  });
});

test("normalizeParameters leaves already-legal identifiers alone", () => {
  const source = "  @query(#{ explode: true }) project?: string,\n";
  assert.equal(normalizeParameters(source).source, source);
});

test("normalizeParameters does not touch model properties", () => {
  const source = "model M {\n  `odd.name`?: string;\n}\n";
  assert.equal(normalizeParameters(source).source, source);
});
