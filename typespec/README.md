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
| `tools/group-operations.mjs`   | Rewrites flat operations into TypeSpec interfaces.                 |
| `tools/normalize-parameters.mjs` | Gives query parameters legal identifiers.                        |
| `tools/*.test.mjs`       | Unit tests for each transform.                                           |
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
   TypeSpec, flat
   │
   │  tools/convert.mjs post-processing:
   │    · drop the unused `@typespec/openapi3` import
   │    · declare the service `@versioned`
   │    · tools/normalize-parameters.mjs
   │    · tools/group-operations.mjs
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

## Post-processing

`tsp-openapi3` produces a faithful but unidiomatic translation. Four
transforms in `tools/convert.mjs` turn it into TypeSpec that a client
generator can consume directly. Each is gated by `tsp compile`, so a
transform that breaks a spec fails the run rather than shipping.

### Drop the unused `@typespec/openapi3` import

No Azure DevOps spec uses an openapi3-only decorator (`@oneOf`,
`@useRef`) — `@extension` and friends come from `@typespec/openapi`. The
import would otherwise force every consumer to vendor a library nothing
references.

### Declare the service `@versioned`

`api-version` is a required query parameter on all 1086 operations. The
client generator only recognises it as client state when the service
carries a version enum, so one is synthesized from the Swagger
`info.version`:

```tsp
@versioned(ServiceApiVersions)
@service(#{ title: "Git" })
namespace Git;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}
```

Azure DevOps documents finer-grained values per operation
(`7.2-preview.1`, `7.2-preview.2`, …) but accepts the coarse version on
every route — the same simplification
[`azure-devops-rust-api`](https://github.com/microsoft/azure-devops-rust-api)
makes. The result is `api-version` as a client field with a default
instead of an argument on every call.

### `tools/normalize-parameters.mjs`

Azure DevOps flattens nested search objects onto the query string, which
forces back-tick identifiers. The wire name moves into the decorator so
the parameter has a name a generator can spell:

```tsp
// before
@query(#{ explode: true }) `searchCriteria.creatorId`?: string;

// after
@query(#{ name: "searchCriteria.creatorId", explode: true })
searchCriteriaCreatorId?: string;
```

95 distinct parameters are renamed. The request is byte-for-byte
unchanged.

### `tools/group-operations.mjs`

Every `operationId` is spelled `Group_Operation`, but `tsp-openapi3`
emits a flat list, which yields a single client with 108 methods named
`repositories_GetDeletedRepositories`. Grouping them into interfaces
produces one operation group per `Group`:

```tsp
// before
@route("/{organization}/{project}/_apis/git/repositories")
@get
op Repositories_List(...): GitRepository[];

// after
interface Repositories {
  @route("/{organization}/{project}/_apis/git/repositories")
  @get
  List(...): GitRepository[];
}
```

All 1086 operations group cleanly into 371 interfaces with no member
collisions. Where Azure DevOps reuses a name for both a model and its
operation group (`model Timeline` alongside `Timeline_Get`), the
interface is suffixed with `Operations` to avoid a duplicate symbol; the
eight such renames are recorded in `specs/manifest.json` under
`renamedInterfaces`.

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
