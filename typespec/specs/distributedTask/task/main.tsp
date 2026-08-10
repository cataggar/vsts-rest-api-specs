import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Task" })
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
namespace Task;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
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
    | "dependentOnManualQueue";
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
  state?: "pending" | "inProgress" | "completed";
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
    | "dependentOnManualQueue";
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
  state?: "inProgress" | "queued" | "completed" | "throttled";
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
  type?: "error" | "warning";
}

/** A pipeline job event to be processed by the execution plan. */
model JobEvent {
  /** The ID of the pipeline job affected by the event. */
  @format("uuid") jobId?: string;

  /** The name of the pipeline job event. */
  name?: string;
}

/** Represents a JSON object. */
model JObject {
  @format("JToken") item?: string;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

/** Represents an option that may affect the way an agent runs the job. */
model JobOption {
  data?: Record<string>;

  /** Gets the id of the option. */
  @format("uuid") id?: string;
}

model MaskHint {
  @extension(
    "x-ms-enum",
    #{
      name: "MaskType",
      values: #[#{ value: "variable", description: "" }, #{ value: "regex", description: "" }],
    }
  )
  type?: "variable" | "regex";
  value?: string;
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

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model TaskAgentJob {
  container?: string;
  @format("uuid") id?: string;
  name?: string;
  sidecarContainers?: Record<string>;
  steps?: TaskAgentJobStep[];
  variables?: TaskAgentJobVariable[];
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
  type?: "task" | "action";
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

model TaskHubOidcToken {
  oidcToken?: string;
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
  itemType?: "container" | "job";
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
    | "dependentOnManualQueue";
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
  state?: "inProgress" | "queued" | "completed" | "throttled";
  timeline?: TimelineReference;
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
  status?: "running" | "queued" | "all";
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
    | "dependentOnManualQueue";

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
  state?: "pending" | "inProgress" | "completed";

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

/** A reference to a timeline. */
model TimelineReference {
  /** The change ID. */
  changeId?: int32;

  /** The ID of the timeline. */
  @format("uuid") id?: string;

  /** The REST URL of the timeline. */
  location?: string;
}

/** A wrapper class for a generic variable. */
model VariableValue {
  /** Indicates whether the variable can be changed during script's execution runtime. */
  isReadOnly?: boolean;

  /** Indicates whether the variable should be encrypted at rest. */
  isSecret?: boolean;

  /** The value of the variable. */
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

/** A collection of `TimelineRecord` as returned by Azure DevOps. */
model TimelineRecordList {
  count?: int32;
  value?: TimelineRecord[];
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

interface Webhooks {
  /** Triggers a pipeline run of pipelines which have a webhook resource defined with specified WebHook Name property of the WebHook service connection. */
  @tag("Webhooks")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "webhooks")
  @extension("x-ms-vss-method", "ReceiveExternalEvent")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/public/distributedtask/webhooks/{webHookId}")
  @post
  ReceiveExternalEvent(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The WebHook Name property of the WebHook service connection */
    @path webHookId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;
}

interface Events {
  /** Send a pipeline job event to be processed by the execution plan. */
  @tag("Events")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "events")
  @extension("x-ms-vss-method", "PostEvent")
  @extension("x-ms-preview", true)
  @route("/{organization}/{scopeIdentifier}/_apis/distributedtask/hubs/{hubName}/plans/{planId}/events")
  @post
  PostEvent(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project GUID to scope the request */
    @format("uuid") @path scopeIdentifier: string,

    /** The name of the server hub. Common examples: 'build', 'rm', 'checks' */
    @path hubName: string,

    /** The ID of the plan. */
    @format("uuid") @path planId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The event data to be processed by the plan. */
    @body body: JobEvent,
  ): OkResponse;
}

interface Oidctoken {
  @tag("Oidctoken")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "oidctoken")
  @extension("x-ms-vss-method", "CreateOidcToken")
  @extension("x-ms-preview", true)
  @route("/{organization}/{scopeIdentifier}/_apis/distributedtask/hubs/{hubName}/plans/{planId}/jobs/{jobId}/oidctoken")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project GUID to scope the request */
    @format("uuid") @path scopeIdentifier: string,

    /** The name of the server hub. Common examples: 'build', 'rm', 'checks' */
    @path hubName: string,

    @format("uuid") @path planId: string,
    @format("uuid") @path jobId: string,
    @format("uuid") @query(#{ explode: true }) serviceConnectionId?: string,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: Record<string>,
  ): TaskHubOidcToken;
}

interface Logs {
  /** Create a log and connect it to a pipeline run's execution plan. */
  @tag("Logs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "logs")
  @extension("x-ms-vss-method", "CreateLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/{scopeIdentifier}/_apis/distributedtask/hubs/{hubName}/plans/{planId}/logs")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project GUID to scope the request */
    @format("uuid") @path scopeIdentifier: string,

    /** The name of the server hub. Common examples: 'build', 'rm', 'checks' */
    @path hubName: string,

    /** The ID of the plan. */
    @format("uuid") @path planId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** An object that contains information about log's path. */
    @body body: TaskLog,
  ): TaskLog;

  /** Append a log to a task's log. The log should be sent in the body of the request as a TaskLog object stream. */
  @tag("Logs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "logs")
  @extension("x-ms-vss-method", "AppendLogContent")
  @extension("x-ms-preview", true)
  @route("/{organization}/{scopeIdentifier}/_apis/distributedtask/hubs/{hubName}/plans/{planId}/logs/{logId}")
  @post
  AppendLogContent(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project GUID to scope the request */
    @format("uuid") @path scopeIdentifier: string,

    /** The name of the server hub. Common examples: 'build', 'rm', 'checks' */
    @path hubName: string,

    /** The ID of the plan. */
    @format("uuid") @path planId: string,

    /** The ID of the log. */
    @path logId: int32,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/octet-stream",

    /** Stream to upload */
    @body body: string,
  ): TaskLog;
}

interface Records {
  /** Update timeline records if they already exist, otherwise create new ones for the same timeline. */
  @tag("Records")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "records")
  @extension("x-ms-vss-method", "UpdateRecords")
  @extension("x-ms-preview", true)
  @route("/{organization}/{scopeIdentifier}/_apis/distributedtask/hubs/{hubName}/plans/{planId}/timelines/{timelineId}/records")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project GUID to scope the request */
    @format("uuid") @path scopeIdentifier: string,

    /** The name of the server hub. Common examples: 'build', 'rm', 'checks' */
    @path hubName: string,

    /** The ID of the plan. */
    @format("uuid") @path planId: string,

    /** The ID of the timeline. */
    @format("uuid") @path timelineId: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** The array of timeline records to be updated. */
    @body body: VssJsonCollectionWrapper,
  ): TimelineRecordList;
}
