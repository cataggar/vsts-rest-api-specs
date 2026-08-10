import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Feed" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://feeds.dev.azure.com")
namespace Feed;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Feed & package info for build packages tab */
model BuildPackage {
  /** Display name of the feed. */
  feedName?: string;

  /** Package version description. */
  packageDescription?: string;

  /** Display name of the package. */
  packageName?: string;

  /** Version of the package. */
  packageVersion?: string;

  /** TFS project id. */
  @format("uuid") projectId?: string;

  /** Type of the package. */
  protocolType?: string;
}

/** A container for artifacts. */
model Feed {
  ...FeedCore;
  _links?: ReferenceLinks;

  /** If set, this feed supports generation of package badges. */
  badgesEnabled?: boolean;

  /** The view that the feed administrator has indicated is the default experience for readers. */
  @format("uuid") defaultViewId?: string;

  /** The date that this feed was deleted. */
  deletedDate?: utcDateTime;

  /** A description for the feed. Descriptions must not exceed 255 characters. */
  description?: string;

  /** If set, the feed will hide all deleted/unpublished versions */
  hideDeletedPackageVersions?: boolean;

  /** The date that this feed was permanently deleted. */
  permanentDeletedDate?: utcDateTime;

  /** Explicit permissions for the feed. */
  permissions?: FeedPermission[];

  /** The date that this feed is scheduled to be permanently deleted. */
  scheduledPermanentDeleteDate?: utcDateTime;

  /** If set, time that the UpstreamEnabled property was changed. Will be null if UpstreamEnabled was never changed after Feed creation. */
  upstreamEnabledChangedDate?: utcDateTime;

  /** The URL of the base feed in GUID form. */
  url?: string;
}

model FeedBatchData {
  data?: FeedBatchOperationData;
  @extension(
    "x-ms-enum",
    #{ name: "FeedBatchOperation", values: #[#{ value: "saveCachedPackages", description: "" }] }
  )
  operation?: "saveCachedPackages";
}

model FeedBatchOperationData {}

/** A container that encapsulates the state of the feed after a create, update, or delete. */
model FeedChange {
  /** The type of operation. */
  @extension(
    "x-ms-enum",
    #{
      name: "ChangeType",
      values: #[
        #{ value: "addOrUpdate", description: "A package version was added or updated." },
        #{ value: "delete", description: "A package version was deleted." },
        #{
          value: "permanentDelete",
          description: "A feed was permanently deleted. This is not used for package version.",
        }
      ],
    }
  )
  changeType?: "addOrUpdate" | "delete" | "permanentDelete";

  feed?: Feed;

  /** A token that identifies the next change in the log of changes. */
  feedContinuationToken?: int64;

  /** A token that identifies the latest package change for this feed. This can be used to quickly determine if there have been any changes to packages in a specific feed. */
  latestPackageContinuationToken?: int64;
}

/** A result set containing the feed changes for the range that was requested. */
model FeedChangesResponse {
  _links?: ReferenceLinks;

  /** The number of changes in this set. */
  count?: int32;

  /** A container that encapsulates the state of the feed after a create, update, or delete. */
  feedChanges?: FeedChange[];

  /** When iterating through the log of changes this value indicates the value that should be used for the next continuation token. */
  nextFeedContinuationToken?: int64;
}

/** An object that contains all of the settings for a specific feed. */
model FeedCore {
  /** Supported capabilities of a feed. */
  @extension(
    "x-ms-enum",
    #{
      name: "FeedCapabilities",
      values: #[
        #{ value: "none", description: "No flags exist for this feed" },
        #{
          value: "upstreamV2",
          description: "This feed can serve packages from upstream sources Upstream packages must be manually promoted to views",
        },
        #{
          value: "underMaintenance",
          description: "This feed is currently under maintenance and may have reduced functionality",
        },
        #{
          value: "defaultCapabilities",
          description: "The capabilities given to a newly created feed",
        }
      ],
    }
  )
  capabilities?: "none" | "upstreamV2" | "underMaintenance" | "defaultCapabilities";

  /** This will either be the feed GUID or the feed GUID and view GUID depending on how the feed was accessed. */
  fullyQualifiedId?: string;

  /** Full name of the view, in feed\@view format. */
  fullyQualifiedName?: string;

  /** A GUID that uniquely identifies this feed. */
  @format("uuid") id?: string;

  /** If false, the feed is disabled and cannot be interacted with */
  isEnabled?: boolean;

  /** If set, all packages in the feed are immutable. It is important to note that feed views are immutable; therefore, this flag will always be set for views. */
  isReadOnly?: boolean;

  /** A name for the feed. feed names must follow these rules: <list type='bullet'><item><description> Must not exceed 64 characters </description></item><item><description> Must not contain whitespaces </description></item><item><description> Must not start with an underscore or a period </description></item><item><description> Must not end with a period </description></item><item><description> Must not contain any of the following illegal characters: <![CDATA[ \@, ~, ;, {, }, , +, =, <, >, |, /, , ?, :, &, $, *, ', #, [, ] ]]></description></item></list> */
  name?: string;

  project?: ProjectReference;

  /** This should always be true. Setting to false will override all sources in UpstreamSources. */
  upstreamEnabled?: boolean;

  /** A list of sources that this feed will fetch packages from. An empty list indicates that this feed will not search any additional sources for packages. */
  upstreamSources?: UpstreamSource[];

  view?: FeedView;

  /** View Id. */
  @format("uuid") viewId?: string;

  /** View name. */
  viewName?: string;
}

model FeedIdsResult {
  @format("uuid") id?: string;
  name?: string;
  @format("uuid") projectId?: string;
  projectName?: string;
}

/** Permissions for a feed. */
model FeedPermission {
  /** Display name for the identity. */
  displayName?: string;

  identityDescriptor?: IdentityDescriptor;

  /** Id of the identity associated with this role. */
  @format("uuid") identityId?: string;

  /** Boolean indicating whether the role is inherited or set directly. */
  isInheritedRole?: boolean;

  /** The role for this identity on a feed. */
  @extension(
    "x-ms-enum",
    #{
      name: "FeedRole",
      values: #[
        #{ value: "custom", description: "Unsupported." },
        #{ value: "none", description: "Unsupported." },
        #{ value: "reader", description: "Readers can only read packages and view settings." },
        #{
          value: "contributor",
          description: "Contributors can do anything to packages in the feed including adding new packages, but they may not modify feed settings.",
        },
        #{
          value: "administrator",
          description: "Administrators have total control over the feed.",
        },
        #{
          value: "collaborator",
          description: "Collaborators have the same permissions as readers, but can also ingest packages from configured upstream sources.",
        }
      ],
    }
  )
  role?: "custom" | "none" | "reader" | "contributor" | "administrator" | "collaborator";
}

/** Retention policy settings. */
model FeedRetentionPolicy {
  /** This attribute is deprecated and is not honoured by retention */
  ageLimitInDays?: int32;

  /** Maximum versions to preserve per package and package type. */
  countLimit?: int32;

  /** Number of days to preserve a package version after its latest download. */
  daysToKeepRecentlyDownloadedPackages?: int32;
}

/** Update a feed definition with these new values. */
model FeedUpdate {
  /** If set, the feed will allow upload of packages that exist on the upstream */
  allowUpstreamNameConflict?: boolean;

  /** If set, this feed supports generation of package badges. */
  badgesEnabled?: boolean;

  /** The view that the feed administrator has indicated is the default experience for readers. */
  @format("uuid") defaultViewId?: string;

  /** A description for the feed. Descriptions must not exceed 255 characters. */
  description?: string;

  /** If set, feed will hide all deleted/unpublished versions */
  hideDeletedPackageVersions?: boolean;

  /** A GUID that uniquely identifies this feed. */
  @format("uuid") id?: string;

  /** If true, enable the feed. If false, disable the feed. If null, do not enable or disable the feed in this request. When enabling or disabling a feed, no other changes to the feed are allowed in the same request. */
  isEnabled?: boolean;

  /** A name for the feed. feed names must follow these rules: <list type='bullet'><item><description> Must not exceed 64 characters </description></item><item><description> Must not contain whitespaces </description></item><item><description> Must not start with an underscore or a period </description></item><item><description> Must not end with a period </description></item><item><description> Must not contain any of the following illegal characters: <![CDATA[ \@, ~, ;, {, }, , +, =, <, >, |, /, , ?, :, &, $, *, ', #, [, ] ]]></description></item></list> */
  name?: string;

  /** If set, the feed can proxy packages from an upstream feed */
  upstreamEnabled?: boolean;

  /** A list of sources that this feed will fetch packages from. An empty list indicates that this feed will not search any additional sources for packages. */
  upstreamSources?: UpstreamSource[];
}

/** A view on top of a feed. */
model FeedView {
  _links?: ReferenceLinks;

  /** Id of the view. */
  @format("uuid") id?: string;

  /** Name of the view. */
  name?: string;

  /** Type of view. */
  @extension(
    "x-ms-enum",
    #{
      name: "FeedViewType",
      values: #[
        #{ value: "none", description: "Default, unspecified view type." },
        #{
          value: "release",
          description: "View used as a promotion destination to classify released artifacts.",
        },
        #{
          value: "implicit",
          description: "Internal view type that is automatically created and managed by the system.",
        }
      ],
    }
  )
  type?: "none" | "release" | "implicit";

  /** Url of the view. */
  url?: string;

  /** Visibility status of the view. */
  @extension(
    "x-ms-enum",
    #{
      name: "FeedVisibility",
      values: #[
        #{
          value: "private",
          description: "Only accessible by the permissions explicitly set by the feed administrator.",
        },
        #{
          value: "collection",
          description: "Feed is accessible by all the valid users present in the organization where the feed resides (for example across organization 'myorg' at 'dev.azure.com/myorg')",
        },
        #{
          value: "organization",
          description: "Feed is accessible by all the valid users present in the enterprise where the feed resides. Note that legacy naming and back compat leaves the name of this value out of sync with its new meaning.",
        },
        #{
          value: "aadTenant",
          description: "Feed is accessible by all the valid users present in the Azure Active Directory tenant.",
        }
      ],
    }
  )
  visibility?: "private" | "collection" | "organization" | "aadTenant";
}

/** Permissions for feed service-wide operations such as the creation of new feeds. */
model GlobalPermission {
  identityDescriptor?: IdentityDescriptor;

  /** IdentityId corresponding to the IdentityDescriptor */
  @format("uuid") identityId?: string;

  /** Role associated with the Identity. */
  @extension(
    "x-ms-enum",
    #{
      name: "GlobalRole",
      values: #[
        #{ value: "custom", description: "Invalid default value." },
        #{ value: "none", description: "Explicit no permissions." },
        #{ value: "feedCreator", description: "Ability to create new feeds." },
        #{ value: "administrator", description: "Read and manage any feed" }
      ],
    }
  )
  role?: "custom" | "none" | "feedCreator" | "administrator";
}

/** An Identity descriptor is a wrapper for the identity type (Windows SID, Passport) along with a unique identifier such as the SID or PUID. */
model IdentityDescriptor {
  /** The unique identifier for this identity, not exceeding 256 chars, which will be persisted. */
  identifier?: string;

  /** Type of descriptor (for example, Windows, Passport, etc.). */
  identityType?: string;
}

/** The JSON model for JSON Patch Operations */
model JsonPatchDocument {}

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

/** Core data about any package, including its id and version information and basic state. */
model MinimalPackageVersion {
  /** Upstream source this package was ingested from. */
  @format("uuid") directUpstreamSourceId?: string;

  /** Id for the package. */
  @format("uuid") id?: string;

  /** [Obsolete] Used for legacy scenarios and may be removed in future versions. */
  isCachedVersion?: boolean;

  /** True if this package has been deleted. */
  isDeleted?: boolean;

  /** True if this is the latest version of the package by package type sort order. */
  isLatest?: boolean;

  /** (NuGet and Cargo Only) True if this package is listed. */
  isListed?: boolean;

  /** Normalized version using normalization rules specific to a package type. */
  normalizedVersion?: string;

  /** Package description. */
  packageDescription?: string;

  /** UTC Date the package was published to the service. */
  publishDate?: utcDateTime;

  /** Internal storage id. */
  storageId?: string;

  /** Display version. */
  version?: string;

  /** List of views containing this package version. */
  views?: FeedView[];
}

/** Reference for an async operation. */
model OperationReference {
  /** Unique identifier for the operation. */
  @format("uuid") id?: string;

  /** Unique identifier for the plugin. */
  @format("uuid") pluginId?: string;

  /** The current status of the operation. */
  @extension(
    "x-ms-enum",
    #{
      name: "OperationStatus",
      values: #[
        #{ value: "notSet", description: "The operation does not have a status set." },
        #{ value: "queued", description: "The operation has been queued." },
        #{ value: "inProgress", description: "The operation is in progress." },
        #{ value: "cancelled", description: "The operation was cancelled by the user." },
        #{ value: "succeeded", description: "The operation completed successfully." },
        #{ value: "failed", description: "The operation completed with a failure." }
      ],
    }
  )
  status?: "notSet" | "queued" | "inProgress" | "cancelled" | "succeeded" | "failed";

  /** URL to get the full operation object. */
  url?: string;
}

/** A package, which is a container for one or more package versions. */
model Package {
  _links?: ReferenceLinks;

  /** Id of the package. */
  @format("uuid") id?: string;

  /** Used for legacy scenarios and may be removed in future versions. */
  isCached?: boolean;

  /** The display name of the package. */
  name?: string;

  /** The normalized name representing the identity of this package within its package type. */
  normalizedName?: string;

  /** Type of the package. */
  protocolType?: string;

  /** [Obsolete] - this field is unused and will be removed in a future release. */
  starCount?: int32;

  /** Url for this package. */
  url?: string;

  /** All versions for this package within its feed. */
  versions?: MinimalPackageVersion[];
}

/** A single change to a feed's packages. */
model PackageChange {
  package?: Package;
  packageVersionChange?: PackageVersionChange;
}

/** A set of change operations to a feed's packages. */
model PackageChangesResponse {
  _links?: ReferenceLinks;

  /** Number of changes in this batch. */
  count?: int32;

  /** Token that should be used in future calls for this feed to retrieve new changes. */
  nextPackageContinuationToken?: int64;

  /** List of changes. */
  packageChanges?: PackageChange[];
}

/** A dependency on another package version. */
model PackageDependency {
  /** Dependency package group (an optional classification within some package types). */
  group?: string;

  /** Dependency package name. */
  packageName?: string;

  /** Dependency package version range. */
  versionRange?: string;
}

/** A package file for a specific package version, only relevant to package types that contain multiple files per version. */
model PackageFile {
  /** Hierarchical representation of files. */
  children?: PackageFile[];

  /** File name. */
  name?: string;

  protocolMetadata?: ProtocolMetadata;
}

/** All metrics for a certain package id */
model PackageMetrics {
  /** Total count of downloads per package id. */
  downloadCount?: float64;

  /** Number of downloads per unique user per package id. */
  downloadUniqueUsers?: float64;

  /** UTC date and time when package was last downloaded. */
  lastDownloaded?: utcDateTime;

  /** Package id. */
  @format("uuid") packageId?: string;
}

/** Query to get package metrics */
model PackageMetricsQuery {
  /** List of package ids */
  packageIds?: string[];
}

/** A specific version of a package. */
model PackageVersion {
  ...MinimalPackageVersion;
  _links?: ReferenceLinks;

  /** Package version author. */
  author?: string;

  /** UTC date that this package version was deleted. */
  deletedDate?: utcDateTime;

  /** List of dependencies for this package version. */
  dependencies?: PackageDependency[];

  /** Package version description. */
  description?: string;

  /** Files associated with this package version, only relevant for multi-file package types. */
  files?: PackageFile[];

  /** Other versions of this package. */
  otherVersions?: MinimalPackageVersion[];

  protocolMetadata?: ProtocolMetadata;

  /** List of upstream sources through which a package version moved to land in this feed. */
  sourceChain?: UpstreamSource[];

  /** Package version summary. */
  summary?: string;

  /** Package version tags. */
  tags?: string[];

  /** Package version url. */
  url?: string;
}

/** A change to a single package version. */
model PackageVersionChange {
  /** The type of change that was performed. */
  @extension(
    "x-ms-enum",
    #{
      name: "ChangeType",
      values: #[
        #{ value: "addOrUpdate", description: "A package version was added or updated." },
        #{ value: "delete", description: "A package version was deleted." },
        #{
          value: "permanentDelete",
          description: "A feed was permanently deleted. This is not used for package version.",
        }
      ],
    }
  )
  changeType?: "addOrUpdate" | "delete" | "permanentDelete";

  /** Token marker for this change, allowing the caller to send this value back to the service and receive changes beyond this one. */
  continuationToken?: int64;

  packageVersion?: PackageVersion;
}

/** All metrics for a certain package version id */
model PackageVersionMetrics {
  /** Total count of downloads per package version id. */
  downloadCount?: float64;

  /** Number of downloads per unique user per package version id. */
  downloadUniqueUsers?: float64;

  /** UTC date and time when package version was last downloaded. */
  lastDownloaded?: utcDateTime;

  /** Package id. */
  @format("uuid") packageId?: string;

  /** Package version id. */
  @format("uuid") packageVersionId?: string;
}

/** Query to get package version metrics */
model PackageVersionMetricsQuery {
  /** List of package version ids */
  packageVersionIds?: string[];
}

/** Provenance for a published package version */
model PackageVersionProvenance {
  /** Name or Id of the feed. */
  @format("uuid") feedId?: string;

  /** Id of the package (GUID Id, not name). */
  @format("uuid") packageId?: string;

  /** Id of the package version (GUID Id, not name). */
  @format("uuid") packageVersionId?: string;

  provenance?: Provenance;
}

model ProjectReference {
  /** Gets or sets id of the project. */
  @format("uuid") id?: string;

  /** Gets or sets name of the project. */
  name?: string;

  /** Gets or sets visibility of the project. */
  visibility?: string;
}

/** Extended metadata for a specific package type. */
model ProtocolMetadata {
  /** Extended metadata for a specific package type, formatted to the associated schema version definition. */
  data?: {};

  /** Schema version. */
  schemaVersion?: int32;
}

/** Data about the origin of a published package */
model Provenance {
  /** Other provenance data. */
  data?: Record<string>;

  /** Type of provenance source, for example 'InternalBuild', 'InternalRelease' */
  provenanceSource?: string;

  /** Identity of user that published the package */
  @format("uuid") publisherUserIdentity?: string;

  /** HTTP User-Agent used when pushing the package. */
  userAgent?: string;
}

/** A single package version within the recycle bin. */
model RecycleBinPackageVersion {
  ...PackageVersion;

  /** UTC date on which the package will automatically be removed from the recycle bin and permanently deleted. */
  scheduledPermanentDeleteDate?: utcDateTime;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model SaveCachedPackagesData {
  ...FeedBatchOperationData;
  normalizedPackageNames?: string[];
  viewsForPromotion?: string[];
}

/** Upstream source definition, including its Identity, package type, and other associated information. */
model UpstreamSource {
  /** UTC date that this upstream was deleted. */
  deletedDate?: utcDateTime;

  /** Locator for connecting to the upstream source in a user friendly format, that may potentially change over time */
  displayLocation?: string;

  /** Identity of the upstream source. */
  @format("uuid") id?: string;

  /** For an internal upstream type, track the Azure DevOps organization that contains it. */
  @format("uuid") internalUpstreamCollectionId?: string;

  /** For an internal upstream type, track the feed id being referenced. */
  @format("uuid") internalUpstreamFeedId?: string;

  /** For an internal upstream type, track the project of the feed being referenced. */
  @format("uuid") internalUpstreamProjectId?: string;

  /** For an internal upstream type, track the view of the feed being referenced. */
  @format("uuid") internalUpstreamViewId?: string;

  /** Consistent locator for connecting to the upstream source. */
  location?: string;

  /** Display name. */
  name?: string;

  /** Package type associated with the upstream source. */
  protocol?: string;

  /** The identity of the service endpoint that holds credentials to use when accessing the upstream. */
  @format("uuid") serviceEndpointId?: string;

  /** Specifies the projectId of the Service Endpoint. */
  @format("uuid") serviceEndpointProjectId?: string;

  /** Specifies the status of the upstream. */
  @extension(
    "x-ms-enum",
    #{
      name: "UpstreamStatus",
      values: #[
        #{ value: "ok", description: "Upstream source is ok." },
        #{ value: "disabled", description: "Upstream source is disabled." }
      ],
    }
  )
  status?: "ok" | "disabled";

  /** Provides a human-readable reason for the status of the upstream. */
  statusDetails?: UpstreamStatusDetail[];

  /** Source type, such as Public or Internal. */
  @extension(
    "x-ms-enum",
    #{
      name: "UpstreamSourceType",
      values: #[
        #{ value: "public", description: "Publicly available source." },
        #{ value: "internal", description: "Azure DevOps upstream source." }
      ],
    }
  )
  upstreamSourceType?: "public" | "internal";
}

model UpstreamStatusDetail {
  /** Provides a human-readable reason for the status of the upstream. */
  reason?: string;
}

/** This class is used to serialize collections as a single JSON object on the wire. */
model VssJsonCollectionWrapper {
  ...VssJsonCollectionWrapperBase;

  /** The serialized item. */
  @format("T") value?: string;
}

model VssJsonCollectionWrapperBase {
  /** The number of serialized items. */
  count?: int32;
}

/** A collection of `GlobalPermission` as returned by Azure DevOps. */
model GlobalPermissionList {
  count?: int32;
  value?: GlobalPermission[];
}

/** A collection of `Feed` as returned by Azure DevOps. */
model FeedList {
  count?: int32;
  value?: Feed[];
}

/** A collection of `PackageMetrics` as returned by Azure DevOps. */
model PackageMetricsList {
  count?: int32;
  value?: PackageMetrics[];
}

/** A collection of `Package` as returned by Azure DevOps. */
model PackageList {
  count?: int32;
  value?: Package[];
}

/** A collection of `PackageVersionMetrics` as returned by Azure DevOps. */
model PackageVersionMetricsList {
  count?: int32;
  value?: PackageVersionMetrics[];
}

/** A collection of `PackageVersion` as returned by Azure DevOps. */
model PackageVersionList {
  count?: int32;
  value?: PackageVersion[];
}

/** A collection of `FeedPermission` as returned by Azure DevOps. */
model FeedPermissionList {
  count?: int32;
  value?: FeedPermission[];
}

/** A collection of `RecycleBinPackageVersion` as returned by Azure DevOps. */
model RecycleBinPackageVersionList {
  count?: int32;
  value?: RecycleBinPackageVersion[];
}

/** A collection of `FeedView` as returned by Azure DevOps. */
model FeedViewList {
  count?: int32;
  value?: FeedView[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface ServiceSettings {
  /** Get all service-wide feed creation and administration permissions. */
  @tag("Service  Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "globalPermissions")
  @extension("x-ms-vss-method", "GetGlobalPermissions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/packaging/globalpermissions")
  @get
  GetGlobalPermissions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Set to true to add IdentityIds to the permission objects. */
    @query(#{ explode: true }) includeIds?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): GlobalPermissionList;

  /** Set service-wide permissions that govern feed creation and administration. */
  @tag("Service  Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "globalPermissions")
  @extension("x-ms-vss-method", "SetGlobalPermissions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/packaging/globalpermissions")
  @patch
  SetGlobalPermissions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** New permissions for the organization. */
    @body body: GlobalPermission[],
  ): GlobalPermissionList;
}

interface ChangeTracking {
  /** Query to determine which feeds have changed since the last call, tracked through the provided continuationToken. Only changes to a feed itself are returned and impact the continuationToken, not additions or alterations to packages within the feeds. If the project parameter is present, gets all feed changes in the given project. If omitted, gets all feed changes in the organization. */
  @tag("Change  Tracking")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feedChanges")
  @extension("x-ms-vss-method", "GetFeedChanges")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feedchanges")
  @get
  GetFeedChanges(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If true, get changes for all feeds including deleted feeds. The default value is false. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** A continuation token which acts as a bookmark to a previously retrieved change. This token allows the user to continue retrieving changes in batches, picking up where the previous batch left off. If specified, all the changes that occur strictly after the token will be returned. If not specified or 0, iteration will start with the first change. */
    @query(#{ explode: true }) continuationToken?: int64,

    /** Number of package changes to fetch. The default value is 1000. The maximum value is 2000. */
    @query(#{ explode: true }) batchSize?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedChangesResponse;

  /** Query a feed to determine its current state. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Change  Tracking")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feedChanges")
  @extension("x-ms-vss-method", "GetFeedChange")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feedchanges/{feedId}")
  @get
  GetFeedChange(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedChange;

  /** Get a batch of package changes made to a feed. The changes returned are 'most recent change' so if an Add is followed by an Update before you begin enumerating, you'll only see one change in the batch. While consuming batches using the continuation token, you may see changes to the same package version multiple times if they are happening as you enumerate. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Change  Tracking")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packageChanges")
  @extension("x-ms-vss-method", "GetPackageChanges")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/packagechanges")
  @get
  GetPackageChanges(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** A continuation token which acts as a bookmark to a previously retrieved change. This token allows the user to continue retrieving changes in batches, picking up where the previous batch left off. If specified, all the changes that occur strictly after the token will be returned. If not specified or 0, iteration will start with the first change. */
    @query(#{ explode: true }) continuationToken?: int64,

    /** Number of package changes to fetch. The default value is 1000. The maximum value is 2000. */
    @query(#{ explode: true }) batchSize?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): PackageChangesResponse;
}

interface FeedRecycleBin {
  /** Query for feeds within the recycle bin. If the project parameter is present, gets all feeds in recycle bin in the given project. If omitted, gets all feeds in recycle bin in the organization. */
  @tag("Feed Recycle Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feedRecycleBin")
  @extension("x-ms-vss-method", "GetFeedsFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feedrecyclebin")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedList;

  /** Permanently delete a feed and all of its packages. The action is irreversible and the package content will be deleted immediately. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed Recycle Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feedRecycleBin")
  @extension("x-ms-vss-method", "PermanentDeleteFeed")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feedrecyclebin/{feedId}")
  @delete
  PermanentDeleteFeed(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Restores a deleted feed and all of its packages. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed Recycle Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feedRecycleBin")
  @extension("x-ms-vss-method", "RestoreDeletedFeed")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feedrecyclebin/{feedId}")
  @patch
  RestoreDeletedFeed(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/json-patch+json",
    @body body: JsonPatchDocument,
  ): OkResponse;
}

interface FeedManagement {
  /** Get all feeds in an account where you have the provided role access. If the project parameter is present, gets all feeds in the given project. If omitted, gets all feeds in the organization. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feeds")
  @extension("x-ms-vss-method", "GetFeeds")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds")
  @get
  GetFeeds(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Filter by this role, either Administrator(4), Contributor(3), or Reader(2) level permissions. */
    @extension(
      "x-ms-enum",
      #{
        name: "FeedRole",
        values: #[
          #{ value: "custom", description: "Unsupported." },
          #{ value: "none", description: "Unsupported." },
          #{ value: "reader", description: "Readers can only read packages and view settings." },
          #{
            value: "contributor",
            description: "Contributors can do anything to packages in the feed including adding new packages, but they may not modify feed settings.",
          },
          #{
            value: "administrator",
            description: "Administrators have total control over the feed.",
          },
          #{
            value: "collaborator",
            description: "Collaborators have the same permissions as readers, but can also ingest packages from configured upstream sources.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    feedRole?: "custom" | "none" | "reader" | "contributor" | "administrator" | "collaborator",

    /** Include upstreams that have been deleted in the response. */
    @query(#{ explode: true }) includeDeletedUpstreams?: boolean,

    /** Resolve names if true */
    @query(#{ explode: true }) includeUrls?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedList;

  /** Create a feed, a container for various package types. Feeds can be created in a project if the project parameter is included in the request url. If the project parameter is omitted, the feed will not be associated with a project and will be created at the organization level. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feeds")
  @extension("x-ms-vss-method", "CreateFeed")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds")
  @post
  CreateFeed(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** A JSON object containing both required and optional attributes for the feed. Name is the only required value. */
    @body body: Feed,
  ): Feed;

  /** Remove a feed and all its packages. The feed moves to the recycle bin and is reversible. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feeds")
  @extension("x-ms-vss-method", "DeleteFeed")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}")
  @delete
  DeleteFeed(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get the settings for a specific feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feeds")
  @extension("x-ms-vss-method", "GetFeed")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}")
  @get
  GetFeed(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Include upstreams that have been deleted in the response. */
    @query(#{ explode: true }) includeDeletedUpstreams?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Feed;

  /** Change the attributes of a feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "feeds")
  @extension("x-ms-vss-method", "UpdateFeed")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/feeds/{feedId}")
  @patch
  UpdateFeed(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** A JSON object containing the feed settings to be updated. */
    @body body: FeedUpdate,
  ): Feed;

  /** Get the permissions for a feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissions")
  @extension("x-ms-vss-method", "GetFeedPermissions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/permissions")
  @get
  GetFeedPermissions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include user Ids in the response. Default is false. */
    @query(#{ explode: true }) includeIds?: boolean,

    /** True to only return explicitly set permissions on the feed. Default is false. */
    @query(#{ explode: true }) excludeInheritedPermissions?: boolean,

    /** Filter permissions to the provided identity. */
    @query(#{ explode: true }) identityDescriptor?: string,

    /** If includeDeletedFeeds is true, then feedId must be specified by name and not by Guid. */
    @query(#{ explode: true }) includeDeletedFeeds?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedPermissionList;

  /** Update the permissions on a feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissions")
  @extension("x-ms-vss-method", "SetFeedPermissions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/permissions")
  @patch
  SetFeedPermissions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Permissions to set. */
    @body body: FeedPermission[],
  ): FeedPermissionList;

  /** Get all views for a feed. The project parameter must be supplied if the feed was created in a project. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "views")
  @extension("x-ms-vss-method", "GetFeedViews")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/views")
  @get
  GetFeedViews(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedViewList;

  /** Create a new view on the referenced feed. The project parameter must be supplied if the feed was created in a project. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "views")
  @extension("x-ms-vss-method", "CreateFeedView")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/views")
  @post
  CreateFeedView(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** View to be created. */
    @body body: FeedView,
  ): FeedView;

  /** Delete a feed view. The project parameter must be supplied if the feed was created in a project. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "views")
  @extension("x-ms-vss-method", "DeleteFeedView")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/views/{viewId}")
  @delete
  DeleteFeedView(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Name or Id of the view. */
    @path viewId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a view by Id. The project parameter must be supplied if the feed was created in a project. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "views")
  @extension("x-ms-vss-method", "GetFeedView")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/views/{viewId}")
  @get
  GetFeedView(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Name or Id of the view. */
    @path viewId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedView;

  /** Update a view. The project parameter must be supplied if the feed was created in a project. */
  @tag("Feed  Management")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "views")
  @extension("x-ms-vss-method", "UpdateFeedView")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/views/{viewId}")
  @patch
  UpdateFeedView(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Name or Id of the view. */
    @path viewId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** New settings to apply to the specified view. */
    @body body: FeedView,
  ): FeedView;
}

interface ArtifactDetails {
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packageMetricsBatch")
  @extension("x-ms-vss-method", "QueryPackageMetrics")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/packagemetricsbatch")
  @post
  QueryPackageMetrics(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: PackageMetricsQuery,
  ): PackageMetricsList;

  /** Get details about all of the packages in the feed. Use the various filters to include or exclude information from the result set. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packages")
  @extension("x-ms-vss-method", "GetPackages")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/packages")
  @get
  GetPackages(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** One of the supported artifact package types. */
    @query(#{ explode: true }) protocolType?: string,

    /** Filter to packages that contain the provided string. Characters in the string must conform to the package name constraints. */
    @query(#{ explode: true }) packageNameQuery?: string,

    /** [Obsolete] Used for legacy scenarios and may be removed in future versions. */
    @query(#{ explode: true }) normalizedPackageName?: string,

    /** True to return REST Urls with the response. Default is True. */
    @query(#{ explode: true }) includeUrls?: boolean,

    /** True to return all versions of the package in the response. Default is false (latest version only). */
    @query(#{ explode: true }) includeAllVersions?: boolean,

    /** Only applicable for NuGet packages, setting it for other package types will result in a 404. If false, delisted package versions will be returned. Use this to filter the response when includeAllVersions is set to true. Default is unset (do not return delisted packages). */
    @query(#{ explode: true }) isListed?: boolean,

    /** Changes the behavior of $top and $skip to return all versions of each package up to $top. Must be used in conjunction with includeAllVersions=true */
    @query(#{ explode: true }) getTopPackageVersions?: boolean,

    /** Only applicable for Nuget packages. Use this to filter the response when includeAllVersions is set to true. Default is True (only return packages without prerelease versioning). */
    @query(#{ explode: true }) isRelease?: boolean,

    /** Return the description for every version of each package in the response. Default is False. */
    @query(#{ explode: true }) includeDescription?: boolean,

    /** Get the top N packages (or package versions where getTopPackageVersions=true) */
    @query(#{ explode: true }) $top?: int32,

    /** Skip the first N packages (or package versions where getTopPackageVersions=true) */
    @query(#{ explode: true }) $skip?: int32,

    /** Return deleted or unpublished versions of packages in the response. Default is False. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** [Obsolete] Used for legacy scenarios and may be removed in future versions. */
    @query(#{ explode: true }) isCached?: boolean,

    /** Filter results to return packages from a specific upstream. */
    @format("uuid") @query(#{ explode: true }) directUpstreamId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PackageList;

  /** Get details about a specific package. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packages")
  @extension("x-ms-vss-method", "GetPackage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/packages/{packageId}")
  @get
  GetPackage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** The package Id (GUID Id, not the package name). */
    @path packageId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to return all versions of the package in the response. Default is false (latest version only). */
    @query(#{ explode: true }) includeAllVersions?: boolean,

    /** True to return REST Urls with the response. Default is True. */
    @query(#{ explode: true }) includeUrls?: boolean,

    /** Only applicable for NuGet packages, setting it for other package types will result in a 404. If false, delisted package versions will be returned. Use this to filter the response when includeAllVersions is set to true. Default is unset (do not return delisted packages). */
    @query(#{ explode: true }) isListed?: boolean,

    /** Only applicable for Nuget packages. Use this to filter the response when includeAllVersions is set to true. Default is True (only return packages without prerelease versioning). */
    @query(#{ explode: true }) isRelease?: boolean,

    /** Return deleted or unpublished versions of packages in the response. Default is False. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** Return the description for every version of each package in the response. Default is False. */
    @query(#{ explode: true }) includeDescription?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Package;

  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versionMetricsBatch")
  @extension("x-ms-vss-method", "QueryPackageVersionMetrics")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/Packages/{packageId}/versionmetricsbatch")
  @post
  QueryPackageVersionMetrics(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path feedId: string,
    @format("uuid") @path packageId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: PackageVersionMetricsQuery,
  ): PackageVersionMetricsList;

  /** Get a list of package versions, optionally filtering by state. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "GetPackageVersions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/Packages/{packageId}/versions")
  @get
  GetPackageVersions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Id of the package (GUID Id, not name). */
    @path packageId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include urls for each version. Default is true. */
    @query(#{ explode: true }) includeUrls?: boolean,

    /** Only applicable for NuGet packages. If false, delisted package versions will be returned. */
    @query(#{ explode: true }) isListed?: boolean,

    /** If set specifies whether to return only deleted or non-deleted versions of packages in the response. Default is unset (return all versions). */
    @query(#{ explode: true }) isDeleted?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): PackageVersionList;

  /** Get details about a specific package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "versions")
  @extension("x-ms-vss-method", "GetPackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/Packages/{packageId}/versions/{packageVersionId}")
  @get
  GetPackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Id of the package (GUID Id, not name). */
    @path packageId: string,

    /** Id of the package version (GUID Id, not name). */
    @path packageVersionId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include urls for each version. Default is true. */
    @query(#{ explode: true }) includeUrls?: boolean,

    /** Only applicable for NuGet packages. If false, delisted package versions will be returned. */
    @query(#{ explode: true }) isListed?: boolean,

    /** This does not have any effect on the requested package version, for other versions returned specifies whether to return only deleted or non-deleted versions of packages in the response. Default is unset (return all versions). */
    @query(#{ explode: true }) isDeleted?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): PackageVersion;

  /** Gets provenance for a package version. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "provenance")
  @extension("x-ms-vss-method", "GetPackageVersionProvenance")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/Packages/{packageId}/Versions/{packageVersionId}/provenance")
  @get
  GetPackageVersionProvenance(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Id of the package (GUID Id, not name). */
    @format("uuid") @path packageId: string,

    /** Id of the package version (GUID Id, not name). */
    @format("uuid") @path packageVersionId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PackageVersionProvenance;

  /** Generate a SVG badge for the latest version of a package. The generated SVG is typically used as the image in an HTML link which takes users to the feed containing the package to accelerate discovery and consumption. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Artifact  Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "badge")
  @extension("x-ms-vss-method", "GetBadge")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/public/packaging/Feeds/{feedId}/Packages/{packageId}/badge")
  @get
  GetBadge(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Id of the package (GUID Id, not name). */
    @format("uuid") @path packageId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "image/svg+xml";
    @body @format("Stream") body: string;
  };
}

interface RecycleBin {
  /** Queues a job to remove all package versions from a feed's recycle bin */
  @tag("Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinPackages")
  @extension("x-ms-vss-method", "EmptyRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/RecycleBin/Packages")
  @delete
  EmptyRecycleBin(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OperationReference;

  /** Query for packages within the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinPackages")
  @extension("x-ms-vss-method", "GetRecycleBinPackages")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/RecycleBin/Packages")
  @get
  GetRecycleBinPackages(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Type of package (e.g. NuGet, npm, ...). */
    @query(#{ explode: true }) protocolType?: string,

    /** Filter to packages matching this name. */
    @query(#{ explode: true }) packageNameQuery?: string,

    /** True to return REST Urls with the response. Default is True. */
    @query(#{ explode: true }) includeUrls?: boolean,

    /** Get the top N packages. */
    @query(#{ explode: true }) $top?: int32,

    /** Skip the first N packages. */
    @query(#{ explode: true }) $skip?: int32,

    /** True to return all versions of the package in the response. Default is false (latest version only). */
    @query(#{ explode: true }) includeAllVersions?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): PackageList;

  /** Get information about a package and all its versions within the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinPackages")
  @extension("x-ms-vss-method", "GetRecycleBinPackage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/RecycleBin/Packages/{packageId}")
  @get
  GetRecycleBinPackage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** The package Id (GUID Id, not the package name). */
    @format("uuid") @path packageId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to return REST Urls with the response. Default is True. */
    @query(#{ explode: true }) includeUrls?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Package;

  /** Get a list of package versions within the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "GetRecycleBinPackageVersions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/RecycleBin/Packages/{packageId}/Versions")
  @get
  GetRecycleBinPackageVersions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** The package Id (GUID Id, not the package name). */
    @format("uuid") @path packageId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to return REST Urls with the response. Default is True. */
    @query(#{ explode: true }) includeUrls?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): RecycleBinPackageVersionList;

  /** Get information about a package version within the recycle bin. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinVersions")
  @extension("x-ms-vss-method", "GetRecycleBinPackageVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/RecycleBin/Packages/{packageId}/Versions/{packageVersionId}")
  @get
  GetRecycleBinPackageVersion(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or Id of the feed. */
    @path feedId: string,

    /** The package Id (GUID Id, not the package name). */
    @format("uuid") @path packageId: string,

    /** The package version Id 9guid Id, not the version string). */
    @format("uuid") @path packageVersionId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to return REST Urls with the response. Default is True. */
    @query(#{ explode: true }) includeUrls?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): RecycleBinPackageVersion;
}

interface RetentionPolicies {
  /** Delete the retention policy for a feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Retention  Policies")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "retentionPolicies")
  @extension("x-ms-vss-method", "DeleteFeedRetentionPolicies")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/retentionpolicies")
  @delete
  DeleteRetentionPolicy(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get the retention policy for a feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Retention  Policies")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "retentionPolicies")
  @extension("x-ms-vss-method", "GetFeedRetentionPolicies")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/retentionpolicies")
  @get
  GetRetentionPolicy(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): FeedRetentionPolicy;

  /** Set the retention policy for a feed. The project parameter must be supplied if the feed was created in a project. If the feed is not associated with any project, omit the project parameter from the request. */
  @tag("Retention  Policies")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "retentionPolicies")
  @extension("x-ms-vss-method", "SetFeedRetentionPolicies")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/packaging/Feeds/{feedId}/retentionpolicies")
  @put
  SetRetentionPolicy(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name or ID of the feed. */
    @path feedId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Feed retention policy. */
    @body body: FeedRetentionPolicy,
  ): FeedRetentionPolicy;
}
