import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Build" })
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
namespace Build;

/** Represents a queue for running builds. */
model AgentPoolQueue {
  _links?: ReferenceLinks;

  /** The ID of the queue. */
  id?: int32;

  /** The name of the queue. */
  name?: string;

  pool?: TaskAgentPoolReference;

  /** The full http link to the resource. */
  url?: string;
}

/** Represents a reference to an agent queue. */
model AgentPoolQueueReference {
  ...ResourceReference;

  /** The ID of the queue. */
  id?: int32;
}

/** Describes how a phase should run against an agent queue. */
model AgentPoolQueueTarget {
  ...PhaseTarget;
  agentSpecification?: AgentSpecification;

  /** Enables scripts and other processes launched while executing phase to access the OAuth token */
  allowScriptsAuthAccessOption?: boolean;

  demands?: Demand[];
  executionOptions?: AgentTargetExecutionOptions;
  queue?: AgentPoolQueue;
}

/** Specification of the agent defined by the pool provider. */
model AgentSpecification {
  /** Agent specification unique identifier. */
  identifier?: string;
}

/** Additional options for running phases against an agent queue. */
model AgentTargetExecutionOptions {
  /** Indicates the type of execution options. */
  type?: int32;
}

model AggregatedResultsAnalysis {
  @format("TimeSpan") duration?: string;
  notReportedResultsByOutcome?: Record<AggregatedResultsByOutcome>;
  previousContext?: TestResultsContext;
  resultsByOutcome?: Record<AggregatedResultsByOutcome>;
  resultsDifference?: AggregatedResultsDifference;
  runSummaryByOutcome?: Record<AggregatedRunsByOutcome>;
  runSummaryByState?: Record<AggregatedRunsByState>;
  totalTests?: int32;
}

model AggregatedResultsByOutcome {
  count?: int32;
  @format("TimeSpan") duration?: string;
  groupByField?: string;
  groupByValue?: {};
  @extension(
    "x-ms-enum",
    #{
      name: "TestOutcome",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{
          value: "none",
          description: "Test has not been completed, or the test type does not report pass/failure.",
        },
        #{ value: "passed", description: "Test was executed w/o any issues." },
        #{
          value: "failed",
          description: "Test was executed, but there were issues. Issues may involve exceptions or failed assertions.",
        },
        #{
          value: "inconclusive",
          description: "Test has completed, but we can't say if it passed or failed. May be used for aborted tests...",
        },
        #{ value: "timeout", description: "The test timed out" },
        #{
          value: "aborted",
          description: "Test was aborted. This was not caused by a user gesture, but rather by a framework decision.",
        },
        #{
          value: "blocked",
          description: "Test had it chance for been executed but was not, as ITestElement.IsRunnable == false.",
        },
        #{
          value: "notExecuted",
          description: "Test was not executed. This was caused by a user gesture - e.g. user hit stop button.",
        },
        #{
          value: "warning",
          description: "To be used by Run level results. This is not a failure.",
        },
        #{
          value: "error",
          description: "There was a system error while we were trying to execute a test.",
        },
        #{ value: "notApplicable", description: "Test is Not Applicable for execution." },
        #{ value: "paused", description: "Test is paused." },
        #{
          value: "inProgress",
          description: "Test is currently executing. Added this for TCM charts",
        },
        #{ value: "notImpacted", description: "Test is not impacted. Added fot TIA." }
      ],
    }
  )
  outcome?:
    | "unspecified"
    | "none"
    | "passed"
    | "failed"
    | "inconclusive"
    | "timeout"
    | "aborted"
    | "blocked"
    | "notExecuted"
    | "warning"
    | "error"
    | "notApplicable"
    | "paused"
    | "inProgress"
    | "notImpacted";
  rerunResultCount?: int32;
}

model AggregatedResultsDifference {
  @format("TimeSpan") increaseInDuration?: string;
  increaseInFailures?: int32;
  increaseInNonImpactedTests?: int32;
  increaseInOtherTests?: int32;
  increaseInPassedTests?: int32;
  increaseInTotalTests?: int32;
}

model AggregatedRunsByOutcome {
  @extension(
    "x-ms-enum",
    #{
      name: "TestRunOutcome",
      values: #[
        #{
          value: "passed",
          description: "Run with zero failed tests and has at least one impacted test",
        },
        #{ value: "failed", description: "Run with at-least one failed test." },
        #{ value: "notImpacted", description: "Run with no impacted tests." },
        #{ value: "others", description: "Runs with All tests in other category." }
      ],
    }
  )
  outcome?: "passed" | "failed" | "notImpacted" | "others";
  runsCount?: int32;
}

model AggregatedRunsByState {
  resultsByOutcome?: Record<AggregatedResultsByOutcome>;
  runsCount?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "TestRunState",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{
          value: "notStarted",
          description: "The run is still being created. No tests have started yet.",
        },
        #{ value: "inProgress", description: "Tests are running." },
        #{ value: "completed", description: "All tests have completed or been skipped." },
        #{ value: "aborted", description: "Run is stopped and remaining tests have been aborted" },
        #{
          value: "waiting",
          description: "Run is currently initializing This is a legacy state and should not be used any more",
        },
        #{
          value: "needsInvestigation",
          description: "Run requires investigation because of a test point failure This is a legacy state and should not be used any more",
        }
      ],
    }
  )
  state?:
    | "unspecified"
    | "notStarted"
    | "inProgress"
    | "completed"
    | "aborted"
    | "waiting"
    | "needsInvestigation";
}

model ArtifactResource {
  _links?: ReferenceLinks;

  /** Type-specific data about the artifact. */
  data?: string;

  /** A link to download the resource. */
  downloadUrl?: string;

  /** Type-specific properties of the artifact. */
  properties?: Record<string>;

  /** The type of the resource: File container, version control folder, UNC path, etc. */
  type?: string;

  /** The full http link to the resource. */
  url?: string;
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

/** Represents an attachment to a build. */
model Attachment {
  _links?: ReferenceLinks;

  /** The name of the attachment. */
  name?: string;
}

model AuthorizationHeader {
  name?: string;
  value?: string;
}

/** Data representation of a build. */
model Build {
  _links?: ReferenceLinks;
  agentSpecification?: AgentSpecification;

  /** Append Commit Message To BuildNumber in UI. */
  appendCommitMessageToRunName?: boolean;

  /** The build number/name of the build. */
  buildNumber?: string;

  /** The build number revision. */
  buildNumberRevision?: int32;

  controller?: BuildController;
  definition?: DefinitionReference;

  /** Indicates whether the build has been deleted. */
  deleted?: boolean;

  deletedBy?: IdentityRef;

  /** The date the build was deleted. */
  deletedDate?: utcDateTime;

  /** The description of how the build was deleted. */
  deletedReason?: string;

  /** A list of demands that represents the agent capabilities required by this build. */
  demands?: Demand[];

  /** The time that the build was completed. */
  finishTime?: utcDateTime;

  /** The ID of the build. */
  id?: int32;

  lastChangedBy?: IdentityRef;

  /** The date the build was last changed. */
  lastChangedDate?: utcDateTime;

  logs?: BuildLogReference;
  orchestrationPlan?: TaskOrchestrationPlanReference;

  /** The parameters for the build. */
  parameters?: string;

  /** Orchestration plans associated with the build (build, cleanup) */
  plans?: TaskOrchestrationPlanReference[];

  /** Azure Pipelines does not support job priority. This field is deprecated. */
  @extension(
    "x-ms-enum",
    #{
      name: "QueuePriority",
      values: #[
        #{ value: "low", description: "Low priority." },
        #{ value: "belowNormal", description: "Below normal priority." },
        #{ value: "normal", description: "Normal priority." },
        #{ value: "aboveNormal", description: "Above normal priority." },
        #{ value: "high", description: "High priority." }
      ],
    }
  )
  priority?: "low" | "belowNormal" | "normal" | "aboveNormal" | "high";

  project?: TeamProjectReference;
  properties?: PropertiesCollection;

  /** The quality of the xaml build (good, bad, etc.) */
  quality?: string;

  queue?: AgentPoolQueue;

  /** Additional options for queueing the build. */
  @extension(
    "x-ms-enum",
    #{
      name: "QueueOptions",
      values: #[
        #{ value: "none", description: "No queue options" },
        #{ value: "doNotRun", description: "Create a plan Id for the build, do not run it" }
      ],
    }
  )
  queueOptions?: "none" | "doNotRun";

  /** The current position of the build in the queue. */
  queuePosition?: int32;

  /** The time that the build was queued. */
  queueTime?: utcDateTime;

  /** The reason that the build was created. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildReason",
      values: #[
        #{ value: "none", description: "No reason. This value should not be used." },
        #{ value: "manual", description: "The build was started manually." },
        #{
          value: "individualCI",
          description: "The build was started for the trigger TriggerType.ContinuousIntegration.",
        },
        #{
          value: "batchedCI",
          description: "The build was started for the trigger TriggerType.BatchedContinuousIntegration.",
        },
        #{
          value: "schedule",
          description: "The build was started for the trigger TriggerType.Schedule.",
        },
        #{
          value: "scheduleForced",
          description: "The build was started for the trigger TriggerType.ScheduleForced.",
        },
        #{ value: "userCreated", description: "The build was created by a user." },
        #{
          value: "validateShelveset",
          description: "The build was started manually for private validation.",
        },
        #{
          value: "checkInShelveset",
          description: "The build was started for the trigger ContinuousIntegrationType.Gated.",
        },
        #{
          value: "pullRequest",
          description: "The build was started by a pull request. Added in resource version 3.",
        },
        #{
          value: "buildCompletion",
          description: "The build was started when another build completed.",
        },
        #{
          value: "resourceTrigger",
          description: "The build was started when resources in pipeline triggered it",
        },
        #{
          value: "triggered",
          description: "The build was triggered for retention policy purposes.",
        },
        #{ value: "all", description: "All reasons." }
      ],
    }
  )
  reason?:
    | "none"
    | "manual"
    | "individualCI"
    | "batchedCI"
    | "schedule"
    | "scheduleForced"
    | "userCreated"
    | "validateShelveset"
    | "checkInShelveset"
    | "pullRequest"
    | "buildCompletion"
    | "resourceTrigger"
    | "triggered"
    | "all";

  repository?: BuildRepository;
  requestedBy?: IdentityRef;
  requestedFor?: IdentityRef;

  /** The build result. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildResult",
      values: #[
        #{ value: "none", description: "No result" },
        #{ value: "succeeded", description: "The build completed successfully." },
        #{
          value: "partiallySucceeded",
          description: "The build completed compilation successfully but had other errors.",
        },
        #{ value: "failed", description: "The build completed unsuccessfully." },
        #{ value: "canceled", description: "The build was canceled before starting." }
      ],
    }
  )
  result?: "none" | "succeeded" | "partiallySucceeded" | "failed" | "canceled";

  /** Indicates whether the build is retained by a release. */
  retainedByRelease?: boolean;

  /** The source branch. */
  sourceBranch?: string;

  /** The source version. */
  sourceVersion?: string;

  /** The time that the build was started. */
  startTime?: utcDateTime;

  /** The status of the build. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildStatus",
      values: #[
        #{ value: "none", description: "No status." },
        #{ value: "inProgress", description: "The build is currently in progress." },
        #{ value: "completed", description: "The build has completed." },
        #{ value: "cancelling", description: "The build is cancelling" },
        #{ value: "postponed", description: "The build is inactive in the queue." },
        #{ value: "abandoned", description: "The build has been abandoned." },
        #{ value: "notStarted", description: "The build has not yet started." },
        #{ value: "all", description: "All status." }
      ],
    }
  )
  status?:
    | "none"
    | "inProgress"
    | "completed"
    | "cancelling"
    | "postponed"
    | "abandoned"
    | "notStarted"
    | "all";

  tags?: string[];

  /** Parameters to template expression evaluation */
  templateParameters?: Record<string>;

  triggeredByBuild?: Build;

  /** Sourceprovider-specific information about what triggered the build */
  triggerInfo?: Record<string>;

  /** The URI of the build. */
  uri?: string;

  /** The REST URL of the build. */
  url?: string;

  validationResults?: BuildRequestValidationResult[];
}

model BuildAgent {
  buildDirectory?: string;
  controller?: XamlBuildControllerReference;
  createdDate?: utcDateTime;
  description?: string;
  enabled?: boolean;
  id?: int32;
  messageQueueUrl?: string;
  name?: string;
  reservedForBuild?: string;
  server?: XamlBuildServerReference;
  @extension(
    "x-ms-enum",
    #{
      name: "AgentStatus",
      values: #[
        #{
          value: "unavailable",
          description: "Indicates that the build agent cannot be contacted.",
        },
        #{
          value: "available",
          description: "Indicates that the build agent is currently available.",
        },
        #{
          value: "offline",
          description: "Indicates that the build agent has taken itself offline.",
        }
      ],
    }
  )
  status?: "unavailable" | "available" | "offline";
  statusMessage?: string;
  updatedDate?: utcDateTime;
  uri?: string;
  url?: string;
}

model BuildAgentReference {
  /** Id of the resource */
  id?: int32;

  /** Name of the linked resource (definition name, controller name, etc.) */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

/** Represents an artifact produced by a build. */
model BuildArtifact {
  /** The artifact ID. */
  id?: int32;

  /** The name of the artifact. */
  name?: string;

  resource?: ArtifactResource;

  /** The artifact source, which will be the ID of the job that produced this artifact. If an artifact is associated with multiple sources, this points to the first source. */
  source?: string;
}

/** Represents a build badge. */
model BuildBadge {
  /** The ID of the build represented by this badge. */
  buildId?: int32;

  /** A link to the SVG resource. */
  imageUrl?: string;
}

model BuildCompletedEvent {
  ...BuildUpdatedEvent;

  /** Changes associated with a build used for build notifications */
  changes?: Change[];

  pullRequest?: PullRequest;
  testResults?: AggregatedResultsAnalysis;

  /** Timeline records associated with a build used for build notifications */
  timelineRecords?: TimelineRecord[];

  /** Work items associated with a build used for build notifications */
  workItems?: AssociatedWorkItem[];
}

/** Represents a build completion trigger. */
model BuildCompletionTrigger {
  ...BuildTrigger;
  branchFilters?: string[];
  definition?: DefinitionReference;
  requiresSuccessfulBuild?: boolean;
}

model BuildController {
  ...XamlBuildControllerReference;
  _links?: ReferenceLinks;

  /** The date the controller was created. */
  createdDate?: utcDateTime;

  /** The description of the controller. */
  description?: string;

  /** Indicates whether the controller is enabled. */
  enabled?: boolean;

  /** The status of the controller. */
  @extension(
    "x-ms-enum",
    #{
      name: "ControllerStatus",
      values: #[
        #{
          value: "unavailable",
          description: "Indicates that the build controller cannot be contacted.",
        },
        #{
          value: "available",
          description: "Indicates that the build controller is currently available.",
        },
        #{
          value: "offline",
          description: "Indicates that the build controller has taken itself offline.",
        }
      ],
    }
  )
  status?: "unavailable" | "available" | "offline";

  /** The date the controller was last updated. */
  updatedDate?: utcDateTime;

  /** The controller's URI. */
  uri?: string;
}

/** Represents a build definition. */
model BuildDefinition {
  ...BuildDefinitionReference;

  /** Indicates whether badges are enabled for this definition. */
  badgeEnabled?: boolean;

  /** The build number format. */
  buildNumberFormat?: string;

  /** A save-time comment for the definition. */
  comment?: string;

  demands?: Demand[];

  /** The description. */
  description?: string;

  /** The drop location for the definition. */
  dropLocation?: string;

  /** The job authorization scope for builds queued against this definition. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildAuthorizationScope",
      values: #[
        #{
          value: "projectCollection",
          description: "The identity used should have build service account permissions scoped to the project collection. This is useful when resources for a single build are spread across multiple projects.",
        },
        #{
          value: "project",
          description: "The identity used should have build service account permissions scoped to the project in which the build definition resides. This is useful for isolation of build jobs to a particular team project to avoid any unintentional escalation of privilege attacks during a build.",
        }
      ],
    }
  )
  jobAuthorizationScope?: "projectCollection" | "project";

  /** The job cancel timeout (in minutes) for builds cancelled by user for this definition. */
  jobCancelTimeoutInMinutes?: int32;

  /** The job execution timeout (in minutes) for builds queued against this definition. */
  jobTimeoutInMinutes?: int32;

  options?: BuildOption[];
  process?: BuildProcess;
  processParameters?: ProcessParameters;
  properties?: PropertiesCollection;
  repository?: BuildRepository;
  retentionRules?: RetentionPolicy[];
  tags?: string[];
  triggers?: BuildTrigger[];
  variableGroups?: VariableGroup[];
  variables?: Record<BuildDefinitionVariable>;
}

/** For back-compat with extensions that use the old Steps format instead of Process and Phases */
model BuildDefinition3_2 {
  ...BuildDefinitionReference3_2;

  /** Indicates whether badges are enabled for this definition */
  badgeEnabled?: boolean;

  build?: BuildDefinitionStep[];

  /** The build number format */
  buildNumberFormat?: string;

  /** The comment entered when saving the definition */
  comment?: string;

  demands?: Demand[];

  /** The description */
  description?: string;

  /** The drop location for the definition */
  dropLocation?: string;

  /** The job authorization scope for builds which are queued against this definition */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildAuthorizationScope",
      values: #[
        #{
          value: "projectCollection",
          description: "The identity used should have build service account permissions scoped to the project collection. This is useful when resources for a single build are spread across multiple projects.",
        },
        #{
          value: "project",
          description: "The identity used should have build service account permissions scoped to the project in which the build definition resides. This is useful for isolation of build jobs to a particular team project to avoid any unintentional escalation of privilege attacks during a build.",
        }
      ],
    }
  )
  jobAuthorizationScope?: "projectCollection" | "project";

  /** The job cancel timeout in minutes for builds which are cancelled by user for this definition */
  jobCancelTimeoutInMinutes?: int32;

  /** The job execution timeout in minutes for builds which are queued against this definition */
  jobTimeoutInMinutes?: int32;

  latestBuild?: Build;
  latestCompletedBuild?: Build;
  options?: BuildOption[];
  processParameters?: ProcessParameters;
  properties?: PropertiesCollection;
  repository?: BuildRepository;
  retentionRules?: RetentionPolicy[];
  tags?: string[];
  triggers?: BuildTrigger[];
  variables?: Record<BuildDefinitionVariable>;
}

/** Represents a reference to a build definition. */
model BuildDefinitionReference {
  ...DefinitionReference;
  _links?: ReferenceLinks;
  authoredBy?: IdentityRef;
  draftOf?: DefinitionReference;

  /** The list of drafts associated with this definition, if this is not a draft definition. */
  drafts?: DefinitionReference[];

  latestBuild?: Build;
  latestCompletedBuild?: Build;
  metrics?: BuildMetric[];

  /** The quality of the definition document (draft, etc.) */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionQuality",
      values: #[#{ value: "definition", description: "" }, #{ value: "draft", description: "" }],
    }
  )
  quality?: "definition" | "draft";

  queue?: AgentPoolQueue;
}

/** For back-compat with extensions that use the old Steps format instead of Process and Phases */
model BuildDefinitionReference3_2 {
  ...DefinitionReference;
  _links?: ReferenceLinks;
  authoredBy?: IdentityRef;
  draftOf?: DefinitionReference;

  /** The list of drafts associated with this definition, if this is not a draft definition. */
  drafts?: DefinitionReference[];

  metrics?: BuildMetric[];

  /** The quality of the definition document (draft, etc.) */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionQuality",
      values: #[#{ value: "definition", description: "" }, #{ value: "draft", description: "" }],
    }
  )
  quality?: "definition" | "draft";

  queue?: AgentPoolQueue;
}

/** Represents a revision of a build definition. */
model BuildDefinitionRevision {
  changedBy?: IdentityRef;

  /** The date and time that the definition was changed. */
  changedDate?: utcDateTime;

  /** The change type (add, edit, delete). */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditAction",
      values: #[
        #{ value: "add", description: "" },
        #{ value: "update", description: "" },
        #{ value: "delete", description: "" }
      ],
    }
  )
  changeType?: "add" | "update" | "delete";

  /** The comment associated with the change. */
  comment?: string;

  /** A link to the definition at this revision. */
  definitionUrl?: string;

  /** The name of the definition. */
  name?: string;

  /** The revision number. */
  revision?: int32;
}

model BuildDefinitionSourceProvider {
  /** Uri of the associated definition */
  definitionUri?: string;

  /** fields associated with this build definition */
  fields?: Record<string>;

  /** Id of this source provider */
  id?: int32;

  /** The lst time this source provider was modified */
  lastModified?: utcDateTime;

  /** Name of the source provider */
  name?: string;

  /** Which trigger types are supported by this definition source provider */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionTriggerType",
      values: #[
        #{ value: "none", description: "Manual builds only." },
        #{
          value: "continuousIntegration",
          description: "A build should be started for each changeset.",
        },
        #{
          value: "batchedContinuousIntegration",
          description: "A build should be started for multiple changesets at a time at a specified interval.",
        },
        #{
          value: "schedule",
          description: "A build should be started on a specified schedule whether or not changesets exist.",
        },
        #{
          value: "gatedCheckIn",
          description: "A validation build should be started for each check-in.",
        },
        #{
          value: "batchedGatedCheckIn",
          description: "A validation build should be started for each batch of check-ins.",
        },
        #{
          value: "pullRequest",
          description: "A build should be triggered when a GitHub pull request is created or updated. Added in resource version 3",
        },
        #{
          value: "buildCompletion",
          description: "A build should be triggered when another build completes.",
        },
        #{ value: "all", description: "All types." }
      ],
    }
  )
  supportedTriggerTypes?:
    | "none"
    | "continuousIntegration"
    | "batchedContinuousIntegration"
    | "schedule"
    | "gatedCheckIn"
    | "batchedGatedCheckIn"
    | "pullRequest"
    | "buildCompletion"
    | "all";
}

/** Represents a step in a build phase. */
model BuildDefinitionStep {
  /** Indicates whether this step should run even if a previous step fails. */
  alwaysRun?: boolean;

  /** A condition that determines whether this step should run. */
  condition?: string;

  /** Indicates whether the phase should continue even if this step fails. */
  continueOnError?: boolean;

  /** The display name for this step. */
  displayName?: string;

  /** Indicates whether the step is enabled. */
  enabled?: boolean;

  environment?: Record<string>;
  inputs?: Record<string>;

  /** The reference name for this step. */
  refName?: string;

  /** Number of retries. */
  retryCountOnTaskFailure?: int32;

  task?: TaskDefinitionReference;

  /** The time, in minutes, that this step is allowed to run. */
  timeoutInMinutes?: int32;
}

/** Represents a template from which new build definitions can be created. */
model BuildDefinitionTemplate {
  /** Indicates whether the template can be deleted. */
  canDelete?: boolean;

  /** The template category. */
  category?: string;

  /** An optional hosted agent queue for the template to use by default. */
  defaultHostedQueue?: string;

  /** A description of the template. */
  description?: string;

  icons?: Record<string>;

  /** The ID of the task whose icon is used when showing this template in the UI. */
  @format("uuid") iconTaskId?: string;

  /** The ID of the template. */
  id?: string;

  /** The name of the template. */
  name?: string;

  template?: BuildDefinition;
}

/** For back-compat with extensions that use the old Steps format instead of Process and Phases */
model BuildDefinitionTemplate3_2 {
  canDelete?: boolean;
  category?: string;
  defaultHostedQueue?: string;
  description?: string;
  icons?: Record<string>;
  @format("uuid") iconTaskId?: string;
  id?: string;
  name?: string;
  template?: BuildDefinition3_2;
}

/** Represents a variable used by a build definition. */
model BuildDefinitionVariable {
  /** Indicates whether the value can be set at queue time. */
  allowOverride?: boolean;

  /** Indicates whether the variable's value is a secret. */
  isSecret?: boolean;

  /** The value of the variable. */
  value?: string;
}

model BuildDeletedEvent {
  ...RealtimeBuildEvent;
  build?: Build;
}

model BuildDeployment {
  deployment?: BuildSummary;
  sourceBuild?: XamlBuildReference;
}

model BuildEvent {
  data?: string[];
  identifier?: string;
}

/** Represents a build log. */
model BuildLog {
  ...BuildLogReference;

  /** The date and time the log was created. */
  createdOn?: utcDateTime;

  /** The date and time the log was last changed. */
  lastChangedOn?: utcDateTime;

  /** The number of lines in the log. */
  lineCount?: int64;
}

/** Represents a reference to a build log. */
model BuildLogReference {
  /** The ID of the log. */
  id?: int32;

  /** The type of the log location. */
  type?: string;

  /** A full link to the log resource. */
  url?: string;
}

/** Represents metadata about builds in the system. */
model BuildMetric {
  /** The date for the scope. */
  date?: utcDateTime;

  /** The value. */
  intValue?: int32;

  /** The name of the metric. */
  name?: string;

  /** The scope. */
  scope?: string;
}

/** Represents the application of an optional behavior to a build definition. */
model BuildOption {
  definition?: BuildOptionDefinitionReference;

  /** Indicates whether the behavior is enabled. */
  enabled?: boolean;

  inputs?: Record<string>;
}

/** Represents an optional behavior that can be applied to a build definition. */
model BuildOptionDefinition {
  ...BuildOptionDefinitionReference;

  /** The description. */
  description?: string;

  /** The list of input groups defined for the build option. */
  groups?: BuildOptionGroupDefinition[];

  /** The list of inputs defined for the build option. */
  inputs?: BuildOptionInputDefinition[];

  /** The name of the build option. */
  name?: string;

  /** A value that indicates the relative order in which the behavior should be applied. */
  ordinal?: int32;
}

/** Represents a reference to a build option definition. */
model BuildOptionDefinitionReference {
  /** The ID of the referenced build option. */
  @format("uuid") id?: string;
}

/** Represents a group of inputs for a build option. */
model BuildOptionGroupDefinition {
  /** The name of the group to display in the UI. */
  displayName?: string;

  /** Indicates whether the group is initially displayed as expanded in the UI. */
  isExpanded?: boolean;

  /** The internal name of the group. */
  name?: string;
}

/** Represents an input for a build option. */
model BuildOptionInputDefinition {
  /** The default value. */
  defaultValue?: string;

  /** The name of the input group that this input belongs to. */
  groupName?: string;

  help?: Record<string>;

  /** The label for the input. */
  label?: string;

  /** The name of the input. */
  name?: string;

  options?: Record<string>;

  /** Indicates whether the input is required to have a value. */
  required?: boolean;

  /** Indicates the type of the input value. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildOptionInputType",
      values: #[
        #{ value: "string", description: "" },
        #{ value: "boolean", description: "" },
        #{ value: "stringList", description: "" },
        #{ value: "radio", description: "" },
        #{ value: "pickList", description: "" },
        #{ value: "multiLine", description: "" },
        #{ value: "branchFilter", description: "" }
      ],
    }
  )
  type?: "string" | "boolean" | "stringList" | "radio" | "pickList" | "multiLine" | "branchFilter";

  /** The rule that is applied to determine whether the input is visible in the UI. */
  visibleRule?: string;
}

/** Represents a build process. */
model BuildProcess {
  /** The type of the process. */
  type?: int32;
}

/** Represents resources used by a build process. */
model BuildProcessResources {
  endpoints?: ServiceEndpointReference[];
  files?: SecureFileReference[];
  queues?: AgentPoolQueueReference[];
  variableGroups?: VariableGroupReference[];
}

model BuildProcessTemplate {
  description?: string;
  fileExists?: boolean;
  id?: int32;
  parameters?: string;
  serverPath?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "BuildReason",
      values: #[
        #{ value: "none", description: "No reason. This value should not be used." },
        #{ value: "manual", description: "The build was started manually." },
        #{
          value: "individualCI",
          description: "The build was started for the trigger TriggerType.ContinuousIntegration.",
        },
        #{
          value: "batchedCI",
          description: "The build was started for the trigger TriggerType.BatchedContinuousIntegration.",
        },
        #{
          value: "schedule",
          description: "The build was started for the trigger TriggerType.Schedule.",
        },
        #{
          value: "scheduleForced",
          description: "The build was started for the trigger TriggerType.ScheduleForced.",
        },
        #{ value: "userCreated", description: "The build was created by a user." },
        #{
          value: "validateShelveset",
          description: "The build was started manually for private validation.",
        },
        #{
          value: "checkInShelveset",
          description: "The build was started for the trigger ContinuousIntegrationType.Gated.",
        },
        #{
          value: "pullRequest",
          description: "The build was started by a pull request. Added in resource version 3.",
        },
        #{
          value: "buildCompletion",
          description: "The build was started when another build completed.",
        },
        #{
          value: "resourceTrigger",
          description: "The build was started when resources in pipeline triggered it",
        },
        #{
          value: "triggered",
          description: "The build was triggered for retention policy purposes.",
        },
        #{ value: "all", description: "All reasons." }
      ],
    }
  )
  supportedReasons?:
    | "none"
    | "manual"
    | "individualCI"
    | "batchedCI"
    | "schedule"
    | "scheduleForced"
    | "userCreated"
    | "validateShelveset"
    | "checkInShelveset"
    | "pullRequest"
    | "buildCompletion"
    | "resourceTrigger"
    | "triggered"
    | "all";
  teamProject?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ProcessTemplateType",
      values: #[
        #{ value: "custom", description: "Indicates a custom template." },
        #{ value: "default", description: "Indicates a default template." },
        #{ value: "upgrade", description: "Indicates an upgrade template." }
      ],
    }
  )
  templateType?: "custom" | "default" | "upgrade";
  url?: string;
  version?: string;
}

model BuildQueuedEvent {
  ...BuildUpdatedEvent;
}

/** Represents a reference to a build. */
model BuildReference {
  _links?: ReferenceLinks;

  /** The build number. */
  buildNumber?: string;

  /** Indicates whether the build has been deleted. */
  deleted?: boolean;

  /** The time that the build was completed. */
  finishTime?: utcDateTime;

  /** The ID of the build. */
  id?: int32;

  /** The time that the build was queued. */
  queueTime?: utcDateTime;

  requestedFor?: IdentityRef;

  /** The build result. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildResult",
      values: #[
        #{ value: "none", description: "No result" },
        #{ value: "succeeded", description: "The build completed successfully." },
        #{
          value: "partiallySucceeded",
          description: "The build completed compilation successfully but had other errors.",
        },
        #{ value: "failed", description: "The build completed unsuccessfully." },
        #{ value: "canceled", description: "The build was canceled before starting." }
      ],
    }
  )
  result?: "none" | "succeeded" | "partiallySucceeded" | "failed" | "canceled";

  /** The time that the build was started. */
  startTime?: utcDateTime;

  /** The build status. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildStatus",
      values: #[
        #{ value: "none", description: "No status." },
        #{ value: "inProgress", description: "The build is currently in progress." },
        #{ value: "completed", description: "The build has completed." },
        #{ value: "cancelling", description: "The build is cancelling" },
        #{ value: "postponed", description: "The build is inactive in the queue." },
        #{ value: "abandoned", description: "The build has been abandoned." },
        #{ value: "notStarted", description: "The build has not yet started." },
        #{ value: "all", description: "All status." }
      ],
    }
  )
  status?:
    | "none"
    | "inProgress"
    | "completed"
    | "cancelling"
    | "postponed"
    | "abandoned"
    | "notStarted"
    | "all";
}

/** Represents information about a build report. */
model BuildReportMetadata {
  /** The Id of the build. */
  buildId?: int32;

  /** The content of the report. */
  content?: string;

  /** The type of the report. */
  type?: string;
}

/** Represents a repository used by a build definition. */
model BuildRepository {
  /** Indicates whether to checkout submodules. */
  checkoutSubmodules?: boolean;

  /** Indicates whether to clean the target folder when getting code from the repository. */
  clean?: string;

  /** The name of the default branch. */
  defaultBranch?: string;

  /** The ID of the repository. */
  id?: string;

  /** The friendly name of the repository. */
  name?: string;

  properties?: Record<string>;

  /** The root folder. */
  rootFolder?: string;

  /** The type of the repository. */
  type?: string;

  /** The URL of the repository. */
  url?: string;
}

/** Represents the result of validating a build request. */
model BuildRequestValidationResult {
  /** The message associated with the result. */
  message?: string;

  /** The result. */
  @extension(
    "x-ms-enum",
    #{
      name: "ValidationResult",
      values: #[
        #{ value: "ok", description: "" },
        #{ value: "warning", description: "" },
        #{ value: "error", description: "" }
      ],
    }
  )
  result?: "ok" | "warning" | "error";
}

/** Represents information about resources used by builds in the system. */
model BuildResourceUsage {
  /** The number of build agents. */
  distributedTaskAgents?: int32;

  /** The number of paid private agent slots. */
  paidPrivateAgentSlots?: int32;

  /** The total usage. */
  totalUsage?: int32;

  /** The number of XAML controllers. */
  xamlControllers?: int32;
}

/** A historical overview of build retention information. This includes a list of snapshots taken about build retention usage, and a list of builds that have exceeded the default 30 day retention policy. */
model BuildRetentionHistory {
  /** A list of builds that are older than the default retention policy, but are not marked as retained. Something is causing these builds to not get cleaned up. */
  buildRetentionSamples?: BuildRetentionSample[];
}

/** A snapshot of build retention information. This class takes a sample at the given time. It provides information about retained builds, files associated with those retained builds, and number of files being retained. */
model BuildRetentionSample {
  /** Summary of retention by build */
  builds?: string;

  /** List of build definitions */
  definitions?: string;

  /** Summary of files consumed by retained builds */
  files?: string;

  /** The date and time when the sample was taken */
  sampleTime?: utcDateTime;
}

model BuildsDeletedEvent {
  ...BuildsDeletedEvent1;
}

model BuildsDeletedEvent1 {
  buildIds?: int32[];

  /** The ID of the definition. */
  definitionId?: int32;

  /** The ID of the project. */
  @format("uuid") projectId?: string;
}

model BuildServer {
  agents?: BuildAgentReference[];
  controller?: XamlBuildControllerReference;
  id?: int32;
  isVirtual?: boolean;
  messageQueueUrl?: string;
  name?: string;
  requireClientCertificates?: boolean;
  @extension(
    "x-ms-enum",
    #{
      name: "ServiceHostStatus",
      values: #[
        #{
          value: "online",
          description: "The service host is currently connected and accepting commands.",
        },
        #{
          value: "offline",
          description: "The service host is currently disconnected and not accepting commands.",
        }
      ],
    }
  )
  status?: "online" | "offline";
  statusChangedDate?: utcDateTime;
  uri?: string;
  url?: string;
  version?: int32;
}

/** Represents system-wide build settings. */
model BuildSettings {
  /** The number of days to keep records of deleted builds. */
  daysToKeepDeletedBuildsBeforeDestroy?: int32;

  defaultRetentionPolicy?: RetentionPolicy;
  maximumRetentionPolicy?: RetentionPolicy;
}

model BuildSummary {
  build?: XamlBuildReference;
  finishTime?: utcDateTime;
  keepForever?: boolean;
  quality?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "BuildReason",
      values: #[
        #{ value: "none", description: "No reason. This value should not be used." },
        #{ value: "manual", description: "The build was started manually." },
        #{
          value: "individualCI",
          description: "The build was started for the trigger TriggerType.ContinuousIntegration.",
        },
        #{
          value: "batchedCI",
          description: "The build was started for the trigger TriggerType.BatchedContinuousIntegration.",
        },
        #{
          value: "schedule",
          description: "The build was started for the trigger TriggerType.Schedule.",
        },
        #{
          value: "scheduleForced",
          description: "The build was started for the trigger TriggerType.ScheduleForced.",
        },
        #{ value: "userCreated", description: "The build was created by a user." },
        #{
          value: "validateShelveset",
          description: "The build was started manually for private validation.",
        },
        #{
          value: "checkInShelveset",
          description: "The build was started for the trigger ContinuousIntegrationType.Gated.",
        },
        #{
          value: "pullRequest",
          description: "The build was started by a pull request. Added in resource version 3.",
        },
        #{
          value: "buildCompletion",
          description: "The build was started when another build completed.",
        },
        #{
          value: "resourceTrigger",
          description: "The build was started when resources in pipeline triggered it",
        },
        #{
          value: "triggered",
          description: "The build was triggered for retention policy purposes.",
        },
        #{ value: "all", description: "All reasons." }
      ],
    }
  )
  reason?:
    | "none"
    | "manual"
    | "individualCI"
    | "batchedCI"
    | "schedule"
    | "scheduleForced"
    | "userCreated"
    | "validateShelveset"
    | "checkInShelveset"
    | "pullRequest"
    | "buildCompletion"
    | "resourceTrigger"
    | "triggered"
    | "all";
  requestedFor?: IdentityRef;
  startTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "BuildStatus",
      values: #[
        #{ value: "none", description: "No status." },
        #{ value: "inProgress", description: "The build is currently in progress." },
        #{ value: "completed", description: "The build has completed." },
        #{ value: "cancelling", description: "The build is cancelling" },
        #{ value: "postponed", description: "The build is inactive in the queue." },
        #{ value: "abandoned", description: "The build has been abandoned." },
        #{ value: "notStarted", description: "The build has not yet started." },
        #{ value: "all", description: "All status." }
      ],
    }
  )
  status?:
    | "none"
    | "inProgress"
    | "completed"
    | "cancelling"
    | "postponed"
    | "abandoned"
    | "notStarted"
    | "all";
}

model BuildTagsAddedEvent {
  ...BuildUpdatedEvent;
  allTags?: string[];
  newTags?: string[];
}

/** Represents a trigger for a buld definition. */
model BuildTrigger {
  /** The type of the trigger. */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionTriggerType",
      values: #[
        #{ value: "none", description: "Manual builds only." },
        #{
          value: "continuousIntegration",
          description: "A build should be started for each changeset.",
        },
        #{
          value: "batchedContinuousIntegration",
          description: "A build should be started for multiple changesets at a time at a specified interval.",
        },
        #{
          value: "schedule",
          description: "A build should be started on a specified schedule whether or not changesets exist.",
        },
        #{
          value: "gatedCheckIn",
          description: "A validation build should be started for each check-in.",
        },
        #{
          value: "batchedGatedCheckIn",
          description: "A validation build should be started for each batch of check-ins.",
        },
        #{
          value: "pullRequest",
          description: "A build should be triggered when a GitHub pull request is created or updated. Added in resource version 3",
        },
        #{
          value: "buildCompletion",
          description: "A build should be triggered when another build completes.",
        },
        #{ value: "all", description: "All types." }
      ],
    }
  )
  triggerType?:
    | "none"
    | "continuousIntegration"
    | "batchedContinuousIntegration"
    | "schedule"
    | "gatedCheckIn"
    | "batchedGatedCheckIn"
    | "pullRequest"
    | "buildCompletion"
    | "all";
}

model BuildUpdatedEvent {
  ...RealtimeBuildEvent;
  build?: Build;
}

/** Represents a workspace mapping. */
model BuildWorkspace {
  mappings?: MappingDetails[];
}

/** Represents a change associated with a build. */
model Change {
  author?: IdentityRef;

  /** The location of a user-friendly representation of the resource. */
  displayUri?: string;

  /** The identifier for the change. For a commit, this would be the SHA1. For a TFVC changeset, this would be the changeset ID. */
  id?: string;

  /** The location of the full representation of the resource. */
  location?: string;

  /** The description of the change. This might be a commit message or changeset description. */
  message?: string;

  /** Indicates whether the message was truncated. */
  messageTruncated?: boolean;

  /** The person or process that pushed the change. */
  pusher?: string;

  /** The timestamp for the change. */
  timestamp?: utcDateTime;

  /** The type of change. 'commit', 'changeset', etc. */
  type?: string;
}

model ConsoleLogEvent {
  ...RealtimeBuildEvent;
  lines?: string[];
  @format("uuid") stepRecordId?: string;
  @format("uuid") timelineId?: string;
  @format("uuid") timelineRecordId?: string;
}

model ContinuousDeploymentDefinition {
  connectedService?: WebApiConnectedServiceRef;
  definition?: XamlDefinitionReference;
  gitBranch?: string;
  hostedServiceName?: string;
  project?: TeamProjectReference;
  repositoryId?: string;
  storageAccountName?: string;
  subscriptionId?: string;
  website?: string;
  webspace?: string;
}

/** Represents a continuous integration (CI) trigger. */
model ContinuousIntegrationTrigger {
  ...BuildTrigger;

  /** Indicates whether changes should be batched while another CI build is running. */
  batchChanges?: boolean;

  branchFilters?: string[];

  /** The maximum number of simultaneous CI builds that will run per branch. */
  maxConcurrentBuildsPerBranch?: int32;

  pathFilters?: string[];

  /** The polling interval, in seconds. */
  pollingInterval?: int32;

  /** The ID of the job used to poll an external repository. */
  @format("uuid") pollingJobId?: string;

  settingsSourceType?: int32;
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

/** Represents a reference to a definition. */
model DefinitionReference {
  /** The date this version of the definition was created. */
  createdDate?: utcDateTime;

  /** The ID of the referenced definition. */
  id?: int32;

  /** The name of the referenced definition. */
  name?: string;

  /** The folder path of the definition. */
  path?: string;

  project?: TeamProjectReference;

  /** A value that indicates whether builds can be queued against this definition. */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionQueueStatus",
      values: #[
        #{
          value: "enabled",
          description: "When enabled the definition queue allows builds to be queued by users, the system will queue scheduled, gated and continuous integration builds, and the queued builds will be started by the system.",
        },
        #{
          value: "paused",
          description: "When paused the definition queue allows builds to be queued by users and the system will queue scheduled, gated and continuous integration builds. Builds in the queue will not be started by the system.",
        },
        #{
          value: "disabled",
          description: "When disabled the definition queue will not allow builds to be queued by users and the system will not queue scheduled, gated or continuous integration builds. Builds already in the queue will not be started by the system.",
        }
      ],
    }
  )
  queueStatus?: "enabled" | "paused" | "disabled";

  /** The definition revision number. */
  revision?: int32;

  /** The type of the definition. */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionType",
      values: #[#{ value: "xaml", description: "" }, #{ value: "build", description: "" }],
    }
  )
  type?: "xaml" | "build";

  /** The definition's URI. */
  uri?: string;

  /** The REST URL of the definition. */
  url?: string;
}

model DefinitionResourceReference {
  /** Indicates whether the resource is authorized for use. */
  authorized?: boolean;

  /** The id of the resource. */
  id?: string;

  /** A friendly name for the resource. */
  name?: string;

  /** The type of the resource. */
  type?: string;
}

/** Represents a demand used by a definition or build. */
model Demand {
  /** The name of the capability referenced by the demand. */
  name?: string;

  /** The demanded value. */
  value?: string;
}

/** Represents a dependency. */
model Dependency {
  /** The event. The dependency is satisfied when the referenced object emits this event. */
  event?: string;

  /** The scope. This names the object referenced by the dependency. */
  scope?: string;
}

/** Represents the data from the build information nodes for type 'DeploymentInformation' for xaml builds */
model Deployment {
  type?: string;
}

/** Deployment information for type 'Build' */
model DeploymentBuild {
  ...Deployment;
  buildId?: int32;
}

/** Deployment information for type 'Deploy' */
model DeploymentDeploy {
  ...Deployment;
  message?: string;
}

/** Deployment information for type 'Test' */
model DeploymentTest {
  ...Deployment;
  runId?: int32;
}

/** Represents a build process supported by the build definition designer. */
model DesignerProcess {
  ...BuildProcess;
  phases?: Phase[];
  target?: DesignerProcessTarget;
}

/** Represents the target for the build process. */
model DesignerProcessTarget {
  agentSpecification?: AgentSpecification;
}

model DockerProcess {
  ...BuildProcess;
  target?: DockerProcessTarget;
}

/** Represents the target for the docker build process. */
model DockerProcessTarget {
  ...DesignerProcessTarget;
}

/** Represents a folder that contains build definitions. */
model Folder {
  createdBy?: IdentityRef;

  /** The date the folder was created. */
  createdOn?: utcDateTime;

  /** The description. */
  description?: string;

  lastChangedBy?: IdentityRef;

  /** The date the folder was last changed. */
  lastChangedDate?: utcDateTime;

  /** The full path. */
  path?: string;

  project?: TeamProjectReference;
}

/** Represents the ability to build forks of the selected repository. */
model Forks {
  /** Indicates whether a build should allow a full access token or scope it down when building forks of the selected repository. */
  allowFullAccessToken?: boolean;

  /** Indicates whether a build should use secrets when building forks of the selected repository. */
  allowSecrets?: boolean;

  /** Indicates whether the trigger should queue builds for forks of the selected repository. */
  enabled?: boolean;
}

/** Represents a gated check-in trigger. */
model GatedCheckInTrigger {
  ...BuildTrigger;
  pathFilters?: string[];

  /** Indicates whether CI triggers should run after the gated check-in succeeds. */
  runContinuousIntegration?: boolean;

  /** Indicates whether to take workspace mappings into account when determining whether a build should run. */
  useWorkspaceMappings?: boolean;
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

/** Data representation of an information node associated with a build */
model InformationNode {
  /** Fields of the information node */
  fields?: Record<string>;

  /** Process or person that last modified this node */
  lastModifiedBy?: string;

  /** Date this node was last modified */
  lastModifiedDate?: utcDateTime;

  /** Node Id of this information node */
  nodeId?: int32;

  /** Id of parent node (xml tree) */
  parentId?: int32;

  /** The type of the information node */
  type?: string;
}

/** Represents an issue (error, warning) associated with a build. */
model Issue {
  /** The category. */
  category?: string;

  data?: Record<string>;

  /** A description of the issue. */
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

/** Job in pipeline. This is related to matrixing in YAML. */
model JobReference {
  /** Attempt number of the job */
  attempt?: int32;

  /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
  jobName?: string;
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

model JustInTimeProcess {
  ...BuildProcess;
}

/** Represents an entry in a workspace mapping. */
model MappingDetails {
  /** The local path. */
  localPath?: string;

  /** The mapping type. */
  mappingType?: string;

  /** The server path. */
  serverPath?: string;
}

model MinimalRetentionLease {
  /** The pipeline definition of the run. */
  definitionId?: int32;

  /** User-provided string that identifies the owner of a retention lease. */
  ownerId?: string;

  /** The pipeline run to protect. */
  runId?: int32;
}

/** Represents options for running a phase against multiple agents. */
model MultipleAgentExecutionOptions {
  ...AgentTargetExecutionOptions;

  /** Indicates whether failure on one agent should prevent the phase from running on other agents. */
  continueOnError?: boolean;

  /** The maximum number of agents to use simultaneously. */
  maxConcurrency?: int32;
}

/** Required information to create a new retention lease. */
model NewRetentionLease {
  /** The number of days to consider the lease valid. A retention lease valid for more than 100 years (36500 days) will display as retaining the build 'forever'. */
  daysValid?: int32;

  /** The pipeline definition of the run. */
  definitionId?: int32;

  /** User-provided string that identifies the owner of a retention lease. */
  ownerId?: string;

  /** If set, this lease will also prevent the pipeline from being deleted while the lease is still valid. */
  protectPipeline?: boolean;

  /** The pipeline run to protect. */
  runId?: int32;
}

/** Represents a phase of a build definition. */
model Phase {
  /** The condition that must be true for this phase to execute. */
  condition?: string;

  dependencies?: Dependency[];

  /** The job authorization scope for builds queued against this definition. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildAuthorizationScope",
      values: #[
        #{
          value: "projectCollection",
          description: "The identity used should have build service account permissions scoped to the project collection. This is useful when resources for a single build are spread across multiple projects.",
        },
        #{
          value: "project",
          description: "The identity used should have build service account permissions scoped to the project in which the build definition resides. This is useful for isolation of build jobs to a particular team project to avoid any unintentional escalation of privilege attacks during a build.",
        }
      ],
    }
  )
  jobAuthorizationScope?: "projectCollection" | "project";

  /** The cancellation timeout, in minutes, for builds queued against this definition. */
  jobCancelTimeoutInMinutes?: int32;

  /** The job execution timeout, in minutes, for builds queued against this definition. */
  jobTimeoutInMinutes?: int32;

  /** The name of the phase. */
  name?: string;

  /** The unique ref name of the phase. */
  refName?: string;

  steps?: BuildDefinitionStep[];
  target?: PhaseTarget;
  variables?: Record<BuildDefinitionVariable>;
}

/** Phase in pipeline */
model PhaseReference {
  /** Attempt number of the phase */
  attempt?: int32;

  /** Name of the phase. Maximum supported length for name is 256 character. */
  phaseName?: string;
}

/** Represents the target of a phase. */
model PhaseTarget {
  /** The type of the target. */
  type?: int32;
}

/** Contains pipeline general settings. */
model PipelineGeneralSettings {
  /** If enabled, audit logs will be generated whenever someone queues a pipeline run and defines variables that are not marked as 'Settable at queue time'. */
  auditEnforceSettableVar?: boolean;

  /** Enable forked repositories to build pull requests. */
  buildsEnabledForForks?: boolean;

  /** Disable classic build pipelines creation. */
  disableClassicBuildPipelineCreation?: boolean;

  /** Disable classic pipelines creation. */
  disableClassicPipelineCreation?: boolean;

  /** Disable classic release pipelines creation. */
  disableClassicReleasePipelineCreation?: boolean;

  /** Disable implied pipeline CI triggers if the trigger section in YAML is missing. */
  disableImpliedYAMLCiTrigger?: boolean;

  /** Enable shell tasks args sanitizing. */
  enableShellTasksArgsSanitizing?: boolean;

  /** Enable shell tasks args sanitizing preview. */
  enableShellTasksArgsSanitizingAudit?: boolean;

  /** If enabled, scope of access for all non-release pipelines reduces to the current project. */
  enforceJobAuthScope?: boolean;

  /** Enforce job auth scope for builds of forked repositories. */
  enforceJobAuthScopeForForks?: boolean;

  /** If enabled, scope of access for all release pipelines reduces to the current project. */
  enforceJobAuthScopeForReleases?: boolean;

  /** Enforce no access to secrets for builds of forked repositories. */
  enforceNoAccessToSecretsFromForks?: boolean;

  /** Restricts the scope of GitHub access for all pipelines to only GitHub repositories explicitly referenced by the pipeline. */
  enforceReferencedGitHubRepoScopedToken?: boolean;

  /** Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline. */
  enforceReferencedRepoScopedToken?: boolean;

  /** If enabled, only those variables that are explicitly marked as 'Settable at queue time' can be set at queue time. */
  enforceSettableVar?: boolean;

  /** Enable settings that enforce certain levels of protection for building pull requests from forks globally. */
  forkProtectionEnabled?: boolean;

  /** Make comments required to have builds in all pull requests. */
  isCommentRequiredForPullRequest?: boolean;

  /** Allows pipelines to record metadata. */
  publishPipelineMetadata?: boolean;

  /** Make comments required to have builds in pull requests from non-team members and non-contributors. */
  requireCommentsForNonTeamMemberAndNonContributors?: boolean;

  /** Make comments required to have builds in pull requests from non-team members. */
  requireCommentsForNonTeamMembersOnly?: boolean;

  /** Anonymous users can access the status badge API for all pipelines unless this option is enabled. */
  statusBadgesArePrivate?: boolean;
}

/** Pipeline reference */
model PipelineReference {
  jobReference?: JobReference;
  phaseReference?: PhaseReference;

  /** Reference of the BuildDefinitionId. */
  pipelineDefinitionId?: int32;

  /** Reference of the pipeline with which this pipeline instance is related. */
  pipelineId?: int32;

  stageReference?: StageReference;
}

/** Represents the effective settings applicable to individual pipeline triggers. */
model PipelineTriggerSettings {
  /** Enable forked repositories to build pull requests. */
  buildsEnabledForForks?: boolean;

  /** Enforce job auth scope for builds of forked repositories. */
  enforceJobAuthScopeForForks?: boolean;

  /** Enforce no access to secrets for builds of forked repositories. */
  enforceNoAccessToSecretsFromForks?: boolean;

  /** The comment trigger option for pull requests from forks. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentTriggerOption",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "nonTeamMembersNonContributor", description: "" },
        #{ value: "nonTeamMembers", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  forkCommentOption?: "none" | "nonTeamMembersNonContributor" | "nonTeamMembers" | "all";

  /** Make comments required to have builds in pull requests from forks. */
  forkIsCommentRequiredForPullRequest?: boolean;

  /** Enable settings that enforce certain levels of protection for building pull requests from forks globally. */
  forkProtectionEnabled?: boolean;

  /** The comment trigger option for repository-internal pull requests. */
  @extension(
    "x-ms-enum",
    #{
      name: "CommentTriggerOption",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "nonTeamMembersNonContributor", description: "" },
        #{ value: "nonTeamMembers", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  internalRepoCommentOption?: "none" | "nonTeamMembersNonContributor" | "nonTeamMembers" | "all";

  /** Make comments required to have builds in repository-internal pull requests. */
  internalRepoIsCommentRequiredForPullRequest?: boolean;

  /** [Deprecated] Make comments required to have builds in all pull requests. */
  isCommentRequiredForPullRequest?: boolean;

  /** [Deprecated] Make comments required to have builds in pull requests from non-team members and non-contributors. */
  requireCommentsForNonTeamMemberAndNonContributors?: boolean;

  /** [Deprecated] Make comments required to have builds in pull requests from non-team members. */
  requireCommentsForNonTeamMembersOnly?: boolean;
}

model ProcessParameters {
  dataSourceBindings?: DataSourceBindingBase[];
  inputs?: TaskInputDefinitionBase[];
  sourceDefinitions?: TaskSourceDefinitionBase[];
}

/** Contains the settings for the retention rules. */
model ProjectRetentionSetting {
  purgeArtifacts?: RetentionSetting;
  purgePullRequestRuns?: RetentionSetting;
  purgeRuns?: RetentionSetting;
  retainRunsPerProtectedBranch?: RetentionSetting;
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

/** Represents a pull request object. These are retrieved from Source Providers. */
model PullRequest {
  _links?: ReferenceLinks;
  author?: IdentityRef;

  /** Current state of the pull request, e.g. open, merged, closed, conflicts, etc. */
  currentState?: string;

  /** Description for the pull request. */
  description?: string;

  /** Returns if pull request is draft */
  draft?: boolean;

  /** Unique identifier for the pull request */
  id?: string;

  /** The name of the provider this pull request is associated with. */
  providerName?: string;

  /** Source branch ref of this pull request */
  sourceBranchRef?: string;

  /** Owner of the source repository of this pull request */
  sourceRepositoryOwner?: string;

  /** Target branch ref of this pull request */
  targetBranchRef?: string;

  /** Owner of the target repository of this pull request */
  targetRepositoryOwner?: string;

  /** Title of the pull request. */
  title?: string;
}

/** Represents a pull request trigger. */
model PullRequestTrigger {
  ...BuildTrigger;

  /** Indicates if an update to a PR should delete current in-progress builds. */
  autoCancel?: boolean;

  branchFilters?: string[];
  @extension(
    "x-ms-enum",
    #{
      name: "CommentTriggerOption",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "nonTeamMembersNonContributor", description: "" },
        #{ value: "nonTeamMembers", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  forkCommentOption?: "none" | "nonTeamMembersNonContributor" | "nonTeamMembers" | "all";
  forkIsCommentRequiredForPullRequest?: boolean;
  forks?: Forks;
  @extension(
    "x-ms-enum",
    #{
      name: "CommentTriggerOption",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "nonTeamMembersNonContributor", description: "" },
        #{ value: "nonTeamMembers", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  internalRepoCommentOption?: "none" | "nonTeamMembersNonContributor" | "nonTeamMembers" | "all";
  internalRepoIsCommentRequiredForPullRequest?: boolean;
  isCommentRequiredForPullRequest?: boolean;
  pathFilters?: string[];
  pipelineTriggerSettings?: PipelineTriggerSettings;
  requireCommentsForNonTeamMemberAndNonContributors?: boolean;
  requireCommentsForNonTeamMembersOnly?: boolean;
  settingsSourceType?: int32;
}

model RealtimeBuildEvent {
  buildId?: int32;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** Reference to a release. */
model ReleaseReference {
  /** Number of Release Attempt. */
  attempt?: int32;

  /** Release Creation Date(UTC). */
  creationDate?: utcDateTime;

  /** Release definition ID. */
  definitionId?: int32;

  /** Environment creation Date(UTC). */
  environmentCreationDate?: utcDateTime;

  /** Release environment definition ID. */
  environmentDefinitionId?: int32;

  /** Release environment definition name. */
  environmentDefinitionName?: string;

  /** Release environment ID. */
  environmentId?: int32;

  /** Release environment name. */
  environmentName?: string;

  /** Release ID. */
  id?: int32;

  /** Release name. */
  name?: string;
}

/** Represents a repository's webhook returned from a source provider. */
model RepositoryWebhook {
  /** The status of last delivery attempt for the webhook. */
  lastDeliveryStatus?: int32;

  /** The friendly name of the repository. */
  name?: string;

  types?: (
    | "none"
    | "continuousIntegration"
    | "batchedContinuousIntegration"
    | "schedule"
    | "gatedCheckIn"
    | "batchedGatedCheckIn"
    | "pullRequest"
    | "buildCompletion"
    | "all")[];

  /** The URL of the repository. */
  url?: string;
}

model ResourceRef {
  id?: string;
  url?: string;
}

/** Represents a reference to a resource. */
model ResourceReference {
  /** An alias to be used when referencing the resource. */
  `alias`?: string;
}

/** A valid retention lease prevents automated systems from deleting a pipeline run. */
model RetentionLease {
  /** When the lease was created. */
  createdOn?: utcDateTime;

  /** The pipeline definition of the run. */
  definitionId?: int32;

  /** The unique identifier for this lease. */
  leaseId?: int32;

  /** Non-unique string that identifies the owner of a retention lease. */
  ownerId?: string;

  /** If set, this lease will also prevent the pipeline from being deleted while the lease is still valid. */
  protectPipeline?: boolean;

  /** The pipeline run protected by this lease. */
  runId?: int32;

  /** The last day the lease is considered valid. */
  validUntil?: utcDateTime;
}

/** An update to the retention parameters of a retention lease. */
model RetentionLeaseUpdate {
  /** The number of days to consider the lease valid. A retention lease valid for more than 100 years (36500 days) will display as retaining the build 'forever'. */
  daysValid?: int32;

  /** If set, this lease will also prevent the pipeline from being deleted while the lease is still valid. */
  protectPipeline?: boolean;
}

/** Represents a retention policy for a build definition. */
model RetentionPolicy {
  artifacts?: string[];
  artifactTypesToDelete?: string[];
  branches?: string[];

  /** The number of days to keep builds. */
  daysToKeep?: int32;

  /** Indicates whether the build record itself should be deleted. */
  deleteBuildRecord?: boolean;

  /** Indicates whether to delete test results associated with the build. */
  deleteTestResults?: boolean;

  /** The minimum number of builds to keep. */
  minimumToKeep?: int32;
}

/** Contains the minimum, maximum, and current value for a retention setting. */
model RetentionSetting {
  max?: int32;
  min?: int32;
  value?: int32;
}

model Schedule {
  branchFilters?: string[];

  /** Days for a build (flags enum for days of the week) */
  @extension(
    "x-ms-enum",
    #{
      name: "ScheduleDays",
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
    | "all";

  /** The Job Id of the Scheduled job that will queue the scheduled build. Since a single trigger can have multiple schedules and we want a single job to process a single schedule (since each schedule has a list of branches to build), the schedule itself needs to define the Job Id. This value will be filled in when a definition is added or updated. The UI does not provide it or use it. */
  @format("uuid") scheduleJobId?: string;

  /** Flag to determine if this schedule should only build if the associated source has been changed. */
  scheduleOnlyWithChanges?: boolean;

  /** Local timezone hour to start */
  startHours?: int32;

  /** Local timezone minute to start */
  startMinutes?: int32;

  /** Time zone of the build schedule (String representation of the time zone ID) */
  timeZoneId?: string;
}

/** Represents a schedule trigger. */
model ScheduleTrigger {
  ...BuildTrigger;
  schedules?: Schedule[];
}

/** Represents a reference to a secure file. */
model SecureFileReference {
  ...ResourceReference;

  /** The ID of the secure file. */
  @format("uuid") id?: string;
}

/** Represents a phase target that runs on the server. */
model ServerTarget {
  ...PhaseTarget;
  executionOptions?: ServerTargetExecutionOptions;
}

/** Represents options for running a phase on the server. */
model ServerTargetExecutionOptions {
  /** The type. */
  type?: int32;
}

/** Represents a referenec to a service endpoint. */
model ServiceEndpointReference {
  ...ResourceReference;

  /** The ID of the service endpoint. */
  @format("uuid") id?: string;
}

model SourceProviderAttributes {
  /** The name of the source provider. */
  name?: string;

  /** The capabilities supported by this source provider. */
  supportedCapabilities?: Record<boolean>;

  /** The types of triggers supported by this source provider. */
  supportedTriggers?: SupportedTrigger[];
}

/** Represents a work item related to some source item. These are retrieved from Source Providers. */
model SourceRelatedWorkItem {
  _links?: ReferenceLinks;
  assignedTo?: IdentityRef;

  /** Current state of the work item, e.g. Active, Resolved, Closed, etc. */
  currentState?: string;

  /** Long description for the work item. */
  description?: string;

  /** Unique identifier for the work item */
  id?: string;

  /** The name of the provider the work item is associated with. */
  providerName?: string;

  /** Short name for the work item. */
  title?: string;

  /** Type of work item, e.g. Bug, Task, User Story, etc. */
  type?: string;
}

/** A set of repositories returned from the source provider. */
model SourceRepositories {
  /** A token used to continue this paged request; 'null' if the request is complete */
  continuationToken?: string;

  /** The number of repositories requested for each page */
  pageLength?: int32;

  /** A list of repositories */
  repositories?: SourceRepository[];

  /** The total number of pages, or '-1' if unknown */
  totalPageCount?: int32;
}

/** Represents a repository returned from a source provider. */
model SourceRepository {
  /** The name of the default branch. */
  defaultBranch?: string;

  /** The full name of the repository. */
  fullName?: string;

  /** The ID of the repository. */
  id?: string;

  /** The friendly name of the repository. */
  name?: string;

  properties?: Record<string>;

  /** The name of the source provider the repository is from. */
  sourceProviderName?: string;

  /** The URL of the repository. */
  url?: string;
}

/** Represents an item in a repository from a source provider. */
model SourceRepositoryItem {
  /** Whether the item is able to have sub-items (e.g., is a folder). */
  isContainer?: boolean;

  /** The full path of the item, relative to the root of the repository. */
  path?: string;

  /** The type of the item (folder, file, etc). */
  type?: string;

  /** The URL of the item. */
  url?: string;
}

/** Stage in pipeline */
model StageReference {
  /** Attempt number of stage */
  attempt?: int32;

  /** Name of the stage. Maximum supported length for name is 256 character. */
  stageName?: string;
}

model SupportedTrigger {
  /** The default interval to wait between polls (only relevant when NotificationType is Polling). */
  defaultPollingInterval?: int32;

  /** How the trigger is notified of changes. */
  notificationType?: string;

  /** The capabilities supported by this trigger. */
  supportedCapabilities?: Record<"unsupported" | "supported" | "required">;

  /** The type of trigger. */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionTriggerType",
      values: #[
        #{ value: "none", description: "Manual builds only." },
        #{
          value: "continuousIntegration",
          description: "A build should be started for each changeset.",
        },
        #{
          value: "batchedContinuousIntegration",
          description: "A build should be started for multiple changesets at a time at a specified interval.",
        },
        #{
          value: "schedule",
          description: "A build should be started on a specified schedule whether or not changesets exist.",
        },
        #{
          value: "gatedCheckIn",
          description: "A validation build should be started for each check-in.",
        },
        #{
          value: "batchedGatedCheckIn",
          description: "A validation build should be started for each batch of check-ins.",
        },
        #{
          value: "pullRequest",
          description: "A build should be triggered when a GitHub pull request is created or updated. Added in resource version 3",
        },
        #{
          value: "buildCompletion",
          description: "A build should be triggered when another build completes.",
        },
        #{ value: "all", description: "All types." }
      ],
    }
  )
  type?:
    | "none"
    | "continuousIntegration"
    | "batchedContinuousIntegration"
    | "schedule"
    | "gatedCheckIn"
    | "batchedGatedCheckIn"
    | "pullRequest"
    | "buildCompletion"
    | "all";
}

/** Represents a Subversion mapping entry. */
model SvnMappingDetails {
  /** The depth. */
  depth?: int32;

  /** Indicates whether to ignore externals. */
  ignoreExternals?: boolean;

  /** The local path. */
  localPath?: string;

  /** The revision. */
  revision?: string;

  /** The server path. */
  serverPath?: string;
}

/** Represents a subversion workspace. */
model SvnWorkspace {
  mappings?: SvnMappingDetails[];
}

/** Represents a reference to an agent pool. */
model TaskAgentPoolReference {
  /** The pool ID. */
  id?: int32;

  /** A value indicating whether or not this pool is managed by the service. */
  isHosted?: boolean;

  /** The pool name. */
  name?: string;
}

/** A reference to a task definition. */
model TaskDefinitionReference {
  /** The type of task (task or task group). */
  definitionType?: string;

  /** The ID of the task. */
  @format("uuid") id?: string;

  /** The version of the task. */
  versionSpec?: string;
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

/** Represents a reference to a plan group. */
model TaskOrchestrationPlanGroupReference {
  /** The name of the plan group. */
  planGroup?: string;

  /** The project ID. */
  @format("uuid") projectId?: string;
}

model TaskOrchestrationPlanGroupsStartedEvent {
  planGroups?: TaskOrchestrationPlanGroupReference[];
}

/** Represents a reference to an orchestration plan. */
model TaskOrchestrationPlanReference {
  /** The type of the plan. */
  orchestrationType?: int32;

  /** The ID of the plan. */
  @format("uuid") planId?: string;
}

/** Represents a reference to a task. */
model TaskReference {
  /** The ID of the task definition. */
  @format("uuid") id?: string;

  /** The name of the task definition. */
  name?: string;

  /** The version of the task definition. */
  version?: string;
}

model TaskSourceDefinitionBase {
  authKey?: string;
  endpoint?: string;
  keySelector?: string;
  selector?: string;
  target?: string;
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

model TestResultsContext {
  build?: BuildReference;
  @extension(
    "x-ms-enum",
    #{
      name: "TestResultsContextType",
      values: #[
        #{ value: "build", description: "" },
        #{ value: "release", description: "" },
        #{ value: "pipeline", description: "" }
      ],
    }
  )
  contextType?: "build" | "release" | "pipeline";
  pipelineReference?: PipelineReference;
  release?: ReleaseReference;
}

/** Represents the timeline of a build. */
model Timeline {
  ...TimelineReference;

  /** The process or person that last changed the timeline. */
  @format("uuid") lastChangedBy?: string;

  /** The time the timeline was last changed. */
  lastChangedOn?: utcDateTime;

  records?: TimelineRecord[];
}

model TimelineAttempt {
  /** Gets or sets the attempt of the record. */
  attempt?: int32;

  /** Gets or sets the record identifier located within the specified timeline. */
  @format("uuid") recordId?: string;

  /** Gets or sets the timeline identifier which owns the record representing this attempt. */
  @format("uuid") timelineId?: string;
}

/** Represents an entry in a build's timeline. */
model TimelineRecord {
  _links?: ReferenceLinks;

  /** Attempt number of record. */
  attempt?: int32;

  /** The change ID. */
  changeId?: int32;

  /** A string that indicates the current operation. */
  currentOperation?: string;

  details?: TimelineReference;

  /** The number of errors produced by this operation. */
  errorCount?: int32;

  /** The finish time. */
  finishTime?: utcDateTime;

  /** The ID of the record. */
  @format("uuid") id?: string;

  /** String identifier that is consistent across attempts. */
  identifier?: string;

  issues?: Issue[];

  /** The time the record was last modified. */
  lastModified?: utcDateTime;

  log?: BuildLogReference;

  /** The name. */
  name?: string;

  /** An ordinal value relative to other records. */
  order?: int32;

  /** The ID of the record's parent. */
  @format("uuid") parentId?: string;

  /** The current completion percentage. */
  percentComplete?: int32;

  previousAttempts?: TimelineAttempt[];

  /** The queue ID of the queue that the operation ran on. */
  queueId?: int32;

  /** The ref name */
  refName?: string;

  /** The result. */
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

  /** The result code. */
  resultCode?: string;

  /** The start time. */
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

  /** The type of the record. */
  type?: string;

  /** The REST URL of the timeline record. */
  url?: string;

  /** The number of warnings produced by this operation. */
  warningCount?: int32;

  /** The name of the agent running the operation. */
  workerName?: string;
}

model TimelineRecordsUpdatedEvent {
  ...RealtimeBuildEvent;
  timelineRecords?: TimelineRecord[];
}

/** Represents a reference to a timeline. */
model TimelineReference {
  /** The change ID. */
  changeId?: int32;

  /** The ID of the timeline. */
  @format("uuid") id?: string;

  /** The REST URL of the timeline. */
  url?: string;
}

/** Contains members for updating the retention settings values. All fields are optional. */
model UpdateProjectRetentionSettingModel {
  artifactsRetention?: UpdateRetentionSettingModel;
  pullRequestRunRetention?: UpdateRetentionSettingModel;
  retainRunsPerProtectedBranch?: UpdateRetentionSettingModel;
  runRetention?: UpdateRetentionSettingModel;
}

model UpdateRetentionSettingModel {
  value?: int32;
}

model UpdateStageParameters {
  forceRetryAllJobs?: boolean;
  retryDependencies?: boolean;
  @extension(
    "x-ms-enum",
    #{
      name: "StageUpdateType",
      values: #[
        #{ value: "cancel", description: "" },
        #{ value: "retry", description: "" },
        #{ value: "run", description: "" }
      ],
    }
  )
  state?: "cancel" | "retry" | "run";
}

model UpdateTagParameters {
  tagsToAdd?: string[];
  tagsToRemove?: string[];
}

/** Represents a variable group. */
model VariableGroup {
  ...VariableGroupReference;

  /** The description. */
  description?: string;

  /** The name of the variable group. */
  name?: string;

  /** The type of the variable group. */
  type?: string;

  variables?: Record<BuildDefinitionVariable>;
}

/** Represents a reference to a variable group. */
model VariableGroupReference {
  /** The Name of the variable group. */
  `alias`?: string;

  /** The ID of the variable group. */
  id?: int32;
}

/** Represents options for running a phase based on values specified by a list of variables. */
model VariableMultipliersAgentExecutionOptions {
  ...AgentTargetExecutionOptions;

  /** Indicates whether failure on one agent should prevent the phase from running on other agents. */
  continueOnError?: boolean;

  /** The maximum number of agents to use in parallel. */
  maxConcurrency?: int32;

  multipliers?: string[];
}

/** Represents options for running a phase based on values specified by a list of variables. */
model VariableMultipliersServerExecutionOptions {
  ...ServerTargetExecutionOptions;

  /** Indicates whether failure of one job should prevent the phase from running in other jobs. */
  continueOnError?: boolean;

  /** The maximum number of server jobs to run in parallel. */
  maxConcurrency?: int32;

  multipliers?: string[];
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

model WebApiConnectedServiceRef {
  id?: string;
  url?: string;
}

/** Mapping for a workspace */
model WorkspaceMapping {
  /** Uri of the associated definition */
  definitionUri?: string;

  /** Depth of this mapping */
  depth?: int32;

  /** local location of the definition */
  localItem?: string;

  /** type of workspace mapping */
  @extension(
    "x-ms-enum",
    #{
      name: "WorkspaceMappingType",
      values: #[
        #{ value: "map", description: "The path is mapped in the workspace." },
        #{ value: "cloak", description: "The path is cloaked in the workspace." }
      ],
    }
  )
  mappingType?: "map" | "cloak";

  /** Server location of the definition */
  serverItem?: string;

  /** Id of the workspace */
  workspaceId?: int32;
}

model WorkspaceTemplate {
  /** Uri of the associated definition */
  definitionUri?: string;

  /** The identity that last modified this template */
  lastModifiedBy?: string;

  /** The last time this template was modified */
  lastModifiedDate?: utcDateTime;

  /** List of workspace mappings */
  mappings?: WorkspaceMapping[];

  /** Id of the workspace for this template */
  workspaceId?: int32;
}

model XamlBuildControllerReference {
  /** Id of the resource */
  id?: int32;

  /** Name of the linked resource (definition name, controller name, etc.) */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

model XamlBuildDefinition {
  ...DefinitionReference;
  _links?: ReferenceLinks;

  /** Batch size of the definition */
  batchSize?: int32;

  buildArgs?: string;

  /** The continuous integration quiet period */
  continuousIntegrationQuietPeriod?: int32;

  controller?: BuildController;

  /** The date this definition was created */
  createdOn?: utcDateTime;

  /** Default drop location for builds from this definition */
  defaultDropLocation?: string;

  /** Description of the definition */
  description?: string;

  lastBuild?: XamlBuildReference;
  repository?: BuildRepository;

  /** The reasons supported by the template */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildReason",
      values: #[
        #{ value: "none", description: "No reason. This value should not be used." },
        #{ value: "manual", description: "The build was started manually." },
        #{
          value: "individualCI",
          description: "The build was started for the trigger TriggerType.ContinuousIntegration.",
        },
        #{
          value: "batchedCI",
          description: "The build was started for the trigger TriggerType.BatchedContinuousIntegration.",
        },
        #{
          value: "schedule",
          description: "The build was started for the trigger TriggerType.Schedule.",
        },
        #{
          value: "scheduleForced",
          description: "The build was started for the trigger TriggerType.ScheduleForced.",
        },
        #{ value: "userCreated", description: "The build was created by a user." },
        #{
          value: "validateShelveset",
          description: "The build was started manually for private validation.",
        },
        #{
          value: "checkInShelveset",
          description: "The build was started for the trigger ContinuousIntegrationType.Gated.",
        },
        #{
          value: "pullRequest",
          description: "The build was started by a pull request. Added in resource version 3.",
        },
        #{
          value: "buildCompletion",
          description: "The build was started when another build completed.",
        },
        #{
          value: "resourceTrigger",
          description: "The build was started when resources in pipeline triggered it",
        },
        #{
          value: "triggered",
          description: "The build was triggered for retention policy purposes.",
        },
        #{ value: "all", description: "All reasons." }
      ],
    }
  )
  supportedReasons?:
    | "none"
    | "manual"
    | "individualCI"
    | "batchedCI"
    | "schedule"
    | "scheduleForced"
    | "userCreated"
    | "validateShelveset"
    | "checkInShelveset"
    | "pullRequest"
    | "buildCompletion"
    | "resourceTrigger"
    | "triggered"
    | "all";

  /** How builds are triggered from this definition */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionTriggerType",
      values: #[
        #{ value: "none", description: "Manual builds only." },
        #{
          value: "continuousIntegration",
          description: "A build should be started for each changeset.",
        },
        #{
          value: "batchedContinuousIntegration",
          description: "A build should be started for multiple changesets at a time at a specified interval.",
        },
        #{
          value: "schedule",
          description: "A build should be started on a specified schedule whether or not changesets exist.",
        },
        #{
          value: "gatedCheckIn",
          description: "A validation build should be started for each check-in.",
        },
        #{
          value: "batchedGatedCheckIn",
          description: "A validation build should be started for each batch of check-ins.",
        },
        #{
          value: "pullRequest",
          description: "A build should be triggered when a GitHub pull request is created or updated. Added in resource version 3",
        },
        #{
          value: "buildCompletion",
          description: "A build should be triggered when another build completes.",
        },
        #{ value: "all", description: "All types." }
      ],
    }
  )
  triggerType?:
    | "none"
    | "continuousIntegration"
    | "batchedContinuousIntegration"
    | "schedule"
    | "gatedCheckIn"
    | "batchedGatedCheckIn"
    | "pullRequest"
    | "buildCompletion"
    | "all";
}

model XamlBuildReference {
  /** Id of the resource */
  id?: int32;

  /** Name of the linked resource (definition name, controller name, etc.) */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

model XamlBuildServerReference {
  /** Id of the resource */
  id?: int32;

  /** Name of the linked resource (definition name, controller name, etc.) */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

model XamlDefinitionReference {
  /** Id of the resource */
  id?: int32;

  /** Name of the linked resource (definition name, controller name, etc.) */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

/** Represents a yaml build. */
model YamlBuild {
  /** The yaml used to define the build */
  yaml?: string;
}

/** Represents a YAML process. */
model YamlProcess {
  ...BuildProcess;
  errors?: string[];
  resources?: BuildProcessResources;

  /** The YAML filename. */
  yamlFilename?: string;
}

/** Gets controller, optionally filtered by name */
@tag("Controllers")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "controllers")
@extension("x-ms-vss-method", "GetBuildControllers")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/build/controllers")
@get
op Controllers_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  @query(#{ explode: true }) name?: string,
  ...Parameters.`api-Version-preview`.`2`,
): Body<BuildController[]>;

/** Gets a controller */
@tag("Controllers")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "controllers")
@extension("x-ms-vss-method", "GetBuildController")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/build/controllers/{controllerId}")
@get
op Controllers_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  @path controllerId: int32,
  ...Parameters.`api-Version-preview`.`2`,
): BuildController;

/** Gets information about build resources in the system. */
@tag("Resource Usage")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "resourceUsage")
@extension("x-ms-vss-method", "GetResourceUsage")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/build/resourceusage")
@get
op `Resource Usage_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  ...Parameters.`api-Version-preview`.`2`,
): BuildResourceUsage;

/** Returns the retention history for the project collection. This includes pipelines that have custom retention rules that may prevent the retention job from cleaning them up, runs per pipeline with retention type, files associated with pipelines owned by the collection with retention type, and the number of files per pipeline. */
@tag("History")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "history")
@extension("x-ms-vss-method", "GetRetentionHistory")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/build/retention/history")
@get
op History_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  @query(#{ explode: true }) daysToLookback?: int32,
  ...Parameters.`api-Version-preview`.`1`,
): BuildRetentionHistory;

/** This endpoint is deprecated. Please see the Build Status REST endpoint. */
@tag("Badge")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "badge")
@extension("x-ms-vss-method", "GetBadge")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/public/build/definitions/{project}/{definitionId}/badge")
@get
op Badge_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The project ID or name. */
  @format("uuid") @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The name of the branch. */
  @query(#{ explode: true }) branchName?: string,

  ...Parameters.`api-Version-preview`.`2`,
): Body<string>;

@tag("Authorizedresources")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "authorizedresources")
@extension("x-ms-vss-method", "GetProjectResources")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/authorizedresources")
@get
op Authorizedresources_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @query(#{ explode: true }) type?: string,
  @query(#{ explode: true }) id?: string,
  ...Parameters.`api-Version-preview`.`1`,
): Body<DefinitionResourceReference[]>;

@tag("Authorizedresources")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "authorizedresources")
@extension("x-ms-vss-method", "AuthorizeProjectResources")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/authorizedresources")
@patch
op `Authorizedresources_Authorize Project Resources`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: DefinitionResourceReference[],
): Body<DefinitionResourceReference[]>;

/** Gets a list of builds. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "builds")
@extension("x-ms-vss-method", "GetBuilds")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds")
@get
op Builds_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** A comma-delimited list of definition IDs. If specified, filters to builds for these definitions. */
  @format("array (int32)") @query(#{ explode: true }) definitions?: string,

  /** A comma-delimited list of queue IDs. If specified, filters to builds that ran against these queues. */
  @format("array (int32)") @query(#{ explode: true }) queues?: string,

  /** If specified, filters to builds that match this build number. Append * to do a prefix search. */
  @query(#{ explode: true }) buildNumber?: string,

  /** If specified, filters to builds that finished/started/queued after this date based on the queryOrder specified. */
  @query(#{ explode: true }) minTime?: utcDateTime,

  /** If specified, filters to builds that finished/started/queued before this date based on the queryOrder specified. */
  @query(#{ explode: true }) maxTime?: utcDateTime,

  /** If specified, filters to builds requested for the specified user. */
  @query(#{ explode: true }) requestedFor?: string,

  /** If specified, filters to builds that match this reason. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildReason",
      values: #[
        #{ value: "none", description: "No reason. This value should not be used." },
        #{ value: "manual", description: "The build was started manually." },
        #{
          value: "individualCI",
          description: "The build was started for the trigger TriggerType.ContinuousIntegration.",
        },
        #{
          value: "batchedCI",
          description: "The build was started for the trigger TriggerType.BatchedContinuousIntegration.",
        },
        #{
          value: "schedule",
          description: "The build was started for the trigger TriggerType.Schedule.",
        },
        #{
          value: "scheduleForced",
          description: "The build was started for the trigger TriggerType.ScheduleForced.",
        },
        #{ value: "userCreated", description: "The build was created by a user." },
        #{
          value: "validateShelveset",
          description: "The build was started manually for private validation.",
        },
        #{
          value: "checkInShelveset",
          description: "The build was started for the trigger ContinuousIntegrationType.Gated.",
        },
        #{
          value: "pullRequest",
          description: "The build was started by a pull request. Added in resource version 3.",
        },
        #{
          value: "buildCompletion",
          description: "The build was started when another build completed.",
        },
        #{
          value: "resourceTrigger",
          description: "The build was started when resources in pipeline triggered it",
        },
        #{
          value: "triggered",
          description: "The build was triggered for retention policy purposes.",
        },
        #{ value: "all", description: "All reasons." }
      ],
    }
  )
  @query(#{ explode: true })
  reasonFilter?:
    | "none"
    | "manual"
    | "individualCI"
    | "batchedCI"
    | "schedule"
    | "scheduleForced"
    | "userCreated"
    | "validateShelveset"
    | "checkInShelveset"
    | "pullRequest"
    | "buildCompletion"
    | "resourceTrigger"
    | "triggered"
    | "all",

  /** If specified, filters to builds that match this status. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildStatus",
      values: #[
        #{ value: "none", description: "No status." },
        #{ value: "inProgress", description: "The build is currently in progress." },
        #{ value: "completed", description: "The build has completed." },
        #{ value: "cancelling", description: "The build is cancelling" },
        #{ value: "postponed", description: "The build is inactive in the queue." },
        #{ value: "abandoned", description: "The build has been abandoned." },
        #{ value: "notStarted", description: "The build has not yet started." },
        #{ value: "all", description: "All status." }
      ],
    }
  )
  @query(#{ explode: true })
  statusFilter?:
    | "none"
    | "inProgress"
    | "completed"
    | "cancelling"
    | "postponed"
    | "abandoned"
    | "notStarted"
    | "all",

  /** If specified, filters to builds that match this result. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildResult",
      values: #[
        #{ value: "none", description: "No result" },
        #{ value: "succeeded", description: "The build completed successfully." },
        #{
          value: "partiallySucceeded",
          description: "The build completed compilation successfully but had other errors.",
        },
        #{ value: "failed", description: "The build completed unsuccessfully." },
        #{ value: "canceled", description: "The build was canceled before starting." }
      ],
    }
  )
  @query(#{ explode: true })
  resultFilter?: "none" | "succeeded" | "partiallySucceeded" | "failed" | "canceled",

  /** A comma-delimited list of tags. If specified, filters to builds that have the specified tags. */
  @format("array (string)") @query(#{ explode: true }) tagFilters?: string,

  /** A comma-delimited list of properties to retrieve. */
  @format("array (string)") @query(#{ explode: true }) properties?: string,

  /** The maximum number of builds to return. */
  @query(#{ explode: true }) $top?: int32,

  /** A continuation token, returned by a previous call to this method, that can be used to return the next set of builds. */
  @query(#{ explode: true }) continuationToken?: string,

  /** The maximum number of builds to return per definition. */
  @query(#{ explode: true }) maxBuildsPerDefinition?: int32,

  /** Indicates whether to exclude, include, or only return deleted builds. */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryDeletedOption",
      values: #[
        #{ value: "excludeDeleted", description: "Include only non-deleted builds." },
        #{ value: "includeDeleted", description: "Include deleted and non-deleted builds." },
        #{ value: "onlyDeleted", description: "Include only deleted builds." }
      ],
    }
  )
  @query(#{ explode: true })
  deletedFilter?: "excludeDeleted" | "includeDeleted" | "onlyDeleted",

  /** The order in which builds should be returned. */
  @extension(
    "x-ms-enum",
    #{
      name: "BuildQueryOrder",
      values: #[
        #{ value: "finishTimeAscending", description: "Order by finish time ascending." },
        #{ value: "finishTimeDescending", description: "Order by finish time descending." },
        #{ value: "queueTimeDescending", description: "Order by queue time descending." },
        #{ value: "queueTimeAscending", description: "Order by queue time ascending." },
        #{ value: "startTimeDescending", description: "Order by start time descending." },
        #{ value: "startTimeAscending", description: "Order by start time ascending." }
      ],
    }
  )
  @query(#{ explode: true })
  queryOrder?:
    | "finishTimeAscending"
    | "finishTimeDescending"
    | "queueTimeDescending"
    | "queueTimeAscending"
    | "startTimeDescending"
    | "startTimeAscending",

  /** If specified, filters to builds that built branches that built this branch. */
  @query(#{ explode: true }) branchName?: string,

  /** A comma-delimited list that specifies the IDs of builds to retrieve. */
  @format("array (int32)") @query(#{ explode: true }) buildIds?: string,

  /** If specified, filters to builds that built from this repository. */
  @query(#{ explode: true }) repositoryId?: string,

  /** If specified, filters to builds that built from repositories of this type. */
  @query(#{ explode: true }) repositoryType?: string,

  ...Parameters.`api-Version-preview`.`8`,
): Body<Build[]>;

/** Updates multiple builds. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "builds")
@extension("x-ms-vss-method", "UpdateBuilds")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds")
@patch
op `Builds_Update Builds`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`8`,

  /** The builds to update. */
  @body body: Build[],
): Body<Build[]>;

/** Queues a build */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "builds")
@extension("x-ms-vss-method", "QueueBuild")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds")
@post
op Builds_Queue(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @query(#{ explode: true }) ignoreWarnings?: boolean,
  @query(#{ explode: true }) checkInTicket?: string,
  @query(#{ explode: true }) sourceBuildId?: int32,

  /** Optional definition id to queue a build without a body. Ignored if there's a valid body */
  @query(#{ explode: true }) definitionId?: int32,

  ...Parameters.`api-Version-preview`.`8`,
  @body body: Build,
): Build;

/** Deletes a build. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "builds")
@extension("x-ms-vss-method", "DeleteBuild")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}")
@delete
op Builds_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`8`,
): OkResponse;

/** Gets a build */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "builds")
@extension("x-ms-vss-method", "GetBuild")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}")
@get
op Builds_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path buildId: int32,
  @query(#{ explode: true }) propertyFilters?: string,
  ...Parameters.`api-Version-preview`.`8`,
): Build;

/** Updates a build. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "builds")
@extension("x-ms-vss-method", "UpdateBuild")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}")
@patch
op `Builds_Update Build`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  @query(#{ explode: true }) retry?: boolean,
  ...Parameters.`api-Version-preview`.`8`,

  /** The build. */
  @body body: Build,
): Build;

/** Gets a specific attachment. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "GetAttachment")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/{timelineId}/{recordId}/attachments/{type}/{name}")
@get
op Attachments_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The ID of the timeline. */
  @format("uuid") @path timelineId: string,

  /** The ID of the timeline record. */
  @format("uuid") @path recordId: string,

  /** The type of the attachment. */
  @path type: string,

  /** The name of the attachment. */
  @path name: string,

  ...Parameters.`api-Version-preview`.`2`,
): {
  @header contentType: "application/octet-stream";
  @body @format("Stream") body: string;
};

/** Gets all artifacts for a build. */
@tag("Artifacts")
@extension("x-ms-docs-override-version", "7.2-preview.5")
@extension("x-ms-vss-resource", "artifacts")
@extension("x-ms-vss-method", "GetArtifacts")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/artifacts")
@get
op Artifacts_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`5`,
): Body<BuildArtifact[]>;

/** Associates an artifact with a build. */
@tag("Artifacts")
@extension("x-ms-docs-override-version", "7.2-preview.5")
@extension("x-ms-vss-resource", "artifacts")
@extension("x-ms-vss-method", "CreateArtifact")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/artifacts")
@post
op Artifacts_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`5`,

  /** The artifact. */
  @body body: BuildArtifact,
): BuildArtifact;

/** Gets the list of attachments of a specific type that are associated with a build. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "GetAttachments")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/attachments/{type}")
@get
op Attachments_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The type of attachment. */
  @path type: string,

  ...Parameters.`api-Version-preview`.`2`,
): Body<Attachment[]>;

/** Gets the changes associated with a build */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "changes")
@extension("x-ms-vss-method", "GetBuildChanges")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/changes")
@get
op `Builds_Get Build Changes`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path buildId: int32,
  @query(#{ explode: true }) continuationToken?: string,

  /** The maximum number of changes to return */
  @query(#{ explode: true }) $top?: int32,

  @query(#{ explode: true }) includeSourceChange?: boolean,
  ...Parameters.`api-Version-preview`.`2`,
): Body<Change[]>;

/** Gets all retention leases that apply to a specific build. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "buildleases")
@extension("x-ms-vss-method", "GetRetentionLeasesForBuild")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/leases")
@get
op `Builds_Get Retention Leases For Build`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Body<RetentionLease[]>;

/** Gets the logs for a build. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "logs")
@extension("x-ms-vss-method", "GetBuildLogs")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/logs")
@get
op `Builds_Get Build Logs`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`2`,
):
  | {
      @header contentType: "application/zip";
      @body body: BuildLog[];
    }
  | Body<BuildLog[]>;

/** Gets an individual log file for a build. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "logs")
@extension("x-ms-vss-method", "GetBuildLog")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/logs/{logId}")
@get
op `Builds_Get Build Log`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The ID of the log file. */
  @path logId: int32,

  /** The start line. */
  @query(#{ explode: true }) startLine?: int64,

  /** The end line. */
  @query(#{ explode: true }) endLine?: int64,

  ...Parameters.`api-Version-preview`.`2`,
):
  | {
      @header contentType: "application/zip";
      @body @format("Stream") body: string;
    }
  | Body<string>
  | {
      @header contentType: "text/plain";
      @body @format("Stream") body: string;
    };

/** Gets properties for a build. */
@tag("Properties")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "properties")
@extension("x-ms-vss-method", "GetBuildProperties")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/properties")
@get
op `Properties_Get Build Properties`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** A comma-delimited list of properties. If specified, filters to these specific properties. */
  @format("array (string)") @query(#{ explode: true }) filter?: string,

  ...Parameters.`api-Version-preview`.`1`,
): PropertiesCollection;

/** Updates properties for a build. */
@tag("Properties")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "properties")
@extension("x-ms-vss-method", "UpdateBuildProperties")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/properties")
@patch
op `Properties_Update Build Properties`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`1`,
  @header contentType: "application/json-patch+json",

  /** A json-patch document describing the properties to update. */
  @body body: JsonPatchDocument,
): PropertiesCollection;

/** Gets a build report. */
@tag("Report")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "report")
@extension("x-ms-vss-method", "GetBuildReport")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/report")
@get
op Report_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  @query(#{ explode: true }) type?: string,
  ...Parameters.`api-Version-preview`.`2`,
):
  | {
      @header contentType: "text/html";
      @body body: BuildReportMetadata;
    }
  | BuildReportMetadata;

/** Update a build stage */
@tag("Stages")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "stages")
@extension("x-ms-vss-method", "UpdateStage")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/stages/{stageRefName}")
@patch
op Stages_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  @path buildId: int32,
  @path stageRefName: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: UpdateStageParameters,
): OkResponse;

/** Gets the tags for a build. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "GetBuildTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/tags")
@get
op `Tags_Get Build Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Adds/Removes tags from a build. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "UpdateBuildTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/tags")
@patch
op `Tags_Update Build Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`3`,

  /** The tags to add/remove. */
  @body body: UpdateTagParameters,
): Body<string[]>;

/** Adds tags to a build. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "AddBuildTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/tags")
@post
op `Tags_Add Build Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  ...Parameters.`api-Version-preview`.`3`,

  /** The tags to add. Request body is composed directly from listed tags. */
  @body body: string[],
): Body<string[]>;

/** Removes a tag from a build. NOTE: This API will not work for tags with special characters. To remove tags with special characters, use the PATCH method instead (in 6.0+) */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "DeleteBuildTag")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/tags/{tag}")
@delete
op `Tags_Delete Build Tag`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The tag to remove. */
  @path tag: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Adds a tag to a build. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "AddBuildTag")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/tags/{tag}")
@put
op `Tags_Add Build Tag`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The tag to add. */
  @path tag: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Gets details for a build */
@tag("Timeline")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "timeline")
@extension("x-ms-vss-method", "GetBuildTimeline")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/timeline/{timelineId}")
@get
op Timeline_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path buildId: int32,

  @extension("x-ms-required", false)
  @format("uuid")
  @path
  timelineId: string,

  @query(#{ explode: true }) changeId?: int32,
  @format("uuid") @query(#{ explode: true }) planId?: string,
  ...Parameters.`api-Version-preview`.`3`,
): Timeline;

/** Gets the timeline for a build filtered to a specific stage. */
@tag("Stage Timeline")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "stageTimeline")
@extension("x-ms-vss-method", "GetBuildStageTimeline")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/Timeline/{timelineId}/stages/{stageName}")
@get
op `Stage Timeline_Get Build Stage Timeline`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The ID of the timeline. */
  @format("uuid") @path timelineId: string,

  /** The name of the stage to filter by. */
  @path stageName: string,

  /** The change ID to filter by. */
  @query(#{ explode: true }) changeId?: int32,

  /** The ID of the plan. */
  @format("uuid") @query(#{ explode: true }) planId?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Timeline;

/** Gets the latest timeline for a build filtered to a specific stage. */
@tag("Stage Timeline")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "stageTimeline")
@extension("x-ms-vss-method", "GetBuildStageLatestTimeline")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/Timeline/stages/{stageName}")
@get
op `Stage Timeline_Get Build Stage Latest Timeline`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The name of the stage to filter by. */
  @path stageName: string,

  /** The change ID to filter by. */
  @query(#{ explode: true }) changeId?: int32,

  /** The ID of the plan. */
  @format("uuid") @query(#{ explode: true }) planId?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Timeline;

/** Gets the work items associated with a build. Only work items in the same project are returned. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "workitems")
@extension("x-ms-vss-method", "GetBuildWorkItemsRefs")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/workitems")
@get
op `Builds_Get Build Work Items Refs`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The maximum number of work items to return. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`2`,
): Body<ResourceRef[]>;

/** Gets the work items associated with a build, filtered to specific commits. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "workitems")
@extension("x-ms-vss-method", "GetBuildWorkItemsRefsFromCommits")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/builds/{buildId}/workitems")
@post
op `Builds_Get Build Work Items Refs From Commits`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the build. */
  @path buildId: int32,

  /** The maximum number of work items to return, or the number of commits to consider if no commit IDs are specified. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`2`,

  /** A comma-delimited list of commit IDs. */
  @body body: string[],
): Body<ResourceRef[]>;

/** Gets the changes made to the repository between two given builds. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "changes")
@extension("x-ms-vss-method", "GetChangesBetweenBuilds")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/changes")
@get
op `Builds_Get Changes Between Builds`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the first build. */
  @query(#{ explode: true }) fromBuildId?: int32,

  /** The ID of the last build. */
  @query(#{ explode: true }) toBuildId?: int32,

  /** The maximum number of changes to return. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`2`,
): Body<Change[]>;

/** Gets a list of definitions. */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "definitions")
@extension("x-ms-vss-method", "GetDefinitions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions")
@get
op Definitions_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** If specified, filters to definitions whose names match this pattern. */
  @query(#{ explode: true }) name?: string,

  /** A repository ID. If specified, filters to definitions that use this repository. */
  @query(#{ explode: true }) repositoryId?: string,

  /** If specified, filters to definitions that have a repository of this type. */
  @query(#{ explode: true }) repositoryType?: string,

  /** Indicates the order in which definitions should be returned. */
  @extension(
    "x-ms-enum",
    #{
      name: "DefinitionQueryOrder",
      values: #[
        #{ value: "none", description: "No order" },
        #{
          value: "lastModifiedAscending",
          description: "Order by created on/last modified time ascending.",
        },
        #{
          value: "lastModifiedDescending",
          description: "Order by created on/last modified time descending.",
        },
        #{ value: "definitionNameAscending", description: "Order by definition name ascending." },
        #{ value: "definitionNameDescending", description: "Order by definition name descending." }
      ],
    }
  )
  @query(#{ explode: true })
  queryOrder?:
    | "none"
    | "lastModifiedAscending"
    | "lastModifiedDescending"
    | "definitionNameAscending"
    | "definitionNameDescending",

  /** The maximum number of definitions to return. */
  @query(#{ explode: true }) $top?: int32,

  /** A continuation token, returned by a previous call to this method, that can be used to return the next set of definitions. */
  @query(#{ explode: true }) continuationToken?: string,

  /** If specified, indicates the date from which metrics should be included. */
  @query(#{ explode: true }) minMetricsTime?: utcDateTime,

  /** A comma-delimited list that specifies the IDs of definitions to retrieve. */
  @format("array (int32)") @query(#{ explode: true }) definitionIds?: string,

  /** If specified, filters to definitions under this folder. */
  @query(#{ explode: true }) path?: string,

  /** If specified, filters to definitions that have builds after this date. */
  @query(#{ explode: true }) builtAfter?: utcDateTime,

  /** If specified, filters to definitions that do not have builds after this date. */
  @query(#{ explode: true }) notBuiltAfter?: utcDateTime,

  /** Indicates whether the full definitions should be returned. By default, shallow representations of the definitions are returned. */
  @query(#{ explode: true }) includeAllProperties?: boolean,

  /** Indicates whether to return the latest and latest completed builds for this definition. */
  @query(#{ explode: true }) includeLatestBuilds?: boolean,

  /** If specified, filters to definitions that use the specified task. */
  @format("uuid") @query(#{ explode: true }) taskIdFilter?: string,

  /** If specified, filters to definitions with the given process type. */
  @query(#{ explode: true }) processType?: int32,

  /** If specified, filters to YAML definitions that match the given filename. To use this filter includeAllProperties should be set to true */
  @query(#{ explode: true }) yamlFilename?: string,

  ...Parameters.`api-Version-preview`.`8`,
): Body<BuildDefinitionReference[]>;

/** Creates a new definition. */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "definitions")
@extension("x-ms-vss-method", "CreateDefinition")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions")
@post
op Definitions_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @query(#{ explode: true }) definitionToCloneId?: int32,
  @query(#{ explode: true }) definitionToCloneRevision?: int32,
  ...Parameters.`api-Version-preview`.`8`,

  /** The definition. */
  @body body: BuildDefinition,
): BuildDefinition;

/** Deletes a definition and all associated builds. */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "definitions")
@extension("x-ms-vss-method", "DeleteDefinition")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}")
@delete
op Definitions_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  ...Parameters.`api-Version-preview`.`8`,
): OkResponse;

/** Gets a definition, optionally at a specific revision. */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "definitions")
@extension("x-ms-vss-method", "GetDefinition")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}")
@get
op Definitions_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The revision number to retrieve. If this is not specified, the latest version will be returned. */
  @query(#{ explode: true }) revision?: int32,

  /** If specified, indicates the date from which metrics should be included. */
  @query(#{ explode: true }) minMetricsTime?: utcDateTime,

  /** A comma-delimited list of properties to include in the results. */
  @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

  @query(#{ explode: true }) includeLatestBuilds?: boolean,
  ...Parameters.`api-Version-preview`.`8`,
): BuildDefinition;

/** Restores a deleted definition */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "definitions")
@extension("x-ms-vss-method", "RestoreDefinition")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}")
@patch
op `Definitions_Restore Definition`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The identifier of the definition to restore. */
  @path definitionId: int32,

  /** When false, restores a deleted definition. */
  @query(#{ explode: true }) deleted: boolean,

  ...Parameters.`api-Version-preview`.`8`,
): BuildDefinition;

/** Updates an existing build definition. In order for this operation to succeed, the value of the 'Revision' property of the request body must match the existing build definition's. It is recommended that you obtain the existing build definition by using GET, modify the build definition as necessary, and then submit the modified definition with PUT. */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.8")
@extension("x-ms-vss-resource", "definitions")
@extension("x-ms-vss-method", "UpdateDefinition")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}")
@put
op Definitions_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** Optional ID of the definition to use as the source for secrets. */
  @query(#{ explode: true }) secretsSourceDefinitionId?: int32,

  /** Optional revision of the secrets source definition. */
  @query(#{ explode: true }) secretsSourceDefinitionRevision?: int32,

  /** If true, cancels paused builds when the pipeline is being enabled from a paused or disabled state. */
  @query(#{ explode: true }) cancelPausedBuilds?: boolean,

  ...Parameters.`api-Version-preview`.`8`,

  /** The new version of the definition. Its 'Revision' property must match the existing definition for the update to be accepted. */
  @body body: BuildDefinition,
): BuildDefinition;

/** Gets build metrics for a definition. */
@tag("Metrics")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "metrics")
@extension("x-ms-vss-method", "GetDefinitionMetrics")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/metrics")
@get
op `Metrics_Get Definition Metrics`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The date from which to calculate metrics. */
  @query(#{ explode: true }) minMetricsTime?: utcDateTime,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BuildMetric[]>;

/** Gets properties for a definition. */
@tag("Properties")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "properties")
@extension("x-ms-vss-method", "GetDefinitionProperties")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/properties")
@get
op `Properties_Get Definition Properties`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** A comma-delimited list of properties. If specified, filters to these specific properties. */
  @format("array (string)") @query(#{ explode: true }) filter?: string,

  ...Parameters.`api-Version-preview`.`1`,
): PropertiesCollection;

/** Updates properties for a definition. */
@tag("Properties")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "properties")
@extension("x-ms-vss-method", "UpdateDefinitionProperties")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/properties")
@patch
op `Properties_Update Definition Properties`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  ...Parameters.`api-Version-preview`.`1`,
  @header contentType: "application/json-patch+json",

  /** A json-patch document describing the properties to update. */
  @body body: JsonPatchDocument,
): PropertiesCollection;

@tag("Resources")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "resources")
@extension("x-ms-vss-method", "GetDefinitionResources")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/resources")
@get
op Resources_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path definitionId: int32,
  ...Parameters.`api-Version-preview`.`1`,
): Body<DefinitionResourceReference[]>;

@tag("Resources")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "resources")
@extension("x-ms-vss-method", "AuthorizeDefinitionResources")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/resources")
@patch
op `Resources_Authorize Definition Resources`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path definitionId: int32,
  ...Parameters.`api-Version-preview`.`1`,
  @body body: DefinitionResourceReference[],
): Body<DefinitionResourceReference[]>;

/** Gets all revisions of a definition. */
@tag("Definitions")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "revisions")
@extension("x-ms-vss-method", "GetDefinitionRevisions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/revisions")
@get
op `Definitions_Get Definition Revisions`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  ...Parameters.`api-Version-preview`.`3`,
): Body<BuildDefinitionRevision[]>;

/** Converts a definition to YAML, optionally at a specific revision. */
@tag("Yaml")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "yaml")
@extension("x-ms-vss-method", "GetDefinitionYaml")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/yaml")
@get
op Yaml_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The revision number to retrieve. If this is not specified, the latest version will be returned. */
  @query(#{ explode: true }) revision?: int32,

  /** If specified, indicates the date from which metrics should be included. */
  @query(#{ explode: true }) minMetricsTime?: utcDateTime,

  /** A comma-delimited list of properties to include in the results. */
  @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

  @query(#{ explode: true }) includeLatestBuilds?: boolean,
  ...Parameters.`api-Version-preview`.`1`,
): YamlBuild;

/** Gets all definition templates. */
@tag("Templates")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "templates")
@extension("x-ms-vss-method", "GetTemplates")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/templates")
@get
op Templates_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<BuildDefinitionTemplate[]>;

/** Deletes a build definition template. */
@tag("Templates")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "templates")
@extension("x-ms-vss-method", "DeleteTemplate")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/templates/{templateId}")
@delete
op Templates_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the template. */
  @path templateId: string,

  ...Parameters.`api-Version-preview`.`3`,
): OkResponse;

/** Gets a specific build definition template. */
@tag("Templates")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "templates")
@extension("x-ms-vss-method", "GetTemplate")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/templates/{templateId}")
@get
op Templates_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the requested template. */
  @path templateId: string,

  ...Parameters.`api-Version-preview`.`3`,
): BuildDefinitionTemplate;

/** Updates an existing build definition template. */
@tag("Templates")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "templates")
@extension("x-ms-vss-method", "SaveTemplate")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/templates/{templateId}")
@put
op `Templates_Save Template`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the template. */
  @path templateId: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** The new version of the template. */
  @body body: BuildDefinitionTemplate,
): BuildDefinitionTemplate;

/** Deletes a definition folder. Definitions and their corresponding builds will also be deleted. */
@tag("Folders")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "folders")
@extension("x-ms-vss-method", "DeleteFolder")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/folders")
@delete
op Folders_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The full path to the folder. */
  @query(#{ explode: true }) path: string,

  ...Parameters.`api-Version-preview`.`2`,
): OkResponse;

/** Updates an existing folder at given existing path */
@tag("Folders")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "folders")
@extension("x-ms-vss-method", "UpdateFolder")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/folders")
@post
op Folders_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The full path to the folder. */
  @query(#{ explode: true }) path: string,

  ...Parameters.`api-Version-preview`.`2`,

  /** The new version of the folder. */
  @body body: Folder,
): Folder;

/** Creates a new folder. */
@tag("Folders")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "folders")
@extension("x-ms-vss-method", "CreateFolder")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/folders")
@put
op Folders_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The full path of the folder. */
  @query(#{ explode: true }) path: string,

  ...Parameters.`api-Version-preview`.`2`,

  /** The folder. */
  @body body: Folder,
): Folder;

/** Gets a list of build definition folders. */
@tag("Folders")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "folders")
@extension("x-ms-vss-method", "GetFolders")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/folders/{path}")
@get
op Folders_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The path to start with. */
  @extension("x-ms-required", false) @path path: string,

  /** The order in which folders should be returned. */
  @extension(
    "x-ms-enum",
    #{
      name: "FolderQueryOrder",
      values: #[
        #{ value: "none", description: "No order" },
        #{ value: "folderAscending", description: "Order by folder name and path ascending." },
        #{ value: "folderDescending", description: "Order by folder name and path descending." }
      ],
    }
  )
  @query(#{ explode: true })
  queryOrder?: "none" | "folderAscending" | "folderDescending",

  ...Parameters.`api-Version-preview`.`2`,
): Body<Folder[]>;

/** Gets pipeline general settings. */
@tag("General Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "generalSettings")
@extension("x-ms-vss-method", "GetBuildGeneralSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/generalsettings")
@get
op `General Settings_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): PipelineGeneralSettings;

/** Updates pipeline general settings. */
@tag("General Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "generalSettings")
@extension("x-ms-vss-method", "UpdateBuildGeneralSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/generalsettings")
@patch
op `General Settings_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: PipelineGeneralSettings,
): PipelineGeneralSettings;

/** Gets the latest build for a definition, optionally scoped to a specific branch. */
@tag("Latest")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "latest")
@extension("x-ms-vss-method", "GetLatestBuild")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/latest/{definition}")
@get
op Latest_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** definition name with optional leading folder path, or the definition id */
  @path definition: string,

  /** optional parameter that indicates the specific branch to use. If not specified, the default branch is used. */
  @query(#{ explode: true }) branchName?: string,

  ...Parameters.`api-Version-preview`.`2`,
): Build;

/** Gets build metrics for a project. */
@tag("Metrics")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "metrics")
@extension("x-ms-vss-method", "GetProjectMetrics")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/metrics/{metricAggregationType}")
@get
op `Metrics_Get Project Metrics`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The aggregation type to use (hourly, daily). */
  @extension("x-ms-required", false) @path metricAggregationType: string,

  /** The date from which to calculate metrics. */
  @query(#{ explode: true }) minMetricsTime?: utcDateTime,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BuildMetric[]>;

/** Gets all build definition options supported by the system. */
@tag("Options")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "options")
@extension("x-ms-vss-method", "GetBuildOptionDefinitions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/options")
@get
op Options_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`2`,
): Body<BuildOptionDefinition[]>;

/** Gets a badge that indicates the status of the most recent build for the specified branch. */
@tag("Badge")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "buildbadge")
@extension("x-ms-vss-method", "GetBuildBadge")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/repos/{repoType}/badge")
@get
op `Badge_Get Build Badge Data`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The repository type. */
  @path repoType: string,

  /** The repository ID. */
  @query(#{ explode: true }) repoId?: string,

  /** The branch name. */
  @query(#{ explode: true }) branchName?: string,

  ...Parameters.`api-Version-preview`.`2`,
): Body<string>;

/** Gets the project's retention settings. */
@tag("Retention")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "retention")
@extension("x-ms-vss-method", "GetRetentionSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention")
@get
op Retention_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): ProjectRetentionSetting;

/** Updates the project's retention settings. */
@tag("Retention")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "retention")
@extension("x-ms-vss-method", "UpdateRetentionSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention")
@patch
op Retention_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: UpdateProjectRetentionSettingModel,
): ProjectRetentionSetting;

/** Removes specific retention leases. */
@tag("Leases")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "leases")
@extension("x-ms-vss-method", "DeleteRetentionLeasesById")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention/leases")
@delete
op Leases_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @format("array (int32)") @query(#{ explode: true }) ids: string,
  ...Parameters.`api-Version-preview`.`2`,
): OkResponse;

/** Returns any leases matching the specified MinimalRetentionLeases */
@tag("Leases")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "leases")
@extension("x-ms-vss-method", "GetRetentionLeasesByMinimalRetentionLeases")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention/leases")
@get
op `Leases_Get Retention Leases By Minimal Retention Leases`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** List of JSON-serialized MinimalRetentionLeases separated by '|' */
  @format("array (MinimalRetentionLease)") @query(#{ explode: true }) leasesToFetch: string,

  ...Parameters.`api-Version-preview`.`2`,
): Body<RetentionLease[]>;

/** Adds new leases for pipeline runs. */
@tag("Leases")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "leases")
@extension("x-ms-vss-method", "AddRetentionLeases")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention/leases")
@post
op Leases_Add(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`2`,
  @body body: NewRetentionLease[],
): Body<RetentionLease[]>;

/** Returns the details of the retention lease given a lease id. */
@tag("Leases")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "leases")
@extension("x-ms-vss-method", "GetRetentionLease")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention/leases/{leaseId}")
@get
op Leases_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path leaseId: int32,
  ...Parameters.`api-Version-preview`.`2`,
): RetentionLease;

/** Updates the duration or pipeline protection status of a retention lease. */
@tag("Leases")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "leases")
@extension("x-ms-vss-method", "UpdateRetentionLease")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/retention/leases/{leaseId}")
@patch
op Leases_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the lease to update. */
  @path leaseId: int32,

  ...Parameters.`api-Version-preview`.`2`,

  /** The new data for the retention lease. */
  @body body: RetentionLeaseUpdate,
): RetentionLease;

/** Gets the build settings. */
@tag("Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "settings")
@extension("x-ms-vss-method", "GetBuildSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/settings")
@get
op Settings_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): BuildSettings;

/** Updates the build settings. */
@tag("Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "settings")
@extension("x-ms-vss-method", "UpdateBuildSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/settings")
@patch
op Settings_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** The new settings. */
  @body body: BuildSettings,
): BuildSettings;

/** <p>Gets the build status for a definition, optionally scoped to a specific branch, stage, job, and configuration.</p> <p>If there are more than one, then it is required to pass in a stageName value when specifying a jobName, and the same rule then applies for both if passing a configuration parameter.</p> */
@tag("Status")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "status")
@extension("x-ms-vss-method", "GetStatusBadge")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/status/{definition}")
@get
op Status_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Either the definition name with optional leading folder path, or the definition id. */
  @path definition: string,

  /** Only consider the most recent build for this branch. If not specified, the default branch is used. */
  @query(#{ explode: true }) branchName?: string,

  /** Use this stage within the pipeline to render the status. */
  @query(#{ explode: true }) stageName?: string,

  /** Use this job within a stage of the pipeline to render the status. */
  @query(#{ explode: true }) jobName?: string,

  /** Use this job configuration to render the status */
  @query(#{ explode: true }) configuration?: string,

  /** Replaces the default text on the left side of the badge. */
  @query(#{ explode: true }) label?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<string>;

/** Gets a list of all build tags in the project. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "GetTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/tags")
@get
op `Tags_Get Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Removes a tag from builds, definitions, and from the tag store */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "DeleteTag")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/tags/{tag}")
@delete
op `Tags_Delete Tag`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The tag to remove. */
  @path tag: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Gets all the work items between two builds. */
@tag("Builds")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "workitems")
@extension("x-ms-vss-method", "GetWorkItemsBetweenBuilds")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/workitems")
@get
op `Builds_Get Work Items Between Builds`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the first build. */
  @query(#{ explode: true }) fromBuildId: int32,

  /** The ID of the last build. */
  @query(#{ explode: true }) toBuildId: int32,

  /** The maximum number of work items to return. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`2`,
): Body<ResourceRef[]>;

/** Get a list of source providers and their capabilities. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "sourceProviders")
@extension("x-ms-vss-method", "ListSourceProviders")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceproviders")
@get
op `Source Providers_List`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<SourceProviderAttributes[]>;

/** Gets a list of branches for the given source code repository. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "branches")
@extension("x-ms-vss-method", "ListBranches")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/branches")
@get
op `Source Providers_List Branches`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  /** The vendor-specific identifier or the name of the repository to get branches. Can only be omitted for providers that do not support multiple repositories. */
  @query(#{ explode: true }) repository?: string,

  /** If supplied, the name of the branch to check for specifically. */
  @query(#{ explode: true }) branchName?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<string[]>;

/** Gets the contents of a file in the given source code repository. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "fileContents")
@extension("x-ms-vss-method", "GetFileContents")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/filecontents")
@get
op `Source Providers_Get File Contents`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  /** If specified, the vendor-specific identifier or the name of the repository to get branches. Can only be omitted for providers that do not support multiple repositories. */
  @query(#{ explode: true }) repository?: string,

  /** The identifier of the commit or branch from which a file's contents are retrieved. */
  @query(#{ explode: true }) commitOrBranch?: string,

  /** The path to the file to retrieve, relative to the root of the repository. */
  @query(#{ explode: true }) path?: string,

  ...Parameters.`api-Version-preview`.`1`,
): {
  @header contentType: "text/plain";
  @body @format("Stream") body: string;
};

/** Gets the contents of a directory in the given source code repository. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pathContents")
@extension("x-ms-vss-method", "GetPathContents")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/pathcontents")
@get
op `Source Providers_Get Path Contents`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  /** If specified, the vendor-specific identifier or the name of the repository to get branches. Can only be omitted for providers that do not support multiple repositories. */
  @query(#{ explode: true }) repository?: string,

  /** The identifier of the commit or branch from which a file's contents are retrieved. */
  @query(#{ explode: true }) commitOrBranch?: string,

  /** The path contents to list, relative to the root of the repository. */
  @query(#{ explode: true }) path?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<SourceRepositoryItem[]>;

/** Gets a pull request object from source provider. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pullRequests")
@extension("x-ms-vss-method", "GetPullRequest")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/pullrequests/{pullRequestId}")
@get
op `Source Providers_Get Pull Request`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** Vendor-specific id of the pull request. */
  @path pullRequestId: string,

  /** Vendor-specific identifier or the name of the repository that contains the pull request. */
  @query(#{ explode: true }) repositoryId?: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  ...Parameters.`api-Version-preview`.`1`,
): PullRequest;

/** Gets a list of source code repositories. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "repositories")
@extension("x-ms-vss-method", "ListRepositories")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/repositories")
@get
op `Source Providers_List Repositories`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  /** If specified, the vendor-specific identifier or the name of a single repository to get. */
  @query(#{ explode: true }) repository?: string,

  /** 'top' for the repositories most relevant for the endpoint. If not set, all repositories are returned. Ignored if 'repository' is set. */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultSet",
      values: #[
        #{ value: "all", description: "Include all repositories" },
        #{ value: "top", description: "Include most relevant repositories for user" }
      ],
    }
  )
  @query(#{ explode: true })
  resultSet?: "all" | "top",

  /** If set to true, this will limit the set of results and will return a continuation token to continue the query. */
  @query(#{ explode: true }) pageResults?: boolean,

  /** When paging results, this is a continuation token, returned by a previous call to this method, that can be used to return the next set of repositories. */
  @query(#{ explode: true }) continuationToken?: string,

  ...Parameters.`api-Version-preview`.`1`,
): SourceRepositories;

/** Gets a list of webhooks installed in the given source code repository. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "webhooks")
@extension("x-ms-vss-method", "ListWebhooks")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/webhooks")
@get
op `Source Providers_List Webhooks`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  /** If specified, the vendor-specific identifier or the name of the repository to get webhooks. Can only be omitted for providers that do not support multiple repositories. */
  @query(#{ explode: true }) repository?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<RepositoryWebhook[]>;

/** Recreates the webhooks for the specified triggers in the given source code repository. */
@tag("Source Providers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "webhooks")
@extension("x-ms-vss-method", "RestoreWebhooks")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/sourceProviders/{providerName}/webhooks")
@post
op `Source Providers_Restore Webhooks`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name of the source provider. */
  @path providerName: string,

  /** If specified, the ID of the service endpoint to query. Can only be omitted for providers that do not use service endpoints, e.g. TFVC or TFGit. */
  @format("uuid") @query(#{ explode: true }) serviceEndpointId?: string,

  /** If specified, the vendor-specific identifier or the name of the repository to get webhooks. Can only be omitted for providers that do not support multiple repositories. */
  @query(#{ explode: true }) repository?: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** The types of triggers to restore webhooks for. */
  @body body: string[],
): OkResponse;

/** Gets the tags for a definition. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "GetDefinitionTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/tags")
@get
op `Tags_Get Definition Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The definition revision number. If not specified, uses the latest revision of the definition. */
  @query(#{ explode: true }) revision?: int32,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Adds/Removes tags from a definition. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "UpdateDefinitionTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/tags")
@patch
op `Tags_Update Definition Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  ...Parameters.`api-Version-preview`.`3`,

  /** The tags to add/remove. */
  @body body: UpdateTagParameters,
): Body<string[]>;

/** Adds multiple tags to a definition. */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "AddDefinitionTags")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/tags")
@post
op `Tags_Add Definition Tags`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  ...Parameters.`api-Version-preview`.`3`,

  /** The tags to add. */
  @body body: string[],
): Body<string[]>;

/** Removes a tag from a definition. NOTE: This API will not work for tags with special characters. To remove tags with special characters, use the PATCH method instead (in 6.0+) */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "DeleteDefinitionTag")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/tags/{tag}")
@delete
op `Tags_Delete Definition Tag`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The tag to remove. */
  @path tag: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

/** Adds a tag to a definition */
@tag("Tags")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "tags")
@extension("x-ms-vss-method", "AddDefinitionTag")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/build/definitions/{definitionId}/tags/{tag}")
@put
op `Tags_Add Definition Tag`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The ID of the definition. */
  @path definitionId: int32,

  /** The tag to add. */
  @path tag: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<string[]>;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `3` {
      /** Version of the API to use. This should be set to '7.2-preview.3' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `5` {
      /** Version of the API to use. This should be set to '7.2-preview.5' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `8` {
      /** Version of the API to use. This should be set to '7.2-preview.8' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
