import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Git" })
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
namespace Git;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AdvSecEnablementOptions {
  /** Enforces secret scanning job for a repo where AdvSec is already enabled. */
  forceRepoSecretScanning?: boolean;
}

model AdvSecEnablementStatus {
  /** Enabled by VSID */
  @format("uuid") changedById?: string;

  /** Enabled changed on datetime */
  changedOnDate?: utcDateTime;

  /** True if Dependabot is enabled for the repository, false if it is disabled. */
  dependabotEnabled?: boolean;

  /** True if Dependency Scanning injection is enabled for the repository, false if it is disabled. */
  dependencyScanningInjectionEnabled?: boolean;

  /** Enabled status 0 disabled, 1 enabled, Null never explicitly set, always whatever project is, ya this should probably be an enum somewhere */
  enabled?: boolean;

  /** ProjectId */
  @format("uuid") projectId?: string;

  /** RepositoryId */
  @format("uuid") repositoryId?: string;
}

model AdvSecEnablementUpdate {
  /** New Dependabot status. */
  newDependabotStatus?: boolean;

  /** New Dependency Scanning injection enablement status. */
  newDependencyScanningInjectionEnablementStatus?: boolean;

  /** New status */
  newStatus?: boolean;

  options?: AdvSecEnablementOptions;

  /** ProjectId */
  @format("uuid") projectId?: string;

  /** RepositoryId Actual RepositoryId to Modify or Magic Repository Id 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF' for ALL Repositories for that project */
  @format("uuid") repositoryId?: string;
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

model AsyncGitOperationNotification {
  operationId?: int32;
}

model AsyncRefOperationCommitLevelEventNotification {
  ...AsyncGitOperationNotification;
  commitId?: string;
}

model AsyncRefOperationCompletedNotification {
  ...AsyncGitOperationNotification;
  newRefName?: string;
}

model AsyncRefOperationConflictNotification {
  ...AsyncRefOperationCommitLevelEventNotification;
}

model AsyncRefOperationGeneralFailureNotification {
  ...AsyncGitOperationNotification;
}

model AsyncRefOperationProgressNotification {
  ...AsyncRefOperationCommitLevelEventNotification;
  progress?: float64;
}

model AsyncRefOperationTimeoutNotification {
  ...AsyncGitOperationNotification;
}

/** Meta data for a file attached to an artifact. */
model Attachment {
  _links?: ReferenceLinks;
  author?: IdentityRef;

  /** Content hash of on-disk representation of file content. Its calculated by the server by using SHA1 hash function. */
  contentHash?: string;

  /** The time the attachment was uploaded. */
  createdDate?: utcDateTime;

  /** The description of the attachment. */
  description?: string;

  /** The display name of the attachment. Can't be null or empty. */
  displayName?: string;

  /** Id of the attachment. */
  id?: int32;

  properties?: PropertiesCollection;

  /** The url to download the content of the attachment. */
  url?: string;
}

/** Real time event (SignalR) for an auto-complete update on a pull request */
model AutoCompleteUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Used by AdvSec to return billable committers. */
model BillableCommitter {
  /** RepositoryId commit was pushed to. */
  @format("uuid") repoId?: string;

  /** Visual Studio ID /Team Foundation ID */
  @format("uuid") vsid?: string;
}

model BillableCommitterDetail {
  ...BillableCommitter;

  /** ID (SHA-1) of the commit. */
  commitId?: string;

  /** Committer email address after parsing. */
  committerEmail?: string;

  /** Time reported by the commit. */
  commitTime?: utcDateTime;

  /** DisplayName of the Pusher. */
  displayName?: string;

  /** MailNickName of the Pusher. */
  mailNickName?: string;

  /** Project Id commit was pushed to. */
  @format("uuid") projectId?: string;

  /** Project name commit was pushed to. */
  projectName?: string;

  /** Time of the push that contained the commit. */
  pushedTime?: utcDateTime;

  /** Pusher Id for the push. */
  @format("uuid") pusherId?: string;

  /** Push Id that contained the commit. */
  pushId?: int32;

  /** Repository name commit was pushed to. */
  repoName?: string;

  /** SamAccountName of the Pusher. */
  samAccountName?: string;
}

/** Used by AdvSec to estimate billable pushers for a Host or Project. */
model BillablePusher {
  /** ProjectId that was pushed to. */
  @format("uuid") projectId?: string;

  /** RepositoryId that was pushed to. */
  @format("uuid") repoId?: string;

  /** Visual Studio ID /Team Foundation ID */
  @format("uuid") vsid?: string;
}

/** Real time event (SignalR) for a source/target branch update on a pull request */
model BranchUpdatedEvent {
  ...RealTimePullRequestEvent;

  /** If true, the source branch of the pull request was updated */
  isSourceUpdate?: boolean;
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

model ChangeCountDictionary {}

model ChangeList {
  allChangesIncluded?: boolean;
  changeCounts?: Record<int32>;
  changes?: Change[];
  comment?: string;
  commentTruncated?: boolean;
  creationDate?: utcDateTime;
  notes?: CheckinNote[];
  owner?: string;
  ownerDisplayName?: string;
  @format("uuid") ownerId?: string;
  sortDate?: utcDateTime;
  version?: string;
}

/** Criteria used in a search for change lists */
model ChangeListSearchCriteria {
  /** If provided, a version descriptor to compare against base */
  compareVersion?: string;

  /** If true, don't include delete history entries */
  excludeDeletes?: boolean;

  /** Whether or not to follow renames for the given item being queried */
  followRenames?: boolean;

  /** If provided, only include history entries created after this date (string) */
  fromDate?: string;

  /** If provided, a version descriptor for the earliest change list to include */
  fromVersion?: string;

  /** Path of item to search under. If the itemPaths memebr is used then it will take precedence over this. */
  itemPath?: string;

  /** List of item paths to search under. If this member is used then itemPath will be ignored. */
  itemPaths?: string[];

  /** Version of the items to search */
  itemVersion?: string;

  /** Number of results to skip (used when clicking more...) */
  skip?: int32;

  /** If provided, only include history entries created before this date (string) */
  toDate?: string;

  /** If provided, the maximum number of history entries to return */
  top?: int32;

  /** If provided, a version descriptor for the latest change list to include */
  toVersion?: string;

  /** Alias or display name of user who made the changes */
  user?: string;
}

model CheckinNote {
  name?: string;
  value?: string;
}

/** Represents a comment which is one of potentially many in a comment thread. */
model Comment {
  _links?: ReferenceLinks;
  author?: IdentityRef;

  /** The comment type at the time of creation. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentType",
      values: #[
        #{ value: "unknown", description: "The comment type is not known." },
        #{ value: "text", description: "This is a regular user comment." },
        #{ value: "codeChange", description: "The comment comes as a result of a code change." },
        #{ value: "system", description: "The comment represents a system message." }
      ],
    }
  )
  commentType?: "unknown" | "text" | "codeChange" | "system";

  /** The comment content. */
  content?: string;

  /** The comment ID. IDs start at 1 and are unique to a pull request. */
  id?: int16;

  /** Whether or not this comment was soft-deleted. */
  isDeleted?: boolean;

  /** The date the comment's content was last updated. */
  lastContentUpdatedDate?: utcDateTime;

  /** The date the comment was last updated. */
  lastUpdatedDate?: utcDateTime;

  /** The ID of the parent comment. This is used for replies. */
  parentCommentId?: int16;

  /** The date the comment was first published. */
  publishedDate?: utcDateTime;

  /** A list of the users who have liked this comment. */
  usersLiked?: IdentityRef[];
}

/** Comment iteration context is used to identify which diff was being viewed when the thread was created. */
model CommentIterationContext {
  /** The iteration of the file on the left side of the diff when the thread was created. If this value is equal to SecondComparingIteration, then this version is the common commit between the source and target branches of the pull request. */
  firstComparingIteration?: int16;

  /** The iteration of the file on the right side of the diff when the thread was created. */
  secondComparingIteration?: int16;
}

model CommentPosition {
  /** The line number of a thread's position. Starts at 1. */
  line?: int32;

  /** The character offset of a thread's position inside of a line. Starts at 1. */
  offset?: int32;
}

/** Represents a comment thread of a pull request. A thread contains meta data about the file it was left on along with one or more comments (an initial comment and the subsequent replies). */
model CommentThread {
  _links?: ReferenceLinks;

  /** A list of the comments. */
  comments?: Comment[];

  /** The comment thread id. */
  id?: int32;

  /** Set of identities related to this thread */
  identities?: Record<IdentityRef>;

  /** Specify if the thread is deleted which happens when all comments are deleted. */
  isDeleted?: boolean;

  /** The time this thread was last updated. */
  lastUpdatedDate?: utcDateTime;

  properties?: PropertiesCollection;

  /** The time this thread was published. */
  publishedDate?: utcDateTime;

  /** The status of the comment thread. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentThreadStatus",
      values: #[
        #{ value: "unknown", description: "The thread status is unknown." },
        #{ value: "active", description: "The thread status is active." },
        #{ value: "fixed", description: "The thread status is resolved as fixed." },
        #{ value: "wontFix", description: "The thread status is resolved as won't fix." },
        #{ value: "closed", description: "The thread status is closed." },
        #{ value: "byDesign", description: "The thread status is resolved as by design." },
        #{ value: "pending", description: "The thread status is pending." }
      ],
    }
  )
  status?: "unknown" | "active" | "fixed" | "wontFix" | "closed" | "byDesign" | "pending";

  threadContext?: CommentThreadContext;
}

model CommentThreadContext {
  /** File path relative to the root of the repository. It's up to the client to use any path format. */
  filePath?: string;

  leftFileEnd?: CommentPosition;
  leftFileStart?: CommentPosition;
  rightFileEnd?: CommentPosition;
  rightFileStart?: CommentPosition;
}

/** Comment tracking criteria is used to identify which iteration context the thread has been tracked to (if any) along with some detail about the original position and filename. */
model CommentTrackingCriteria {
  /** The iteration of the file on the left side of the diff that the thread will be tracked to. Threads were tracked if this is greater than 0. */
  firstComparingIteration?: int32;

  /** Original filepath the thread was created on before tracking. This will be different than the current thread filepath if the file in question was renamed in a later iteration. */
  origFilePath?: string;

  origLeftFileEnd?: CommentPosition;
  origLeftFileStart?: CommentPosition;
  origRightFileEnd?: CommentPosition;
  origRightFileStart?: CommentPosition;

  /** The iteration of the file on the right side of the diff that the thread will be tracked to. Threads were tracked if this is greater than 0. */
  secondComparingIteration?: int32;
}

/** Real time event (SignalR) for a completion errors on a pull request */
model CompletionErrorsEvent {
  ...RealTimePullRequestEvent;

  /** The error message associated with the completion error */
  errorMessage?: string;
}

/** Request to create an Enterprise Live Migration. */
model CreateMigrationRequest {
  /** Optional name of the agent pool to run the migration pipeline. When not specified, the pool is determined by region. */
  agentPoolName?: string;

  configOptions?: ElmConfigOptions;

  /** GitHub token (Device Flow or PAT with read:org scope) proving the identity of the migration owner. */
  gitHubUserToken?: string;

  /** Optional. The ID of a GitHub Enterprise service connection to use for pipeline rewiring. May be supplied at create time or attached later via PUT /pipelines. When EnableAutoDiscoverPipelines is opted in but no connection is attached, auto-discovery and clone-definition creation no-op during sync, and cutover is blocked by the cutover-readiness check until a connection is attached. */
  @format("uuid") pipelineServiceConnectionId?: string;

  /** The UTC date/time representing when the cutover is to occur. */
  scheduledCutoverDate?: utcDateTime;

  /** Optional. ID of a GitHub Enterprise Server-typed service connection whose PAT has ELM API access on the target GHES instance. */
  @format("uuid") serviceEndpointId?: string;

  /** Optional. The set of pre-migration validation policies to skip. */
  @extension(
    "x-ms-enum",
    #{
      name: "SkipValidationPolicy",
      values: #[
        #{ value: "none", description: "Do not skip any validation policies." },
        #{
          value: "activePullRequestCount",
          description: "Skip the active pull request count policy.",
        },
        #{
          value: "pullRequestDeltaSize",
          description: "Skip the pull request delta size policy.",
        },
        #{ value: "agentPoolExists", description: "Skip the agent pool exists policy." },
        #{ value: "maxFileSize", description: "Skip the max file size policy." },
        #{ value: "maxPullRequestSize", description: "Skip the max pull request size policy." },
        #{ value: "maxPushPackSize", description: "Skip the max push pack size policy." },
        #{
          value: "maxReferenceNameLength",
          description: "Skip the max reference name length policy.",
        },
        #{
          value: "targetRepositoryDoesNotExist",
          description: "Skip the target repository does not exist policy.",
        },
        #{
          value: "sourceRepositoryContainsLfsObjects",
          description: "Skip the source repository contains LFS objects policy.",
        },
        #{
          value: "sourceRepositoryNotReadOnly",
          description: "Skip the source repository read-only (maintenance) check policy.",
        },
        #{
          value: "boardsGitHubConnectionProvisioning",
          description: "Skip provisioning of Boards GitHub connection.",
        },
        #{ value: "all", description: "Skip all validation policies." }
      ],
    }
  )
  skipValidation?:
    | "none"
    | "activePullRequestCount"
    | "pullRequestDeltaSize"
    | "agentPoolExists"
    | "maxFileSize"
    | "maxPullRequestSize"
    | "maxPushPackSize"
    | "maxReferenceNameLength"
    | "targetRepositoryDoesNotExist"
    | "sourceRepositoryContainsLfsObjects"
    | "sourceRepositoryNotReadOnly"
    | "boardsGitHubConnectionProvisioning"
    | "all";

  /** The GitHub login of the migration owner. Set by the server when GitHubUserToken is provided. */
  targetOwnerUserId?: string;

  /** URL identifying the destination respository of migration. */
  targetRepository?: string;

  /** True if the migration should only perform pre-migration validation. */
  validateOnly?: boolean;
}

/** A failed or blocked resource from the GitHub migration, mapped back to ADO context. */
model CutoverReviewItem {
  /** The error message from GitHub for this failed resource, if any. */
  error?: string;

  /** The full URL to the ADO pull request. */
  pullRequestUrl?: string;

  /** The node state: failed, blocked, or pending. */
  state?: string;

  /** The resource type (e.g. pull_request, pull_request_comment). */
  type?: string;
}

/** Response from the GetCutoverReview API containing failed and blocked resource details. */
model CutoverReviewResponse {
  blockedCount?: int32;
  failedCount?: int32;
  pendingCount?: int32;
  requiresPipelineVerificationAcknowledgment?: boolean;
  totalUnprocessedCount?: int32;
  unprocessedItems?: CutoverReviewItem[];
}

/** Real time event (SignalR) for a discussions update on a pull request */
model DiscussionsUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Strongly-typed configuration options for an Enterprise Live Migration. Sent on <c>CreateMigrationRequest.ConfigOptions</c> and echoed back on <c>Migration.ConfigOptions</c>. All members are optional so the contract can grow additively. */
model ElmConfigOptions {
  /** Enable auto-discovery of pipelines for the repository. When unset (default), pipelines must be submitted manually via the POST /pipelines API. */
  enableAutoDiscoverPipelines?: boolean;

  /** Opt in to automatic Azure Boards GitHub connection provisioning on cutover. Disabled by default. */
  enableBoardsGitHubConnection?: boolean;

  /** When <c>true</c>, branch policies will not be migrated to GitHub rulesets during cutover. */
  skipBranchPolicyMigration?: boolean;

  /** When <c>true</c>, the source ADO repository will not be set to read-only (maintenance mode) during cutover. */
  skipSourceRepoLockdown?: boolean;

  skipValidation?: ElmSkipValidationOptions;
}

/** Named-boolean form of <c>SkipValidationPolicy</c>. Setting a property to <c>true</c> tells the server to skip that pre-migration validation. */
model ElmSkipValidationOptions {
  activePullRequestCount?: boolean;
  agentPoolExists?: boolean;

  /** When <c>true</c>, all validation policies are skipped. Equivalent to setting every other property to <c>true</c>. Never echoed back on responses — only the individual policy properties are populated. */
  all?: boolean;

  maxFileSize?: boolean;
  maxPullRequestSize?: boolean;
  maxPushPackSize?: boolean;
  maxReferenceNameLength?: boolean;
  pullRequestDeltaSize?: boolean;
  sourceRepositoryContainsLfsObjects?: boolean;
  targetRepositoryDoesNotExist?: boolean;
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

/** Provides properties that describe file differences */
model FileDiff {
  /** The collection of line diff blocks */
  lineDiffBlocks?: LineDiffBlock[];

  /** Original path of item if different from current path. */
  originalPath?: string;

  /** Current path of item */
  path?: string;
}

/** Provides properties that describe detailed file differences including line content */
model FileDiffDetail {
  /** The collection of detailed line diff blocks */
  lineDiffBlocks?: LineDiffBlockDetail[];

  /** Original path of item if different from current path. */
  originalPath?: string;

  /** Current path of item */
  path?: string;
}

/** Provides parameters that describe inputs for the file diff */
model FileDiffParams {
  /** Original path of the file */
  originalPath?: string;

  /** Current path of the file */
  path?: string;
}

/** Provides properties that describe inputs for the file diffs */
model FileDiffsCriteria {
  /** Commit ID of the base version */
  baseVersionCommit?: string;

  /** List of parameters for each of the files for which we need to get the file diff */
  fileDiffParams?: FileDiffParams[];

  /** Commit ID of the target version */
  targetVersionCommit?: string;
}

/** Request to get accessible repositories based on permission. */
model GetAccessibleRepositoriesRequest {
  /** Permission being requested, must be 'viewAlert' 'dismissAlert' 'manage' 'viewEnablement' 'repoRead' or 'repoContribute' */
  permission?: string;

  /** List of repository IDs to check permissions for */
  repositoryIds?: string[];
}

/** Response containing accessible repository IDs. */
model GetAccessibleRepositoriesResponse {
  /** List of repository IDs where the user has the requested permission */
  accessibleRepositoryIds?: string[];
}

/** A Git annotated tag. */
model GitAnnotatedTag {
  /** The tagging Message */
  message?: string;

  /** The name of the annotated tag. */
  name?: string;

  /** The objectId (Sha1Id) of the tag. */
  objectId?: string;

  taggedBy?: GitUserDate;
  taggedObject?: GitObject;
  url?: string;
}

model GitAsyncRefOperation {
  _links?: ReferenceLinks;
  detailedStatus?: GitAsyncRefOperationDetail;
  parameters?: GitAsyncRefOperationParameters;
  @extension(
    "x-ms-enum",
    #{
      name: "GitAsyncOperationStatus",
      values: #[
        #{
          value: "queued",
          description: "The operation is waiting in a queue and has not yet started.",
        },
        #{ value: "inProgress", description: "The operation is currently in progress." },
        #{ value: "completed", description: "The operation has completed." },
        #{ value: "failed", description: "The operation has failed. Check for an error message." },
        #{ value: "abandoned", description: "The operation has been abandoned." }
      ],
    }
  )
  status?: "queued" | "inProgress" | "completed" | "failed" | "abandoned";

  /** A URL that can be used to make further requests for status about the operation */
  url?: string;
}

/** Information about the progress of a cherry pick or revert operation. */
model GitAsyncRefOperationDetail {
  /** Indicates if there was a conflict generated when trying to cherry pick or revert the changes. */
  conflict?: boolean;

  /** The current commit from the list of commits that are being cherry picked or reverted. */
  currentCommitId?: string;

  /** Detailed information about why the cherry pick or revert failed to complete. */
  failureMessage?: string;

  /** A number between 0 and 1 indicating the percent complete of the operation. */
  progress?: float64;

  /** Provides a status code that indicates the reason the cherry pick or revert failed. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitAsyncRefOperationFailureStatus",
      values: #[
        #{ value: "none", description: "No status" },
        #{
          value: "invalidRefName",
          description: "Indicates that the ref update request could not be completed because the ref name presented in the request was not valid.",
        },
        #{
          value: "refNameConflict",
          description: "The ref update could not be completed because, in case-insensitive mode, the ref name conflicts with an existing, differently-cased ref name.",
        },
        #{
          value: "createBranchPermissionRequired",
          description: "The ref update request could not be completed because the user lacks the permission to create a branch",
        },
        #{
          value: "writePermissionRequired",
          description: "The ref update request could not be completed because the user lacks write permissions required to write this ref",
        },
        #{
          value: "targetBranchDeleted",
          description: "Target branch was deleted after Git async operation started",
        },
        #{
          value: "gitObjectTooLarge",
          description: "Git object is too large to materialize into memory",
        },
        #{
          value: "operationIndentityNotFound",
          description: "Identity who authorized the operation was not found",
        },
        #{ value: "asyncOperationNotFound", description: "Async operation was not found" },
        #{ value: "other", description: "Unexpected failure" },
        #{
          value: "emptyCommitterSignature",
          description: "Initiator of async operation has signature with empty name or email",
        }
      ],
    }
  )
  status?:
    | "none"
    | "invalidRefName"
    | "refNameConflict"
    | "createBranchPermissionRequired"
    | "writePermissionRequired"
    | "targetBranchDeleted"
    | "gitObjectTooLarge"
    | "operationIndentityNotFound"
    | "asyncOperationNotFound"
    | "other"
    | "emptyCommitterSignature";

  /** Indicates if the operation went beyond the maximum time allowed for a cherry pick or revert operation. */
  timedout?: boolean;
}

/** Parameters that are provided in the request body when requesting to cherry pick or revert. */
model GitAsyncRefOperationParameters {
  /** Proposed target branch name for the cherry pick or revert operation. */
  generatedRefName?: string;

  /** The target branch for the cherry pick or revert operation. */
  ontoRefName?: string;

  repository?: GitRepository;
  source?: GitAsyncRefOperationSource;
}

/** GitAsyncRefOperationSource specifies the pull request or list of commits to use when making a cherry pick and revert operation request. Only one should be provided. */
model GitAsyncRefOperationSource {
  /** A list of commits to cherry pick or revert */
  commitList?: GitCommitRef[];

  /** Id of the pull request to cherry pick or revert */
  pullRequestId?: int32;
}

model GitBaseVersionDescriptor {
  ...GitVersionDescriptor;

  /** Version string identifier (name of tag/branch, SHA1 of commit) */
  baseVersion?: string;

  /** Version options - Specify additional modifiers to version (e.g Previous) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionOptions",
      values: #[
        #{ value: "none", description: "Not specified" },
        #{
          value: "previousChange",
          description: "Commit that changed item prior to the current version",
        },
        #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
      ],
    }
  )
  baseVersionOptions?: "none" | "previousChange" | "firstParent";

  /** Version type (branch, tag, or commit). Determines how Id is interpreted */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionType",
      values: #[
        #{ value: "branch", description: "Interpret the version as a branch name" },
        #{ value: "tag", description: "Interpret the version as a tag name" },
        #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
      ],
    }
  )
  baseVersionType?: "branch" | "tag" | "commit";
}

model GitBlobRef {
  _links?: ReferenceLinks;

  /** SHA1 hash of git object */
  objectId?: string;

  /** Size of blob content (in bytes) */
  size?: int64;

  url?: string;
}

/** Ahead and behind counts for a particular ref. */
model GitBranchStats {
  /** Number of commits ahead. */
  aheadCount?: int32;

  /** Number of commits behind. */
  behindCount?: int32;

  commit?: GitCommitRef;

  /** True if this is the result for the base version. */
  isBaseVersion?: boolean;

  /** Name of the ref. */
  name?: string;
}

model GitChange {
  ...Change;

  /** ID of the change within the group of changes. */
  changeId?: int32;

  newContentTemplate?: GitTemplate;

  /** Original path of item if different from current path. */
  originalPath?: string;
}

/** This object is returned from Cherry Pick operations and provides the id and status of the operation */
model GitCherryPick {
  ...GitAsyncRefOperation;
  cherryPickId?: int32;
}

model GitCommit {
  ...GitCommitRef;
  treeId?: string;
}

model GitCommitChanges {
  changeCounts?: ChangeCountDictionary;
  changes?: GitChange[];
}

model GitCommitDiffs {
  aheadCount?: int32;
  allChangesIncluded?: boolean;
  baseCommit?: string;
  behindCount?: int32;
  changeCounts?: Record<int32>;
  changes?: GitChange[];
  commonCommit?: string;
  targetCommit?: string;
}

/** Provides properties that describe a Git commit and associated metadata. */
model GitCommitRef {
  _links?: ReferenceLinks;
  author?: GitUserDate;
  changeCounts?: ChangeCountDictionary;

  /** An enumeration of the changes included with the commit. */
  changes?: GitChange[];

  /** Comment or message of the commit. */
  comment?: string;

  /** Indicates if the comment is truncated from the full Git commit comment message. */
  commentTruncated?: boolean;

  /** ID (SHA-1) of the commit. */
  commitId?: string;

  committer?: GitUserDate;

  /** Indicates that commit contains too many changes to be displayed */
  commitTooManyChanges?: boolean;

  /** An enumeration of the parent commit IDs for this commit. */
  parents?: string[];

  push?: GitPushRef;

  /** Remote URL path to the commit. */
  remoteUrl?: string;

  /** A list of status metadata from services and extensions that may associate additional information to the commit. */
  statuses?: GitStatus[];

  /** REST URL for this resource. */
  url?: string;

  /** A list of workitems associated with this commit. */
  workItems?: ResourceRef[];
}

model GitCommitToCreate {
  baseRef?: GitRef;
  comment?: string;
  pathActions?: GitPathAction[];
}

model GitConflict {
  _links?: ReferenceLinks;
  conflictId?: int32;
  conflictPath?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "GitConflictType",
      values: #[
        #{ value: "none", description: "No conflict" },
        #{ value: "addAdd", description: "Added on source and target; content differs" },
        #{ value: "addRename", description: "Added on source and rename destination on target" },
        #{ value: "deleteEdit", description: "Deleted on source and edited on target" },
        #{ value: "deleteRename", description: "Deleted on source and renamed on target" },
        #{
          value: "directoryFile",
          description: "Path is a directory on source and a file on target",
        },
        #{
          value: "directoryChild",
          description: "Children of directory which has DirectoryFile or FileDirectory conflict",
        },
        #{ value: "editDelete", description: "Edited on source and deleted on target" },
        #{ value: "editEdit", description: "Edited on source and target; content differs" },
        #{
          value: "fileDirectory",
          description: "Path is a file on source and a directory on target",
        },
        #{
          value: "rename1to2",
          description: "Same file renamed on both source and target; destination paths differ",
        },
        #{
          value: "rename2to1",
          description: "Different files renamed to same destination path on both source and target",
        },
        #{
          value: "renameAdd",
          description: "Rename destination on source and new file on target",
        },
        #{ value: "renameDelete", description: "Renamed on source and deleted on target" },
        #{
          value: "renameRename",
          description: "Rename destination on both source and target; content differs",
        }
      ],
    }
  )
  conflictType?:
    | "none"
    | "addAdd"
    | "addRename"
    | "deleteEdit"
    | "deleteRename"
    | "directoryFile"
    | "directoryChild"
    | "editDelete"
    | "editEdit"
    | "fileDirectory"
    | "rename1to2"
    | "rename2to1"
    | "renameAdd"
    | "renameDelete"
    | "renameRename";
  mergeBaseCommit?: GitCommitRef;
  mergeOrigin?: GitMergeOriginRef;
  mergeSourceCommit?: GitCommitRef;
  mergeTargetCommit?: GitCommitRef;
  @extension(
    "x-ms-enum",
    #{
      name: "GitResolutionError",
      values: #[
        #{ value: "none", description: "No error" },
        #{
          value: "mergeContentNotFound",
          description: "User set a blob id for resolving a content merge, but blob was not found in repo during application",
        },
        #{
          value: "pathInUse",
          description: "Attempted to resolve a conflict by moving a file to another path, but path was already in use",
        },
        #{ value: "invalidPath", description: "No error" },
        #{
          value: "unknownAction",
          description: "GitResolutionAction was set to an unrecognized value",
        },
        #{
          value: "unknownMergeType",
          description: "GitResolutionMergeType was set to an unrecognized value",
        },
        #{
          value: "otherError",
          description: "Any error for which a more specific code doesn't apply",
        }
      ],
    }
  )
  resolutionError?:
    | "none"
    | "mergeContentNotFound"
    | "pathInUse"
    | "invalidPath"
    | "unknownAction"
    | "unknownMergeType"
    | "otherError";
  @extension(
    "x-ms-enum",
    #{
      name: "GitResolutionStatus",
      values: #[
        #{ value: "unresolved", description: "" },
        #{ value: "partiallyResolved", description: "" },
        #{ value: "resolved", description: "" }
      ],
    }
  )
  resolutionStatus?: "unresolved" | "partiallyResolved" | "resolved";
  resolvedBy?: IdentityRef;
  resolvedDate?: utcDateTime;
  url?: string;
}

/** Data object for AddAdd conflict */
model GitConflictAddAdd {
  ...GitConflict;
  resolution?: GitResolutionMergeContent;
  sourceBlob?: GitBlobRef;
  targetBlob?: GitBlobRef;
}

/** Data object for RenameAdd conflict */
model GitConflictAddRename {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionPathConflict;
  sourceBlob?: GitBlobRef;
  targetBlob?: GitBlobRef;
  targetOriginalPath?: string;
}

/** Data object for EditDelete conflict */
model GitConflictDeleteEdit {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionPickOneAction;
  targetBlob?: GitBlobRef;
}

/** Data object for RenameDelete conflict */
model GitConflictDeleteRename {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionPickOneAction;
  targetBlob?: GitBlobRef;
  targetNewPath?: string;
}

/** Data object for FileDirectory conflict */
model GitConflictDirectoryFile {
  ...GitConflict;
  resolution?: GitResolutionPathConflict;
  sourceTree?: GitTreeRef;
  targetBlob?: GitBlobRef;
}

/** Data object for DeleteEdit conflict */
model GitConflictEditDelete {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionPickOneAction;
  sourceBlob?: GitBlobRef;
}

/** Data object for EditEdit conflict */
model GitConflictEditEdit {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionMergeContent;
  sourceBlob?: GitBlobRef;
  targetBlob?: GitBlobRef;
}

/** Data object for DirectoryFile conflict */
model GitConflictFileDirectory {
  ...GitConflict;
  resolution?: GitResolutionPathConflict;
  sourceBlob?: GitBlobRef;
  targetTree?: GitTreeRef;
}

/** Data object for Rename1to2 conflict */
model GitConflictRename1to2 {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionRename1to2;
  sourceBlob?: GitBlobRef;
  sourceNewPath?: string;
  targetBlob?: GitBlobRef;
  targetNewPath?: string;
}

/** Data object for Rename2to1 conflict */
model GitConflictRename2to1 {
  ...GitConflict;
  resolution?: GitResolutionPathConflict;
  sourceNewBlob?: GitBlobRef;
  sourceOriginalBlob?: GitBlobRef;
  sourceOriginalPath?: string;
  targetNewBlob?: GitBlobRef;
  targetOriginalBlob?: GitBlobRef;
  targetOriginalPath?: string;
}

/** Data object for AddRename conflict */
model GitConflictRenameAdd {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionPathConflict;
  sourceBlob?: GitBlobRef;
  sourceOriginalPath?: string;
  targetBlob?: GitBlobRef;
}

/** Data object for DeleteRename conflict */
model GitConflictRenameDelete {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  resolution?: GitResolutionPickOneAction;
  sourceBlob?: GitBlobRef;
  sourceNewPath?: string;
}

/** Data object for RenameRename conflict */
model GitConflictRenameRename {
  ...GitConflict;
  baseBlob?: GitBlobRef;
  originalPath?: string;
  resolution?: GitResolutionMergeContent;
  sourceBlob?: GitBlobRef;
  targetBlob?: GitBlobRef;
}

model GitConflictUpdateResult {
  /** Conflict ID that was provided by input */
  conflictId?: int32;

  /** Reason for failing */
  customMessage?: string;

  updatedConflict?: GitConflict;

  /** Status of the update on the server */
  @extension(
    "x-ms-enum",
    #{
      name: "GitConflictUpdateStatus",
      values: #[
        #{
          value: "succeeded",
          description: "Indicates that pull request conflict update request was completed successfully",
        },
        #{
          value: "badRequest",
          description: "Indicates that the update request did not fit the expected data contract",
        },
        #{
          value: "invalidResolution",
          description: "Indicates that the requested resolution was not valid",
        },
        #{
          value: "unsupportedConflictType",
          description: "Indicates that the conflict in the update request was not a supported conflict type",
        },
        #{ value: "notFound", description: "Indicates that the conflict could not be found" }
      ],
    }
  )
  updateStatus?:
    | "succeeded"
    | "badRequest"
    | "invalidResolution"
    | "unsupportedConflictType"
    | "notFound";
}

model GitDeletedRepository {
  createdDate?: utcDateTime;
  deletedBy?: IdentityRef;
  deletedDate?: utcDateTime;
  @format("uuid") id?: string;
  name?: string;
  project?: TeamProjectReference;
}

model GitFilePathsCollection {
  commitId?: string;
  paths?: string[];
  url?: string;
}

/** Status information about a requested fork operation. */
model GitForkOperationStatusDetail {
  /** All valid steps for the forking process */
  allSteps?: string[];

  /** Index into AllSteps for the current step */
  currentStep?: int32;

  /** Error message if the operation failed. */
  errorMessage?: string;
}

/** Information about a fork ref. */
model GitForkRef {
  ...GitRef;
  repository?: GitRepository;
}

/** Request to sync data between two forks. */
model GitForkSyncRequest {
  _links?: ReferenceLinks;
  detailedStatus?: GitForkOperationStatusDetail;

  /** Unique identifier for the operation. */
  operationId?: int32;

  source?: GlobalGitRepositoryKey;

  /** If supplied, the set of ref mappings to use when performing a 'sync' or create. If missing, all refs will be synchronized. */
  sourceToTargetRefs?: SourceToTargetRef[];

  @extension(
    "x-ms-enum",
    #{
      name: "GitAsyncOperationStatus",
      values: #[
        #{
          value: "queued",
          description: "The operation is waiting in a queue and has not yet started.",
        },
        #{ value: "inProgress", description: "The operation is currently in progress." },
        #{ value: "completed", description: "The operation has completed." },
        #{ value: "failed", description: "The operation has failed. Check for an error message." },
        #{ value: "abandoned", description: "The operation has been abandoned." }
      ],
    }
  )
  status?: "queued" | "inProgress" | "completed" | "failed" | "abandoned";
}

/** Parameters for creating a fork request */
model GitForkSyncRequestParameters {
  source?: GlobalGitRepositoryKey;

  /** If supplied, the set of ref mappings to use when performing a 'sync' or create. If missing, all refs will be synchronized. */
  sourceToTargetRefs?: SourceToTargetRef[];
}

model GitForkTeamProjectReference {
  ...TeamProjectReference;
}

model GitImportFailedEvent {
  sourceRepositoryName?: string;
  targetRepository?: GitRepository;
}

/** Parameter for creating a git import request when source is Git version control */
model GitImportGitSource {
  /** Tells if this is a sync request or not */
  overwrite?: boolean;

  /** Url for the source repo */
  url?: string;
}

/** A request to import data from a remote source control system. */
model GitImportRequest {
  _links?: ReferenceLinks;
  detailedStatus?: GitImportStatusDetail;

  /** The unique identifier for this import request. */
  importRequestId?: int32;

  parameters?: GitImportRequestParameters;
  repository?: GitRepository;

  /** Current status of the import. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitAsyncOperationStatus",
      values: #[
        #{
          value: "queued",
          description: "The operation is waiting in a queue and has not yet started.",
        },
        #{ value: "inProgress", description: "The operation is currently in progress." },
        #{ value: "completed", description: "The operation has completed." },
        #{ value: "failed", description: "The operation has failed. Check for an error message." },
        #{ value: "abandoned", description: "The operation has been abandoned." }
      ],
    }
  )
  status?: "queued" | "inProgress" | "completed" | "failed" | "abandoned";

  /** A link back to this import request resource. */
  url?: string;
}

/** Parameters for creating an import request */
model GitImportRequestParameters {
  /** Option to delete service endpoint when import is done */
  deleteServiceEndpointAfterImportIsDone?: boolean;

  gitSource?: GitImportGitSource;

  /** Service Endpoint for connection to external endpoint */
  @format("uuid") serviceEndpointId?: string;

  tfvcSource?: GitImportTfvcSource;
}

/** Additional status information about an import request. */
model GitImportStatusDetail {
  /** All valid steps for the import process */
  allSteps?: string[];

  /** Index into AllSteps for the current step */
  currentStep?: int32;

  /** Error message if the operation failed. */
  errorMessage?: string;
}

model GitImportSucceededEvent {
  sourceRepositoryName?: string;
  targetRepository?: GitRepository;
}

/** Parameter for creating a git import request when source is tfvc version control */
model GitImportTfvcSource {
  /** Set true to import History, false otherwise */
  importHistory?: boolean;

  /** Get history for last n days (max allowed value is 180 days) */
  importHistoryDurationInDays?: int32;

  /** Path which we want to import (this can be copied from Path Control in Explorer) */
  path?: string;
}

model GitItem {
  ...ItemModel;

  /** SHA1 of commit item was fetched at */
  commitId?: string;

  /** Type of object (Commit, Tree, Blob, Tag, ...) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitObjectType",
      values: #[
        #{ value: "bad", description: "" },
        #{ value: "commit", description: "" },
        #{ value: "tree", description: "" },
        #{ value: "blob", description: "" },
        #{ value: "tag", description: "" },
        #{ value: "ext2", description: "" },
        #{ value: "ofsDelta", description: "" },
        #{ value: "refDelta", description: "" }
      ],
    }
  )
  gitObjectType?: "bad" | "commit" | "tree" | "blob" | "tag" | "ext2" | "ofsDelta" | "refDelta";

  latestProcessedChange?: GitCommitRef;

  /** Git object id */
  objectId?: string;

  /** Git object id */
  originalObjectId?: string;
}

model GitItemDescriptor {
  /** Path to item */
  path?: string;

  /** Specifies whether to include children (OneLevel), all descendants (Full), or None */
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

  /** Version string (interpretation based on VersionType defined in subclass */
  version?: string;

  /** Version modifiers (e.g. previous) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionOptions",
      values: #[
        #{ value: "none", description: "Not specified" },
        #{
          value: "previousChange",
          description: "Commit that changed item prior to the current version",
        },
        #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
      ],
    }
  )
  versionOptions?: "none" | "previousChange" | "firstParent";

  /** How to interpret version (branch,tag,commit) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionType",
      values: #[
        #{ value: "branch", description: "Interpret the version as a branch name" },
        #{ value: "tag", description: "Interpret the version as a tag name" },
        #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
      ],
    }
  )
  versionType?: "branch" | "tag" | "commit";
}

model GitItemRequestData {
  /** Whether to include metadata for all items */
  includeContentMetadata?: boolean;

  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;

  /** Collection of items to fetch, including path, version, and recursion level */
  itemDescriptors?: GitItemDescriptor[];

  /** Whether to include shallow ref to commit that last changed each item */
  latestProcessedChange?: boolean;
}

model GitLastChangeItem {
  /** Gets or sets the commit Id this item was modified most recently for the provided version. */
  commitId?: string;

  /** Gets or sets the path of the item. */
  path?: string;
}

model GitLastChangeTreeItems {
  /** The list of commits referenced by Items, if they were requested. */
  commits?: GitCommitRef[];

  /** The last change of items. */
  items?: GitLastChangeItem[];

  /** The last explored time, in case the result is not comprehensive. Null otherwise. */
  lastExploredTime?: utcDateTime;
}

model GitMerge {
  ...GitMergeParameters;
  _links?: ReferenceLinks;
  detailedStatus?: GitMergeOperationStatusDetail;

  /** Unique identifier for the merge operation. */
  mergeOperationId?: int32;

  /** Status of the merge operation. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitAsyncOperationStatus",
      values: #[
        #{
          value: "queued",
          description: "The operation is waiting in a queue and has not yet started.",
        },
        #{ value: "inProgress", description: "The operation is currently in progress." },
        #{ value: "completed", description: "The operation has completed." },
        #{ value: "failed", description: "The operation has failed. Check for an error message." },
        #{ value: "abandoned", description: "The operation has been abandoned." }
      ],
    }
  )
  status?: "queued" | "inProgress" | "completed" | "failed" | "abandoned";
}

/** Status information about a requested merge operation. */
model GitMergeOperationStatusDetail {
  /** Error message if the operation failed. */
  failureMessage?: string;

  /** The commitId of the resultant merge commit. */
  mergeCommitId?: string;
}

model GitMergeOriginRef {
  cherryPickId?: int32;
  pullRequestId?: int32;
  revertId?: int32;
}

/** Parameters required for performing git merge. */
model GitMergeParameters {
  /** Comment or message of the commit. */
  comment?: string;

  /** An enumeration of the parent commit IDs for the merge commit. */
  parents?: string[];
}

/** Git object identifier and type information. */
model GitObject {
  /** Object Id (Sha1Id). */
  objectId?: string;

  /** Type of object (Commit, Tree, Blob, Tag) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitObjectType",
      values: #[
        #{ value: "bad", description: "" },
        #{ value: "commit", description: "" },
        #{ value: "tree", description: "" },
        #{ value: "blob", description: "" },
        #{ value: "tag", description: "" },
        #{ value: "ext2", description: "" },
        #{ value: "ofsDelta", description: "" },
        #{ value: "refDelta", description: "" }
      ],
    }
  )
  objectType?: "bad" | "commit" | "tree" | "blob" | "tag" | "ext2" | "ofsDelta" | "refDelta";
}

model GitPathAction {
  @extension(
    "x-ms-enum",
    #{
      name: "GitPathActions",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "edit", description: "" },
        #{ value: "delete", description: "" },
        #{ value: "add", description: "" },
        #{ value: "rename", description: "" }
      ],
    }
  )
  action?: "none" | "edit" | "delete" | "add" | "rename";
  base64Content?: string;
  path?: string;
  rawTextContent?: string;
  targetPath?: string;
}

model GitPathToItemsCollection {
  items?: Record<GitItem[]>;
}

model GitPolicyConfigurationResponse {
  /** The HTTP client methods find the continuation token header in the response and populate this field. */
  continuationToken?: string;

  policyConfigurations?: PolicyConfiguration[];
}

/** Represents all the data associated with a pull request. */
model GitPullRequest {
  _links?: ReferenceLinks;

  /** A string which uniquely identifies this pull request. To generate an artifact ID for a pull request, use this template: ```vstfs:///Git/PullRequestId/{projectId}/{repositoryId}/{pullRequestId}``` */
  artifactId?: string;

  autoCompleteSetBy?: IdentityRef;
  closedBy?: IdentityRef;

  /** The date when the pull request was closed (completed, abandoned, or merged externally). */
  closedDate?: utcDateTime;

  /** The code review ID of the pull request. Used internally. */
  codeReviewId?: int32;

  /** The commits contained in the pull request. */
  commits?: GitCommitRef[];

  completionOptions?: GitPullRequestCompletionOptions;

  /** The most recent date at which the pull request entered the queue to be completed. Used internally. */
  completionQueueTime?: utcDateTime;

  createdBy?: IdentityRef;

  /** The date when the pull request was created. */
  creationDate?: utcDateTime;

  /** The description of the pull request. */
  description?: string;

  forkSource?: GitForkRef;

  /** Multiple mergebases warning */
  hasMultipleMergeBases?: boolean;

  /** This optional parameter allows clients to use server-side dynamic choices for the target ref. Due to preexisting contracts, users _must_ specify a target ref, but this option will cause the server to ignore it and choose dynamically from the user's favorites (or the default branch). */
  ignoreTargetRefAndChooseDynamically?: boolean;

  /** Draft / WIP pull request. */
  isDraft?: boolean;

  /** The labels associated with the pull request. */
  labels?: WebApiTagDefinition[];

  lastMergeCommit?: GitCommitRef;
  lastMergeSourceCommit?: GitCommitRef;
  lastMergeTargetCommit?: GitCommitRef;

  /** If set, pull request merge failed for this reason. */
  mergeFailureMessage?: string;

  /** The type of failure (if any) of the pull request merge. */
  @extension(
    "x-ms-enum",
    #{
      name: "PullRequestMergeFailureType",
      values: #[
        #{ value: "none", description: "Type is not set. Default type." },
        #{ value: "unknown", description: "Pull request merge failure type unknown." },
        #{
          value: "caseSensitive",
          description: "Pull request merge failed due to case mismatch.",
        },
        #{
          value: "objectTooLarge",
          description: "Pull request merge failed due to an object being too large.",
        }
      ],
    }
  )
  mergeFailureType?: "none" | "unknown" | "caseSensitive" | "objectTooLarge";

  /** The ID of the job used to run the pull request merge. Used internally. */
  @format("uuid") mergeId?: string;

  mergeOptions?: GitPullRequestMergeOptions;

  /** The current status of the pull request merge. */
  @extension(
    "x-ms-enum",
    #{
      name: "PullRequestAsyncStatus",
      values: #[
        #{ value: "notSet", description: "Status is not set. Default state." },
        #{ value: "queued", description: "Pull request merge is queued." },
        #{ value: "conflicts", description: "Pull request merge failed due to conflicts." },
        #{ value: "succeeded", description: "Pull request merge succeeded." },
        #{ value: "rejectedByPolicy", description: "Pull request merge rejected by policy." },
        #{ value: "failure", description: "Pull request merge failed." }
      ],
    }
  )
  mergeStatus?: "notSet" | "queued" | "conflicts" | "succeeded" | "rejectedByPolicy" | "failure";

  /** The ID of the pull request. */
  pullRequestId?: int32;

  /** Used internally. */
  remoteUrl?: string;

  repository?: GitRepository;

  /** A list of reviewers on the pull request along with the state of their votes. */
  reviewers?: IdentityRefWithVote[];

  /** The name of the source branch of the pull request. */
  sourceRefName?: string;

  /** The status of the pull request. */
  @extension(
    "x-ms-enum",
    #{
      name: "PullRequestStatus",
      values: #[
        #{ value: "notSet", description: "Status not set. Default state." },
        #{ value: "active", description: "Pull request is active." },
        #{ value: "abandoned", description: "Pull request is abandoned." },
        #{ value: "completed", description: "Pull request is completed." },
        #{
          value: "all",
          description: "Used in pull request search criteria to include all statuses.",
        }
      ],
    }
  )
  status?: "notSet" | "active" | "abandoned" | "completed" | "all";

  /** If true, this pull request supports multiple iterations. Iteration support means individual pushes to the source branch of the pull request can be reviewed and comments left in one iteration will be tracked across future iterations. */
  supportsIterations?: boolean;

  /** The name of the target branch of the pull request. */
  targetRefName?: string;

  /** The title of the pull request. */
  title?: string;

  /** Used internally. */
  url?: string;

  /** Any work item references associated with this pull request. */
  workItemRefs?: ResourceRef[];
}

/** Change made in a pull request. */
model GitPullRequestChange {
  ...GitChange;

  /** ID used to track files through multiple changes. */
  changeTrackingId?: int32;
}

/** Represents a comment thread of a pull request. A thread contains meta data about the file it was left on (if any) along with one or more comments (an initial comment and the subsequent replies). */
model GitPullRequestCommentThread {
  ...CommentThread;
  pullRequestThreadContext?: GitPullRequestCommentThreadContext;
}

/** Comment thread context contains details about what diffs were being viewed at the time of thread creation and whether or not the thread has been tracked from that original diff. */
model GitPullRequestCommentThreadContext {
  /** Used to track a comment across iterations. This value can be found by looking at the iteration's changes list. Must be set for pull requests with iteration support. Otherwise, it's not required for 'legacy' pull requests. */
  changeTrackingId?: int32;

  iterationContext?: CommentIterationContext;
  trackingCriteria?: CommentTrackingCriteria;
}

/** Preferences about how the pull request should be completed. */
model GitPullRequestCompletionOptions {
  /** List of any policy configuration Id's which auto-complete should not wait for. Only applies to optional policies (isBlocking == false). Auto-complete always waits for required policies (isBlocking == true). */
  autoCompleteIgnoreConfigIds?: int32[];

  /** If true, policies will be explicitly bypassed while the pull request is completed. */
  bypassPolicy?: boolean;

  /** If policies are bypassed, this reason is stored as to why bypass was used. */
  bypassReason?: string;

  /** If true, the source branch of the pull request will be deleted after completion. */
  deleteSourceBranch?: boolean;

  /** If set, this will be used as the commit message of the merge commit. */
  mergeCommitMessage?: string;

  /** Specify the strategy used to merge the pull request during completion. If MergeStrategy is not set to any value, the service selects the first merge strategy not prohibited by the target branch’s policy. If the limit merge type policy is not configured, the default is noFastForward unless the deprecated SquashMerge is true, in which case the default is squash. If an explicit value is provided for MergeStrategy, the SquashMerge property will be ignored. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitPullRequestMergeStrategy",
      values: #[
        #{
          value: "noFastForward",
          description: "A two-parent, no-fast-forward merge. The source branch is unchanged. This is the default behavior.",
        },
        #{
          value: "squash",
          description: "Put all changes from the pull request into a single-parent commit.",
        },
        #{
          value: "rebase",
          description: "Rebase the source branch on top of the target branch HEAD commit, and fast-forward the target branch. The source branch is updated during the rebase operation.",
        },
        #{
          value: "rebaseMerge",
          description: "Rebase the source branch on top of the target branch HEAD commit, and create a two-parent, no-fast-forward merge. The source branch is updated during the rebase operation.",
        }
      ],
    }
  )
  mergeStrategy?: "noFastForward" | "squash" | "rebase" | "rebaseMerge";

  /** SquashMerge is deprecated. You should explicitly set the value of MergeStrategy. This flag is only used when MergeStrategy is not specified and the target branch has no merge-strategy policy configured. In all other cases it is ignored. */
  squashMerge?: boolean;

  /** If true, we will attempt to transition any work items linked to the pull request into the next logical state (i.e. Active -> Resolved) */
  transitionWorkItems?: boolean;

  /** If true, the current completion attempt was triggered via auto-complete. Used internally. */
  triggeredByAutoComplete?: boolean;
}

/** Collection of file diffs for a pull request. */
model GitPullRequestFilesDiff {
  /** File diffs for all changed files in the pull request. */
  fileDiffs?: FileDiffDetail[];

  /** Description of the pull request. */
  pullRequestDescription?: string;

  /** Title of the pull request. */
  pullRequestTitle?: string;
}

/** Provides properties that describe a Git pull request iteration. Iterations are created as a result of creating and pushing updates to a pull request. */
model GitPullRequestIteration {
  _links?: ReferenceLinks;
  author?: IdentityRef;

  /** Changes included with the pull request iteration. */
  changeList?: GitPullRequestChange[];

  /** The commits included with the pull request iteration. */
  commits?: GitCommitRef[];

  commonRefCommit?: GitCommitRef;

  /** The creation date of the pull request iteration. */
  createdDate?: utcDateTime;

  /** Description of the pull request iteration. */
  description?: string;

  /** Indicates if the Commits property contains a truncated list of commits in this pull request iteration. */
  hasMoreCommits?: boolean;

  /** ID of the pull request iteration. Iterations are created as a result of creating and pushing updates to a pull request. */
  id?: int32;

  /** If the iteration reason is Retarget, this is the refName of the new target */
  newTargetRefName?: string;

  /** If the iteration reason is Retarget, this is the original target refName */
  oldTargetRefName?: string;

  push?: GitPushRef;

  /** The reason for which the pull request iteration was created. */
  @extension(
    "x-ms-enum",
    #{
      name: "IterationReason",
      values: #[
        #{ value: "push", description: "" },
        #{ value: "forcePush", description: "" },
        #{ value: "create", description: "" },
        #{ value: "rebase", description: "" },
        #{ value: "unknown", description: "" },
        #{ value: "retarget", description: "" },
        #{ value: "resolveConflicts", description: "" }
      ],
    }
  )
  reason?: "push" | "forcePush" | "create" | "rebase" | "unknown" | "retarget" | "resolveConflicts";

  sourceRefCommit?: GitCommitRef;
  targetRefCommit?: GitCommitRef;

  /** The updated date of the pull request iteration. */
  updatedDate?: utcDateTime;
}

/** Collection of changes made in a pull request. */
model GitPullRequestIterationChanges {
  /** Changes made in the iteration. */
  changeEntries?: GitPullRequestChange[];

  /** Value to specify as skip to get the next page of changes. This will be zero if there are no more changes. */
  nextSkip?: int32;

  /** Value to specify as top to get the next page of changes. This will be zero if there are no more changes. */
  nextTop?: int32;
}

/** The options which are used when a pull request merge is created. */
model GitPullRequestMergeOptions {
  /** If true, conflict resolutions applied during the merge will be put in separate commits to preserve authorship info for git blame, etc. */
  conflictAuthorshipCommits?: boolean;

  /** If true, renames where there is more than one valid way to map the original file locations to renamed file locations will be treated as false positives and ignored. */
  detectRenameFalsePositives?: boolean;

  /** If true, rename detection will not be performed during the merge. */
  disableRenames?: boolean;
}

/** A set of pull request queries and their results. */
model GitPullRequestQuery {
  /** The queries to perform. */
  queries?: GitPullRequestQueryInput[];

  /** The results of the queries. This matches the QueryInputs list so Results[n] are the results of QueryInputs[n]. Each entry in the list is a dictionary of commit->pull requests. */
  results?: Record<GitPullRequest[]>[];
}

/** Pull request query input parameters. */
model GitPullRequestQueryInput {
  /** Options for including additional PR properties in the response. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitPullRequestQueryIncludeOptions",
      values: #[
        #{ value: "notSet", description: "No additional elements included." },
        #{ value: "labels", description: "Enforces adding associated labels to the response." }
      ],
    }
  )
  include?: "notSet" | "labels";

  /** The list of commit IDs to search for. */
  items?: string[];

  /** The type of query to perform. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitPullRequestQueryType",
      values: #[
        #{ value: "notSet", description: "No query type set." },
        #{
          value: "lastMergeCommit",
          description: "Search for pull requests that created the supplied merge commits.",
        },
        #{
          value: "commit",
          description: "Search for pull requests that merged the supplied commits.",
        }
      ],
    }
  )
  type?: "notSet" | "lastMergeCommit" | "commit";
}

model GitPullRequestReviewFileContentInfo {
  _links?: ReferenceLinks;

  /** The file change path. */
  path?: string;

  /** Content hash of on-disk representation of file content. Its calculated by the client by using SHA1 hash function. Ensure that uploaded file has same encoding as in source control. */
  shA1Hash?: string;
}

/** Pull requests can be searched for matching this criteria. */
model GitPullRequestSearchCriteria {
  /** If set, search for pull requests that were created by this identity. */
  @format("uuid") creatorId?: string;

  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;

  /** If set, filters pull requests that have labels matching the specified label names. */
  labels?: string[];

  /** If specified, filters pull requests that created/closed before this date based on the queryTimeRangeType specified. */
  maxTime?: utcDateTime;

  /** If specified, filters pull requests that created/closed after this date based on the queryTimeRangeType specified. */
  minTime?: utcDateTime;

  /** The type of time range which should be used for minTime and maxTime. Defaults to Created if unset. */
  @extension(
    "x-ms-enum",
    #{
      name: "PullRequestTimeRangeType",
      values: #[
        #{ value: "created", description: "The date when the pull request was created." },
        #{
          value: "closed",
          description: "The date when the pull request was closed (completed, abandoned, or merged externally).",
        }
      ],
    }
  )
  queryTimeRangeType?: "created" | "closed";

  /** If set, search for pull requests whose target branch is in this repository. */
  @format("uuid") repositoryId?: string;

  /** If set, search for pull requests that have this identity as a reviewer. */
  @format("uuid") reviewerId?: string;

  /** If set, search for pull requests from this branch. */
  sourceRefName?: string;

  /** If set, search for pull requests whose source branch is in this repository. */
  @format("uuid") sourceRepositoryId?: string;

  /** If set, search for pull requests that are in this state. Defaults to Active if unset. */
  @extension(
    "x-ms-enum",
    #{
      name: "PullRequestStatus",
      values: #[
        #{ value: "notSet", description: "Status not set. Default state." },
        #{ value: "active", description: "Pull request is active." },
        #{ value: "abandoned", description: "Pull request is abandoned." },
        #{ value: "completed", description: "Pull request is completed." },
        #{
          value: "all",
          description: "Used in pull request search criteria to include all statuses.",
        }
      ],
    }
  )
  status?: "notSet" | "active" | "abandoned" | "completed" | "all";

  /** The operator used for filtering by labels. Defaults to And if unset. When And is used, pull requests must have all specified labels. When Or is used, pull requests must have at least one of the specified labels. */
  @extension(
    "x-ms-enum",
    #{
      name: "TagsFilterOperator",
      values: #[
        #{ value: "and", description: "Pull request must have ALL specified tags." },
        #{ value: "or", description: "Pull request must have AT LEAST ONE of the specified tags." }
      ],
    }
  )
  tagsFilterOperator?: "and" | "or";

  /** If set, search for pull requests into this branch. */
  targetRefName?: string;

  /** If set, filters pull requests that contain the specified text in the title. */
  title?: string;
}

/** This class contains the metadata of a service/extension posting pull request status. Status can be associated with a pull request or an iteration. */
model GitPullRequestStatus {
  ...GitStatus;

  /** ID of the iteration to associate status with. Minimum value is 1. */
  iterationId?: int32;

  properties?: PropertiesCollection;
}

model GitPush {
  ...GitPushRef;
  commits?: GitCommitRef[];
  refUpdates?: GitRefUpdate[];
  repository?: GitRepository;
}

model GitPushEventData {
  afterId?: string;
  beforeId?: string;
  branch?: string;
  commits?: GitCommit[];
  repository?: GitRepository;
}

model GitPushRef {
  _links?: ReferenceLinks;
  date?: utcDateTime;
  pushedBy?: IdentityRef;
  pushId?: int32;
  url?: string;
}

model GitPushSearchCriteria {
  fromDate?: utcDateTime;

  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;

  includeRefUpdates?: boolean;
  @format("uuid") pusherId?: string;
  refName?: string;
  toDate?: utcDateTime;
}

model GitQueryBranchStatsCriteria {
  baseCommit?: GitVersionDescriptor;
  targetCommits?: GitVersionDescriptor[];
}

model GitQueryCommitsCriteria {
  /** Number of entries to skip */
  $skip?: int32;

  /** Maximum number of entries to retrieve */
  $top?: int32;

  /** Alias or display name of the author */
  author?: string;

  compareVersion?: GitVersionDescriptor;

  /** Only applies when an itemPath is specified. This determines whether to exclude delete entries of the specified path. */
  excludeDeletes?: boolean;

  /** If provided, a lower bound for filtering commits alphabetically */
  fromCommitId?: string;

  /** If provided, only include history entries created after this date (string) */
  fromDate?: string;

  /** What Git history mode should be used. This only applies to the search criteria when Ids = null and an itemPath is specified. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitHistoryMode",
      values: #[
        #{
          value: "simplifiedHistory",
          description: "The history mode used by `git log`. This is the default.",
        },
        #{
          value: "firstParent",
          description: "The history mode used by `git log --first-parent`",
        },
        #{
          value: "fullHistory",
          description: "The history mode used by `git log --full-history`",
        },
        #{
          value: "fullHistorySimplifyMerges",
          description: "The history mode used by `git log --full-history --simplify-merges`",
        }
      ],
    }
  )
  historyMode?: "simplifiedHistory" | "firstParent" | "fullHistory" | "fullHistorySimplifyMerges";

  /** If provided, specifies the exact commit ids of the commits to fetch. May not be combined with other parameters. */
  ids?: string[];

  /** Whether to include the _links field on the shallow references */
  includeLinks?: boolean;

  /** Whether to include the push information */
  includePushData?: boolean;

  /** Whether to include the image Url for committers and authors */
  includeUserImageUrl?: boolean;

  /** Whether to include linked work items */
  includeWorkItems?: boolean;

  /** Path of item to search under */
  itemPath?: string;

  itemVersion?: GitVersionDescriptor;

  /** If enabled, this option will ignore the itemVersion and compareVersion parameters */
  showOldestCommitsFirst?: boolean;

  /** If provided, an upper bound for filtering commits alphabetically */
  toCommitId?: string;

  /** If provided, only include history entries created before this date (string) */
  toDate?: string;

  /** Alias or display name of the committer */
  user?: string;
}

model GitQueryRefsCriteria {
  /** List of commit Ids to be searched */
  commitIds?: string[];

  /** List of complete or partial names for refs to be searched */
  refNames?: string[];

  /** Type of search on refNames, if provided */
  @extension(
    "x-ms-enum",
    #{
      name: "GitRefSearchType",
      values: #[
        #{ value: "exact", description: "" },
        #{ value: "startsWith", description: "" },
        #{ value: "contains", description: "" }
      ],
    }
  )
  searchType?: "exact" | "startsWith" | "contains";
}

model GitRecycleBinRepositoryDetails {
  /** Setting to false will undo earlier deletion and restore the repository. */
  deleted?: boolean;
}

model GitRef {
  _links?: ReferenceLinks;
  creator?: IdentityRef;
  isLocked?: boolean;
  isLockedBy?: IdentityRef;
  name?: string;
  objectId?: string;
  peeledObjectId?: string;
  statuses?: GitStatus[];
  url?: string;
}

model GitRefFavorite {
  _links?: ReferenceLinks;
  id?: int32;
  @format("uuid") identityId?: string;
  name?: string;
  @format("uuid") repositoryId?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "RefFavoriteType",
      values: #[
        #{ value: "invalid", description: "" },
        #{ value: "folder", description: "" },
        #{ value: "ref", description: "" }
      ],
    }
  )
  type?: "invalid" | "folder" | "ref";
  url?: string;
}

model GitRefUpdate {
  isLocked?: boolean;
  name?: string;
  newObjectId?: string;
  oldObjectId?: string;
  @format("uuid") repositoryId?: string;
}

model GitRefUpdateResult {
  /** Custom message for the result object For instance, Reason for failing. */
  customMessage?: string;

  /** Whether the ref is locked or not */
  isLocked?: boolean;

  /** Ref name */
  name?: string;

  /** New object ID */
  newObjectId?: string;

  /** Old object ID */
  oldObjectId?: string;

  /** Name of the plugin that rejected the updated. */
  rejectedBy?: string;

  /** Repository ID */
  @format("uuid") repositoryId?: string;

  /** True if the ref update succeeded, false otherwise */
  success?: boolean;

  /** Status of the update from the TFS server. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitRefUpdateStatus",
      values: #[
        #{
          value: "succeeded",
          description: "Indicates that the ref update request was completed successfully.",
        },
        #{
          value: "forcePushRequired",
          description: "Indicates that the ref update request could not be completed because part of the graph would be disconnected by this change, and the caller does not have ForcePush permission on the repository.",
        },
        #{
          value: "staleOldObjectId",
          description: "Indicates that the ref update request could not be completed because the old object ID presented in the request was not the object ID of the ref when the database attempted the update. The most likely scenario is that the caller lost a race to update the ref.",
        },
        #{
          value: "invalidRefName",
          description: "Indicates that the ref update request could not be completed because the ref name presented in the request was not valid.",
        },
        #{ value: "unprocessed", description: "The request was not processed" },
        #{
          value: "unresolvableToCommit",
          description: "The ref update request could not be completed because the new object ID for the ref could not be resolved to a commit object (potentially through any number of tags)",
        },
        #{
          value: "writePermissionRequired",
          description: "The ref update request could not be completed because the user lacks write permissions required to write this ref",
        },
        #{
          value: "manageNotePermissionRequired",
          description: "The ref update request could not be completed because the user lacks note creation permissions required to write this note",
        },
        #{
          value: "createBranchPermissionRequired",
          description: "The ref update request could not be completed because the user lacks the permission to create a branch",
        },
        #{
          value: "createTagPermissionRequired",
          description: "The ref update request could not be completed because the user lacks the permission to create a tag",
        },
        #{
          value: "rejectedByPlugin",
          description: "The ref update could not be completed because it was rejected by the plugin.",
        },
        #{
          value: "locked",
          description: "The ref update could not be completed because the ref is locked by another user.",
        },
        #{
          value: "refNameConflict",
          description: "The ref update could not be completed because, in case-insensitive mode, the ref name conflicts with an existing, differently-cased ref name.",
        },
        #{
          value: "rejectedByPolicy",
          description: "The ref update could not be completed because it was rejected by policy.",
        },
        #{
          value: "succeededNonExistentRef",
          description: "Indicates that the ref update request was completed successfully, but the ref doesn't actually exist so no changes were made. This should only happen during deletes.",
        },
        #{
          value: "succeededCorruptRef",
          description: "Indicates that the ref update request was completed successfully, but the passed-in ref was corrupt - as in, the old object ID was bad. This should only happen during deletes.",
        }
      ],
    }
  )
  updateStatus?:
    | "succeeded"
    | "forcePushRequired"
    | "staleOldObjectId"
    | "invalidRefName"
    | "unprocessed"
    | "unresolvableToCommit"
    | "writePermissionRequired"
    | "manageNotePermissionRequired"
    | "createBranchPermissionRequired"
    | "createTagPermissionRequired"
    | "rejectedByPlugin"
    | "locked"
    | "refNameConflict"
    | "rejectedByPolicy"
    | "succeededNonExistentRef"
    | "succeededCorruptRef";
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

model GitRepositoryCreateOptions {
  name?: string;
  parentRepository?: GitRepositoryRef;
  project?: TeamProjectReference;
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

model GitRepositoryStats {
  activePullRequestsCount?: int32;
  branchesCount?: int32;
  commitsCount?: int32;
  repositoryId?: string;
}

model GitResolution {
  author?: IdentityRef;
}

model GitResolutionMergeContent {
  ...GitResolution;
  @extension(
    "x-ms-enum",
    #{
      name: "GitResolutionMergeType",
      values: #[
        #{ value: "undecided", description: "" },
        #{ value: "takeSourceContent", description: "" },
        #{ value: "takeTargetContent", description: "" },
        #{ value: "autoMerged", description: "" },
        #{ value: "userMerged", description: "" }
      ],
    }
  )
  mergeType?: "undecided" | "takeSourceContent" | "takeTargetContent" | "autoMerged" | "userMerged";
  userMergedBlob?: GitBlobRef;
  userMergedContent?: bytes[];
}

model GitResolutionPathConflict {
  ...GitResolution;
  @extension(
    "x-ms-enum",
    #{
      name: "GitResolutionPathConflictAction",
      values: #[
        #{ value: "undecided", description: "" },
        #{ value: "keepSourceRenameTarget", description: "" },
        #{ value: "keepSourceDeleteTarget", description: "" },
        #{ value: "keepTargetRenameSource", description: "" },
        #{ value: "keepTargetDeleteSource", description: "" }
      ],
    }
  )
  action?:
    | "undecided"
    | "keepSourceRenameTarget"
    | "keepSourceDeleteTarget"
    | "keepTargetRenameSource"
    | "keepTargetDeleteSource";
  renamePath?: string;
}

model GitResolutionPickOneAction {
  ...GitResolution;
  @extension(
    "x-ms-enum",
    #{
      name: "GitResolutionWhichAction",
      values: #[
        #{ value: "undecided", description: "" },
        #{ value: "pickSourceAction", description: "" },
        #{ value: "pickTargetAction", description: "" }
      ],
    }
  )
  action?: "undecided" | "pickSourceAction" | "pickTargetAction";
}

model GitResolutionRename1to2 {
  ...GitResolutionMergeContent;
  @extension(
    "x-ms-enum",
    #{
      name: "GitResolutionRename1to2Action",
      values: #[
        #{ value: "undecided", description: "" },
        #{ value: "keepSourcePath", description: "" },
        #{ value: "keepTargetPath", description: "" },
        #{ value: "keepBothFiles", description: "" }
      ],
    }
  )
  action?: "undecided" | "keepSourcePath" | "keepTargetPath" | "keepBothFiles";
}

model GitRevert {
  ...GitAsyncRefOperation;
  revertId?: int32;
}

/** This class contains the metadata of a service/extension posting a status. */
model GitStatus {
  _links?: ReferenceLinks;
  context?: GitStatusContext;
  createdBy?: IdentityRef;

  /** Creation date and time of the status. */
  creationDate?: utcDateTime;

  /** Status description. Typically describes current state of the status. */
  description?: string;

  /** Status identifier. */
  id?: int32;

  /** State of the status. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitStatusState",
      values: #[
        #{ value: "notSet", description: "Status state not set. Default state." },
        #{ value: "pending", description: "Status pending." },
        #{ value: "succeeded", description: "Status succeeded." },
        #{ value: "failed", description: "Status failed." },
        #{ value: "error", description: "Status with an error." },
        #{ value: "notApplicable", description: "Status is not applicable to the target object." },
        #{
          value: "partiallySucceeded",
          description: "Status Partially Succeeded, build finished with warnings.",
        }
      ],
    }
  )
  state?:
    | "notSet"
    | "pending"
    | "succeeded"
    | "failed"
    | "error"
    | "notApplicable"
    | "partiallySucceeded";

  /** URL with status details. */
  targetUrl?: string;

  /** Last update date and time of the status. */
  updatedDate?: utcDateTime;
}

/** Status context that uniquely identifies the status. */
model GitStatusContext {
  /** Genre of the status. Typically name of the service/tool generating the status, can be empty. */
  genre?: string;

  /** Name identifier of the status, cannot be null or empty. */
  name?: string;
}

/** An object describing the git suggestion. Git suggestions are currently limited to suggested pull requests. */
model GitSuggestion {
  /** Specific properties describing the suggestion. */
  properties?: Record<{}>;

  /** The type of suggestion (e.g. pull request). */
  type?: string;
}

model GitTargetVersionDescriptor {
  ...GitVersionDescriptor;

  /** Version string identifier (name of tag/branch, SHA1 of commit) */
  targetVersion?: string;

  /** Version options - Specify additional modifiers to version (e.g Previous) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionOptions",
      values: #[
        #{ value: "none", description: "Not specified" },
        #{
          value: "previousChange",
          description: "Commit that changed item prior to the current version",
        },
        #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
      ],
    }
  )
  targetVersionOptions?: "none" | "previousChange" | "firstParent";

  /** Version type (branch, tag, or commit). Determines how Id is interpreted */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionType",
      values: #[
        #{ value: "branch", description: "Interpret the version as a branch name" },
        #{ value: "tag", description: "Interpret the version as a tag name" },
        #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
      ],
    }
  )
  targetVersionType?: "branch" | "tag" | "commit";
}

model GitTemplate {
  /** Name of the Template */
  name?: string;

  /** Type of the Template */
  type?: string;
}

model GitTreeDiff {
  /** ObjectId of the base tree of this diff. */
  baseTreeId?: string;

  /** List of tree entries that differ between the base and target tree. Renames and object type changes are returned as a delete for the old object and add for the new object. If a continuation token is returned in the response header, some tree entries are yet to be processed and may yield more diff entries. If the continuation token is not returned all the diff entries have been included in this response. */
  diffEntries?: GitTreeDiffEntry[];

  /** ObjectId of the target tree of this diff. */
  targetTreeId?: string;

  /** REST Url to this resource. */
  url?: string;
}

model GitTreeDiffEntry {
  /** SHA1 hash of the object in the base tree, if it exists. Will be null in case of adds. */
  baseObjectId?: string;

  /** Type of change that affected this entry. */
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

  /** Object type of the tree entry. Blob, Tree or Commit('submodule') */
  @extension(
    "x-ms-enum",
    #{
      name: "GitObjectType",
      values: #[
        #{ value: "bad", description: "" },
        #{ value: "commit", description: "" },
        #{ value: "tree", description: "" },
        #{ value: "blob", description: "" },
        #{ value: "tag", description: "" },
        #{ value: "ext2", description: "" },
        #{ value: "ofsDelta", description: "" },
        #{ value: "refDelta", description: "" }
      ],
    }
  )
  objectType?: "bad" | "commit" | "tree" | "blob" | "tag" | "ext2" | "ofsDelta" | "refDelta";

  /** Relative path in base and target trees. */
  path?: string;

  /** SHA1 hash of the object in the target tree, if it exists. Will be null in case of deletes. */
  targetObjectId?: string;
}

model GitTreeDiffResponse {
  /** The HTTP client methods find the continuation token header in the response and populate this field. */
  continuationToken?: string[];

  treeDiff?: GitTreeDiff;
}

model GitTreeEntryRef {
  /** Blob or tree */
  @extension(
    "x-ms-enum",
    #{
      name: "GitObjectType",
      values: #[
        #{ value: "bad", description: "" },
        #{ value: "commit", description: "" },
        #{ value: "tree", description: "" },
        #{ value: "blob", description: "" },
        #{ value: "tag", description: "" },
        #{ value: "ext2", description: "" },
        #{ value: "ofsDelta", description: "" },
        #{ value: "refDelta", description: "" }
      ],
    }
  )
  gitObjectType?: "bad" | "commit" | "tree" | "blob" | "tag" | "ext2" | "ofsDelta" | "refDelta";

  /** Mode represented as octal string */
  mode?: string;

  /** SHA1 hash of git object */
  objectId?: string;

  /** Path relative to parent tree object */
  relativePath?: string;

  /** Size of content */
  size?: int64;

  /** url to retrieve tree or blob */
  url?: string;
}

model GitTreeRef {
  _links?: ReferenceLinks;

  /** SHA1 hash of git object */
  objectId?: string;

  /** Sum of sizes of all children */
  size?: int64;

  /** Blobs and trees under this tree */
  treeEntries?: GitTreeEntryRef[];

  /** Url to tree */
  url?: string;
}

/** User info and date for Git operations. */
model GitUserDate {
  /** Date of the Git operation. */
  date?: utcDateTime;

  /** Email address of the user performing the Git operation. */
  email?: string;

  /** Url for the user's avatar. */
  imageUrl?: string;

  /** Name of the user performing the Git operation. */
  name?: string;
}

model GitVersionDescriptor {
  /** Version string identifier (name of tag/branch, SHA1 of commit) */
  version?: string;

  /** Version options - Specify additional modifiers to version (e.g Previous) */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionOptions",
      values: #[
        #{ value: "none", description: "Not specified" },
        #{
          value: "previousChange",
          description: "Commit that changed item prior to the current version",
        },
        #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
      ],
    }
  )
  versionOptions?: "none" | "previousChange" | "firstParent";

  /** Version type (branch, tag, or commit). Determines how Id is interpreted */
  @extension(
    "x-ms-enum",
    #{
      name: "GitVersionType",
      values: #[
        #{ value: "branch", description: "Interpret the version as a branch name" },
        #{ value: "tag", description: "Interpret the version as a tag name" },
        #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
      ],
    }
  )
  versionType?: "branch" | "tag" | "commit";
}

/** Globally unique key for a repository. */
model GlobalGitRepositoryKey {
  /** Team Project Collection ID of the collection for the repository. */
  @format("uuid") collectionId?: string;

  /** Team Project ID of the project for the repository. */
  @format("uuid") projectId?: string;

  /** ID of the repository. */
  @format("uuid") repositoryId?: string;
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

model HistoryEntry {
  changeList?: ChangeList;

  /** The change made to the item from this change list (only relevant for File history, not folders) */
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
  itemChangeType?:
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

  /** The path of the item at this point in history (only relevant for File history, not folders) */
  serverItem?: string;
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

/** Identity information including a vote on a pull request. */
model IdentityRefWithVote {
  ...IdentityRef;

  /** Indicates if this reviewer has declined to review this pull request. */
  hasDeclined?: boolean;

  /** Indicates if this reviewer is flagged for attention on this pull request. */
  isFlagged?: boolean;

  /** Indicates if this approve vote should still be handled even though vote didn't change. */
  isReapprove?: boolean;

  /** Indicates if this is a required reviewer for this pull request. <br /> Branches can have policies that require particular reviewers are required for pull requests. */
  isRequired?: boolean;

  /** URL to retrieve information about this identity */
  reviewerUrl?: string;

  /** Vote on a pull request:<br /> 10 - approved 5 - approved with suggestions 0 - no vote -5 - waiting for author -10 - rejected */
  vote?: int16;

  /** Groups or teams that this reviewer contributed to. <br /> Groups and teams can be reviewers on pull requests but can not vote directly. When a member of the group or team votes, that vote is rolled up into the group or team vote. VotedFor is a list of such votes. */
  votedFor?: IdentityRefWithVote[];
}

model ImportRepositoryValidation {
  gitSource?: GitImportGitSource;
  password?: string;
  tfvcSource?: GitImportTfvcSource;
  username?: string;
}

model IncludedGitCommit {
  commitId?: string;
  commitTime?: utcDateTime;
  parentCommitIds?: string[];
  @format("uuid") repositoryId?: string;
}

/** Real time event (SignalR) for IsDraft update on a pull request */
model IsDraftUpdatedEvent {
  ...RealTimePullRequestEvent;
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

/** Optional details to include when returning an item model */
model ItemDetailsOptions {
  /** If true, include metadata about the file type */
  includeContentMetadata?: boolean;

  /** Specifies whether to include children (OneLevel), all descendants (Full) or None for folder items */
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

/** Real time event (SignalR) for updated labels on a pull request */
model LabelsUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** The class to represent the line diff block */
model LineDiffBlock {
  /** Type of change that was made to the block. */
  @extension(
    "x-ms-enum",
    #{
      name: "LineDiffBlockChangeType",
      values: #[
        #{ value: "none", description: "No change - both the blocks are identical" },
        #{ value: "add", description: "Lines were added to the block in the modified file" },
        #{
          value: "delete",
          description: "Lines were deleted from the block in the original file",
        },
        #{ value: "edit", description: "Lines were modified" }
      ],
    }
  )
  changeType?: "none" | "add" | "delete" | "edit";

  /** Line number where this block starts in modified file. */
  modifiedLineNumberStart?: int32;

  /** Count of lines in this block in modified file. */
  modifiedLinesCount?: int32;

  /** Line number where this block starts in original file. */
  originalLineNumberStart?: int32;

  /** Count of lines in this block in original file. */
  originalLinesCount?: int32;
}

/** The class to represent a detailed line diff block with line content */
model LineDiffBlockDetail {
  /** Type of change that was made to the block. */
  @extension(
    "x-ms-enum",
    #{
      name: "LineDiffBlockChangeType",
      values: #[
        #{ value: "none", description: "No change - both the blocks are identical" },
        #{ value: "add", description: "Lines were added to the block in the modified file" },
        #{
          value: "delete",
          description: "Lines were deleted from the block in the original file",
        },
        #{ value: "edit", description: "Lines were modified" }
      ],
    }
  )
  changeType?: "none" | "add" | "delete" | "edit";

  /** Line number where this block starts in modified file. */
  modifiedLineNumberStart?: int32;

  /** Modified lines of content in this block. */
  modifiedLines?: string[];

  /** Count of lines in this block in modified file. */
  modifiedLinesCount?: int32;

  /** Line number where this block starts in original file. */
  originalLineNumberStart?: int32;

  /** Original lines of content in this block. */
  originalLines?: string[];

  /** Count of lines in this block in original file. */
  originalLinesCount?: int32;
}

/** Real time event (SignalR) for a merge completed on a pull request */
model MergeCompletedEvent {
  ...RealTimePullRequestEvent;
}

/** An Enterprise Live Migration */
model Migration {
  /** The name of the agent pool used to run the migration pipeline. */
  agentPoolName?: string;

  changedBy?: IdentityRef;

  /** The UTC date/time this migration was last changed. */
  changedDate?: utcDateTime;

  /** The UTC date/time of the last successful code synchronization pass. */
  codeSyncDate?: utcDateTime;

  configOptions?: ElmConfigOptions;
  createdBy?: IdentityRef;

  /** The UTC date/time this migration was created. */
  createdDate?: utcDateTime;

  /** The error that caused this migration to fail. */
  errorMessage?: string;

  /** The UTC date/time of the last successful pull request synchronization pass. */
  pullRequestSyncDate?: utcDateTime;

  /** RepositoryId */
  @format("uuid") repositoryId?: string;

  /** The UTC date/time representing when the cutover is to occur. */
  scheduledCutoverDate?: utcDateTime;

  /** The ID of the GitHub Enterprise Server service connection that holds the PAT used to authenticate against the target GitHub Enterprise Server. */
  @format("uuid") serviceEndpointId?: string;

  /** The pre-migration validation policies that are being skipped. */
  @extension(
    "x-ms-enum",
    #{
      name: "SkipValidationPolicy",
      values: #[
        #{ value: "none", description: "Do not skip any validation policies." },
        #{
          value: "activePullRequestCount",
          description: "Skip the active pull request count policy.",
        },
        #{
          value: "pullRequestDeltaSize",
          description: "Skip the pull request delta size policy.",
        },
        #{ value: "agentPoolExists", description: "Skip the agent pool exists policy." },
        #{ value: "maxFileSize", description: "Skip the max file size policy." },
        #{ value: "maxPullRequestSize", description: "Skip the max pull request size policy." },
        #{ value: "maxPushPackSize", description: "Skip the max push pack size policy." },
        #{
          value: "maxReferenceNameLength",
          description: "Skip the max reference name length policy.",
        },
        #{
          value: "targetRepositoryDoesNotExist",
          description: "Skip the target repository does not exist policy.",
        },
        #{
          value: "sourceRepositoryContainsLfsObjects",
          description: "Skip the source repository contains LFS objects policy.",
        },
        #{
          value: "sourceRepositoryNotReadOnly",
          description: "Skip the source repository read-only (maintenance) check policy.",
        },
        #{
          value: "boardsGitHubConnectionProvisioning",
          description: "Skip provisioning of Boards GitHub connection.",
        },
        #{ value: "all", description: "Skip all validation policies." }
      ],
    }
  )
  skipValidation?:
    | "none"
    | "activePullRequestCount"
    | "pullRequestDeltaSize"
    | "agentPoolExists"
    | "maxFileSize"
    | "maxPullRequestSize"
    | "maxPushPackSize"
    | "maxReferenceNameLength"
    | "targetRepositoryDoesNotExist"
    | "sourceRepositoryContainsLfsObjects"
    | "sourceRepositoryNotReadOnly"
    | "boardsGitHubConnectionProvisioning"
    | "all";

  /** The current stage of the migration (Queued, Validation, Synchronization, Cutover, Migrated). */
  @extension(
    "x-ms-enum",
    #{
      name: "MigrationStage",
      values: #[
        #{
          value: "queued",
          description: "The migration has been created but pre-check validation has not started yet.",
        },
        #{ value: "validation", description: "Pre-check validation is in progress." },
        #{ value: "synchronization", description: "Code and PR synchronization is in progress." },
        #{ value: "cutover", description: "The migration is in the cutover phase." },
        #{ value: "migrated", description: "The migration has been fully migrated." },
        #{
          value: "readyForCutover",
          description: "Initial backfill is complete. Delta synchronization continues until cutover is scheduled.",
        },
        #{
          value: "degraded",
          description: "GitHub migration provisioning failed; the migration will retry synchronization on the next job run without re-running validation.",
        },
        #{
          value: "reviewForCutover",
          description: "Cutover is blocked because failed or blocked resources were detected. The user must review failures and approve before cutover can proceed.",
        }
      ],
    }
  )
  stage?:
    | "queued"
    | "validation"
    | "synchronization"
    | "cutover"
    | "migrated"
    | "readyForCutover"
    | "degraded"
    | "reviewForCutover";

  /** If the migration is 'active', 'complete', or 'failed'. */
  @extension(
    "x-ms-enum",
    #{
      name: "MigrationStatus",
      values: #[
        #{ value: "active", description: "The migration is active." },
        #{ value: "completed", description: "The migration has completed successfully." },
        #{
          value: "failed",
          description: "The migration has completed with a failure. The error details can be found in the Migration.Error property.",
        },
        #{ value: "paused", description: "The migration was paused." }
      ],
    }
  )
  status?: "active" | "completed" | "failed" | "paused";

  /** The ID of the user that will end up owning the migrated repository. */
  targetOwnerUserId?: string;

  /** URL identifying the destination respository of migration. */
  targetRepository?: string;

  /** True if the migration should only perform pre-migration validation. */
  validateOnly?: boolean;

  /** A list of any issues found during pre-migration checks. */
  validationIssues?: string[];
}

/** A classification finding for a pipeline. Each finding represents a characteristic that makes the pipeline complex (e.g., cross-repo references, multi-checkout). A pipeline with zero findings is Simple. */
model PipelineClassificationFinding {
  /** External repositories involved in the finding, if any. */
  affectedRepositories?: string[];

  /** User-facing description of the issue. */
  description?: string;

  /** Short stable identifier for the rule that produced this finding. */
  ruleName?: string;
}

/** Represents the rewiring state of a single pipeline within a migration. */
model PipelineRewireEntry {
  /** True if the user has acknowledged this pipeline (e.g., confirmed a complex pipeline has been manually fixed). Acknowledged pipelines do not block cutover. */
  acknowledged?: boolean;

  /** The classification of the pipeline. */
  @extension(
    "x-ms-enum",
    #{
      name: "PipelineClassification",
      values: #[
        #{ value: "unknown", description: "Classification has not been determined yet." },
        #{
          value: "simple",
          description: "Pipeline is in the same project, uses only self repo, no cross-repo templates.",
        },
        #{
          value: "sameRepoTemplates",
          description: "Pipeline uses extends/template from the same repo (resolves via self).",
        },
        #{
          value: "crossRepoTemplates",
          description: "Pipeline references templates from another repo via resources.repositories.",
        },
        #{
          value: "multiRepoCheckout",
          description: "Pipeline checks out multiple repos including the migrated one.",
        },
        #{
          value: "separatePipelineRepo",
          description: "Pipeline YAML lives in a different repo; the migrated repo is referenced in resources.",
        },
        #{
          value: "crossProject",
          description: "Pipeline is in a different AzDO project than the migrated repo.",
        }
      ],
    }
  )
  classification?:
    | "unknown"
    | "simple"
    | "sameRepoTemplates"
    | "crossRepoTemplates"
    | "multiRepoCheckout"
    | "separatePipelineRepo"
    | "crossProject";

  /** The build definition ID of the clone pipeline, if one has been created. */
  cloneDefinitionId?: int32;

  /** The YAML filename of the clone on the elm/migrations branch (for complex cases only). */
  cloneYamlFile?: string;

  /** The build definition ID of the pipeline. */
  definitionId?: int32;

  /** Error message if the pipeline rewiring failed. */
  errorMessage?: string;

  /** Classification findings that describe why this pipeline is complex. Empty for Simple pipelines. */
  findings?: PipelineClassificationFinding[];

  /** The name of the pipeline definition. */
  name?: string;

  /** The folder path of the pipeline definition. */
  path?: string;

  /** The project ID containing this pipeline. */
  @format("uuid") projectId?: string;

  /** The project name containing this pipeline. */
  projectName?: string;

  /** List of repositories referenced by this pipeline that need mappings. Populated when Status is 'needsMappings'. */
  requiredMappings?: RepositoryReference[];

  /** The current rewiring status. */
  @extension(
    "x-ms-enum",
    #{
      name: "PipelineRewireStatus",
      values: #[
        #{
          value: "pending",
          description: "Pipeline has been submitted but classification has not started.",
        },
        #{ value: "classifying", description: "Pipeline is being classified." },
        #{ value: "preCheckPassed", description: "Pre-checks passed. Ready for rewiring." },
        #{ value: "preCheckFailed", description: "Pre-checks failed." },
        #{
          value: "needsMappings",
          description: "Pipeline has cross-repo references that require repository mappings from the user.",
        },
        #{
          value: "cloneCreated",
          description: "A clone definition has been created for testing.",
        },
        #{
          value: "rewired",
          description: "Rewiring is complete — clone created and ready or original swapped at cutover.",
        },
        #{
          value: "swapComplete",
          description: "The original pipeline has been swapped to point at GitHub. Cutover complete.",
        },
        #{ value: "failed", description: "Rewiring failed." },
        #{
          value: "awaitingCodeSync",
          description: "Clone YAML has been written to the AzDO source repo's <c>elm/migrations</c> branch and is waiting for ELM code sync to mirror it to GitHub before the clone BuildDefinition can be created. Each sync cycle re-checks GitHub for the snapshotted commit; once visible the entry advances to CloneCreated.",
        }
      ],
    }
  )
  status?:
    | "pending"
    | "classifying"
    | "preCheckPassed"
    | "preCheckFailed"
    | "needsMappings"
    | "cloneCreated"
    | "rewired"
    | "swapComplete"
    | "failed"
    | "awaitingCodeSync";

  /** The YAML filename used by the pipeline definition. */
  yamlFilename?: string;
}

/** Response containing the pipeline rewiring configuration and status for a migration. */
model PipelineRewireResponse {
  /** The list of pipelines and their rewiring status. */
  pipelines?: PipelineRewireEntry[];

  /** The GitHub Enterprise service connection ID used for pipeline clones. */
  @format("uuid") serviceConnectionId?: string;
}

/** The full policy configuration with settings. */
model PolicyConfiguration {
  ...VersionedPolicyConfigurationRef;
  _links?: ReferenceLinks;
  createdBy?: IdentityRef;

  /** The date and time when the policy was created. */
  createdDate?: utcDateTime;

  /** Indicates whether the policy is blocking. */
  isBlocking?: boolean;

  /** Indicates whether the policy has been (soft) deleted. */
  isDeleted?: boolean;

  /** Indicates whether the policy is enabled. */
  isEnabled?: boolean;

  /** If set, this policy requires 'Manage Enterprise Policies' permission to create, edit, or delete. */
  isEnterpriseManaged?: boolean;

  /** The policy configuration settings. */
  @format("JObject") settings?: string;
}

/** Policy configuration reference. */
model PolicyConfigurationRef {
  /** The policy configuration ID. */
  id?: int32;

  type?: PolicyTypeRef;

  /** The URL where the policy configuration can be retrieved. */
  url?: string;
}

/** Real time event (SignalR) for a policy evaluation update on a pull request */
model PolicyEvaluationUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Policy type reference. */
model PolicyTypeRef {
  /** Display name of the policy type. */
  displayName?: string;

  /** The policy type ID. */
  @format("uuid") id?: string;

  /** The URL where the policy type can be retrieved. */
  url?: string;
}

/** The class represents a property bag as a collection of key-value pairs. Values of all primitive types (any type with a `TypeCode != TypeCode.Object`) except for `DBNull` are accepted. Values of type Byte[], Int32, Double, DateType and String preserve their type, other primitives are retuned as a String. Byte[] expected as base64 encoded string. */
model PropertiesCollection {
  /** The count of properties in the collection. */
  count?: int32;

  item?: {};

  /** The set of keys in the collection. */
  keys?: string[];

  /** The set of values in the collection. */
  values?: string[];
}

/** Real time event (SignalR) for pull request creation */
model PullRequestCreatedEvent {
  ...RealTimePullRequestEvent;
}

/** Initial config contract sent to extensions creating tabs on the pull request page */
model PullRequestTabExtensionConfig {
  pullRequestId?: int32;
  repositoryId?: string;
}

/** Base contract for a real time pull request event (SignalR) */
model RealTimePullRequestEvent {
  /** The id of this event. Can be used to track send/receive state between client and server. */
  @format("uuid") eventId?: string;

  /** The id of the pull request this event was generated for. */
  pullRequestId?: int32;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** Maps an AzDO repository to its GitHub counterpart for cross-repo pipeline rewiring. Used when a pipeline references templates or resources from another AzDO repo that has been (or will be) migrated to GitHub. */
model RepositoryMapping {
  /** The AzDO repository GUID of the source repository. */
  @format("uuid") sourceRepositoryId?: string;

  /** The GitHub target repository in 'owner/repo' format. */
  targetRepository?: string;
}

/** Describes a repository referenced by a pipeline that may need a mapping for cross-repo rewiring. Surfaced in RequiredMappings when the pipeline status is NeedsMappings. */
model RepositoryReference {
  /** The AzDO repository GUID, if resolvable. */
  @format("uuid") repositoryId?: string;

  /** The repository name as referenced in the YAML (e.g. 'MyProject/TemplatesRepo'). */
  repositoryName?: string;

  /** The repository type as declared in the YAML (e.g. 'git', 'github'). */
  repositoryType?: string;
}

model ResourceRef {
  id?: string;
  url?: string;
}

/** Real time event (SignalR) for when the target branch of a pull request is changed */
model RetargetEvent {
  ...RealTimePullRequestEvent;
}

/** Real time event (SignalR) for an update to reviewers on a pull request */
model ReviewersUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Real time event (SignalR) for reviewer votes being reset on a pull request */
model ReviewersVotesResetEvent {
  ...RealTimePullRequestEvent;
}

/** Real time event (SignalR) for a reviewer vote update on a pull request */
model ReviewerVoteUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Context used while sharing a pull request. */
model ShareNotificationContext {
  /** Optional user note or message. */
  message?: string;

  /** Identities of users who will receive a share notification. */
  receivers?: IdentityRef[];
}

model SourceToTargetRef {
  /** The source ref to copy. For example, refs/heads/master. */
  sourceRef?: string;

  /** The target ref to update. For example, refs/heads/master. */
  targetRef?: string;
}

/** Real time event (SignalR) for an added status on a pull request */
model StatusAddedEvent {
  ...RealTimePullRequestEvent;
}

/** Real time event (SignalR) for deleted statuses on a pull request */
model StatusesDeletedEvent {
  ...RealTimePullRequestEvent;
}

/** Real time event (SignalR) for a status update on a pull request */
model StatusUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Request to submit pipelines for rewiring as part of an Enterprise Live Migration. */
model SubmitPipelinesRequest {
  /** The build definition IDs of the pipelines to rewire. */
  pipelineIds?: int32[];

  /** Optional mappings for cross-repo references. When a pipeline's YAML references another AzDO repository (via resources.repositories), this mapping tells us which GitHub repository it corresponds to. Not required for simple pipelines. */
  repositoryMappings?: RepositoryMapping[];

  /** The ID of the GitHub service connection to use for the rewired pipelines. This must be a project-scoped service connection with access to the target GitHub org. This is separate from the migration-level ServiceEndpointId. */
  @format("uuid") serviceConnectionId?: string;
}

/** Represents a Supported IDE entity. */
model SupportedIde {
  /** The download URL for the IDE. */
  downloadUrl?: string;

  /** The type of the IDE. */
  @extension(
    "x-ms-enum",
    #{
      name: "SupportedIdeType",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "androidStudio", description: "" },
        #{ value: "appCode", description: "" },
        #{ value: "cLion", description: "" },
        #{ value: "dataGrip", description: "" },
        #{ value: "eclipse", description: "" },
        #{ value: "intelliJ", description: "" },
        #{ value: "mps", description: "" },
        #{ value: "phpStorm", description: "" },
        #{ value: "pyCharm", description: "" },
        #{ value: "rubyMine", description: "" },
        #{ value: "tower", description: "" },
        #{ value: "visualStudio", description: "" },
        #{ value: "vsCode", description: "" },
        #{ value: "webStorm", description: "" }
      ],
    }
  )
  ideType?:
    | "unknown"
    | "androidStudio"
    | "appCode"
    | "cLion"
    | "dataGrip"
    | "eclipse"
    | "intelliJ"
    | "mps"
    | "phpStorm"
    | "pyCharm"
    | "rubyMine"
    | "tower"
    | "visualStudio"
    | "vsCode"
    | "webStorm";

  /** The name of the IDE. */
  name?: string;

  /** The URL to open the protocol handler for the IDE. */
  protocolHandlerUrl?: string;

  /** A list of SupportedPlatforms. */
  supportedPlatforms?: string[];
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

model TfvcCheckinEventData {
  changeset?: TfvcChangeset;
  project?: TeamProjectReference;
}

model TfvcHistoryEntry {
  ...HistoryEntry;

  /** The encoding of the item at this point in history (only relevant for File history, not folders) */
  encoding?: int32;

  /** The file id of the item at this point in history (only relevant for File history, not folders) */
  fileId?: int32;
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

/** Metadata for an item including the previous hash value for files. */
model TfvcItemPreviousHash {
  ...TfvcItem;

  /** MD5 hash as a base 64 string, applies to files only. */
  previousHashValue?: string;
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

/** Real time event (SignalR) for a title/description update on a pull request */
model TitleDescriptionUpdatedEvent {
  ...RealTimePullRequestEvent;
}

/** Request to update an Enterprise Live Migration. */
model UpdateMigrationRequest {
  /** The number of failed and blocked resources the user has reviewed and accepted. Required when approving cutover for a migration in the ReviewForCutover stage. Must match the current total failure count; rejected if the count has changed. Set to int.MaxValue to accept all failures (requires AllowBlanketCutoverApproval feature flag). */
  cutoverFailureAcceptedCount?: int32;

  /** Set to true to acknowledge that all rewired pipelines have been verified. Required for cutover when RequiresPipelineVerificationAcknowledgment is true. Independent of CutoverFailureAcceptedCount. */
  pipelinesVerified?: boolean;

  /** The UTC date/time representing when the cutover is to occur. */
  scheduledCutoverDate?: utcDateTime;

  /** The status requested for the migration. Allowed values are 'Active' and 'Paused'. */
  @extension(
    "x-ms-enum",
    #{
      name: "MigrationStatus",
      values: #[
        #{ value: "active", description: "The migration is active." },
        #{ value: "completed", description: "The migration has completed successfully." },
        #{
          value: "failed",
          description: "The migration has completed with a failure. The error details can be found in the Migration.Error property.",
        },
        #{ value: "paused", description: "The migration was paused." }
      ],
    }
  )
  statusRequested?: "active" | "completed" | "failed" | "paused";

  /** True if the migration should only perform pre-migration validation. */
  validateOnly?: boolean;
}

/** Request to update the pipeline rewiring configuration for a migration. All fields are optional — only provided fields are applied. */
model UpdatePipelinesRequest {
  /** Pipeline definition IDs to acknowledge. Acknowledged pipelines (including complex or failed ones) do not block cutover. */
  acknowledgePipelineIds?: int32[];

  /** Pipeline definition IDs to add to the rewiring selection. */
  addPipelineIds?: int32[];

  /** Pipeline definition IDs to remove from the rewiring selection. If a clone exists for a removed pipeline, it will be deleted. */
  removePipelineIds?: int32[];

  /** Repository mappings to add or update. Merged by SourceRepositoryId — if a mapping for the same source repo already exists, it is replaced. */
  repositoryMappings?: RepositoryMapping[];

  /** Pipeline definition IDs to retry. Matching entries in Failed status are reset so the next sync cycle retries them. One-shot: the reset happens immediately and the IDs are not persisted. */
  retryFailedPipelineIds?: int32[];

  /** Updated GitHub service connection ID. */
  @format("uuid") serviceConnectionId?: string;
}

model UpdateRefsRequest {
  refUpdateRequests?: GitRefUpdate[];
  @extension(
    "x-ms-enum",
    #{
      name: "GitRefUpdateMode",
      values: #[
        #{
          value: "bestEffort",
          description: "Indicates the Git protocol model where any refs that can be updated will be updated, but any failures will not prevent other updates from succeeding.",
        },
        #{
          value: "allOrNone",
          description: "Indicates that all ref updates must succeed or none will succeed. All ref updates will be atomically written. If any failure is encountered, previously successful updates will be rolled back and the entire operation will fail.",
        }
      ],
    }
  )
  updateMode?: "bestEffort" | "allOrNone";
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

/** A particular revision for a policy configuration. */
model VersionedPolicyConfigurationRef {
  ...PolicyConfigurationRef;

  /** The policy configuration revision ID. */
  revision?: int32;
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

/** The representation of data needed to create a tag definition which is sent across the wire. */
model WebApiCreateTagRequestData {
  /** Name of the tag definition that will be created. */
  name?: string;
}

/** The representation of a tag definition which is sent across the wire. */
model WebApiTagDefinition {
  /** Whether or not the tag definition is active. */
  active?: boolean;

  /** ID of the tag definition. */
  @format("uuid") id?: string;

  /** The name of the tag definition. */
  name?: string;

  /** Resource URL for the Tag Definition. */
  url?: string;
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
  }
}

interface Repositories {
  /** Retrieve deleted git repositories. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "deletedRepositories")
  @extension("x-ms-vss-method", "GetDeletedRepositories")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/deletedrepositories")
  @get
  GetDeletedRepositories(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitDeletedRepository[]>;

  /** Retrieve soft-deleted git repositories from the recycle bin. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinRepositories")
  @extension("x-ms-vss-method", "GetRecycleBinRepositories")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/recycleBin/repositories")
  @get
  GetRecycleBinRepositories(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitDeletedRepository[]>;

  /** Destroy (hard delete) a soft-deleted Git repository. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinRepositories")
  @extension("x-ms-vss-method", "DeleteRepositoryFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/recycleBin/repositories/{repositoryId}")
  @delete
  DeleteRepositoryFromRecycleBin(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID of the repository. */
    @format("uuid") @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Recover a soft-deleted Git repository. Recently deleted repositories go into a soft-delete state for a period of time before they are hard deleted and become unrecoverable. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "recycleBinRepositories")
  @extension("x-ms-vss-method", "RestoreRepositoryFromRecycleBin")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/recycleBin/repositories/{repositoryId}")
  @patch
  RestoreRepositoryFromRecycleBin(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID of the repository. */
    @format("uuid") @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: GitRecycleBinRepositoryDetails,
  ): GitRepository;

  /** Retrieve git repositories. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "repositories")
  @extension("x-ms-vss-method", "GetRepositories")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** [optional] True to include reference links. The default value is false. */
    @query(#{ explode: true }) includeLinks?: boolean,

    /** [optional] True to include all remote URLs. The default value is false. */
    @query(#{ explode: true }) includeAllUrls?: boolean,

    /** [optional] True to include hidden repositories. The default value is false. */
    @query(#{ explode: true }) includeHidden?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitRepository[]>;

  /** Create a git repository in a team project. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "repositories")
  @extension("x-ms-vss-method", "CreateRepository")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** [optional] Specify the source refs to use while creating a fork repo */
    @query(#{ explode: true }) sourceRef?: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Specify the repo name, team project and/or parent repository. Team project information can be omitted from gitRepositoryToCreate if the request is project-scoped (i.e., includes project Id). */
    @body body: GitRepositoryCreateOptions,
  ): CreatedResponse & GitRepository;

  /** Delete a git repository */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "repositories")
  @extension("x-ms-vss-method", "DeleteRepository")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the repository. */
    @format("uuid") @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Retrieve a git repository. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "repositories")
  @extension("x-ms-vss-method", "GetRepository")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}")
  @get
  GetRepository(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitRepository;

  /** Updates the Git repository with either a new repo name or a new default branch. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "repositories")
  @extension("x-ms-vss-method", "UpdateRepository")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the repository. */
    @format("uuid") @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Specify a new repo name or a new default branch of the repository */
    @body body: GitRepository,
  ): GitRepository;
}

interface RefsFavorites {
  /** Gets the refs favorites for a repo and an identity. */
  @tag("Refs Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "refsFavorites")
  @extension("x-ms-vss-method", "GetRefFavorites")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/favorites/refs")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The id of the repository. */
    @query(#{ explode: true }) repositoryId?: string,

    /** The id of the identity whose favorites are to be retrieved. If null, the requesting identity is used. */
    @query(#{ explode: true }) identityId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitRefFavorite[]>;

  /** Creates a ref favorite */
  @tag("Refs Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "refsFavorites")
  @extension("x-ms-vss-method", "CreateFavorite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/favorites/refs")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The ref favorite to create. */
    @body body: GitRefFavorite,
  ): GitRefFavorite;

  /** Deletes the refs favorite specified */
  @tag("Refs Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "refsFavorites")
  @extension("x-ms-vss-method", "DeleteRefFavorite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/favorites/refs/{favoriteId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The Id of the ref favorite to delete. */
    @path favoriteId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Gets the refs favorite for a favorite Id. */
  @tag("Refs Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "refsFavorites")
  @extension("x-ms-vss-method", "GetRefFavorite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/favorites/refs/{favoriteId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The Id of the requested ref favorite. */
    @path favoriteId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitRefFavorite;
}

interface RefsFavoritesForProject {
  @tag("Refs Favorites For Project")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "refsFavoritesForProject")
  @extension("x-ms-vss-method", "GetRefFavoritesForProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/favorites/refsForProject")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) identityId?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitRefFavorite[]>;
}

interface PolicyConfigurations {
  /** Retrieve a list of policy configurations by a given set of scope/filtering criteria. Azure Repos uses two types of policies to protect your code: **Repository policies (push policies)** check every push to your repository. They validate things like file size limits, path restrictions, or commit requirements. When someone pushes code that violates these rules, the push gets rejected - no matter which branch they're pushing to. **Branch policies (PR policies)** protect specific branches by requiring pull requests. When you set a branch policy on `main`, for example, nobody can push directly to `main` anymore. They must create a pull request instead, which can then require reviews, builds, or other checks to pass first. ## How Policies Work with Your Project Structure Both types of policies can be defined at different levels in your project hierarchy. A policy defined at the project level affects all repositories in that project. A policy defined at the repository level affects just that repository. A branch policy can even be defined at the project level to protect all branches with the same name - like protecting all `main` branches across your entire project with one policy. ### Branch Patterns and Wildcards Branches in Git follow a folder-like structure. You might have branches like: - `refs/heads/main` - `refs/heads/releases/1.0.0` - `refs/heads/releases/2.0.0` - `refs/heads/features/new-login` You can create policies for specific branches or for groups of branches using wildcards. When you create a policy for `refs/heads/releases/*`, it protects all branches in the `releases` 'folder' - both the ones that exist now and any new release branches you create later. This pattern matching works recursively, so `refs/heads/releases/*` also covers branches like `refs/heads/releases/v1/hotfix`. This helps you set up consistent protection without creating the same policy over and over. For example, you can require two reviewers for all release branches with just one policy. ## Understanding Policy Inheritance When you query for policies, this endpoint shows you what policies are actually enforcing rules at your specified scope. This includes policies inherited from higher levels. For example, if you query for policies on a specific branch, you get: - Branch policies for that exact branch - Branch policies with wildcards that match your branch - Repository policies for that repo - Any applicable project-level policies Everything that protects that branch shows up in your results. ## How to Query for Policies The `repositoryId` and `refName` parameters let you focus on specific parts of your project. Here's what you get with different combinations: **Both `repositoryId` and `refName` specified:** - When `refName` is a specific branch name: You see all policies affecting that specific branch. This includes exact branch policies, wildcard branch policies that match, repository policies for that repo, and any project-level policies. - When `refName` is `~all`: You see every policy that affects any branch in that repository. This special value gives you the same results as if you called this API once for every single branch in the repo and then combined all the results (removing duplicates). You get all branch-specific policies, all wildcard policies, all repository policies, and all inherited project-level policies that apply to this repository. This helps you see the complete picture of what protects all your branches without making multiple API calls. **Only `repositoryId` specified:** You see policies that apply to the repository as a whole - repository policies and inherited project-level repository policies. Branch policies aren't included because they don't affect the whole repository. **Neither parameter specified:** You see only project-level repository policies. Branch policies defined at the project level aren't included, even though they exist at the project level. This happens because branch policies need a branch context to be meaningful - without specifying a repository or branch name, the API only returns policies that apply to repositories as a whole. **Only `refName` specified:** You see project-level branch policies for branches with that name (like all `main` branch policies defined at project level), plus project-level repository policies. You can add the `policyType` parameter to filter for a specific type of policy, such as 'Minimum number of reviewers' or 'File size restriction'. This parameter accepts the policy type ID and filters the results to show only that specific policy type. ## Common Scenarios - **'What protects my main branch?'** - Use `repositoryId` + `refName=refs/heads/main` - **'What protects all my release branches?'** - Use `repositoryId` + `refName=refs/heads/releases/*` - **'Show me every policy that affects any branch in this repository'** - Use `repositoryId` + `refName=~all` - **'What repository policies apply to this repo?'** - Use `repositoryId` only - **'What file size limits apply to this repository?'** - Use `repositoryId` with the `policyType` for file size restrictions - **'What project-wide repository policies do we have?'** - Don't specify `repositoryId` or `refName` - **'Which policies apply to develop branches across all repositories?'** - Use `refName=refs/heads/develop` */
  @tag("Policy Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "policyConfigurations")
  @extension("x-ms-vss-method", "GetPolicyConfigurations")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/policy/configurations")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The unique identifier of a specific repository to query policies for - when provided, returns policies that apply to this repository including inherited project-level policies. */
    @format("uuid") @query(#{ explode: true }) repositoryId?: string,

    /** The branch reference to query policies for (e.g., 'refs/heads/main' for a specific branch or '~all' to get all policies affecting any branch in the repository) - determines which branch-specific policies are included in the results. */
    @query(#{ explode: true }) refName?: string,

    /** The type ID of a specific policy to filter by (e.g., 'Minimum number of reviewers' or 'File size restriction') - when specified, returns only policies of this particular type rather than all policy types. */
    @format("uuid") @query(#{ explode: true }) policyType?: string,

    /** The maximum number of policy configurations to return in a single response - useful for limiting result size when dealing with projects that have many policies. */
    @query(#{ explode: true }) $top?: int32,

    /** A token returned in the x-ms-continuationtoken response header from a previous request when not all results were returned - use this token to retrieve the next page of results in the dataset. */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;
    @body body: PolicyConfiguration[];
  };
}

interface PullRequests {
  /** Retrieve all pull requests matching a specified criteria. Please note that description field will be truncated up to 400 symbols in the result. */
  @tag("Pull Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequests")
  @extension("x-ms-vss-method", "GetPullRequestsByProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/pullrequests")
  @get
  GetPullRequestsByProject(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** If set, search for pull requests that were created by this identity. */
    @format("uuid") @query(#{ name: "searchCriteria.creatorId", explode: true }) searchCriteriaCreatorId?: string,

    /** Whether to include the _links field on the shallow references */
    @query(#{ name: "searchCriteria.includeLinks", explode: true }) searchCriteriaIncludeLinks?: boolean,

    /** If set, filters pull requests that have labels matching the specified label names. */
    @query(#{ name: "searchCriteria.labels" }) searchCriteriaLabels?: string[],

    /** If specified, filters pull requests that created/closed before this date based on the queryTimeRangeType specified. */
    @query(#{ name: "searchCriteria.maxTime", explode: true }) searchCriteriaMaxTime?: utcDateTime,

    /** If specified, filters pull requests that created/closed after this date based on the queryTimeRangeType specified. */
    @query(#{ name: "searchCriteria.minTime", explode: true }) searchCriteriaMinTime?: utcDateTime,

    /** The type of time range which should be used for minTime and maxTime. Defaults to Created if unset. */
    @extension(
      "x-ms-enum",
      #{
        name: "PullRequestTimeRangeType",
        values: #[
          #{ value: "created", description: "The date when the pull request was created." },
          #{
            value: "closed",
            description: "The date when the pull request was closed (completed, abandoned, or merged externally).",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `searchCriteria.queryTimeRangeType`?: "created" | "closed",

    /** If set, search for pull requests whose target branch is in this repository. */
    @format("uuid") @query(#{ name: "searchCriteria.repositoryId", explode: true }) searchCriteriaRepositoryId?: string,

    /** If set, search for pull requests that have this identity as a reviewer. */
    @format("uuid") @query(#{ name: "searchCriteria.reviewerId", explode: true }) searchCriteriaReviewerId?: string,

    /** If set, search for pull requests from this branch. */
    @query(#{ name: "searchCriteria.sourceRefName", explode: true }) searchCriteriaSourceRefName?: string,

    /** If set, search for pull requests whose source branch is in this repository. */
    @format("uuid") @query(#{ name: "searchCriteria.sourceRepositoryId", explode: true }) searchCriteriaSourceRepositoryId?: string,

    /** If set, search for pull requests that are in this state. Defaults to Active if unset. */
    @extension(
      "x-ms-enum",
      #{
        name: "PullRequestStatus",
        values: #[
          #{ value: "notSet", description: "Status not set. Default state." },
          #{ value: "active", description: "Pull request is active." },
          #{ value: "abandoned", description: "Pull request is abandoned." },
          #{ value: "completed", description: "Pull request is completed." },
          #{
            value: "all",
            description: "Used in pull request search criteria to include all statuses.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `searchCriteria.status`?: "notSet" | "active" | "abandoned" | "completed" | "all",

    /** The operator used for filtering by labels. Defaults to And if unset. When And is used, pull requests must have all specified labels. When Or is used, pull requests must have at least one of the specified labels. */
    @extension(
      "x-ms-enum",
      #{
        name: "TagsFilterOperator",
        values: #[
          #{ value: "and", description: "Pull request must have ALL specified tags." },
          #{ value: "or", description: "Pull request must have AT LEAST ONE of the specified tags." }
        ],
      }
    )
    @query(#{ explode: true })
    `searchCriteria.tagsFilterOperator`?: "and" | "or",

    /** If set, search for pull requests into this branch. */
    @query(#{ name: "searchCriteria.targetRefName", explode: true }) searchCriteriaTargetRefName?: string,

    /** If set, filters pull requests that contain the specified text in the title. */
    @query(#{ name: "searchCriteria.title", explode: true }) searchCriteriaTitle?: string,

    /** Not used. */
    @query(#{ explode: true }) maxCommentLength?: int32,

    /** The number of pull requests to ignore. For example, to retrieve results 101-150, set top to 50 and skip to 100. */
    @query(#{ explode: true }) $skip?: int32,

    /** The number of pull requests to retrieve. */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitPullRequest[]>;

  /** Retrieve a pull request. */
  @tag("Pull Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequests")
  @extension("x-ms-vss-method", "GetPullRequestById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/pullrequests/{pullRequestId}")
  @get
  GetPullRequestById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the pull request to retrieve. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitPullRequest;

  /** Retrieve all pull requests matching a specified criteria. Please note that description field will be truncated up to 400 symbols in the result. */
  @tag("Pull Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequests")
  @extension("x-ms-vss-method", "GetPullRequests")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests")
  @get
  GetPullRequests(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If set, search for pull requests that were created by this identity. */
    @format("uuid") @query(#{ name: "searchCriteria.creatorId", explode: true }) searchCriteriaCreatorId?: string,

    /** Whether to include the _links field on the shallow references */
    @query(#{ name: "searchCriteria.includeLinks", explode: true }) searchCriteriaIncludeLinks?: boolean,

    /** If set, filters pull requests that have labels matching the specified label names. */
    @query(#{ name: "searchCriteria.labels" }) searchCriteriaLabels?: string[],

    /** If specified, filters pull requests that created/closed before this date based on the queryTimeRangeType specified. */
    @query(#{ name: "searchCriteria.maxTime", explode: true }) searchCriteriaMaxTime?: utcDateTime,

    /** If specified, filters pull requests that created/closed after this date based on the queryTimeRangeType specified. */
    @query(#{ name: "searchCriteria.minTime", explode: true }) searchCriteriaMinTime?: utcDateTime,

    /** The type of time range which should be used for minTime and maxTime. Defaults to Created if unset. */
    @extension(
      "x-ms-enum",
      #{
        name: "PullRequestTimeRangeType",
        values: #[
          #{ value: "created", description: "The date when the pull request was created." },
          #{
            value: "closed",
            description: "The date when the pull request was closed (completed, abandoned, or merged externally).",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `searchCriteria.queryTimeRangeType`?: "created" | "closed",

    /** If set, search for pull requests whose target branch is in this repository. */
    @format("uuid") @query(#{ name: "searchCriteria.repositoryId", explode: true }) searchCriteriaRepositoryId?: string,

    /** If set, search for pull requests that have this identity as a reviewer. */
    @format("uuid") @query(#{ name: "searchCriteria.reviewerId", explode: true }) searchCriteriaReviewerId?: string,

    /** If set, search for pull requests from this branch. */
    @query(#{ name: "searchCriteria.sourceRefName", explode: true }) searchCriteriaSourceRefName?: string,

    /** If set, search for pull requests whose source branch is in this repository. */
    @format("uuid") @query(#{ name: "searchCriteria.sourceRepositoryId", explode: true }) searchCriteriaSourceRepositoryId?: string,

    /** If set, search for pull requests that are in this state. Defaults to Active if unset. */
    @extension(
      "x-ms-enum",
      #{
        name: "PullRequestStatus",
        values: #[
          #{ value: "notSet", description: "Status not set. Default state." },
          #{ value: "active", description: "Pull request is active." },
          #{ value: "abandoned", description: "Pull request is abandoned." },
          #{ value: "completed", description: "Pull request is completed." },
          #{
            value: "all",
            description: "Used in pull request search criteria to include all statuses.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `searchCriteria.status`?: "notSet" | "active" | "abandoned" | "completed" | "all",

    /** The operator used for filtering by labels. Defaults to And if unset. When And is used, pull requests must have all specified labels. When Or is used, pull requests must have at least one of the specified labels. */
    @extension(
      "x-ms-enum",
      #{
        name: "TagsFilterOperator",
        values: #[
          #{ value: "and", description: "Pull request must have ALL specified tags." },
          #{ value: "or", description: "Pull request must have AT LEAST ONE of the specified tags." }
        ],
      }
    )
    @query(#{ explode: true })
    `searchCriteria.tagsFilterOperator`?: "and" | "or",

    /** If set, search for pull requests into this branch. */
    @query(#{ name: "searchCriteria.targetRefName", explode: true }) searchCriteriaTargetRefName?: string,

    /** If set, filters pull requests that contain the specified text in the title. */
    @query(#{ name: "searchCriteria.title", explode: true }) searchCriteriaTitle?: string,

    /** Not used. */
    @query(#{ explode: true }) maxCommentLength?: int32,

    /** The number of pull requests to ignore. For example, to retrieve results 101-150, set top to 50 and skip to 100. */
    @query(#{ explode: true }) $skip?: int32,

    /** The number of pull requests to retrieve. */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitPullRequest[]>;

  /** Create a pull request. */
  @tag("Pull Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequests")
  @extension("x-ms-vss-method", "CreatePullRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If true, subsequent pushes to the pull request will be individually reviewable. Set this to false for large pull requests for performance reasons if this functionality is not needed. */
    @query(#{ explode: true }) supportsIterations?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** The pull request to create. */
    @body body: GitPullRequest,
  ): GitPullRequest;

  /** Retrieve a pull request. */
  @tag("Pull Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequests")
  @extension("x-ms-vss-method", "GetPullRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests/{pullRequestId}")
  @get
  GetPullRequest(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** The ID of the pull request to retrieve. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Not used. */
    @query(#{ explode: true }) maxCommentLength?: int32,

    /** Not used. */
    @query(#{ explode: true }) $skip?: int32,

    /** Not used. */
    @query(#{ explode: true }) $top?: int32,

    /** If true, the pull request will be returned with the associated commits. */
    @query(#{ explode: true }) includeCommits?: boolean,

    /** If true, the pull request will be returned with the associated work item references. */
    @query(#{ explode: true }) includeWorkItemRefs?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitPullRequest;

  /** Update a pull request These are the properties that can be updated with the API: - Status - Title - Description (up to 4000 characters) - CompletionOptions - MergeOptions - AutoCompleteSetBy.Id - TargetRefName (when the PR retargeting feature is enabled) Attempting to update other properties outside of this list will either cause the server to throw an `InvalidArgumentValueException`, or to silently ignore the update. */
  @tag("Pull Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequests")
  @extension("x-ms-vss-method", "UpdatePullRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests/{pullRequestId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request to update. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** The pull request content that should be updated. */
    @body body: GitPullRequest,
  ): GitPullRequest;
}

interface AnnotatedTags {
  /** Create an annotated tag. Repositories have both a name and an identifier. Identifiers are globally unique, but several projects may contain a repository of the same name. You don't need to include the project if you specify a repository by ID. However, if you specify a repository by name, you must also specify the project (by name or ID). */
  @tag("Annotated Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "annotatedTags")
  @extension("x-ms-vss-method", "CreateAnnotatedTag")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/annotatedtags")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Object containing details of tag to be created. */
    @body body: GitAnnotatedTag,
  ): GitAnnotatedTag;

  /** Get an annotated tag. Repositories have both a name and an identifier. Identifiers are globally unique, but several projects may contain a repository of the same name. You don't need to include the project if you specify a repository by ID. However, if you specify a repository by name, you must also specify the project (by name or ID). */
  @tag("Annotated Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "annotatedTags")
  @extension("x-ms-vss-method", "GetAnnotatedTag")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/annotatedtags/{objectId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    /** ObjectId (Sha1Id) of tag to get. */
    @path objectId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitAnnotatedTag;
}

interface Blobs {
  /** Gets one or more blobs in a zip file download. */
  @tag("Blobs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "blobs")
  @extension("x-ms-vss-method", "GetBlobs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/blobs")
  @post
  GetBlobsZip(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    @query(#{ explode: true }) filename?: string,
    ...Parameters.`api-Version-preview`.`1`,

    /** Blob IDs (SHA1 hashes) to be returned in the zip file. */
    @body body: string[],
  ): {
    @header contentType: "application/zip";
    @body @format("Stream") body: string;
  };

  /** Get a single blob. Repositories have both a name and an identifier. Identifiers are globally unique, but several projects may contain a repository of the same name. You don't need to include the project if you specify a repository by ID. However, if you specify a repository by name, you must also specify the project (by name or ID). */
  @tag("Blobs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "blobs")
  @extension("x-ms-vss-method", "GetBlob")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/blobs/{sha1}")
  @get
  GetBlob(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** SHA1 hash of the file. You can get the SHA1 of a file using the 'Git/Items/Get Item' endpoint. */
    @path sha1: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If true, prompt for a download rather than rendering in a browser. Note: this value defaults to true if $format is zip */
    @query(#{ explode: true }) download?: boolean,

    /** Provide a fileName to use for a download. */
    @query(#{ explode: true }) fileName?: string,

    /** Options: json, zip, text, octetstream. If not set, defaults to the MIME type set in the Accept header. */
    @query(#{ explode: true }) $format?: string,

    /** If true, try to resolve a blob to its LFS contents, if it's an LFS pointer file. Only compatible with octet-stream Accept headers or $format types */
    @query(#{ explode: true }) resolveLfs?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header contentType: "application/zip";
        @body body: GitBlobRef;
      }
    | {
        @header contentType: "application/octet-stream";
        @body body: GitBlobRef;
      }
    | GitBlobRef;
}

interface CherryPicks {
  /** Retrieve information about a cherry pick operation for a specific branch. This operation is expensive due to the underlying object structure, so this API only looks at the 1000 most recent cherry pick operations. */
  @tag("Cherry Picks")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "cherryPicks")
  @extension("x-ms-vss-method", "GetCherryPickForRefName")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/cherryPicks")
  @get
  GetCherryPickForRefName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the repository. */
    @path repositoryId: string,

    /** The GitAsyncRefOperationParameters generatedRefName used for the cherry pick operation. */
    @query(#{ explode: true }) refName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitCherryPick;

  /** Cherry pick a specific commit or commits that are associated to a pull request into a new branch. */
  @tag("Cherry Picks")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "cherryPicks")
  @extension("x-ms-vss-method", "CreateCherryPick")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/cherryPicks")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the repository. */
    @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: GitAsyncRefOperationParameters,
  ): GitCherryPick;

  /** Retrieve information about a cherry pick operation by cherry pick Id. */
  @tag("Cherry Picks")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "cherryPicks")
  @extension("x-ms-vss-method", "GetCherryPick")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/cherryPicks/{cherryPickId}")
  @get
  GetCherryPick(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the cherry pick. */
    @path cherryPickId: int32,

    /** ID of the repository. */
    @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitCherryPick;
}

interface Commits {
  /** Retrieve a list of commits associated with a particular push. */
  @tag("Commits")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "commits")
  @extension("x-ms-vss-method", "GetPushCommits")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/commits")
  @get
  GetPushCommits(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The id or friendly name of the repository. To use the friendly name, projectId must also be specified. */
    @path repositoryId: string,

    /** The id of the push. */
    @query(#{ explode: true }) pushId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The maximum number of commits to return ('get the top x commits'). */
    @query(#{ explode: true }) top?: int32,

    /** The number of commits to skip. */
    @query(#{ explode: true }) skip?: int32,

    /** Set to false to avoid including REST Url links for resources. Defaults to true. */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitCommitRef[]>;

  /** Retrieve a particular commit. */
  @tag("Commits")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "commits")
  @extension("x-ms-vss-method", "GetCommit")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/commits/{commitId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The id of the commit. */
    @path commitId: string,

    /** The id or friendly name of the repository. To use the friendly name, projectId must also be specified. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The number of changes to include in the result. */
    @query(#{ explode: true }) changeCount?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitCommit;

  /** Retrieve changes for a particular commit. */
  @tag("Commits")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "changes")
  @extension("x-ms-vss-method", "GetChanges")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/commits/{commitId}/changes")
  @get
  GetChanges(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The id of the commit. */
    @path commitId: string,

    /** The id or friendly name of the repository. To use the friendly name, projectId must also be specified. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The maximum number of changes to return. */
    @query(#{ explode: true }) top?: int32,

    /** The number of changes to skip. */
    @query(#{ explode: true }) skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitCommitChanges;

  /** Retrieve git commits for a project matching the search criteria */
  @tag("Commits")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "commitsBatch")
  @extension("x-ms-vss-method", "GetCommitsBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/commitsbatch")
  @post
  GetCommitsBatch(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Number of commits to skip. The value cannot exceed 3,000,000. */
    @query(#{ explode: true }) $skip?: int32,

    /** Maximum number of commits to return. The value cannot exceed 50,000. */
    @query(#{ explode: true }) $top?: int32,

    /** True to include additional commit status information. */
    @query(#{ explode: true }) includeStatuses?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** Search options */
    @body body: GitQueryCommitsCriteria,
  ): Body<GitCommitRef[]>;
}

interface Statuses {
  /** Get statuses associated with the Git commit. */
  @tag("Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "statuses")
  @extension("x-ms-vss-method", "GetStatuses")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/commits/{commitId}/statuses")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the Git commit. */
    @path commitId: string,

    /** ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Optional. The number of statuses to retrieve. Default is 1000. */
    @query(#{ explode: true }) top?: int32,

    /** Optional. The number of statuses to ignore. Default is 0. For example, to retrieve results 101-150, set top to 50 and skip to 100. */
    @query(#{ explode: true }) skip?: int32,

    /** The flag indicates whether to get only latest statuses grouped by `Context.Name` and `Context.Genre`. */
    @query(#{ explode: true }) latestOnly?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitStatus[]>;

  /** Create Git commit status. */
  @tag("Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "statuses")
  @extension("x-ms-vss-method", "CreateCommitStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/commits/{commitId}/statuses")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the Git commit. */
    @path commitId: string,

    /** ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Git commit status object to create. */
    @body body: GitStatus,
  ): GitStatus;
}

interface Diffs {
  /** Find the closest common commit (the merge base) between base and target commits, and get the diff between either the base and target commits or common and target commits. */
  @tag("Diffs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "commitDiffs")
  @extension("x-ms-vss-method", "GetCommitDiffs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/diffs/commits")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If true, diff between common and target commits. If false, diff between base and target commits. */
    @query(#{ explode: true }) diffCommonCommit?: boolean,

    /** Maximum number of changes to return. Defaults to 100. */
    @query(#{ explode: true }) $top?: int32,

    /** Number of changes to skip */
    @query(#{ explode: true }) $skip?: int32,

    /** Version string identifier (name of tag/branch, SHA1 of commit) */
    @query(#{ explode: true }) baseVersion?: string,

    /** Version options - Specify additional modifiers to version (e.g Previous) */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionOptions",
        values: #[
          #{ value: "none", description: "Not specified" },
          #{
            value: "previousChange",
            description: "Commit that changed item prior to the current version",
          },
          #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
        ],
      }
    )
    @query(#{ explode: true })
    baseVersionOptions?: "none" | "previousChange" | "firstParent",

    /** Version type (branch, tag, or commit). Determines how Id is interpreted */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionType",
        values: #[
          #{ value: "branch", description: "Interpret the version as a branch name" },
          #{ value: "tag", description: "Interpret the version as a tag name" },
          #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
        ],
      }
    )
    @query(#{ explode: true })
    baseVersionType?: "branch" | "tag" | "commit",

    /** Version string identifier (name of tag/branch, SHA1 of commit) */
    @query(#{ explode: true }) targetVersion?: string,

    /** Version options - Specify additional modifiers to version (e.g Previous) */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionOptions",
        values: #[
          #{ value: "none", description: "Not specified" },
          #{
            value: "previousChange",
            description: "Commit that changed item prior to the current version",
          },
          #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
        ],
      }
    )
    @query(#{ explode: true })
    targetVersionOptions?: "none" | "previousChange" | "firstParent",

    /** Version type (branch, tag, or commit). Determines how Id is interpreted */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionType",
        values: #[
          #{ value: "branch", description: "Interpret the version as a branch name" },
          #{ value: "tag", description: "Interpret the version as a tag name" },
          #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
        ],
      }
    )
    @query(#{ explode: true })
    targetVersionType?: "branch" | "tag" | "commit",

    ...Parameters.`api-Version-preview`.`1`,
  ): GitCommitDiffs;
}

interface ImportRequests {
  /** Retrieve import requests for a repository. */
  @tag("Import Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "importRequests")
  @extension("x-ms-vss-method", "QueryImportRequests")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/importRequests")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** True to include abandoned import requests in the results. */
    @query(#{ explode: true }) includeAbandoned?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitImportRequest[]>;

  /** Create an import request. */
  @tag("Import Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "importRequests")
  @extension("x-ms-vss-method", "CreateImportRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/importRequests")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The import request to create. */
    @body body: GitImportRequest,
  ): GitImportRequest;

  /** Retrieve a particular import request. */
  @tag("Import Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "importRequests")
  @extension("x-ms-vss-method", "GetImportRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/importRequests/{importRequestId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** The unique identifier for the import request. */
    @path importRequestId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitImportRequest;

  /** Retry or abandon a failed import request. There can only be one active import request associated with a repository. Marking a failed import request abandoned makes it inactive. */
  @tag("Import Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "importRequests")
  @extension("x-ms-vss-method", "UpdateImportRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/importRequests/{importRequestId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** The unique identifier for the import request to update. */
    @path importRequestId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** The updated version of the import request. Currently, the only change allowed is setting the Status to Queued or Abandoned. */
    @body body: GitImportRequest,
  ): GitImportRequest;
}

interface Items {
  /** Get Item Metadata and/or Content for a collection of items. The download parameter is to indicate whether the content should be available as a download or just sent as a stream in the response. Doesn't apply to zipped content which is always returned as a download. */
  @tag("Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "items")
  @extension("x-ms-vss-method", "GetItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/items")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The path scope. The default is null. */
    @query(#{ explode: true }) scopePath?: string,

    /** The recursion level of this request. The default is 'none', no recursion. */
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

    /** Set to true to include content metadata. Default is false. */
    @query(#{ explode: true }) includeContentMetadata?: boolean,

    /** Set to true to include the latest changes. Default is false. */
    @query(#{ explode: true }) latestProcessedChange?: boolean,

    /** Set to true to download the response as a file. Default is false. */
    @query(#{ explode: true }) download?: boolean,

    /** Set to true to include links to items. Default is false. */
    @query(#{ explode: true }) includeLinks?: boolean,

    /** If specified, this overrides the HTTP Accept request header to return either 'json' or 'zip'. If $format is specified, then api-version should also be specified as a query parameter. */
    @query(#{ explode: true }) $format?: string,

    /** Version string identifier (name of tag/branch, SHA1 of commit) */
    @query(#{ name: "versionDescriptor.version", explode: true }) versionDescriptorVersion?: string,

    /** Version options - Specify additional modifiers to version (e.g Previous) */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionOptions",
        values: #[
          #{ value: "none", description: "Not specified" },
          #{
            value: "previousChange",
            description: "Commit that changed item prior to the current version",
          },
          #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
        ],
      }
    )
    @query(#{ explode: true })
    `versionDescriptor.versionOptions`?: "none" | "previousChange" | "firstParent",

    /** Version type (branch, tag, or commit). Determines how Id is interpreted */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionType",
        values: #[
          #{ value: "branch", description: "Interpret the version as a branch name" },
          #{ value: "tag", description: "Interpret the version as a tag name" },
          #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
        ],
      }
    )
    @query(#{ explode: true })
    `versionDescriptor.versionType`?: "branch" | "tag" | "commit",

    /** Set to true to keep the file permissions for unix (and POSIX) systems like executables and symlinks */
    @query(#{ explode: true }) zipForUnix?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitItem[]>;

  /** Retrieves a batch of items in a repo / project for a given list of paths or a long path */
  @tag("Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "itemsBatch")
  @extension("x-ms-vss-method", "GetItemsBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/itemsbatch")
  @post
  GetItemsBatch(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Request data attributes: ItemDescriptors, IncludeContentMetadata, LatestProcessedChange, IncludeLinks. ItemDescriptors: Collection of items to fetch, including path, version, and recursion level. IncludeContentMetadata: Whether to include metadata for all items LatestProcessedChange: Whether to include shallow ref to commit that last changed each item. IncludeLinks: Whether to include the _links field on the shallow references. */
    @body body: GitItemRequestData,
  ): Body<unknown[][]>;
}

interface PullRequestQuery {
  /** This API is used to find what pull requests are related to a given commit. It can be used to either find the pull request that created a particular merge commit or it can be used to find all pull requests that have ever merged a particular commit. The input is a list of queries which each contain a list of commits. For each commit that you search against, you will get back a dictionary of commit -> pull requests. */
  @tag("Pull Request Query")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestQuery")
  @extension("x-ms-vss-method", "GetPullRequestQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequestquery")
  @post
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The list of queries to perform. */
    @body body: GitPullRequestQuery,
  ): GitPullRequestQuery;
}

interface PullRequestAttachments {
  /** Get a list of files attached to a given pull request. */
  @tag("Pull Request Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestAttachments")
  @extension("x-ms-vss-method", "GetAttachments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/attachments")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Attachment[]>;

  /** Delete a pull request attachment. */
  @tag("Pull Request Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestAttachments")
  @extension("x-ms-vss-method", "DeleteAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/attachments/{fileName}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name of the attachment to delete. */
    @path fileName: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get the file content of a pull request attachment. */
  @tag("Pull Request Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestAttachments")
  @extension("x-ms-vss-method", "GetAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/attachments/{fileName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name of the attachment. */
    @path fileName: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header contentType: "application/octet-stream";
        @body @format("Stream") body: string;
      }
    | {
        @header contentType: "application/zip";
        @body @format("Stream") body: string;
      };

  /** Attach a new file to a pull request. */
  @tag("Pull Request Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestAttachments")
  @extension("x-ms-vss-method", "CreateAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/attachments/{fileName}")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name of the file. */
    @path fileName: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/octet-stream",

    /** Stream to upload */
    @body body: string,
  ): (CreatedResponse & Attachment) | (AcceptedResponse & Attachment);
}

interface PullRequestCommits {
  /** Get the commits for the specified pull request. */
  @tag("Pull Request Commits")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestCommits")
  @extension("x-ms-vss-method", "GetPullRequestCommits")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/commits")
  @get
  GetPullRequestCommits(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Maximum number of commits to return. */
    @query(#{ explode: true }) $top?: int32,

    /** The continuation token used for pagination. */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: GitCommitRef[];
  };

  /** Get the commits for the specified iteration of a pull request. */
  @tag("Pull Request Commits")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestCommits")
  @extension("x-ms-vss-method", "GetPullRequestIterationCommits")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/commits")
  @get
  GetPullRequestIterationCommits(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the iteration from which to get the commits. */
    @path iterationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Maximum number of commits to return. The maximum number of commits that can be returned per batch is 500. */
    @query(#{ explode: true }) top?: int32,

    /** Number of commits to skip. */
    @query(#{ explode: true }) skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitCommitRef[]>;
}

interface PullRequestIterations {
  /** Get the list of iterations for the specified pull request. */
  @tag("Pull Request Iterations")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterations")
  @extension("x-ms-vss-method", "GetPullRequestIterations")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If true, include the commits associated with each iteration in the response. */
    @query(#{ explode: true }) includeCommits?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitPullRequestIteration[]>;

  /** Get the specified iteration for a pull request. */
  @tag("Pull Request Iterations")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterations")
  @extension("x-ms-vss-method", "GetPullRequestIteration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration to return. */
    @path iterationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitPullRequestIteration;
}

interface PullRequestIterationChanges {
  /** Retrieve the changes made in a pull request between two iterations. */
  @tag("Pull Request Iteration Changes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestIterationChanges")
  @extension("x-ms-vss-method", "GetPullRequestIterationChanges")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/changes")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration. <br /> Iteration one is the head of the source branch at the time the pull request is created and subsequent iterations are created when there are pushes to the source branch. Allowed values are between 1 and the maximum iteration on this pull request. */
    @path iterationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Optional. The number of changes to retrieve. The default value is 100 and the maximum value is 2000. */
    @query(#{ explode: true }) $top?: int32,

    /** Optional. The number of changes to ignore. For example, to retrieve changes 101-150, set top 50 and skip to 100. */
    @query(#{ explode: true }) $skip?: int32,

    /** ID of the pull request iteration to compare against. The default value is zero which indicates the comparison is made against the common commit between the source and target branches */
    @query(#{ explode: true }) $compareTo?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitPullRequestIterationChanges;
}

interface PullRequestIterationStatuses {
  /** Get all the statuses associated with a pull request iteration. */
  @tag("Pull Request Iteration Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterationStatuses")
  @extension("x-ms-vss-method", "GetPullRequestIterationStatuses")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/statuses")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration. */
    @path iterationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitPullRequestStatus[]>;

  /** Update pull request iteration statuses collection. The only supported operation type is `remove`. This operation allows to delete multiple statuses in one call. The path of the `remove` operation should refer to the ID of the pull request status. For example `path='/1'` refers to the pull request status with ID 1. */
  @tag("Pull Request Iteration Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterationStatuses")
  @extension("x-ms-vss-method", "UpdatePullRequestIterationStatuses")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/statuses")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration. */
    @path iterationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
    @header contentType: "application/json-patch+json",

    /** Operations to apply to the pull request statuses in JSON Patch format. */
    @body body: JsonPatchDocument,
  ): OkResponse;

  /** Create a pull request status on the iteration. This operation will have the same result as Create status on pull request with specified iteration ID in the request body. The only required field for the status is `Context.Name` that uniquely identifies the status. Note that `iterationId` in the request body is optional since `iterationId` can be specified in the URL. A conflict between `iterationId` in the URL and `iterationId` in the request body will result in status code 400. */
  @tag("Pull Request Iteration Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterationStatuses")
  @extension("x-ms-vss-method", "CreatePullRequestIterationStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/statuses")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration. */
    @path iterationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Pull request status to create. */
    @body body: GitPullRequestStatus,
  ): GitPullRequestStatus;

  /** Delete pull request iteration status. You can remove multiple statuses in one call by using Update operation. */
  @tag("Pull Request Iteration Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterationStatuses")
  @extension("x-ms-vss-method", "DeletePullRequestIterationStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/statuses/{statusId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration. */
    @path iterationId: int32,

    /** ID of the pull request status. */
    @path statusId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Get the specific pull request iteration status by ID. The status ID is unique within the pull request across all iterations. */
  @tag("Pull Request Iteration Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestIterationStatuses")
  @extension("x-ms-vss-method", "GetPullRequestIterationStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/iterations/{iterationId}/statuses/{statusId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request iteration. */
    @path iterationId: int32,

    /** ID of the pull request status. */
    @path statusId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitPullRequestStatus;
}

interface PullRequestLabels {
  /** Get all the labels (tags) assigned to a pull request. */
  @tag("Pull Request Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestLabels")
  @extension("x-ms-vss-method", "GetPullRequestLabels")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/labels")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Project ID or project name. */
    @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<WebApiTagDefinition[]>;

  /** Create a tag (if that does not exists yet) and add that as a label (tag) for a specified pull request. The only required field is the name of the new label (tag). */
  @tag("Pull Request Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestLabels")
  @extension("x-ms-vss-method", "CreatePullRequestLabel")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/labels")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Project ID or project name. */
    @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Label to assign to the pull request. */
    @body body: WebApiCreateTagRequestData,
  ): WebApiTagDefinition;

  /** Removes a label (tag) from the set of those assigned to the pull request. The tag itself will not be deleted. */
  @tag("Pull Request Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestLabels")
  @extension("x-ms-vss-method", "DeletePullRequestLabels")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/labels/{labelIdOrName}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** The name or ID of the label requested. */
    @path labelIdOrName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Project ID or project name. */
    @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Retrieves a single label (tag) that has been assigned to a pull request. */
  @tag("Pull Request Labels")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestLabels")
  @extension("x-ms-vss-method", "GetPullRequestLabel")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/labels/{labelIdOrName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** The name or ID of the label requested. */
    @path labelIdOrName: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Project ID or project name. */
    @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WebApiTagDefinition;
}

interface PullRequestProperties {
  /** Get external properties of the pull request. */
  @tag("Pull Request Properties")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestProperties")
  @extension("x-ms-vss-method", "GetPullRequestProperties")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/properties")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PropertiesCollection;

  /** Create or update pull request external properties. The patch operation can be `add`, `replace` or `remove`. For `add` operation, the path can be empty. If the path is empty, the value must be a list of key value pairs. For `replace` operation, the path cannot be empty. If the path does not exist, the property will be added to the collection. For `remove` operation, the path cannot be empty. If the path does not exist, no action will be performed. */
  @tag("Pull Request Properties")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestProperties")
  @extension("x-ms-vss-method", "UpdatePullRequestProperties")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/properties")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/json-patch+json",

    /** Properties to add, replace or remove in JSON Patch format. */
    @body body: JsonPatchDocument,
  ): PropertiesCollection;
}

interface PullRequestReviewers {
  /** Retrieve the reviewers for a pull request */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "GetPullRequestReviewers")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<IdentityRefWithVote[]>;

  /** Reset the votes of multiple reviewers on a pull request. NOTE: This endpoint only supports updating votes, but does not support updating required reviewers (use policy) or display names. */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "UpdatePullRequestReviewers")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers")
  @patch
  UpdatePullRequestReviewers(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** IDs of the reviewers whose votes will be reset to zero */
    @body body: IdentityRefWithVote[],
  ): OkResponse;

  /** Add reviewers to a pull request. */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "CreatePullRequestReviewers")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers")
  @post
  CreatePullRequestReviewers(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Reviewers to add to the pull request. */
    @body body: IdentityRef[],
  ): Body<IdentityRefWithVote[]>;

  /** Add an unmaterialized identity to the reviewers of a pull request. */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "CreateUnmaterializedPullRequestReviewer")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers")
  @put
  CreateUnmaterializedPullRequestReviewer(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Reviewer to add to the pull request. */
    @body body: IdentityRefWithVote,
  ): IdentityRefWithVote;

  /** Remove a reviewer from a pull request. */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "DeletePullRequestReviewer")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers/{reviewerId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the reviewer to remove. */
    @path reviewerId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Retrieve information about a particular reviewer on a pull request */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "GetPullRequestReviewer")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers/{reviewerId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the reviewer. */
    @path reviewerId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): IdentityRefWithVote;

  /** Edit a reviewer entry. These fields are patchable: isFlagged, hasDeclined */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "UpdatePullRequestReviewer")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers/{reviewerId}")
  @patch
  UpdatePullRequestReviewer(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the reviewer. */
    @path reviewerId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Reviewer data.<br />If the reviewer's ID is included here, it must match the reviewerID parameter. */
    @body body: IdentityRefWithVote,
  ): IdentityRefWithVote;

  /** Add a reviewer to a pull request or cast a vote. */
  @tag("Pull Request Reviewers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestReviewers")
  @extension("x-ms-vss-method", "CreatePullRequestReviewer")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/reviewers/{reviewerId}")
  @put
  CreatePullRequestReviewer(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the reviewer. */
    @path reviewerId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Reviewer's vote.<br />If the reviewer's ID is included here, it must match the reviewerID parameter.<br />Reviewers can set their own vote with this method. When adding other reviewers, vote must be set to zero. */
    @body body: IdentityRefWithVote,
  ): IdentityRefWithVote;
}

interface PullRequestShare {
  /** Sends an e-mail notification about a specific pull request to a set of recipients */
  @tag("Pull Request Share")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestShare")
  @extension("x-ms-vss-method", "SharePullRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/share")
  @post
  SharePullRequest(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the git repository. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: ShareNotificationContext,
  ): OkResponse;
}

interface PullRequestStatuses {
  /** Get all the statuses associated with a pull request. */
  @tag("Pull Request Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestStatuses")
  @extension("x-ms-vss-method", "GetPullRequestStatuses")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/statuses")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitPullRequestStatus[]>;

  /** Update pull request statuses collection. The only supported operation type is `remove`. This operation allows to delete multiple statuses in one call. The path of the `remove` operation should refer to the ID of the pull request status. For example `path='/1'` refers to the pull request status with ID 1. */
  @tag("Pull Request Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestStatuses")
  @extension("x-ms-vss-method", "UpdatePullRequestStatuses")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/statuses")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
    @header contentType: "application/json-patch+json",

    /** Operations to apply to the pull request statuses in JSON Patch format. */
    @body body: JsonPatchDocument,
  ): OkResponse;

  /** Create a pull request status. The only required field for the status is `Context.Name` that uniquely identifies the status. Note that you can specify iterationId in the request body to post the status on the iteration. */
  @tag("Pull Request Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestStatuses")
  @extension("x-ms-vss-method", "CreatePullRequestStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/statuses")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Pull request status to create. */
    @body body: GitPullRequestStatus,
  ): GitPullRequestStatus;

  /** Delete pull request status. You can remove multiple statuses in one call by using Update operation. */
  @tag("Pull Request Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestStatuses")
  @extension("x-ms-vss-method", "DeletePullRequestStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/statuses/{statusId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request status. */
    @path statusId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Get the specific pull request status by ID. The status ID is unique within the pull request across all iterations. */
  @tag("Pull Request Statuses")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "pullRequestStatuses")
  @extension("x-ms-vss-method", "GetPullRequestStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/statuses/{statusId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request’s target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the pull request status. */
    @path statusId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitPullRequestStatus;
}

interface PullRequestThreads {
  /** Retrieve all threads in a pull request. */
  @tag("Pull Request Threads")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreads")
  @extension("x-ms-vss-method", "GetThreads")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If specified, thread positions will be tracked using this iteration as the right side of the diff. */
    @query(#{ explode: true }) $iteration?: int32,

    /** If specified, thread positions will be tracked using this iteration as the left side of the diff. */
    @query(#{ explode: true }) $baseIteration?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitPullRequestCommentThread[]>;

  /** Create a thread in a pull request. */
  @tag("Pull Request Threads")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreads")
  @extension("x-ms-vss-method", "CreateThread")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The thread to create. Thread must contain at least one comment. */
    @body body: GitPullRequestCommentThread,
  ): GitPullRequestCommentThread;

  /** Retrieve a thread in a pull request. */
  @tag("Pull Request Threads")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreads")
  @extension("x-ms-vss-method", "GetPullRequestThread")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread. */
    @path threadId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If specified, thread position will be tracked using this iteration as the right side of the diff. */
    @query(#{ explode: true }) $iteration?: int32,

    /** If specified, thread position will be tracked using this iteration as the left side of the diff. */
    @query(#{ explode: true }) $baseIteration?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitPullRequestCommentThread;

  /** Update a thread in a pull request. */
  @tag("Pull Request Threads")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreads")
  @extension("x-ms-vss-method", "UpdateThread")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread to update. */
    @path threadId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The thread content that should be updated. */
    @body body: GitPullRequestCommentThread,
  ): GitPullRequestCommentThread;
}

interface PullRequestThreadComments {
  /** Retrieve all comments associated with a specific thread in a pull request. */
  @tag("Pull Request Thread Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreadComments")
  @extension("x-ms-vss-method", "GetComments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread. */
    @path threadId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Comment[]>;

  /** Create a comment on a specific thread in a pull request (up to 500 comments can be created per thread). */
  @tag("Pull Request Thread Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreadComments")
  @extension("x-ms-vss-method", "CreateComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread that the desired comment is in. */
    @path threadId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The comment to create. Comments can be up to 150,000 characters. */
    @body body: Comment,
  ): Comment;

  /** Delete a comment associated with a specific thread in a pull request. */
  @tag("Pull Request Thread Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreadComments")
  @extension("x-ms-vss-method", "DeleteComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments/{commentId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread that the desired comment is in. */
    @path threadId: int32,

    /** ID of the comment. */
    @path commentId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Retrieve a comment associated with a specific thread in a pull request. */
  @tag("Pull Request Thread Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreadComments")
  @extension("x-ms-vss-method", "GetComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments/{commentId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread that the desired comment is in. */
    @path threadId: int32,

    /** ID of the comment. */
    @path commentId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Comment;

  /** Update a comment associated with a specific thread in a pull request. */
  @tag("Pull Request Thread Comments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestThreadComments")
  @extension("x-ms-vss-method", "UpdateComment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments/{commentId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** ID of the thread that the desired comment is in. */
    @path threadId: int32,

    /** ID of the comment to update. */
    @path commentId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The comment content that should be updated. Comments can be up to 150,000 characters. */
    @body body: Comment,
  ): Comment;
}

interface PullRequestCommentLikes {
  /** Delete a like on a comment. */
  @tag("Pull Request Comment Likes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestCommentLikes")
  @extension("x-ms-vss-method", "DeleteLike")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments/{commentId}/likes")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** The ID of the thread that contains the comment. */
    @path threadId: int32,

    /** The ID of the comment. */
    @path commentId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get likes for a comment. */
  @tag("Pull Request Comment Likes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestCommentLikes")
  @extension("x-ms-vss-method", "GetLikes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments/{commentId}/likes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** The ID of the thread that contains the comment. */
    @path threadId: int32,

    /** The ID of the comment. */
    @path commentId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<IdentityRef[]>;

  /** Add a like on a comment. */
  @tag("Pull Request Comment Likes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestCommentLikes")
  @extension("x-ms-vss-method", "CreateLike")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments/{commentId}/likes")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The repository ID of the pull request's target branch. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** The ID of the thread that contains the comment. */
    @path threadId: int32,

    /** The ID of the comment. */
    @path commentId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface PullRequestWorkItems {
  /** Retrieve a list of work items associated with a pull request. */
  @tag("Pull Request Work Items")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pullRequestWorkItems")
  @extension("x-ms-vss-method", "GetPullRequestWorkItemRefs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/workitems")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID or name of the repository. */
    @path repositoryId: string,

    /** ID of the pull request. */
    @path pullRequestId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ResourceRef[]>;
}

interface Pushes {
  /** Retrieves pushes associated with the specified repository. */
  @tag("Pushes")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "pushes")
  @extension("x-ms-vss-method", "GetPushes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pushes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Number of pushes to skip. */
    @query(#{ explode: true }) $skip?: int32,

    /** Number of pushes to return. */
    @query(#{ explode: true }) $top?: int32,

    /** Search criteria attributes: fromDate, toDate, pusherId, refName, includeRefUpdates or includeLinks. fromDate: Start date to search from. toDate: End date to search to. pusherId: Identity of the person who submitted the push. refName: Branch name to consider. includeRefUpdates: If true, include the list of refs that were updated by the push. includeLinks: Whether to include the _links field on the shallow references. */
    @query(#{ name: "searchCriteria.fromDate", explode: true }) searchCriteriaFromDate?: utcDateTime,

    /** Whether to include the _links field on the shallow references */
    @query(#{ name: "searchCriteria.includeLinks", explode: true }) searchCriteriaIncludeLinks?: boolean,

    /** Search criteria attributes: fromDate, toDate, pusherId, refName, includeRefUpdates or includeLinks. fromDate: Start date to search from. toDate: End date to search to. pusherId: Identity of the person who submitted the push. refName: Branch name to consider. includeRefUpdates: If true, include the list of refs that were updated by the push. includeLinks: Whether to include the _links field on the shallow references. */
    @query(#{ name: "searchCriteria.includeRefUpdates", explode: true }) searchCriteriaIncludeRefUpdates?: boolean,

    /** Search criteria attributes: fromDate, toDate, pusherId, refName, includeRefUpdates or includeLinks. fromDate: Start date to search from. toDate: End date to search to. pusherId: Identity of the person who submitted the push. refName: Branch name to consider. includeRefUpdates: If true, include the list of refs that were updated by the push. includeLinks: Whether to include the _links field on the shallow references. */
    @format("uuid") @query(#{ name: "searchCriteria.pusherId", explode: true }) searchCriteriaPusherId?: string,

    /** Search criteria attributes: fromDate, toDate, pusherId, refName, includeRefUpdates or includeLinks. fromDate: Start date to search from. toDate: End date to search to. pusherId: Identity of the person who submitted the push. refName: Branch name to consider. includeRefUpdates: If true, include the list of refs that were updated by the push. includeLinks: Whether to include the _links field on the shallow references. */
    @query(#{ name: "searchCriteria.refName", explode: true }) searchCriteriaRefName?: string,

    /** Search criteria attributes: fromDate, toDate, pusherId, refName, includeRefUpdates or includeLinks. fromDate: Start date to search from. toDate: End date to search to. pusherId: Identity of the person who submitted the push. refName: Branch name to consider. includeRefUpdates: If true, include the list of refs that were updated by the push. includeLinks: Whether to include the _links field on the shallow references. */
    @query(#{ name: "searchCriteria.toDate", explode: true }) searchCriteriaToDate?: utcDateTime,

    ...Parameters.`api-Version-preview`.`3`,
  ): Body<GitPush[]>;

  /** Push changes to the repository. */
  @tag("Pushes")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "pushes")
  @extension("x-ms-vss-method", "CreatePush")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pushes")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`3`,
    @body body: GitPush,
  ): GitPush;

  /** Retrieves a particular push. */
  @tag("Pushes")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "pushes")
  @extension("x-ms-vss-method", "GetPush")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/pushes/{pushId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** ID of the push. */
    @path pushId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The number of commits to include in the result. */
    @query(#{ explode: true }) includeCommits?: int32,

    /** If true, include the list of refs that were updated by the push. */
    @query(#{ explode: true }) includeRefUpdates?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): GitPush;
}

interface Refs {
  /** Queries the provided repository for its refs and returns them. */
  @tag("Refs")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "refs")
  @extension("x-ms-vss-method", "GetRefs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/refs")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** [optional] A filter to apply to the refs (starts with). */
    @query(#{ explode: true }) filter?: string,

    /** [optional] Specifies if referenceLinks should be included in the result. default is false. */
    @query(#{ explode: true }) includeLinks?: boolean,

    /** [optional] Includes up to the first 1000 commit statuses for each ref. The default value is false. */
    @query(#{ explode: true }) includeStatuses?: boolean,

    /** [optional] Includes only branches that the user owns, the branches the user favorites, and the default branch. The default value is false. Cannot be combined with the filter parameter. */
    @query(#{ explode: true }) includeMyBranches?: boolean,

    /** [optional] True to include only the tip commit status for each ref. This option requires `includeStatuses` to be true. The default value is false. */
    @query(#{ explode: true }) latestStatusesOnly?: boolean,

    /** [optional] Annotated tags will populate the PeeledObjectId property. default is false. */
    @query(#{ explode: true }) peelTags?: boolean,

    /** [optional] A filter to apply to the refs (contains). */
    @query(#{ explode: true }) filterContains?: string,

    /** [optional] Maximum number of refs to return. It cannot be bigger than 1000. If it is not provided but continuationToken is, top will default to 100. */
    @query(#{ explode: true }) $top?: int32,

    /** The continuation token used for pagination. */
    @query(#{ explode: true }) continuationToken?: string,

    /** [optional] Includes target branches defined by patterns in pull_request_targets.yml. */
    @query(#{ explode: true }) includeTargetBranches?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: GitRef[];
  };

  /** Lock or Unlock a branch. */
  @tag("Refs")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "refs")
  @extension("x-ms-vss-method", "UpdateRef")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/refs")
  @patch
  UpdateRef(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** The name of the branch to lock/unlock */
    @query(#{ explode: true }) filter: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** ID or name of the team project. Optional if specifying an ID for repository. */
    @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** The ref update action (lock/unlock) to perform */
    @body body: GitRefUpdate,
  ): GitRef;

  /** Creating, updating, or deleting refs(branches). Updating a ref means making it point at a different commit than it used to. You must specify both the old and new commit to avoid race conditions. */
  @tag("Refs")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "refs")
  @extension("x-ms-vss-method", "UpdateRefs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/refs")
  @post
  UpdateRefs(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** ID or name of the team project. Optional if specifying an ID for repository. */
    @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** List of ref updates to attempt to perform */
    @body body: GitRefUpdate[],
  ): Body<GitRefUpdateResult[]>;
}

interface Reverts {
  /** Retrieve information about a revert operation for a specific branch. */
  @tag("Reverts")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "reverts")
  @extension("x-ms-vss-method", "GetRevertForRefName")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/reverts")
  @get
  GetRevertForRefName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the repository. */
    @path repositoryId: string,

    /** The GitAsyncRefOperationParameters generatedRefName used for the revert operation. */
    @query(#{ explode: true }) refName: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitRevert;

  /** Starts the operation to create a new branch which reverts changes introduced by either a specific commit or commits that are associated to a pull request. */
  @tag("Reverts")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "reverts")
  @extension("x-ms-vss-method", "CreateRevert")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/reverts")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the repository. */
    @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: GitAsyncRefOperationParameters,
  ): GitRevert;

  /** Retrieve information about a revert operation by revert Id. */
  @tag("Reverts")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "reverts")
  @extension("x-ms-vss-method", "GetRevert")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/reverts/{revertId}")
  @get
  GetRevert(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the revert operation. */
    @path revertId: int32,

    /** ID of the repository. */
    @path repositoryId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): GitRevert;
}

interface Stats {
  /** Retrieve statistics about all branches within a repository. */
  @tag("Stats")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "branchStats")
  @extension("x-ms-vss-method", "GetBranches")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/stats/branches")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Version string identifier (name of tag/branch, SHA1 of commit) */
    @query(#{ name: "baseVersionDescriptor.version", explode: true }) baseVersionDescriptorVersion?: string,

    /** Version options - Specify additional modifiers to version (e.g Previous) */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionOptions",
        values: #[
          #{ value: "none", description: "Not specified" },
          #{
            value: "previousChange",
            description: "Commit that changed item prior to the current version",
          },
          #{ value: "firstParent", description: "First parent of commit (HEAD^)" }
        ],
      }
    )
    @query(#{ explode: true })
    `baseVersionDescriptor.versionOptions`?: "none" | "previousChange" | "firstParent",

    /** Version type (branch, tag, or commit). Determines how Id is interpreted */
    @extension(
      "x-ms-enum",
      #{
        name: "GitVersionType",
        values: #[
          #{ value: "branch", description: "Interpret the version as a branch name" },
          #{ value: "tag", description: "Interpret the version as a tag name" },
          #{ value: "commit", description: "Interpret the version as a commit ID (SHA1)" }
        ],
      }
    )
    @query(#{ explode: true })
    `baseVersionDescriptor.versionType`?: "branch" | "tag" | "commit",

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<GitBranchStats[]>;
}

interface Suggestions {
  /** Retrieve a pull request suggestion for a particular repository or team project. */
  @tag("Suggestions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suggestions")
  @extension("x-ms-vss-method", "GetSuggestions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/suggestions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the git repository. */
    @path repositoryId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** If true, prefer the compare branch over the default branch as target branch for pull requests. */
    @query(#{ explode: true }) preferCompareBranch?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitSuggestion[]>;
}

interface Trees {
  /** The Tree endpoint returns the collection of objects underneath the specified tree. Trees are folders in a Git repository. Repositories have both a name and an identifier. Identifiers are globally unique, but several projects may contain a repository of the same name. You don't need to include the project if you specify a repository by ID. However, if you specify a repository by name, you must also specify the project (by name or ID. */
  @tag("Trees")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "trees")
  @extension("x-ms-vss-method", "GetTree")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryId}/trees/{sha1}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Repository Id. */
    @path repositoryId: string,

    /** SHA1 hash of the tree object. */
    @path sha1: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Project Id. */
    @query(#{ explode: true }) projectId?: string,

    /** Search recursively. Include trees underneath this tree. Default is false. */
    @query(#{ explode: true }) recursive?: boolean,

    /** Name to use if a .zip file is returned. Default is the object ID. */
    @query(#{ explode: true }) fileName?: string,

    /** Use 'zip'. Defaults to the MIME type set in the Accept header. */
    @query(#{ explode: true }) $format?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header contentType: "application/zip";
        @body body: GitTreeRef;
      }
    | GitTreeRef;
}

interface MergeBases {
  /** Find the merge bases of two commits, optionally across forks. If otherRepositoryId is not specified, the merge bases will only be calculated within the context of the local repositoryNameOrId. */
  @tag("Merge Bases")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "mergeBases")
  @extension("x-ms-vss-method", "GetMergeBases")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/commits/{commitId}/mergebases")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID or name of the local repository. */
    @path repositoryNameOrId: string,

    /** First commit, usually the tip of the target branch of the potential merge. */
    @path commitId: string,

    /** Other commit, usually the tip of the source branch of the potential merge. */
    @query(#{ explode: true }) otherCommitId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** The collection ID where otherCommitId lives. */
    @format("uuid") @query(#{ explode: true }) otherCollectionId?: string,

    /** The repository ID where otherCommitId lives. */
    @format("uuid") @query(#{ explode: true }) otherRepositoryId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitCommitRef[]>;
}

interface Forks {
  /** Retrieve all forks of a repository in the collection. */
  @tag("Forks")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "forks")
  @extension("x-ms-vss-method", "GetForks")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/forks/{collectionId}")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryNameOrId: string,

    /** Team project collection ID. */
    @format("uuid") @path collectionId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include links. */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitRepositoryRef[]>;

  /** Retrieve all requested fork sync operations on this repository. */
  @tag("Forks")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "forkSyncRequests")
  @extension("x-ms-vss-method", "GetForkSyncRequests")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/forkSyncRequests")
  @get
  GetForkSyncRequests(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryNameOrId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include abandoned requests. */
    @query(#{ explode: true }) includeAbandoned?: boolean,

    /** True to include links. */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<GitForkSyncRequest[]>;

  /** Request that another repository's refs be fetched into this one. It syncs two existing forks. To create a fork, please see the <a href='https://docs.microsoft.com/en-us/rest/api/vsts/git/repositories/create?view=azure-devops-rest-5.1'> repositories endpoint</a> */
  @tag("Forks")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "forkSyncRequests")
  @extension("x-ms-vss-method", "CreateForkSyncRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/forkSyncRequests")
  @post
  CreateForkSyncRequest(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryNameOrId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include links */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,

    /** Source repository and ref mapping. */
    @body body: GitForkSyncRequestParameters,
  ): GitForkSyncRequest;

  /** Get a specific fork sync operation's details. */
  @tag("Forks")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "forkSyncRequests")
  @extension("x-ms-vss-method", "GetForkSyncRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/forkSyncRequests/{forkSyncOperationId}")
  @get
  GetForkSyncRequest(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID of the repository. */
    @path repositoryNameOrId: string,

    /** OperationId of the sync request. */
    @path forkSyncOperationId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** True to include links. */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitForkSyncRequest;
}

interface Merges {
  /** Request a git merge operation. Currently we support merging only 2 commits. */
  @tag("Merges")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "merges")
  @extension("x-ms-vss-method", "CreateMergeRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/merges")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repositoryNameOrId: string,

    /** True to include links */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,

    /** Parents commitIds and merge commit messsage. */
    @body body: GitMergeParameters,
  ): GitMerge;

  /** Get a specific merge operation's details. */
  @tag("Merges")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "merges")
  @extension("x-ms-vss-method", "GetMergeRequest")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/git/repositories/{repositoryNameOrId}/merges/{mergeOperationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repositoryNameOrId: string,

    /** OperationId of the merge request. */
    @path mergeOperationId: int32,

    /** True to include links */
    @query(#{ explode: true }) includeLinks?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): GitMerge;
}
