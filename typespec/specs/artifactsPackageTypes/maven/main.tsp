import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Maven" })
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
namespace Maven;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
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

model MavenDistributionManagement {
  repository?: MavenRepository;
  snapshotRepository?: MavenSnapshotRepository;
}

/** Identifies a particular Maven package version */
model MavenMinimalPackageDetails {
  /** Package artifact ID */
  artifact?: string;

  /** Package group ID */
  group?: string;

  /** Package version */
  version?: string;
}

model MavenPackage {
  artifactId?: string;
  artifactIndex?: ReferenceLink;
  artifactMetadata?: ReferenceLink;
  deletedDate?: utcDateTime;
  files?: ReferenceLinks;
  groupId?: string;
  pom?: MavenPomMetadata;
  requestedFile?: ReferenceLink;
  snapshotMetadata?: ReferenceLink;
  version?: string;
  versions?: ReferenceLinks;
  versionsIndex?: ReferenceLink;
}

/** A batch of operations to apply to package versions. */
model MavenPackagesBatchRequest {
  data?: BatchOperationData;

  /** Type of operation that needs to be performed on packages. */
  @extension(
    "x-ms-enum",
    #{
      name: "MavenBatchOperationType",
      values: #[
        #{
          value: "promote",
          description: "Promote package versions to a release view. If constructing a MavenPackagesBatchRequest object with this type, use BatchPromoteData for its Data property. Not supported in the Recycle Bin.",
        },
        #{
          value: "delete",
          description: "Delete package versions. Not supported in the Recycle Bin.",
        },
        #{
          value: "permanentDelete",
          description: "Permanently delete package versions. Only supported in the Recycle Bin.",
        },
        #{
          value: "restoreToFeed",
          description: "Restore unpublished package versions to the feed. Only supported in the Recycle Bin.",
        }
      ],
    }
  )
  operation?: "promote" | "delete" | "permanentDelete" | "restoreToFeed" | string;

  /** The packages onto which the operation will be performed. */
  packages?: MavenMinimalPackageDetails[];
}

/** Deletion state of a maven package. */
model MavenPackageVersionDeletionState {
  /** Artifact Id of the package. */
  artifactId?: string;

  /** UTC date the package was deleted. */
  deletedDate?: utcDateTime;

  /** Group Id of the package. */
  groupId?: string;

  /** Version of the package. */
  version?: string;
}

model MavenPomBuild {
  plugins?: Plugin[];
}

model MavenPomCi {
  notifiers?: MavenPomCiNotifier[];
  system?: string;
  url?: string;
}

model MavenPomCiNotifier {
  configuration?: string[];
  sendOnError?: string;
  sendOnFailure?: string;
  sendOnSuccess?: string;
  sendOnWarning?: string;
  type?: string;
}

model MavenPomDependency {
  ...MavenPomGav;
  optional?: boolean;
  scope?: string;
  type?: string;
}

model MavenPomDependencyManagement {
  dependencies?: MavenPomDependency[];
}

model MavenPomGav {
  artifactId?: string;
  groupId?: string;
  version?: string;
}

model MavenPomIssueManagement {
  system?: string;
  url?: string;
}

model MavenPomLicense {
  ...MavenPomOrganization;
  distribution?: string;
}

model MavenPomMailingList {
  archive?: string;
  name?: string;
  otherArchives?: string[];
  post?: string;
  subscribe?: string;
  unsubscribe?: string;
}

model MavenPomMetadata {
  ...MavenPomGav;
  build?: MavenPomBuild;
  ciManagement?: MavenPomCi;
  contributors?: MavenPomPerson[];
  dependencies?: MavenPomDependency[];
  dependencyManagement?: MavenPomDependencyManagement;
  description?: string;
  developers?: MavenPomPerson[];
  distributionManagement?: MavenDistributionManagement;
  inceptionYear?: string;
  issueManagement?: MavenPomIssueManagement;
  licenses?: MavenPomLicense[];
  mailingLists?: MavenPomMailingList[];
  modelVersion?: string;
  modules?: string[];
  name?: string;
  organization?: MavenPomOrganization;
  packaging?: string;
  parent?: MavenPomParent;
  prerequisites?: Record<string>;
  properties?: Record<string>;
  scm?: MavenPomScm;
  url?: string;
}

model MavenPomOrganization {
  name?: string;
  url?: string;
}

model MavenPomParent {
  ...MavenPomGav;
  relativePath?: string;
}

model MavenPomPerson {
  email?: string;
  id?: string;
  name?: string;
  organization?: string;
  organizationUrl?: string;
  roles?: string[];
  timezone?: string;
  url?: string;
}

model MavenPomScm {
  connection?: string;
  developerConnection?: string;
  tag?: string;
  url?: string;
}

model MavenRecycleBinPackageVersionDetails {
  /** Setting to false will undo earlier deletion and restore the package to feed. */
  deleted?: boolean;
}

model MavenRepository {
  uniqueVersion?: boolean;
}

model MavenSnapshotRepository {
  ...MavenRepository;
}

/** Package version metadata for a Maven package */
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

  /** The history of upstream sources for this package. The first source in the list is the immediate source from which this package was saved. */
  sourceChain?: UpstreamSourceInfo[];

  /** The version of the package. */
  version?: string;
}

model PackageVersionDetails {
  views?: JsonPatchOperation;
}

model Plugin {
  ...MavenPomGav;
  configuration?: PluginConfiguration;
}

model PluginConfiguration {
  goalPrefix?: string;
}

/** The class to represent a REST reference link. RFC: http://tools.ietf.org/html/draft-kelly-json-hal-06 The RFC is not fully implemented, additional properties are allowed on the reference link but as of yet we don't have a need for them. */
model ReferenceLink {
  href?: string;
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

interface Maven {
  /** Get the upstreaming behavior of a package within the context of a feed */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "upstreaming")
  @extension("x-ms-vss-method", "GetUpstreamingBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/groups/{groupId}/artifacts/{artifactId}/upstreaming")
  @get
  GetUpstreamingBehavior(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or id of the feed */
    @path feed: string,

    /** The group id of the package */
    @path groupId: string,

    /** The artifact id of the package */
    @path artifactId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): UpstreamingBehavior;

  /** Set the upstreaming behavior of a package within the context of a feed The package does not need to necessarily exist in the feed prior to setting the behavior. This assists with packages that are not yet ingested from an upstream, yet the feed owner wants to apply a specific behavior on the first ingestion. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "upstreaming")
  @extension("x-ms-vss-method", "SetUpstreamingBehavior")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/groups/{groupId}/artifacts/{artifactId}/upstreaming")
  @patch
  SetUpstreamingBehavior(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or id of the feed */
    @path feed: string,

    @path groupId: string,
    @path artifactId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The behavior to apply to the package within the scope of the feed */
    @body body: UpstreamingBehavior,
  ): OkResponse;

  /** Delete a package version from the feed and move it to the feed's recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "PackageDelete")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/groups/{groupId}/artifacts/{artifactId}/versions/{version}")
  @delete
  DeletePackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feed: string,

    /** Group ID of the package. */
    @path groupId: string,

    /** Artifact ID of the package. */
    @path artifactId: string,

    /** Version of the package. */
    @path version: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AcceptedResponse;

  /** Get information about a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "GetPackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/groups/{groupId}/artifacts/{artifactId}/versions/{version}")
  @get
  GetPackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feed: string,

    /** Group ID of the package. */
    @path groupId: string,

    /** Artifact ID of the package. */
    @path artifactId: string,

    /** Version of the package. */
    @path version: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to show information for deleted packages. */
    @query(#{ explode: true }) showDeleted?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Package;

  /** Update state for a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "UpdatePackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/groups/{groupId}/artifacts/{artifactId}/versions/{version}")
  @patch
  UpdatePackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feed: string,

    /** Group ID of the package. */
    @path groupId: string,

    /** Artifact ID of the package. */
    @path artifactId: string,

    /** Version of the package. */
    @path version: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Details to be updated. */
    @body body: PackageVersionDetails,
  ): OkResponse;

  /** Permanently delete a package from a feed's recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "DeletePackageVersionFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/RecycleBin/groups/{groupId}/artifacts/{artifactId}/versions/{version}")
  @delete
  DeletePackageVersionFromRecycleBin(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feed: string,

    /** Group ID of the package. */
    @path groupId: string,

    /** Artifact ID of the package. */
    @path artifactId: string,

    /** Version of the package. */
    @path version: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get information about a package version in the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "GetPackageVersionMetadataFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/RecycleBin/groups/{groupId}/artifacts/{artifactId}/versions/{version}")
  @get
  GetPackageVersionFromRecycleBin(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feed: string,

    /** Group ID of the package. */
    @path groupId: string,

    /** Artifact ID of the package. */
    @path artifactId: string,

    /** Version of the package. */
    @path version: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): MavenPackageVersionDeletionState;

  /** Restore a package version from the recycle bin to its associated feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "RestorePackageVersionFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/RecycleBin/groups/{groupId}/artifacts/{artifactId}/versions/{version}")
  @patch
  RestorePackageVersionFromRecycleBin(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feed: string,

    /** Group ID of the package. */
    @path groupId: string,

    /** Artifact ID of the package. */
    @path artifactId: string,

    /** Version of the package. */
    @path version: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Set the 'Deleted' property to false to restore the package. */
    @body body: MavenRecycleBinPackageVersionDetails,
  ): OkResponse;

  /** Delete or restore several package versions from the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recyclebinpackagesbatch")
  @extension("x-ms-vss-method", "UpdateRecycleBinPackagesAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feed}/maven/RecycleBin/packagesBatch")
  @post
  UpdateRecycleBinPackages(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path feed: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Information about the packages to update, the operation to perform, and its associated data. */
    @body body: MavenPackagesBatchRequest,
  ): OkResponse;

  /** Fulfills Maven package file download requests by either returning the URL of the requested package file or, in the case of Azure DevOps Server (OnPrem), returning the content as a stream. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "content")
  @extension("x-ms-vss-method", "DownloadPackage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/maven/{groupId}/{artifactId}/{version}/{fileName}/content")
  @get
  DownloadPackage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** GroupId of the maven package */
    @path groupId: string,

    /** ArtifactId of the maven package */
    @path artifactId: string,

    /** Version of the package */
    @path version: string,

    /** File name to download */
    @path fileName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/octet-stream";
    @body @format("Stream") body: string;
  };

  /** Update several packages from a single feed in a single request. The updates to the packages do not happen atomically. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Maven")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packagesBatch")
  @extension("x-ms-vss-method", "UpdatePackageVersions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}/maven/packagesbatch")
  @post
  UpdatePackageVersions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Feed which contains the packages to update. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Information about the packages to update, the operation to perform, and its associated data. */
    @body body: MavenPackagesBatchRequest,
  ): OkResponse;
}
