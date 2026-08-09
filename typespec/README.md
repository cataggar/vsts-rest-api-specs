# Azure DevOps TypeSpec

Generated TypeSpec for the Azure DevOps REST API, converted from the
Swagger 2.0 documents under [`specification/`](../specification).

This branch is `typespec`. It tracks `master` — which is the mirror of
upstream [`MicrosoftDocs/vsts-rest-api-specs`](https://github.com/MicrosoftDocs/vsts-rest-api-specs) —
and adds the `typespec/` directory on top. Merge `master` into `typespec`
to pick up new upstream Swagger, then re-run the conversion.

Consumed by the `rest/devops` package branch of
[`azure-sdk-for-zig`](https://github.com/cataggar/azure-sdk-for-zig),
whose generator front-end is
[TCGC](https://github.com/Azure/typespec-azure/tree/main/packages/typespec-client-generator-core).

## Scope

Only the latest API version is converted. It is pinned in
[`config.json`](config.json):

```json
{ "apiVersion": "7.2" }
```

Areas without a directory for that version are skipped, as are the
entries listed in `exclude`. Older versions and the
`azure-devops-server-*` / `tfs-*` on-premises variants are out of scope.

## Layout

| Path                     | Contents                                                                 |
| ------------------------ | ------------------------------------------------------------------------ |
| `config.json`            | Pinned API version and per-spec exclusions.                              |
| `tools/patcher.mjs`      | OpenAPI 3 patches that work around defects in the upstream Swagger.      |
| `tools/patcher.test.mjs` | Unit tests, one per patch.                                               |
| `tools/convert.mjs`      | Conversion driver.                                                       |
| `specs/<area>/<name>/`   | Generated `main.tsp`. Do not edit by hand.                               |
| `specs/manifest.json`    | Machine-readable index: area, source Swagger, output path, patch counts. |
| `.openapi3/`             | Untracked intermediate OpenAPI 3 documents, kept for debugging.          |

## Pipeline

```text
specification/<area>/7.2/<name>.json     Swagger 2.0 (upstream)
   │
   │  swagger2openapi --patch
   ▼
.openapi3/<area>/<name>.json             OpenAPI 3.0
   │
   │  tools/patcher.mjs
   ▼
.openapi3/<area>/<name>.json             OpenAPI 3.0, patched
   │
   │  tsp-openapi3
   ▼
specs/<area>/<name>/main.tsp             TypeSpec
   │
   │  tsp compile --no-emit               (gate: must be diagnostic-free)
   ▼
   consumed by azure-sdk-for-zig codegen (TCGC → Zig)
```

## Usage

```bash
cd typespec
npm install

npm run convert            # every area
npm run convert -- git     # one area
npm run check              # fail if tracked output is stale
npm test                   # patcher unit tests
```

`convert` fails if any spec cannot be converted or if the resulting
TypeSpec does not compile cleanly, so a green run means every tracked
`main.tsp` is valid TypeSpec.

## Patches

The upstream Swagger has defects that block conversion. Rather than
editing generated TypeSpec, each defect is fixed on the intermediate
OpenAPI 3 document by a named function in `tools/patcher.mjs`.

| Patch                     | Upstream defect                                                                 | Symptom                                                                  |
| ------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `sanitizeDocStrings`      | `description` / `summary` / `title` contain raw newlines and unescaped `"`.        | `tsp-openapi3` crashes: `Unterminated string literal`, `',' expected`.   |
| `stripRootTags`           | Root `tags` carry prose that converts to invalid `@tagMetadata` calls.             | `invalid-argument-count`, `invalid-ref: Unknown identifier Build`.       |
| `dedupeAllOfProperties`   | `allOf` children redeclare a property already defined by their base.               | `duplicate-property`.                                                     |
| `fixPathParameterCasing`  | Route templates spell a path parameter with different casing than the declaration. | `@typespec/http/missing-uri-param`.                                       |
| `normalizeOperationIds`   | `operationId` contains spaces (`Repositories_Get Deleted Repositories`).           | Backtick-quoted TypeSpec identifiers that leak into generated client code. |

`swagger2openapi --patch` additionally repairs non-body parameters that
omit `type` (`tfvc/tfvc.json`).

Add a patch by exporting a new function from `tools/patcher.mjs`, calling
it from `patchDocument`, and covering it in `tools/patcher.test.mjs`. Do
not hand-edit anything under `specs/`; it is overwritten on every run.

## Refreshing from upstream

```bash
git checkout typespec
git merge master
cd typespec && npm run convert
git add specs && git commit -m "Regenerate TypeSpec from <upstream commit>"
```

Review the `specs/` diff the same way a generated-code diff is reviewed:
new or removed operations and models are the signal; formatting churn is
not.
