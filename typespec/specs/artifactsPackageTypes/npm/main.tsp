import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Npm" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://pkgs.dev.azure.com")
namespace Npm;

/** Data required to deprecate multiple package versions. Pass this while performing NpmBatchOperationTypes.Deprecate batch operation. */
model BatchDeprecateData {
  ...BatchOperationData;

  /** Deprecate message that will be added to packages */
  message?: string;
}

/** Do not attempt to use this type to create a new BatchOperationData. This type does not contain sufficient fields to create a new batch operation data. */
model BatchOperationData {}

/** The JSON model for a JSON Patch operation */
model JsonPatchOperation {
  /** The path to copy from for the Move/Copy operation. */
  from?: string;

  /** The patch operation */
  @extension(
    "x-ms-enum",
    #{
      name: "Operation",
      values: #[
        #{ value: "add", description: "" },
        #{ value: "remove", description: "" },
        #{ value: "replace", description: "" },
        #{ value: "move", description: "" },
        #{ value: "copy", description: "" },
        #{ value: "test", description: "" }
      ],
    }
  )
  `op`?: "add" | "remove" | "replace" | "move" | "copy" | "test";

  /** The path for the operation. In the case of an array, a zero based index can be used to specify the position in the array (e.g. /biscuits/0/name). The '-' character can be used instead of an index to insert at the end of the array (e.g. /biscuits/-). */
  path?: string;

  /** The value for the operation. This is either a primitive or a JToken. */
  value?: {};
}

/** Minimal package details required to identify a package within a protocol. */
model MinimalPackageDetails {
  /** Package name. */
  id?: string;

  /** Package version. */
  version?: string;
}

/** A batch of operations to apply to package versions. */
model NpmPackagesBatchRequest {
  data?: BatchOperationData;

  /** Type of operation that needs to be performed on packages. */
  @extension(
    "x-ms-enum",
    #{
      name: "NpmBatchOperationType",
      values: #[
        #{
          value: "promote",
          description: "Promote package versions to a release view. If constructing a NpmPackagesBatchRequest object with this type, use BatchPromoteData for its Data property. Not supported in the Recycle Bin.",
        },
        #{
          value: "deprecate",
          description: "Deprecate or undeprecate package versions. Not supported in the Recycle Bin.",
        },
        #{
          value: "unpublish",
          description: "Unpublish package versions. Npm-specific alias for the Delete operation. Not supported in the Recycle Bin.",
        },
        #{
          value: "permanentDelete",
          description: "Permanently delete package versions. Only supported in the Recycle Bin.",
        },
        #{
          value: "restoreToFeed",
          description: "Restore unpublished package versions to the feed. Only supported in the Recycle Bin.",
        },
        #{
          value: "delete",
          description: "Delete package versions (equivalent to Unpublish). Not supported in the Recycle Bin.",
        }
      ],
    }
  )
  operation?:
    | "promote"
    | "deprecate"
    | "unpublish"
    | "permanentDelete"
    | "restoreToFeed"
    | "delete";

  /** The packages onto which the operation will be performed. */
  packages?: MinimalPackageDetails[];
}

/** Deletion state of an npm package. */
model NpmPackageVersionDeletionState {
  /** Name of the package. */
  name?: string;

  /** UTC date the package was unpublished. */
  unpublishedDate?: utcDateTime;

  /** Version of the package. */
  version?: string;
}

model NpmRecycleBinPackageVersionDetails {
  /** Setting to false will undo earlier deletion and restore the package to feed. */
  deleted?: boolean;
}

/** Package version metadata for an npm package */
model Package {
  _links?: ReferenceLinks;

  /** Deprecated message, if any, for the package. */
  deprecateMessage?: string;

  /** Package Id. */
  id?: string;

  /** The display name of the package. */
  name?: string;

  /** If and when the package was permanently deleted. */
  permanentlyDeletedDate?: utcDateTime;

  /** The history of upstream sources for this package. The first source in the list is the immediate source from which this package was saved. */
  sourceChain?: UpstreamSourceInfo[];

  /** If and when the package was deleted. */
  unpublishedDate?: utcDateTime;

  /** The version of the package. */
  version?: string;
}

model PackageVersionDetails {
  /** Indicates the deprecate message of a package version */
  deprecateMessage?: string;

  views?: JsonPatchOperation;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** Describes upstreaming behavior for a given feed/protocol/package */
model UpstreamingBehavior {
  /** Indicates whether external upstream versions should be considered for this package */
  @extension(
    "x-ms-enum",
    #{
      name: "UpstreamVersionVisibility",
      values: #[
        #{ value: "auto", description: "" },
        #{ value: "allowExternalVersions", description: "" }
      ],
    }
  )
  versionsFromExternalUpstreams?: "auto" | "allowExternalVersions";
}

/** Upstream source definition, including its Identity, package type, and other associated information. */
model UpstreamSourceInfo {
  /** Locator for connecting to the upstream source in a user friendly format, that may potentially change over time */
  displayLocation?: string;

  /** Identity of the upstream source. */
  @format("uuid") id?: string;

  /** Locator for connecting to the upstream source */
  location?: string;

  /** Display name. */
  name?: string;

  /** Source type, such as Public or Internal. */
  @extension(
    "x-ms-enum",
    #{
      name: "PackagingSourceType",
      values: #[
        #{ value: "public", description: "Publicly available source." },
        #{ value: "internal", description: "Azure DevOps upstream source." }
      ],
    }
  )
  sourceType?: "public" | "internal";
}

model ValidateCustomPublicUpstreamSourceRequest {
  packageName?: string;
  upstreamLocation?: string;
}

model ValidateCustomPublicUpstreamSourceResponse {
  message?: string;
  validatedSuccessfully?: boolean;
}

/** Validates whether the given upstream is valid to add as a custom upstream using the given package name. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "validateUpstream")
@extension("x-ms-vss-method", "ValidateCustomPublicUpstreamSource")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/packaging/npm/validateupstream")
@post
op `Npm_Validate Custom Public Upstream Source`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** The upstream location (https URI) and package name to validate */
  @body body: ValidateCustomPublicUpstreamSourceRequest,
): ValidateCustomPublicUpstreamSourceResponse;

/** Unpublish a scoped package version (such as \@scope/name). The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "UnpublishScopedPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}")
@delete
op `Npm_Unpublish Scoped Package`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the package (the 'scope' part of \@scope/name). */
  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scope/name). */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Package;

/** Get information about a scoped package version (such as \@scope/name). The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "GetScopedPackageInfoAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}")
@get
op Npm_GetScopedPackageVersion(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the package (the 'scope' part of \@scope/name). */
  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scope/name). */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Package;

/** Update state for an npm scoped package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "UpdateScopedPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}")
@patch
op `Npm_Update Scoped Package`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scope/name). */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Updated state for the package version. */
  @body body: PackageVersionDetails,
): Package;

/** Unpublish an unscoped package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "UnpublishPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/{packageName}/versions/{packageVersion}")
@delete
op `Npm_Unpublish Package`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Package;

/** Get information about an unscoped package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "GetPackageInfoAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/{packageName}/versions/{packageVersion}")
@get
op Npm_GetPackageVersion(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Package;

/** Update state for an unscoped package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "UpdatePackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/{packageName}/versions/{packageVersion}")
@patch
op `Npm_Update Package`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Updated state for the package version. */
  @body body: PackageVersionDetails,
): Package;

/** Get the upstreaming behavior of the (scoped) package within the context of a feed */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "upstreaming")
@extension("x-ms-vss-method", "GetScopedUpstreamingBehavior")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/@{packageScope}/{unscopedPackageName}/upstreaming")
@get
op Npm_GetPackageUpstreamingBehavior(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The name or id of the feed */
  @path feedId: string,

  /** The scope of the package */
  @path packageScope: string,

  /** The name of the scoped package */
  @path unscopedPackageName: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): UpstreamingBehavior;

/** Set the upstreaming behavior of a (scoped) package within the context of a feed The package does not need to necessarily exist in the feed prior to setting the behavior. This assists with packages that are not yet ingested from an upstream, yet the feed owner wants to apply a specific behavior on the first ingestion. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "upstreaming")
@extension("x-ms-vss-method", "SetScopedUpstreamingBehavior")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/@{packageScope}/{unscopedPackageName}/upstreaming")
@patch
op `Npm_Set Scoped Upstreaming Behavior`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The name or id of the feed */
  @path feedId: string,

  /** The scope of the package */
  @path packageScope: string,

  /** The name of the scoped package */
  @path unscopedPackageName: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** The behavior to apply to the scoped package within the scope of the feed */
  @body body: UpstreamingBehavior,
): OkResponse;

/** Get scoped npm package. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "content")
@extension("x-ms-vss-method", "GetContentScopedPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}/content")
@get
op Npm_DownloadScopedPackage(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the npm package (the \@scope portion of \@scope/packageName). */
  @path packageScope: string,

  /** Name of the package without the scope component. */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): {
  @header contentType: "application/octet-stream";
  @body @format("Stream") body: string;
};

/** Get the Readme for a package version with an npm scope. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "readme")
@extension("x-ms-vss-method", "GetReadmeScopedPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}/readme")
@get
op Npm_GetScopedPackageReadme(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the package (the 'scope' part of \@scopename) */
  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scopename) */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): {
  @header contentType: "text/plain";
  @body @format("Stream") body: string;
};

/** Get the upstreaming behavior of the (unscoped) package within the context of a feed */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "upstreaming")
@extension("x-ms-vss-method", "GetUpstreamingBehavior")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/{packageName}/upstreaming")
@get
op Npm_GetScopedPackageUpstreamingBehavior(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The name or id of the feed */
  @path feedId: string,

  /** The name of the package */
  @path packageName: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): UpstreamingBehavior;

/** Set the upstreaming behavior of a (scoped) package within the context of a feed The package does not need to necessarily exist in the feed prior to setting the behavior. This assists with packages that are not yet ingested from an upstream, yet the feed owner wants to apply a specific behavior on the first ingestion. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "upstreaming")
@extension("x-ms-vss-method", "SetUpstreamingBehavior")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/{packageName}/upstreaming")
@patch
op `Npm_Set Upstreaming Behavior`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The name or id of the feed */
  @path feedId: string,

  /** The name of the package */
  @path packageName: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** The behavior to apply to the scoped package within the scope of the feed */
  @body body: UpstreamingBehavior,
): OkResponse;

/** Get an unscoped npm package. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "content")
@extension("x-ms-vss-method", "GetContentUnscopedPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/{packageName}/versions/{packageVersion}/content")
@get
op Npm_DownloadPackage(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): {
  @header contentType: "application/octet-stream";
  @body @format("Stream") body: string;
};

/** Get the Readme for a package version that has no npm scope. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "readme")
@extension("x-ms-vss-method", "GetReadmeUnscopedPackageAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packages/{packageName}/versions/{packageVersion}/readme")
@get
op Npm_GetPackageReadme(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): {
  @header contentType: "text/plain";
  @body @format("Stream") body: string;
};

/** Update several packages from a single feed in a single request. The updates to the packages do not happen atomically. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "packagesbatch")
@extension("x-ms-vss-method", "UpdatePackagesAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/packagesbatch")
@post
op `Npm_Update Packages`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Information about the packages to update, the operation to perform, and its associated data. */
  @body body: NpmPackagesBatchRequest,
): OkResponse;

/** Delete a package version with an npm scope from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "DeleteScopedPackageVersionFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/packages/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}")
@delete
op `Npm_Delete Scoped Package Version From Recycle Bin`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the package (the 'scope' part of \@scope/name). */
  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scope/name). */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Get information about a scoped package version in the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "GetScopedPackageVersionMetadataFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/packages/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}")
@get
op Npm_GetScopedPackageVersionFromRecycleBin(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the package (the 'scope' part of \@scope/name) */
  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scope/name). */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): NpmPackageVersionDeletionState;

/** Restore a package version with an npm scope from the recycle bin to its feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "RestoreScopedPackageVersionFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/packages/@{packageScope}/{unscopedPackageName}/versions/{packageVersion}")
@patch
op `Npm_Restore Scoped Package Version From Recycle Bin`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Scope of the package (the 'scope' part of \@scope/name). */
  @path packageScope: string,

  /** Name of the package (the 'name' part of \@scope/name). */
  @path unscopedPackageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: NpmRecycleBinPackageVersionDetails,
): OkResponse;

/** Delete a package version without an npm scope from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "DeletePackageVersionFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/packages/{packageName}/versions/{packageVersion}")
@delete
op `Npm_Delete Package Version From Recycle Bin`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Get information about an unscoped package version in the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "GetPackageVersionMetadataFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/packages/{packageName}/versions/{packageVersion}")
@get
op Npm_GetPackageVersionFromRecycleBin(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): NpmPackageVersionDeletionState;

/** Restore a package version without an npm scope from the recycle bin to its feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "RestorePackageVersionFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/packages/{packageName}/versions/{packageVersion}")
@patch
op `Npm_Restore Package Version From Recycle Bin`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Name of the package. */
  @path packageName: string,

  /** Version of the package. */
  @path packageVersion: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: NpmRecycleBinPackageVersionDetails,
): OkResponse;

/** Delete or restore several package versions from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Npm")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recyclebinpackagesbatch")
@extension("x-ms-vss-method", "UpdateRecycleBinPackagesAsync")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/npm/RecycleBin/PackagesBatch")
@post
op `Npm_Update Recycle Bin Packages`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Information about the packages to update, the operation to perform, and its associated data. */
  @body body: NpmPackagesBatchRequest,
): OkResponse;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
