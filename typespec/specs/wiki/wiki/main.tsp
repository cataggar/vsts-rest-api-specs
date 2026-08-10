import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Wiki" })
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
namespace Wiki;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Comment on an artifact like Work Item or Wiki, etc. */
model Comment {
  ...CommentResourceReference;

  /** The id of the artifact this comment belongs to */
  artifactId?: string;

  createdBy?: IdentityRef;

  /** The creation date of the comment. */
  createdDate?: utcDateTime;

  /** The id assigned to the comment. */
  id?: int32;

  /** Indicates if the comment has been deleted. */
  isDeleted?: boolean;

  /** The mentions of the comment. */
  mentions?: CommentMention[];

  modifiedBy?: IdentityRef;

  /** The last modification date of the comment. */
  modifiedDate?: utcDateTime;

  /** The comment id of the parent comment, if any */
  parentId?: int32;

  /** The reactions on the comment. */
  reactions?: CommentReaction[];

  /** The rendered text of the comment */
  renderedText?: string;

  replies?: CommentList;

  /** Indicates the current state of the comment */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentState",
      values: #[
        #{ value: "active", description: "" },
        #{ value: "resolved", description: "" },
        #{ value: "closed", description: "" }
      ],
    }
  )
  state?: "active" | "resolved" | "closed";

  /** The plaintext/markdown version of the comment */
  text?: string;

  /** The current version of the comment */
  version?: int32;
}

/** Represents an attachment to a comment. */
model CommentAttachment {
  ...CommentResourceReference;
  createdBy?: IdentityRef;

  /** The creation date of the attachment. */
  createdDate?: utcDateTime;

  /** Unique Id of the attachment. */
  @format("uuid") id?: string;
}

/** Represents a request to create a work item comment. */
model CommentCreateParameters {
  /** Optional CommentId of the parent in order to add a reply for an existing comment */
  parentId?: int32;

  /** Text of the comment */
  text?: string;
}

/** Represents a list of comments. */
model CommentList {
  ...CommentResourceReference;

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

/** Contains information about various artifacts mentioned in the comment */
model CommentMention {
  ...CommentResourceReference;

  /** Id of the artifact this mention belongs to */
  artifactId?: string;

  /** Id of the comment associated with this mention. Nullable to support legacy mentions which can potentially have null commentId */
  commentId?: int32;

  /** Value of the mentioned artifact. Expected Value varies by CommentMentionType: Person: VSID associated with the identity Work Item: ID of the work item Pull Request: ID of the Pull Request */
  mentionedArtifact?: string;

  /** The context which represent where this mentioned was parsed from */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentMentionType",
      values: #[
        #{ value: "person", description: "An identity was mentioned by using the format @{VSID}" },
        #{
          value: "workItem",
          description: "A work item was mentioned by using the format #{Work Item ID}",
        },
        #{
          value: "pullRequest",
          description: "A Pull Request was mentioned by using the format !{PR Number}",
        }
      ],
    }
  )
  type?: "person" | "workItem" | "pullRequest";
}

/** Contains information about comment reaction for a particular reaction type. */
model CommentReaction {
  ...CommentResourceReference;

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
  type?: "like" | "dislike" | "heart" | "hooray" | "smile" | "confused";
}

/** Base class for comment resource references */
model CommentResourceReference {
  /** REST URL for the resource. */
  url?: string;
}

/** Represents a request to update a comment. */
model CommentUpdateParameters {
  /** Set the current state of the comment */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentState",
      values: #[
        #{ value: "active", description: "" },
        #{ value: "resolved", description: "" },
        #{ value: "closed", description: "" }
      ],
    }
  )
  state?: "active" | "resolved" | "closed";

  /** The updated text of the comment */
  text?: string;
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

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model TeamProjectCollectionReference {
  avatarUrl?: string;
  @format("uuid") id?: string;
  name?: string;
  url?: string;
}

model TeamProjectReference {
  abbreviation?: string;
  defaultTeamImageUrl?: string;
  description?: string;
  @format("uuid") id?: string;
  lastUpdateTime?: utcDateTime;
  name?: string;
  revision?: int64;
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectState",
      values: #[
        #{ value: "deleting", description: "" },
        #{ value: "new", description: "" },
        #{ value: "wellFormed", description: "" },
        #{ value: "createPending", description: "" },
        #{ value: "all", description: "" },
        #{ value: "unchanged", description: "" },
        #{ value: "deleted", description: "" }
      ],
    }
  )
  state?: "deleting" | "new" | "wellFormed" | "createPending" | "all" | "unchanged" | "deleted";
  url?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectVisibility",
      values: #[#{ value: "private", description: "" }, #{ value: "public", description: "" }],
    }
  )
  visibility?: "private" | "public";
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

/** Defines a wiki repository which encapsulates the git repository backing the wiki. */
model Wiki {
  ...WikiCreateParameters;

  /** The head commit associated with the git repository backing up the wiki. */
  headCommit?: string;

  /** The ID of the wiki which is same as the ID of the Git repository that it is backed by. */
  @format("uuid") id?: string;

  repository?: GitRepository;
}

/** Defines properties for wiki attachment file. */
model WikiAttachment {
  /** Name of the wiki attachment file. */
  name?: string;

  /** Path of the wiki attachment file. */
  path?: string;
}

/** Response contract for the Wiki Attachments API */
model WikiAttachmentResponse {
  attachment?: WikiAttachment;

  /** Contains the list of ETag values from the response header of the attachments API call. The first item in the list contains the version of the wiki attachment. */
  eTag?: string[];
}

/** Base wiki creation parameters. */
model WikiCreateBaseParameters {
  /** Folder path inside repository which is shown as Wiki. Not required for ProjectWiki type. */
  mappedPath?: string;

  /** Wiki name. */
  name?: string;

  /** ID of the project in which the wiki is to be created. */
  @format("uuid") projectId?: string;

  /** ID of the git repository that backs up the wiki. Not required for ProjectWiki type. */
  @format("uuid") repositoryId?: string;

  /** Type of the wiki. */
  @extension(
    "x-ms-enum",
    #{
      name: "WikiType",
      values: #[
        #{
          value: "projectWiki",
          description: "Indicates that the wiki is provisioned for the team project",
        },
        #{
          value: "codeWiki",
          description: "Indicates that the wiki is published from a git repository",
        }
      ],
    }
  )
  type?: "projectWiki" | "codeWiki";
}

/** Wiki creations parameters. */
model WikiCreateParameters {
  /** Wiki name. */
  name?: string;

  /** ID of the project in which the wiki is to be created. */
  @format("uuid") projectId?: string;
}

/** Wiki creation parameters. */
model WikiCreateParametersV2 {
  ...WikiCreateBaseParameters;
  version?: GitVersionDescriptor;
}

/** Defines a page in a wiki. */
model WikiPage {
  ...WikiPageCreateOrUpdateParameters;

  /** Path of the git item corresponding to the wiki page stored in the backing Git repository. */
  gitItemPath?: string;

  /** When present, permanent identifier for the wiki page */
  id?: int32;

  /** True if a page is non-conforming, i.e. 1) if the name doesn't match page naming standards. 2) if the page does not have a valid entry in the appropriate order file. */
  isNonConformant?: boolean;

  /** True if this page has subpages under its path. */
  isParentPage?: boolean;

  /** Order of the wiki page, relative to other pages in the same hierarchy level. */
  order?: int32;

  /** Path of the wiki page. */
  path?: string;

  /** Remote web url to the wiki page. */
  remoteUrl?: string;

  /** List of subpages of the current page. */
  subPages?: WikiPage[];

  /** REST url for this wiki page. */
  url?: string;
}

/** Contract encapsulating parameters for the page create or update operations. */
model WikiPageCreateOrUpdateParameters {
  /** Content of the wiki page. */
  content?: string;
}

/** Defines a page with its metedata in a wiki. */
model WikiPageDetail {
  /** When present, permanent identifier for the wiki page */
  id?: int32;

  /** Path of the wiki page. */
  path?: string;

  /** Path of the wiki page. */
  viewStats?: WikiPageStat[];
}

/** Request contract for Wiki Page Move. */
model WikiPageMove {
  ...WikiPageMoveParameters;
  page?: WikiPage;
}

/** Contract encapsulating parameters for the page move operation. */
model WikiPageMoveParameters {
  /** New order of the wiki page. */
  newOrder?: int32;

  /** New path of the wiki page. */
  newPath?: string;

  /** Current path of the wiki page. */
  path?: string;
}

/** Response contract for the Wiki Page Move API. */
model WikiPageMoveResponse {
  /** Contains the list of ETag values from the response header of the page move API call. The first item in the list contains the version of the wiki page subject to page move. */
  eTag?: string[];

  pageMove?: WikiPageMove;
}

/** Response contract for the Wiki Pages PUT, PATCH and DELETE APIs. */
model WikiPageResponse {
  /** Contains the list of ETag values from the response header of the pages API call. The first item in the list contains the version of the wiki page. */
  eTag?: string[];

  page?: WikiPage;
}

/** Contract encapsulating parameters for the pages batch. */
model WikiPagesBatchRequest {
  /** If the list of page data returned is not complete, a continuation token to query next batch of pages is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of Wiki Page Data. */
  continuationToken?: string;

  /** last N days from the current day for which page views is to be returned. It's inclusive of current day. */
  pageViewsForDays?: int32;

  /** Total count of pages on a wiki to return. */
  top?: int32;
}

/** Defines properties for wiki page stat. */
model WikiPageStat {
  /** the count of the stat for the Day */
  count?: int32;

  /** Day of the stat */
  day?: utcDateTime;
}

/** Defines properties for wiki page view stats. */
model WikiPageViewStats {
  /** Wiki page view count. */
  count?: int32;

  /** Wiki page last viewed time. */
  lastViewedTime?: utcDateTime;

  /** Wiki page path. */
  path?: string;
}

model WikiUpdatedNotificationMessage {
  /** Collection host Id for which the wikis are updated. */
  @format("uuid") collectionId?: string;

  /** Project Id for which the wikis are updated. */
  @format("uuid") projectId?: string;

  /** Repository Id associated with the particular wiki which is added, updated or deleted. */
  @format("uuid") repositoryId?: string;
}

/** Wiki update parameters. */
model WikiUpdateParameters {
  /** Name for wiki. */
  name?: string;

  /** Versions of the wiki. */
  versions?: GitVersionDescriptor[];
}

/** Defines a wiki resource. */
model WikiV2 {
  ...WikiCreateBaseParameters;

  /** ID of the wiki. */
  @format("uuid") id?: string;

  /** Is wiki repository disabled */
  isDisabled?: boolean;

  /** Properties of the wiki. */
  properties?: Record<string>;

  /** Remote web url to the wiki. */
  remoteUrl?: string;

  /** REST url for this wiki. */
  url?: string;

  /** Versions of the wiki. */
  versions?: GitVersionDescriptor[];
}

/** A collection of `WikiV2` as returned by Azure DevOps. */
model WikiV2List {
  count?: int32;
  value?: WikiV2[];
}

/** A collection of `WikiPageDetail` as returned by Azure DevOps. */
model WikiPageDetailList {
  count?: int32;
  value?: WikiPageDetail[];
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
  }
}

interface Wikis {
  /** Gets all wikis in a project or collection. */
  @tag("Wikis")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wikis")
  @extension("x-ms-vss-method", "GetAllWikis")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WikiV2List;

  /** Creates the wiki resource. */
  @tag("Wikis")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wikis")
  @extension("x-ms-vss-method", "CreateWiki")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Parameters for the wiki creation. */
    @body body: WikiCreateParametersV2,
  ): CreatedResponse & WikiV2;

  /** Deletes the wiki corresponding to the wiki ID or wiki name provided. */
  @tag("Wikis")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wikis")
  @extension("x-ms-vss-method", "DeleteWiki")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WikiV2;

  /** Gets the wiki corresponding to the wiki ID or wiki name provided. */
  @tag("Wikis")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wikis")
  @extension("x-ms-vss-method", "GetWiki")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): WikiV2;

  /** Updates the wiki corresponding to the wiki ID or wiki name provided using the update parameters. */
  @tag("Wikis")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "wikis")
  @extension("x-ms-vss-method", "UpdateWiki")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Update parameters. */
    @body body: WikiUpdateParameters,
  ): WikiV2;
}

interface Attachments {
  /** Creates an attachment in the wiki. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "CreateAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/attachments")
  @put
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki attachment name. */
    @query(#{ explode: true }) name: string,

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

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/octet-stream",

    /** Stream to upload */
    @body body: string,
  ): {
    @statusCode statusCode: 201;
    @header ETag?: string;
    @body body: WikiAttachment;
  };
}

interface PageMoves {
  /** Creates a page move operation that updates the path and order of the page as provided in the parameters. */
  @tag("Page Moves")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pageMoves")
  @extension("x-ms-vss-method", "CreatePageMove")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pagemoves")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Comment that is to be associated with this page move. */
    @query(#{ explode: true }) comment?: string,

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

    ...Parameters.`api-Version-preview`.`1`,

    /** Page more operation parameters. */
    @body body: WikiPageMoveParameters,
  ): {
    @statusCode statusCode: 201;
    @header ETag?: string;
    @body body: WikiPageMove;
  };
}

interface Pages {
  /** Deletes a wiki page. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "DeletePage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages")
  @delete
  DeletePage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki page path. */
    @query(#{ explode: true }) path: string,

    /** Comment to be associated with this page delete. */
    @query(#{ explode: true }) comment?: string,

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

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @body body: WikiPage;
      };

  /** Gets metadata or content of the wiki page for the provided path. Content negotiation is done based on the `Accept` header sent in the request. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "GetPage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages")
  @get
  GetPage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki page path. */
    @query(#{ explode: true }) path?: string,

    /** Recursion level for subpages retrieval. Defaults to `None` (Optional). */
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

    /** True to include the content of the page in the response for Json content type. Defaults to false (Optional) */
    @query(#{ explode: true }) includeContent?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header ETag?: string;
        @header contentType: "application/zip";
        @body body: WikiPage;
      }
    | {
        @header ETag?: string;
        @header contentType: "text/plain";
        @body body: WikiPage;
      }
    | {
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @header contentType: "application/zip";
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @header contentType: "text/plain";
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @body body: WikiPage;
      };

  /** Creates or edits a wiki page. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "CreateOrUpdatePage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages")
  @put
  CreateOrUpdate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki page path. */
    @query(#{ explode: true }) path: string,

    /** Version of the page on which the change is to be made. Mandatory for `Edit` scenario. To be populated in the If-Match header of the request. */
    @header Version: string,

    /** Comment to be associated with the page operation. */
    @query(#{ explode: true }) comment?: string,

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

    ...Parameters.`api-Version-preview`.`1`,

    /** Wiki create or update operation parameters. */
    @body body: WikiPageCreateOrUpdateParameters,
  ):
    | {
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 201;
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @body body: WikiPage;
      };

  /** Deletes a wiki page. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "DeletePageById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages/{id}")
  @delete
  DeletePageById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki page ID. */
    @path id: int32,

    /** Comment to be associated with this page delete. */
    @query(#{ explode: true }) comment?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @body body: WikiPage;
      };

  /** Gets metadata or content of the wiki page for the provided page id. Content negotiation is done based on the `Accept` header sent in the request. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "GetPageById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages/{id}")
  @get
  GetPageById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name.. */
    @path wikiIdentifier: string,

    /** Wiki page ID. */
    @path id: int32,

    /** Recursion level for subpages retrieval. Defaults to `None` (Optional). */
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

    /** True to include the content of the page in the response for Json content type. Defaults to false (Optional) */
    @query(#{ explode: true }) includeContent?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header ETag?: string;
        @header contentType: "application/zip";
        @body body: WikiPage;
      }
    | {
        @header ETag?: string;
        @header contentType: "text/plain";
        @body body: WikiPage;
      }
    | {
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @header contentType: "application/zip";
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @header contentType: "text/plain";
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @body body: WikiPage;
      };

  /** Edits a wiki page. */
  @tag("Pages")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pages")
  @extension("x-ms-vss-method", "UpdatePageById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages/{id}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki page ID. */
    @path id: int32,

    /** Version of the page on which the change is to be made. Mandatory for `Edit` scenario. To be populated in the If-Match header of the request. */
    @header Version: string,

    /** Comment to be associated with the page operation. */
    @query(#{ explode: true }) comment?: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Wiki update operation parameters. */
    @body body: WikiPageCreateOrUpdateParameters,
  ):
    | {
        @header ETag?: string;
        @body body: WikiPage;
      }
    | {
        @statusCode statusCode: 404;
        @header ETag?: string;
        @body body: WikiPage;
      };
}

interface PageStats {
  /** Returns page detail corresponding to Page ID. */
  @tag("Page Stats")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pageStats")
  @extension("x-ms-vss-method", "GetPageData")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pages/{pageId}/stats")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

    /** Wiki page ID. */
    @path pageId: int32,

    /** last N days from the current day for which page views is to be returned. It's inclusive of current day. */
    @query(#{ explode: true }) pageViewsForDays?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): WikiPageDetail;
}

interface PagesBatch {
  /** Returns pageable list of Wiki Pages */
  @tag("Pages Batch")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pagesBatch")
  @extension("x-ms-vss-method", "GetPagesBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/wiki/wikis/{wikiIdentifier}/pagesbatch")
  @post
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Wiki ID or wiki name. */
    @path wikiIdentifier: string,

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

    ...Parameters.`api-Version-preview`.`1`,

    /** Wiki batch page request. */
    @body body: WikiPagesBatchRequest,
  ): WikiPageDetailList;
}
