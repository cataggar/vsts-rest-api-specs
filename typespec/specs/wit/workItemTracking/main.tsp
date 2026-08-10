import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "WorkItemTracking" })
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
namespace WorkItemTracking;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AccountMyWorkResult {
  /** True, when length of WorkItemDetails is same as the limit */
  querySizeLimitExceeded?: boolean;

  /** WorkItem Details */
  workItemDetails?: AccountWorkWorkItemModel[];
}

/** Represents Work Item Recent Activity */
model AccountRecentActivityWorkItemModel {
  ...AccountRecentActivityWorkItemModelBase;

  /** Assigned To */
  assignedTo?: string;
}

/** Represents Work Item Recent Activity */
model AccountRecentActivityWorkItemModel2 {
  ...AccountRecentActivityWorkItemModelBase;
  assignedTo?: IdentityRef;
}

/** Represents Work Item Recent Activity */
model AccountRecentActivityWorkItemModelBase {
  /** Date of the last Activity by the user */
  activityDate?: utcDateTime;

  /** Type of the activity */
  @extension(
    "x-ms-enum",
    #{
      name: "WorkItemRecentActivityType",
      values: #[
        #{ value: "visited", description: "" },
        #{ value: "edited", description: "" },
        #{ value: "deleted", description: "" },
        #{ value: "restored", description: "" }
      ],
    }
  )
  activityType?: "visited" | "edited" | "deleted" | "restored" | string;

  /** Last changed date of the work item */
  changedDate?: utcDateTime;

  /** Work Item Id */
  id?: int32;

  /** TeamFoundationId of the user this activity belongs to */
  @format("uuid") identityId?: string;

  /** State of the work item */
  state?: string;

  /** Team project the work item belongs to */
  teamProject?: string;

  /** Title of the work item */
  title?: string;

  /** Type of Work Item */
  workItemType?: string;
}

/** Represents Recent Mention Work Item */
model AccountRecentMentionWorkItemModel {
  /** Assigned To */
  assignedTo?: string;

  /** Work Item Id */
  id?: int32;

  /** Latest date that the user were mentioned */
  mentionedDateField?: utcDateTime;

  /** State of the work item */
  state?: string;

  /** Team project the work item belongs to */
  teamProject?: string;

  /** Title of the work item */
  title?: string;

  /** Type of Work Item */
  workItemType?: string;
}

model AccountWorkWorkItemModel {
  assignedTo?: string;
  changedDate?: utcDateTime;
  id?: int32;
  state?: string;
  teamProject?: string;
  title?: string;
  workItemType?: string;
}

/** Contains criteria for querying work items based on artifact URI. */
model ArtifactUriQuery {
  /** List of artifact URIs to use for querying work items. */
  artifactUris?: string[];
}

/** Defines result of artifact URI query on work items. Contains mapping of work item IDs to artifact URI. */
model ArtifactUriQueryResult {
  /** A Dictionary that maps a list of work item references to the given list of artifact URI. */
  artifactUrisQueryResult?: Record<WorkItemReference[]>;
}

model AttachmentReference {
  @format("uuid") id?: string;
  url?: string;
}

/** Comment on a Work Item. */
model Comment {
  ...WorkItemTrackingResource;
  createdBy?: IdentityRef;

  /** The creation date of the comment. */
  createdDate?: utcDateTime;

  /** Effective Date/time value for adding the comment. Can be optionally different from CreatedDate. */
  createdOnBehalfDate?: utcDateTime;

  createdOnBehalfOf?: IdentityRef;

  /** Represents the possible types for the comment format. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentFormat",
      values: #[#{ value: "markdown", description: "" }, #{ value: "html", description: "" }],
    }
  )
  format?: "markdown" | "html" | string;

  /** The id assigned to the comment. */
  id?: int32;

  /** Indicates if the comment has been deleted. */
  isDeleted?: boolean;

  /** The mentions of the comment. */
  mentions?: CommentMention[];

  modifiedBy?: IdentityRef;

  /** The last modification date of the comment. */
  modifiedDate?: utcDateTime;

  /** The reactions of the comment. */
  reactions?: CommentReaction[];

  /** The text of the comment in HTML format. */
  renderedText?: string;

  /** The text of the comment. */
  text?: string;

  /** The current version of the comment. */
  version?: int32;

  /** The id of the work item this comment belongs to. */
  workItemId?: int32;
}

/** Represents a request to create a work item comment. */
model CommentCreate {
  /** The text of the comment. */
  text?: string;
}

/** Represents a list of work item comments. */
model CommentList {
  ...WorkItemTrackingResource;

  /** List of comments in the current batch. */
  comments?: Comment[];

  /** A string token that can be used to retrieving next page of comments if available. Otherwise null. */
  continuationToken?: string;

  /** The count of comments in the current batch. */
  count?: int32;

  /** Uri to the next page of comments if it is available. Otherwise null. */
  nextPage?: string;

  /** Total count of comments on a work item. */
  totalCount?: int32;
}

model CommentMention {
  ...WorkItemTrackingResource;

  /** The artifact portion of the parsed text. (i.e. the work item's id) */
  artifactId?: string;

  /** The type the parser assigned to the mention. (i.e. person, work item, etc) */
  artifactType?: string;

  /** The comment id of the mention. */
  commentId?: int32;

  /** The resolved target of the mention. An example of this could be a user's tfid */
  targetId?: string;
}

/** Contains information about work item comment reaction for a particular reaction type. */
model CommentReaction {
  ...WorkItemTrackingResource;

  /** The id of the comment this reaction belongs to. */
  commentId?: int32;

  /** Total number of reactions for the CommentReactionType. */
  count?: int32;

  /** Flag to indicate if the current user has engaged on this particular EngagementType (e.g. if they liked the associated comment). */
  isCurrentUserEngaged?: boolean;

  /** Type of the reaction. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentReactionType",
      values: #[
        #{ value: "like", description: "" },
        #{ value: "dislike", description: "" },
        #{ value: "heart", description: "" },
        #{ value: "hooray", description: "" },
        #{ value: "smile", description: "" },
        #{ value: "confused", description: "" }
      ],
    }
  )
  type?: "like" | "dislike" | "heart" | "hooray" | "smile" | "confused" | string;
}

/** Represents a request to update a work item comment. */
model CommentUpdate {
  /** The updated text of the comment. */
  text?: string;
}

/** Represents a specific version of a comment on a work item. */
model CommentVersion {
  ...WorkItemTrackingResource;
  createdBy?: IdentityRef;

  /** The creation date of the comment. */
  createdDate?: utcDateTime;

  /** Effective Date/time value for adding the comment. Can be optionally different from CreatedDate. */
  createdOnBehalfDate?: utcDateTime;

  createdOnBehalfOf?: IdentityRef;

  /** The id assigned to the comment. */
  id?: int32;

  /** Indicates if the comment has been deleted at this version. */
  isDeleted?: boolean;

  modifiedBy?: IdentityRef;

  /** The modification date of the comment for this version. */
  modifiedDate?: utcDateTime;

  /** The rendered content of the comment at this version. */
  renderedText?: string;

  /** The text of the comment at this version. */
  text?: string;

  /** The version number. */
  version?: int32;
}

/** Describes permanently deleted attachment and work items that had links to this attachment. */
model DestroyedAttachment {
  /** Work items with attachment references that have been marked as deleted. */
  affectedWorkItems?: WorkItemReference[];

  attachment?: AttachmentReference;
}

model EmailRecipients {
  /** Plaintext email addresses. */
  emailAddresses?: string[];

  /** TfIds */
  tfIds?: string[];

  /** Unresolved entity ids */
  unresolvedEntityIds?: string[];
}

model ExternalDeployment {
  @format("uuid") artifactId?: string;
  @format("uuid") createdBy?: string;
  description?: string;
  displayName?: string;
  environment?: ExternalEnvironment;
  group?: string;
  pipeline?: ExternalPipeline;
  relatedWorkItemIds?: int32[];
  runId?: int32;
  sequenceNumber?: int32;
  status?: string;
  statusDate?: utcDateTime;
  url?: string;
}

model ExternalEnvironment {
  displayName?: string;
  id?: int32;
  type?: string;
}

model ExternalPipeline {
  displayName?: string;
  id?: int32;
  url?: string;
}

/** Describes a list of dependent fields for a rule. */
model FieldDependentRule {
  ...WorkItemTrackingResource;

  /** The dependent fields. */
  dependentFields?: WorkItemFieldReference[];
}

/** Describes an update request for a work item field. */
model FieldUpdate {
  /** Indicates whether the user wants to restore the field. */
  isDeleted?: boolean;

  /** Indicates whether the user wants to lock the field. */
  isLocked?: boolean;
}

/** Request model for creating a new GitHub connection. Requires a pre-existing ServiceEndpoint (use the ServiceEndpoint API to create one first). */
model GitHubConnectionCreateRequest {
  /** List of GitHub repository URLs to include in the connection. Example: ['https://github.com/owner/repo1', 'https://github.com/owner/repo2'] */
  gitHubRepositoryUrls?: GitHubConnectionRepoModel[];

  /** A fine-grained GH User Token with write access to repositories being added to the connection. */
  gitHubUserToken?: string;

  /** The ID of an existing service endpoint to use for authentication. Create the ServiceEndpoint first using the ServiceEndpoint API with InstallationToken scheme for Boards connections. */
  @format("uuid") serviceEndpointId?: string;
}

/** Response model for GitHub connection creation */
model GitHubConnectionCreateResponse {
  connection?: GitHubConnectionModel;

  /** Results for each repository that was attempted to be added to the connection. Includes repository URL and any error messages. */
  repositoryResults?: GitHubConnectionRepoModel[];

  /** The ID of the ServiceEndpoint that was used for this connection */
  @format("uuid") serviceEndpointId?: string;
}

/** Describes Github connection. */
model GitHubConnectionModel {
  /** Github connection authorization type (f. e. PAT, OAuth) */
  authorizationType?: string;

  createdBy?: IdentityRef;

  /** Github connection id */
  @format("uuid") id?: string;

  /** Whether current Github connection is valid or not */
  isConnectionValid?: boolean;

  /** Github connection name (should contain organization/user name) */
  name?: string;
}

/** Describes Github connection's repo. */
model GitHubConnectionRepoModel {
  /** Error message */
  errorMessage?: string;

  /** Repository web url */
  gitHubRepositoryUrl?: string;
}

/** Describes Github connection's repo bulk request */
model GitHubConnectionReposBatchRequest {
  /** Requested repos urls */
  gitHubRepositoryUrls?: GitHubConnectionRepoModel[];

  /** Operation type (f. e. add, remove) */
  operationType?: string;
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

/** Describes a reference to an identity. */
model IdentityReference {
  ...IdentityRef;

  /** Legacy back-compat property. This has been the WIT specific value from Constants. Will be hidden (but exists) on the client unless they are targeting the newest version */
  name?: string;
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
  `op`?: "add" | "remove" | "replace" | "move" | "copy" | "test" | string;

  /** The path for the operation. In the case of an array, a zero based index can be used to specify the position in the array (e.g. /biscuits/0/name). The '-' character can be used instead of an index to insert at the end of the array (e.g. /biscuits/-). */
  path?: string;

  /** The value for the operation. This is either a primitive or a JToken. */
  value?: {};
}

/** Link description. */
model Link {
  /** Collection of link attributes. */
  attributes?: Record<{}>;

  /** Relation type. */
  rel?: string;

  /** Link url. */
  url?: string;
}

model MailMessage {
  /** The mail body in HTML format. */
  body?: string;

  cc?: EmailRecipients;

  /** The in-reply-to header value */
  inReplyTo?: string;

  /** The Message Id value */
  messageId?: string;

  replyTo?: EmailRecipients;

  /** The mail subject. */
  subject?: string;

  to?: EmailRecipients;
}

/** Stores process ID. */
model ProcessIdModel {
  /** The ID of the process. */
  @format("uuid") typeId?: string;
}

/** Stores project ID and its process ID. */
model ProcessMigrationResultModel {
  /** The ID of the process. */
  @format("uuid") processId?: string;

  /** The ID of the project. */
  @format("uuid") projectId?: string;
}

/** Project work item type state colors */
model ProjectWorkItemStateColors {
  /** Project name */
  projectName?: string;

  /** State colors for all work item type in a project */
  workItemTypeStateColors?: WorkItemTypeStateColors[];
}

/** Result of an update work item type XML update operation. */
model ProvisioningResult {
  /** Details about of the provisioning import events. */
  provisioningImportEvents?: string[];
}

/** Describes a request to get a list of queries */
model QueryBatchGetRequest {
  /** The expand parameters for queries. Possible options are { None, Wiql, Clauses, All, Minimal } */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryExpand",
      values: #[
        #{ value: "none", description: "Expands Columns, Links and ChangeInfo" },
        #{ value: "wiql", description: "Expands Columns, Links, ChangeInfo and WIQL text" },
        #{
          value: "clauses",
          description: "Expands Columns, Links, ChangeInfo, WIQL text and clauses",
        },
        #{ value: "all", description: "Expands all properties" },
        #{ value: "minimal", description: "Displays minimal properties and the WIQL text" }
      ],
    }
  )
  $expand?: "none" | "wiql" | "clauses" | "all" | "minimal" | string;

  /** The flag to control error policy in a query batch request. Possible options are { Fail, Omit }. */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryErrorPolicy",
      values: #[#{ value: "fail", description: "" }, #{ value: "omit", description: "" }],
    }
  )
  errorPolicy?: "fail" | "omit" | string;

  /** The requested query ids */
  ids?: string[];
}

/** Represents an item in the work item query hierarchy. This can be either a query or a folder. */
model QueryHierarchyItem {
  ...WorkItemTrackingResource;

  /** The child query items inside a query folder. */
  children?: QueryHierarchyItem[];

  clauses?: WorkItemQueryClause;

  /** The columns of the query. */
  columns?: WorkItemFieldReference[];

  createdBy?: IdentityReference;

  /** When the query item was created. */
  createdDate?: utcDateTime;

  /** The link query mode. */
  @extension(
    "x-ms-enum",
    #{
      name: "LinkQueryMode",
      values: #[
        #{ value: "workItems", description: "Returns flat list of work items." },
        #{
          value: "linksOneHopMustContain",
          description: "Returns work items where the source, target, and link criteria are all satisfied.",
        },
        #{
          value: "linksOneHopMayContain",
          description: "Returns work items that satisfy the source and link criteria, even if no linked work item satisfies the target criteria.",
        },
        #{
          value: "linksOneHopDoesNotContain",
          description: "Returns work items that satisfy the source, only if no linked work item satisfies the link and target criteria.",
        },
        #{ value: "linksRecursiveMustContain", description: "" },
        #{
          value: "linksRecursiveMayContain",
          description: "Returns work items a hierarchy of work items that by default satisfy the source",
        },
        #{ value: "linksRecursiveDoesNotContain", description: "" }
      ],
    }
  )
  filterOptions?:
    | "workItems"
    | "linksOneHopMustContain"
    | "linksOneHopMayContain"
    | "linksOneHopDoesNotContain"
    | "linksRecursiveMustContain"
    | "linksRecursiveMayContain"
    | "linksRecursiveDoesNotContain"
    | string;

  /** If this is a query folder, indicates if it contains any children. */
  hasChildren?: boolean;

  /** The id of the query item. */
  @format("uuid") id?: string;

  /** Indicates if this query item is deleted. Setting this to false on a deleted query item will undelete it. Undeleting a query or folder will not bring back the permission changes that were previously applied to it. */
  isDeleted?: boolean;

  /** Indicates if this is a query folder or a query. */
  isFolder?: boolean;

  /** Indicates if the WIQL of this query is invalid. This could be due to invalid syntax or a no longer valid area/iteration path. */
  isInvalidSyntax?: boolean;

  /** Indicates if this query item is public or private. */
  isPublic?: boolean;

  lastExecutedBy?: IdentityReference;

  /** When the query was last run. */
  lastExecutedDate?: utcDateTime;

  lastModifiedBy?: IdentityReference;

  /** When the query item was last modified. */
  lastModifiedDate?: utcDateTime;

  linkClauses?: WorkItemQueryClause;

  /** The name of the query item. */
  name?: string;

  /** The path of the query item. */
  path?: string;

  /** The recursion option for use in a tree query. */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryRecursionOption",
      values: #[
        #{
          value: "parentFirst",
          description: "Returns work items that satisfy the source, even if no linked work item satisfies the target and link criteria.",
        },
        #{
          value: "childFirst",
          description: "Returns work items that satisfy the target criteria, even if no work item satisfies the source and link criteria.",
        }
      ],
    }
  )
  queryRecursionOption?: "parentFirst" | "childFirst" | string;

  /** The type of query. */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryType",
      values: #[
        #{ value: "flat", description: "Gets a flat list of work items." },
        #{ value: "tree", description: "Gets a tree of work items showing their link hierarchy." },
        #{ value: "oneHop", description: "Gets a list of work items and their direct links." }
      ],
    }
  )
  queryType?: "flat" | "tree" | "oneHop" | string;

  /** The sort columns of the query. */
  sortColumns?: WorkItemQuerySortColumn[];

  sourceClauses?: WorkItemQueryClause;
  targetClauses?: WorkItemQueryClause;

  /** The WIQL text of the query */
  wiql?: string;
}

model QueryHierarchyItemsResult {
  /** The count of items. */
  count?: int32;

  /** Indicates if the max return limit was hit but there are still more items */
  hasMore?: boolean;

  /** The list of items */
  value?: QueryHierarchyItem[];
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model ReportingWorkItemLinksBatch {
  ...StreamedBatch;
}

model ReportingWorkItemRevisionsBatch {
  ...StreamedBatch;
}

/** The class represents the reporting work item revision filer. */
model ReportingWorkItemRevisionsFilter {
  /** A list of fields to return in work item revisions. Omit this parameter to get all reportable fields. */
  fields?: string[];

  /** Include deleted work item in the result. */
  includeDeleted?: boolean;

  /** Return an identity reference instead of a string value for identity fields. */
  includeIdentityRef?: boolean;

  /** Include only the latest version of a work item, skipping over all previous revisions of the work item. */
  includeLatestOnly?: boolean;

  /** Include tag reference instead of string value for System.Tags field */
  includeTagRef?: boolean;

  /** A list of types to filter the results to specific work item types. Omit this parameter to get work item revisions of all work item types. */
  types?: string[];
}

model SendMailBody {
  fields?: string[];
  ids?: int32[];
  message?: MailMessage;
  @format("uuid") persistenceId?: string;
  projectId?: string;
  sortFields?: string[];
  tempQueryId?: string;
  wiql?: string;
}

/** The class describes reporting work item revision batch. */
model StreamedBatch {
  /** ContinuationToken acts as a waterMark. Used while querying large results. */
  continuationToken?: string;

  /** Returns 'true' if it's last batch, 'false' otherwise. */
  isLastBatch?: boolean;

  /** The next link for the work item. */
  nextLink?: string;

  /** Values such as rel, sourceId, TargetId, ChangedDate, isActive. */
  values?: string[];
}

/** The Team Context for an operation. */
model TeamContext {
  /** The team project Id or name. Ignored if ProjectId is set. */
  project?: string;

  /** The Team Project ID. Required if Project is not set. */
  @format("uuid") projectId?: string;

  /** The Team Id or name. Ignored if TeamId is set. */
  team?: string;

  /** The Team Id */
  @format("uuid") teamId?: string;
}

/** Describes a request to create a temporary query */
model TemporaryQueryRequestModel {
  ...WorkItemTrackingResource;

  /** The WIQL text of the temporary query */
  wiql?: string;
}

/** The result of a temporary query creation. */
model TemporaryQueryResponseModel {
  /** The id of the temporary query item. */
  @format("uuid") id?: string;
}

/** Describes an update request for a work item field. */
model UpdateWorkItemField {
  /** Indicates whether the user wants to restore the field. */
  isDeleted?: boolean;
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

/** A WIQL query */
model Wiql {
  /** The text of the WIQL query */
  query?: string;
}

/** A work artifact link describes an outbound artifact link type. */
model WorkArtifactLink {
  /** Target artifact type. */
  artifactType?: string;

  /** Outbound link type. */
  linkType?: string;

  /** Target tool type. */
  toolType?: string;
}

/** Describes a work item. */
model WorkItem {
  ...WorkItemTrackingResource;
  commentVersionRef?: WorkItemCommentVersionRef;

  /** Map of field and values for the work item. */
  fields?: Record<{}>;

  /** The work item ID. */
  id?: int32;

  /** Dictionary describing the Format for multiline fields selected by the last edit user. */
  multilineFieldsFormat?: Record<"markdown" | "html" | string>;

  /** Relations of the work item. */
  relations?: WorkItemRelation[];

  /** Revision number of the work item. */
  rev?: int32;
}

/** Describes a request to get a set of work items */
model WorkItemBatchGetRequest {
  /** The expand parameters for work item attributes. Possible options are { None, Relations, Fields, Links, All } */
  @extension(
    "x-ms-enum",
    #{
      name: "WorkItemExpand",
      values: #[
        #{ value: "none", description: "Default behavior." },
        #{ value: "relations", description: "Relations work item expand." },
        #{ value: "fields", description: "Fields work item expand." },
        #{ value: "links", description: "Links work item expand." },
        #{ value: "all", description: "Expands all." }
      ],
    }
  )
  $expand?: "none" | "relations" | "fields" | "links" | "all" | string;

  /** AsOf UTC date time string */
  asOf?: utcDateTime;

  /** The flag to control error policy in a bulk get work items request. Possible options are {Fail, Omit}. */
  @extension(
    "x-ms-enum",
    #{
      name: "WorkItemErrorPolicy",
      values: #[
        #{ value: "fail", description: "Fail work error policy." },
        #{ value: "omit", description: "Omit work error policy." }
      ],
    }
  )
  errorPolicy?: "fail" | "omit" | string;

  /** The requested fields */
  fields?: string[];

  /** The requested work item ids */
  ids?: int32[];
}

/** Defines a classification node for work item tracking. */
model WorkItemClassificationNode {
  ...WorkItemTrackingResource;

  /** Dictionary that has node attributes like start/finish date for iteration nodes. */
  attributes?: Record<{}>;

  /** List of child nodes fetched. */
  children?: WorkItemClassificationNode[];

  /** Flag that indicates if the classification node has any child nodes. */
  hasChildren?: boolean;

  /** Integer ID of the classification node. */
  id?: int32;

  /** GUID ID of the classification node. */
  @format("uuid") identifier?: string;

  /** Name of the classification node. */
  name?: string;

  /** Path of the classification node. */
  path?: string;

  /** Node structure type. */
  @extension(
    "x-ms-enum",
    #{
      name: "TreeNodeStructureType",
      values: #[
        #{ value: "area", description: "Area type." },
        #{ value: "iteration", description: "Iteration type." }
      ],
    }
  )
  structureType?: "area" | "iteration" | string;
}

/** Comment on Work Item */
model WorkItemComment {
  ...WorkItemTrackingResource;

  /** Represents the possible types for the comment format. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentFormat",
      values: #[#{ value: "markdown", description: "" }, #{ value: "html", description: "" }],
    }
  )
  format?: "markdown" | "html" | string;

  /** The text of the comment in HTML format. */
  renderedText?: string;

  revisedBy?: IdentityReference;

  /** The date of comment. */
  revisedDate?: utcDateTime;

  /** The work item revision number. */
  revision?: int32;

  /** The text of the comment. */
  text?: string;
}

/** Collection of comments. */
model WorkItemComments {
  ...WorkItemTrackingResource;

  /** Comments collection. */
  comments?: WorkItemComment[];

  /** The count of comments. */
  count?: int32;

  /** Count of comments from the revision. */
  fromRevisionCount?: int32;

  /** Total count of comments. */
  totalCount?: int32;
}

/** Represents the reference to a specific version of a comment on a Work Item. */
model WorkItemCommentVersionRef {
  ...WorkItemTrackingResourceReference;

  /** The id assigned to the comment. */
  commentId?: int32;

  /** [Internal] The work item revision where this comment was originally added. */
  createdInRevision?: int32;

  /** [Internal] Specifies whether comment was deleted. */
  isDeleted?: boolean;

  /** [Internal] The text of the comment. */
  text?: string;

  /** The version number. */
  version?: int32;
}

/** Full deleted work item object. Includes the work item itself. */
model WorkItemDelete {
  ...WorkItemDeleteReference;
  resource?: WorkItem;
}

/** Describes response to delete a set of work items. */
model WorkItemDeleteBatch {
  /** List of results for each work item */
  results?: WorkItemDelete[];
}

/** Describes a request to delete a set of work items */
model WorkItemDeleteBatchRequest {
  /** Optional parameter, if set to true, the work item is deleted permanently. Please note: the destroy action is PERMANENT and cannot be undone. */
  destroy?: boolean;

  /** The requested work item ids */
  ids?: int32[];

  /** Optional parameter, if set to true, notifications will be disabled. */
  skipNotifications?: boolean;
}

/** Reference to a deleted work item. */
model WorkItemDeleteReference {
  /** The HTTP status code for work item operation in a batch request. */
  code?: int32;

  /** The user who deleted the work item type. */
  deletedBy?: string;

  /** The work item deletion date. */
  deletedDate?: string;

  /** Work item ID. */
  id?: int32;

  /** The exception message for work item operation in a batch request. */
  message?: string;

  /** Name or title of the work item. */
  name?: string;

  /** Parent project of the deleted work item. */
  project?: string;

  /** Type of work item. */
  type?: string;

  /** REST API URL of the resource */
  url?: string;
}

/** Shallow Reference to a deleted work item. */
model WorkItemDeleteShallowReference {
  /** Work item ID. */
  id?: int32;

  /** REST API URL of the resource */
  url?: string;
}

/** Describes an update request for a deleted work item. */
model WorkItemDeleteUpdate {
  /** Sets a value indicating whether this work item is deleted. */
  isDeleted?: boolean;
}

/** Describes a field on a work item and it's properties specific to that work item type. */
model WorkItemField {
  ...WorkItemTrackingResource;

  /** Indicates whether the field is sortable in server queries. */
  canSortBy?: boolean;

  /** The description of the field. */
  description?: string;

  /** Indicates whether this field is deleted. */
  isDeleted?: boolean;

  /** Indicates whether this field is an identity field. */
  isIdentity?: boolean;

  /** Indicates whether this instance is picklist. */
  isPicklist?: boolean;

  /** Indicates whether this instance is a suggested picklist . */
  isPicklistSuggested?: boolean;

  /** Indicates whether the field can be queried in the server. */
  isQueryable?: boolean;

  /** The name of the field. */
  name?: string;

  /** If this field is picklist, the identifier of the picklist associated, otherwise null */
  @format("uuid") picklistId?: string;

  /** Indicates whether the field is [read only]. */
  readOnly?: boolean;

  /** The reference name of the field. */
  referenceName?: string;

  /** The supported operations on this field. */
  supportedOperations?: WorkItemFieldOperation[];

  /** The type of the field. */
  @extension(
    "x-ms-enum",
    #{
      name: "FieldType",
      values: #[
        #{ value: "string", description: "String field type." },
        #{ value: "integer", description: "Integer field type." },
        #{ value: "dateTime", description: "Datetime field type." },
        #{ value: "plainText", description: "Plain text field type." },
        #{ value: "html", description: "HTML (Multiline) field type." },
        #{ value: "treePath", description: "Treepath field type." },
        #{ value: "history", description: "History field type." },
        #{ value: "double", description: "Double field type." },
        #{ value: "guid", description: "Guid field type." },
        #{ value: "boolean", description: "Boolean field type." },
        #{ value: "identity", description: "Identity field type." },
        #{
          value: "picklistString",
          description: "String picklist field type. When creating a string picklist field from REST API, use 'String' FieldType.",
        },
        #{
          value: "picklistInteger",
          description: "Integer picklist field type. When creating a integer picklist field from REST API, use 'Integer' FieldType.",
        },
        #{
          value: "picklistDouble",
          description: "Double picklist field type. When creating a double picklist field from REST API, use 'Double' FieldType.",
        }
      ],
    }
  )
  type?:
    | "string"
    | "integer"
    | "dateTime"
    | "plainText"
    | "html"
    | "treePath"
    | "history"
    | "double"
    | "guid"
    | "boolean"
    | "identity"
    | "picklistString"
    | "picklistInteger"
    | "picklistDouble"
    | string;

  /** The usage of the field. */
  @extension(
    "x-ms-enum",
    #{
      name: "FieldUsage",
      values: #[
        #{ value: "none", description: "Empty usage." },
        #{ value: "workItem", description: "Work item field usage." },
        #{ value: "workItemLink", description: "Work item link field usage." },
        #{ value: "tree", description: "Treenode field usage." },
        #{ value: "workItemTypeExtension", description: "Work Item Type Extension usage." }
      ],
    }
  )
  usage?: "none" | "workItem" | "workItemLink" | "tree" | "workItemTypeExtension" | string;
}

/** Describes a field on a work item and it's properties specific to that work item type. */
model WorkItemField2 {
  ...WorkItemField;

  /** Indicates whether this field is marked as locked for editing. */
  isLocked?: boolean;
}

/** Describes the list of allowed values of the field. */
model WorkItemFieldAllowedValues {
  /** The list of field allowed values. */
  allowedValues?: string[];

  /** Name of the field. */
  fieldName?: string;
}

/** Describes a work item field operation. */
model WorkItemFieldOperation {
  /** Friendly name of the operation. */
  name?: string;

  /** Reference name of the operation. */
  referenceName?: string;
}

/** Reference to a field in a work item */
model WorkItemFieldReference {
  /** The friendly name of the field. */
  name?: string;

  /** The reference name of the field. */
  referenceName?: string;

  /** The REST URL of the resource. */
  url?: string;
}

/** Describes an update to a work item field. */
model WorkItemFieldUpdate {
  /** The new value of the field. */
  newValue?: {};

  /** The old value of the field. */
  oldValue?: {};
}

model WorkItemHistory {
  ...WorkItemTrackingResource;
  rev?: int32;
  revisedBy?: IdentityReference;
  revisedDate?: utcDateTime;
  value?: string;
}

/** Reference to a work item icon. */
model WorkItemIcon {
  /** The identifier of the icon. */
  id?: string;

  /** The REST URL of the resource. */
  url?: string;
}

/** A link between two work items. */
model WorkItemLink {
  /** The type of link. */
  rel?: string;

  source?: WorkItemReference;
  target?: WorkItemReference;
}

/** Describes the next state for a work item. */
model WorkItemNextStateOnTransition {
  /** Error code if there is no next state transition possible. */
  errorCode?: string;

  /** Work item ID. */
  id?: int32;

  /** Error message if there is no next state transition possible. */
  message?: string;

  /** Name of the next state on transition. */
  stateOnTransition?: string;
}

/** Represents a clause in a work item query. This shows the structure of a work item query. */
model WorkItemQueryClause {
  /** Child clauses if the current clause is a logical operator */
  clauses?: WorkItemQueryClause[];

  field?: WorkItemFieldReference;
  fieldValue?: WorkItemFieldReference;

  /** Determines if this is a field to field comparison */
  isFieldValue?: boolean;

  /** Logical operator separating the condition clause */
  @extension(
    "x-ms-enum",
    #{
      name: "LogicalOperation",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "and", description: "" },
        #{ value: "or", description: "" }
      ],
    }
  )
  logicalOperator?: "none" | "and" | "or" | string;

  operator?: WorkItemFieldOperation;

  /** Right side of the condition when a field to value comparison */
  value?: string;
}

/** The result of a work item query. */
model WorkItemQueryResult {
  /** The date the query was run in the context of. */
  asOf?: utcDateTime;

  /** The columns of the query. */
  columns?: WorkItemFieldReference[];

  /** The result type */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryResultType",
      values: #[
        #{ value: "workItem", description: "A list of work items (for flat queries)." },
        #{
          value: "workItemLink",
          description: "A list of work item links (for OneHop and Tree queries).",
        }
      ],
    }
  )
  queryResultType?: "workItem" | "workItemLink" | string;

  /** The type of the query */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryType",
      values: #[
        #{ value: "flat", description: "Gets a flat list of work items." },
        #{ value: "tree", description: "Gets a tree of work items showing their link hierarchy." },
        #{ value: "oneHop", description: "Gets a list of work items and their direct links." }
      ],
    }
  )
  queryType?: "flat" | "tree" | "oneHop" | string;

  /** The sort columns of the query. */
  sortColumns?: WorkItemQuerySortColumn[];

  /** The work item links returned by the query. */
  workItemRelations?: WorkItemLink[];

  /** The work items returned by the query. */
  workItems?: WorkItemReference[];
}

/** A sort column. */
model WorkItemQuerySortColumn {
  /** The direction to sort by. */
  descending?: boolean;

  field?: WorkItemFieldReference;
}

/** Contains reference to a work item. */
model WorkItemReference {
  /** Work item ID. */
  id?: int32;

  /** REST API URL of the resource */
  url?: string;
}

model WorkItemRelation {
  ...Link;
}

/** Represents the work item type relation type. */
model WorkItemRelationType {
  ...WorkItemTrackingReference;

  /** The collection of relation type attributes. */
  attributes?: Record<{}>;
}

/** Describes updates to a work item's relations. */
model WorkItemRelationUpdates {
  /** List of newly added relations. */
  added?: WorkItemRelation[];

  /** List of removed relations. */
  removed?: WorkItemRelation[];

  /** List of updated relations. */
  updated?: WorkItemRelation[];
}

/** Work item type state name, color and state category */
model WorkItemStateColor {
  /** Category of state */
  category?: string;

  /** Color value */
  color?: string;

  /** Work item type state name */
  name?: string;
}

/** Describes a state transition in a work item. */
model WorkItemStateTransition {
  /** Gets a list of actions needed to transition to that state. */
  actions?: string[];

  /** Name of the next state. */
  to?: string;
}

model WorkItemTagDefinition {
  @format("uuid") id?: string;
  lastUpdated?: utcDateTime;
  name?: string;
  url?: string;
}

/** Describes a work item template. */
model WorkItemTemplate {
  ...WorkItemTemplateReference;

  /** Mapping of field and its templated value. */
  fields?: Record<string>;
}

/** Describes a shallow reference to a work item template. */
model WorkItemTemplateReference {
  ...WorkItemTrackingResource;

  /** The description of the work item template. */
  description?: string;

  /** The identifier of the work item template. */
  @format("uuid") id?: string;

  /** The name of the work item template. */
  name?: string;

  /** The name of the work item type. */
  workItemTypeName?: string;
}

model WorkItemTrackingReference {
  ...WorkItemTrackingResource;

  /** The name. */
  name?: string;

  /** The reference name. */
  referenceName?: string;
}

/** Base class for WIT REST resources. */
model WorkItemTrackingResource {
  ...WorkItemTrackingResourceReference;
  _links?: ReferenceLinks;
}

/** Base class for work item tracking resource references. */
model WorkItemTrackingResourceReference {
  /** REST URL for the resource. */
  url?: string;
}

/** Describes a work item type. */
model WorkItemType {
  ...WorkItemTrackingResource;

  /** The color. */
  color?: string;

  /** The description of the work item type. */
  description?: string;

  /** The fields that exist on the work item type. */
  fieldInstances?: WorkItemTypeFieldInstance[];

  /** The fields that exist on the work item type. */
  fields?: WorkItemTypeFieldInstance[];

  icon?: WorkItemIcon;

  /** True if work item type is disabled */
  isDisabled?: boolean;

  /** Gets the name of the work item type. */
  name?: string;

  /** The reference name of the work item type. */
  referenceName?: string;

  /** Gets state information for the work item type. */
  states?: WorkItemStateColor[];

  /** Gets the various state transition mappings in the work item type. */
  transitions?: Record<WorkItemStateTransition[]>;

  /** The XML form. */
  xmlForm?: string;
}

/** Describes a work item type category. */
model WorkItemTypeCategory {
  ...WorkItemTrackingResource;
  defaultWorkItemType?: WorkItemTypeReference;

  /** The name of the category. */
  name?: string;

  /** The reference name of the category. */
  referenceName?: string;

  /** The work item types that belong to the category. */
  workItemTypes?: WorkItemTypeReference[];
}

/** Describes a work item type's colors. */
model WorkItemTypeColor {
  /** Gets or sets the color of the primary. */
  primaryColor?: string;

  /** Gets or sets the color of the secondary. */
  secondaryColor?: string;

  /** The name of the work item type. */
  workItemTypeName?: string;
}

/** Describes work item type name, its icon and color. */
model WorkItemTypeColorAndIcon {
  /** The color of the work item type in hex format. */
  color?: string;

  /** The work item type icon. */
  icon?: string;

  /** Indicates if the work item is disabled in the process. */
  isDisabled?: boolean;

  /** The name of the work item type. */
  workItemTypeName?: string;
}

/** Field instance of a work item type. */
model WorkItemTypeFieldInstance {
  ...WorkItemTypeFieldInstanceBase;

  /** The list of field allowed values. */
  allowedValues?: string[];

  /** Represents the default value of the field. */
  defaultValue?: string;
}

/** Base field instance for workItemType fields. */
model WorkItemTypeFieldInstanceBase {
  ...WorkItemFieldReference;

  /** Indicates whether field value is always required. */
  alwaysRequired?: boolean;

  /** The list of dependent fields. */
  dependentFields?: WorkItemFieldReference[];

  /** Gets the help text for the field. */
  helpText?: string;
}

/** Field Instance of a workItemype with detailed references. */
model WorkItemTypeFieldWithReferences {
  ...WorkItemTypeFieldInstanceBase;

  /** The list of field allowed values. */
  allowedValues?: {}[];

  /** Represents the default value of the field. */
  defaultValue?: {};
}

/** Reference to a work item type. */
model WorkItemTypeReference {
  ...WorkItemTrackingResourceReference;

  /** Name of the work item type. */
  name?: string;
}

/** State colors for a work item type */
model WorkItemTypeStateColors {
  /** Work item type state colors */
  stateColors?: WorkItemStateColor[];

  /** Work item type name */
  workItemTypeName?: string;
}

/** Describes a work item type template. */
model WorkItemTypeTemplate {
  /** XML template in string format. */
  template?: string;
}

/** Describes a update work item type template request body. */
model WorkItemTypeTemplateUpdateModel {
  /** Describes the type of the action for the update request. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProvisioningActionType",
      values: #[#{ value: "import", description: "" }, #{ value: "validate", description: "" }],
    }
  )
  actionType?: "import" | "validate" | string;

  /** Methodology to which the template belongs, eg. Agile, Scrum, CMMI. */
  methodology?: string;

  /** String representation of the work item type template. */
  template?: string;

  /** The type of the template described in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "TemplateType",
      values: #[
        #{ value: "workItemType", description: "" },
        #{ value: "globalWorkflow", description: "" }
      ],
    }
  )
  templateType?: "workItemType" | "globalWorkflow" | string;
}

/** Describes an update to a work item. */
model WorkItemUpdate {
  ...WorkItemTrackingResource;

  /** List of updates to fields. */
  fields?: Record<WorkItemFieldUpdate>;

  /** ID of update. */
  id?: int32;

  relations?: WorkItemRelationUpdates;

  /** The revision number of work item update. */
  rev?: int32;

  revisedBy?: IdentityReference;

  /** The work item updates revision date. */
  revisedDate?: utcDateTime;

  /** The work item ID. */
  workItemId?: int32;
}

/** A collection of `WorkArtifactLink` as returned by Azure DevOps. */
model WorkArtifactLinkList {
  count?: int32;
  value?: WorkArtifactLink[];
}

/** A collection of `WorkItemIcon` as returned by Azure DevOps. */
model WorkItemIconList {
  count?: int32;
  value?: WorkItemIcon[];
}

/** A collection of `WorkItemRelationType` as returned by Azure DevOps. */
model WorkItemRelationTypeList {
  count?: int32;
  value?: WorkItemRelationType[];
}

/** A collection of `WorkItemNextStateOnTransition` as returned by Azure DevOps. */
model WorkItemNextStateOnTransitionList {
  count?: int32;
  value?: WorkItemNextStateOnTransition[];
}

/** A collection of `AccountRecentActivityWorkItemModel2` as returned by Azure DevOps. */
model AccountRecentActivityWorkItemModel2List {
  count?: int32;
  value?: AccountRecentActivityWorkItemModel2[];
}

/** A collection of `GitHubConnectionModel` as returned by Azure DevOps. */
model GitHubConnectionModelList {
  count?: int32;
  value?: GitHubConnectionModel[];
}

/** A collection of `GitHubConnectionRepoModel` as returned by Azure DevOps. */
model GitHubConnectionRepoModelList {
  count?: int32;
  value?: GitHubConnectionRepoModel[];
}

/** A collection of `WorkItemClassificationNode` as returned by Azure DevOps. */
model WorkItemClassificationNodeList {
  count?: int32;
  value?: WorkItemClassificationNode[];
}

/** A collection of `WorkItemField2` as returned by Azure DevOps. */
model WorkItemField2List {
  count?: int32;
  value?: WorkItemField2[];
}

/** A collection of `QueryHierarchyItem` as returned by Azure DevOps. */
model QueryHierarchyItemList {
  count?: int32;
  value?: QueryHierarchyItem[];
}

/** A collection of `WorkItemDeleteShallowReference` as returned by Azure DevOps. */
model WorkItemDeleteShallowReferenceList {
  count?: int32;
  value?: WorkItemDeleteShallowReference[];
}

/** A collection of `WorkItemTagDefinition` as returned by Azure DevOps. */
model WorkItemTagDefinitionList {
  count?: int32;
  value?: WorkItemTagDefinition[];
}

/** A collection of `WorkItem` as returned by Azure DevOps. */
model WorkItemList {
  count?: int32;
  value?: WorkItem[];
}

/** A collection of `WorkItemUpdate` as returned by Azure DevOps. */
model WorkItemUpdateList {
  count?: int32;
  value?: WorkItemUpdate[];
}

/** A collection of `CommentReaction` as returned by Azure DevOps. */
model CommentReactionList {
  count?: int32;
  value?: CommentReaction[];
}

/** A collection of `IdentityRef` as returned by Azure DevOps. */
model IdentityRefList {
  count?: int32;
  value?: IdentityRef[];
}

/** A collection of `CommentVersion` as returned by Azure DevOps. */
model CommentVersionList {
  count?: int32;
  value?: CommentVersion[];
}

/** A collection of `WorkItemTypeCategory` as returned by Azure DevOps. */
model WorkItemTypeCategoryList {
  count?: int32;
  value?: WorkItemTypeCategory[];
}

/** A collection of `WorkItemType` as returned by Azure DevOps. */
model WorkItemTypeList {
  count?: int32;
  value?: WorkItemType[];
}

/** A collection of `WorkItemTypeFieldWithReferences` as returned by Azure DevOps. */
model WorkItemTypeFieldWithReferencesList {
  count?: int32;
  value?: WorkItemTypeFieldWithReferences[];
}

/** A collection of `WorkItemStateColor` as returned by Azure DevOps. */
model WorkItemStateColorList {
  count?: int32;
  value?: WorkItemStateColor[];
}

/** A collection of `WorkItemTemplateReference` as returned by Azure DevOps. */
model WorkItemTemplateReferenceList {
  count?: int32;
  value?: WorkItemTemplateReference[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `3` {
      /** Version of the API to use. This should be set to '7.2-preview.3' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `4` {
      /** Version of the API to use. This should be set to '7.2-preview.4' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface ArtifactLinkTypes {
  /** Get the list of work item tracking outbound artifact link types. */
  @tag("Artifact Link Types")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "artifactLinkTypes")
  @extension("x-ms-vss-method", "GetWorkArtifactLinkTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/wit/artifactlinktypes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkArtifactLinkList;
}

interface WorkItemIcons {
  /** Get a list of all work item icons. */
  @tag("Work Item Icons")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemIcons")
  @extension("x-ms-vss-method", "GetWorkItemIcons")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/wit/workitemicons")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemIconList;

  /** Get a work item icon given the friendly name and icon color. */
  @tag("Work Item Icons")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemIcons")
  @extension("x-ms-vss-method", "GetWorkItemIcon")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/wit/workitemicons/{icon}")
  @get
  Get(
    /** The name of the icon */
    @path icon: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** The 6-digit hex color for the icon */
    @query(#{ explode: true }) color?: string,

    /** The version of the icon (used only for cache invalidation) */
    @query(#{ explode: true }) v?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header contentType: "image/svg+xml";
        @body body: WorkItemIcon;
      }
    | {
        @header contentType: "image/xaml+xml";
        @body body: WorkItemIcon;
      }
    | WorkItemIcon;
}

interface WorkItemRelationTypes {
  /** Gets the work item relation types. */
  @tag("Work Item Relation Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemRelationTypes")
  @extension("x-ms-vss-method", "GetRelationTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/wit/workitemrelationtypes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemRelationTypeList;

  /** Gets the work item relation type definition. */
  @tag("Work Item Relation Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemRelationTypes")
  @extension("x-ms-vss-method", "GetRelationType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/wit/workitemrelationtypes/{relation}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The relation name */
    @path relation: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemRelationType;
}

interface WorkItemTransitions {
  /** Returns the next state on the given work item IDs. */
  @tag("Work Item Transitions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTransitions")
  @extension("x-ms-vss-method", "GetWorkItemNextStatesOnCheckinAction")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/wit/workitemtransitions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** list of work item ids */
    @format("array (int32)") @query(#{ explode: true }) ids: string,

    /** possible actions. Currently only supports checkin */
    @query(#{ explode: true }) action?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemNextStateOnTransitionList;
}

interface AccountMyWorkRecentActivity {
  /** Gets recent work item activities */
  @tag("Account My Work Recent Activity")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "accountMyWorkRecentActivity")
  @extension("x-ms-vss-method", "GetRecentActivityData")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/accountmyworkrecentactivity")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): AccountRecentActivityWorkItemModel2List;
}

interface GithubConnections {
  /** Gets a list of github connections */
  @tag("Github Connections")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "githubConnections")
  @extension("x-ms-vss-method", "GetGithubConnections")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/githubconnections")
  @get
  GetGithubConnections(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitHubConnectionModelList;

  /** Gets a list of repos within specified github connection. */
  @tag("Github Connections")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "githubConnections")
  @extension("x-ms-vss-method", "GetGithubConnectionRepositories")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/githubconnections/{connectionId}/repos")
  @get
  GetGithubConnectionRepositories(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @format("uuid") @path connectionId: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): GitHubConnectionRepoModelList;

  /** Add/remove list of repos within specified github connection. */
  @tag("Github Connections")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "githubConnections")
  @extension("x-ms-vss-method", "UpdateGithubConnectionRepos")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/githubconnections/{connectionId}/reposBatch")
  @post
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @format("uuid") @path connectionId: string,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: GitHubConnectionReposBatchRequest,
  ): GitHubConnectionRepoModelList;
}

interface ArtifactUriQueryOperations {
  /** Queries work items linked to a given list of artifact URI. */
  @tag("Artifact Uri Query")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "artifactUriQuery")
  @extension("x-ms-vss-method", "QueryWorkItemsForArtifactUris")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/artifacturiquery")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Defines a list of artifact URI for querying work items. */
    @body body: ArtifactUriQuery,
  ): ArtifactUriQueryResult;
}

interface Attachments {
  /** Uploads an attachment. On accounts with higher attachment upload limits (>130MB), you will need to use chunked upload. To upload an attachment in multiple chunks, you first need to [**Start a Chunked Upload**](#start_a_chunked_upload) and then follow the example from the **Upload Chunk** section. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "CreateAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/attachments")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The name of the file */
    @query(#{ explode: true }) fileName?: string,

    /** Attachment upload type: Simple or Chunked */
    @query(#{ explode: true }) uploadType?: string,

    /** Target project Area Path */
    @query(#{ explode: true }) areaPath?: string,

    ...Parameters.`api-Version-preview`.`4`,
    @header contentType: "application/octet-stream",

    /** Stream to upload */
    @body body: string,
  ): AttachmentReference;

  /** Permanently delete an attachment. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "DeleteAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/attachments/{id}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Attachment ID */
    @format("uuid") @path id: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`4`,
  ): DestroyedAttachment;

  /** Downloads an attachment. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/attachments/{id}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Attachment ID */
    @format("uuid") @path id: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Name of the file */
    @query(#{ explode: true }) fileName?: string,

    /** If set to <c>true</c> always download attachment */
    @query(#{ explode: true }) download?: boolean,

    ...Parameters.`api-Version-preview`.`4`,
  ):
    | {
        @header contentType: "application/octet-stream";
        @body @format("Stream") body: string;
      }
    | {
        @header contentType: "application/zip";
        @body @format("Stream") body: string;
      };

  /** Uploads an attachment chunk. Before performing [**Upload a Chunk**](#upload-a-chunk), make sure to have an attachment id returned in **Start a Chunked Upload** example on **Create** section. Specify the byte range of the chunk using Content-Length. For example: 'Content - Length': 'bytes 0 - 39999 / 50000' for the first 40000 bytes of a 50000 byte file. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "UploadAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/attachments/{id}")
  @put
  UploadChunk(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The id of the attachment */
    @format("uuid") @path id: string,

    /** starting and ending byte positions for chunked file upload, format is 'Content-Range': 'bytes 0-10000/50000' */
    @header contentRangeHeader: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    @query(#{ explode: true }) fileName?: string,
    ...Parameters.`api-Version-preview`.`4`,
    @header contentType: "application/octet-stream",

    /** Stream to upload */
    @body body: string,
  ): AttachmentReference;
}

interface ClassificationNodes {
  /** Gets root classification nodes under the project. */
  @tag("Classification Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "classificationNodes")
  @extension("x-ms-vss-method", "GetRootNodes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/classificationnodes")
  @get
  GetRootNodes(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Depth of children to fetch. */
    @query(#{ explode: true }) $depth?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemClassificationNodeList;

  /** Delete an existing classification node. */
  @tag("Classification Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "classificationNodes")
  @extension("x-ms-vss-method", "DeleteClassificationNode")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/classificationnodes/{structureGroup}/{path}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Structure group of the classification node, area or iteration. */
    @extension(
      "x-ms-enum",
      #{
        name: "TreeStructureGroup",
        values: #[#{ value: "areas", description: "" }, #{ value: "iterations", description: "" }],
      }
    )
    @path
    structureGroup: "areas" | "iterations",

    /** Path of the classification node. */
    @extension("x-ms-required", false) @path path: string,

    /** Id of the target classification node for reclassification. */
    @query(#{ explode: true }) $reclassifyId?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Gets the classification node for a given node path. */
  @tag("Classification Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "classificationNodes")
  @extension("x-ms-vss-method", "GetClassificationNode")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/classificationnodes/{structureGroup}/{path}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Structure group of the classification node, area or iteration. */
    @extension(
      "x-ms-enum",
      #{
        name: "TreeStructureGroup",
        values: #[#{ value: "areas", description: "" }, #{ value: "iterations", description: "" }],
      }
    )
    @path
    structureGroup: "areas" | "iterations",

    /** Path of the classification node. */
    @extension("x-ms-required", false) @path path: string,

    /** Depth of children to fetch. */
    @query(#{ explode: true }) $depth?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemClassificationNode;

  /** Update an existing classification node. */
  @tag("Classification Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "classificationNodes")
  @extension("x-ms-vss-method", "UpdateClassificationNode")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/classificationnodes/{structureGroup}/{path}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Structure group of the classification node, area or iteration. */
    @extension(
      "x-ms-enum",
      #{
        name: "TreeStructureGroup",
        values: #[#{ value: "areas", description: "" }, #{ value: "iterations", description: "" }],
      }
    )
    @path
    structureGroup: "areas" | "iterations",

    /** Path of the classification node. */
    @extension("x-ms-required", false) @path path: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Node to create or update. */
    @body body: WorkItemClassificationNode,
  ): WorkItemClassificationNode;

  /** Create new or update an existing classification node. */
  @tag("Classification Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "classificationNodes")
  @extension("x-ms-vss-method", "CreateOrUpdateClassificationNode")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/classificationnodes/{structureGroup}/{path}")
  @post
  CreateOrUpdate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Structure group of the classification node, area or iteration. */
    @extension(
      "x-ms-enum",
      #{
        name: "TreeStructureGroup",
        values: #[#{ value: "areas", description: "" }, #{ value: "iterations", description: "" }],
      }
    )
    @path
    structureGroup: "areas" | "iterations",

    /** Path of the classification node. */
    @extension("x-ms-required", false) @path path: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Node to create or update. */
    @body body: WorkItemClassificationNode,
  ): WorkItemClassificationNode;
}

interface Fields {
  /** Returns information for all fields. The project ID/name parameter is optional. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "GetWorkItemFields")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/fields")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Use ExtensionFields to include extension fields, otherwise exclude them. Unless the feature flag for this parameter is enabled, extension fields are always included. */
    @extension(
      "x-ms-enum",
      #{
        name: "GetFieldsExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "extensionFields", description: "Adds extension fields to the response." },
          #{ value: "includeDeleted", description: "Includes fields that have been deleted." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "extensionFields" | "includeDeleted",

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemField2List;

  /** Create a new field. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "CreateWorkItemField")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/fields")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,

    /** New field definition */
    @body body: WorkItemField2,
  ): WorkItemField2;

  /** Deletes the field. To undelete a filed, see 'Update Field' API. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "DeleteWorkItemField")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/fields/{fieldNameOrRefName}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Field simple name or reference name */
    @path fieldNameOrRefName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): OkResponse;

  /** Gets information on a specific field. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "GetWorkItemField")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/fields/{fieldNameOrRefName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Field simple name or reference name */
    @path fieldNameOrRefName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemField2;

  /** Update a field. */
  @tag("Fields")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "fields")
  @extension("x-ms-vss-method", "UpdateWorkItemField")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/fields/{fieldNameOrRefName}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name/reference name of the field to be updated */
    @path fieldNameOrRefName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,

    /** Payload contains desired value of the field's properties */
    @body body: FieldUpdate,
  ): WorkItemField2;
}

interface ProjectProcessMigration {
  /** Migrates a project to a different process within the same OOB type. For example, you can only migrate a project from agile/custom-agile to agile/custom-agile. */
  @tag("Project Process Migration")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "projectProcessMigration")
  @extension("x-ms-vss-method", "MigrateProjectsProcess")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/projectprocessmigration")
  @post
  MigrateProjectsProcess(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: ProcessIdModel,
  ): ProcessMigrationResultModel;
}

interface Queries {
  /** Gets the root queries and their children */
  @tag("Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "queries")
  @extension("x-ms-vss-method", "GetQueries")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/queries")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Include the query string (wiql), clauses, query result columns, and sort options in the results. */
    @extension(
      "x-ms-enum",
      #{
        name: "QueryExpand",
        values: #[
          #{ value: "none", description: "Expands Columns, Links and ChangeInfo" },
          #{ value: "wiql", description: "Expands Columns, Links, ChangeInfo and WIQL text" },
          #{
            value: "clauses",
            description: "Expands Columns, Links, ChangeInfo, WIQL text and clauses",
          },
          #{ value: "all", description: "Expands all properties" },
          #{ value: "minimal", description: "Displays minimal properties and the WIQL text" }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "wiql" | "clauses" | "all" | "minimal",

    /** In the folder of queries, return child queries and folders to this depth. */
    @query(#{ explode: true }) $depth?: int32,

    /** Include deleted queries and folders */
    @query(#{ explode: true }) $includeDeleted?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): QueryHierarchyItemList;

  /** Delete a query or a folder. This deletes any permission change on the deleted query or folder and any of its descendants if it is a folder. It is important to note that the deleted permission changes cannot be recovered upon undeleting the query or folder. */
  @tag("Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "queries")
  @extension("x-ms-vss-method", "DeleteQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/queries/{query}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID or path of the query or folder to delete. */
    @path query: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Retrieves an individual query and its children */
  @tag("Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "queries")
  @extension("x-ms-vss-method", "GetQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/queries/{query}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID or path of the query. */
    @path query: string,

    /** Include the query string (wiql), clauses, query result columns, and sort options in the results. */
    @extension(
      "x-ms-enum",
      #{
        name: "QueryExpand",
        values: #[
          #{ value: "none", description: "Expands Columns, Links and ChangeInfo" },
          #{ value: "wiql", description: "Expands Columns, Links, ChangeInfo and WIQL text" },
          #{
            value: "clauses",
            description: "Expands Columns, Links, ChangeInfo, WIQL text and clauses",
          },
          #{ value: "all", description: "Expands all properties" },
          #{ value: "minimal", description: "Displays minimal properties and the WIQL text" }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "wiql" | "clauses" | "all" | "minimal",

    /** In the folder of queries, return child queries and folders to this depth. */
    @query(#{ explode: true }) $depth?: int32,

    /** Include deleted queries and folders */
    @query(#{ explode: true }) $includeDeleted?: boolean,

    /** DateTime query clauses will be formatted using a ISO 8601 compliant format */
    @query(#{ explode: true }) $useIsoDateFormat?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): QueryHierarchyItem;

  /** Update a query or a folder. This allows you to update, rename and move queries and folders. */
  @tag("Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "queries")
  @extension("x-ms-vss-method", "UpdateQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/queries/{query}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID or path for the query to update. */
    @path query: string,

    /** Undelete the children of this folder. It is important to note that this will not bring back the permission changes that were previously applied to the descendants. */
    @query(#{ explode: true }) $undeleteDescendants?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** The query to update. */
    @body body: QueryHierarchyItem,
  ): QueryHierarchyItem;

  /** Creates a query, or moves a query. Learn more about Work Item Query Language (WIQL) syntax [here](https://docs.microsoft.com/en-us/vsts/collaborate/wiql-syntax?toc=/vsts/work/track/toc.json&bc=/vsts/work/track/breadcrumb/toc.json&view=vsts). */
  @tag("Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "queries")
  @extension("x-ms-vss-method", "CreateQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/queries/{query}")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The parent id or path under which the query is to be created. */
    @path query: string,

    /** If you only want to validate your WIQL query without actually creating one, set it to true. Default is false. */
    @query(#{ explode: true }) validateWiqlOnly?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** The query to create. */
    @body body: QueryHierarchyItem,
  ): QueryHierarchyItem;

  /** Gets a list of queries by ids (Maximum 1000) */
  @tag("Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "queriesBatch")
  @extension("x-ms-vss-method", "GetQueriesBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/queriesbatch")
  @post
  GetQueriesBatch(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: QueryBatchGetRequest,
  ): QueryHierarchyItemList;
}

interface Recyclebin {
  /** Gets a list of the IDs and the URLs of the deleted the work items in the Recycle Bin. */
  @tag("Recyclebin")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "recyclebin")
  @extension("x-ms-vss-method", "GetDeletedWorkItemShallowReferences")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/recyclebin")
  @get
  GetDeletedWorkItemShallowReferences(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemDeleteShallowReferenceList;

  /** Destroys the specified work item permanently from the Recycle Bin. This action can not be undone. */
  @tag("Recyclebin")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "recyclebin")
  @extension("x-ms-vss-method", "DestroyWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/recyclebin/{id}")
  @delete
  DestroyWorkItem(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the work item to be destroyed permanently */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Gets a deleted work item from Recycle Bin. */
  @tag("Recyclebin")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "recyclebin")
  @extension("x-ms-vss-method", "GetDeletedWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/recyclebin/{id}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the work item to be returned */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemDelete;

  /** Restores the deleted work item from Recycle Bin. */
  @tag("Recyclebin")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "recyclebin")
  @extension("x-ms-vss-method", "RestoreWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/recyclebin/{id}")
  @patch
  RestoreWorkItem(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the work item to be restored */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Paylod with instructions to update the IsDeleted flag to false */
    @body body: WorkItemDeleteUpdate,
  ): WorkItemDelete;
}

interface ReportingWorkItemLinks {
  /** Get a batch of work item links */
  @tag("Reporting Work Item Links")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItemLinks")
  @extension("x-ms-vss-method", "GetReportingLinksByLinkType")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/reporting/workitemlinks")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** A list of types to filter the results to specific link types. Omit this parameter to get work item links of all link types. */
    @format("array (string)") @query(#{ explode: true }) linkTypes?: string,

    /** A list of types to filter the results to specific work item types. Omit this parameter to get work item links of all work item types. */
    @format("array (string)") @query(#{ explode: true }) types?: string,

    /** Specifies the continuationToken to start the batch from. Omit this parameter to get the first batch of links. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Date/time to use as a starting point for link changes. Only link changes that occurred after that date/time will be returned. Cannot be used in conjunction with 'watermark' parameter. */
    @query(#{ explode: true }) startDateTime?: utcDateTime,

    ...Parameters.`api-Version-preview`.`3`,
  ): ReportingWorkItemLinksBatch;
}

interface ReportingWorkItemRevisions {
  /** Get a batch of work item revisions with the option of including deleted items */
  @tag("Reporting Work Item Revisions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemRevisions")
  @extension("x-ms-vss-method", "ReadReportingRevisionsGet")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/reporting/workitemrevisions")
  @get
  ReadReportingRevisionsGet(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** A list of fields to return in work item revisions. Omit this parameter to get all reportable fields. */
    @format("array (string)") @query(#{ explode: true }) fields?: string,

    /** A list of types to filter the results to specific work item types. Omit this parameter to get work item revisions of all work item types. */
    @format("array (string)") @query(#{ explode: true }) types?: string,

    /** Specifies the watermark to start the batch from. Omit this parameter to get the first batch of revisions. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Date/time to use as a starting point for revisions, all revisions will occur after this date/time. Cannot be used in conjunction with 'watermark' parameter. */
    @query(#{ explode: true }) startDateTime?: utcDateTime,

    /** Return an identity reference instead of a string value for identity fields. */
    @query(#{ explode: true }) includeIdentityRef?: boolean,

    /** Specify if the deleted item should be returned. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** Specify if the tag objects should be returned for System.Tags field. */
    @query(#{ explode: true }) includeTagRef?: boolean,

    /** Return only the latest revisions of work items, skipping all historical revisions */
    @query(#{ explode: true }) includeLatestOnly?: boolean,

    /** Return all the fields in work item revisions, including long text fields which are not returned by default */
    @extension(
      "x-ms-enum",
      #{
        name: "ReportingRevisionsExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "fields", description: "Add fields to the response." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "fields",

    /** Return only the those revisions of work items, where only history field was changed */
    @query(#{ explode: true }) includeDiscussionChangesOnly?: boolean,

    /** The maximum number of results to return in this batch */
    @query(#{ explode: true }) $maxPageSize?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): ReportingWorkItemRevisionsBatch;

  /** Get a batch of work item revisions. This request may be used if your list of fields is large enough that it may run the URL over the length limit. */
  @tag("Reporting Work Item Revisions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemRevisions")
  @extension("x-ms-vss-method", "ReadReportingRevisionsPost")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/reporting/workitemrevisions")
  @post
  ReadReportingRevisionsPost(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Specifies the watermark to start the batch from. Omit this parameter to get the first batch of revisions. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Date/time to use as a starting point for revisions, all revisions will occur after this date/time. Cannot be used in conjunction with 'watermark' parameter. */
    @query(#{ explode: true }) startDateTime?: utcDateTime,

    @extension(
      "x-ms-enum",
      #{
        name: "ReportingRevisionsExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "fields", description: "Add fields to the response." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "fields",
    ...Parameters.`api-Version-preview`.`2`,

    /** An object that contains request settings: field filter, type filter, identity format */
    @body body: ReportingWorkItemRevisionsFilter,
  ): ReportingWorkItemRevisionsBatch;
}

interface WorkItemRevisionsDiscussions {
  @tag("Work Item Revisions Discussions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemRevisionsDiscussions")
  @extension("x-ms-vss-method", "ReadReportingDiscussions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/reporting/workItemRevisions/discussions")
  @get
  ReadReportingDiscussions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    @query(#{ explode: true }) continuationToken?: string,
    @query(#{ explode: true }) $maxPageSize?: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): ReportingWorkItemRevisionsBatch;
}

interface SendMail {
  /** RESTful method to send mail for selected/queried work items. */
  @tag("Send Mail")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "sendMail")
  @extension("x-ms-vss-method", "SendMailAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/sendmail")
  @post
  SendMail(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: SendMailBody,
  ): OkResponse;
}

interface Tags {
  /** Get all the tags for the project. */
  @tag("Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tags")
  @extension("x-ms-vss-method", "GetTags")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/tags")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemTagDefinitionList;

  /** Delete the tag for the project. Please note, that the deleted tag will be removed from all Work Items as well as Pull Requests. */
  @tag("Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tags")
  @extension("x-ms-vss-method", "DeleteTag")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/tags/{tagIdOrName}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Tag ID or tag name. */
    @path tagIdOrName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get the tag for the project. */
  @tag("Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tags")
  @extension("x-ms-vss-method", "GetTag")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/tags/{tagIdOrName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Tag ID or tag name. */
    @path tagIdOrName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemTagDefinition;

  /** Update the tag for the project. */
  @tag("Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tags")
  @extension("x-ms-vss-method", "UpdateTag")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/tags/{tagIdOrName}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Tag ID or tag name. */
    @path tagIdOrName: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemTagDefinition,
  ): WorkItemTagDefinition;
}

interface TempQueries {
  /** Creates a temporary query Learn more about Work Item Query Language (WIQL) syntax [here](https://docs.microsoft.com/en-us/vsts/collaborate/wiql-syntax?toc=/vsts/work/track/toc.json&bc=/vsts/work/track/breadcrumb/toc.json&view=vsts). */
  @tag("Temp Queries")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tempQueries")
  @extension("x-ms-vss-method", "CreateTempQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/tempqueries")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The temporary query to create */
    @body body: TemporaryQueryRequestModel,
  ): TemporaryQueryResponseModel;
}

interface WorkItems {
  /** Returns a list of work items (Maximum 200) */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItems")
  @extension("x-ms-vss-method", "GetWorkItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitems")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The comma-separated list of requested work item ids. (Maximum 200 ids allowed). */
    @format("array (int32)") @query(#{ explode: true }) ids: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Comma-separated list of requested fields */
    @format("array (string)") @query(#{ explode: true }) fields?: string,

    /** AsOf UTC date time string */
    @query(#{ explode: true }) asOf?: utcDateTime,

    /** The expand parameters for work item attributes. Possible options are { None, Relations, Fields, Links, All }. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",

    /** The flag to control error policy in a bulk get work items request. Possible options are {Fail, Omit}. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemErrorPolicy",
        values: #[
          #{ value: "fail", description: "Fail work error policy." },
          #{ value: "omit", description: "Omit work error policy." }
        ],
      }
    )
    @query(#{ explode: true })
    errorPolicy?: "fail" | "omit",

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemList;

  /** Returns a single work item from a template. */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItems")
  @extension("x-ms-vss-method", "GetWorkItemTemplate")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitems/\${type}")
  @get
  GetWorkItemTemplate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The work item type name */
    @path type: string,

    /** Comma-separated list of requested fields */
    @query(#{ explode: true }) fields?: string,

    /** AsOf UTC date time string */
    @query(#{ explode: true }) asOf?: utcDateTime,

    /** The expand parameters for work item attributes. Possible options are { None, Relations, Fields, Links, All }. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItem;

  /** Creates a single work item. */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItems")
  @extension("x-ms-vss-method", "CreateWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitems/\${type}")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The work item type of the work item to create */
    @path type: string,

    /** Indicate if you only want to validate the changes without saving the work item */
    @query(#{ explode: true }) validateOnly?: boolean,

    /** Do not enforce the work item type rules on this update */
    @query(#{ explode: true }) bypassRules?: boolean,

    /** Do not fire any notifications for this change */
    @query(#{ explode: true }) suppressNotifications?: boolean,

    /** The expand parameters for work item attributes. Possible options are { None, Relations, Fields, Links, All }. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",

    ...Parameters.`api-Version-preview`.`3`,
    @header contentType: "application/json-patch+json",

    /** The JSON Patch document representing the work item */
    @body body: JsonPatchDocument,
  ): WorkItem;

  /** Deletes the specified work item and sends it to the Recycle Bin, so that it can be restored back, if required. Optionally, if the destroy parameter has been set to true, it destroys the work item permanently. WARNING: If the destroy parameter is set to true, work items deleted by this command will NOT go to recycle-bin and there is no way to restore/recover them after deletion. It is recommended NOT to use this parameter. If you do, please use this parameter with extreme caution. */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItems")
  @extension("x-ms-vss-method", "DeleteWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitems/{id}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the work item to be deleted */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Optional parameter, if set to true, the work item is deleted permanently. Please note: the destroy action is PERMANENT and cannot be undone. */
    @query(#{ explode: true }) destroy?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemDelete;

  /** Returns a single work item. */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItems")
  @extension("x-ms-vss-method", "GetWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitems/{id}")
  @get
  GetWorkItem(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The work item id */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Comma-separated list of requested fields */
    @format("array (string)") @query(#{ explode: true }) fields?: string,

    /** AsOf UTC date time string */
    @query(#{ explode: true }) asOf?: utcDateTime,

    /** The expand parameters for work item attributes. Possible options are { None, Relations, Fields, Links, All }. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItem;

  /** Updates a single work item. */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItems")
  @extension("x-ms-vss-method", "UpdateWorkItem")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitems/{id}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The id of the work item to update */
    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Indicate if you only want to validate the changes without saving the work item */
    @query(#{ explode: true }) validateOnly?: boolean,

    /** Do not enforce the work item type rules on this update */
    @query(#{ explode: true }) bypassRules?: boolean,

    /** Do not fire any notifications for this change */
    @query(#{ explode: true }) suppressNotifications?: boolean,

    /** The expand parameters for work item attributes. Possible options are { None, Relations, Fields, Links, All }. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",

    ...Parameters.`api-Version-preview`.`3`,
    @header contentType: "application/json-patch+json",

    /** The JSON Patch document representing the update */
    @body body: JsonPatchDocument,
  ): WorkItem;

  /** Gets work items for a list of work item ids (Maximum 200) */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemsBatch")
  @extension("x-ms-vss-method", "GetWorkItemsBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemsbatch")
  @post
  GetWorkItemsBatch(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemBatchGetRequest,
  ): WorkItemList;

  /** Deletes specified work items and sends them to the Recycle Bin, so that it can be restored back, if required. Optionally, if the destroy parameter has been set to true, it destroys the work item permanently. WARNING: If the destroy parameter is set to true, work items deleted by this command will NOT go to recycle-bin and there is no way to restore/recover them after deletion. */
  @tag("Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemsDelete")
  @extension("x-ms-vss-method", "DeleteWorkItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemsdelete")
  @post
  DeleteWorkItems(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: WorkItemDeleteBatchRequest,
  ): WorkItemDeleteBatch;
}

interface Revisions {
  /** Returns the list of fully hydrated work item revisions, paged. */
  @tag("Revisions")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "revisions")
  @extension("x-ms-vss-method", "GetRevisions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{id}/revisions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) $skip?: int32,
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",
    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemList;

  /** Returns a fully hydrated work item for the requested revision */
  @tag("Revisions")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "revisions")
  @extension("x-ms-vss-method", "GetRevision")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{id}/revisions/{revisionNumber}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path id: int32,
    @path revisionNumber: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemExpand",
        values: #[
          #{ value: "none", description: "Default behavior." },
          #{ value: "relations", description: "Relations work item expand." },
          #{ value: "fields", description: "Fields work item expand." },
          #{ value: "links", description: "Links work item expand." },
          #{ value: "all", description: "Expands all." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "relations" | "fields" | "links" | "all",
    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItem;
}

interface Updates {
  /** Returns the deltas between work item revisions */
  @tag("Updates")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "updates")
  @extension("x-ms-vss-method", "GetUpdates")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{id}/updates")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path id: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) $skip?: int32,
    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemUpdateList;

  /** Returns a single update for a work item */
  @tag("Updates")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "updates")
  @extension("x-ms-vss-method", "GetUpdate")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{id}/updates/{updateNumber}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path id: int32,
    @path updateNumber: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemUpdate;
}

interface Comments {
  /** Returns a list of work item comments by ids. */
  @tag("Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "comments")
  @extension("x-ms-vss-method", "GetCommentsBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments")
  @get
  GetCommentsBatch(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of a work item to get comments for. */
    @path workItemId: int32,

    /** Comma-separated list of comment ids to return. */
    @format("array (int32)") @query(#{ explode: true }) ids: string,

    /** Specify if the deleted comments should be retrieved. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** Specifies the additional data retrieval options for work item comments. */
    @extension(
      "x-ms-enum",
      #{
        name: "CommentExpandOptions",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "reactions", description: "Include comment reactions." },
          #{
            value: "renderedText",
            description: "Include the rendered text (html) in addition to MD text.",
          },
          #{
            value: "renderedTextOnly",
            description: "If specified, then ONLY rendered text (html) will be returned, w/o markdown. Supposed to be used internally from data provides for optimization purposes.",
          },
          #{ value: "all", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "reactions" | "renderedText" | "renderedTextOnly" | "all",

    ...Parameters.`api-Version-preview`.`4`,
  ): CommentList;

  /** Add a comment on a work item. */
  @tag("Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "comments")
  @extension("x-ms-vss-method", "AddComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments")
  @post
  AddComment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of a work item. */
    @path workItemId: int32,

    ...Parameters.`api-Version-preview`.`4`,

    /** Comment create request. */
    @body body: CommentCreate,
  ): Comment;

  /** Delete a comment on a work item. */
  @tag("Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "comments")
  @extension("x-ms-vss-method", "DeleteComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of a work item. */
    @path workItemId: int32,

    @path commentId: int32,
    ...Parameters.`api-Version-preview`.`4`,
  ): OkResponse;

  /** Returns a work item comment. */
  @tag("Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "comments")
  @extension("x-ms-vss-method", "GetComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}")
  @get
  GetComment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of a work item to get the comment. */
    @path workItemId: int32,

    /** Id of the comment to return. */
    @path commentId: int32,

    /** Specify if the deleted comment should be retrieved. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** Specifies the additional data retrieval options for work item comments. */
    @extension(
      "x-ms-enum",
      #{
        name: "CommentExpandOptions",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "reactions", description: "Include comment reactions." },
          #{
            value: "renderedText",
            description: "Include the rendered text (html) in addition to MD text.",
          },
          #{
            value: "renderedTextOnly",
            description: "If specified, then ONLY rendered text (html) will be returned, w/o markdown. Supposed to be used internally from data provides for optimization purposes.",
          },
          #{ value: "all", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "reactions" | "renderedText" | "renderedTextOnly" | "all",

    ...Parameters.`api-Version-preview`.`4`,
  ): Comment;

  /** Update a comment on a work item. */
  @tag("Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "comments")
  @extension("x-ms-vss-method", "UpdateComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}")
  @patch
  UpdateComment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of a work item. */
    @path workItemId: int32,

    @path commentId: int32,
    ...Parameters.`api-Version-preview`.`4`,

    /** Comment update request. */
    @body body: CommentUpdate,
  ): Comment;
}

interface CommentsReactions {
  /** Gets reactions of a comment. */
  @tag("Comments Reactions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commentsReactions")
  @extension("x-ms-vss-method", "GetCommentReactions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}/reactions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** WorkItem ID */
    @path workItemId: int32,

    /** Comment ID */
    @path commentId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): CommentReactionList;

  /** Deletes an existing reaction on a comment. */
  @tag("Comments Reactions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commentsReactions")
  @extension("x-ms-vss-method", "DeleteCommentReaction")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}/reactions/{reactionType}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** WorkItem ID */
    @path workItemId: int32,

    /** Comment ID */
    @path commentId: int32,

    /** Type of the reaction */
    @extension(
      "x-ms-enum",
      #{
        name: "CommentReactionType",
        values: #[
          #{ value: "like", description: "" },
          #{ value: "dislike", description: "" },
          #{ value: "heart", description: "" },
          #{ value: "hooray", description: "" },
          #{ value: "smile", description: "" },
          #{ value: "confused", description: "" }
        ],
      }
    )
    @path
    reactionType: "like" | "dislike" | "heart" | "hooray" | "smile" | "confused",

    ...Parameters.`api-Version-preview`.`1`,
  ): CommentReaction;

  /** Adds a new reaction to a comment. */
  @tag("Comments Reactions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commentsReactions")
  @extension("x-ms-vss-method", "CreateCommentReaction")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}/reactions/{reactionType}")
  @put
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** WorkItem ID */
    @path workItemId: int32,

    /** Comment ID */
    @path commentId: int32,

    /** Type of the reaction */
    @extension(
      "x-ms-enum",
      #{
        name: "CommentReactionType",
        values: #[
          #{ value: "like", description: "" },
          #{ value: "dislike", description: "" },
          #{ value: "heart", description: "" },
          #{ value: "hooray", description: "" },
          #{ value: "smile", description: "" },
          #{ value: "confused", description: "" }
        ],
      }
    )
    @path
    reactionType: "like" | "dislike" | "heart" | "hooray" | "smile" | "confused",

    ...Parameters.`api-Version-preview`.`1`,
  ): CommentReaction;
}

interface CommentReactionsEngagedUsers {
  /** Get users who reacted on the comment. */
  @tag("Comment Reactions Engaged Users")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commentReactionsEngagedUsers")
  @extension("x-ms-vss-method", "GetEngagedUsers")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}/reactions/{reactionType}/users")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** WorkItem ID. */
    @path workItemId: int32,

    /** Comment ID. */
    @path commentId: int32,

    /** Type of the reaction. */
    @extension(
      "x-ms-enum",
      #{
        name: "CommentReactionType",
        values: #[
          #{ value: "like", description: "" },
          #{ value: "dislike", description: "" },
          #{ value: "heart", description: "" },
          #{ value: "hooray", description: "" },
          #{ value: "smile", description: "" },
          #{ value: "confused", description: "" }
        ],
      }
    )
    @path
    reactionType: "like" | "dislike" | "heart" | "hooray" | "smile" | "confused",

    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) $skip?: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): IdentityRefList;
}

interface CommentsVersions {
  @tag("Comments Versions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commentsVersions")
  @extension("x-ms-vss-method", "GetCommentVersions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}/versions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path workItemId: int32,
    @path commentId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): CommentVersionList;

  @tag("Comments Versions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commentsVersions")
  @extension("x-ms-vss-method", "GetCommentVersion")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workItems/{workItemId}/comments/{commentId}/versions/{version}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path workItemId: int32,
    @path commentId: int32,
    @path version: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): CommentVersion;
}

interface WorkItemTypeCategories {
  /** Get all work item type categories. */
  @tag("Work Item Type Categories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypeCategories")
  @extension("x-ms-vss-method", "GetWorkItemTypeCategories")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypecategories")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemTypeCategoryList;

  /** Get specific work item type category by name. */
  @tag("Work Item Type Categories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypeCategories")
  @extension("x-ms-vss-method", "GetWorkItemTypeCategory")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypecategories/{category}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The category name */
    @path category: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemTypeCategory;
}

interface WorkItemTypes {
  /** Returns the list of work item types */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "GetWorkItemTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemTypeList;

  /** Returns a work item type definition. */
  @tag("Work Item Types")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workItemTypes")
  @extension("x-ms-vss-method", "GetWorkItemType")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypes/{type}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Work item type name */
    @path type: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemType;
}

interface WorkItemTypesField {
  /** Get a list of fields for a work item type with detailed references. */
  @tag("Work Item Types Field")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItemTypesField")
  @extension("x-ms-vss-method", "GetWorkItemTypeFieldsWithReferences")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypes/{type}/fields")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Work item type. */
    @path type: string,

    /** Expand level for the API response. Properties: to include allowedvalues, default value, isRequired etc. as a part of response; None: to skip these properties. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemTypeFieldsExpandLevel",
        values: #[
          #{ value: "none", description: "Includes only basic properties of the field." },
          #{ value: "allowedValues", description: "Includes allowed values for the field." },
          #{ value: "dependentFields", description: "Includes dependent fields of the field." },
          #{ value: "all", description: "Includes allowed values and dependent fields of the field." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "allowedValues" | "dependentFields" | "all",

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemTypeFieldWithReferencesList;

  /** Get a field for a work item type with detailed references. */
  @tag("Work Item Types Field")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "workItemTypesField")
  @extension("x-ms-vss-method", "GetWorkItemTypeFieldWithReferences")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypes/{type}/fields/{field}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Work item type. */
    @path type: string,

    @path field: string,

    /** Expand level for the API response. Properties: to include allowedvalues, default value, isRequired etc. as a part of response; None: to skip these properties. */
    @extension(
      "x-ms-enum",
      #{
        name: "WorkItemTypeFieldsExpandLevel",
        values: #[
          #{ value: "none", description: "Includes only basic properties of the field." },
          #{ value: "allowedValues", description: "Includes allowed values for the field." },
          #{ value: "dependentFields", description: "Includes dependent fields of the field." },
          #{ value: "all", description: "Includes allowed values and dependent fields of the field." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "allowedValues" | "dependentFields" | "all",

    ...Parameters.`api-Version-preview`.`3`,
  ): WorkItemTypeFieldWithReferences;
}

interface WorkItemTypeStates {
  /** Returns the state names and colors for a work item type. */
  @tag("Work Item Type States")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemTypeStates")
  @extension("x-ms-vss-method", "GetWorkItemTypeStates")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wit/workitemtypes/{type}/states")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The state name */
    @path type: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemStateColorList;
}

interface Templates {
  /** Gets template */
  @tag("Templates")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "templates")
  @extension("x-ms-vss-method", "GetTemplates")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/templates")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @path team: string,

    /** Optional, When specified returns templates for given Work item type. */
    @query(#{ explode: true }) workitemtypename?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemTemplateReferenceList;

  /** Creates a template */
  @tag("Templates")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "templates")
  @extension("x-ms-vss-method", "CreateTemplate")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/templates")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @path team: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Template contents */
    @body body: WorkItemTemplate,
  ): WorkItemTemplate;

  /** Deletes the template with given id */
  @tag("Templates")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "templates")
  @extension("x-ms-vss-method", "DeleteTemplate")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/templates/{templateId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @path team: string,

    /** Template id */
    @format("uuid") @path templateId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Gets the template with specified id */
  @tag("Templates")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "templates")
  @extension("x-ms-vss-method", "GetTemplate")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/templates/{templateId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @path team: string,

    /** Template Id */
    @format("uuid") @path templateId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemTemplate;

  /** Replace template contents */
  @tag("Templates")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "templates")
  @extension("x-ms-vss-method", "ReplaceTemplate")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/templates/{templateId}")
  @put
  ReplaceTemplate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @path team: string,

    /** Template id */
    @format("uuid") @path templateId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Template contents to replace with */
    @body body: WorkItemTemplate,
  ): WorkItemTemplate;
}

interface WiqlOperations {
  /** Gets the results of the query given its WIQL. */
  @tag("Wiql")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wiql")
  @extension("x-ms-vss-method", "QueryByWiql")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/wiql")
  @post
  QueryByWiql(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    /** Whether or not to use time precision. */
    @query(#{ explode: true }) timePrecision?: boolean,

    /** The max number of results to return. */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`2`,

    /** The query containing the WIQL. */
    @body body: Wiql,
  ): WorkItemQueryResult;

  /** Gets the results of the query given the query ID. */
  @tag("Wiql")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wiql")
  @extension("x-ms-vss-method", "QueryById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/wiql/{id}")
  @get
  QueryById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The query ID. */
    @format("uuid") @path id: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    /** Whether or not to use time precision. */
    @query(#{ explode: true }) timePrecision?: boolean,

    /** The max number of results to return. */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemQueryResult;

  /** Gets the results of the query given the query ID. */
  @tag("Wiql")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wiql")
  @extension("x-ms-vss-method", "QueryById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/wit/wiql/{id}")
  @head
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The query ID. */
    @format("uuid") @path id: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    /** Whether or not to use time precision. */
    @query(#{ explode: true }) timePrecision?: boolean,

    /** The max number of results to return. */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<int32>;
}
