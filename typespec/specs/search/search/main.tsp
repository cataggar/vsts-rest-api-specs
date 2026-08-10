import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Search" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://almsearch.dev.azure.com")
namespace Search;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Defines the Board result that matched a Board search request. */
model BoardResult {
  /** Board Type of the board document. */
  boardtype?: string;

  collection?: Collection;
  project?: Project;
  team?: Team;
}

/** Defines a Board search request. */
model BoardSearchRequest {
  ...EntitySearchRequest;
}

/** Defines a Board search response item. */
model BoardSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched Board documents. */
  count?: int32;

  /** List of top matched Board documents. */
  results?: BoardResult[];
}

/** Information about the configured branch. */
model BranchInfo {
  /** Name of the indexed branch */
  name?: string;
}

model Chunk {
  embedding?: Embedding;

  /** Hash of the chunk. */
  hash?: string;

  line_range?: Range;
  range?: Range;

  /** Text of the chunk */
  text?: string;
}

/** Defines the code result containing information of the searched files and its metadata. */
model CodeResult {
  collection?: Collection;

  /** ContentId of the result file. */
  contentId?: string;

  /** Name of the result file. */
  fileName?: string;

  /** Dictionary of field to hit offsets in the result file. Key identifies the area in which hits were found, for ex: file content/file name etc. */
  matches?: Record<Hit[]>;

  /** Path at which result file is present. */
  path?: string;

  project?: Project;
  repository?: Repository;

  /** Versions of the result file. */
  versions?: Version[];
}

/** Defines a code search request. */
model CodeSearchRequest {
  ...EntitySearchRequest;

  /** Flag to opt for including matched code snippet in the result. Default behavior is false. */
  includeSnippet?: boolean;
}

/** Defines a code search response item. */
model CodeSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched files. */
  count?: int32;

  /** List of matched files. */
  results?: CodeResult[];
}

/** Defines the details of the collection. */
model Collection {
  /** Name of the collection. */
  name?: string;
}

/** Defines the matched terms in the field of the commit result. */
model CommitHit {
  /** Reference name of the field highlighted. */
  fieldReferenceName?: string;

  /** Highlighted snippets of the field. */
  highlights?: string[];
}

/** Defines the commit result that matches the commit search request. */
model CommitResult {
  authorDate?: utcDateTime;
  authorEmail?: string;
  authorName?: string;
  branchName?: string;
  branchNameOriginal?: string;
  collectionId?: string;
  collectionName?: string;
  collectionNameOriginal?: string;
  commitDate?: utcDateTime;
  commitDescription?: string;
  commitId?: string;
  committerEmail?: string;
  committerName?: string;
  commitTitle?: string;

  /** Highlighted snippets of fields that match the search request. */
  hits?: CommitHit[];

  projectId?: string;
  projectName?: string;
  projectNameOriginal?: string;
  pushedBy?: string;
  pushedByEmail?: string;
  pushedDate?: utcDateTime;
  repositoryName?: string;
  repositoryNameOriginal?: string;
  respositoryId?: string;
}

/** Defines the commit search request. */
model CommitSearchRequest {
  ...EntitySearchRequest;
}

/** Defines commit search response. */
model CommitSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched commit items. */
  count?: int32;

  /** List of top matched commit items. */
  results?: CommitResult[];

  searchRequest?: CommitSearchRequest;
}

/** Represents a response for a commit search that includes an activity ID. */
model CommitSearchResponseWithActivityId {
  /** Gets or sets the activity ID associated with the response. */
  activityId?: string[];

  response?: CommitSearchResponse;
}

model CustomRepositoryBranchStatusResponse {
  lastIndexedChangeId?: int64;
  lastIndexedChangeIdChangeTime?: utcDateTime;
  latestChangeId?: int64;
  latestChangeIdChangeTime?: utcDateTime;
}

/** Defines the custom repository status. */
model CustomRepositoryStatusResponse {
  /** Repository Id. */
  @format("uuid") id?: string;

  /** List of indexed top level folders info. */
  indexedTopLevelFolders?: DepotInfo[];

  /** Repository Name. */
  name?: string;
}

/** Information about the custom repository indexing freshness for configured branches and depots. */
model DepotInfo {
  /** Name of the indexed top level folder (depot). */
  name?: string;
}

model Embedding {
  /** Array of floating-point values representing the embedding. */
  embedding?: float32[];
}

/** Base contract for search request types without scroll support. */
model EntitySearchRequest {
  ...EntitySearchRequestBase;

  /** Options for sorting search results. If set to null, the results will be returned sorted by relevance. If more than one sort option is provided, the results are sorted in the order specified in the OrderBy. */
  $orderBy?: SortOption[];

  /** Number of results to be skipped. */
  $skip?: int32;

  /** Number of results to be returned. */
  $top?: int32;

  /** Flag to opt for faceting in the result. Default behavior is false. */
  includeFacets?: boolean;
}

/** Base class for search request types. */
model EntitySearchRequestBase {
  /** Filters to be applied. Set it to null if there are no filters to be applied. */
  filters?: Record<string[]>;

  /** The search text. */
  searchText?: string;
}

/** Defines the base contract for search response. */
model EntitySearchResponse {
  /** A dictionary storing an array of <code>Filter</code> object against each facet. */
  facets?: Record<Filter[]>;

  /** Numeric code indicating any additional information: 0 - Ok, 1 - Account is being reindexed, 2 - Account indexing has not started, 3 - Invalid Request, 4 - Prefix wildcard query not supported, 5 - MultiWords with code facet not supported, 6 - Account is being onboarded, 7 - Account is being onboarded or reindexed, 8 - Top value trimmed to maxresult allowed 9 - Branches are being indexed, 10 - Faceting not enabled, 11 - Work items not accessible, 19 - Phrase queries with code type filters not supported, 20 - Wildcard queries with code type filters not supported. Any other info code is used for internal purpose. */
  infoCode?: int32;
}

/** Defines the details of a feed. */
model FeedInfo {
  /** Id of the collection. */
  collectionId?: string;

  /** Name of the collection. */
  collectionName?: string;

  /** Id of the feed. */
  feedId?: string;

  /** Name of the feed. */
  feedName?: string;

  /** Latest matched version of package in this Feed. */
  latestMatchedVersion?: string;

  /** Latest version of package in this Feed. */
  latestVersion?: string;

  /** Url of package in this Feed. */
  packageUrl?: string;

  /** List of views which contain the matched package. */
  views?: string[];
}

/** Describes a filter bucket item representing the total matches of search result, name and id. */
model Filter {
  /** Id of the filter bucket. */
  id?: string;

  /** Name of the filter bucket. */
  name?: string;

  /** Count of matches in the filter bucket. */
  resultCount?: int32;
}

/** Describes the position of a piece of text in a document. */
model Hit {
  /** Gets or sets the start character offset of a piece of text. */
  charOffset?: int32;

  /** Gets or sets an extract of code where the match appears. Usually it is the line where there is the match. */
  codeSnippet?: string;

  /** Gets or sets the column number where the match appears in the line. */
  column?: int32;

  /** Gets or sets the length of a piece of text. */
  length?: int32;

  /** Gets or sets the line number where the match appears in the file. */
  line?: int32;

  /** Gets or sets the name of type of a piece of text. */
  type?: string;
}

model Language {
  color?: string;
  id?: int32;
  name?: string;
}

model Location {
  /** Hex encoded commit SHA. */
  commit_sha?: string;

  language?: Language;

  /** File path in the repository. */
  path?: string;

  /** Refname. */
  ref_name?: string;

  repo?: RepositoryContext;
}

/** Defines the matched terms in the field of the package result. */
model PackageHit {
  /** Reference name of the highlighted field. */
  fieldReferenceName?: string;

  /** Matched/highlighted snippets of the field. */
  highlights?: string[];
}

/** Defines the package result that matched a package search request. */
model PackageResult {
  /** Description of the package. */
  description?: string;

  /** List of feeds which contain the matching package. */
  feeds?: FeedInfo[];

  /** List of highlighted fields for the match. */
  hits?: PackageHit[];

  /** Id of the package. */
  id?: string;

  /** Name of the package. */
  name?: string;

  /** Type of the package. */
  protocolType?: string;
}

/** Defines a package search request. */
model PackageSearchRequest {
  ...EntitySearchRequest;
}

model PackageSearchResponse {
  activityId?: string[];
  content?: PackageSearchResponseContent;
}

/** Defines a response item that is returned for a package search request. */
model PackageSearchResponseContent {
  ...EntitySearchResponse;

  /** Total number of matched packages. */
  count?: int32;

  /** List of matched packages. */
  results?: PackageResult[];
}

/** Defines the details of the project. */
model Project {
  /** Id of the project. */
  @format("uuid") id?: string;

  /** Name of the project. */
  name?: string;
}

/** Defines the details of the project. */
model ProjectReference {
  /** ID of the project. */
  @format("uuid") id?: string;

  /** Name of the project. */
  name?: string;

  /** Visibility of the project. */
  visibility?: string;
}

model Range {
  /** End of the range. */
  end?: int32;

  /** Start of the range. */
  start?: int32;
}

/** Defines the details of the repository. */
model Repository {
  /** Id of the repository. */
  id?: string;

  /** Name of the repository. */
  name?: string;

  /** Version control type of the result file. */
  @extension(
    "x-ms-enum",
    #{
      name: "VersionControlType",
      values: #[
        #{ value: "git", description: "" },
        #{ value: "tfvc", description: "" },
        #{ value: "custom", description: "For internal use." }
      ],
    }
  )
  type?: "git" | "tfvc" | "custom" | string;
}

model RepositoryContext {
  /** ID of the repository. */
  id?: int32;

  /** Namespace with owner, e.g. 'microsoft/copilot'. */
  nwo?: string;

  /** ID of the owner. */
  owner_id?: int32;

  /** URL of the repository. */
  url?: string;
}

/** Defines the repository status. */
model RepositoryStatusResponse {
  /** Repository Id. */
  @format("uuid") id?: string;

  /** List of Indexed branches info. */
  indexedBranches?: BranchInfo[];

  /** Repository Name. */
  name?: string;
}

/** Defines a scroll code search request. */
model ScrollSearchRequest {
  ...EntitySearchRequestBase;

  /** Scroll Id for scroll search query. */
  $scrollId?: string;

  /** Size of data to return for scroll search query. Min value is 201. */
  $scrollSize?: int32;
}

model SemanticSearchRequest {
  /** Set to true to include the embeddings in the response. */
  include_embeddings?: boolean;

  /** The maximum number of results to return. */
  limit?: int32;

  /** The semantic search query. This will be embedded and combined with the scoping query. */
  prompt?: string;

  /** Scoping Query */
  scoping_query?: string;
}

/** Defines the base contract for search response. */
model SemanticSearchResponse {
  /** The embeddings model used. */
  embedding_model?: string;

  /** The search results. */
  results?: SemanticSearchResult[];
}

model SemanticSearchResult {
  chunk?: Chunk;

  /** The cosine similarity of the result (as related to the request prompt). */
  distance?: float32;

  location?: Location;
}

model SemanticSearchStatusResponse {
  /** Indicates whether advanced semantic search is enabled or not. */
  advancedSemanticSearchEnabled?: boolean;

  /** Repository Id. */
  @format("uuid") id?: string;

  /** List of Indexed branches info. */
  indexedBranches?: BranchInfo[];

  /** Repository Name. */
  name?: string;

  /** Indicates whether semantic search is enabled or not. */
  semanticSearchEnabled?: boolean;
}

/** Defines the setting result that matched a setting search request */
model SettingResult {
  /** Description of the settings page */
  description?: string;

  /** Icon name of the settings page */
  icon?: string;

  /** Contribution url route id of the corresponding settings page */
  routeId?: string;

  /** Contribution url route parameter of the corresponding settings page */
  routeParameterMapping?: Record<string>;

  /** Scope of the settings page, either organization, project or user */
  @extension(
    "x-ms-enum",
    #{
      name: "SearchScope",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "organization", description: "" },
        #{ value: "project", description: "" },
        #{ value: "user", description: "" }
      ],
    }
  )
  scope?: "none" | "organization" | "project" | "user" | string;

  /** Title of the settings page */
  title?: string;
}

/** Defines a setting search request */
model SettingSearchRequest {
  ...EntitySearchRequest;
}

/** Defines a setting search response item */
model SettingSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched setting documents. */
  count?: int32;

  /** List of top matched setting documents. */
  results?: SettingResult[];
}

/** Defines how to sort the result. */
model SortOption {
  /** Field name on which sorting should be done. */
  field?: string;

  /** Order (ASC/DESC) in which the results should be sorted. */
  sortOrder?: string;
}

/** Lightweight file identifier sent from the frontend for the summarization endpoint. The backend uses collectionId + contentId to fetch content from the ES semantic search index. */
model SummarizeFileInfo {
  contentId?: string;
  documentType?: string;
  filePath?: string;
}

/** Defines the details of the team. */
model Team {
  /** Id of the team. */
  @format("uuid") id?: string;

  /** Name of the Team. */
  name?: string;
}

/** Defines the TFVC repository status. */
model TfvcRepositoryStatusResponse {
  /** Repository Id. */
  @format("uuid") id?: string;

  /** List of Indexing Information for TFVC repository */
  indexingInformation?: BranchInfo[];

  /** Repository Name. */
  name?: string;
}

model VectorResult {
  ...SemanticSearchResult;

  /** contentId of the file. */
  contentId?: string;

  /** Parsed fields from the chunk text (for work items). Key = field reference name (e.g., 'system.title'), Value = field value. Only populated for workitem entity type. */
  fields?: Record<string>;

  /** repoId of the repository. */
  projectId?: string;

  /** projectid of the repository project. */
  repoId?: string;
}

model VectorSearchRequest {
  ...EntitySearchRequest;

  /** Document Type - code, workitem, wiki etc. */
  documentType?: string;

  /** Note: This aligns with SemanticSearchRequest. Set to true to include the embeddings in the response. */
  include_embeddings?: boolean;

  /** Note: This aligns with SemanticSearchRequest. The maximum number of results to return. */
  limit?: int32;

  /** Note: This aligns with SemanticSearchRequest. The semantic search query. This will be embedded and combined with the scoping query. */
  prompt?: string;

  /** Note: This aligns with SemanticSearchRequest. Scoping Query */
  scoping_query?: string;

  /** Flag to determine whether summarization is needed or not. */
  shouldSummarize?: boolean;
}

model VectorSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched files. */
  count?: int32;

  /** Note: This aligns with SemanticSearchResponse. The embeddings model used. */
  embedding_model?: string;

  /** Note: This aligns with SemanticSearchResponse. The search results. */
  results?: VectorResult[];

  /** Result summarization. Chunk won't be populated when summarization is done. */
  summarization?: string;
}

/** Represents a response for a vector search that includes an activity ID. */
model VectorSearchResponseWithActivityId {
  /** Gets or sets the activity ID associated with the response. */
  activityId?: string[];

  response?: VectorSearchResponse;
}

/** Request contract for lazy-loaded summarization. Contains the user's query and file identifiers for fetching content from ES. */
model VectorSummarizeRequest {
  /** File identifiers from the vector search response. The backend uses these to fetch content from the ES semantic search index. */
  fileInfos?: SummarizeFileInfo[];

  /** The user's original search prompt. */
  prompt?: string;
}

/** Response contract for lazy-loaded summarization. */
model VectorSummarizeResponse {
  /** The LLM-generated summary of the search results. */
  summarization?: string;
}

/** Describes the details pertaining to a version of the result file. */
model Version {
  /** Name of the branch. */
  branchName?: string;

  /** ChangeId in the given branch associated with this match. */
  changeId?: string;
}

/** Defines the details of wiki. */
model Wiki {
  /** Id of the wiki. */
  id?: string;

  /** Mapped path for the wiki. */
  mappedPath?: string;

  /** Name of the wiki. */
  name?: string;

  /** Version for wiki. */
  version?: string;
}

/** Defines the matched terms in the field of the wiki result. */
model WikiHit {
  /** Reference name of the highlighted field. */
  fieldReferenceName?: string;

  /** Matched/highlighted snippets of the field. */
  highlights?: string[];
}

/** Defines the wiki result that matched a wiki search request. */
model WikiResult {
  collection?: Collection;

  /** ContentId of the result file. */
  contentId?: string;

  /** Name of the result file. */
  fileName?: string;

  /** Highlighted snippets of fields that match the search request. The list is sorted by relevance of the snippets. */
  hits?: WikiHit[];

  /** Path at which result file is present. */
  path?: string;

  project?: ProjectReference;
  wiki?: Wiki;
}

/** Defines a wiki search request. */
model WikiSearchRequest {
  ...EntitySearchRequest;
}

/** Defines a wiki search response item. */
model WikiSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched wiki documents. */
  count?: int32;

  /** List of top matched wiki documents. */
  results?: WikiResult[];
}

/** Defines the matched terms in the field of the work item result. */
model WorkItemHit {
  /** Reference name of the highlighted field. */
  fieldReferenceName?: string;

  /** Matched/highlighted snippets of the field. */
  highlights?: string[];
}

/** Defines the work item result that matched a work item search request. */
model WorkItemResult {
  /** A standard set of work item fields and their values. */
  fields?: Record<string>;

  /** Highlighted snippets of fields that match the search request. The list is sorted by relevance of the snippets. */
  hits?: WorkItemHit[];

  project?: Project;

  /** Reference to the work item. */
  url?: string;
}

/** Defines a work item search request. */
model WorkItemSearchRequest {
  ...EntitySearchRequest;
}

/** Defines a response item that is returned for a work item search request. */
model WorkItemSearchResponse {
  ...EntitySearchResponse;

  /** Total number of matched work items. */
  count?: int32;

  /** List of top matched work items. */
  results?: WorkItemResult[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface PackageSearchResults {
  /** Provides a set of results for the search text. */
  @tag("Package Search Results")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "packageSearchResults")
  @extension("x-ms-vss-method", "FetchPackageSearchResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/search/packagesearchresults")
  @post
  FetchPackageSearchResults(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The Package Search Request. */
    @body body: PackageSearchRequest,
  ): {
    @header ActivityId?: string;
    @body body: PackageSearchResponseContent;
  };
}

interface CodeSearchResults {
  /** Provides a set of results for the search text. */
  @tag("Code Search Results")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "codeSearchResults")
  @extension("x-ms-vss-method", "FetchCodeSearchResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/search/codesearchresults")
  @post
  FetchCodeSearchResults(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The Code Search Request. */
    @body body: CodeSearchRequest,
  ): CodeSearchResponse;
}

interface Repositories {
  /** Provides status of Repository. */
  @tag("Repositories")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "repositories")
  @extension("x-ms-vss-method", "GetRepositoryStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/search/status/repositories/{repository}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Repository ID or repository name. */
    @path repository: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): RepositoryStatusResponse;
}

interface Tfvc {
  /** Provides status of TFVC Repository. */
  @tag("Tfvc")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tfvc")
  @extension("x-ms-vss-method", "GetTfvcRepositoryStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/search/status/tfvc")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TfvcRepositoryStatusResponse;
}

interface WikiSearchResults {
  /** Provides a set of results for the search request. */
  @tag("Wiki Search Results")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "wikiSearchResults")
  @extension("x-ms-vss-method", "FetchWikiSearchResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/search/wikisearchresults")
  @post
  FetchWikiSearchResults(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The Wiki Search Request. */
    @body body: WikiSearchRequest,
  ): WikiSearchResponse;
}

interface WorkItemSearchResults {
  /** Provides a set of results for the search text. */
  @tag("Work Item Search Results")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "workItemSearchResults")
  @extension("x-ms-vss-method", "FetchWorkItemSearchResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/search/workitemsearchresults")
  @post
  FetchWorkItemSearchResults(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The Work Item Search Request. */
    @body body: WorkItemSearchRequest,
  ): WorkItemSearchResponse;
}
