import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Pipelines" })
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
namespace Pipelines;

/** Artifacts are collections of files produced by a pipeline. Use artifacts to share files between stages in a pipeline or between different pipelines. */
model Artifact {
  /** The name of the artifact. */
  name?: string;

  signedContent?: SignedUrl;

  /** Self-referential url */
  url?: string;
}

model Build {
  artifactSourceVersionUrl?: string;
  type?: string;
  versionId?: string;
  versionName?: string;
}

model BuildResourceParameters {
  version?: string;
}

model Container {
  environment?: Record<string>;
  image?: string;
  mapDockerSocket?: boolean;
  options?: string;
  ports?: string[];
  volumes?: string[];
}

model ContainerResource {
  container?: Container;
}

model ContainerResourceParameters {
  version?: string;
}

/** Configuration parameters of the pipeline. */
model CreatePipelineConfigurationParameters {
  /** Type of configuration. */
  @extension(
    "x-ms-enum",
    #{
      name: "ConfigurationType",
      values: #[
        #{ value: "unknown", description: "Unknown type." },
        #{ value: "yaml", description: "YAML." },
        #{ value: "designerJson", description: "Designer JSON." },
        #{ value: "justInTime", description: "Just-in-time." },
        #{ value: "designerHyphenJson", description: "Designer-JSON." }
      ],
    }
  )
  type?: "unknown" | "yaml" | "designerJson" | "justInTime" | "designerHyphenJson";
}

/** Parameters to create a pipeline. */
model CreatePipelineParameters {
  configuration?: CreatePipelineConfigurationParameters;

  /** Folder of the pipeline. */
  folder?: string;

  /** Name of the pipeline. */
  name?: string;
}

/** Log for a pipeline. */
model Log {
  /** The date and time the log was created. */
  createdOn?: utcDateTime;

  /** The ID of the log. */
  id?: int32;

  /** The date and time the log was last changed. */
  lastChangedOn?: utcDateTime;

  /** The number of lines in the log. */
  lineCount?: int64;

  signedContent?: SignedUrl;
  url?: string;
}

/** A collection of logs. */
model LogCollection {
  /** The list of logs. */
  logs?: Log[];

  signedContent?: SignedUrl;

  /** URL of the log. */
  url?: string;
}

model PackageResourceParameters {
  version?: string;
}

/** Definition of a pipeline. */
model Pipeline {
  ...PipelineBase;
  _links?: ReferenceLinks;
  configuration?: PipelineConfiguration;

  /** URL of the pipeline */
  url?: string;
}

model PipelineBase {
  /** Pipeline folder */
  folder?: string;

  /** Pipeline ID */
  id?: int32;

  /** Pipeline name */
  name?: string;

  /** Revision number */
  revision?: int32;
}

model PipelineConfiguration {
  @extension(
    "x-ms-enum",
    #{
      name: "ConfigurationType",
      values: #[
        #{ value: "unknown", description: "Unknown type." },
        #{ value: "yaml", description: "YAML." },
        #{ value: "designerJson", description: "Designer JSON." },
        #{ value: "justInTime", description: "Just-in-time." },
        #{ value: "designerHyphenJson", description: "Designer-JSON." }
      ],
    }
  )
  type?: "unknown" | "yaml" | "designerJson" | "justInTime" | "designerHyphenJson";
}

/** A reference to a Pipeline. */
model PipelineReference {
  ...PipelineBase;
  url?: string;
}

model PipelineResource {
  pipeline?: PipelineReference;
  version?: string;
}

model PipelineResourceParameters {
  runId?: int32;
  version?: string;
}

model PreviewRun {
  finalYaml?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model Repository {
  @extension(
    "x-ms-enum",
    #{
      name: "RepositoryType",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "gitHub", description: "" },
        #{ value: "azureReposGit", description: "" },
        #{ value: "gitHubEnterprise", description: "" },
        #{ value: "bitBucket", description: "" },
        #{ value: "azureReposGitHyphenated", description: "" }
      ],
    }
  )
  type?:
    | "unknown"
    | "gitHub"
    | "azureReposGit"
    | "gitHubEnterprise"
    | "bitBucket"
    | "azureReposGitHyphenated";
}

model RepositoryResource {
  refName?: string;
  repository?: Repository;
  version?: string;
}

model RepositoryResourceParameters {
  refName?: string;

  /** This is the security token to use when connecting to the repository. */
  token?: string;

  /** Optional. This is the type of the token given. If not provided, a type of 'Bearer' is assumed. Note: Use 'Basic' for a PAT token. */
  tokenType?: string;

  version?: string;
}

model Run {
  ...RunReference;
  _links?: ReferenceLinks;
  createdDate?: utcDateTime;
  finalYaml?: string;
  finishedDate?: utcDateTime;
  pipeline?: PipelineReference;
  resources?: RunResources;
  @extension(
    "x-ms-enum",
    #{
      name: "RunResult",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "succeeded", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "canceled", description: "" }
      ],
    }
  )
  result?: "unknown" | "succeeded" | "failed" | "canceled";
  @extension(
    "x-ms-enum",
    #{
      name: "RunState",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "inProgress", description: "" },
        #{ value: "canceling", description: "" },
        #{ value: "completed", description: "" }
      ],
    }
  )
  state?: "unknown" | "inProgress" | "canceling" | "completed";
  tags?: string[];
  templateParameters?: Record<{}>;
  url?: string;
  variables?: Record<Variable>;
  yamlDetails?: RunYamlDetails;
}

/** Settings which influence pipeline runs. */
model RunPipelineParameters {
  /** If true, don't actually create a new run. Instead, return the final YAML document after parsing templates. */
  previewRun?: boolean;

  resources?: RunResourcesParameters;
  stagesToSkip?: string[];
  templateParameters?: Record<string>;
  variables?: Record<Variable>;

  /** If you use the preview run option, you may optionally supply different YAML. This allows you to preview the final YAML document without committing a changed file. */
  yamlOverride?: string;
}

model RunReference {
  id?: int32;
  name?: string;
}

model RunResources {
  builds?: Record<Build>;
  containers?: Record<ContainerResource>;
  pipelines?: Record<PipelineResource>;
  repositories?: Record<RepositoryResource>;
}

model RunResourcesParameters {
  builds?: Record<BuildResourceParameters>;
  containers?: Record<ContainerResourceParameters>;
  packages?: Record<PackageResourceParameters>;
  pipelines?: Record<PipelineResourceParameters>;
  repositories?: Record<RepositoryResourceParameters>;
}

model RunYamlDetails {
  expandedYamlUrl?: string;
  extendedTemplates?: YamlFileDetails[];
  includedTemplates?: YamlFileDetails[];
  rootYamlFile?: YamlFileDetails;
}

model SignalRConnection {
  signedContent?: SignedUrl;
}

/** A signed url allowing limited-time anonymous access to private resources. */
model SignedUrl {
  /** Timestamp when access expires. */
  signatureExpires?: utcDateTime;

  /** The URL to allow access to. */
  url?: string;
}

model Variable {
  isSecret?: boolean;
  value?: string;
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

model YamlFileDetails {
  ref?: string;
  repoAlias?: string;
  yamlFile?: string;
}

/** Get a list of pipelines. */
@tag("Pipelines")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pipelines")
@extension("x-ms-vss-method", "ListPipelines")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines")
@get
op Pipelines_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** A sort expression. Defaults to 'name asc' */
  @query(#{ explode: true }) orderBy?: string,

  /** The maximum number of pipelines to return */
  @query(#{ explode: true }) $top?: int32,

  /** A continuation token from a previous request, to retrieve the next page of results */
  @query(#{ explode: true }) continuationToken?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<Pipeline[]>;

/** Create a pipeline. */
@tag("Pipelines")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pipelines")
@extension("x-ms-vss-method", "CreatePipeline")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines")
@post
op Pipelines_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Input parameters. */
  @body body: CreatePipelineParameters,
): Pipeline;

/** Gets a pipeline, optionally at the specified version */
@tag("Pipelines")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pipelines")
@extension("x-ms-vss-method", "GetPipeline")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}")
@get
op Pipelines_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The pipeline ID */
  @path pipelineId: int32,

  /** The pipeline version */
  @query(#{ explode: true }) pipelineVersion?: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Pipeline;

/** Queues a dry run of the pipeline and returns an object containing the final yaml. */
@tag("Preview")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "preview")
@extension("x-ms-vss-method", "Preview")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/preview")
@post
op Preview_Preview(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The pipeline ID. */
  @path pipelineId: int32,

  /** The pipeline version. */
  @query(#{ explode: true }) pipelineVersion?: int32,

  ...Parameters.`api-Version-preview`.`1`,

  /** Optional additional parameters for this run. */
  @body body: RunPipelineParameters,
): PreviewRun;

/** Gets top 10000 runs for a particular pipeline. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "ListRuns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/runs")
@get
op Runs_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The pipeline id */
  @path pipelineId: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Body<Run[]>;

/** Runs a pipeline. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "RunPipeline")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/runs")
@post
op Runs_RunPipeline(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The pipeline ID. */
  @path pipelineId: int32,

  /** The pipeline version. */
  @query(#{ explode: true }) pipelineVersion?: int32,

  ...Parameters.`api-Version-preview`.`1`,

  /** Optional additional parameters for this run. */
  @body body: RunPipelineParameters,
): Run;

/** Gets a run for a particular pipeline. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "GetRun")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/runs/{runId}")
@get
op Runs_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The pipeline id */
  @path pipelineId: int32,

  /** The run id */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Run;

/** Get a specific artifact from a pipeline run */
@tag("Artifacts")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "artifacts")
@extension("x-ms-vss-method", "GetArtifact")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/runs/{runId}/artifacts")
@get
op Artifacts_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the pipeline. */
  @path pipelineId: int32,

  /** ID of the run of that pipeline. */
  @path runId: int32,

  /** Name of the artifact. */
  @query(#{ explode: true }) artifactName: string,

  /** Expand options. Default is None. */
  @extension(
    "x-ms-enum",
    #{
      name: "GetArtifactExpandOptions",
      values: #[
        #{ value: "none", description: "No expansion." },
        #{ value: "signedContent", description: "Include signed content." }
      ],
    }
  )
  @query(#{ explode: true })
  $expand?: "none" | "signedContent",

  ...Parameters.`api-Version-preview`.`1`,
): Artifact;

/** Get a list of logs from a pipeline run. */
@tag("Logs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "logs")
@extension("x-ms-vss-method", "ListLogs")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/runs/{runId}/logs")
@get
op Logs_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the pipeline. */
  @path pipelineId: int32,

  /** ID of the run of that pipeline. */
  @path runId: int32,

  /** Expand options. Default is None. */
  @extension(
    "x-ms-enum",
    #{
      name: "GetLogExpandOptions",
      values: #[#{ value: "none", description: "" }, #{ value: "signedContent", description: "" }],
    }
  )
  @query(#{ explode: true })
  $expand?: "none" | "signedContent",

  ...Parameters.`api-Version-preview`.`1`,
): LogCollection;

/** Get a specific log from a pipeline run */
@tag("Logs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "logs")
@extension("x-ms-vss-method", "GetLog")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/{pipelineId}/runs/{runId}/logs/{logId}")
@get
op Logs_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the pipeline. */
  @path pipelineId: int32,

  /** ID of the run of that pipeline. */
  @path runId: int32,

  /** ID of the log. */
  @path logId: int32,

  /** Expand options. Default is None. */
  @extension(
    "x-ms-enum",
    #{
      name: "GetLogExpandOptions",
      values: #[#{ value: "none", description: "" }, #{ value: "signedContent", description: "" }],
    }
  )
  @query(#{ explode: true })
  $expand?: "none" | "signedContent",

  ...Parameters.`api-Version-preview`.`1`,
): Log;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
