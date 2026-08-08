// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// convert.mjs — regenerate `typespec/specs/**` from the Swagger 2.0
// documents under `specification/<area>/<version>/`.
//
// Pipeline:
//
//   specification/<area>/<version>/<name>.json   (Swagger 2.0)
//        │  swagger2openapi --patch
//        ▼
//   .openapi3/<area>/<name>.json                 (OpenAPI 3.0, untracked)
//        │  tools/patcher.mjs
//        ▼
//   .openapi3/<area>/<name>.json                 (patched in place)
//        │  tsp-openapi3
//        ▼
//   specs/<area>/<name>/main.tsp                 (TypeSpec, tracked)
//
// Usage:
//
//   npm run convert                 # every area at the pinned version
//   npm run convert -- git build    # only the named areas
//   npm run convert -- --check      # fail if any output would change

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { execFileSync } from "node:child_process";
import { patchDocument } from "./patcher.mjs";

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, "..");
const repo = path.resolve(root, "..");

const config = JSON.parse(fs.readFileSync(path.join(root, "config.json"), "utf8"));
const { apiVersion, exclude } = config;

const specificationRoot = path.join(repo, "specification");
const openapi3Root = path.join(root, ".openapi3");
const specsRoot = path.join(root, "specs");

const args = process.argv.slice(2);
const check = args.includes("--check");
const selected = args.filter((a) => !a.startsWith("--"));

function run(command, commandArgs) {
  return execFileSync(command, commandArgs, {
    stdio: ["ignore", "pipe", "pipe"],
    encoding: "utf8",
    shell: process.platform === "win32",
  });
}

function discover() {
  const found = [];
  for (const area of fs.readdirSync(specificationRoot).sort()) {
    if (selected.length && !selected.includes(area)) continue;
    const versionDir = path.join(specificationRoot, area, apiVersion);
    if (!fs.existsSync(versionDir)) continue;
    for (const file of fs.readdirSync(versionDir).sort()) {
      if (!file.endsWith(".json")) continue;
      const name = file.replace(/\.json$/, "");
      if (exclude.includes(`${area}/${name}`)) continue;
      found.push({ area, name, source: path.join(versionDir, file) });
    }
  }
  return found;
}

const specs = discover();
if (specs.length === 0) {
  console.error(`no specs found for version ${apiVersion}`);
  process.exit(1);
}

const failures = [];
const drift = [];
const manifest = [];

for (const { area, name, source } of specs) {
  const openapi3 = path.join(openapi3Root, area, `${name}.json`);
  const outDir = path.join(specsRoot, area, name);
  fs.mkdirSync(path.dirname(openapi3), { recursive: true });

  try {
    run("npx", ["swagger2openapi", "--patch", source, "-o", openapi3]);
  } catch (error) {
    failures.push({ id: `${area}/${name}`, stage: "swagger2openapi", error: String(error.stderr || error.message) });
    continue;
  }

  const document = JSON.parse(fs.readFileSync(openapi3, "utf8"));
  const patched = patchDocument(document);
  fs.writeFileSync(openapi3, `${JSON.stringify(document, null, 2)}\n`);

  const previous = fs.existsSync(path.join(outDir, "main.tsp"))
    ? fs.readFileSync(path.join(outDir, "main.tsp"), "utf8")
    : null;
  fs.rmSync(outDir, { recursive: true, force: true });

  try {
    run("npx", ["tsp-openapi3", openapi3, "--output-dir", outDir]);
  } catch (error) {
    failures.push({ id: `${area}/${name}`, stage: "tsp-openapi3", error: String(error.stdout || error.stderr || error.message) });
    continue;
  }

  const emitted = fs.readFileSync(path.join(outDir, "main.tsp"), "utf8");
  if (previous !== null && previous !== emitted) drift.push(`${area}/${name}`);

  try {
    run("npx", ["tsp", "compile", path.join(outDir, "main.tsp"), "--no-emit"]);
  } catch (error) {
    const text = String(error.stdout || "") + String(error.stderr || "");
    const codes = [...new Set([...text.matchAll(/error ([\w@/-]+):/g)].map((m) => m[1]))];
    failures.push({ id: `${area}/${name}`, stage: "tsp compile", error: codes.join(", ") });
    continue;
  }

  manifest.push({
    area,
    name,
    swagger: path.relative(repo, source).replace(/\\/g, "/"),
    typespec: path.relative(repo, outDir).replace(/\\/g, "/"),
    patched,
    lines: emitted.split("\n").length,
  });
  console.log(`ok   ${area}/${name}`);
}

fs.writeFileSync(
  path.join(root, "specs", "manifest.json"),
  `${JSON.stringify({ apiVersion, generator: "typespec/tools/convert.mjs", specs: manifest }, null, 2)}\n`,
);

for (const failure of failures) console.error(`FAIL ${failure.id} [${failure.stage}] ${failure.error.slice(0, 200)}`);
console.log(`\n${manifest.length}/${specs.length} specs converted and compiled`);

if (failures.length) process.exit(1);
if (check && drift.length) {
  console.error(`\ncheck failed; regenerate:\n  ${drift.join("\n  ")}`);
  process.exit(1);
}
