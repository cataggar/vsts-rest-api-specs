import assert from "node:assert/strict";
import { test } from "node:test";
import { groupOperations, scanTopLevel } from "./group-operations.mjs";

test("scanTopLevel ignores braces and semicolons inside comments and strings", () => {
  const source = [
    '@doc("a } string ; here")',
    "model A {",
    "  /** a } doc ; comment */",
    "  x: string;",
    "}",
    "op B_C(): void;",
  ].join("\n");
  const ranges = scanTopLevel(source);
  const texts = ranges.map(([s, e]) => source.slice(s, e));
  assert.equal(texts.length, 2);
  assert.ok(texts[0].startsWith("@doc"));
  assert.ok(texts[0].endsWith("}"));
  assert.equal(texts[1], "op B_C(): void;");
});

test("scanTopLevel ends an op at its semicolon, not at an inline model brace", () => {
  const source = [
    "op A_B(): {",
    '  @header contentType: "application/octet-stream";',
    "  @body body: Blob;",
    "} | BlobRef;",
    "",
    "model M {",
    "  x: string;",
    "}",
  ].join("\n");
  const texts = scanTopLevel(source).map(([s, e]) => source.slice(s, e));
  assert.equal(texts.length, 2);
  assert.ok(texts[0].startsWith("op A_B"));
  assert.ok(texts[0].endsWith("| BlobRef;"));
  assert.ok(texts[1].startsWith("model M"));
});

test("scanTopLevel recovers after a decorator nested inside a model body", () => {
  const source = ["model A {", '  @format("uuid") id?: string;', "}", "", "model B {", "  x: string;", "}"].join("\n");
  const texts = scanTopLevel(source).map(([s, e]) => source.slice(s, e));
  assert.equal(texts.length, 2);
  assert.ok(texts[1].startsWith("model B"));
});

test("groupOperations moves prefixed ops into interfaces and keeps decorators", () => {
  const source = [
    "namespace Git;",
    "",
    "model Repo {",
    "  id: string;",
    "}",
    "",
    '@route("/repos")',
    "@get",
    "op Repositories_List(): Repo[];",
    "",
    '@route("/repos/{id}")',
    "@get",
    "op Repositories_Get(@path id: string): Repo;",
    "",
    '@route("/refs")',
    "@get",
    "op Refs_List(): string[];",
  ].join("\n");

  const result = groupOperations(source).source;
  assert.ok(result.includes("interface Repositories {"));
  assert.ok(result.includes("interface Refs {"));
  assert.ok(/interface Repositories \{[\s\S]*List\(\): Repo\[\];/.test(result));
  assert.ok(/interface Repositories \{[\s\S]*Get\(@path id: string\): Repo;/.test(result));
  assert.ok(result.includes('@route("/repos")'));
  // The model and namespace survive outside any interface.
  assert.ok(result.includes("namespace Git;"));
  assert.ok(/model Repo \{/.test(result));
  // No flat op declarations remain.
  assert.equal(/(^|\n)op\s/.test(result), false);
});

test("groupOperations suffixes an interface that collides with a model name", () => {
  const source = ["namespace B;", "", "model Timeline {", "  id: string;", "}", "", "op Timeline_Get(): Timeline;"].join(
    "\n",
  );
  const { source: result, renames } = groupOperations(source);
  assert.deepEqual(renames, { Timeline: "TimelineOperations" });
  assert.ok(result.includes("interface TimelineOperations {"));
  assert.ok(result.includes("model Timeline {"));
});

test("groupOperations leaves un-prefixed operations alone", () => {
  const source = "namespace X;\n\nop Ping(): void;\n";
  assert.equal(groupOperations(source).source, source);
});

test("groupOperations does not treat 'op' inside a doc comment as a declaration", () => {
  const source = ["namespace X;", "", "/** describes an op Foo_Bar thing */", "model M {", "  a: string;", "}"].join("\n");
  assert.equal(groupOperations(source).source, source);
});
