import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "TaskAgent" })
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
namespace TaskAgent;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AadOauthTokenRequest {
  refresh?: boolean;
  resource?: string;
  tenantId?: string;
  token?: string;
}

model AadOauthTokenResult {
  accessToken?: string;
  refreshTokenCache?: string;
}

model AgentChangeEvent {
  agent?: TaskAgent;
  eventType?: string;
  pool?: TaskAgentPoolReference;
}

model AgentJobRequestMessage {
  ...JobRequestMessage;
  lockedUntil?: utcDateTime;
  @format("uuid") lockToken?: string;
  requestId?: int64;
  tasks?: TaskInstance[];
}

model AgentPoolEvent {
  eventType?: string;
  pool?: TaskAgentPool;
}

model AgentQueueEvent {
  eventType?: string;
  queue?: TaskAgentQueue;
}

model AgentQueueServiceHookEvent {
  @format("uuid") projectId?: string;
  queueId?: int32;
  queueName?: string;
}

model AgentQueuesEvent {
  eventType?: string;
  queues?: TaskAgentQueue[];
}

model AgentRefreshMessage {
  agentId?: int32;
  targetVersion?: string;
  @format("TimeSpan") timeout?: string;
}

model AuthenticationSchemeReference {
  inputs?: Record<string>;
  type?: string;
}

model AuthorizationHeader {
  /** Gets or sets the name of authorization header. */
  name?: string;

  /** Gets or sets the value of authorization header. */
  value?: string;
}

model AzureKeyVaultPermission {
  ...AzureResourcePermission;
  vault?: string;
}

model AzureKeyVaultVariableGroupProviderData {
  ...VariableGroupProviderData;
  lastRefreshedOn?: utcDateTime;
  @format("uuid") serviceEndpointId?: string;
  vault?: string;
}

model AzureKeyVaultVariableValue {
  ...VariableValue;
  contentType?: string;
  enabled?: boolean;
  expires?: utcDateTime;
}

/** Azure Management Group */
model AzureManagementGroup {
  /** Display name of azure management group */
  displayName?: string;

  /** Id of azure management group */
  id?: string;

  /** Azure management group name */
  name?: string;

  /** Id of tenant from which azure management group belongs */
  tenantId?: string;
}

/** Azure management group query result */
model AzureManagementGroupQueryResult {
  /** Error message in case of an exception */
  errorMessage?: string;

  /** List of azure management groups */
  value?: AzureManagementGroup[];
}

model AzurePermission {
  provisioned?: boolean;
  resourceProvider?: string;
}

model AzureResourcePermission {
  ...AzurePermission;
  resourceGroup?: string;
}

model AzureRoleAssignmentPermission {
  ...AzurePermission;
  @format("uuid") roleAssignmentId?: string;
}

model AzureSpnOperationStatus {
  state?: string;
  statusMessage?: string;
}

model AzureSubscription {
  displayName?: string;
  subscriptionId?: string;
  subscriptionTenantId?: string;
  subscriptionTenantName?: string;
}

model AzureSubscriptionQueryResult {
  errorMessage?: string;
  value?: AzureSubscription[];
}

model ClientCertificate {
  /** Gets or sets the value of client certificate. */
  value?: string;
}

model CounterVariable {
  prefix?: string;
  seed?: int32;
  value?: int32;
}

model DataSource {
  authenticationScheme?: AuthenticationSchemeReference;
  endpointUrl?: string;
  headers?: AuthorizationHeader[];
  name?: string;
  resourceUrl?: string;
  resultSelector?: string;
}

model DataSourceBinding {
  ...DataSourceBindingBase;
}

/** Represents binding of data source for the service endpoint request. */
model DataSourceBindingBase {
  /** Pagination format supported by this data source(ContinuationToken/SkipTop). */
  callbackContextTemplate?: string;

  /** Subsequent calls needed? */
  callbackRequiredTemplate?: string;

  /** Gets or sets the name of the data source. */
  dataSourceName?: string;

  /** Gets or sets the endpoint Id. */
  endpointId?: string;

  /** Gets or sets the url of the service endpoint. */
  endpointUrl?: string;

  /** Gets or sets the authorization headers. */
  headers?: AuthorizationHeader[];

  /** Defines the initial value of the query params */
  initialContextTemplate?: string;

  /** Gets or sets the parameters for the data source. */
  parameters?: Record<string>;

  /** Gets or sets http request body */
  requestContent?: string;

  /** Gets or sets http request verb */
  requestVerb?: string;

  /** Gets or sets the result selector. */
  resultSelector?: string;

  /** Gets or sets the result template. */
  resultTemplate?: string;

  /** Gets or sets the target of the data source. */
  target?: string;
}

model DataSourceDetails {
  dataSourceName?: string;
  dataSourceUrl?: string;
  headers?: AuthorizationHeader[];
  parameters?: Record<string>;
  resourceUrl?: string;
  resultSelector?: string;
}

model Demand {
  name?: string;
  value?: string;
}

model DemandEquals {
  ...Demand;
}

model DemandExists {
  ...Demand;
}

model DemandMinimumVersion {
  ...Demand;
  source?: DemandSource;
}

model DemandSource {
  sourceName?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "DemandSourceType",
      values: #[#{ value: "task", description: "" }, #{ value: "feature", description: "" }],
    }
  )
  sourceType?: "task" | "feature" | string;
  sourceVersion?: string;
}

model DependencyBinding {
  key?: string;
  value?: string;
}

model DependencyData {
  input?: string;
  map?: {}[];
}

model DependsOn {
  input?: string;
  map?: DependencyBinding[];
}

model DeploymentGatesChangeEvent {
  gateNames?: string[];
}

/** Deployment group. */
model DeploymentGroup {
  ...DeploymentGroupReference;

  /** Description of the deployment group. */
  description?: string;

  /** Number of deployment targets in the deployment group. */
  machineCount?: int32;

  /** List of deployment targets in the deployment group. */
  machines?: DeploymentMachine[];

  /** List of unique tags across all deployment targets in the deployment group. */
  machineTags?: string[];
}

/** Properties to create Deployment group. */
model DeploymentGroupCreateParameter {
  /** Description of the deployment group. */
  description?: string;

  /** Name of the deployment group. */
  name?: string;

  /** Identifier of the deployment pool in which deployment agents are registered. */
  poolId?: int32;
}

/** Properties of Deployment pool to create Deployment group. */
model DeploymentGroupCreateParameterPoolProperty {
  /** Deployment pool identifier. */
  id?: int32;
}

/** Deployment group metrics. */
model DeploymentGroupMetrics {
  columnsHeader?: MetricsColumnsHeader;
  deploymentGroup?: DeploymentGroupReference;

  /** Values of properties and the metrics. E.g. 1: total count of deployment targets for which 'TargetState' is 'offline'. E.g. 2: Average time of deployment to the deployment targets for which 'LastJobStatus' is 'passed' and 'TargetState' is 'online'. */
  rows?: MetricsRow[];
}

/** Deployment group reference. This is useful for referring a deployment group in another object. */
model DeploymentGroupReference {
  /** Deployment group identifier. */
  id?: int32;

  /** Name of the deployment group. */
  name?: string;

  pool?: TaskAgentPoolReference;
  project?: ProjectReference;
}

/** Deployment group update parameter. */
model DeploymentGroupUpdateParameter {
  /** Description of the deployment group. */
  description?: string;

  /** Name of the deployment group. */
  name?: string;
}

/** Deployment target. */
model DeploymentMachine {
  agent?: TaskAgent;

  /** Deployment target Identifier. */
  id?: int32;

  properties?: PropertiesCollection;

  /** Tags of the deployment target. */
  tags?: string[];
}

model DeploymentMachineChangedData {
  ...DeploymentMachine;
  addedTags?: string[];
  deletedTags?: string[];
}

model DeploymentMachineGroup {
  ...DeploymentMachineGroupReference;
  machines?: DeploymentMachine[];
  size?: int32;
}

model DeploymentMachineGroupReference {
  id?: int32;
  name?: string;
  pool?: TaskAgentPoolReference;
  project?: ProjectReference;
}

model DeploymentMachinesChangeEvent {
  machineGroupReference?: DeploymentGroupReference;
  machines?: DeploymentMachineChangedData[];
}

/** Deployment pool summary. */
model DeploymentPoolSummary {
  /** List of deployment groups referring to the deployment pool. */
  deploymentGroups?: DeploymentGroupReference[];

  /** Number of deployment agents that are offline. */
  offlineAgentsCount?: int32;

  /** Number of deployment agents that are online. */
  onlineAgentsCount?: int32;

  pool?: TaskAgentPoolReference;
  resource?: EnvironmentResourceReference;
}

/** Deployment target update parameter. */
model DeploymentTargetUpdateParameter {
  /** Identifier of the deployment target. */
  id?: int32;

  tags?: string[];
}

model DiagnosticLogMetadata {
  agentId?: int32;
  agentName?: string;
  fileName?: string;
  phaseName?: string;
  phaseResult?: string;
  poolId?: int32;
}

/** Per-Job projection on a DynamicPipelinePlanStatus. The LogId is the join key for the per-log endpoint and matches the addressing pattern Build uses for its run logs. Issues are not surfaced here — fetch the per-log endpoint to get task-level errors for a specific log. */
model DynamicPipelineJob {
  /** ID of the log stored against this record. <c>null</c> when the agent hasn't started writing a log yet. Pass to <c>dynamicpipelines/{planId}/logs/{logId}</c> to fetch the lines and task-level issues. */
  logId?: int32;

  name?: string;

  /** Timeline record ID for the Job record. Stable across the run; useful for keying UI state per job and for future SignalR integration that emits per-record events. */
  @format("uuid") recordId?: string;

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
    | "dependentOnManualQueue"
    | string;
  @extension(
    "x-ms-enum",
    #{
      name: "TimelineRecordState",
      values: #[
        #{ value: "pending", description: "" },
        #{ value: "inProgress", description: "" },
        #{ value: "completed", description: "" }
      ],
    }
  )
  state?: "pending" | "inProgress" | "completed" | string;
}

/** Response for <c>dynamicpipelines/{planId}/logs/{logId}</c>. Carries the log content plus the task-level Issues the agent raised while running tasks that wrote to this log. Job-level (orchestration) issues are intentionally not included here — consumers care about what the tasks themselves reported, not the surrounding plan plumbing. */
model DynamicPipelineLog {
  /** Task-level issues for this log. Populated from <c>TimelineRecord.Issues</c> on records whose <c>RecordType</c> is <c>Task</c>: <list type='bullet'><item>When the <c>logId</c> belongs to a Task record, this is that record's <c>Issues</c> directly.</item><item>When the <c>logId</c> belongs to a Job (or other parent) record, this aggregates <c>Issues</c> from child Task records (<c>ParentId == ownerRecord.Id</c>).</item></list> */
  issues?: Issue[];

  lines?: string[];
  logId?: int32;
}

/** Structured projection of a dynamic-pipeline plan returned by <c>dynamicpipelines/{planId}/status</c>. Carries plan-level state plus a per-job breakdown (Jobs) so consumers can read structured issues / per-job logId without scraping log lines or making extra calls. */
model DynamicPipelinePlanStatus {
  finishTime?: utcDateTime;

  /** Per-Job timeline record summary. One entry per <c>Job</c>-typed record across all timelines for the plan. <c>LogId</c> is used with the per-log endpoint (<c>dynamicpipelines/{planId}/logs/{logId}</c>), matching Build's log addressing pattern. */
  jobs?: DynamicPipelineJob[];

  @format("uuid") planId?: string;

  /** ID of the repository the plan was queued against (parsed from the plan's artifact URI). The repository name is intentionally not on this payload — consumers look it up via the Git client to avoid pulling a Git server reference into DistributedTask.Sdk.Server. */
  @format("uuid") repositoryId?: string;

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
    | "dependentOnManualQueue"
    | string;
  resultCode?: string;
  startTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskOrchestrationPlanState",
      values: #[
        #{ value: "inProgress", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "throttled", description: "" }
      ],
    }
  )
  state?: "inProgress" | "queued" | "completed" | "throttled" | string;
}

model ElasticAgentPoolResizedEvent {
  newSize?: int32;
  poolId?: int32;
  poolName?: string;
  previousSize?: int32;
  resourceId?: string;
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
  agentState?: "none" | "enabled" | "online" | "assigned" | string;

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
    | "unhealthyVmssVm"
    | string;

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
    | "pendingReimageCandidate"
    | string;

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
    | "pendingReimageCandidate"
    | string;

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
    | "pendingReimageCandidate"
    | string;
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
  orchestrationType?: "uniform" | "flexible" | string;

  /** Operating system type of the nodes in the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "OperatingSystemType",
      values: #[#{ value: "windows", description: "" }, #{ value: "linux", description: "" }],
    }
  )
  osType?: "windows" | "linux" | string;

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
  state?: "online" | "offline" | "unhealthy" | "new" | string;

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
  level?: "error" | "warning" | "info" | string;

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
  operation?:
    | "configurationJob"
    | "sizingJob"
    | "increaseCapacity"
    | "reimage"
    | "deleteVMs"
    | string;

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
  orchestrationType?: "uniform" | "flexible" | string;

  /** Operating system type of the machines in the pool */
  @extension(
    "x-ms-enum",
    #{
      name: "OperatingSystemType",
      values: #[#{ value: "windows", description: "" }, #{ value: "linux", description: "" }],
    }
  )
  osType?: "windows" | "linux" | string;

  /** Discard machines after each job completes */
  recycleAfterEachUse?: boolean;

  /** Id of the Service Endpoint used to connect to Azure */
  @format("uuid") serviceEndpointId?: string;

  /** Scope the Service Endpoint belongs to */
  @format("uuid") serviceEndpointScope?: string;

  /** The minimum time in minutes to keep idle agents alive */
  timeToLiveMinutes?: int32;
}

model EndpointAuthorization {
  /** Gets or sets the parameters for the selected authorization scheme. */
  parameters?: Record<string>;

  /** Gets or sets the scheme used for service endpoint authentication. */
  scheme?: string;
}

/** Represents url of the service endpoint. */
model EndpointUrl {
  dependsOn?: DependsOn;

  /** Gets or sets the display name of service endpoint url. */
  displayName?: string;

  /** Gets or sets the help text of service endpoint url. */
  helpText?: string;

  /** Gets or sets the visibility of service endpoint url. */
  isVisible?: string;

  /** Gets or sets the value of service endpoint url. */
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
    | "dependentOnManualQueue"
    | string;

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

/** EnvironmentLinkedResourceReference. */
model EnvironmentLinkedResourceReference {
  /** Id of the resource. */
  id?: string;

  /** Type of resource. */
  typeName?: string;
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
  type?: "undefined" | "generic" | "virtualMachine" | "kubernetes" | string;
}

/** EnvironmentResourceDeploymentExecutionRecord. */
model EnvironmentResourceDeploymentExecutionRecord {
  /** Id of the Environment */
  environmentId?: int32;

  /** Finish time of the environment resource deployment execution */
  finishTime?: utcDateTime;

  /** Id of the Environment deployment execution history record */
  requestId?: int64;

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
    | "dependentOnManualQueue"
    | string;

  /** Start time of the environment resource deployment execution */
  startTime?: utcDateTime;
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
  type?: "undefined" | "generic" | "virtualMachine" | "kubernetes" | string;
}

/** Properties to update Environment. */
model EnvironmentUpdateParameter {
  /** Description of the environment. */
  description?: string;

  /** Name of the environment. */
  name?: string;
}

model EventsConfig {}

model ExpressionValidationItem {
  ...ValidationItem;
}

model ExternalRepositoryResource {
  displayName?: string;
  externalId?: string;
  @format("uuid") externalRepositoryId?: string;
  hostName?: string;
}

model FilterDropDownItem {
  displayName?: string;
  id?: string;
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

model HelpLink {
  text?: string;
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

model InputBindingContext {
  /** Value of the input */
  value?: string;
}

/** Describes an input for subscriptions. */
model InputDescriptor {
  /** The ids of all inputs that the value of this input is dependent on. */
  dependencyInputIds?: string[];

  /** Description of what this input is used for */
  description?: string;

  /** The group localized name to which this input belongs and can be shown as a header for the container that will include all the inputs in the group. */
  groupName?: string;

  /** If true, the value information for this input is dynamic and should be fetched when the value of dependency inputs change. */
  hasDynamicValueInformation?: boolean;

  /** Identifier for the subscription input */
  id?: string;

  /** Mode in which the value of this input should be entered */
  @extension(
    "x-ms-enum",
    #{
      name: "InputMode",
      values: #[
        #{ value: "none", description: "This input should not be shown in the UI" },
        #{ value: "textBox", description: "An input text box should be shown" },
        #{ value: "passwordBox", description: "An password input box should be shown" },
        #{ value: "combo", description: "A select/combo control should be shown" },
        #{ value: "radioButtons", description: "Radio buttons should be shown" },
        #{ value: "checkBox", description: "Checkbox should be shown(for true/false values)" },
        #{ value: "textArea", description: "A multi-line text area should be shown" }
      ],
    }
  )
  inputMode?:
    | "none"
    | "textBox"
    | "passwordBox"
    | "combo"
    | "radioButtons"
    | "checkBox"
    | "textArea"
    | string;

  /** Gets whether this input is confidential, such as for a password or application key */
  isConfidential?: boolean;

  /** Localized name which can be shown as a label for the subscription input */
  name?: string;

  /** Custom properties for the input which can be used by the service provider */
  properties?: Record<{}>;

  /** Underlying data type for the input value. When this value is specified, InputMode, Validation and Values are optional. */
  type?: string;

  /** Gets whether this input is included in the default generated action description. */
  useInDefaultDescription?: boolean;

  validation?: InputValidation;

  /** A hint for input value. It can be used in the UI as the input placeholder. */
  valueHint?: string;

  values?: InputValues;
}

/** Describes what values are valid for a subscription input */
model InputValidation {
  /** Gets or sets the data type to validate. */
  @extension(
    "x-ms-enum",
    #{
      name: "InputDataType",
      values: #[
        #{ value: "none", description: "No data type is specified." },
        #{ value: "string", description: "Represents a textual value." },
        #{ value: "number", description: "Represents a numeric value." },
        #{ value: "boolean", description: "Represents a value of true or false." },
        #{ value: "guid", description: "Represents a Guid." },
        #{ value: "uri", description: "Represents a URI." }
      ],
    }
  )
  dataType?: "none" | "string" | "number" | "boolean" | "guid" | "uri" | string;

  /** Gets or sets if this is a required field. */
  isRequired?: boolean;

  /** Gets or sets the maximum length of this descriptor. */
  maxLength?: int32;

  /** Gets or sets the minimum value for this descriptor. */
  @format("decimal") maxValue?: string;

  /** Gets or sets the minimum length of this descriptor. */
  minLength?: int32;

  /** Gets or sets the minimum value for this descriptor. */
  @format("decimal") minValue?: string;

  /** Gets or sets the pattern to validate. */
  pattern?: string;

  /** Gets or sets the error on pattern mismatch. */
  patternMismatchErrorMessage?: string;

  /** Gets or sets the warning on pattern mismatch. */
  patternMismatchWarningMessage?: string;

  /** Gets or sets the pattern to validate. */
  warningPattern?: string;
}

model InputValidationItem {
  ...ValidationItem;
  context?: InputBindingContext;
}

model InputValidationRequest {
  inputs?: Record<ValidationItem>;
}

/** Information about a single value for an input */
model InputValue {
  /** Any other data about this input */
  data?: Record<{}>;

  /** The text to show for the display of this value */
  displayValue?: string;

  /** The value to store for this input */
  value?: string;
}

/** Information about the possible/allowed values for a given subscription input */
model InputValues {
  /** The default value to use for this input */
  defaultValue?: string;

  error?: InputValuesError;

  /** The id of the input */
  inputId?: string;

  /** Should this input be disabled */
  isDisabled?: boolean;

  /** Should the value be restricted to one of the values in the PossibleValues (True) or are the values in PossibleValues just a suggestion (False) */
  isLimitedToPossibleValues?: boolean;

  /** Should this input be made read-only */
  isReadOnly?: boolean;

  /** Possible values that this input can take */
  possibleValues?: InputValue[];
}

/** Error information related to a subscription input value. */
model InputValuesError {
  /** The error message. */
  message?: string;
}

/** An issue (error, warning) associated with a pipeline run. */
model Issue {
  /** The category of the issue. <br />Example: Code - refers to compilation errors <br />Example: General - refers to generic errors */
  category?: string;

  /** A dictionary containing details about the issue. */
  data?: Record<string>;

  /** A description of issue. */
  message?: string;

  /** The type (error, warning) of the issue. */
  @extension(
    "x-ms-enum",
    #{
      name: "IssueType",
      values: #[#{ value: "error", description: "" }, #{ value: "warning", description: "" }],
    }
  )
  type?: "error" | "warning" | string;
}

model JobAssignedEvent {
  ...JobEvent;
  request?: TaskAgentJobRequest;
}

model JobCanceledEvent {
  ...JobEvent;

  /** The reason for job cancellation. */
  reason?: string;

  /** The job's timeout interval. */
  @format("TimeSpan") timeout?: string;
}

model JobCancelMessage {
  @format("uuid") jobId?: string;
  @format("TimeSpan") timeout?: string;
}

model JobCompletedEvent {
  ...JobEvent;

  /** Indicates whether the agent is in the process of shutting down. */
  agentShuttingDown?: boolean;

  /** The ID of the request. */
  requestId?: int64;

  /** The result of the request. */
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
    | "dependentOnManualQueue"
    | string;
}

/** Represents the context of variables and vectors for a job request. */
model JobEnvironment {
  endpoints?: ServiceEndpoint[];
  mask?: MaskHint[];
  options?: Record<JobOption>;
  secureFiles?: SecureFile[];
  systemConnection?: ServiceEndpoint;
  variables?: Record<string>;
}

/** A pipeline job event to be processed by the execution plan. */
model JobEvent {
  /** The ID of the pipeline job affected by the event. */
  @format("uuid") jobId?: string;

  /** The name of the pipeline job event. */
  name?: string;
}

model JobEventConfig {
  timeout?: string;
}

model JobEventsConfig {
  ...EventsConfig;
  jobAssigned?: JobEventConfig;
  jobCompleted?: JobEventConfig;
  jobStarted?: JobEventConfig;
}

/** Represents a JSON object. */
model JObject {
  item?: JToken;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

model JobMetadataEvent {
  ...JobEvent;
  message?: JobMetadataMessage;
}

/** A message to be sent to an agent currently running the job. */
model JobMetadataMessage {
  /** The id of the job. */
  @format("uuid") jobId?: string;

  /** The agent's frequency of posting lines to the logs console expressed in milliseconds. There are 2 modes: Slow (10 seconds) and Fast (half a second). */
  postLinesFrequencyMillis?: int32;
}

/** Represents an option that may affect the way an agent runs the job. */
model JobOption {
  data?: Record<string>;

  /** Gets the id of the option. */
  @format("uuid") id?: string;
}

model JobRequestMessage {
  environment?: JobEnvironment;
  @format("uuid") jobId?: string;
  jobName?: string;
  jobRefName?: string;
  messageType?: string;
  plan?: TaskOrchestrationPlanReference;
  timeline?: TimelineReference;
}

model JobStartedEvent {
  ...JobEvent;
}

/** Represents an abstract JSON token. */
model JToken {
  first?: JToken;

  /** Gets a value indicating whether this token has child tokens. */
  hasValues?: boolean;

  item?: JToken;
  last?: JToken;
  next?: JToken;

  /** Gets or sets the parent. */
  @format("JContainer") parent?: string;

  /** Gets the path of the JSON token. */
  path?: string;

  previous?: JToken;
  root?: JToken;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
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

model KubernetesResourceCreateParametersNewEndpoint {
  ...KubernetesResourceCreateParameters;
  endpoint?: ServiceEndpoint;
}

model KubernetesResourcePatchParameters {
  authorizationParameters?: Record<string>;

  /** Provider type (CustomProvider or AzureKubernetesServiceProvider) of the resource to be updated */
  providerType?: string;

  resourceId?: int32;
}

/** Represents a purchase of resource units in a secondary marketplace. */
model MarketplacePurchasedLicense {
  /** The Marketplace display name. */
  marketplaceName?: string;

  /** The name of the identity making the purchase as seen by the marketplace */
  purchaserName?: string;

  /** The quantity purchased. */
  purchaseUnitCount?: int32;
}

model MaskHint {
  @extension(
    "x-ms-enum",
    #{
      name: "MaskType",
      values: #[#{ value: "variable", description: "" }, #{ value: "regex", description: "" }],
    }
  )
  type?: "variable" | "regex" | string;
  value?: string;
}

/** Meta data for a metrics column. */
model MetricsColumnMetaData {
  /** Name. */
  columnName?: string;

  /** Data type. */
  columnValueType?: string;
}

/** Metrics columns header */
model MetricsColumnsHeader {
  /** Properties of deployment group for which metrics are provided. E.g. 1: LastJobStatus E.g. 2: TargetState */
  dimensions?: MetricsColumnMetaData[];

  /** The types of metrics. E.g. 1: total count of deployment targets. E.g. 2: Average time of deployment to the deployment targets. */
  metrics?: MetricsColumnMetaData[];
}

/** Metrics row. */
model MetricsRow {
  /** The values of the properties mentioned as 'Dimensions' in column header. E.g. 1: For a property 'LastJobStatus' - metrics will be provided for 'passed', 'failed', etc. E.g. 2: For a property 'TargetState' - metrics will be provided for 'online', 'offline' targets. */
  dimensions?: string[];

  /** Metrics in serialized format. Should be deserialized based on the data type provided in header. */
  metrics?: string[];
}

/** Represents a downloadable package. */
model PackageMetadata {
  /** The date the package was created */
  createdOn?: utcDateTime;

  /** A direct link to download the package. */
  downloadUrl?: string;

  /** The UI uses this to display instructions, i.e. 'unzip MyAgent.zip' */
  filename?: string;

  /** MD5 hash as a base64 string */
  hashValue?: string;

  /** A link to documentation */
  infoUrl?: string;

  /** The platform (win7, linux, etc.) */
  platform?: string;

  /** The type of package (e.g. 'agent') */
  type?: string;

  version?: PackageVersion;
}

model PackageVersion {
  major?: int32;
  minor?: int32;
  patch?: int32;
}

model PlanEnvironment {
  mask?: MaskHint[];
  options?: Record<JobOption>;
  variables?: Record<string>;
}

model ProjectReference {
  @format("uuid") id?: string;
  name?: string;
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

model PublishTaskGroupMetadata {
  comment?: string;
  parentDefinitionRevision?: int32;
  preview?: boolean;
  @format("uuid") taskGroupId?: string;
  taskGroupRevision?: int32;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model ResourceFilterOptions {
  endpointSchemes?: FilterDropDownItem[];
  endpointTypes?: FilterDropDownItem[];
  identities?: IdentityRef[];
  resourceTypes?: string[];
}

model ResourceFilters {
  createdBy?: string[];
  resourceAuthScheme?: string[];
  resourceType?: string[];
  searchText?: string;
}

/** Resources include Service Connections, Variable Groups and Secure Files. */
model ResourceItem {
  createdBy?: IdentityRef;

  /** Gets or sets description of the resource. */
  description?: string;

  /** Gets or sets icon url of the resource. */
  iconUrl?: string;

  /** Gets or sets Id of the resource. */
  id?: string;

  /** Indicates whether resource is outdated or not. */
  isOutdated?: boolean;

  /** Indicates whether resource is shared with other projects or not. */
  isShared?: boolean;

  /** Gets or sets name of the resource. */
  name?: string;

  /** Gets or sets internal properties of the resource. */
  properties?: Record<string>;

  /** Gets or sets resource type. */
  resourceType?: string;
}

model ResourceLimit {
  failedToReachAllProviders?: boolean;
  @format("uuid") hostId?: string;
  isHosted?: boolean;
  isPremium?: boolean;
  parallelismTag?: string;
  @format("uuid") quotaId?: string;
  resourceLimitsData?: Record<string>;
  totalCount?: int32;
  totalMinutes?: int32;
}

/** A request for a resource's exclusive lock */
model ResourceLockRequest {
  /** The date/time this request was assigned. */
  assignTime?: utcDateTime;

  /** The branch the lock belongs to. It's used only by RunLatest exclusive locks of persisted stages. */
  branch?: string;

  /** The ID of the check run waiting on this request */
  @format("uuid") checkRunId?: string;

  /** The ID of the pipeline that requested this resource */
  definitionId?: int32;

  /** The date/time this request was finished. */
  finishTime?: utcDateTime;

  /** The behavior this request should exhibit in relation to other lock requests */
  @extension(
    "x-ms-enum",
    #{
      name: "ExclusiveLockType",
      values: #[
        #{ value: "runLatest", description: "" },
        #{ value: "sequential", description: "" },
        #{ value: "branchRunLatest", description: "" },
        #{ value: "parallel", description: "" }
      ],
    }
  )
  lockType?: "runLatest" | "sequential" | "branchRunLatest" | "parallel" | string;

  /** Attempt of the graph node */
  nodeAttempt?: int32;

  /** Name of the graph node (currently stage) requesting this resource */
  nodeName?: string;

  /** Internal ID for the orchestration plan connected with this request. */
  @format("uuid") planId?: string;

  /** The ID of the project of the check run and definition exist in */
  @format("uuid") projectId?: string;

  /** The date/time this request was queued. */
  queueTime?: utcDateTime;

  /** ID of the request. */
  requestId?: int64;

  /** The id of the resource */
  resourceId?: string;

  /** The type of the resource */
  resourceType?: string;

  /** The result of this request. */
  @extension(
    "x-ms-enum",
    #{
      name: "ResourceLockStatus",
      values: #[
        #{ value: "queued", description: "" },
        #{ value: "inUse", description: "" },
        #{ value: "finished", description: "" },
        #{ value: "timedOut", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "abandoned", description: "" },
        #{ value: "waitingOnChecks", description: "" }
      ],
    }
  )
  status?:
    | "queued"
    | "inUse"
    | "finished"
    | "timedOut"
    | "canceled"
    | "abandoned"
    | "waitingOnChecks"
    | string;
}

model ResourcesHubData {
  continuationToken?: string;
  hasProjectLevelManagePermission?: boolean;
  resourceFilterOptions?: ResourceFilterOptions;
  resourceFilters?: ResourceFilters;
  resourceItems?: ResourceItem[];
}

model ResourceUsage {
  resourceLimit?: ResourceLimit;
  runningRequests?: TaskAgentJobRequest[];
  usedCount?: int32;
  usedMinutes?: int32;
}

model ResultTransformationDetails {
  resultTemplate?: string;
}

model SecureFile {
  createdBy?: IdentityRef;
  createdOn?: utcDateTime;
  @format("uuid") id?: string;
  modifiedBy?: IdentityRef;
  modifiedOn?: utcDateTime;
  name?: string;
  properties?: Record<string>;
  ticket?: string;
}

model SecureFileEvent {
  eventType?: string;
  @format("uuid") projectId?: string;
  secureFiles?: SecureFile[];
}

model SendJobResponse {
  events?: JobEventsConfig;
  variables?: Record<string>;
}

model ServerExecutionDefinition {
  events?: EventsConfig;
  handlerName?: string;
}

model ServerTaskRequestMessage {
  ...JobRequestMessage;
  taskDefinition?: TaskDefinition;
  taskInstance?: TaskInstance;
}

/** Represents an endpoint which may be used by an orchestration job. */
model ServiceEndpoint {
  administratorsGroup?: IdentityRef;
  authorization?: EndpointAuthorization;
  createdBy?: IdentityRef;

  /** Gets or sets the date, when the Service endpoint has been created. */
  creationDate?: utcDateTime;

  data?: Record<string>;

  /** Gets or sets the description of endpoint. */
  description?: string;

  @format("uuid") groupScopeId?: string;

  /** Gets or sets the identifier of this endpoint. */
  @format("uuid") id?: string;

  /** If this endpoint is disabled. */
  isDisabled?: boolean;

  /** EndPoint state indicator */
  isReady?: boolean;

  /** Indicates whether service endpoint is shared with other projects or not. */
  isShared?: boolean;

  /** Gets or sets the date, when the Service endpoint has been modified. */
  modificationDate?: utcDateTime;

  modifiedBy?: IdentityRef;

  /** Gets or sets the friendly name of the endpoint. */
  name?: string;

  operationStatus?: JObject;

  /** Gets or sets the owner of the endpoint. */
  owner?: string;

  readersGroup?: IdentityRef;

  /** Service Tree ID */
  serviceManagementReference?: string;

  /** Gets or sets the type of the endpoint. */
  type?: string;

  /** Gets or sets the url of the endpoint. */
  url?: string;
}

model ServiceEndpointAuthenticationScheme {
  /** Gets or sets the authorization headers of service endpoint authentication scheme. */
  authorizationHeaders?: AuthorizationHeader[];

  /** Gets or sets the certificates of service endpoint authentication scheme. */
  clientCertificates?: ClientCertificate[];

  /** Gets or sets the display name for the service endpoint authentication scheme. */
  displayName?: string;

  /** Gets or sets the input descriptors for the service endpoint authentication scheme. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets the scheme for service endpoint authentication. */
  scheme?: string;
}

model ServiceEndpointDetails {
  authorization?: EndpointAuthorization;
  data?: Record<string>;
  type?: string;
  url?: string;
}

/** Represents service endpoint execution data. */
model ServiceEndpointExecutionData {
  definition?: TaskOrchestrationOwner;

  /** Gets the finish time of service endpoint execution. */
  finishTime?: utcDateTime;

  /** Gets the Id of service endpoint execution data. */
  id?: int64;

  owner?: TaskOrchestrationOwner;

  /** Gets the plan type of service endpoint execution data. */
  planType?: string;

  /** Gets the result of service endpoint execution. */
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
    | "dependentOnManualQueue"
    | string;

  /** Gets the start time of service endpoint execution. */
  startTime?: utcDateTime;
}

model ServiceEndpointExecutionRecord {
  data?: ServiceEndpointExecutionData;

  /** Gets the Id of service endpoint. */
  @format("uuid") endpointId?: string;
}

model ServiceEndpointExecutionRecordsInput {
  data?: ServiceEndpointExecutionData;
  endpointIds?: string[];
}

model ServiceEndpointRequest {
  dataSourceDetails?: DataSourceDetails;
  resultTransformationDetails?: ResultTransformationDetails;
  serviceEndpointDetails?: ServiceEndpointDetails;
}

model ServiceEndpointRequestResult {
  errorMessage?: string;
  result?: JToken;
  @extension(
    "x-ms-enum",
    #{
      name: "HttpStatusCode",
      values: #[
        #{ value: "continue", description: "" },
        #{ value: "switchingProtocols", description: "" },
        #{ value: "ok", description: "" },
        #{ value: "created", description: "" },
        #{ value: "accepted", description: "" },
        #{ value: "nonAuthoritativeInformation", description: "" },
        #{ value: "noContent", description: "" },
        #{ value: "resetContent", description: "" },
        #{ value: "partialContent", description: "" },
        #{ value: "multipleChoices", description: "" },
        #{ value: "ambiguous", description: "" },
        #{ value: "movedPermanently", description: "" },
        #{ value: "moved", description: "" },
        #{ value: "found", description: "" },
        #{ value: "redirect", description: "" },
        #{ value: "seeOther", description: "" },
        #{ value: "redirectMethod", description: "" },
        #{ value: "notModified", description: "" },
        #{ value: "useProxy", description: "" },
        #{ value: "unused", description: "" },
        #{ value: "temporaryRedirect", description: "" },
        #{ value: "redirectKeepVerb", description: "" },
        #{ value: "badRequest", description: "" },
        #{ value: "unauthorized", description: "" },
        #{ value: "paymentRequired", description: "" },
        #{ value: "forbidden", description: "" },
        #{ value: "notFound", description: "" },
        #{ value: "methodNotAllowed", description: "" },
        #{ value: "notAcceptable", description: "" },
        #{ value: "proxyAuthenticationRequired", description: "" },
        #{ value: "requestTimeout", description: "" },
        #{ value: "conflict", description: "" },
        #{ value: "gone", description: "" },
        #{ value: "lengthRequired", description: "" },
        #{ value: "preconditionFailed", description: "" },
        #{ value: "requestEntityTooLarge", description: "" },
        #{ value: "requestUriTooLong", description: "" },
        #{ value: "unsupportedMediaType", description: "" },
        #{ value: "requestedRangeNotSatisfiable", description: "" },
        #{ value: "expectationFailed", description: "" },
        #{ value: "upgradeRequired", description: "" },
        #{ value: "internalServerError", description: "" },
        #{ value: "notImplemented", description: "" },
        #{ value: "badGateway", description: "" },
        #{ value: "serviceUnavailable", description: "" },
        #{ value: "gatewayTimeout", description: "" },
        #{ value: "httpVersionNotSupported", description: "" }
      ],
    }
  )
  statusCode?:
    | "continue"
    | "switchingProtocols"
    | "ok"
    | "created"
    | "accepted"
    | "nonAuthoritativeInformation"
    | "noContent"
    | "resetContent"
    | "partialContent"
    | "multipleChoices"
    | "ambiguous"
    | "movedPermanently"
    | "moved"
    | "found"
    | "redirect"
    | "seeOther"
    | "redirectMethod"
    | "notModified"
    | "useProxy"
    | "unused"
    | "temporaryRedirect"
    | "redirectKeepVerb"
    | "badRequest"
    | "unauthorized"
    | "paymentRequired"
    | "forbidden"
    | "notFound"
    | "methodNotAllowed"
    | "notAcceptable"
    | "proxyAuthenticationRequired"
    | "requestTimeout"
    | "conflict"
    | "gone"
    | "lengthRequired"
    | "preconditionFailed"
    | "requestEntityTooLarge"
    | "requestUriTooLong"
    | "unsupportedMediaType"
    | "requestedRangeNotSatisfiable"
    | "expectationFailed"
    | "upgradeRequired"
    | "internalServerError"
    | "notImplemented"
    | "badGateway"
    | "serviceUnavailable"
    | "gatewayTimeout"
    | "httpVersionNotSupported"
    | string;
}

/** Represents type of the service endpoint. */
model ServiceEndpointType {
  /** Authentication scheme of service endpoint type. */
  authenticationSchemes?: ServiceEndpointAuthenticationScheme[];

  /** Data sources of service endpoint type. */
  dataSources?: DataSource[];

  /** Dependency data of service endpoint type. */
  dependencyData?: DependencyData[];

  /** Gets or sets the description of service endpoint type. */
  description?: string;

  /** Gets or sets the display name of service endpoint type. */
  displayName?: string;

  endpointUrl?: EndpointUrl;
  helpLink?: HelpLink;
  helpMarkDown?: string;

  /** Gets or sets the icon url of service endpoint type. */
  iconUrl?: string;

  /** Input descriptor of service endpoint type. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets the name of service endpoint type. */
  name?: string;

  /** Trusted hosts of a service endpoint type. */
  trustedHosts?: string[];

  /** Gets or sets the ui contribution id of service endpoint type. */
  uiContributionId?: string;
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

model TaskAgentCloud {
  /** Gets or sets a AcquireAgentEndpoint using which a request can be made to acquire new agent */
  acquireAgentEndpoint?: string;

  acquisitionTimeout?: int32;
  agentCloudId?: int32;
  getAccountParallelismEndpoint?: string;
  getAgentDefinitionEndpoint?: string;
  getAgentRequestStatusEndpoint?: string;
  @format("uuid") id?: string;

  /** Signifies that this Agent Cloud is internal and should not be user-manageable */
  internal?: boolean;

  maxParallelism?: int32;
  name?: string;
  releaseAgentEndpoint?: string;
  sharedSecret?: string;

  /** Gets or sets the type of the endpoint. */
  type?: string;
}

model TaskAgentCloudRequest {
  agent?: TaskAgentReference;
  agentCloudId?: int32;
  agentConnectedTime?: utcDateTime;
  agentData?: JObject;
  agentSpecification?: JObject;
  pool?: TaskAgentPoolReference;
  poolProvidersTags?: Record<string>;
  provisionedTime?: utcDateTime;
  provisionRequestTime?: utcDateTime;
  releaseRequestTime?: utcDateTime;
  @format("uuid") requestId?: string;
  requestVersion?: int32;
}

model TaskAgentCloudType {
  /** Gets or sets the display name of agent cloud type. */
  displayName?: string;

  /** Gets or sets the input descriptors */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets the name of agent cloud type. */
  name?: string;
}

model TaskAgentDowngrade {
  ...TaskAgentUpdateReason;
}

model TaskAgentJob {
  container?: string;
  @format("uuid") id?: string;
  name?: string;
  sidecarContainers?: Record<string>;
  steps?: TaskAgentJobStep[];
  variables?: TaskAgentJobVariable[];
}

/** A job request for an agent. */
model TaskAgentJobRequest {
  ...TaskAgentJobRequestRef;
  agentSpecification?: JObject;

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
    | "dependentOnManualQueue"
    | string;

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

model TaskAgentJobStep {
  condition?: string;
  continueOnError?: boolean;
  enabled?: boolean;
  env?: Record<string>;
  @format("uuid") id?: string;
  inputs?: Record<string>;
  name?: string;
  retryCountOnTaskFailure?: int32;
  task?: TaskAgentJobTask;
  timeoutInMinutes?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentJobStepType",
      values: #[#{ value: "task", description: "" }, #{ value: "action", description: "" }],
    }
  )
  type?: "task" | "action" | string;
}

model TaskAgentJobTask {
  @format("uuid") id?: string;
  name?: string;
  version?: string;
}

model TaskAgentJobVariable {
  name?: string;
  secret?: boolean;
  value?: string;
}

model TaskAgentManualUpdate {
  ...TaskAgentUpdateReason;
}

/** Provides a contract for receiving messages from the task orchestrator. */
model TaskAgentMessage {
  /** Gets or sets the body of the message. If the <c>IV</c> property is provided the body will need to be decrypted using the <c>TaskAgentSession.EncryptionKey</c> value in addition to the <c>IV</c>. */
  body?: string;

  /** Gets or sets the initialization vector used to encrypt this message. */
  iv?: bytes[];

  /** Gets or sets the message identifier. */
  messageId?: int64;

  /** Gets or sets the message type, describing the data contract found in <c>TaskAgentMessage.Body</c>. */
  messageType?: string;
}

model TaskAgentMinAgentVersionRequiredUpdate {
  ...TaskAgentUpdateReason;
  jobDefinition?: TaskOrchestrationOwner;
  jobOwner?: TaskOrchestrationOwner;
  minAgentVersion?: Demand;
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

model TaskAgentPoolMaintenanceDefinition {
  /** Enable maintenance */
  enabled?: boolean;

  /** Id */
  id?: int32;

  /** Maintenance job timeout per agent */
  jobTimeoutInMinutes?: int32;

  /** Max percentage of agents within a pool running maintenance job at given time */
  maxConcurrentAgentsPercentage?: int32;

  options?: TaskAgentPoolMaintenanceOptions;
  pool?: TaskAgentPoolReference;
  retentionPolicy?: TaskAgentPoolMaintenanceRetentionPolicy;
  scheduleSetting?: TaskAgentPoolMaintenanceSchedule;
}

model TaskAgentPoolMaintenanceJob {
  /** The maintenance definition for the maintenance job */
  definitionId?: int32;

  /** The total error counts during the maintenance job */
  errorCount?: int32;

  /** Time that the maintenance job was completed */
  finishTime?: utcDateTime;

  /** Id of the maintenance job */
  jobId?: int32;

  /** The log download url for the maintenance job */
  logsDownloadUrl?: string;

  /** Orchestration/Plan Id for the maintenance job */
  @format("uuid") orchestrationId?: string;

  pool?: TaskAgentPoolReference;

  /** Time that the maintenance job was queued */
  queueTime?: utcDateTime;

  requestedBy?: IdentityRef;

  /** The maintenance job result */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolMaintenanceJobResult",
      values: #[
        #{ value: "succeeded", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "canceled", description: "" }
      ],
    }
  )
  result?: "succeeded" | "failed" | "canceled" | string;

  /** Time that the maintenance job was started */
  startTime?: utcDateTime;

  /** Status of the maintenance job */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolMaintenanceJobStatus",
      values: #[
        #{ value: "inProgress", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "cancelling", description: "" },
        #{ value: "queued", description: "" }
      ],
    }
  )
  status?: "inProgress" | "completed" | "cancelling" | "queued" | string;

  targetAgents?: TaskAgentPoolMaintenanceJobTargetAgent[];

  /** The total warning counts during the maintenance job */
  warningCount?: int32;
}

model TaskAgentPoolMaintenanceJobTargetAgent {
  agent?: TaskAgentReference;
  jobId?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolMaintenanceJobResult",
      values: #[
        #{ value: "succeeded", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "canceled", description: "" }
      ],
    }
  )
  result?: "succeeded" | "failed" | "canceled" | string;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolMaintenanceJobStatus",
      values: #[
        #{ value: "inProgress", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "cancelling", description: "" },
        #{ value: "queued", description: "" }
      ],
    }
  )
  status?: "inProgress" | "completed" | "cancelling" | "queued" | string;
}

model TaskAgentPoolMaintenanceOptions {
  /** time to consider a System.DefaultWorkingDirectory is stale */
  workingDirectoryExpirationInDays?: int32;
}

model TaskAgentPoolMaintenanceRetentionPolicy {
  /** Number of records to keep for maintenance job executed with this definition. */
  numberOfHistoryRecordsToKeep?: int32;
}

model TaskAgentPoolMaintenanceSchedule {
  /** Days for a build (flags enum for days of the week) */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentPoolMaintenanceScheduleDays",
      values: #[
        #{ value: "none", description: "Do not run." },
        #{ value: "monday", description: "Run on Monday." },
        #{ value: "tuesday", description: "Run on Tuesday." },
        #{ value: "wednesday", description: "Run on Wednesday." },
        #{ value: "thursday", description: "Run on Thursday." },
        #{ value: "friday", description: "Run on Friday." },
        #{ value: "saturday", description: "Run on Saturday." },
        #{ value: "sunday", description: "Run on Sunday." },
        #{ value: "all", description: "Run on all days of the week." }
      ],
    }
  )
  daysToBuild?:
    | "none"
    | "monday"
    | "tuesday"
    | "wednesday"
    | "thursday"
    | "friday"
    | "saturday"
    | "sunday"
    | "all"
    | string;

  /** The Job Id of the Scheduled job that will queue the pool maintenance job. */
  @format("uuid") scheduleJobId?: string;

  /** Local timezone hour to start */
  startHours?: int32;

  /** Local timezone minute to start */
  startMinutes?: int32;

  /** Time zone of the build schedule (string representation of the time zone id) */
  timeZoneId?: string;
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
  options?: "none" | "elasticPool" | "singleUseAgents" | "preserveAgentOnJobFailure" | string;

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
  poolType?: "automation" | "deployment" | string;

  @format("uuid") scope?: string;

  /** Gets the current size of the pool. */
  size?: int32;
}

model TaskAgentPoolStatus {
  ...TaskAgentPoolReference;

  /** Number of requests queued and assigned to an agent. Not running yet. */
  assignedRequestCount?: int32;

  /** Number of queued requests which are not assigned to any agents */
  queuedRequestCount?: int32;

  /** Number of currently running requests */
  runningRequestCount?: int32;
}

model TaskAgentPoolSummary {
  columnsHeader?: MetricsColumnsHeader;
  deploymentGroups?: DeploymentGroupReference[];
  pool?: TaskAgentPoolReference;
  queues?: TaskAgentQueue[];
  rows?: MetricsRow[];
}

/** Represents the public key portion of an RSA asymmetric key. */
model TaskAgentPublicKey {
  /** Gets or sets the exponent for the public key. */
  exponent?: bytes[];

  /** Gets or sets the modulus for the public key. */
  modulus?: bytes[];
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

/** Restrictions applied to an agent queue */
model TaskAgentQueueRestrictions {
  /** The restricted image labels. */
  restrictedImageLabels?: string[];
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
  status?: "offline" | "online" | string;

  /** Agent version. */
  version?: string;
}

/** Represents a session for performing message exchanges from an agent. */
model TaskAgentSession {
  agent?: TaskAgentReference;

  /** This will be false in case an old Agent is creating the session. */
  agentCanHandleOaepSHA256?: boolean;

  encryptionKey?: TaskAgentSessionKey;

  /** Gets or sets the owner name of this session. Generally this will be the machine of origination. */
  ownerName?: string;

  /** Gets the unique identifier for this session. */
  @format("uuid") sessionId?: string;

  systemCapabilities?: Record<string>;
}

/** Represents a symmetric key used for message-level encryption for communication sent to an agent. */
model TaskAgentSessionKey {
  /** Gets or sets a value indicating whether or not the key value is encrypted. If this value is true, the Value property should be decrypted using the <c>RSA</c> key exchanged with the server during registration. */
  encrypted?: boolean;

  /** Name of RSAEncryptionPadding that TFS (backend) used. New Agents will check this value. Won't be emitted for old Agents that only support OaepSHA1. */
  encryptionPadding?: string;

  /** Gets or sets the symmetric key value. */
  value?: bytes[];
}

model TaskAgentSkuUsage {
  @format("uuid") meterId?: string;
  skuName?: string;
  value?: int32;
}

/** A single ranked usage entry for one dimension value within one SKU. */
model TaskAgentSkuUsageRow {
  /** The value of the grouped dimension for this row (e.g. a project GUID string, a definition ID string). */
  dimensionValue?: string;

  /** Rank within its SKU (1 = highest usage). */
  rank?: int32;

  usage?: TaskAgentSkuUsage;
}

/** Query for SKU usage statistics on an agent cloud pool. Groups billing data by a specified dimension and returns the top N consumers per SKU, ranked by total billed minutes. */
model TaskAgentSkuUsageSummaryQuery {
  /** End of the time range (exclusive). */
  endTimeExclusive?: utcDateTime;

  /** The billing dimension to group and rank results by. */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentSkuUsageDimension",
      values: #[
        #{ value: "scopeIdentifier", description: "Group by project (scope identifier GUID)." },
        #{ value: "queueId", description: "Group by agent queue." },
        #{ value: "definitionId", description: "Group by pipeline definition." }
      ],
    }
  )
  groupBy?: "scopeIdentifier" | "queueId" | "definitionId" | string;

  /** Optional: restrict to specific SKUs. Null or empty means all SKUs. When multiple MeterIds are provided, results are ranked independently per SKU. */
  meterIds?: string[];

  /** The pool to query usage for. */
  poolId?: int32;

  /** Optional: narrow results to a specific queue before grouping. Only valid when GroupBy is DefinitionId. The queue implicitly identifies the project. */
  queueId?: int32;

  /** Optional: narrow results to a specific project before grouping. Typically used when drilling down from pool → project, with GroupBy set to DefinitionId to see pipelines within that project. */
  @format("uuid") scopeIdentifier?: string;

  /** Start of the time range (inclusive). */
  startTimeInclusive?: utcDateTime;

  /** Maximum results per SKU. Defaults to 5 server-side. */
  topN?: int32;
}

/** Result of a SKU usage query. Contains the original query and the ranked usage rows. */
model TaskAgentSkuUsageSummaryResult {
  query?: TaskAgentSkuUsageSummaryQuery;

  /** Ranked usage rows, ordered by MeterId then rank. Each SKU has its own independent top-N ranking. */
  usages?: TaskAgentSkuUsageRow[];
}

/** A single time bucket's total billed minutes for a SKU. */
model TaskAgentSkuUsageTrendPoint {
  @format("uuid") meterId?: string;
  totalMinutes?: int32;
  usageDate?: utcDateTime;
}

/** Query for daily SKU usage trend data on an agent cloud pool. Returns one row per day per meter with total billed minutes. */
model TaskAgentSkuUsageTrendQuery {
  /** End of the time range (exclusive). */
  endTimeExclusive?: utcDateTime;

  /** Optional list of SKU meter IDs to get trend data for. When empty, all meters are returned. */
  meterIds?: string[];

  /** The pool to query usage for. */
  poolId?: int32;

  /** Optional: restrict to a specific queue. */
  queueId?: int32;

  /** Time bucket size in minutes. 60=hourly, 360=6h, 720=12h, 1440=daily. Defaults to 1440 (daily). */
  resolutionMinutes?: int32;

  /** Start of the time range (inclusive). */
  startTimeInclusive?: utcDateTime;
}

/** Result of a SKU usage trend query. Contains the original query and the daily usage data points. */
model TaskAgentSkuUsageTrendResult {
  /** Usage data points, ordered by date ascending. Buckets with no usage are not included. */
  points?: TaskAgentSkuUsageTrendPoint[];

  query?: TaskAgentSkuUsageTrendQuery;
}

model TaskAgentStatusUpdate {
  /** Whether or not the agent is online. */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskAgentStatus",
      values: #[#{ value: "offline", description: "" }, #{ value: "online", description: "" }],
    }
  )
  status?: "offline" | "online" | string;

  /** Date on which the last connectivity status change occurred. */
  statusChangedOn?: utcDateTime;
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
  code?: "manual" | "minAgentVersionRequired" | "downgrade" | string;
}

model TaskAssignedEvent {
  ...TaskEvent;
}

model TaskAttachment {
  _links?: ReferenceLinks;
  createdOn?: utcDateTime;
  @format("uuid") lastChangedBy?: string;
  lastChangedOn?: utcDateTime;
  name?: string;
  @format("uuid") recordId?: string;
  @format("uuid") timelineId?: string;
  type?: string;
}

model TaskCommandRestrictions {
  @extension(
    "x-ms-enum",
    #{
      name: "TaskCommandMode",
      values: #[#{ value: "any", description: "" }, #{ value: "restricted", description: "" }],
    }
  )
  mode?: "any" | "restricted" | string;
}

model TaskCompletedEvent {
  ...TaskEvent;

  /** The api request was no delivered successfully */
  deliveryFailed?: boolean;

  /** The result of the task. */
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
    | "dependentOnManualQueue"
    | string;
}

model TaskDefinition {
  agentExecution?: TaskExecution;
  author?: string;
  buildConfig?: string;
  category?: string;
  contentsUploaded?: boolean;
  contributionIdentifier?: string;
  contributionVersion?: string;
  dataSourceBindings?: DataSourceBinding[];
  definitionType?: string;
  demands?: Demand[];
  deprecated?: boolean;
  description?: string;
  disabled?: boolean;
  execution?: Record<JObject>;
  friendlyName?: string;
  groups?: TaskGroupDefinition[];
  helpMarkDown?: string;
  helpUrl?: string;
  hostType?: string;
  iconUrl?: string;
  @format("uuid") id?: string;
  inputs?: TaskInputDefinition[];
  instanceNameFormat?: string;
  minimumAgentVersion?: string;
  name?: string;
  outputVariables?: TaskOutputVariable[];
  packageLocation?: string;
  packageType?: string;
  postJobExecution?: Record<JObject>;
  preJobExecution?: Record<JObject>;
  preview?: boolean;
  releaseNotes?: string;
  restrictions?: TaskRestrictions;
  runsOn?: string[];
  satisfies?: string[];
  serverOwned?: boolean;
  showEnvironmentVariables?: boolean;
  sourceDefinitions?: TaskSourceDefinition[];
  sourceLocation?: string;
  version?: TaskVersion;
  visibility?: string[];
}

model TaskDefinitionEndpoint {
  /** An ID that identifies a service connection to be used for authenticating endpoint requests. */
  connectionId?: string;

  /** An Json based keyselector to filter response returned by fetching the endpoint <c>Url</c>.A Json based keyselector must be prefixed with 'jsonpath:'. KeySelector can be used to specify the filter to get the keys for the values specified with Selector. <example> The following keyselector defines an Json for extracting nodes named 'ServiceName'. <code> endpoint.KeySelector = 'jsonpath://ServiceName'; </code></example> */
  keySelector?: string;

  /** The scope as understood by Connected Services. Essentially, a project-id for now. */
  scope?: string;

  /** An XPath/Json based selector to filter response returned by fetching the endpoint <c>Url</c>. An XPath based selector must be prefixed with the string 'xpath:'. A Json based selector must be prefixed with 'jsonpath:'. <example> The following selector defines an XPath for extracting nodes named 'ServiceName'. <code> endpoint.Selector = 'xpath://ServiceName'; </code></example> */
  selector?: string;

  /** TaskId that this endpoint belongs to. */
  taskId?: string;

  /** URL to GET. */
  url?: string;
}

model TaskDefinitionReference {
  /** Gets or sets the definition type. Values can be 'task' or 'metaTask'. */
  definitionType?: string;

  /** Gets or sets the unique identifier of task. */
  @format("uuid") id?: string;

  /** Gets or sets the version specification of task. */
  versionSpec?: string;
}

model TaskEvent {
  ...JobEvent;

  /** The ID of the task definition. */
  @format("uuid") taskId?: string;
}

model TaskExecution {
  execTask?: TaskReference;

  /** If a task is going to run code, then this provides the type/script etc... information by platform. For example, it might look like. net45: { typeName: 'Microsoft.TeamFoundation.Automation.Tasks.PowerShellTask', assemblyName: 'Microsoft.TeamFoundation.Automation.Tasks.PowerShell.dll' } net20: { typeName: 'Microsoft.TeamFoundation.Automation.Tasks.PowerShellTask', assemblyName: 'Microsoft.TeamFoundation.Automation.Tasks.PowerShell.dll' } java: { jar: 'powershelltask.tasks.automation.teamfoundation.microsoft.com', } node: { script: 'powershellhost.js', } */
  platformInstructions?: Record<Record<string>>;
}

model TaskGroup {
  ...TaskDefinition;

  /** Gets or sets comment. */
  comment?: string;

  createdBy?: IdentityRef;

  /** Gets or sets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets or sets as 'true' to indicate as deleted, 'false' otherwise. */
  deleted?: boolean;

  modifiedBy?: IdentityRef;

  /** Gets or sets date on which it got modified. */
  modifiedOn?: utcDateTime;

  /** Gets or sets the owner. */
  owner?: string;

  /** Gets or sets parent task group Id. This is used while creating a draft task group. */
  @format("uuid") parentDefinitionId?: string;

  /** Gets or sets revision. */
  revision?: int32;

  /** Gets or sets the tasks. */
  tasks?: TaskGroupStep[];
}

model TaskGroupCreateParameter {
  /** Sets author name of the task group. */
  author?: string;

  /** Sets category of the task group. */
  category?: string;

  /** Sets description of the task group. */
  description?: string;

  /** Sets friendly name of the task group. */
  friendlyName?: string;

  /** Sets url icon of the task group. */
  iconUrl?: string;

  /** Sets input for the task group. */
  inputs?: TaskInputDefinition[];

  /** Sets display name of the task group. */
  instanceNameFormat?: string;

  /** Sets name of the task group. */
  name?: string;

  /** Sets parent task group Id. This is used while creating a draft task group. */
  @format("uuid") parentDefinitionId?: string;

  /** Sets RunsOn of the task group. Value can be 'Agent', 'Server' or 'DeploymentGroup'. */
  runsOn?: string[];

  /** Sets tasks for the task group. */
  tasks?: TaskGroupStep[];

  version?: TaskVersion;
}

model TaskGroupDefinition {
  displayName?: string;
  isExpanded?: boolean;
  name?: string;
  tags?: string[];
  visibleRule?: string;
}

model TaskGroupPublishPreviewParameter {
  ...TaskGroupUpdatePropertiesBase;

  /** This is to disable previous versions of task group upon publish */
  disablePriorVersions?: boolean;

  /** Denotes if task group is in preview */
  preview?: boolean;

  /** This is the revision of task group that is getting published */
  revision?: int32;

  version?: TaskVersion;
}

model TaskGroupRestoreParameter {
  ...TaskGroupUpdatePropertiesBase;

  /** This is to restore deleted Task Group */
  restore?: boolean;
}

model TaskGroupRevision {
  changedBy?: IdentityRef;
  changedDate?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "AuditAction",
      values: #[
        #{ value: "add", description: "" },
        #{ value: "update", description: "" },
        #{ value: "delete", description: "" },
        #{ value: "undelete", description: "" }
      ],
    }
  )
  changeType?: "add" | "update" | "delete" | "undelete" | string;
  comment?: string;
  fileId?: int32;
  majorVersion?: int32;
  revision?: int32;
  @format("uuid") taskGroupId?: string;
}

/** Represents tasks in the task group. */
model TaskGroupStep {
  /** Gets or sets as 'true' to run the task always, 'false' otherwise. */
  alwaysRun?: boolean;

  /** Gets or sets condition for the task. */
  condition?: string;

  /** Gets or sets as 'true' to continue on error, 'false' otherwise. */
  continueOnError?: boolean;

  /** Gets or sets the display name. */
  displayName?: string;

  /** Gets or sets as task is enabled or not. */
  enabled?: boolean;

  /** Gets dictionary of environment variables. */
  environment?: Record<string>;

  /** Gets or sets dictionary of inputs. */
  inputs?: Record<string>;

  /** Gets or sets the maximum number of retries */
  retryCountOnTaskFailure?: int32;

  task?: TaskDefinitionReference;

  /** Gets or sets the maximum time, in minutes, that a task is allowed to execute on agent before being cancelled by server. A zero value indicates an infinite timeout. */
  timeoutInMinutes?: int32;
}

model TaskGroupUpdateParameter {
  /** Sets author name of the task group. */
  author?: string;

  /** Sets category of the task group. */
  category?: string;

  /** Sets comment of the task group. */
  comment?: string;

  /** Sets description of the task group. */
  description?: string;

  /** Sets friendly name of the task group. */
  friendlyName?: string;

  /** Sets url icon of the task group. */
  iconUrl?: string;

  /** Sets the unique identifier of this field. */
  @format("uuid") id?: string;

  /** Sets input for the task group. */
  inputs?: TaskInputDefinition[];

  /** Sets display name of the task group. */
  instanceNameFormat?: string;

  /** Sets name of the task group. */
  name?: string;

  /** Gets or sets parent task group Id. This is used while creating a draft task group. */
  @format("uuid") parentDefinitionId?: string;

  /** Sets revision of the task group. */
  revision?: int32;

  /** Sets RunsOn of the task group. Value can be 'Agent', 'Server' or 'DeploymentGroup'. */
  runsOn?: string[];

  /** Sets tasks for the task group. */
  tasks?: TaskGroupStep[];

  version?: TaskVersion;
}

model TaskGroupUpdatePropertiesBase {
  /** Comment for this update request */
  comment?: string;
}

model TaskHubAccessToken {
  accessToken?: string;
}

model TaskHubLicenseDetails {
  enterpriseUsersCount?: int32;
  failedToReachAllProviders?: boolean;
  freeHostedLicenseCount?: int32;
  freeLicenseCount?: int32;
  hasLicenseCountEverUpdated?: boolean;
  hostedAgentMinutesFreeCount?: int32;
  hostedAgentMinutesUsedCount?: int32;
  hostedLicensesArePremium?: boolean;
  msdnUsersCount?: int32;

  /** Microsoft-hosted licenses purchased from VSTS directly. */
  purchasedHostedLicenseCount?: int32;

  /** Self-hosted licenses purchased from VSTS directly. */
  purchasedLicenseCount?: int32;

  totalHostedLicenseCount?: int32;
  totalLicenseCount?: int32;
  totalPrivateLicenseCount?: int32;
}

model TaskHubOidcToken {
  oidcToken?: string;
}

model TaskInputDefinition {
  ...TaskInputDefinitionBase;
}

model TaskInputDefinitionBase {
  aliases?: string[];
  defaultValue?: string;
  groupName?: string;
  helpMarkDown?: string;
  label?: string;
  name?: string;
  options?: Record<string>;
  properties?: Record<string>;
  required?: boolean;
  type?: string;
  validation?: TaskInputValidation;
  visibleRule?: string;
}

model TaskInputValidation {
  /** Conditional expression */
  expression?: string;

  /** Message explaining how user can correct if validation fails */
  message?: string;
}

model TaskInstance {
  ...TaskReference;
  alwaysRun?: boolean;
  condition?: string;
  continueOnError?: boolean;
  displayName?: string;
  enabled?: boolean;
  environment?: Record<string>;
  @format("uuid") instanceId?: string;
  refName?: string;
  retryCountOnTaskFailure?: int32;
  timeoutInMinutes?: int32;
}

/** A task log connected to a timeline record. */
model TaskLog {
  ...TaskLogReference;

  /** The time of the task log creation. */
  createdOn?: utcDateTime;

  /** The REST URL of the task log when indexed. */
  indexLocation?: string;

  /** The time of the last modification of the task log. */
  lastChangedOn?: utcDateTime;

  /** The number of the task log lines. */
  lineCount?: int64;

  /** The path of the task log. */
  path?: string;
}

/** A reference to a task log. This class contains information about the output printed to the timeline record's logs console during pipeline run. */
model TaskLogReference {
  /** The ID of the task log. */
  id?: int32;

  /** The REST URL of the task log. */
  location?: string;
}

model TaskOrchestrationContainer {
  ...TaskOrchestrationItem;
  children?: TaskOrchestrationItem[];
  continueOnError?: boolean;
  data?: Record<string>;
  maxConcurrency?: int32;
  parallel?: boolean;
  rollback?: TaskOrchestrationContainer;
}

model TaskOrchestrationItem {
  @extension(
    "x-ms-enum",
    #{
      name: "TaskOrchestrationItemType",
      values: #[#{ value: "container", description: "" }, #{ value: "job", description: "" }],
    }
  )
  itemType?: "container" | "job" | string;
}

model TaskOrchestrationJob {
  ...TaskOrchestrationItem;
  demands?: Demand[];
  executeAs?: IdentityRef;
  executionMode?: string;
  @format("TimeSpan") executionTimeout?: string;
  @format("uuid") instanceId?: string;
  name?: string;
  refName?: string;
  tasks?: TaskInstance[];
  variables?: Record<string>;
}

model TaskOrchestrationOwner {
  _links?: ReferenceLinks;
  id?: int32;
  name?: string;
}

model TaskOrchestrationPlan {
  ...TaskOrchestrationPlanReference;
  environment?: PlanEnvironment;
  expandedYaml?: TaskLogReference;
  finishTime?: utcDateTime;
  implementation?: TaskOrchestrationContainer;
  initializationLog?: TaskLogReference;
  @format("uuid") requestedById?: string;
  @format("uuid") requestedForId?: string;
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
    | "dependentOnManualQueue"
    | string;
  resultCode?: string;
  startTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskOrchestrationPlanState",
      values: #[
        #{ value: "inProgress", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "throttled", description: "" }
      ],
    }
  )
  state?: "inProgress" | "queued" | "completed" | "throttled" | string;
  timeline?: TimelineReference;
}

model TaskOrchestrationPlanGroup {
  planGroup?: string;
  project?: ProjectReference;
  runningRequests?: TaskAgentJobRequest[];
}

model TaskOrchestrationPlanGroupsQueueMetrics {
  count?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "PlanGroupStatus",
      values: #[
        #{ value: "running", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?: "running" | "queued" | "all" | string;
}

model TaskOrchestrationPlanReference {
  artifactLocation?: string;
  artifactUri?: string;
  definition?: TaskOrchestrationOwner;
  owner?: TaskOrchestrationOwner;
  planGroup?: string;
  @format("uuid") planId?: string;
  planType?: string;
  @format("uuid") scopeIdentifier?: string;
  version?: int32;
}

model TaskOrchestrationQueuedPlan {
  assignTime?: utcDateTime;
  definition?: TaskOrchestrationOwner;
  owner?: TaskOrchestrationOwner;
  planGroup?: string;
  @format("uuid") planId?: string;
  poolId?: int32;
  queuePosition?: int32;
  queueTime?: utcDateTime;
  @format("uuid") scopeIdentifier?: string;
}

model TaskOrchestrationQueuedPlanGroup {
  definition?: TaskOrchestrationOwner;
  owner?: TaskOrchestrationOwner;
  planGroup?: string;
  plans?: TaskOrchestrationQueuedPlan[];
  project?: ProjectReference;
  queuePosition?: int32;
}

model TaskOutputVariable {
  description?: string;
  name?: string;
}

model TaskPackageMetadata {
  /** Gets the name of the package. */
  type?: string;

  /** Gets the url of the package. */
  url?: string;

  /** Gets the version of the package. */
  version?: string;
}

/** A reference to a task. */
model TaskReference {
  /** The build config of the task definition. Corresponds to the version value of task.json file. <br />Example: CmdLineV2 { '_buildConfigMapping': { 'Default': '2.232.2', 'Node20_229_7': '2.232.3' } } */
  buildConfig?: string;

  contributionIdentifier?: string;
  contributionVersion?: string;

  /** The ID of the task definition. Corresponds to the id value of task.json file. <br />Example: CmdLineV2 { 'id': 'D9BAFED4-0B18-4F58-968D-86655B4D2CE9' } */
  @format("uuid") id?: string;

  /** A dictionary of inputs specific to a task definition. Corresponds to inputs value of task.json file. */
  inputs?: Record<string>;

  /** The name of the task definition. Corresponds to the name value of task.json file. <br />Example: CmdLineV2 { 'name': 'CmdLine' } */
  name?: string;

  /** The version of the task definition. Corresponds to the version value of task.json file. <br />Example: CmdLineV2 { 'version': { 'Major': 2, 'Minor': 212, 'Patch': 0 } } */
  version?: string;
}

model TaskRelease {
  /** The ordinal number of a release within the selected sprint. */
  ordinal?: int32;

  /** The Azure DevOps sprint the release belongs to. */
  sprint?: int32;
}

model TaskRestrictions {
  commands?: TaskCommandRestrictions;
  settableVariables?: TaskVariableRestrictions;
}

model TaskSourceDefinition {
  ...TaskSourceDefinitionBase;
}

model TaskSourceDefinitionBase {
  authKey?: string;
  endpoint?: string;
  keySelector?: string;
  selector?: string;
  target?: string;
}

model TaskStartedEvent {
  ...TaskEvent;
}

model TaskVariableRestrictions {
  allowed?: string[];
}

model TaskVersion {
  isTest?: boolean;
  major?: int32;
  minor?: int32;
  patch?: int32;
}

model Timeline {
  ...TimelineReference;
  @format("uuid") lastChangedBy?: string;
  lastChangedOn?: utcDateTime;
  records?: TimelineRecord[];
}

/** An attempt to update a TimelineRecord. */
model TimelineAttempt {
  /** The attempt of the record. */
  attempt?: int32;

  /** The unique identifier for the record. */
  identifier?: string;

  /** The record identifier located within the specified timeline. */
  @format("uuid") recordId?: string;

  /** The timeline identifier which owns the record representing this attempt. */
  @format("uuid") timelineId?: string;
}

/** Detailed information about the execution of different operations during pipeline run. */
model TimelineRecord {
  agentSpecification?: JObject;

  /** The number of record attempts. */
  attempt?: int32;

  /** The ID connecting all records updated at the same time. This value is taken from timeline's ChangeId. */
  changeId?: int32;

  /** A string that indicates the current operation. */
  currentOperation?: string;

  details?: TimelineReference;

  /** The number of errors produced by this operation. */
  errorCount?: int32;

  /** The finish time of the record. */
  finishTime?: utcDateTime;

  /** The ID of the record. */
  @format("uuid") id?: string;

  /** String identifier that is consistent across attempts. */
  identifier?: string;

  /** The list of issues produced by this operation. */
  issues?: Issue[];

  /** The time the record was last modified. */
  lastModified?: utcDateTime;

  /** The REST URL of the record. */
  location?: string;

  log?: TaskLogReference;

  /** The name of the record. */
  name?: string;

  /** An ordinal value relative to other records within the timeline. */
  order?: int32;

  /** The ID of the record's parent. <br />Example: Stage is a parent of a Phase, Phase is a parent of a Job, Job is a parent of a Task. */
  @format("uuid") parentId?: string;

  /** The percentage of record completion. */
  percentComplete?: int32;

  /** The previous record attempts. */
  previousAttempts?: TimelineAttempt[];

  /** The ID of the queue which connects projects to agent pools on which the operation ran on. Applicable when record is of type Job. */
  queueId?: int32;

  /** Name of the referenced record. */
  refName?: string;

  /** The result of the record. */
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
    | "dependentOnManualQueue"
    | string;

  /** Evaluation of predefined conditions upon completion of record's operation. <br />Example: Evaluating `succeeded()`, Result = True <br />Example: Evaluating `and(succeeded(), eq(variables['system.debug'], False))`, Result = False */
  resultCode?: string;

  /** The start time of the record. */
  startTime?: utcDateTime;

  /** The state of the record. */
  @extension(
    "x-ms-enum",
    #{
      name: "TimelineRecordState",
      values: #[
        #{ value: "pending", description: "" },
        #{ value: "inProgress", description: "" },
        #{ value: "completed", description: "" }
      ],
    }
  )
  state?: "pending" | "inProgress" | "completed" | string;

  task?: TaskReference;

  /** The type of operation being tracked by the record. <br />Example: Stage, Phase, Job, Task... */
  type?: string;

  /** The variables of the record. */
  variables?: Record<VariableValue>;

  /** The number of warnings produced by this operation. */
  warningCount?: int32;

  /** The name of the agent running the operation. Applicable when record is of type Job. */
  workerName?: string;
}

model TimelineRecordFeedLinesWrapper {
  count?: int32;
  endLine?: int64;
  startLine?: int64;
  @format("uuid") stepId?: string;
  value?: string[];
}

/** A reference to a timeline record. */
model TimelineRecordReference {
  attempt?: int32;

  /** The ID of the record. */
  @format("uuid") id?: string;

  /** String identifier that is consistent across attempts. */
  identifier?: string;

  /** The state of the record. */
  @extension(
    "x-ms-enum",
    #{
      name: "TimelineRecordState",
      values: #[
        #{ value: "pending", description: "" },
        #{ value: "inProgress", description: "" },
        #{ value: "completed", description: "" }
      ],
    }
  )
  state?: "pending" | "inProgress" | "completed" | string;
}

/** A reference to a timeline. */
model TimelineReference {
  /** The change ID. */
  changeId?: int32;

  /** The ID of the timeline. */
  @format("uuid") id?: string;

  /** The REST URL of the timeline. */
  location?: string;
}

model ValidationItem {
  /** Tells whether the current input is valid or not */
  isValid?: boolean;

  /** Reason for input validation failure */
  reason?: string;

  /** Type of validation item */
  type?: string;

  /** Value to validate. The conditional expression to validate for the input for 'expression' type Eg:eq(variables['Build.SourceBranch'], 'refs/heads/master');eq(value, 'refs/heads/master') */
  value?: string;
}

/** A variable group is a collection of related variables. */
model VariableGroup {
  createdBy?: IdentityRef;

  /** Gets or sets the time when variable group was created. */
  createdOn?: utcDateTime;

  /** Gets or sets description of the variable group. */
  description?: string;

  /** Gets or sets id of the variable group. */
  id?: int32;

  /** Indicates whether variable group is shared with other projects or not. */
  isShared?: boolean;

  modifiedBy?: IdentityRef;

  /** Gets or sets the time when variable group was modified */
  modifiedOn?: utcDateTime;

  /** Gets or sets name of the variable group. */
  name?: string;

  providerData?: VariableGroupProviderData;

  /** Gets or sets type of the variable group. */
  type?: string;

  /** all project references where the variable group is shared with other projects. */
  variableGroupProjectReferences?: VariableGroupProjectReference[];

  /** Gets or sets variables contained in the variable group. */
  variables?: Record<VariableValue>;
}

model VariableGroupParameters {
  /** Sets description of the variable group. */
  description?: string;

  /** Sets name of the variable group. */
  name?: string;

  providerData?: VariableGroupProviderData;

  /** Sets type of the variable group. */
  type?: string;

  variableGroupProjectReferences?: VariableGroupProjectReference[];

  /** Sets variables contained in the variable group. */
  variables?: Record<VariableValue>;
}

/** A variable group reference is a shallow reference to variable group. */
model VariableGroupProjectReference {
  /** Gets or sets description of the variable group. */
  description?: string;

  /** Gets or sets name of the variable group. */
  name?: string;

  projectReference?: ProjectReference;
}

/** Defines provider data of the variable group. */
model VariableGroupProviderData {}

/** A wrapper class for a generic variable. */
model VariableValue {
  /** Indicates whether the variable can be changed during script's execution runtime. */
  isReadOnly?: boolean;

  /** Indicates whether the variable should be encrypted at rest. */
  isSecret?: boolean;

  /** The value of the variable. */
  value?: string;
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

model VirtualMachineResourceMinReference {
  ...EnvironmentReference;
  agent?: TaskAgentReference;
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

model WorkloadIdentityFederationDetailsData {
  federationIssuer?: string;
  federationSubject?: string;
}

/** Represents a reference to a check configuration defined in pipeline YAML. Persisted stage is the resource that contains the check configuration reference. */
model YamlCheckReference {
  /** Gets or sets the type of the check configuration reference. */
  @extension(
    "x-ms-enum",
    #{
      name: "YamlCheckType",
      values: #[
        #{ value: "none", description: "Unsupported YAML type" },
        #{ value: "productionReadiness", description: "Production Readiness Check" }
      ],
    }
  )
  type?: "none" | "productionReadiness" | string;
}

/** A collection of `TaskAgentCloud` as returned by Azure DevOps. */
model TaskAgentCloudList {
  count?: int32;
  value?: TaskAgentCloud[];
}

/** A collection of `TaskAgentCloudRequest` as returned by Azure DevOps. */
model TaskAgentCloudRequestList {
  count?: int32;
  value?: TaskAgentCloudRequest[];
}

/** A collection of `TaskAgentCloudType` as returned by Azure DevOps. */
model TaskAgentCloudTypeList {
  count?: int32;
  value?: TaskAgentCloudType[];
}

/** A collection of `TaskAgentPool` as returned by Azure DevOps. */
model TaskAgentPoolList {
  count?: int32;
  value?: TaskAgentPool[];
}

/** A collection of `TaskAgent` as returned by Azure DevOps. */
model TaskAgentList {
  count?: int32;
  value?: TaskAgent[];
}

/** A collection of `DeploymentGroup` as returned by Azure DevOps. */
model DeploymentGroupList {
  count?: int32;
  value?: DeploymentGroup[];
}

/** A collection of `DeploymentMachine` as returned by Azure DevOps. */
model DeploymentMachineList {
  count?: int32;
  value?: DeploymentMachine[];
}

/** A collection of `TaskAgentQueue` as returned by Azure DevOps. */
model TaskAgentQueueList {
  count?: int32;
  value?: TaskAgentQueue[];
}

/** A collection of `SecureFile` as returned by Azure DevOps. */
model SecureFileList {
  count?: int32;
  value?: SecureFile[];
}

/** A collection of `TaskGroup` as returned by Azure DevOps. */
model TaskGroupList {
  count?: int32;
  value?: TaskGroup[];
}

/** A collection of `VariableGroup` as returned by Azure DevOps. */
model VariableGroupList {
  count?: int32;
  value?: VariableGroup[];
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

interface Agentclouds {
  @tag("Agentclouds")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agentclouds")
  @extension("x-ms-vss-method", "GetAgentClouds")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentclouds")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentCloudList;

  @tag("Agentclouds")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agentclouds")
  @extension("x-ms-vss-method", "AddAgentCloud")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentclouds")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: TaskAgentCloud,
  ): TaskAgentCloud;

  @tag("Agentclouds")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agentclouds")
  @extension("x-ms-vss-method", "DeleteAgentCloud")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentclouds/{agentCloudId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path agentCloudId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentCloud;

  @tag("Agentclouds")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agentclouds")
  @extension("x-ms-vss-method", "GetAgentCloud")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentclouds/{agentCloudId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path agentCloudId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentCloud;

  @tag("Agentclouds")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agentclouds")
  @extension("x-ms-vss-method", "UpdateAgentCloud")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentclouds/{agentCloudId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path agentCloudId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: TaskAgentCloud,
  ): TaskAgentCloud;
}

interface Requests {
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "GetAgentCloudRequests")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentclouds/{agentCloudId}/requests")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path agentCloudId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentCloudRequestList;
}

interface Agentcloudtypes {
  /** Get agent cloud types. */
  @tag("Agentcloudtypes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agentcloudtypes")
  @extension("x-ms-vss-method", "GetAgentCloudTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/agentcloudtypes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentCloudTypeList;
}

interface Pools {
  /** Get a list of agent pools. */
  @tag("Pools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pools")
  @extension("x-ms-vss-method", "GetAgentPoolsByIds")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools")
  @get
  GetAgentPoolsByIds(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** pool Ids to fetch */
    @format("array (int32)") @query(#{ explode: true }) poolIds: string,

    /** Filter by whether the calling user has use or manage permissions */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskAgentPoolActionFilter",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "manage", description: "" },
          #{ value: "use", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentPoolList;

  /** Create an agent pool. */
  @tag("Pools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pools")
  @extension("x-ms-vss-method", "AddAgentPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Details about the new agent pool */
    @body body: TaskAgentPool,
  ): TaskAgentPool;

  /** Delete an agent pool. */
  @tag("Pools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pools")
  @extension("x-ms-vss-method", "DeleteAgentPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the agent pool to delete */
    @path poolId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get information about an agent pool. */
  @tag("Pools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pools")
  @extension("x-ms-vss-method", "GetAgentPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** An agent pool ID */
    @path poolId: int32,

    /** Agent pool properties (comma-separated) */
    @format("array (string)") @query(#{ explode: true }) properties?: string,

    /** Filter by whether the calling user has use or manage permissions */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskAgentPoolActionFilter",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "manage", description: "" },
          #{ value: "use", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentPool;

  /** Update properties on an agent pool */
  @tag("Pools")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pools")
  @extension("x-ms-vss-method", "UpdateAgentPool")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent pool to update */
    @path poolId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Updated agent pool details */
    @body body: TaskAgentPool,
  ): TaskAgentPool;
}

interface Agents {
  /** Get a list of agents. */
  @tag("Agents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agents")
  @extension("x-ms-vss-method", "GetAgents")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/agents")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent pool containing the agents */
    @path poolId: int32,

    /** Filter on agent name */
    @query(#{ explode: true }) agentName?: string,

    /** Whether to include the agents' capabilities in the response */
    @query(#{ explode: true }) includeCapabilities?: boolean,

    /** Whether to include details about the agents' current work */
    @query(#{ explode: true }) includeAssignedRequest?: boolean,

    /** Whether to include details about the agents' most recent completed work */
    @query(#{ explode: true }) includeLastCompletedRequest?: boolean,

    /** Filter which custom properties will be returned */
    @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

    /** Filter by demands the agents can satisfy */
    @format("array (string)") @query(#{ explode: true }) demands?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentList;

  /** Adds an agent to a pool. You probably don't want to call this endpoint directly. Instead, [configure an agent](https://docs.microsoft.com/azure/devops/pipelines/agents/agents) using the agent download package. */
  @tag("Agents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agents")
  @extension("x-ms-vss-method", "AddAgent")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/agents")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent pool in which to add the agent */
    @path poolId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Details about the agent being added */
    @body body: TaskAgent,
  ): TaskAgent;

  /** Delete an agent. You probably don't want to call this endpoint directly. Instead, [use the agent configuration script](https://docs.microsoft.com/azure/devops/pipelines/agents/agents) to remove an agent from your organization. */
  @tag("Agents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agents")
  @extension("x-ms-vss-method", "DeleteAgent")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/agents/{agentId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The pool ID to remove the agent from */
    @path poolId: int32,

    /** The agent ID to remove */
    @path agentId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get information about an agent. */
  @tag("Agents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agents")
  @extension("x-ms-vss-method", "GetAgent")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/agents/{agentId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent pool containing the agent */
    @path poolId: int32,

    /** The agent ID to get information about */
    @path agentId: int32,

    /** Whether to include the agent's capabilities in the response */
    @query(#{ explode: true }) includeCapabilities?: boolean,

    /** Whether to include details about the agent's current work */
    @query(#{ explode: true }) includeAssignedRequest?: boolean,

    /** Whether to include details about the agents' most recent completed work */
    @query(#{ explode: true }) includeLastCompletedRequest?: boolean,

    /** Filter which custom properties will be returned */
    @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgent;

  /** Update agent details. */
  @tag("Agents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agents")
  @extension("x-ms-vss-method", "UpdateAgent")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/agents/{agentId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent pool to use */
    @path poolId: int32,

    /** The agent to update */
    @path agentId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Updated details about the agent */
    @body body: TaskAgent,
  ): TaskAgent;

  /** Replace an agent. You probably don't want to call this endpoint directly. Instead, [use the agent configuration script](https://docs.microsoft.com/azure/devops/pipelines/agents/agents) to remove and reconfigure an agent from your organization. */
  @tag("Agents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "agents")
  @extension("x-ms-vss-method", "ReplaceAgent")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/agents/{agentId}")
  @put
  ReplaceAgent(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent pool to use */
    @path poolId: int32,

    /** The agent to replace */
    @path agentId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Updated details about the replacing agent */
    @body body: TaskAgent,
  ): TaskAgent;
}

interface Poolpermissions {
  /** Checks if current identity has passed permissions on a pool. */
  @tag("Poolpermissions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "poolpermissions")
  @extension("x-ms-vss-method", "HasPoolPermissions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/pools/{poolId}/permissions/{permissions}")
  @get
  HasPoolPermissions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of the pool to check */
    @path poolId: int32,

    /** Permissions to check. Multiple permissions might be merged into single value using bitwise OR operator (e.g. AgentPoolPermissions.Manage | AgentPoolPermissions.View) */
    @path permissions: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<boolean>;
}

interface Variablegroups {
  /** Add a variable group. */
  @tag("Variablegroups")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "variablegroups")
  @extension("x-ms-vss-method", "ShareVariableGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/variablegroups")
  @patch
  ShareVariableGroup(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @query(#{ explode: true }) variableGroupId: int32,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: VariableGroupProjectReference[],
  ): OkResponse;

  /** Add a variable group. */
  @tag("Variablegroups")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "variablegroups")
  @extension("x-ms-vss-method", "AddVariableGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/variablegroups")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: VariableGroupParameters,
  ): VariableGroup;

  /** Delete a variable group */
  @tag("Variablegroups")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "variablegroups")
  @extension("x-ms-vss-method", "DeleteVariableGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/variablegroups/{groupId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of the variable group. */
    @path groupId: int32,

    @format("array (string)") @query(#{ explode: true }) projectIds: string,
    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Update a variable group. */
  @tag("Variablegroups")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "variablegroups")
  @extension("x-ms-vss-method", "UpdateVariableGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/variablegroups/{groupId}")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of the variable group to update. */
    @path groupId: int32,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: VariableGroupParameters,
  ): VariableGroup;

  /** Get variable groups by ids. */
  @tag("Variablegroups")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "variablegroups")
  @extension("x-ms-vss-method", "GetVariableGroupsById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/variablegroups")
  @get
  GetVariableGroupsById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Comma separated list of Ids of variable groups. */
    @format("array (int32)") @query(#{ explode: true }) groupIds: string,

    /** Flag indicating if the secrets within variable groups should be loaded. */
    @query(#{ explode: true }) loadSecrets?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): VariableGroupList;

  /** Get a variable group. */
  @tag("Variablegroups")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "variablegroups")
  @extension("x-ms-vss-method", "GetVariableGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/variablegroups/{groupId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the variable group. */
    @path groupId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): VariableGroup;
}

interface Yamlschema {
  /** GET the Yaml schema used for Yaml file validation. */
  @tag("Yamlschema")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "yamlschema")
  @extension("x-ms-vss-method", "GetYamlSchema")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/distributedtask/yamlschema")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** Whether the schema should validate that tasks are actually installed (useful for offline tools where you don't want validation). */
    @query(#{ explode: true }) validateTaskNames?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<{}>;
}

interface Deploymentgroups {
  /** Get a list of deployment groups by name or IDs. */
  @tag("Deploymentgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "deploymentgroups")
  @extension("x-ms-vss-method", "GetDeploymentGroups")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Name of the deployment group. */
    @query(#{ explode: true }) name?: string,

    /** Get only deployment groups on which this action can be performed. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentGroupActionFilter",
        values: #[
          #{ value: "none", description: "All deployment groups." },
          #{
            value: "manage",
            description: "Only deployment groups for which caller has **manage** permission.",
          },
          #{
            value: "use",
            description: "Only deployment groups for which caller has **use** permission.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",

    /** Include these additional details in the returned objects. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentGroupExpands",
        values: #[
          #{ value: "none", description: "No additional properties." },
          #{ value: "machines", description: "Deprecated: Include all the deployment targets." },
          #{
            value: "tags",
            description: "Include unique list of tags across all deployment targets.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "machines" | "tags",

    /** Get deployment groups with names greater than this continuationToken lexicographically. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Maximum number of deployment groups to return. Default is **1000**. */
    @query(#{ explode: true }) $top?: int32,

    /** Comma separated list of IDs of the deployment groups. */
    @format("array (int32)") @query(#{ explode: true }) ids?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: DeploymentGroupList;
  };

  /** Create a deployment group. */
  @tag("Deploymentgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "deploymentgroups")
  @extension("x-ms-vss-method", "AddDeploymentGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Deployment group to create. */
    @body body: DeploymentGroupCreateParameter,
  ): DeploymentGroup;

  /** Delete a deployment group. */
  @tag("Deploymentgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "deploymentgroups")
  @extension("x-ms-vss-method", "DeleteDeploymentGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group to be deleted. */
    @path deploymentGroupId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a deployment group by its ID. */
  @tag("Deploymentgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "deploymentgroups")
  @extension("x-ms-vss-method", "GetDeploymentGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group. */
    @path deploymentGroupId: int32,

    /** Get the deployment group only if this action can be performed on it. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentGroupActionFilter",
        values: #[
          #{ value: "none", description: "All deployment groups." },
          #{
            value: "manage",
            description: "Only deployment groups for which caller has **manage** permission.",
          },
          #{
            value: "use",
            description: "Only deployment groups for which caller has **use** permission.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",

    /** Include these additional details in the returned object. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentGroupExpands",
        values: #[
          #{ value: "none", description: "No additional properties." },
          #{ value: "machines", description: "Deprecated: Include all the deployment targets." },
          #{
            value: "tags",
            description: "Include unique list of tags across all deployment targets.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "machines" | "tags",

    ...Parameters.`api-Version-preview`.`1`,
  ): DeploymentGroup;

  /** Update a deployment group. */
  @tag("Deploymentgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "deploymentgroups")
  @extension("x-ms-vss-method", "UpdateDeploymentGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group. */
    @path deploymentGroupId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Deployment group to update. */
    @body body: DeploymentGroupUpdateParameter,
  ): DeploymentGroup;
}

interface Targets {
  /** Get a list of deployment targets in a deployment group. */
  @tag("Targets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "targets")
  @extension("x-ms-vss-method", "GetDeploymentTargets")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}/targets")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group. */
    @path deploymentGroupId: int32,

    /** Get only the deployment targets that contain all these comma separted list of tags. */
    @format("array (string)") @query(#{ explode: true }) tags?: string,

    /** Name pattern of the deployment targets to return. */
    @query(#{ explode: true }) name?: string,

    /** When set to true, treats **name** as pattern. Else treats it as absolute match. Default is **false**. */
    @query(#{ explode: true }) partialNameMatch?: boolean,

    /** Include these additional details in the returned objects. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentTargetExpands",
        values: #[
          #{ value: "none", description: "No additional properties." },
          #{ value: "capabilities", description: "Include capabilities of the deployment agent." },
          #{
            value: "assignedRequest",
            description: "Include the job request assigned to the deployment agent.",
          },
          #{
            value: "lastCompletedRequest",
            description: "Include the last completed job request of the deployment agent.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "capabilities" | "assignedRequest" | "lastCompletedRequest",

    /** Get only deployment targets that have this status. */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskAgentStatusFilter",
        values: #[
          #{ value: "offline", description: "Only deployment targets that are offline." },
          #{ value: "online", description: "Only deployment targets that are online." },
          #{ value: "all", description: "All deployment targets." }
        ],
      }
    )
    @query(#{ explode: true })
    agentStatus?: "offline" | "online" | "all",

    /** Get only deployment targets that have this last job result. */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskAgentJobResultFilter",
        values: #[
          #{
            value: "failed",
            description: "Only those deployment targets on which last job failed (**Abandoned**, **Canceled**, **Failed**, **Skipped**).",
          },
          #{
            value: "passed",
            description: "Only those deployment targets on which last job Passed (**Succeeded**, **Succeeded with issues**).",
          },
          #{
            value: "neverDeployed",
            description: "Only those deployment targets that never executed a job.",
          },
          #{ value: "all", description: "All deployment targets." }
        ],
      }
    )
    @query(#{ explode: true })
    agentJobResult?: "failed" | "passed" | "neverDeployed" | "all",

    /** Get deployment targets with names greater than this continuationToken lexicographically. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Maximum number of deployment targets to return. Default is **1000**. */
    @query(#{ explode: true }) $top?: int32,

    /** Get only deployment targets that are enabled or disabled. Default is 'null' which returns all the targets. */
    @query(#{ explode: true }) enabled?: boolean,

    @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: DeploymentMachineList;
  };

  /** Update tags of a list of deployment targets in a deployment group. */
  @tag("Targets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "targets")
  @extension("x-ms-vss-method", "UpdateDeploymentTargets")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}/targets")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group in which deployment targets are updated. */
    @path deploymentGroupId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Deployment targets with tags to udpdate. */
    @body body: DeploymentTargetUpdateParameter[],
  ): DeploymentMachineList;

  /** Delete a deployment target in a deployment group. This deletes the agent from associated deployment pool too. */
  @tag("Targets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "targets")
  @extension("x-ms-vss-method", "DeleteDeploymentTarget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}/targets/{targetId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group in which deployment target is deleted. */
    @path deploymentGroupId: int32,

    /** ID of the deployment target to delete. */
    @path targetId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a deployment target by its ID in a deployment group */
  @tag("Targets")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "targets")
  @extension("x-ms-vss-method", "GetDeploymentTarget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/deploymentgroups/{deploymentGroupId}/targets/{targetId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the deployment group to which deployment target belongs. */
    @path deploymentGroupId: int32,

    /** ID of the deployment target to return. */
    @path targetId: int32,

    /** Include these additional details in the returned objects. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentTargetExpands",
        values: #[
          #{ value: "none", description: "No additional properties." },
          #{ value: "capabilities", description: "Include capabilities of the deployment agent." },
          #{
            value: "assignedRequest",
            description: "Include the job request assigned to the deployment agent.",
          },
          #{
            value: "lastCompletedRequest",
            description: "Include the last completed job request of the deployment agent.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "capabilities" | "assignedRequest" | "lastCompletedRequest",

    ...Parameters.`api-Version-preview`.`1`,
  ): DeploymentMachine;
}

interface Queues {
  /** Get a list of agent queues by pool ids */
  @tag("Queues")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "queues")
  @extension("x-ms-vss-method", "GetAgentQueuesForPools")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/queues")
  @get
  GetAgentQueuesForPools(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** A comma-separated list of pool ids to get the corresponding queues for */
    @format("array (int32)") @query(#{ explode: true }) poolIds: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Filter by whether the calling user has use or manage permissions */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskAgentQueueActionFilter",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "manage", description: "" },
          #{ value: "use", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentQueueList;

  /** Create a new agent queue to connect a project to an agent pool. */
  @tag("Queues")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "queues")
  @extension("x-ms-vss-method", "AddAgentQueue")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/queues")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Automatically authorize this queue when using YAML */
    @query(#{ explode: true }) authorizePipelines?: boolean,

    ...Parameters.`api-Version-preview`.`1`,

    /** Details about the queue to create */
    @body body: TaskAgentQueue,
  ): TaskAgentQueue;

  /** Removes an agent queue from a project. */
  @tag("Queues")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "queues")
  @extension("x-ms-vss-method", "DeleteAgentQueue")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/queues/{queueId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent queue to remove */
    @path queueId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get information about an agent queue. */
  @tag("Queues")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "queues")
  @extension("x-ms-vss-method", "GetAgentQueue")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/queues/{queueId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The agent queue to get information about */
    @path queueId: int32,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Filter by whether the calling user has use or manage permissions */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskAgentQueueActionFilter",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "manage", description: "" },
          #{ value: "use", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",

    ...Parameters.`api-Version-preview`.`1`,
  ): TaskAgentQueue;
}

interface Securefiles {
  /** Get secure files */
  @tag("Securefiles")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securefiles")
  @extension("x-ms-vss-method", "GetSecureFilesByNames")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/securefiles")
  @get
  GetSecureFilesByNames(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** A list of secure file Ids */
    @format("array (string)") @query(#{ explode: true }) secureFileNames: string,

    /** If includeDownloadTickets is true and the caller has permissions, a download ticket for each secure file is included in the response. */
    @query(#{ explode: true }) includeDownloadTickets?: boolean,

    @extension(
      "x-ms-enum",
      #{
        name: "SecureFileActionFilter",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "manage", description: "" },
          #{ value: "use", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",
    ...Parameters.`api-Version-preview`.`1`,
  ): SecureFileList;

  /** Update properties and/or names of a set of secure files. Files are identified by their IDs. Properties provided override the existing one entirely, i.e. do not merge. */
  @tag("Securefiles")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securefiles")
  @extension("x-ms-vss-method", "UpdateSecureFiles")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/securefiles")
  @patch
  UpdateSecureFiles(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** A list of secure file objects. Only three field must be populated Id, Name, and Properties. The rest of fields in the object are ignored. */
    @body body: SecureFile[],
  ): SecureFileList;

  /** Query secure files using a name pattern and a condition on file properties. */
  @tag("Securefiles")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securefiles")
  @extension("x-ms-vss-method", "QuerySecureFilesByProperties")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/securefiles")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Name of the secure file to match. Can include wildcards to match multiple files. */
    @query(#{ explode: true }) namePattern?: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The main condition syntax is described [here](https://go.microsoft.com/fwlink/?linkid=842996). Use the *property('property-name')* function to access the value of the specified property of a secure file. It returns null if the property is not set. E.g. ``` and( eq( property('devices'), '2' ), in( property('provisioning profile type'), 'ad hoc', 'development' ) ) ``` */
    @body body: string,
  ): SecureFileList;

  /** Delete a secure file */
  @tag("Securefiles")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securefiles")
  @extension("x-ms-vss-method", "DeleteSecureFile")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/securefiles/{secureFileId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The unique secure file Id */
    @format("uuid") @path secureFileId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a secure file */
  @tag("Securefiles")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securefiles")
  @extension("x-ms-vss-method", "GetSecureFile")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/securefiles/{secureFileId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The unique secure file Id */
    @format("uuid") @path secureFileId: string,

    /** If includeDownloadTicket is true and the caller has permissions, a download ticket is included in the response. */
    @query(#{ explode: true }) includeDownloadTicket?: boolean,

    @extension(
      "x-ms-enum",
      #{
        name: "SecureFileActionFilter",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "manage", description: "" },
          #{ value: "use", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    actionFilter?: "none" | "manage" | "use",
    ...Parameters.`api-Version-preview`.`1`,
  ): SecureFile;

  /** Update the name or properties of an existing secure file */
  @tag("Securefiles")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securefiles")
  @extension("x-ms-vss-method", "UpdateSecureFile")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/securefiles/{secureFileId}")
  @patch
  UpdateSecureFile(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The unique secure file Id */
    @format("uuid") @path secureFileId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The secure file with updated name and/or properties */
    @body body: SecureFile,
  ): SecureFile;
}

interface Taskgroups {
  /** Create a task group. */
  @tag("Taskgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "taskgroups")
  @extension("x-ms-vss-method", "AddTaskGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/taskgroups")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Task group object to create. */
    @body body: TaskGroupCreateParameter,
  ): TaskGroup;

  /** Delete a task group. */
  @tag("Taskgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "taskgroups")
  @extension("x-ms-vss-method", "DeleteTaskGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/taskgroups/{taskGroupId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the task group to be deleted. */
    @format("uuid") @path taskGroupId: string,

    /** Comments to delete. */
    @query(#{ explode: true }) comment?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** List task groups. */
  @tag("Taskgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "taskgroups")
  @extension("x-ms-vss-method", "GetTaskGroups")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/taskgroups/{taskGroupId}")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the task group. */
    @extension("x-ms-required", false)
    @format("uuid")
    @path
    taskGroupId: string,

    /** 'true' to recursively expand task groups. Default is 'false'. */
    @query(#{ explode: true }) expanded?: boolean,

    /** Guid of the taskId to filter. */
    @format("uuid") @query(#{ explode: true }) taskIdFilter?: string,

    /** 'true'to include deleted task groups. Default is 'false'. */
    @query(#{ explode: true }) deleted?: boolean,

    /** Number of task groups to get. */
    @query(#{ explode: true }) $top?: int32,

    /** Gets the task groups after the continuation token provided. */
    @query(#{ explode: true }) continuationToken?: utcDateTime,

    /** Gets the results in the defined order. Default is 'CreatedOnDescending'. */
    @extension(
      "x-ms-enum",
      #{
        name: "TaskGroupQueryOrder",
        values: #[
          #{ value: "createdOnAscending", description: "Order by createdon ascending." },
          #{ value: "createdOnDescending", description: "Order by createdon descending." }
        ],
      }
    )
    @query(#{ explode: true })
    queryOrder?: "createdOnAscending" | "createdOnDescending",

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TaskGroupList;
  };

  /** Update a task group. */
  @tag("Taskgroups")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "taskgroups")
  @extension("x-ms-vss-method", "UpdateTaskGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/distributedtask/taskgroups/{taskGroupId}")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the task group to update. */
    @extension("x-ms-required", false)
    @format("uuid")
    @path
    taskGroupId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Task group to update. */
    @body body: TaskGroupUpdateParameter,
  ): TaskGroup;
}
