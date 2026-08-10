import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "NuGet" })
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
namespace NuGet;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Data required to unlist or relist multiple package versions. Pass this while performing NuGetBatchOperationTypes.List batch operation. */
model BatchListData {
  ...BatchOperationData;

  /** The desired listed status for the package versions. */
  listed?: boolean;
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
  `op`?: "add" | "remove" | "replace" | "move" | "copy" | "test" | string;

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
model NuGetPackagesBatchRequest {
  data?: BatchOperationData;

  /** Type of operation that needs to be performed on packages. */
  @extension(
    "x-ms-enum",
    #{
      name: "NuGetBatchOperationType",
      values: #[
        #{
          value: "promote",
          description: "Promote package versions to a release view. If constructing a NuGetPackagesBatchRequest object with this type, use BatchPromoteData for its Data property. Not supported in the Recycle Bin.",
        },
        #{
          value: "list",
          description: "Delist or relist package versions. Not supported in the Recycle Bin.",
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
  operation?: "promote" | "list" | "delete" | "permanentDelete" | "restoreToFeed" | string;

  /** The packages onto which the operation will be performed. */
  packages?: MinimalPackageDetails[];
}

/** Deletion state of a NuGet package. */
model NuGetPackageVersionDeletionState {
  /** Utc date the package was deleted. */
  deletedDate?: utcDateTime;

  /** Name of the package. */
  name?: string;

  /** Version of the package. */
  version?: string;
}

model NuGetRecycleBinPackageVersionDetails {
  /** Setting to false will undo earlier deletion and restore the package to feed. */
  deleted?: boolean;
}

/** Package version metadata for a NuGet package */
model Package {
  _links?: ReferenceLinks;

  /** If and when the package was deleted. */
  deletedDate?: utcDateTime;

  /** Package Id. */
  id?: string;

  /** Indicates whether the package is marked as 'listed' within the NuGet protocol. If null or missing, the package's 'listed' state is unspecified. */
  listed?: boolean;

  /** The display name of the package. */
  name?: string;

  /** If and when the package was permanently deleted. */
  permanentlyDeletedDate?: utcDateTime;

  /** The history of upstream sources for this package. The first source in the list is the immediate source from which this package was saved. */
  sourceChain?: UpstreamSourceInfo[];

  /** The version of the package. */
  version?: string;
}

model PackageVersionDetails {
  /** Indicates the listing state of a package */
  listed?: boolean;

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
  versionsFromExternalUpstreams?: "auto" | "allowExternalVersions" | string;
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
  sourceType?: "public" | "internal" | string;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface NuGet {
  /** Get the upstreaming behavior of a package within the context of a feed */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "upstreaming")
  @extension("x-ms-vss-method", "GetUpstreamingBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packages/{packageName}/upstreaming")
  @get
  GetUpstreamingBehavior(
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

  /** Set the upstreaming behavior of a package within the context of a feed The package does not need to necessarily exist in the feed prior to setting the behavior. This assists with packages that are not yet ingested from an upstream, yet the feed owner wants to apply a specific behavior on the first ingestion. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "upstreaming")
  @extension("x-ms-vss-method", "SetUpstreamingBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packages/{packageName}/upstreaming")
  @patch
  SetUpstreamingBehavior(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or id of the feed */
    @path feedId: string,

    /** The name of the package */
    @path packageName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The behavior to apply to the package within the scope of the feed */
    @body body: UpstreamingBehavior,
  ): OkResponse;

  /** Send a package version from the feed to its paired recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "DeletePackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}")
  @delete
  DeletePackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Name of the package to delete. */
    @path packageName: string,

    /** Version of the package to delete. */
    @path packageVersion: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Package;

  /** Get information about a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "GetPackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}")
  @get
  GetPackageVersion(
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

    /** True to include deleted packages in the response. */
    @query(#{ explode: true }) showDeleted?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Package;

  /** Set mutable state on a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "UpdatePackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}")
  @patch
  UpdatePackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Name of the package to update. */
    @path packageName: string,

    /** Version of the package to update. */
    @path packageVersion: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** New state to apply to the referenced package. */
    @body body: PackageVersionDetails,
  ): OkResponse;

  /** Download a package version directly. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "content")
  @extension("x-ms-vss-method", "DownloadPackage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}/content")
  @get
  DownloadPackage(
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

    /** Unused */
    @query(#{ explode: true }) sourceProtocolVersion?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/octet-stream";
    @body @format("Stream") body: string;
  };

  /** Update several packages from a single feed in a single request. The updates to the packages do not happen atomically. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packagesBatch")
  @extension("x-ms-vss-method", "UpdatePackageVersions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/packagesbatch")
  @post
  UpdatePackageVersions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Information about the packages to update, the operation to perform, and its associated data. */
    @body body: NuGetPackagesBatchRequest,
  ): OkResponse;

  /** Delete a package version from a feed's recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "DeletePackageVersionFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/RecycleBin/packages/{packageName}/versions/{packageVersion}")
  @delete
  DeletePackageVersionFromRecycleBin(
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

  /** View a package version's deletion/recycled status The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "GetPackageVersionMetadataFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/RecycleBin/packages/{packageName}/versions/{packageVersion}")
  @get
  GetPackageVersionFromRecycleBin(
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
  ): NuGetPackageVersionDeletionState;

  /** Restore a package version from a feed's recycle bin back into the active feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "RestorePackageVersionFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/RecycleBin/packages/{packageName}/versions/{packageVersion}")
  @patch
  RestorePackageVersionFromRecycleBin(
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

    /** Set the 'Deleted' member to 'false' to apply the restore operation */
    @body body: NuGetRecycleBinPackageVersionDetails,
  ): OkResponse;

  /** Delete or restore several package versions from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("NuGet")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinPackagesBatch")
  @extension("x-ms-vss-method", "UpdateRecycleBinPackageVersions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/nuget/RecycleBin/packagesBatch")
  @post
  UpdateRecycleBinPackageVersions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Information about the packages to update, the operation to perform, and its associated data. <c>Operation</c> must be <c>PermanentDelete</c> or <c>RestoreToFeed</c> */
    @body body: NuGetPackagesBatchRequest,
  ): OkResponse;
}
