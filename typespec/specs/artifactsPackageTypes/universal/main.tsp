import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "UPackApi" })
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
namespace UPackApi;

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

/** Package version metadata for a Universal package */
model Package {
  _links?: ReferenceLinks;

  /** If and when the package was deleted. */
  deletedDate?: utcDateTime;

  /** Package Id. */
  id?: string;

  /** The display name of the package. */
  name?: string;

  /** If and when the package was permanently deleted. */
  permanentlyDeletedDate?: utcDateTime;

  /** The version of the package. */
  version?: string;
}

model PackageVersionDetails {
  views?: JsonPatchOperation;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** A batch of operations to apply to package versions. */
model UPackPackagesBatchRequest {
  data?: BatchOperationData;

  /** Type of operation that needs to be performed on packages. */
  @extension(
    "x-ms-enum",
    #{
      name: "UPackBatchOperationType",
      values: #[
        #{
          value: "promote",
          description: "Promote package versions to a release view. If constructing a UPackPackagesBatchRequest object with this type, use BatchPromoteData for its Data property. Not supported in the Recycle Bin.",
        },
        #{
          value: "delete",
          description: "Move package versions to the feed's Recycle Bin. Not supported in the Recycle Bin.",
        },
        #{
          value: "permanentDelete",
          description: "Permanently delete package versions. Only supported in the Recycle Bin.",
        },
        #{
          value: "restoreToFeed",
          description: "Restore deleted package versions to the feed. Only supported in the Recycle Bin.",
        }
      ],
    }
  )
  operation?: "promote" | "delete" | "permanentDelete" | "restoreToFeed";

  /** The packages onto which the operation will be performed. */
  packages?: MinimalPackageDetails[];
}

/** Deletion state of a Universal package. */
model UPackPackageVersionDeletionState {
  /** UTC date the package was deleted. */
  deletedDate?: utcDateTime;

  /** Name of the package. */
  name?: string;

  /** Version of the package. */
  version?: string;
}

model UPackRecycleBinPackageVersionDetails {
  /** Setting to false will undo earlier deletion and restore the package to feed. */
  deleted?: boolean;
}

/** Delete a package version from a feed's recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "DeletePackageVersion")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/packages/{packageName}/versions/{packageVersion}")
@delete
op Universal_DeletePackageVersion(
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

/** Show information about a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "GetPackageVersion")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/packages/{packageName}/versions/{packageVersion}")
@get
op Universal_GetPackageVersion(
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

  /** True to show information for deleted versions */
  @query(#{ explode: true }) showDeleted?: boolean,

  ...Parameters.`api-Version-preview`.`1`,
): Package;

/** Update information for a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "versions")
@extension("x-ms-vss-method", "UpdatePackageVersion")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/packages/{packageName}/versions/{packageVersion}")
@patch
op Universal_UpdatePackageVersion(
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
  @body body: PackageVersionDetails,
): OkResponse;

/** Update several packages from a single feed in a single request. The updates to the packages do not happen atomically. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "packagesBatch")
@extension("x-ms-vss-method", "UpdatePackageVersions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/packagesbatch")
@post
op Universal_UpdatePackageVersions(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Name or ID of the feed. */
  @path feedId: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Information about the packages to update, the operation to perform, and its associated data. */
  @body body: UPackPackagesBatchRequest,
): OkResponse;

/** Delete a package version from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "DeletePackageVersionFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/RecycleBin/packages/{packageName}/versions/{packageVersion}")
@delete
op Universal_DeletePackageVersionFromRecycleBin(
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

/** Get information about a package version in the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "GetPackageVersionMetadataFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/RecycleBin/packages/{packageName}/versions/{packageVersion}")
@get
op Universal_GetPackageVersionFromRecycleBin(
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
): UPackPackageVersionDeletionState;

/** Restore a package version from the recycle bin to its associated feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinVersions")
@extension("x-ms-vss-method", "RestorePackageVersionFromRecycleBin")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/RecycleBin/packages/{packageName}/versions/{packageVersion}")
@patch
op Universal_RestorePackageVersionFromRecycleBin(
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

  /** Set the 'Deleted' property to 'false' to restore the package. */
  @body body: UPackRecycleBinPackageVersionDetails,
): OkResponse;

/** Delete or restore several package versions from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
@tag("Universal")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "recycleBinPackagesBatch")
@extension("x-ms-vss-method", "UpdateRecycleBinPackageVersions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/upack/RecycleBin/packagesBatch")
@post
op Universal_UpdateRecycleBinPackageVersions(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Feed which contains the packages to update. */
  @path feedId: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Information about the packages to update, the operation to perform, and its associated data. <c>Operation</c> must be <c>PermanentDelete</c> or <c>RestoreToFeed</c> */
  @body body: UPackPackagesBatchRequest,
): OkResponse;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
