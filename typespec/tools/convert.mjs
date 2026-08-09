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
import { groupOperations } from "./group-operations.mjs";
import { normalizeParameters } from "./normalize-parameters.mjs";

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

/**
 * `tsp-openapi3` always emits `import "@typespec/openapi3";`, but none of
 * the Azure DevOps specs use an openapi3-only decorator (`@oneOf`,
 * `@useRef`) — `@extension` and friends come from `@typespec/openapi`.
 *
 * The import forces every downstream consumer to vendor `@typespec/openapi3`
 * purely to resolve a dependency nothing references, so it is dropped when
 * unused. `tsp compile` still gates the result, so a spec that genuinely
 * needs the library fails loudly rather than silently losing a decorator.
 */
function stripUnusedOpenApi3Import(source) {
  if (/@(oneOf|useRef)\b/.test(source)) return source;
  return source.replace(/^import "@typespec\/openapi3";\r?\n/m, "");
}

/**
 * Declares the service as versioned so the client generator treats the
 * ubiquitous `api-version` query parameter as client state instead of a
 * required argument on all 1086 operations.
 *
 * TCGC only name-matches `api-version` when the service carries a version
 * enum, so the enum is synthesized from the Swagger `info.version`
 * (`7.2-preview`). Azure DevOps documents finer-grained values per
 * operation (`7.2-preview.1`, `7.2-preview.2`, …), but the service accepts
 * the coarse version for every route — the same simplification
 * `azure-devops-rust-api` makes.
 */
function addServiceVersioning(source, version) {
  if (!version || /@versioned\(/.test(source)) return source;

  const member = `v${version.replace(/[^A-Za-z0-9]+/g, "_")}`;
  let text = source;

  if (!/^import "@typespec\/versioning";$/m.test(text)) {
    text = text.replace(/^(import "[^"]+";\r?\n)(?![\s\S]*^import )/m, `$1import "@typespec/versioning";\n`);
  }
  if (!/^using Versioning;$/m.test(text)) {
    text = text.replace(/^(using [^;]+;\r?\n)(?![\s\S]*^using )/m, `$1using Versioning;\n`);
  }

  const service = text.match(/^@service\b/m);
  if (!service) return source;
  text = `${text.slice(0, service.index)}@versioned(ServiceApiVersions)\n${text.slice(service.index)}`;

  const namespace = text.match(/^namespace [A-Za-z_][A-Za-z0-9_.]*;\r?\n/m);
  if (!namespace) return source;
  const insertAt = namespace.index + namespace[0].length;
  const declaration = `\nenum ServiceApiVersions {\n  ${member}: "${version}",\n}\n`;
  return text.slice(0, insertAt) + declaration + text.slice(insertAt);
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
  const normalized = normalizeParameters(
    addServiceVersioning(stripUnusedOpenApi3Import(emitted), document.info?.version),
  );
  const grouped = groupOperations(normalized.source);
  const rewritten = grouped.source;
  if (rewritten !== emitted) fs.writeFileSync(path.join(outDir, "main.tsp"), rewritten);
  if (previous !== null && previous !== rewritten) drift.push(`${area}/${name}`);

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
    interfaces: (rewritten.match(/^interface /gm) || []).length,
    renamedInterfaces: grouped.renames,
    renamedParameters: normalized.renames,
    lines: rewritten.split("\n").length,
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
