import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Tfvc" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://dev.azure.com")
namespace Tfvc;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AssociatedWorkItem {
  assignedTo?: string;

  /** Id of associated the work item. */
  id?: int32;

  state?: string;
  title?: string;

  /** REST Url of the work item. */
  url?: string;

  webUrl?: string;
  workItemType?: string;
}

model Change {
  /** The type of change that was made to the item. */
  @extension(
    "x-ms-enum",
    #{
      name: "VersionControlChangeType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "add", description: "" },
        #{ value: "edit", description: "" },
        #{ value: "encoding", description: "" },
        #{ value: "rename", description: "" },
        #{ value: "delete", description: "" },
        #{ value: "undelete", description: "" },
        #{ value: "branch", description: "" },
        #{ value: "merge", description: "" },
        #{ value: "lock", description: "" },
        #{ value: "rollback", description: "" },
        #{ value: "sourceRename", description: "" },
        #{ value: "targetRename", description: "" },
        #{ value: "property", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  changeType?:
    | "none"
    | "add"
    | "edit"
    | "encoding"
    | "rename"
    | "delete"
    | "undelete"
    | "branch"
    | "merge"
    | "lock"
    | "rollback"
    | "sourceRename"
    | "targetRename"
    | "property"
    | "all";

  /** Current version. */
  @format("T") item?: string;

  newContent?: ItemContent;

  /** Path of the item on the server. */
  sourceServerItem?: string;

  /** URL to retrieve the item. */
  url?: string;
}

model CheckinNote {
  name?: string;
  value?: string;
}

model FileContentMetadata {
  contentType?: string;
  encoding?: int32;
  extension?: string;
  fileName?: string;
  isBinary?: boolean;
  isImage?: boolean;
  vsLink?: string;
}

model GitRepository {
  _links?: ReferenceLinks;

  /** The timestamp when the repository was created. */
  creationDate?: utcDateTime;

  defaultBranch?: string;
  @format("uuid") id?: string;

  /** True if the repository is disabled. False otherwise. */
  isDisabled?: boolean;

  /** True if the repository was created as a fork. */
  isFork?: boolean;

  /** True if the repository is in maintenance. False otherwise. */
  isInMaintenance?: boolean;

  name?: string;
  parentRepository?: GitRepositoryRef;
  project?: TeamProjectReference;
  remoteUrl?: string;

  /** Compressed size (bytes) of the repository. */
  size?: int64;

  sshUrl?: string;
  url?: string;
  validRemoteUrls?: string[];
  webUrl?: string;
}

model GitRepositoryRef {
  collection?: TeamProjectCollectionReference;
  @format("uuid") id?: string;

  /** True if the repository was created as a fork */
  isFork?: boolean;

  name?: string;
  project?: TeamProjectReference;
  remoteUrl?: string;
  sshUrl?: string;
  url?: string;
}

model GraphSubjectBase {
  _links?: ReferenceLinks;

  /** The descriptor is the primary way to reference the graph subject while the system is running. This field will uniquely identify the same graph subject across both Accounts and Organizations. */
  descriptor?: string;

  /** This is the non-unique display name of the graph subject. To change this field, you must alter its value in the source provider. */
  displayName?: string;

  /** This url is the full route to the source resource of this graph subject. */
  url?: string;
}

model IdentityRef {
  ...GraphSubjectBase;

  /** Deprecated - Can be retrieved by querying the Graph user referenced in the 'self' entry of the IdentityRef '_links' dictionary */
  directoryAlias?: string;

  id?: string;

  /** Deprecated - Available in the 'avatar' entry of the IdentityRef '_links' dictionary */
  imageUrl?: string;

  /** Deprecated - Can be retrieved by querying the Graph membership state referenced in the 'membershipState' entry of the GraphUser '_links' dictionary */
  inactive?: boolean;

  /** Deprecated - Can be inferred from the subject type of the descriptor (Descriptor.IsAadUserType/Descriptor.IsAadGroupType) */
  isAadIdentity?: boolean;

  /** Deprecated - Can be inferred from the subject type of the descriptor (Descriptor.IsGroupType) */
  isContainer?: boolean;

  isDeletedInOrigin?: boolean;

  /** Deprecated - not in use in most preexisting implementations of ToIdentityRef */
  profileUrl?: string;

  /** Deprecated - use Domain+PrincipalName instead */
  uniqueName?: string;
}

model ItemContent {
  content?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ItemContentType",
      values: #[
        #{ value: "rawText", description: "" },
        #{ value: "base64Encoded", description: "" }
      ],
    }
  )
  contentType?: "rawText" | "base64Encoded";
}

model ItemModel {
  _links?: ReferenceLinks;
  content?: string;
  contentMetadata?: FileContentMetadata;
  isFolder?: boolean;
  isSymLink?: boolean;
  path?: string;
  url?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model ResourceRef {
  id?: string;
  url?: string;
}

/** Reference object for a TeamProjectCollection. */
model TeamProjectCollectionReference {
  /** Collection avatar Url. */
  avatarUrl?: string;

  /** Collection Id. */
  @format("uuid") id?: string;

  /** Collection Name. */
  name?: string;

  /** Collection REST Url. */
  url?: string;
}

/** Represents a shallow reference to a TeamProject. */
model TeamProjectReference {
  /** Project abbreviation. */
  abbreviation?: string;

  /** Url to default team identity image. */
  defaultTeamImageUrl?: string;

  /** The project's description (if any). */
  description?: string;

  /** Project identifier. */
  @format("uuid") id?: string;

  /** Project last update time. */
  lastUpdateTime?: utcDateTime;

  /** Project name. */
  name?: string;

  /** Project revision. */
  revision?: int64;

  /** Project state. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectState",
      values: #[
        #{ value: "deleting", description: "Project is in the process of being deleted." },
        #{ value: "new", description: "Project is in the process of being created." },
        #{ value: "wellFormed", description: "Project is completely created and ready to use." },
        #{
          value: "createPending",
          description: "Project has been queued for creation, but the process has not yet started.",
        },
        #{ value: "all", description: "All projects regardless of state except Deleted." },
        #{ value: "unchanged", description: "Project has not been changed." },
        #{ value: "deleted", description: "Project has been deleted." }
      ],
    }
  )
  state?: "deleting" | "new" | "wellFormed" | "createPending" | "all" | "unchanged" | "deleted";

  /** Url to the full version of the object. */
  url?: string;

  /** Project visibility. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectVisibility",
      values: #[
        #{
          value: "private",
          description: "The project is only visible to users with explicit access.",
        },
        #{ value: "public", description: "The project is visible to all." }
      ],
    }
  )
  visibility?: "private" | "public";
}

/** Class representing a branch object. */
model TfvcBranch {
  ...TfvcBranchRef;

  /** List of children for the branch. */
  children?: TfvcBranch[];

  /** List of branch mappings. */
  mappings?: TfvcBranchMapping[];

  parent?: TfvcShallowBranchRef;

  /** List of paths of the related branches. */
  relatedBranches?: TfvcShallowBranchRef[];
}

/** A branch mapping. */
model TfvcBranchMapping {
  /** Depth of the branch. */
  depth?: string;

  /** Server item for the branch. */
  serverItem?: string;

  /** Type of the branch. */
  type?: string;
}

/** Metadata for a branchref. */
model TfvcBranchRef {
  ...TfvcShallowBranchRef;
  _links?: ReferenceLinks;

  /** Creation date of the branch. */
  createdDate?: utcDateTime;

  /** Branch description. */
  description?: string;

  /** Is the branch deleted? */
  isDeleted?: boolean;

  owner?: IdentityRef;

  /** URL to retrieve the item. */
  url?: string;
}

/** A change. */
model TfvcChange {
  ...Change;

  /** List of merge sources in case of rename or branch creation. */
  mergeSources?: TfvcMergeSource[];

  /** Version at which a (shelved) change was pended against */
  pendingVersion?: int32;
}

/** A collection of changes. */
model TfvcChangeset {
  ...TfvcChangesetRef;

  /** Changeset Account Id also known as Organization Id. */
  @format("uuid") accountId?: string;

  /** List of associated changes. */
  changes?: TfvcChange[];

  /** List of Checkin Notes for the changeset. */
  checkinNotes?: CheckinNote[];

  /** Changeset collection Id. */
  @format("uuid") collectionId?: string;

  /** True if more changes are available. */
  hasMoreChanges?: boolean;

  policyOverride?: TfvcPolicyOverrideInfo;

  /** Team Project Ids for the changeset. */
  teamProjectIds?: string[];

  /** List of work items associated with the changeset. */
  workItems?: AssociatedWorkItem[];
}

/** Metadata for a changeset. */
model TfvcChangesetRef {
  _links?: ReferenceLinks;
  author?: IdentityRef;

  /** Changeset Id. */
  changesetId?: int32;

  checkedInBy?: IdentityRef;

  /** Comment for the changeset. */
  comment?: string;

  /** Was the Comment result truncated? */
  commentTruncated?: boolean;

  /** Creation date of the changeset. */
  createdDate?: utcDateTime;

  /** URL to retrieve the item. */
  url?: string;
}

/** Criteria used in a search for change lists. */
model TfvcChangesetSearchCriteria {
  /** Alias or display name of user who made the changes. */
  author?: string;

  /** Whether or not to follow renames for the given item being queried. */
  followRenames?: boolean;

  /** If provided, only include changesets created after this date (string). */
  fromDate?: string;

  /** If provided, only include changesets after this changesetID. */
  fromId?: int32;

  /** Whether to include the _links field on the shallow references. */
  includeLinks?: boolean;

  /** Path of item to search under. */
  itemPath?: string;

  mappings?: TfvcMappingFilter[];

  /** If provided, only include changesets created before this date (string). */
  toDate?: string;

  /** If provided, a version descriptor for the latest change list to include. */
  toId?: int32;
}

/** Request body for Get batched changesets. */
model TfvcChangesetsRequestData {
  /** List of changeset Ids. */
  changesetIds?: int32[];

  /** Max length of the comment. */
  commentLength?: int32;

  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;
}

/** Metadata for an item. */
model TfvcItem {
  ...ItemModel;

  /** Item changed datetime. */
  changeDate?: utcDateTime;

  /** Greater than 0 if item is deleted. */
  deletionId?: int32;

  /** File encoding from database, -1 represents binary. */
  encoding?: int32;

  /** MD5 hash as a base 64 string, applies to files only. */
  hashValue?: string;

  /** True if item is a branch. */
  isBranch?: boolean;

  /** True if there is a change pending. */
  isPendingChange?: boolean;

  /** The size of the file, if applicable. */
  size?: int64;

  /** Changeset version Id. */
  version?: int32;
}

/** Item path and Version descriptor properties */
model TfvcItemDescriptor {
  /** Item path. */
  path?: string;

  /** Defaults to OneLevel. */
  @extension(
    "x-ms-enum",
    #{
      name: "VersionControlRecursionType",
      values: #[
        #{ value: "none", description: "Only return the specified item." },
        #{ value: "oneLevel", description: "Return the specified item and its direct children." },
        #{
          value: "oneLevelPlusNestedEmptyFolders",
          description: "Return the specified item and its direct children, as well as recursive chains of nested child folders that only contain a single folder.",
        },
        #{ value: "full", description: "Return specified item and all descendants" }
      ],
    }
  )
  recursionLevel?: "none" | "oneLevel" | "oneLevelPlusNestedEmptyFolders" | "full";

  /** Specify the desired version, can be null or empty string only if VersionType is latest or tip. */
  version?: string;

  /** Defaults to None. */
  @extension(
    "x-ms-enum",
    #{
      name: "TfvcVersionOption",
      values: #[
        #{ value: "none", description: "None." },
        #{ value: "previous", description: "Return the previous version." },
        #{
          value: "useRename",
          description: "Only usuable with versiontype MergeSource and integer versions, uses RenameSource identifier instead of Merge identifier.",
        }
      ],
    }
  )
  versionOption?: "none" | "previous" | "useRename";

  /** Defaults to Latest. */
  @extension(
    "x-ms-enum",
    #{
      name: "TfvcVersionType",
      values: #[
        #{ value: "none", description: "Version is treated as a ChangesetId." },
        #{ value: "changeset", description: "Version is treated as a ChangesetId." },
        #{ value: "shelveset", description: "Version is treated as a Shelveset name and owner." },
        #{ value: "change", description: "Version is treated as a Change." },
        #{ value: "date", description: "Version is treated as a Date." },
        #{
          value: "latest",
          description: "If Version is defined the Latest of that Version will be used, if no version is defined the latest ChangesetId will be used.",
        },
        #{
          value: "tip",
          description: "Version will be treated as a Tip, if no version is defined latest will be used.",
        },
        #{ value: "mergeSource", description: "Version will be treated as a MergeSource." }
      ],
    }
  )
  versionType?:
    | "none"
    | "changeset"
    | "shelveset"
    | "change"
    | "date"
    | "latest"
    | "tip"
    | "mergeSource";
}

/** Request body used by Get Items Batch */
model TfvcItemRequestData {
  /** If true, include metadata about the file type */
  includeContentMetadata?: boolean;

  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;

  itemDescriptors?: TfvcItemDescriptor[];
}

/** Metadata for a label. */
model TfvcLabel {
  ...TfvcLabelRef;

  /** List of items. */
  items?: TfvcItem[];
}

/** Metadata for a Label. */
model TfvcLabelRef {
  _links?: ReferenceLinks;

  /** Label description. */
  description?: string;

  /** Label Id. */
  id?: int32;

  /** Label scope. */
  labelScope?: string;

  /** Last modified datetime for the label. */
  modifiedDate?: utcDateTime;

  /** Label name. */
  name?: string;

  owner?: IdentityRef;

  /** Label Url. */
  url?: string;
}

model TfvcLabelRequestData {
  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;

  itemLabelFilter?: string;
  labelScope?: string;
  maxItemCount?: int32;
  name?: string;
  owner?: string;
}

/** MappingFilter can be used to include or exclude specific paths. */
model TfvcMappingFilter {
  /** True if ServerPath should be excluded. */
  exclude?: boolean;

  /** Path to be included or excluded. */
  serverPath?: string;
}

model TfvcMergeSource {
  /** Indicates if this a rename source. If false, it is a merge source. */
  isRename?: boolean;

  /** The server item of the merge source. */
  serverItem?: string;

  /** Start of the version range. */
  versionFrom?: int32;

  /** End of the version range. */
  versionTo?: int32;
}

/** Policy failure information. */
model TfvcPolicyFailureInfo {
  /** Policy failure message. */
  message?: string;

  /** Name of the policy that failed. */
  policyName?: string;
}

/** Information on the policy override. */
model TfvcPolicyOverrideInfo {
  /** Overidden policy comment. */
  comment?: string;

  /** Information on the failed policy that was overridden. */
  policyFailures?: TfvcPolicyFailureInfo[];
}

/** This is the shallow branchref class. */
model TfvcShallowBranchRef {
  /** Path for the branch. */
  path?: string;
}

/** Metadata for a shelveset. */
model TfvcShelveset {
  ...TfvcShelvesetRef;

  /** List of changes. */
  changes?: TfvcChange[];

  /** List of checkin notes. */
  notes?: CheckinNote[];

  policyOverride?: TfvcPolicyOverrideInfo;

  /** List of associated workitems. */
  workItems?: AssociatedWorkItem[];
}

/** Metadata for a shallow shelveset. */
model TfvcShelvesetRef {
  _links?: ReferenceLinks;

  /** Shelveset comment. */
  comment?: string;

  /** Shelveset comment truncated as applicable. */
  commentTruncated?: boolean;

  /** Shelveset create date. */
  createdDate?: utcDateTime;

  /** Shelveset Id. */
  id?: string;

  /** Shelveset name. */
  name?: string;

  owner?: IdentityRef;

  /** Shelveset Url. */
  url?: string;
}

model TfvcShelvesetRequestData {
  /** Whether to include policyOverride and notes Only applies when requesting a single deep shelveset */
  includeDetails?: boolean;

  /** Whether to include the _links field on the shallow references. Does not apply when requesting a single deep shelveset object. Links will always be included in the deep shelveset. */
  includeLinks?: boolean;

  /** Whether to include workItems */
  includeWorkItems?: boolean;

  /** Max number of changes to include */
  maxChangeCount?: int32;

  /** Max length of comment */
  maxCommentLength?: int32;

  /** Shelveset name */
  name?: string;

  /** Owner's ID. Could be a name or a guid. */
  owner?: string;
}

model TfvcStatistics {
  /** Id of the last changeset the stats are based on. */
  changesetId?: int32;

  /** Count of files at the requested scope. */
  fileCountTotal?: int64;
}

/** Version descriptor properties. */
model TfvcVersionDescriptor {
  /** Version object. */
  version?: string;

  @extension(
    "x-ms-enum",
    #{
      name: "TfvcVersionOption",
      values: #[
        #{ value: "none", description: "None." },
        #{ value: "previous", description: "Return the previous version." },
        #{
          value: "useRename",
          description: "Only usuable with versiontype MergeSource and integer versions, uses RenameSource identifier instead of Merge identifier.",
        }
      ],
    }
  )
  versionOption?: "none" | "previous" | "useRename";
  @extension(
    "x-ms-enum",
    #{
      name: "TfvcVersionType",
      values: #[
        #{ value: "none", description: "Version is treated as a ChangesetId." },
        #{ value: "changeset", description: "Version is treated as a ChangesetId." },
        #{ value: "shelveset", description: "Version is treated as a Shelveset name and owner." },
        #{ value: "change", description: "Version is treated as a Change." },
        #{ value: "date", description: "Version is treated as a Date." },
        #{
          value: "latest",
          description: "If Version is defined the Latest of that Version will be used, if no version is defined the latest ChangesetId will be used.",
        },
        #{
          value: "tip",
          description: "Version will be treated as a Tip, if no version is defined latest will be used.",
        },
        #{ value: "mergeSource", description: "Version will be treated as a MergeSource." }
      ],
    }
  )
  versionType?:
    | "none"
    | "changeset"
    | "shelveset"
    | "change"
    | "date"
    | "latest"
    | "tip"
    | "mergeSource";
}

model VersionControlProjectInfo {
  @extension(
    "x-ms-enum",
    #{
      name: "SourceControlTypes",
      values: #[#{ value: "tfvc", description: "" }, #{ value: "git", description: "" }],
    }
  )
  defaultSourceControlType?: "tfvc" | "git";
  project?: TeamProjectReference;
  supportsGit?: boolean;
  supportsTFVC?: boolean;
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

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `3` {
      /** Version of the API to use. This should be set to '7.2-preview.3' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Changesets {
  /** Retrieve Tfvc changes for a given changeset. */
  @tag("Changesets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "changesetChanges")
  @extension("x-ms-vss-method", "GetChangesetChanges")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/changesets/{id}/changes")
  @get
  GetChangesetChanges(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the changeset. Default: null */
    @extension("x-ms-required", false) @path id: int32,

    /** Number of results to skip. Default: null */
    @query(#{ explode: true }) $skip?: int32,

    /** The maximum number of results to return. Default: null */
    @query(#{ explode: true }) $top?: int32,

    /** Return the next page of results. Default: null */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TfvcChange[]>;

  /** Retrieves the work items associated with a particular changeset. */
  @tag("Changesets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "changesetWorkItems")
  @extension("x-ms-vss-method", "GetChangesetWorkItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/changesets/{id}/workItems")
  @get
  GetChangesetWorkItems(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the changeset. */
    @extension("x-ms-required", false) @path id: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<AssociatedWorkItem[]>;

  /** Returns changesets for a given list of changeset Ids. */
  @tag("Changesets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "changesetsBatch")
  @extension("x-ms-vss-method", "GetBatchedChangesets")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/changesetsbatch")
  @post
  GetBatchedChangesets(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** List of changeset IDs. */
    @body body: TfvcChangesetsRequestData,
  ): Body<TfvcChangesetRef[]>;

  /** Retrieve Tfvc Changesets Note: This is a new version of the GetChangesets API that doesn't expose the unneeded queryParams present in the 1.0 version of the API. */
  @tag("Changesets")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "changesets")
  @extension("x-ms-vss-method", "GetChangesets")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/changesets")
  @get
  GetChangesets(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Include details about associated work items in the response. Default: null */
    @query(#{ explode: true }) maxCommentLength?: int32,

    /** Number of results to skip. Default: null */
    @query(#{ explode: true }) $skip?: int32,

    /** The maximum number of results to return. Default: null */
    @query(#{ explode: true }) $top?: int32,

    /** Results are sorted by ID in descending order by default. Use id asc to sort by ID in ascending order. */
    @query(#{ explode: true }) $orderby?: string,

    /** Alias or display name of user who made the changes. */
    @query(#{ name: "searchCriteria.author", explode: true }) searchCriteriaAuthor?: string,

    /** Whether or not to follow renames for the given item being queried. */
    @query(#{ name: "searchCriteria.followRenames", explode: true }) searchCriteriaFollowRenames?: boolean,

    /** If provided, only include changesets created after this date (string). */
    @query(#{ name: "searchCriteria.fromDate", explode: true }) searchCriteriaFromDate?: string,

    /** If provided, only include changesets after this changesetID. */
    @query(#{ name: "searchCriteria.fromId", explode: true }) searchCriteriaFromId?: int32,

    /** Whether to include the _links field on the shallow references. */
    @query(#{ name: "searchCriteria.includeLinks", explode: true }) searchCriteriaIncludeLinks?: boolean,

    /** Path of item to search under. */
    @query(#{ name: "searchCriteria.itemPath", explode: true }) searchCriteriaItemPath?: string,

    /** Following criteria available (.itemPath, .version, .versionType, .versionOption, .author, .fromId, .toId, .fromDate, .toDate) Default: null */
    @query(#{ name: "searchCriteria.mappings", explode: true }) searchCriteriaMappings?: TfvcMappingFilter[],

    /** If provided, only include changesets created before this date (string). */
    @query(#{ name: "searchCriteria.toDate", explode: true }) searchCriteriaToDate?: string,

    /** If provided, a version descriptor for the latest change list to include. */
    @query(#{ name: "searchCriteria.toId", explode: true }) searchCriteriaToId?: int32,

    ...Parameters.`api-Version-preview`.`3`,
  ): Body<TfvcChangesetRef[]>;

  /** Create a new changeset. Accepts TfvcChangeset as JSON body */
  @tag("Changesets")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "changesets")
  @extension("x-ms-vss-method", "CreateChangeset")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/changesets")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,
    @body body: TfvcChangeset,
  ): TfvcChangesetRef;

  /** Retrieve a Tfvc Changeset */
  @tag("Changesets")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "changesets")
  @extension("x-ms-vss-method", "GetChangeset")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/changesets/{id}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Changeset Id to retrieve. */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Number of changes to return (maximum 100 changes) Default: 0 */
    @query(#{ explode: true }) maxChangeCount?: int32,

    /** Include policy details and check-in notes in the response. Default: false */
    @query(#{ explode: true }) includeDetails?: boolean,

    /** Include workitems. Default: false */
    @query(#{ explode: true }) includeWorkItems?: boolean,

    /** Include details about associated work items in the response. Default: null */
    @query(#{ explode: true }) maxCommentLength?: int32,

    /** Include renames. Default: false */
    @query(#{ explode: true }) includeSourceRename?: boolean,

    /** Number of results to skip. Default: null */
    @query(#{ explode: true }) $skip?: int32,

    /** The maximum number of results to return. Default: null */
    @query(#{ explode: true }) $top?: int32,

    /** Results are sorted by ID in descending order by default. Use id asc to sort by ID in ascending order. */
    @query(#{ explode: true }) $orderby?: string,

    /** Alias or display name of user who made the changes. */
    @query(#{ name: "searchCriteria.author", explode: true }) searchCriteriaAuthor?: string,

    /** Whether or not to follow renames for the given item being queried. */
    @query(#{ name: "searchCriteria.followRenames", explode: true }) searchCriteriaFollowRenames?: boolean,

    /** If provided, only include changesets created after this date (string). */
    @query(#{ name: "searchCriteria.fromDate", explode: true }) searchCriteriaFromDate?: string,

    /** If provided, only include changesets after this changesetID. */
    @query(#{ name: "searchCriteria.fromId", explode: true }) searchCriteriaFromId?: int32,

    /** Whether to include the _links field on the shallow references. */
    @query(#{ name: "searchCriteria.includeLinks", explode: true }) searchCriteriaIncludeLinks?: boolean,

    /** Path of item to search under. */
    @query(#{ name: "searchCriteria.itemPath", explode: true }) searchCriteriaItemPath?: string,

    /** Following criteria available (.itemPath, .version, .versionType, .versionOption, .author, .fromId, .toId, .fromDate, .toDate) Default: null */
    @query(#{ name: "searchCriteria.mappings", explode: true }) searchCriteriaMappings?: TfvcMappingFilter[],

    /** If provided, only include changesets created before this date (string). */
    @query(#{ name: "searchCriteria.toDate", explode: true }) searchCriteriaToDate?: string,

    /** If provided, a version descriptor for the latest change list to include. */
    @query(#{ name: "searchCriteria.toId", explode: true }) searchCriteriaToId?: int32,

    ...Parameters.`api-Version-preview`.`3`,
  ): TfvcChangeset;
}

interface Labels {
  /** Get items under a label. */
  @tag("Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "labelItems")
  @extension("x-ms-vss-method", "GetLabelItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/labels/{labelId}/items")
  @get
  GetLabelItems(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Unique identifier of label */
    @path labelId: string,

    /** Max number of items to return */
    @query(#{ explode: true }) $top?: int32,

    /** Number of items to skip */
    @query(#{ explode: true }) $skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TfvcItem[]>;

  /** Get a collection of shallow label references. */
  @tag("Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "labels")
  @extension("x-ms-vss-method", "GetLabels")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/labels")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Whether to include the _links field on the shallow references */
    @query(#{ name: "requestData.includeLinks", explode: true }) requestDataIncludeLinks?: boolean,

    /** labelScope, name, owner, and itemLabelFilter */
    @query(#{ name: "requestData.itemLabelFilter", explode: true }) requestDataItemLabelFilter?: string,

    /** labelScope, name, owner, and itemLabelFilter */
    @query(#{ name: "requestData.labelScope", explode: true }) requestDataLabelScope?: string,

    /** labelScope, name, owner, and itemLabelFilter */
    @query(#{ name: "requestData.maxItemCount", explode: true }) requestDataMaxItemCount?: int32,

    /** labelScope, name, owner, and itemLabelFilter */
    @query(#{ name: "requestData.name", explode: true }) requestDataName?: string,

    /** labelScope, name, owner, and itemLabelFilter */
    @query(#{ name: "requestData.owner", explode: true }) requestDataOwner?: string,

    /** Max number of labels to return, defaults to 100 when undefined */
    @query(#{ explode: true }) $top?: int32,

    /** Number of labels to skip */
    @query(#{ explode: true }) $skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TfvcLabelRef[]>;

  /** Get a single deep label. */
  @tag("Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "labels")
  @extension("x-ms-vss-method", "GetLabel")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/labels/{labelId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Unique identifier of label */
    @path labelId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Whether to include the _links field on the shallow references */
    @query(#{ name: "requestData.includeLinks", explode: true }) requestDataIncludeLinks?: boolean,

    /** maxItemCount */
    @query(#{ name: "requestData.itemLabelFilter", explode: true }) requestDataItemLabelFilter?: string,

    /** maxItemCount */
    @query(#{ name: "requestData.labelScope", explode: true }) requestDataLabelScope?: string,

    /** maxItemCount */
    @query(#{ name: "requestData.maxItemCount", explode: true }) requestDataMaxItemCount?: int32,

    /** maxItemCount */
    @query(#{ name: "requestData.name", explode: true }) requestDataName?: string,

    /** maxItemCount */
    @query(#{ name: "requestData.owner", explode: true }) requestDataOwner?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TfvcLabel;
}

interface Shelvesets {
  /** Get a single deep shelveset. */
  @tag("Shelvesets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "shelvesets")
  @extension("x-ms-vss-method", "GetShelveset")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/shelvesets")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Shelveset's unique ID */
    @query(#{ explode: true }) shelvesetId: string,

    /** Whether to include policyOverride and notes Only applies when requesting a single deep shelveset */
    @query(#{ name: "requestData.includeDetails", explode: true }) requestDataIncludeDetails?: boolean,

    /** Whether to include the _links field on the shallow references. Does not apply when requesting a single deep shelveset object. Links will always be included in the deep shelveset. */
    @query(#{ name: "requestData.includeLinks", explode: true }) requestDataIncludeLinks?: boolean,

    /** Whether to include workItems */
    @query(#{ name: "requestData.includeWorkItems", explode: true }) requestDataIncludeWorkItems?: boolean,

    /** Max number of changes to include */
    @query(#{ name: "requestData.maxChangeCount", explode: true }) requestDataMaxChangeCount?: int32,

    /** Max length of comment */
    @query(#{ name: "requestData.maxCommentLength", explode: true }) requestDataMaxCommentLength?: int32,

    /** Shelveset name */
    @query(#{ name: "requestData.name", explode: true }) requestDataName?: string,

    /** Owner's ID. Could be a name or a guid. */
    @query(#{ name: "requestData.owner", explode: true }) requestDataOwner?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TfvcShelveset;

  /** Get changes included in a shelveset. */
  @tag("Shelvesets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "shelvesetChanges")
  @extension("x-ms-vss-method", "GetShelvesetChanges")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/shelvesets/changes")
  @get
  GetShelvesetChanges(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Shelveset's unique ID */
    @query(#{ explode: true }) shelvesetId: string,

    /** Max number of changes to return */
    @query(#{ explode: true }) $top?: int32,

    /** Number of changes to skip */
    @query(#{ explode: true }) $skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TfvcChange[]>;

  /** Get work items associated with a shelveset. */
  @tag("Shelvesets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "shelvesetWorkItems")
  @extension("x-ms-vss-method", "GetShelvesetWorkItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tfvc/shelvesets/workitems")
  @get
  GetShelvesetWorkItems(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Shelveset's unique ID */
    @query(#{ explode: true }) shelvesetId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<AssociatedWorkItem[]>;
}

interface Branches {
  /** Get branch hierarchies below the specified scopePath */
  @tag("Branches")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "branches")
  @extension("x-ms-vss-method", "GetBranchRefs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/branches")
  @get
  GetBranchRefs(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Full path to the branch. Default: $/ Examples: $/, $/MyProject, $/MyProject/SomeFolder. */
    @query(#{ explode: true }) scopePath: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Return deleted branches. Default: False */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** Return links. Default: False */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TfvcBranchRef[]>;
}

interface Items {
  /** Post for retrieving a set of items given a list of paths or a long path. Allows for specifying the recursionLevel and version descriptors for each path. */
  @tag("Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "itemBatch")
  @extension("x-ms-vss-method", "GetItemsBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/itembatch")
  @post
  GetItemsBatch(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: TfvcItemRequestData,
  ):
    | {
        @header contentType: "application/zip";
        @body body: unknown[][];
      }
    | Body<unknown[][]>;

  /** Get a list of Tfvc items */
  @tag("Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "items")
  @extension("x-ms-vss-method", "GetItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/tfvc/items")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Version control path of a folder to return multiple items. */
    @query(#{ explode: true }) scopePath?: string,

    /** None (just the item), or OneLevel (contents of a folder). */
    @extension(
      "x-ms-enum",
      #{
        name: "VersionControlRecursionType",
        values: #[
          #{ value: "none", description: "Only return the specified item." },
          #{ value: "oneLevel", description: "Return the specified item and its direct children." },
          #{
            value: "oneLevelPlusNestedEmptyFolders",
            description: "Return the specified item and its direct children, as well as recursive chains of nested child folders that only contain a single folder.",
          },
          #{ value: "full", description: "Return specified item and all descendants" }
        ],
      }
    )
    @query(#{ explode: true })
    recursionLevel?: "none" | "oneLevel" | "oneLevelPlusNestedEmptyFolders" | "full",

    /** True to include links. */
    @query(#{ explode: true }) includeLinks?: boolean,

    /** Version object. */
    @query(#{ name: "versionDescriptor.version", explode: true }) versionDescriptorVersion?: string,

    @extension(
      "x-ms-enum",
      #{
        name: "TfvcVersionOption",
        values: #[
          #{ value: "none", description: "None." },
          #{ value: "previous", description: "Return the previous version." },
          #{
            value: "useRename",
            description: "Only usuable with versiontype MergeSource and integer versions, uses RenameSource identifier instead of Merge identifier.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `versionDescriptor.versionOption`?: "none" | "previous" | "useRename",
    @extension(
      "x-ms-enum",
      #{
        name: "TfvcVersionType",
        values: #[
          #{ value: "none", description: "Version is treated as a ChangesetId." },
          #{ value: "changeset", description: "Version is treated as a ChangesetId." },
          #{ value: "shelveset", description: "Version is treated as a Shelveset name and owner." },
          #{ value: "change", description: "Version is treated as a Change." },
          #{ value: "date", description: "Version is treated as a Date." },
          #{
            value: "latest",
            description: "If Version is defined the Latest of that Version will be used, if no version is defined the latest ChangesetId will be used.",
          },
          #{
            value: "tip",
            description: "Version will be treated as a Tip, if no version is defined latest will be used.",
          },
          #{ value: "mergeSource", description: "Version will be treated as a MergeSource." }
        ],
      }
    )
    @query(#{ explode: true })
    `versionDescriptor.versionType`?:
      | "none"
      | "changeset"
      | "shelveset"
      | "change"
      | "date"
      | "latest"
      | "tip"
      | "mergeSource",
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TfvcItem[]>;
}
