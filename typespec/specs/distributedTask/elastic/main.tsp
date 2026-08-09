import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Elastic" })
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
namespace Elastic;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Data and settings for an elastic node */
model ElasticNode {
  /** Distributed Task's Agent Id */
  agentId?: int32;

  /** Summary of the state of the agent */
  @extension(
    "x-ms-enum",
    #{
      name: "ElasticAgentState",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "enabled", description: "" },
        #{ value: "online", description: "" },
        #{ value: "assigned", description: "" }
      ],
    }
  )
  agentState?: "none" | "enabled" | "online" | "assigned";

  /** Compute Id. VMSS's InstanceId */
  computeId?: string;

  /** State of the compute host */
  @extension(
    "x-ms-enum",
    #{
      name: "ElasticComputeState",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "healthy", description: "" },
        #{ value: "creating", description: "" },
        #{ value: "deleting", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "stopped", description: "" },
        #{ value: "reimaging", description: "" },
        #{ value: "unhealthyVm", description: "" },
        #{ value: "unhealthyVmssVm", description: "" }
      ],
    }
  )
  computeState?:
    | "none"
    | "healthy"
    | "creating"
    | "deleting"
    | "failed"
    | "stopped"
    | "reimaging"
    | "unhealthyVm"
    | "unhealthyVmssVm";

  /** Users can force state changes to specific states (ToReimage, ToDelete, Save) */
  @extension(
    "x-ms-enum",
    #{
      name: "ElasticNodeState",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "new", description: "" },
        #{ value: "creatingCompute", description: "" },
        #{ value: "startingAgent", description: "" },
        #{ value: "idle", description: "" },
        #{ value: "assigned", description: "" },
        #{ value: "offline", description: "" },
        #{ value: "pendingReimage", description: "" },
        #{ value: "pendingDelete", description: "" },
        #{ value: "saved", description: "" },
        #{ value: "deletingCompute", description: "" },
        #{ value: "deleted", description: "" },
        #{ value: "lost", description: "" },
        #{ value: "reimagingCompute", description: "" },
        #{ value: "restartingAgent", description: "" },
        #{ value: "failedToStartPendingDelete", description: "" },
        #{ value: "failedToRestartPendingDelete", description: "" },
        #{ value: "failedVMPendingDelete", description: "" },
        #{ value: "assignedPendingDelete", description: "" },
        #{ value: "retryDelete", description: "" },
        #{ value: "unhealthyVm", description: "" },
        #{ value: "unhealthyVmPendingDelete", description: "" },
        #{ value: "pendingReimageCandidate", description: "" }
      ],
    }
  )
  desiredState?:
    | "none"
    | "new"
    | "creatingCompute"
    | "startingAgent"
    | "idle"
    | "assigned"
    | "offline"
    | "pendingReimage"
    | "pendingDelete"
    | "saved"
    | "deletingCompute"
    | "deleted"
    | "lost"
    | "reimagingCompute"
    | "restartingAgent"
    | "failedToStartPendingDelete"
    | "failedToRestartPendingDelete"
    | "failedVMPendingDelete"
    | "assignedPendingDelete"
    | "retryDelete"
    | "unhealthyVm"
    | "unhealthyVmPendingDelete"
    | "pendingReimageCandidate";

  /** Unique identifier since the agent and/or VM may be null */
  id?: int32;

  /** Computer name. Used to match a scaleset VM with an agent */
  name?: string;

  /** Pool Id that this node belongs to */
  poolId?: int32;

  /** Last job RequestId assigned to this agent */
  requestId?: int64;

  /** State of the ElasticNode */
  @extension(
    "x-ms-enum",
    #{
      name: "ElasticNodeState",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "new", description: "" },
        #{ value: "creatingCompute", description: "" },
        #{ value: "startingAgent", description: "" },
        #{ value: "idle", description: "" },
        #{ value: "assigned", description: "" },
        #{ value: "offline", description: "" },
        #{ value: "pendingReimage", description: "" },
        #{ value: "pendingDelete", description: "" },
        #{ value: "saved", description: "" },
        #{ value: "deletingCompute", description: "" },
        #{ value: "deleted", description: "" },
        #{ value: "lost", description: "" },
        #{ value: "reimagingCompute", description: "" },
        #{ value: "restartingAgent", description: "" },
        #{ value: "failedToStartPendingDelete", description: "" },
        #{ value: "failedToRestartPendingDelete", description: "" },
        #{ value: "failedVMPendingDelete", description: "" },
        #{ value: "assignedPendingDelete", description: "" },
        #{ value: "retryDelete", description: "" },
        #{ value: "unhealthyVm", description: "" },
        #{ value: "unhealthyVmPendingDelete", description: "" },
        #{ value: "pendingReimageCandidate", description: "" }
      ],
    }
  )
  state?:
    | "none"
    | "new"
    | "creatingCompute"
    | "startingAgent"
    | "idle"
    | "assigned"
    | "offline"
    | "pendingReimage"
    | "pendingDelete"
    | "saved"
    | "deletingCompute"
    | "deleted"
    | "lost"
    | "reimagingCompute"
    | "restartingAgent"
    | "failedToStartPendingDelete"
    | "failedToRestartPendingDelete"
    | "failedVMPendingDelete"
    | "assignedPendingDelete"
    | "retryDelete"
    | "unhealthyVm"
    | "unhealthyVmPendingDelete"
    | "pendingReimageCandidate";

  /** Last state change. Only updated by SQL. */
  stateChangedOn?: utcDateTime;
}

/** Class used for updating an elastic node where only certain members are populated */
model ElasticNodeSettings {
  /** State of the ElasticNode */
  @extension(
    "x-ms-enum",
    #{
      name: "ElasticNodeState",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "new", description: "" },
        #{ value: "creatingCompute", description: "" },
        #{ value: "startingAgent", description: "" },
        #{ value: "idle", description: "" },
        #{ value: "assigned", description: "" },
        #{ value: "offline", description: "" },
        #{ value: "pendingReimage", description: "" },
        #{ value: "pendingDelete", description: "" },
        #{ value: "saved", description: "" },
        #{ value: "deletingCompute", description: "" },
        #{ value: "deleted", description: "" },
        #{ value: "lost", description: "" },
        #{ value: "reimagingCompute", description: "" },
        #{ value: "restartingAgent", description: "" },
        #{ value: "failedToStartPendingDelete", description: "" },
        #{ value: "failedToRestartPendingDelete", description: "" },
        #{ value: "failedVMPendingDelete", description: "" },
        #{ value: "assignedPendingDelete", description: "" },
        #{ value: "retryDelete", description: "" },
        #{ value: "unhealthyVm", description: "" },
        #{ value: "unhealthyVmPendingDelete", description: "" },
        #{ value: "pendingReimageCandidate", description: "" }
      ],
    }
  )
  state?:
    | "none"
    | "new"
    | "creatingCompute"
    | "startingAgent"
    | "idle"
    | "assigned"
    | "offline"
    | "pendingReimage"
    | "pendingDelete"
    | "saved"
    | "deletingCompute"
    | "deleted"
    | "lost"
    | "reimagingCompute"
    | "restartingAgent"
    | "failedToStartPendingDelete"
    | "failedToRestartPendingDelete"
    | "failedVMPendingDelete"
    | "assignedPendingDelete"
    | "retryDelete"
    | "unhealthyVm"
    | "unhealthyVmPendingDelete"
    | "pendingReimageCandidate";
}

/** Data and settings for an elastic pool */
model ElasticPool {
  /** Set whether agents should be configured to run with interactive UI */
  agentInteractiveUI?: boolean;

  /** Azure string representing to location of the resource */
  azureId?: string;

  /** Number of agents to have ready waiting for jobs */
  desiredIdle?: int32;

  /** The desired size of the pool */
  desiredSize?: int32;

  /** Maximum number of nodes that will exist in the elastic pool */
  maxCapacity?: int32;

  /** Keep nodes in the pool on failure for investigation */
  maxSavedNodeCount?: int32;

  /** Timestamp the pool was first detected to be offline */
  offlineSince?: utcDateTime;

  /** Operating system type of the nodes in the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "OrchestrationType",
      values: #[#{ value: "uniform", description: "" }, #{ value: "flexible", description: "" }],
    }
  )
  orchestrationType?: "uniform" | "flexible";

  /** Operating system type of the nodes in the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "OperatingSystemType",
      values: #[#{ value: "windows", description: "" }, #{ value: "linux", description: "" }],
    }
  )
  osType?: "windows" | "linux";

  /** Id of the associated TaskAgentPool */
  poolId?: int32;

  /** Discard node after each job completes */
  recycleAfterEachUse?: boolean;

  /** Id of the Service Endpoint used to connect to Azure */
  @format("uuid") serviceEndpointId?: string;

  /** Scope the Service Endpoint belongs to */
  @format("uuid") serviceEndpointScope?: string;

  /** The number of sizing attempts executed while trying to achieve a desired size */
  sizingAttempts?: int32;

  /** State of the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "ElasticPoolState",
      values: #[
        #{ value: "online", description: "Online and healthy" },
        #{ value: "offline", description: "" },
        #{ value: "unhealthy", description: "" },
        #{ value: "new", description: "" }
      ],
    }
  )
  state?: "online" | "offline" | "unhealthy" | "new";

  /** The minimum time in minutes to keep idle agents alive */
  timeToLiveMinutes?: int32;
}

/** Returned result from creating a new elastic pool */
model ElasticPoolCreationResult {
  agentPool?: TaskAgentPool;
  agentQueue?: TaskAgentQueue;
  elasticPool?: ElasticPool;
}

/** Log data for an Elastic Pool */
model ElasticPoolLog {
  /** Log Id */
  id?: int64;

  /** E.g. error, warning, info */
  @extension(
    "x-ms-enum",
    #{
      name: "LogLevel",
      values: #[
        #{ value: "error", description: "" },
        #{ value: "warning", description: "" },
        #{ value: "info", description: "" }
      ],
    }
  )
  level?: "error" | "warning" | "info";

  /** Log contents */
  message?: string;

  /** Operation that triggered the message being logged */
  @extension(
    "x-ms-enum",
    #{
      name: "OperationType",
      values: #[
        #{ value: "configurationJob", description: "" },
        #{ value: "sizingJob", description: "" },
        #{ value: "increaseCapacity", description: "" },
        #{ value: "reimage", description: "" },
        #{ value: "deleteVMs", description: "" }
      ],
    }
  )
  operation?: "configurationJob" | "sizingJob" | "increaseCapacity" | "reimage" | "deleteVMs";

  /** Id of the associated TaskAgentPool */
  poolId?: int32;

  /** Datetime that the log occurred */
  timestamp?: utcDateTime;
}

/** Class used for updating an elastic pool where only certain members are populated */
model ElasticPoolSettings {
  /** Set whether agents should be configured to run with interactive UI */
  agentInteractiveUI?: boolean;

  /** Azure string representing to location of the resource */
  azureId?: string;

  /** Number of machines to have ready waiting for jobs */
  desiredIdle?: int32;

  /** Maximum number of machines that will exist in the elastic pool */
  maxCapacity?: int32;

  /** Keep machines in the pool on failure for investigation */
  maxSavedNodeCount?: int32;

  /** Operating system type of the machines in the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "OrchestrationType",
      values: #[#{ value: "uniform", description: "" }, #{ value: "flexible", description: "" }],
    }
  )
  orchestrationType?: "uniform" | "flexible";

  /** Operating system type of the machines in the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "OperatingSystemType",
      values: #[#{ value: "windows", description: "" }, #{ value: "linux", description: "" }],
    }
  )
  osType?: "windows" | "linux";

  /** Discard machines after each job completes */
  recycleAfterEachUse?: boolean;

  /** Id of the Service Endpoint used to connect to Azure */
  @format("uuid") serviceEndpointId?: string;

  /** Scope the Service Endpoint belongs to */
  @format("uuid") serviceEndpointScope?: string;

  /** The minimum time in minutes to keep idle agents alive */
  timeToLiveMinutes?: int32;
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

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** An organization-level grouping of agents. */
model TaskAgentPool {
  ...TaskAgentPoolReference;

  /** The ID of the associated agent cloud. */
  agentCloudId?: int32;

  /** Whether or not a queue should be automatically provisioned for each project collection. */
  autoProvision?: boolean;

  /** Whether or not the pool should autosize itself based on the Agent Cloud Provider settings. */
  autoSize?: boolean;

  /** Whether or not agents in this pool are allowed to automatically update */
  autoUpdate?: boolean;

  createdBy?: IdentityRef;

  /** The date/time of the pool creation. */
  createdOn?: utcDateTime;

  owner?: IdentityRef;
  properties?: PropertiesCollection;

  /** Target parallelism - Only applies to agent pools that are backed by pool providers. It will be null for regular pools. */
  targetSize?: int32;
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

/** An agent queue. */
model TaskAgentQueue {
  /** ID of the queue */
  id?: int32;

  /** Name of the queue */
  name?: string;

  pool?: TaskAgentPoolReference;

  /** Project ID */
  @format("uuid") projectId?: string;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Elasticpools {
  /** Get a list of all Elastic Pools. */
  @tag("Elasticpools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "elasticpools")
  @extension("x-ms-vss-method", "GetElasticPools")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ElasticPool[]>;

  /** Create a new elastic pool. This will create a new TaskAgentPool at the organization level. If a project id is provided, this will create a new TaskAgentQueue in the specified project. */
  @tag("Elasticpools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "elasticpools")
  @extension("x-ms-vss-method", "CreateElasticPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name to use for the new TaskAgentPool */
    @query(#{ explode: true }) poolName: string,

    /** Setting to determine if all pipelines are authorized to use this TaskAgentPool by default. */
    @query(#{ explode: true }) authorizeAllPipelines?: boolean,

    /** Setting to automatically provision TaskAgentQueues in every project for the new pool. */
    @query(#{ explode: true }) autoProvisionProjectPools?: boolean,

    /** Optional: If provided, a new TaskAgentQueue will be created in the specified project. */
    @format("uuid") @query(#{ explode: true }) projectId?: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Elastic pool to create. Contains the properties necessary for configuring a new ElasticPool. */
    @body body: ElasticPool,
  ): ElasticPoolCreationResult;

  /** Returns the Elastic Pool with the specified Pool Id. */
  @tag("Elasticpools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "elasticpools")
  @extension("x-ms-vss-method", "GetElasticPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools/{poolId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Pool Id of the associated TaskAgentPool */
    @path poolId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): ElasticPool;

  /** Update settings on a specified Elastic Pool. */
  @tag("Elasticpools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "elasticpools")
  @extension("x-ms-vss-method", "UpdateElasticPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools/{poolId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path poolId: int32,
    ...Parameters.`api-Version-preview`.`1`,

    /** New Elastic Pool settings data */
    @body body: ElasticPoolSettings,
  ): ElasticPool;
}

interface Elasticpoollogs {
  /** Get elastic pool diagnostics logs for a specified Elastic Pool. */
  @tag("Elasticpoollogs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "elasticpoollogs")
  @extension("x-ms-vss-method", "GetElasticPoolLogs")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools/{poolId}/logs")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Pool Id of the Elastic Pool */
    @path poolId: int32,

    /** Number of elastic pool logs to retrieve */
    @query(#{ explode: true }) $top?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ElasticPoolLog[]>;
}

interface Nodes {
  /** Get a list of ElasticNodes currently in the ElasticPool */
  @tag("Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "nodes")
  @extension("x-ms-vss-method", "GetElasticNodes")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools/{poolId}/nodes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Pool id of the ElasticPool */
    @path poolId: int32,

    /** Optional: Filter to only retrieve ElasticNodes in the given ElasticNodeState */
    @extension(
      "x-ms-enum",
      #{
        name: "ElasticNodeState",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "new", description: "" },
          #{ value: "creatingCompute", description: "" },
          #{ value: "startingAgent", description: "" },
          #{ value: "idle", description: "" },
          #{ value: "assigned", description: "" },
          #{ value: "offline", description: "" },
          #{ value: "pendingReimage", description: "" },
          #{ value: "pendingDelete", description: "" },
          #{ value: "saved", description: "" },
          #{ value: "deletingCompute", description: "" },
          #{ value: "deleted", description: "" },
          #{ value: "lost", description: "" },
          #{ value: "reimagingCompute", description: "" },
          #{ value: "restartingAgent", description: "" },
          #{ value: "failedToStartPendingDelete", description: "" },
          #{ value: "failedToRestartPendingDelete", description: "" },
          #{ value: "failedVMPendingDelete", description: "" },
          #{ value: "assignedPendingDelete", description: "" },
          #{ value: "retryDelete", description: "" },
          #{ value: "unhealthyVm", description: "" },
          #{ value: "unhealthyVmPendingDelete", description: "" },
          #{ value: "pendingReimageCandidate", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    $state?:
      | "none"
      | "new"
      | "creatingCompute"
      | "startingAgent"
      | "idle"
      | "assigned"
      | "offline"
      | "pendingReimage"
      | "pendingDelete"
      | "saved"
      | "deletingCompute"
      | "deleted"
      | "lost"
      | "reimagingCompute"
      | "restartingAgent"
      | "failedToStartPendingDelete"
      | "failedToRestartPendingDelete"
      | "failedVMPendingDelete"
      | "assignedPendingDelete"
      | "retryDelete"
      | "unhealthyVm"
      | "unhealthyVmPendingDelete"
      | "pendingReimageCandidate",

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ElasticNode[]>;

  /** Update properties on a specified ElasticNode */
  @tag("Nodes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "nodes")
  @extension("x-ms-vss-method", "UpdateElasticNode")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/elasticpools/{poolId}/nodes/{elasticNodeId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path poolId: int32,
    @path elasticNodeId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: ElasticNodeSettings,
  ): ElasticNode;
}
