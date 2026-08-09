import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Environments" })
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
namespace Environments;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model Demand {
  name?: string;
  value?: string;
}

/** Properties to create Environment. */
model EnvironmentCreateParameter {
  /** Description of the environment. */
  description?: string;

  /** Name of the environment. */
  name?: string;
}

/** EnvironmentDeploymentExecutionRecord. */
model EnvironmentDeploymentExecutionRecord {
  definition?: TaskOrchestrationOwner;

  /** Id of the Environment */
  environmentId?: int32;

  /** Finish time of the environment deployment execution */
  finishTime?: utcDateTime;

  /** Id of the Environment deployment execution history record */
  id?: int64;

  /** Job Attempt */
  jobAttempt?: int32;

  /** Job name */
  jobName?: string;

  owner?: TaskOrchestrationOwner;

  /** Plan Id */
  @format("uuid") planId?: string;

  /** Plan type of the environment deployment execution record */
  planType?: string;

  /** Queue time of the environment deployment execution */
  queueTime?: utcDateTime;

  /** Request identifier of the Environment deployment execution history record */
  requestIdentifier?: string;

  /** Resource Id */
  resourceId?: int32;

  /** Result of the environment deployment execution */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskResult",
      values: #[
        #{ value: "succeeded", description: "" },
        #{ value: "succeededWithIssues", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "skipped", description: "" },
        #{ value: "abandoned", description: "" },
        #{ value: "manuallyQueued", description: "" },
        #{ value: "dependentOnManualQueue", description: "" }
      ],
    }
  )
  result?:
    | "succeeded"
    | "succeededWithIssues"
    | "failed"
    | "canceled"
    | "skipped"
    | "abandoned"
    | "manuallyQueued"
    | "dependentOnManualQueue";

  /** Project Id */
  @format("uuid") scopeId?: string;

  /** Service owner Id */
  @format("uuid") serviceOwner?: string;

  /** Stage Attempt */
  stageAttempt?: int32;

  /** Stage name */
  stageName?: string;

  /** Start time of the environment deployment execution */
  startTime?: utcDateTime;
}

/** Environment. */
model EnvironmentInstance {
  createdBy?: IdentityRef;

  /** Creation time of the Environment */
  createdOn?: utcDateTime;

  /** Description of the Environment. */
  description?: string;

  /** Id of the Environment */
  id?: int32;

  lastModifiedBy?: IdentityRef;

  /** Last modified time of the Environment */
  lastModifiedOn?: utcDateTime;

  /** Name of the Environment. */
  name?: string;

  project?: ProjectReference;
  resources?: EnvironmentResourceReference[];
}

model EnvironmentReference {
  id?: int32;
  name?: string;
}

model EnvironmentResource {
  ...EnvironmentReference;
  createdBy?: IdentityRef;
  createdOn?: utcDateTime;
  environmentReference?: EnvironmentReference;
  lastModifiedBy?: IdentityRef;
  lastModifiedOn?: utcDateTime;

  /** Tags of the Environment Resource. */
  tags?: string[];

  /** Environment resource type */
  @extension(
    "x-ms-enum",
    #{
      name: "EnvironmentResourceType",
      values: #[
        #{ value: "undefined", description: "" },
        #{ value: "generic", description: "Unknown resource type" },
        #{ value: "virtualMachine", description: "Virtual machine resource type" },
        #{ value: "kubernetes", description: "Kubernetes resource type" }
      ],
    }
  )
  type?: "undefined" | "generic" | "virtualMachine" | "kubernetes";
}

/** EnvironmentResourceReference. */
model EnvironmentResourceReference {
  /** Id of the resource. */
  id?: int32;

  /** Name of the resource. */
  name?: string;

  /** Tags of the Environment Resource Reference. */
  tags?: string[];

  /** Type of the resource. */
  @extension(
    "x-ms-enum",
    #{
      name: "EnvironmentResourceType",
      values: #[
        #{ value: "undefined", description: "" },
        #{ value: "generic", description: "Unknown resource type" },
        #{ value: "virtualMachine", description: "Virtual machine resource type" },
        #{ value: "kubernetes", description: "Kubernetes resource type" }
      ],
    }
  )
  type?: "undefined" | "generic" | "virtualMachine" | "kubernetes";
}

/** Properties to update Environment. */
model EnvironmentUpdateParameter {
  /** Description of the environment. */
  description?: string;

  /** Name of the environment. */
  name?: string;
}

model GraphSubjectBase {
  _links?: ReferenceLinks;
  descriptor?: string;
  displayName?: string;
  url?: string;
}

model IdentityRef {
  ...GraphSubjectBase;
  directoryAlias?: string;
  id?: string;
  imageUrl?: string;
  inactive?: boolean;
  isAadIdentity?: boolean;
  isContainer?: boolean;
  isDeletedInOrigin?: boolean;
  profileUrl?: string;
  uniqueName?: string;
}

model KubernetesResource {
  ...EnvironmentResource;
  clusterName?: string;
  `namespace`?: string;
  @format("uuid") serviceEndpointId?: string;
}

model KubernetesResourceCreateParameters {
  clusterName?: string;
  name?: string;
  `namespace`?: string;

  /** Tags of the kubernetes resource. */
  tags?: string[];
}

model KubernetesResourceCreateParametersExistingEndpoint {
  ...KubernetesResourceCreateParameters;
  @format("uuid") serviceEndpointId?: string;
}

model KubernetesResourcePatchParameters {
  authorizationParameters?: Record<string>;

  /** Provider type (CustomProvider or AzureKubernetesServiceProvider) of the resource to be updated */
  providerType?: string;

  resourceId?: int32;
}

model PackageVersion {
  major?: int32;
  minor?: int32;
  patch?: int32;
}

model ProjectReference {
  @format("uuid") id?: string;
  name?: string;
}

model PropertiesCollection {
  count?: int32;
  item?: {};
  keys?: string[];
  values?: string[];
}

model ReferenceLinks {
  links?: Record<{}>;
}

/** A task agent. */
model TaskAgent {
  ...TaskAgentReference;
  assignedAgentCloudRequest?: TaskAgentCloudRequest;
  assignedRequest?: TaskAgentJobRequest;
  authorization?: TaskAgentAuthorization;

  /** Date on which this agent was created. */
  createdOn?: utcDateTime;

  lastCompletedRequest?: TaskAgentJobRequest;

  /** Maximum job parallelism allowed for this agent. */
  maxParallelism?: int32;

  pendingUpdate?: TaskAgentUpdate;
  properties?: PropertiesCollection;

  /** Date on which the last connectivity status change occurred. */
  statusChangedOn?: utcDateTime;

  /** System-defined capabilities supported by this agent's host. Warning: To set capabilities use the PUT method, PUT will completely overwrite existing capabilities. */
  systemCapabilities?: Record<string>;

  /** User-defined capabilities supported by this agent's host. Warning: To set capabilities use the PUT method, PUT will completely overwrite existing capabilities. */
  userCapabilities?: Record<string>;
}

/** Provides data necessary for authorizing the agent using OAuth 2.0 authentication flows. */
model TaskAgentAuthorization {
  /** Endpoint used to obtain access tokens from the configured token service. */
  authorizationUrl?: string;

  /** Client identifier for this agent. */
  @format("uuid") clientId?: string;

  publicKey?: TaskAgentPublicKey;
}

model TaskAgentCloudRequest {
  agent?: TaskAgentReference;
  agentCloudId?: int32;
  agentConnectedTime?: utcDateTime;
  @format("JObject") agentData?: string;
  @format("JObject") agentSpecification?: string;
  pool?: TaskAgentPoolReference;
  poolProvidersTags?: Record<string>;
  provisionedTime?: utcDateTime;
  provisionRequestTime?: utcDateTime;
  releaseRequestTime?: utcDateTime;
  @format("uuid") requestId?: string;
  requestVersion?: int32;
}

/** A job request for an agent. */
model TaskAgentJobRequest {
  ...TaskAgentJobRequestRef;
  @format("JObject") agentSpecification?: string;

  /** Additional data about the request. */
  data?: Record<string>;

  definition?: TaskOrchestrationOwner;

  /** A list of demands required to fulfill this request. */
  demands?: Demand[];

  /** The host which triggered this request. */
  @format("uuid") hostId?: string;

  /** ID of the job resulting from this request. */
  @format("uuid") jobId?: string;

  /** Name of the job resulting from this request. */
  jobName?: string;

  /** The deadline for the agent to renew the lock. */
  lockedUntil?: utcDateTime;

  matchedAgents?: TaskAgentReference[];
  matchesAllAgentsInPool?: boolean;
  owner?: TaskOrchestrationOwner;
  planGroup?: string;

  /** Internal ID for the orchestration plan connected with this request. */
  @format("uuid") planId?: string;

  /** Internal detail representing the type of orchestration plan. */
  planType?: string;

  /** The ID of the pool this request targets */
  poolId?: int32;

  priority?: int32;

  /** The ID of the queue this request targets */
  queueId?: int32;

  reservedAgent?: TaskAgentReference;

  /** The result of this request. */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskResult",
      values: #[
        #{ value: "succeeded", description: "" },
        #{ value: "succeededWithIssues", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "skipped", description: "" },
        #{ value: "abandoned", description: "" },
        #{ value: "manuallyQueued", description: "" },
        #{ value: "dependentOnManualQueue", description: "" }
      ],
    }
  )
  result?:
    | "succeeded"
    | "succeededWithIssues"
    | "failed"
    | "canceled"
    | "skipped"
    | "abandoned"
    | "manuallyQueued"
    | "dependentOnManualQueue";

  /** Scope of the pipeline; matches the project ID. */
  @format("uuid") scopeId?: string;

  /** The service which owns this request. */
  @format("uuid") serviceOwner?: string;

  statusMessage?: string;
  userDelayed?: boolean;
}

model TaskAgentJobRequestRef {
  /** The date/time this request was assigned. */
  assignTime?: utcDateTime;

  /** The date/time this request was finished. */
  finishTime?: utcDateTime;

  orchestrationId?: string;

  /** The date/time this request was queued. */
  queueTime?: utcDateTime;

  /** The date/time this request was receieved by an agent. */
  receiveTime?: utcDateTime;

  /** ID of the request. */
  requestId?: int64;
}

model TaskAgentPoolReference {
  id?: int32;

  /** Gets or sets a value indicating whether or not this pool is managed by the service. */
  isHosted?: boolean;

  /** Determines whether the pool is legacy. */
  isLegacy?: boolean;

  name?: string;

  /** Additional pool settings and details */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolOptions",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "elasticPool", description: "TaskAgentPool backed by the Elastic pool service" },
        #{
          value: "singleUseAgents",
          description: "Set to true if agents are re-imaged after each TaskAgentJobRequest",
        },
        #{
          value: "preserveAgentOnJobFailure",
          description: "Set to true if agents are held for investigation after a TaskAgentJobRequest failure",
        }
      ],
    }
  )
  options?: "none" | "elasticPool" | "singleUseAgents" | "preserveAgentOnJobFailure";

  /** Gets or sets the type of the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolType",
      values: #[
        #{ value: "automation", description: "A typical pool of task agents" },
        #{ value: "deployment", description: "A deployment pool" }
      ],
    }
  )
  poolType?: "automation" | "deployment";

  @format("uuid") scope?: string;

  /** Gets the current size of the pool. */
  size?: int32;
}

/** Represents the public key portion of an RSA asymmetric key. */
model TaskAgentPublicKey {
  /** Gets or sets the exponent for the public key. */
  exponent?: bytes[];

  /** Gets or sets the modulus for the public key. */
  modulus?: bytes[];
}

/** A reference to an agent. */
model TaskAgentReference {
  _links?: ReferenceLinks;

  /** This agent's access point. */
  accessPoint?: string;

  /** Whether or not this agent should run jobs. */
  enabled?: boolean;

  /** Identifier of the agent. */
  id?: int32;

  /** Name of the agent. */
  name?: string;

  /** Agent OS. */
  osDescription?: string;

  /** Provisioning state of this agent. */
  provisioningState?: string;

  /** Whether or not the agent is online. */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentStatus",
      values: #[#{ value: "offline", description: "" }, #{ value: "online", description: "" }],
    }
  )
  status?: "offline" | "online";

  /** Agent version. */
  version?: string;
}

/** Details about an agent update. */
model TaskAgentUpdate {
  /** Current state of this agent update. */
  currentState?: string;

  reason?: TaskAgentUpdateReason;
  requestedBy?: IdentityRef;

  /** Date on which this update was requested. */
  requestTime?: utcDateTime;

  sourceVersion?: PackageVersion;
  targetVersion?: PackageVersion;
}

model TaskAgentUpdateReason {
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentUpdateReasonType",
      values: #[
        #{ value: "manual", description: "" },
        #{ value: "minAgentVersionRequired", description: "" },
        #{ value: "downgrade", description: "" }
      ],
    }
  )
  code?: "manual" | "minAgentVersionRequired" | "downgrade";
}

model TaskOrchestrationOwner {
  _links?: ReferenceLinks;
  id?: int32;
  name?: string;
}

model VirtualMachine {
  agent?: TaskAgent;
  id?: int32;
  tags?: string[];
}

model VirtualMachineGroup {
  ...EnvironmentResource;
  poolId?: int32;
}

model VirtualMachineGroupCreateParameters {
  name?: string;
}

model VirtualMachineResource {
  ...EnvironmentResource;
  agent?: TaskAgent;
}

model VirtualMachineResourceCreateParameters {
  virtualMachineResource?: VirtualMachineResource;
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
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Environments {
  /** Get all environments. */
  @tag("Environments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "GetEnvironments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) name?: string,
    @query(#{ explode: true }) continuationToken?: string,
    @query(#{ explode: true }) $top?: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<EnvironmentInstance[]>;

  /** Create an environment. */
  @tag("Environments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "AddEnvironment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Environment to create. */
    @body body: EnvironmentCreateParameter,
  ): EnvironmentInstance;

  /** Delete the specified environment. */
  @tag("Environments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "DeleteEnvironment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the environment. */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get an environment by its ID. */
  @tag("Environments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "GetEnvironmentById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the environment. */
    @path environmentId: int32,

    /** Include these additional details in the returned objects. */
    @extension(
      "x-ms-enum",
      #{
        name: "EnvironmentExpands",
        values: #[
          #{ value: "none", description: "No additional properties" },
          #{
            value: "resourceReferences",
            description: "Include resource references referring to the environment.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    expands?: "none" | "resourceReferences",

    ...Parameters.`api-Version-preview`.`1`,
  ): EnvironmentInstance;

  /** Update the specified environment. */
  @tag("Environments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "UpdateEnvironment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the environment. */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Environment data to update. */
    @body body: EnvironmentUpdateParameter,
  ): EnvironmentInstance;
}

interface Environmentdeploymentrecords {
  /** Get environment deployment execution history */
  @tag("Environmentdeploymentrecords")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environmentdeploymentrecords")
  @extension("x-ms-vss-method", "GetEnvironmentDeploymentExecutionRecords")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/environmentdeploymentrecords")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path environmentId: int32,
    @query(#{ explode: true }) continuationToken?: string,
    @query(#{ explode: true }) top?: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<EnvironmentDeploymentExecutionRecord[]>;
}

interface Kubernetes {
  @tag("Kubernetes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "kubernetes")
  @extension("x-ms-vss-method", "UpdateKubernetesResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/kubernetes")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path environmentId: int32,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: KubernetesResourcePatchParameters,
  ): KubernetesResource;

  @tag("Kubernetes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "kubernetes")
  @extension("x-ms-vss-method", "AddKubernetesResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/kubernetes")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path environmentId: int32,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: KubernetesResourceCreateParametersExistingEndpoint,
  ): KubernetesResource;

  @tag("Kubernetes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "kubernetes")
  @extension("x-ms-vss-method", "DeleteKubernetesResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/kubernetes/{resourceId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path environmentId: int32,
    @path resourceId: int32,
    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  @tag("Kubernetes")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "kubernetes")
  @extension("x-ms-vss-method", "GetKubernetesResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/kubernetes/{resourceId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path environmentId: int32,
    @path resourceId: int32,
    ...Parameters.`api-Version-preview`.`2`,
  ): KubernetesResource;
}

interface Vmresource {
  /** Get Virtual Machine Resources */
  @tag("Vmresource")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "vmresource")
  @extension("x-ms-vss-method", "GetVirtualMachineResources")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/virtualmachines")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the Environment */
    @path environmentId: int32,

    /** Name of the Virtual Machine Resource */
    @query(#{ explode: true }) name?: string,

    /** Tags of the Virtual Machine Resource */
    @format("array (string)") @query(#{ explode: true }) tags?: string,

    /** Gets the Virtual Machine Resources after the continuation token provided. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Number of Virtual Machine Resources to get. Default is 1000. */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<VirtualMachineResource[]>;

  /** Update Virtual Machine Resource */
  @tag("Vmresource")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "vmresource")
  @extension("x-ms-vss-method", "UpdateVirtualMachineResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/virtualmachines")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the Environment */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Properties to update Virtual Machine Resource */
    @body body: VirtualMachineResource,
  ): VirtualMachineResource;

  /** Add Virtual Machine Resource */
  @tag("Vmresource")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "vmresource")
  @extension("x-ms-vss-method", "AddVirtualMachineResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/virtualmachines")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the Environment */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Properties to create Virtual Machine Resource */
    @body body: VirtualMachineResourceCreateParameters,
  ): VirtualMachineResource;

  /** Replace Virtual Machine Resource */
  @tag("Vmresource")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "vmresource")
  @extension("x-ms-vss-method", "ReplaceVirtualMachineResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/virtualmachines")
  @put
  ReplaceVirtualMachineResource(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the Environment */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Properties to replace Virtual Machine Resource */
    @body body: VirtualMachineResource,
  ): VirtualMachineResource;

  /** Delete Virtual Machine Resource */
  @tag("Vmresource")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "vmresource")
  @extension("x-ms-vss-method", "DeleteVirtualMachineResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/virtualmachines/{resourceId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the Environment */
    @path environmentId: int32,

    /** Id of the Virtual Machine Resource */
    @path resourceId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface Pool {
  @tag("Pool")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pool")
  @extension("x-ms-vss-method", "GetLinkedPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/{environmentId}/providers/virtualmachines/pool")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path environmentId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentPoolReference;
}

interface Environmentaccesstoken {
  /** GET a PAT token for creating and deleting deployment targets in an environment. */
  @tag("Environmentaccesstoken")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "environmentaccesstoken")
  @extension("x-ms-vss-method", "GenerateEnvironmentAccessToken")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/environments/environmentaccesstoken/{environmentId}")
  @post
  GenerateEnvironmentAccessToken(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the environment in which deployment targets are managed. */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<string>;
}
