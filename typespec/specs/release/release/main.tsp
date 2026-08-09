import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Release" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://vsrm.dev.azure.com")
namespace Release;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AgentArtifactDefinition {
  /** Gets or sets the artifact definition alias. */
  `alias`?: string;

  /** Gets or sets the artifact type. */
  @extension(
    "x-ms-enum",
    #{
      name: "AgentArtifactType",
      values: #[
        #{ value: "xamlBuild", description: "Indicates XamlBuild artifact" },
        #{ value: "build", description: "Indicates Build artifact" },
        #{ value: "jenkins", description: "Indicates Jenkins artifact" },
        #{ value: "fileShare", description: "Indicates FileShare artifact" },
        #{ value: "nuget", description: "Indicates Nuget artifact" },
        #{ value: "tfsOnPrem", description: "Indicates TfsOnPrem artifact" },
        #{ value: "gitHub", description: "Indicates GitHub artifact" },
        #{ value: "tfGit", description: "Indicates TFGit artifact" },
        #{ value: "externalTfsBuild", description: "Indicates ExternalTfsBuild artifact" },
        #{ value: "custom", description: "Indicates Custom artifact" },
        #{ value: "tfvc", description: "Indicates Tfvc artifact" }
      ],
    }
  )
  artifactType?:
    | "xamlBuild"
    | "build"
    | "jenkins"
    | "fileShare"
    | "nuget"
    | "tfsOnPrem"
    | "gitHub"
    | "tfGit"
    | "externalTfsBuild"
    | "custom"
    | "tfvc";

  /** Gets or sets the artifact definition details. */
  details?: string;

  /** Gets or sets the name of artifact definition. */
  name?: string;

  /** Gets or sets the version of artifact definition. */
  version?: string;
}

model AgentBasedDeployPhase {
  ...DeployPhase;
  deploymentInput?: AgentDeploymentInput;
}

model AgentDeploymentInput {
  ...DeploymentInput;
  agentSpecification?: AgentSpecification;

  /** Gets or sets the image ID. */
  imageId?: int32;

  parallelExecution?: ExecutionInput;
}

/** Represents a reference to an agent queue. */
model AgentPoolQueueReference {
  ...ResourceReference;

  /** The ID of the queue. */
  id?: int32;
}

/** Specification of the agent defined by the pool provider. */
model AgentSpecification {
  /** Agent specification unique identifier. */
  identifier?: string;
}

model ApprovalOptions {
  /** Specify whether the approval can be skipped if the same approver approved the previous stage. */
  autoTriggeredAndPreviousEnvironmentApprovedCanBeSkipped?: boolean;

  /** Specify whether revalidate identity of approver before completing the approval. */
  enforceIdentityRevalidation?: boolean;

  /** Approvals execution order. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalExecutionOrder",
      values: #[
        #{ value: "beforeGates", description: "Approvals shown before gates." },
        #{
          value: "afterSuccessfulGates",
          description: "Approvals shown after successful execution of gates.",
        },
        #{
          value: "afterGatesAlways",
          description: "Approvals shown always after execution of gates.",
        }
      ],
    }
  )
  executionOrder?: "beforeGates" | "afterSuccessfulGates" | "afterGatesAlways";

  /** Specify whether the user requesting a release or deployment should allow to approver. */
  releaseCreatorCanBeApprover?: boolean;

  /** The number of approvals required to move release forward. '0' means all approvals required. */
  requiredApproverCount?: int32;

  /** Approval timeout. Approval default timeout is 30 days. Maximum allowed timeout is 365 days. '0' means default timeout i.e 30 days. */
  timeoutInMinutes?: int32;
}

model Artifact {
  /** Gets or sets alias. */
  `alias`?: string;

  /** Gets or sets definition reference. e.g. {'project':{'id':'fed755ea-49c5-4399-acea-fd5b5aa90a6c','name':'myProject'},'definition':{'id':'1','name':'mybuildDefinition'},'connection':{'id':'1','name':'myConnection'}}. */
  definitionReference?: Record<ArtifactSourceReference>;

  /** Indicates whether artifact is primary or not. */
  isPrimary?: boolean;

  /** Indicates whether artifact is retained by release or not. */
  isRetained?: boolean;

  /** Gets or sets type. It can have value as 'Build', 'Jenkins', 'GitHub', 'Nuget', 'Team Build (external)', 'ExternalTFSBuild', 'Git', 'TFVC', 'ExternalTfsXamlBuild'. */
  type?: string;
}

model ArtifactContributionDefinition {
  artifactTriggerConfiguration?: ArtifactTriggerConfiguration;
  artifactType?: string;
  artifactTypeStreamMapping?: Record<string>;
  browsableArtifactTypeMapping?: Record<string>;
  dataSourceBindings?: DataSourceBinding[];
  displayName?: string;
  downloadTaskId?: string;
  endpointTypeId?: string;
  inputDescriptors?: InputDescriptor[];
  isCommitsTraceabilitySupported?: boolean;
  isWorkitemsTraceabilitySupported?: boolean;
  name?: string;
  taskInputMapping?: Record<string>;
  uniqueSourceIdentifier?: string;
}

model ArtifactDownloadInputBase {
  /** Gets or sets the alias of artifact. */
  `alias`?: string;

  /** Gets or sets the name of artifact definition. Valid values are 'Skip', 'Selective', 'All'. */
  artifactDownloadMode?: string;

  /** Gets or sets the artifact items of the input. */
  artifactItems?: string[];

  /** Gets or sets the type of artifact. */
  artifactType?: string;
}

model ArtifactFilter {
  /** Gets or sets whether a release should be created on build tagging. */
  createReleaseOnBuildTagging?: boolean;

  /** Gets or sets the branch for the filter. */
  sourceBranch?: string;

  tagFilter?: TagFilter;

  /** Gets or sets the list of tags for the filter. */
  tags?: string[];

  /** Gets or sets whether filter should default to build definition branch. */
  useBuildDefinitionBranch?: boolean;
}

model ArtifactInstanceData {
  accountName?: string;
  authenticationToken?: string;
  tfsUrl?: string;
  version?: string;
}

model ArtifactMetadata {
  /** Sets alias of artifact. */
  `alias`?: string;

  instanceReference?: BuildVersion;
}

model ArtifactProvider {
  /** Gets or sets the id of artifact provider. */
  id?: int32;

  /** Gets or sets the name of artifact provider. */
  name?: string;

  /** Gets or sets the link of artifact provider. */
  sourceUri?: string;

  /** Gets or sets the version of artifact provider. */
  version?: string;
}

model ArtifactsDownloadInput {
  downloadInputs?: ArtifactDownloadInputBase[];
}

model ArtifactSourceId {
  /** Gets or sets the artifact type of artifact source. */
  artifactTypeId?: string;

  /** Gets or sets the list of sourceIdInput of artifact source. */
  sourceIdInputs?: SourceIdInput[];
}

model ArtifactSourceIdsQueryResult {
  /** Gets or sets the list of artifactsourceIds. */
  artifactSourceIds?: ArtifactSourceId[];
}

model ArtifactSourceReference {
  /** ID of the artifact source. */
  id?: string;

  /** Name of the artifact source. */
  name?: string;
}

model ArtifactSourceTrigger {
  ...ReleaseTriggerBase;

  /** Artifact source alias for Artifact Source trigger type */
  artifactAlias?: string;

  triggerConditions?: ArtifactFilter[];
}

model ArtifactTriggerConfiguration {
  /** Gets or sets the whether trigger is supported or not. */
  isTriggerSupported?: boolean;

  /** Gets or sets the whether trigger is supported only on hosted environment. */
  isTriggerSupportedOnlyInHosted?: boolean;

  /** Gets or sets the whether webhook is supported at server level. */
  isWebhookSupportedAtServerLevel?: boolean;

  /** Gets or sets the payload hash header name for the artifact trigger configuration. */
  payloadHashHeaderName?: string;

  /** Gets or sets the resources for artifact trigger configuration. */
  resources?: Record<string>;

  /** Gets or sets the webhook payload mapping for artifact trigger configuration. */
  webhookPayloadMapping?: Record<string>;
}

model ArtifactTypeDefinition {
  artifactTriggerConfiguration?: ArtifactTriggerConfiguration;

  /** Gets or sets the artifact type of artifact type definition. Valid values are 'Build', 'Package', 'Source' or 'ContainerImage'. */
  artifactType?: string;

  /** Gets or sets the display name of artifact type definition. */
  displayName?: string;

  /** Gets or sets the endpoint type id of artifact type definition. */
  endpointTypeId?: string;

  /** Gets or sets the input descriptors of artifact type definition. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets the is commits tracebility supported value of artifact type defintion. */
  isCommitsTraceabilitySupported?: boolean;

  /** Gets or sets the is workitems tracebility supported value of artifact type defintion. */
  isWorkitemsTraceabilitySupported?: boolean;

  /** Gets or sets the name of artifact type definition. */
  name?: string;

  /** Gets or sets the unique source identifier of artifact type definition. */
  uniqueSourceIdentifier?: string;
}

model ArtifactVersion {
  /** Gets or sets the alias of artifact. */
  `alias`?: string;

  defaultVersion?: BuildVersion;

  /** Gets or sets the error message encountered during querying of versions for artifact. */
  errorMessage?: string;

  /** Gets or sets the list of build versions of artifact. */
  versions?: BuildVersion[];
}

model ArtifactVersionQueryResult {
  /** Gets or sets the list for artifact versions of artifact version query result. */
  artifactVersions?: ArtifactVersion[];
}

model AuthorizationHeader {
  name?: string;
  value?: string;
}

model AutoTriggerIssue {
  issue?: Issue;
  @extension(
    "x-ms-enum",
    #{
      name: "IssueSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "user", description: "" },
        #{ value: "system", description: "" }
      ],
    }
  )
  issueSource?: "none" | "user" | "system";
  project?: ProjectReference;
  releaseDefinitionReference?: ReleaseDefinitionShallowReference;
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseTriggerType",
      values: #[
        #{ value: "undefined", description: "Release trigger type not set." },
        #{ value: "artifactSource", description: "Artifact based release trigger." },
        #{ value: "schedule", description: "Schedule based release trigger." },
        #{ value: "sourceRepo", description: "Source repository based release trigger." },
        #{ value: "containerImage", description: "Container image based release trigger." },
        #{ value: "package", description: "Package based release trigger." },
        #{ value: "pullRequest", description: "Pull request based release trigger." }
      ],
    }
  )
  releaseTriggerType?:
    | "undefined"
    | "artifactSource"
    | "schedule"
    | "sourceRepo"
    | "containerImage"
    | "package"
    | "pullRequest";
}

model AzureKeyVaultVariableGroupProviderData {
  ...VariableGroupProviderData;

  /** Gets or sets last refreshed time. */
  lastRefreshedOn?: utcDateTime;

  /** Gets or sets the service endpoint ID. */
  @format("uuid") serviceEndpointId?: string;

  /** Gets or sets the vault name. */
  vault?: string;
}

model AzureKeyVaultVariableValue {
  ...VariableValue;

  /** Gets or sets the content type of key vault variable value. */
  contentType?: string;

  /** Indicates the vault variable value enabled or not. */
  enabled?: boolean;

  /** Gets or sets the expire time of key vault variable value. */
  expires?: utcDateTime;
}

model BaseDeploymentInput {
  /** Gets or sets the job condition. */
  condition?: string;

  /** Gets or sets the job cancel timeout in minutes for deployment which are cancelled by user for this release environment. */
  jobCancelTimeoutInMinutes?: int32;

  /** Gets or sets the override inputs. */
  overrideInputs?: Record<string>;

  /** Gets or sets the job execution timeout in minutes for deployment which are queued against this release environment. */
  timeoutInMinutes?: int32;
}

model BuildArtifactDownloadInput {
  ...ArtifactDownloadInputBase;
}

model BuildVersion {
  /** Gets or sets the commit message for the artifact. */
  commitMessage?: string;

  /** Gets or sets the definition id. */
  definitionId?: string;

  /** Gets or sets the definition name. */
  definitionName?: string;

  /** Gets or sets the build id. */
  id?: string;

  /** Gets or sets if the artifact supports multiple definitions. */
  isMultiDefinitionType?: boolean;

  /** Gets or sets the build number. */
  name?: string;

  /** Gets or sets the source branch for the artifact. */
  sourceBranch?: string;

  sourcePullRequestVersion?: SourcePullRequestVersion;

  /** Gets or sets the repository id for the artifact. */
  sourceRepositoryId?: string;

  /** Gets or sets the repository type for the artifact. */
  sourceRepositoryType?: string;

  /** Gets or sets the source version for the artifact. */
  sourceVersion?: string;
}

/** Represents a change associated with a build. */
model Change {
  author?: IdentityRef;

  /** The type of source. 'TfsVersionControl', 'TfsGit', etc. */
  changeType?: string;

  /** The location of a user-friendly representation of the resource. */
  displayUri?: string;

  /** Something that identifies the change. For a commit, this would be the SHA1. For a TFVC changeset, this would be the changeset id. */
  id?: string;

  /** The location of the full representation of the resource. */
  location?: string;

  /** A description of the change. This might be a commit message or changeset description. */
  message?: string;

  pushedBy?: IdentityRef;

  /** A timestamp for the change. */
  timestamp?: utcDateTime;
}

model CheckConfigurationReference {
  /** Check configuration Id of generated gate. */
  id?: int32;

  /** Name of the resource for which gate was generated. */
  resourceName?: string;

  /** Type of the resource for which the gate was generated. */
  resourceType?: string;

  /** Version of the check configuration gate was generated with. */
  version?: int32;
}

model CheckConfigurationResource {
  /** Id of the resource. */
  id?: string;

  /** Name of the resource. */
  name?: string;

  /** Type of the resource. */
  type?: string;
}

model CodeRepositoryReference {
  /** Gets and sets the repository references. */
  repositoryReference?: Record<ReleaseManagementInputValue>;

  /** It can have value as ‘GitHub’, ‘Vsts’. */
  @extension(
    "x-ms-enum",
    #{
      name: "PullRequestSystemType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "tfsGit", description: "" },
        #{ value: "gitHub", description: "" }
      ],
    }
  )
  systemType?: "none" | "tfsGit" | "gitHub";
}

model ComplianceSettings {
  /** Scan the release definition for secrets */
  checkForCredentialsAndOtherSecrets?: boolean;
}

model Condition {
  /** Gets or sets the condition type. */
  @extension(
    "x-ms-enum",
    #{
      name: "ConditionType",
      values: #[
        #{ value: "undefined", description: "The condition type is undefined." },
        #{ value: "event", description: "The condition type is event." },
        #{ value: "environmentState", description: "The condition type is environment state." },
        #{ value: "artifact", description: "The condition type is artifact." }
      ],
    }
  )
  conditionType?: "undefined" | "event" | "environmentState" | "artifact";

  /** Gets or sets the name of the condition. e.g. 'ReleaseStarted'. */
  name?: string;

  /** The release condition result. */
  result?: boolean;

  /** Gets or set value of the condition. */
  value?: string;
}

model ConfigurationVariableValue {
  /** Gets and sets if a variable can be overridden at deployment time or not. */
  allowOverride?: boolean;

  /** Gets or sets as variable is secret or not. */
  isSecret?: boolean;

  /** Gets and sets value of the configuration variable. */
  value?: string;
}

model Consumer {
  /** ID of the consumer. */
  consumerId?: int32;

  /** Name of the consumer. */
  consumerName?: string;
}

model ContainerImageTrigger {
  ...ReleaseTriggerBase;

  /** Alias of the trigger. */
  `alias`?: string;

  /** List tag filters applied while trigger. */
  tagFilters?: TagFilter[];
}

model ContinuousDeploymentTriggerIssue {
  ...AutoTriggerIssue;

  /** Artifact type. */
  artifactType?: string;

  /** ArtifactVersion ID. */
  artifactVersionId?: string;

  /** Artifact source ID. */
  sourceId?: string;
}

model ControlOptions {
  /** Always run the job. */
  alwaysRun?: boolean;

  /** Indicates whether to continue job on error or not. */
  continueOnError?: boolean;

  /** Indicates the job enabled or not. */
  enabled?: boolean;
}

model CustomArtifactDownloadInput {
  ...ArtifactDownloadInputBase;
}

model DataSourceBinding {
  /** Pagination format supported by this data source(ContinuationToken/SkipTop). */
  callbackContextTemplate?: string;

  /** Subsequent calls needed? */
  callBackRequiredTemplate?: string;

  /** Name of the datasource. */
  dataSourceName?: string;

  /** Endpoint ID of the datasource. */
  endpointId?: string;

  /** Endpoint URL of the datasource. */
  endpointUrl?: string;

  /** Defines the initial value of the query params */
  initialContextTemplate?: string;

  /** Parameters of the datasource. */
  parameters?: Record<string>;

  /** Gets or sets http request body */
  requestContent?: string;

  /** Gets or sets http request verb */
  requestVerb?: string;

  /** Result selector applied on output of datasource result, for example jsonpath:$.value[?(\@.properties.isEnabled == true)]. */
  resultSelector?: string;

  /** Format of the return results, for example. { 'Value' : '{{{id}}}', 'DisplayValue' : '{{{name}}}' }. */
  resultTemplate?: string;

  /** Target of the datasource. */
  target?: string;
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

model DefinitionEnvironmentReference {
  /** Definition environment ID. */
  definitionEnvironmentId?: int32;

  /** Definition environment name. */
  definitionEnvironmentName?: string;

  /** ReleaseDefinition ID. */
  releaseDefinitionId?: int32;

  /** ReleaseDefinition name. */
  releaseDefinitionName?: string;
}

model Demand {
  /** Gets and sets the name of demand. */
  name?: string;

  /** Gets and sets the value of demand. */
  value?: string;
}

model Deployment {
  /** Gets attempt number. */
  attempt?: int32;

  /** Gets the date on which deployment is complete. */
  completedOn?: utcDateTime;

  /** Gets the list of condition associated with deployment. */
  conditions?: Condition[];

  /** Gets release definition environment id. */
  definitionEnvironmentId?: int32;

  /** Gets status of the deployment. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentStatus",
      values: #[
        #{ value: "undefined", description: "The deployment status is undefined." },
        #{ value: "notDeployed", description: "The deployment status is not deployed." },
        #{ value: "inProgress", description: "The deployment status is in progress." },
        #{ value: "succeeded", description: "The deployment status is succeeded." },
        #{
          value: "partiallySucceeded",
          description: "The deployment status is partiallysucceeded.",
        },
        #{ value: "failed", description: "The deployment status is failed." },
        #{ value: "all", description: "The deployment status is all." }
      ],
    }
  )
  deploymentStatus?:
    | "undefined"
    | "notDeployed"
    | "inProgress"
    | "succeeded"
    | "partiallySucceeded"
    | "failed"
    | "all";

  /** Gets the unique identifier for deployment. */
  id?: int32;

  lastModifiedBy?: IdentityRef;

  /** Gets the date on which deployment is last modified. */
  lastModifiedOn?: utcDateTime;

  /** Gets operation status of deployment. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentOperationStatus",
      values: #[
        #{ value: "undefined", description: "The deployment operation status is undefined." },
        #{ value: "queued", description: "The deployment operation status is queued." },
        #{ value: "scheduled", description: "The deployment operation status is scheduled." },
        #{ value: "pending", description: "The deployment operation status is pending." },
        #{ value: "approved", description: "The deployment operation status is approved." },
        #{ value: "rejected", description: "The deployment operation status is rejected." },
        #{ value: "deferred", description: "The deployment operation status is deferred." },
        #{
          value: "queuedForAgent",
          description: "The deployment operation status is queued for agent.",
        },
        #{
          value: "phaseInProgress",
          description: "The deployment operation status is phase in progress.",
        },
        #{
          value: "phaseSucceeded",
          description: "The deployment operation status is phase succeeded.",
        },
        #{
          value: "phasePartiallySucceeded",
          description: "The deployment operation status is phase partially succeeded.",
        },
        #{ value: "phaseFailed", description: "The deployment operation status is phase failed." },
        #{ value: "canceled", description: "The deployment operation status is canceled." },
        #{
          value: "phaseCanceled",
          description: "The deployment operation status is phase canceled.",
        },
        #{
          value: "manualInterventionPending",
          description: "The deployment operation status is manualintervention pending.",
        },
        #{
          value: "queuedForPipeline",
          description: "The deployment operation status is queued for pipeline.",
        },
        #{ value: "cancelling", description: "The deployment operation status is cancelling." },
        #{
          value: "evaluatingGates",
          description: "The deployment operation status is EvaluatingGates.",
        },
        #{ value: "gateFailed", description: "The deployment operation status is GateFailed." },
        #{ value: "all", description: "The deployment operation status is all." }
      ],
    }
  )
  operationStatus?:
    | "undefined"
    | "queued"
    | "scheduled"
    | "pending"
    | "approved"
    | "rejected"
    | "deferred"
    | "queuedForAgent"
    | "phaseInProgress"
    | "phaseSucceeded"
    | "phasePartiallySucceeded"
    | "phaseFailed"
    | "canceled"
    | "phaseCanceled"
    | "manualInterventionPending"
    | "queuedForPipeline"
    | "cancelling"
    | "evaluatingGates"
    | "gateFailed"
    | "all";

  /** Gets list of PostDeployApprovals. */
  postDeployApprovals?: ReleaseApproval[];

  /** Gets list of PreDeployApprovals. */
  preDeployApprovals?: ReleaseApproval[];

  projectReference?: ProjectReference;

  /** Gets the date on which deployment is queued. */
  queuedOn?: utcDateTime;

  /** Gets reason of deployment. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentReason",
      values: #[
        #{ value: "none", description: "The deployment reason is none." },
        #{ value: "manual", description: "The deployment reason is manual." },
        #{ value: "automated", description: "The deployment reason is automated." },
        #{ value: "scheduled", description: "The deployment reason is scheduled." },
        #{ value: "redeployTrigger", description: "The deployment reason is RedeployTrigger." }
      ],
    }
  )
  reason?: "none" | "manual" | "automated" | "scheduled" | "redeployTrigger";

  release?: ReleaseReference;
  releaseDefinition?: ReleaseDefinitionShallowReference;
  releaseEnvironment?: ReleaseEnvironmentShallowReference;
  requestedBy?: IdentityRef;
  requestedFor?: IdentityRef;

  /** Gets the date on which deployment is scheduled. */
  scheduledDeploymentTime?: utcDateTime;

  /** Gets the date on which deployment is started. */
  startedOn?: utcDateTime;
}

model DeploymentApprovalCompletedEvent {
  ...DeploymentEvent;
  approval?: ReleaseApproval;
  project?: ProjectReference;
  release?: Release;
}

model DeploymentApprovalPendingEvent {
  ...DeploymentEvent;
  approval?: ReleaseApproval;
  approvalOptions?: ApprovalOptions;
  completedApprovals?: ReleaseApproval[];
  data?: Record<{}>;
  deployment?: Deployment;
  isMultipleRankApproval?: boolean;
  pendingApprovals?: ReleaseApproval[];
  project?: ProjectReference;
  release?: Release;
}

model DeploymentAttempt {
  /** Deployment attempt. */
  attempt?: int32;

  /** ID of the deployment. */
  deploymentId?: int32;

  /** Specifies whether deployment has started or not. */
  hasStarted?: boolean;

  /** ID of deployment. */
  id?: int32;

  /** All the issues related to the deployment. */
  issues?: Issue[];

  lastModifiedBy?: IdentityRef;

  /** Time when this deployment last modified. */
  lastModifiedOn?: utcDateTime;

  /** Deployment operation status. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentOperationStatus",
      values: #[
        #{ value: "undefined", description: "The deployment operation status is undefined." },
        #{ value: "queued", description: "The deployment operation status is queued." },
        #{ value: "scheduled", description: "The deployment operation status is scheduled." },
        #{ value: "pending", description: "The deployment operation status is pending." },
        #{ value: "approved", description: "The deployment operation status is approved." },
        #{ value: "rejected", description: "The deployment operation status is rejected." },
        #{ value: "deferred", description: "The deployment operation status is deferred." },
        #{
          value: "queuedForAgent",
          description: "The deployment operation status is queued for agent.",
        },
        #{
          value: "phaseInProgress",
          description: "The deployment operation status is phase in progress.",
        },
        #{
          value: "phaseSucceeded",
          description: "The deployment operation status is phase succeeded.",
        },
        #{
          value: "phasePartiallySucceeded",
          description: "The deployment operation status is phase partially succeeded.",
        },
        #{ value: "phaseFailed", description: "The deployment operation status is phase failed." },
        #{ value: "canceled", description: "The deployment operation status is canceled." },
        #{
          value: "phaseCanceled",
          description: "The deployment operation status is phase canceled.",
        },
        #{
          value: "manualInterventionPending",
          description: "The deployment operation status is manualintervention pending.",
        },
        #{
          value: "queuedForPipeline",
          description: "The deployment operation status is queued for pipeline.",
        },
        #{ value: "cancelling", description: "The deployment operation status is cancelling." },
        #{
          value: "evaluatingGates",
          description: "The deployment operation status is EvaluatingGates.",
        },
        #{ value: "gateFailed", description: "The deployment operation status is GateFailed." },
        #{ value: "all", description: "The deployment operation status is all." }
      ],
    }
  )
  operationStatus?:
    | "undefined"
    | "queued"
    | "scheduled"
    | "pending"
    | "approved"
    | "rejected"
    | "deferred"
    | "queuedForAgent"
    | "phaseInProgress"
    | "phaseSucceeded"
    | "phasePartiallySucceeded"
    | "phaseFailed"
    | "canceled"
    | "phaseCanceled"
    | "manualInterventionPending"
    | "queuedForPipeline"
    | "cancelling"
    | "evaluatingGates"
    | "gateFailed"
    | "all";

  postDeploymentGates?: ReleaseGates;
  preDeploymentGates?: ReleaseGates;

  /** When this deployment queued on. */
  queuedOn?: utcDateTime;

  /** Reason for the deployment. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentReason",
      values: #[
        #{ value: "none", description: "The deployment reason is none." },
        #{ value: "manual", description: "The deployment reason is manual." },
        #{ value: "automated", description: "The deployment reason is automated." },
        #{ value: "scheduled", description: "The deployment reason is scheduled." },
        #{ value: "redeployTrigger", description: "The deployment reason is RedeployTrigger." }
      ],
    }
  )
  reason?: "none" | "manual" | "automated" | "scheduled" | "redeployTrigger";

  /** List of release deployphases executed in this deployment. */
  releaseDeployPhases?: ReleaseDeployPhase[];

  requestedBy?: IdentityRef;
  requestedFor?: IdentityRef;

  /** status of the deployment. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentStatus",
      values: #[
        #{ value: "undefined", description: "The deployment status is undefined." },
        #{ value: "notDeployed", description: "The deployment status is not deployed." },
        #{ value: "inProgress", description: "The deployment status is in progress." },
        #{ value: "succeeded", description: "The deployment status is succeeded." },
        #{
          value: "partiallySucceeded",
          description: "The deployment status is partiallysucceeded.",
        },
        #{ value: "failed", description: "The deployment status is failed." },
        #{ value: "all", description: "The deployment status is all." }
      ],
    }
  )
  status?:
    | "undefined"
    | "notDeployed"
    | "inProgress"
    | "succeeded"
    | "partiallySucceeded"
    | "failed"
    | "all";
}

model DeploymentAuthorizationInfo {
  /** Authorization header type, typically either RevalidateApproverIdentity or OnBehalfOf. */
  @extension(
    "x-ms-enum",
    #{
      name: "AuthorizationHeaderFor",
      values: #[
        #{ value: "revalidateApproverIdentity", description: "" },
        #{ value: "onBehalfOf", description: "" }
      ],
    }
  )
  authorizationHeaderFor?: "revalidateApproverIdentity" | "onBehalfOf";

  /** List of resources. */
  resources?: string[];

  /** ID of the tenant. */
  tenantId?: string;

  /** Access token key. */
  vstsAccessTokenKey?: string;
}

model DeploymentCompletedEvent {
  ...DeploymentEvent;
  comment?: string;
  data?: Record<{}>;
  deployment?: Deployment;
  environment?: ReleaseEnvironment;
  project?: ProjectReference;
}

model DeploymentEvent {
  ...ReleaseEvent;
  attemptId?: int32;
  stageName?: string;
}

model DeploymentInput {
  ...BaseDeploymentInput;
  artifactsDownloadInput?: ArtifactsDownloadInput;

  /** List demands that needs to meet to execute the job. */
  demands?: Demand[];

  /** Indicates whether to include access token in deployment job or not. */
  enableAccessToken?: boolean;

  /** Id of the pool on which job get executed. */
  queueId?: int32;

  /** Indicates whether artifacts downloaded while job execution or not. */
  skipArtifactsDownload?: boolean;
}

model DeploymentJob {
  job?: ReleaseTask;

  /** List of executed tasks with in job. */
  tasks?: ReleaseTask[];
}

model DeploymentManualInterventionPendingEvent {
  approval?: ReleaseApproval;
  deployment?: Deployment;
  emailRecipients?: string[];
  environmentOwner?: IdentityRef;
  manualIntervention?: ManualIntervention;
  project?: ProjectReference;
  release?: Release;
}

model DeploymentQueryParameters {
  /** Query deployments based specified artifact source id. */
  artifactSourceId?: string;

  /** Query deployments based specified artifact type id. */
  artifactTypeId?: string;

  /** Query deployments based specified artifact versions. */
  artifactVersions?: string[];

  /** Query deployments number of deployments per environment. */
  deploymentsPerEnvironment?: int32;

  /** Query deployment based on deployment status. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentStatus",
      values: #[
        #{ value: "undefined", description: "The deployment status is undefined." },
        #{ value: "notDeployed", description: "The deployment status is not deployed." },
        #{ value: "inProgress", description: "The deployment status is in progress." },
        #{ value: "succeeded", description: "The deployment status is succeeded." },
        #{
          value: "partiallySucceeded",
          description: "The deployment status is partiallysucceeded.",
        },
        #{ value: "failed", description: "The deployment status is failed." },
        #{ value: "all", description: "The deployment status is all." }
      ],
    }
  )
  deploymentStatus?:
    | "undefined"
    | "notDeployed"
    | "inProgress"
    | "succeeded"
    | "partiallySucceeded"
    | "failed"
    | "all";

  /** Query deployments of specified environments. */
  environments?: DefinitionEnvironmentReference[];

  /** Query deployments based specified expands. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentExpands",
      values: #[
        #{ value: "all", description: "" },
        #{ value: "deploymentOnly", description: "" },
        #{ value: "approvals", description: "" },
        #{ value: "artifacts", description: "" }
      ],
    }
  )
  expands?: "all" | "deploymentOnly" | "approvals" | "artifacts";

  /** Specify deleted deployments should return or not. */
  isDeleted?: boolean;

  /** Query deployment based on deployment operation status. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentOperationStatus",
      values: #[
        #{ value: "undefined", description: "The deployment operation status is undefined." },
        #{ value: "queued", description: "The deployment operation status is queued." },
        #{ value: "scheduled", description: "The deployment operation status is scheduled." },
        #{ value: "pending", description: "The deployment operation status is pending." },
        #{ value: "approved", description: "The deployment operation status is approved." },
        #{ value: "rejected", description: "The deployment operation status is rejected." },
        #{ value: "deferred", description: "The deployment operation status is deferred." },
        #{
          value: "queuedForAgent",
          description: "The deployment operation status is queued for agent.",
        },
        #{
          value: "phaseInProgress",
          description: "The deployment operation status is phase in progress.",
        },
        #{
          value: "phaseSucceeded",
          description: "The deployment operation status is phase succeeded.",
        },
        #{
          value: "phasePartiallySucceeded",
          description: "The deployment operation status is phase partially succeeded.",
        },
        #{ value: "phaseFailed", description: "The deployment operation status is phase failed." },
        #{ value: "canceled", description: "The deployment operation status is canceled." },
        #{
          value: "phaseCanceled",
          description: "The deployment operation status is phase canceled.",
        },
        #{
          value: "manualInterventionPending",
          description: "The deployment operation status is manualintervention pending.",
        },
        #{
          value: "queuedForPipeline",
          description: "The deployment operation status is queued for pipeline.",
        },
        #{ value: "cancelling", description: "The deployment operation status is cancelling." },
        #{
          value: "evaluatingGates",
          description: "The deployment operation status is EvaluatingGates.",
        },
        #{ value: "gateFailed", description: "The deployment operation status is GateFailed." },
        #{ value: "all", description: "The deployment operation status is all." }
      ],
    }
  )
  operationStatus?:
    | "undefined"
    | "queued"
    | "scheduled"
    | "pending"
    | "approved"
    | "rejected"
    | "deferred"
    | "queuedForAgent"
    | "phaseInProgress"
    | "phaseSucceeded"
    | "phasePartiallySucceeded"
    | "phaseFailed"
    | "canceled"
    | "phaseCanceled"
    | "manualInterventionPending"
    | "queuedForPipeline"
    | "cancelling"
    | "evaluatingGates"
    | "gateFailed"
    | "all";

  /** Query deployments based query type. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentsQueryType",
      values: #[
        #{ value: "regular", description: "" },
        #{ value: "failingSince", description: "" }
      ],
    }
  )
  queryType?: "regular" | "failingSince";

  /** Query deployments based specified source branch. */
  sourceBranch?: string;
}

model DeploymentStartedEvent {
  ...DeploymentEvent;
  environment?: ReleaseEnvironment;
  project?: ProjectReference;
  release?: Release;
}

model DeployPhase {
  /** Gets and sets the name of deploy phase. */
  name?: string;

  /** Indicates the deploy phase type. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeployPhaseTypes",
      values: #[
        #{ value: "undefined", description: "Phase type not defined. Don't use this." },
        #{
          value: "agentBasedDeployment",
          description: "Phase type which contains tasks executed on agent.",
        },
        #{
          value: "runOnServer",
          description: "Phase type which contains tasks executed by server.",
        },
        #{
          value: "machineGroupBasedDeployment",
          description: "Phase type which contains tasks executed on deployment group machines.",
        },
        #{
          value: "deploymentGates",
          description: "Phase type which contains tasks which acts as Gates for the deployment to go forward.",
        }
      ],
    }
  )
  phaseType?:
    | "undefined"
    | "agentBasedDeployment"
    | "runOnServer"
    | "machineGroupBasedDeployment"
    | "deploymentGates";

  /** Gets and sets the rank of deploy phase. */
  rank?: int32;

  /** Gets and sets the reference name of deploy phase. */
  refName?: string;

  /** Gets and sets the workflow tasks for the deploy phase. */
  workflowTasks?: WorkflowTask[];
}

model EmailRecipients {
  /** List of email addresses. */
  emailAddresses?: string[];

  /** List of TFS IDs guids. */
  tfsIds?: string[];
}

/** Defines policy on environment queuing at Release Management side queue. We will send to Environment Runner [creating pre-deploy and other steps] only when the policies mentioned are satisfied. */
model EnvironmentExecutionPolicy {
  /** This policy decides, how many environments would be with Environment Runner. */
  concurrencyCount?: int32;

  /** Queue depth in the EnvironmentQueue table, this table keeps the environment entries till Environment Runner is free [as per it's policy] to take another environment for running. */
  queueDepthCount?: int32;
}

model EnvironmentOptions {
  /** Gets and sets as the auto link workitems or not. */
  autoLinkWorkItems?: boolean;

  /** Gets and sets as the badge enabled or not. */
  badgeEnabled?: boolean;

  /** Gets and sets as the publish deployment status or not. */
  publishDeploymentStatus?: boolean;

  /** Gets and sets as the.pull request deployment enabled or not. */
  pullRequestDeploymentEnabled?: boolean;
}

model EnvironmentRetentionPolicy {
  /** Gets and sets the number of days to keep environment. */
  daysToKeep?: int32;

  /** Gets and sets the number of releases to keep. */
  releasesToKeep?: int32;

  /** Gets and sets as the build to be retained or not. */
  retainBuild?: boolean;
}

model EnvironmentTrigger {
  /** Definition environment ID on which this trigger applicable. */
  definitionEnvironmentId?: int32;

  /** ReleaseDefinition ID on which this trigger applicable. */
  releaseDefinitionId?: int32;

  /** Gets or sets the trigger content. */
  triggerContent?: string;

  /** Gets or sets the trigger type. */
  @extension(
    "x-ms-enum",
    #{
      name: "EnvironmentTriggerType",
      values: #[
        #{ value: "undefined", description: "Environment trigger type undefined." },
        #{
          value: "deploymentGroupRedeploy",
          description: "Environment trigger type is deployment group redeploy.",
        },
        #{ value: "rollbackRedeploy", description: "Environment trigger type is Rollback." }
      ],
    }
  )
  triggerType?: "undefined" | "deploymentGroupRedeploy" | "rollbackRedeploy";
}

model EnvironmentTriggerContent {
  /** Gets or sets action. */
  action?: string;

  /** Gets or sets list of event types. */
  eventTypes?: string[];
}

model ExecutionInput {
  /** Parallel execution type, for example MultiConfiguration or MultiMachine. */
  @extension(
    "x-ms-enum",
    #{
      name: "ParallelExecutionTypes",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "multiConfiguration", description: "" },
        #{ value: "multiMachine", description: "" }
      ],
    }
  )
  parallelExecutionType?: "none" | "multiConfiguration" | "multiMachine";
}

/** Class to represent favorite entry. */
model FavoriteItem {
  /** Application specific data for the entry. */
  data?: string;

  /** Unique Id of the entry. */
  @format("uuid") id?: string;

  /** Display text for favorite entry. */
  name?: string;

  /** Application specific favorite entry type. Empty or Null represents that Favorite item is a Folder. */
  type?: string;
}

model Folder {
  createdBy?: IdentityRef;

  /** Time when this folder created. */
  createdOn?: utcDateTime;

  /** Description of the folder. */
  description?: string;

  lastChangedBy?: IdentityRef;

  /** Time when this folder last changed. */
  lastChangedDate?: utcDateTime;

  /** path of the folder. */
  path?: string;
}

model GatesDeploymentInput {
  ...BaseDeploymentInput;

  /** Gates minimum success duration. */
  minimumSuccessDuration?: int32;

  /** Gates sampling interval. */
  samplingInterval?: int32;

  /** Gates stabilization time. */
  stabilizationTime?: int32;
}

model GatesDeployPhase {
  ...DeployPhase;
  deploymentInput?: GatesDeploymentInput;
}

model GateUpdateMetadata {
  /** Comment. */
  comment?: string;

  /** Name of gate to be ignored. */
  gatesToIgnore?: string[];
}

model GitArtifactDownloadInput {
  ...ArtifactDownloadInputBase;
}

model GitHubArtifactDownloadInput {
  ...ArtifactDownloadInputBase;
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

model IgnoredGate {
  /** Gets the date on which gate is last ignored. */
  lastModifiedOn?: utcDateTime;

  /** Name of gate ignored. */
  name?: string;
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
    | "textArea";

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
  dataType?: "none" | "string" | "number" | "boolean" | "guid" | "uri";

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

model InputValuesQuery {
  currentValues?: Record<string>;

  /** The input values to return on input, and the result from the consumer on output. */
  inputValues?: InputValues[];

  /** Subscription containing information about the publisher/consumer and the current input values */
  resource?: {};
}

model Issue {
  /** Issue data. */
  data?: Record<string>;

  /** Issue type, for example error, warning or info. */
  issueType?: string;

  /** Issue message. */
  message?: string;
}

model JenkinsArtifactDownloadInput {
  ...ArtifactDownloadInputBase;
}

model MachineGroupBasedDeployPhase {
  ...DeployPhase;
  deploymentInput?: MachineGroupDeploymentInput;
}

model MachineGroupDeploymentInput {
  ...DeploymentInput;

  /** Deployment group health option. */
  deploymentHealthOption?: string;

  /** Minimum percentage of the targets guaranteed to be healthy. */
  healthPercent?: int32;

  /** Deployment target tag filter. */
  tags?: string[];
}

model MailMessage {
  /** Body of mail. */
  body?: string;

  cc?: EmailRecipients;

  /** Reply to. */
  inReplyTo?: string;

  /** Message ID of the mail. */
  messageId?: string;

  /** Data when should be replied to mail. */
  replyBy?: utcDateTime;

  replyTo?: EmailRecipients;

  /** List of mail section types. */
  sections?: (
    | "details"
    | "environments"
    | "issues"
    | "testResults"
    | "workItems"
    | "releaseInfo")[];

  /** Mail sender type. */
  @extension(
    "x-ms-enum",
    #{
      name: "SenderType",
      values: #[
        #{ value: "serviceAccount", description: "" },
        #{ value: "requestingUser", description: "" }
      ],
    }
  )
  senderType?: "serviceAccount" | "requestingUser";

  /** Subject of the mail. */
  subject?: string;

  to?: EmailRecipients;
}

model ManualIntervention {
  approver?: IdentityRef;

  /** Gets or sets comments for approval. */
  comments?: string;

  /** Gets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets the unique identifier for manual intervention. */
  id?: int32;

  /** Gets or sets instructions for approval. */
  instructions?: string;

  /** Gets date on which it got modified. */
  modifiedOn?: utcDateTime;

  /** Gets or sets the name. */
  name?: string;

  poPTenant?: ProofOfPresenceTenant;
  release?: ReleaseShallowReference;
  releaseDefinition?: ReleaseDefinitionShallowReference;
  releaseEnvironment?: ReleaseEnvironmentShallowReference;

  /** Gets or sets the status of the manual intervention. */
  @extension(
    "x-ms-enum",
    #{
      name: "ManualInterventionStatus",
      values: #[
        #{
          value: "unknown",
          description: "The manual intervention does not have the status set.",
        },
        #{ value: "pending", description: "The manual intervention is pending." },
        #{ value: "rejected", description: "The manual intervention is rejected." },
        #{ value: "approved", description: "The manual intervention is approved." },
        #{ value: "canceled", description: "The manual intervention is canceled." },
        #{ value: "bypassed", description: "The manual intervention is bypassed." }
      ],
    }
  )
  status?: "unknown" | "pending" | "rejected" | "approved" | "canceled" | "bypassed";

  /** Get task instance identifier. */
  @format("uuid") taskInstanceId?: string;

  /** Gets or sets the type. */
  @extension(
    "x-ms-enum",
    #{
      name: "ManualInterventionType",
      values: #[
        #{ value: "task", description: "The manual intervention server task." },
        #{
          value: "proofOfPresence",
          description: "The manual intervention proof of presence server task.",
        }
      ],
    }
  )
  type?: "task" | "proofOfPresence";

  /** Gets url to access the manual intervention. */
  url?: string;
}

model ManualInterventionUpdateMetadata {
  /** Sets the comment for manual intervention update. */
  comment?: string;

  /** Sets the status of the manual intervention. */
  @extension(
    "x-ms-enum",
    #{
      name: "ManualInterventionStatus",
      values: #[
        #{
          value: "unknown",
          description: "The manual intervention does not have the status set.",
        },
        #{ value: "pending", description: "The manual intervention is pending." },
        #{ value: "rejected", description: "The manual intervention is rejected." },
        #{ value: "approved", description: "The manual intervention is approved." },
        #{ value: "canceled", description: "The manual intervention is canceled." },
        #{ value: "bypassed", description: "The manual intervention is bypassed." }
      ],
    }
  )
  status?: "unknown" | "pending" | "rejected" | "approved" | "canceled" | "bypassed";
}

model MappingDetails {
  mappings?: Record<InputValue>;
}

model Metric {
  /** Name of the Metric. */
  name?: string;

  /** Value of the Metric. */
  value?: int32;
}

model MultiConfigInput {
  ...ParallelExecutionInputBase;

  /** Multipliers for parallel execution of deployment, for example x86,x64. */
  multipliers?: string;
}

model MultiMachineInput {
  ...ParallelExecutionInputBase;
}

model OrgPipelineReleaseSettings {
  /** Defines whether user can manage pipeline settings. */
  hasManagePipelinePoliciesPermission?: boolean;

  /** EnforceJobAuthScope setting at organisaion level. If enabled, scope of access for all release pipelines in the organisation reduces to the current project. */
  orgEnforceJobAuthScope?: boolean;
}

model OrgPipelineReleaseSettingsUpdateParameters {
  /** EnforceJobAuthScope setting at organisaion level. If enabled, scope of access for all release pipelines in the organisation reduces to the current project. */
  orgEnforceJobAuthScope?: boolean;
}

model PackageTrigger {
  ...ReleaseTriggerBase;

  /** Package trigger alias. */
  `alias`?: string;
}

model ParallelExecutionInputBase {
  ...ExecutionInput;

  /** Indicate whether continue execution of deployment on error or not. */
  continueOnError?: boolean;

  /** Maximum number of agents used while parallel execution. */
  maxNumberOfAgents?: int32;
}

model PipelineProcess {
  /** Pipeline process type. */
  @extension(
    "x-ms-enum",
    #{
      name: "PipelineProcessTypes",
      values: #[#{ value: "designer", description: "" }, #{ value: "yaml", description: "" }],
    }
  )
  type?: "designer" | "yaml";
}

model ProcessParameters {
  dataSourceBindings?: DataSourceBindingBase[];
  inputs?: TaskInputDefinitionBase[];
  sourceDefinitions?: TaskSourceDefinitionBase[];
}

model ProjectPipelineReleaseSettings {
  /** EnforceJobAuthScope setting at project level. If enabled, scope of access for all release pipelines reduces to the current project. */
  enforceJobAuthScope?: boolean;

  /** Defines whether user can manage pipeline settings. */
  hasManageSettingsPermission?: boolean;

  /** EnforceJobAuthScope setting at organisaion level. If enabled, scope of access for all release pipelines in the organisation reduces to the current project. */
  orgEnforceJobAuthScope?: boolean;

  /** Defines whether project is public. */
  publicProject?: boolean;
}

model ProjectPipelineReleaseSettingsUpdateParameters {
  /** EnforceJobAuthScope setting at project level. If enabled, scope of access for all release pipelines reduces to the current project. */
  enforceJobAuthScope?: boolean;
}

model ProjectReference {
  /** Gets the unique identifier of this field. */
  @format("uuid") id?: string;

  /** Gets name of project. */
  name?: string;
}

model ProofOfPresenceTenant {
  /** Gets authority of protected tenant. */
  authority?: string;

  /** Gets domain hint of protected tenant. */
  domainHint?: string;

  /** Gets distinct list of resources which have proof of presence check configured for this tenant. */
  resources?: CheckConfigurationResource[];

  /** Gets id of protected tenant. */
  @format("uuid") tenantId?: string;

  /** Gets name of protected tenant. */
  tenantName?: string;

  /** Gets timeout of protected tenant PoP check. */
  timeout?: int32;
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

model PropertySelector {
  /** List of properties. */
  properties?: string[];

  /** Property selector type. */
  @extension(
    "x-ms-enum",
    #{
      name: "PropertySelectorType",
      values: #[
        #{ value: "inclusion", description: "Include in property selector." },
        #{ value: "exclusion", description: "Exclude in property selector." }
      ],
    }
  )
  selectorType?: "inclusion" | "exclusion";
}

model PullRequestConfiguration {
  codeRepositoryReference?: CodeRepositoryReference;

  /** In case of Source based artifacts, Code reference will be present in Artifact details. */
  useArtifactReference?: boolean;
}

model PullRequestFilter {
  /** List of tags. */
  tags?: string[];

  /** Target branch of pull request. */
  targetBranch?: string;
}

model PullRequestTrigger {
  ...ReleaseTriggerBase;

  /** Artifact alias trigger is linked to. */
  artifactAlias?: string;

  pullRequestConfiguration?: PullRequestConfiguration;

  /** Policy name using which status will be published to pull request. */
  statusPolicyName?: string;

  /** List of filters applied while trigger. */
  triggerConditions?: PullRequestFilter[];
}

model QueuedReleaseData {
  /** Project ID of the release. */
  @format("uuid") projectId?: string;

  /** Release queue position. */
  queuePosition?: int32;

  /** Queued release ID. */
  releaseId?: int32;
}

model RealtimeReleaseDefinitionEvent {
  definitionId?: int32;
  @format("uuid") projectId?: string;
}

model RealtimeReleaseEvent {
  environmentId?: int32;
  @format("uuid") projectId?: string;
  releaseId?: int32;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model Release {
  _links?: ReferenceLinks;

  /** Gets or sets the list of artifacts. */
  artifacts?: Artifact[];

  /** Gets or sets comment. */
  comment?: string;

  createdBy?: IdentityRef;
  createdFor?: IdentityRef;

  /** Gets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets revision number of definition snapshot. */
  definitionSnapshotRevision?: int32;

  /** Gets or sets description of release. */
  description?: string;

  /** Gets list of environments. */
  environments?: ReleaseEnvironment[];

  /** Gets the unique identifier of this field. */
  id?: int32;

  /** Whether to exclude the release from retention policies. */
  keepForever?: boolean;

  /** Gets logs container url. */
  logsContainerUrl?: string;

  modifiedBy?: IdentityRef;

  /** Gets date on which it got modified. */
  modifiedOn?: utcDateTime;

  /** Gets name. */
  name?: string;

  /** Gets pool name. */
  poolName?: string;

  projectReference?: ProjectReference;
  properties?: PropertiesCollection;

  /** Gets reason of release. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseReason",
      values: #[
        #{ value: "none", description: "Indicates the release triggered reason not set." },
        #{ value: "manual", description: "Indicates the release triggered manually." },
        #{
          value: "continuousIntegration",
          description: "Indicates the release triggered by continuous integration.",
        },
        #{ value: "schedule", description: "Indicates the release triggered by schedule." },
        #{ value: "pullRequest", description: "Indicates the release triggered by PullRequest." }
      ],
    }
  )
  reason?: "none" | "manual" | "continuousIntegration" | "schedule" | "pullRequest";

  releaseDefinition?: ReleaseDefinitionShallowReference;

  /** Gets or sets the release definition revision. */
  releaseDefinitionRevision?: int32;

  /** Gets release name format. */
  releaseNameFormat?: string;

  /** Gets status. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseStatus",
      values: #[
        #{ value: "undefined", description: "Release status not set." },
        #{ value: "draft", description: "Release is in draft state." },
        #{ value: "active", description: "Release status is in active." },
        #{ value: "abandoned", description: "Release status is in abandoned." }
      ],
    }
  )
  status?: "undefined" | "draft" | "active" | "abandoned";

  /** Gets or sets list of tags. */
  tags?: string[];

  triggeringArtifactAlias?: string;

  /** Gets the list of variable groups. */
  variableGroups?: VariableGroup[];

  /** Gets or sets the dictionary of variables. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseAbandonedEvent {
  ...ReleaseEvent;
  project?: ProjectReference;
  release?: Release;
}

model ReleaseApproval {
  /** Gets or sets the type of approval. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalType",
      values: #[
        #{ value: "undefined", description: "Indicates the approval type does not set." },
        #{
          value: "preDeploy",
          description: "Indicates the approvals which executed before deployment.",
        },
        #{
          value: "postDeploy",
          description: "Indicates the approvals which executed after deployment.",
        },
        #{ value: "all", description: "Indicates all approvals." }
      ],
    }
  )
  approvalType?: "undefined" | "preDeploy" | "postDeploy" | "all";

  approvedBy?: IdentityRef;
  approver?: IdentityRef;

  /** Gets or sets attempt which specifies as which deployment attempt it belongs. */
  attempt?: int32;

  /** Gets or sets comments for approval. */
  comments?: string;

  /** Gets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets history which specifies all approvals associated with this approval. */
  history?: ReleaseApprovalHistory[];

  /** Gets the unique identifier of this field. */
  id?: int32;

  /** Gets or sets as approval is automated or not. */
  isAutomated?: boolean;

  /** Gets date on which it got modified. */
  modifiedOn?: utcDateTime;

  /** Gets or sets rank which specifies the order of the approval. e.g. Same rank denotes parallel approval. */
  rank?: int32;

  release?: ReleaseShallowReference;
  releaseDefinition?: ReleaseDefinitionShallowReference;
  releaseEnvironment?: ReleaseEnvironmentShallowReference;

  /** Gets the revision number. */
  revision?: int32;

  /** Gets or sets the status of the approval. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalStatus",
      values: #[
        #{
          value: "undefined",
          description: "Indicates the approval does not have the status set.",
        },
        #{ value: "pending", description: "Indicates the approval is pending." },
        #{ value: "approved", description: "Indicates the approval is approved." },
        #{ value: "rejected", description: "Indicates the approval is rejected." },
        #{ value: "reassigned", description: "Indicates the approval is reassigned." },
        #{ value: "canceled", description: "Indicates the approval is canceled." },
        #{ value: "skipped", description: "Indicates the approval is skipped." }
      ],
    }
  )
  status?:
    | "undefined"
    | "pending"
    | "approved"
    | "rejected"
    | "reassigned"
    | "canceled"
    | "skipped";

  /** Gets url to access the approval. */
  url?: string;
}

model ReleaseApprovalHistory {
  approver?: IdentityRef;
  changedBy?: IdentityRef;

  /** Approval history comments. */
  comments?: string;

  /** Time when this approval created. */
  createdOn?: utcDateTime;

  /** Time when this approval modified. */
  modifiedOn?: utcDateTime;

  /** Approval history revision. */
  revision?: int32;
}

model ReleaseApprovalPendingEvent {
  approval?: ReleaseApproval;
  approvalOptions?: ApprovalOptions;
  completedApprovals?: ReleaseApproval[];
  definitionName?: string;
  deployment?: Deployment;
  environmentId?: int32;
  environmentName?: string;
  environments?: ReleaseEnvironment[];
  isMultipleRankApproval?: boolean;
  pendingApprovals?: ReleaseApproval[];
  releaseCreator?: string;
  releaseName?: string;
  title?: string;
  webAccessUri?: string;
}

model ReleaseArtifact {
  artifactProvider?: ArtifactProvider;

  /** Gets or sets the artifact type of ReleaseArtifact. */
  artifactType?: string;

  /** Gets or sets the definition json of ReleaseArtifact. */
  definitionData?: string;

  /** Gets or sets the definition id of ReleaseArtifact. */
  definitionId?: int32;

  /** Gets or sets the description of ReleaseArtifact. */
  description?: string;

  /** Gets or sets the id of ReleaseArtifact. */
  id?: int32;

  /** Gets or sets the name of ReleaseArtifact. */
  name?: string;

  /** Gets or sets the release id. */
  releaseId?: int32;
}

model ReleaseCondition {
  ...Condition;
}

model ReleaseCreatedEvent {
  ...ReleaseEvent;
  project?: ProjectReference;
  release?: Release;
}

model ReleaseDefinition {
  ...ReleaseDefinitionShallowReference;

  /** Gets or sets the list of artifacts. */
  artifacts?: Artifact[];

  /** Gets or sets comment. */
  comment?: string;

  createdBy?: IdentityRef;

  /** Gets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets or sets the description. */
  description?: string;

  /** Gets or sets the list of environments. */
  environments?: ReleaseDefinitionEnvironment[];

  /** Whether release definition is deleted. */
  isDeleted?: boolean;

  /** Whether release definition is disabled. */
  isDisabled?: boolean;

  lastRelease?: ReleaseReference;
  modifiedBy?: IdentityRef;

  /** Gets date on which it got modified. */
  modifiedOn?: utcDateTime;

  properties?: PropertiesCollection;

  /** Gets or sets the release name format. */
  releaseNameFormat?: string;

  /** Gets the revision number. */
  revision?: int32;

  /** Gets or sets source of release definition. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseDefinitionSource",
      values: #[
        #{ value: "undefined", description: "Indicates ReleaseDefinition source not defined." },
        #{ value: "restApi", description: "Indicates ReleaseDefinition created using REST API." },
        #{ value: "userInterface", description: "Indicates ReleaseDefinition created using UI." },
        #{ value: "ibiza", description: "Indicates ReleaseDefinition created from Ibiza." },
        #{
          value: "portalExtensionApi",
          description: "Indicates ReleaseDefinition created from PortalExtension API.",
        }
      ],
    }
  )
  source?: "undefined" | "restApi" | "userInterface" | "ibiza" | "portalExtensionApi";

  /** Gets or sets list of tags. */
  tags?: string[];

  /** Gets or sets the list of triggers. */
  triggers?: ReleaseTriggerBase[];

  /** Gets or sets the list of variable groups. */
  variableGroups?: int32[];

  /** Gets or sets the dictionary of variables. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseDefinitionApprovals {
  approvalOptions?: ApprovalOptions;

  /** Gets or sets the approvals. */
  approvals?: ReleaseDefinitionApprovalStep[];
}

model ReleaseDefinitionApprovalStep {
  ...ReleaseDefinitionEnvironmentStep;
  approver?: IdentityRef;

  /** Indicates whether the approval automated. */
  isAutomated?: boolean;

  /** Indicates whether the approval notification set. */
  isNotificationOn?: boolean;

  /** Gets or sets the rank of approval step. */
  rank?: int32;
}

model ReleaseDefinitionDeployStep {
  ...ReleaseDefinitionEnvironmentStep;

  /** The list of steps for this definition. */
  tasks?: WorkflowTask[];
}

model ReleaseDefinitionEnvironment {
  /** Gets or sets the BadgeUrl. BadgeUrl will be used when Badge will be enabled in Release Definition Environment. */
  badgeUrl?: string;

  /** Gets or sets the environment conditions. */
  conditions?: Condition[];

  currentRelease?: ReleaseShallowReference;

  /** Gets or sets the demands. */
  demands?: Demand[];

  /** Gets or sets the deploy phases of environment. */
  deployPhases?: DeployPhase[];

  deployStep?: ReleaseDefinitionDeployStep;
  environmentOptions?: EnvironmentOptions;

  /** Gets or sets the triggers on environment. */
  environmentTriggers?: EnvironmentTrigger[];

  executionPolicy?: EnvironmentExecutionPolicy;

  /** Gets and sets the ID of the ReleaseDefinitionEnvironment. */
  id?: int32;

  /** Gets and sets the name of the ReleaseDefinitionEnvironment. */
  name?: string;

  owner?: IdentityRef;
  postDeployApprovals?: ReleaseDefinitionApprovals;
  postDeploymentGates?: ReleaseDefinitionGatesStep;
  preDeployApprovals?: ReleaseDefinitionApprovals;
  preDeploymentGates?: ReleaseDefinitionGatesStep;
  processParameters?: ProcessParameters;
  properties?: PropertiesCollection;

  /** Gets or sets the queue ID. */
  queueId?: int32;

  /** Gets and sets the rank of the ReleaseDefinitionEnvironment. */
  rank?: int32;

  retentionPolicy?: EnvironmentRetentionPolicy;

  /** Gets or sets the schedules */
  schedules?: ReleaseSchedule[];

  /** Gets or sets the variable groups. */
  variableGroups?: int32[];

  /** Gets and sets the variables. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseDefinitionEnvironmentStep {
  /** ID of the approval or deploy step. */
  id?: int32;
}

model ReleaseDefinitionEnvironmentSummary {
  /** ID of ReleaseDefinition environment summary. */
  id?: int32;

  /** List of release shallow reference deployed using this ReleaseDefinition. */
  lastReleases?: ReleaseShallowReference[];

  /** Name of ReleaseDefinition environment summary. */
  name?: string;
}

model ReleaseDefinitionEnvironmentTemplate {
  /** Indicates whether template can be deleted or not. */
  canDelete?: boolean;

  /** Category of the ReleaseDefinition environment template. */
  category?: string;

  /** Description of the ReleaseDefinition environment template. */
  description?: string;

  environment?: ReleaseDefinitionEnvironment;

  /** ID of the task which used to display icon used for this template. */
  @format("uuid") iconTaskId?: string;

  /** Icon uri of the template. */
  iconUri?: string;

  /** ID of the ReleaseDefinition environment template. */
  @format("uuid") id?: string;

  /** Indicates whether template deleted or not. */
  isDeleted?: boolean;

  /** Name of the ReleaseDefinition environment template. */
  name?: string;
}

model ReleaseDefinitionGate {
  /** Gets or sets the flag that indicates if gate was generated. */
  isGenerated?: boolean;

  /** Gets or sets the gates workflow. */
  tasks?: WorkflowTask[];
}

model ReleaseDefinitionGatesOptions {
  /** Gets or sets as the gates enabled or not. */
  isEnabled?: boolean;

  /** Gets or sets the minimum duration for steady results after a successful gates evaluation. */
  minimumSuccessDuration?: int32;

  /** Gets or sets the time between re-evaluation of gates. */
  samplingInterval?: int32;

  /** Gets or sets the delay before evaluation. */
  stabilizationTime?: int32;

  /** Gets or sets the timeout after which gates fail. */
  timeout?: int32;
}

model ReleaseDefinitionGatesStep {
  /** Gets or sets the gates. */
  gates?: ReleaseDefinitionGate[];

  gatesOptions?: ReleaseDefinitionGatesOptions;

  /** ID of the ReleaseDefinitionGateStep. */
  id?: int32;
}

model ReleaseDefinitionRevision {
  /** Gets api-version for revision object. */
  apiVersion?: string;

  changedBy?: IdentityRef;

  /** Gets date on which ReleaseDefinition changed. */
  changedDate?: utcDateTime;

  /** Gets type of change. */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditAction",
      values: #[
        #{ value: "add", description: "Indicates the audit add." },
        #{ value: "update", description: "Indicates the audit update." },
        #{ value: "delete", description: "Indicates the audit delete." },
        #{ value: "undelete", description: "Indicates the audit undelete." }
      ],
    }
  )
  changeType?: "add" | "update" | "delete" | "undelete";

  /** Gets comments for revision. */
  comment?: string;

  /** Get id of the definition. */
  definitionId?: int32;

  /** Gets definition URL. */
  definitionUrl?: string;

  /** Get revision number of the definition. */
  revision?: int32;
}

model ReleaseDefinitionShallowReference {
  _links?: ReferenceLinks;

  /** Gets the unique identifier of release definition. */
  id?: int32;

  /** Gets or sets the name of the release definition. */
  name?: string;

  /** Gets or sets the path of the release definition. */
  path?: string;

  projectReference?: ProjectReference;

  /** Gets the REST API url to access the release definition. */
  url?: string;
}

model ReleaseDefinitionSummary {
  /** List of Release Definition environment summary. */
  environments?: ReleaseDefinitionEnvironmentSummary[];

  releaseDefinition?: ReleaseDefinitionShallowReference;

  /** List of releases deployed using this Release Definition. */
  releases?: Release[];
}

model ReleaseDefinitionUndeleteParameter {
  /** Gets or sets comment. */
  comment?: string;
}

model ReleaseDeployPhase {
  /** Deployment jobs of the phase. */
  deploymentJobs?: DeploymentJob[];

  /** Phase execution error logs. */
  errorLog?: string;

  /** List of manual intervention tasks execution information in phase. */
  manualInterventions?: ManualIntervention[];

  /** Name of the phase. */
  name?: string;

  /** ID of the phase. */
  phaseId?: string;

  /** Type of the phase. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeployPhaseTypes",
      values: #[
        #{ value: "undefined", description: "Phase type not defined. Don't use this." },
        #{
          value: "agentBasedDeployment",
          description: "Phase type which contains tasks executed on agent.",
        },
        #{
          value: "runOnServer",
          description: "Phase type which contains tasks executed by server.",
        },
        #{
          value: "machineGroupBasedDeployment",
          description: "Phase type which contains tasks executed on deployment group machines.",
        },
        #{
          value: "deploymentGates",
          description: "Phase type which contains tasks which acts as Gates for the deployment to go forward.",
        }
      ],
    }
  )
  phaseType?:
    | "undefined"
    | "agentBasedDeployment"
    | "runOnServer"
    | "machineGroupBasedDeployment"
    | "deploymentGates";

  /** Rank of the phase. */
  rank?: int32;

  /** Run Plan ID of the phase. */
  @format("uuid") runPlanId?: string;

  /** Phase start time. */
  startedOn?: utcDateTime;

  /** Status of the phase. */
  @extension(
    "x-ms-enum",
    #{
      name: "DeployPhaseStatus",
      values: #[
        #{ value: "undefined", description: "Phase status not set." },
        #{ value: "notStarted", description: "Phase execution not started." },
        #{ value: "inProgress", description: "Phase execution in progress." },
        #{ value: "partiallySucceeded", description: "Phase execution partially succeeded." },
        #{ value: "succeeded", description: "Phase execution succeeded." },
        #{ value: "failed", description: "Phase execution failed." },
        #{ value: "canceled", description: "Phase execution canceled." },
        #{ value: "skipped", description: "Phase execution skipped." },
        #{ value: "cancelling", description: "Phase is in cancelling state." }
      ],
    }
  )
  status?:
    | "undefined"
    | "notStarted"
    | "inProgress"
    | "partiallySucceeded"
    | "succeeded"
    | "failed"
    | "canceled"
    | "skipped"
    | "cancelling";
}

model ReleaseEnvironment {
  /** Gets list of conditions. */
  conditions?: ReleaseCondition[];

  /** Gets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets definition environment id. */
  definitionEnvironmentId?: int32;

  /** Gets list of deploy phases snapshot. */
  deployPhasesSnapshot?: DeployPhase[];

  /** Gets deploy steps. */
  deploySteps?: DeploymentAttempt[];

  environmentOptions?: EnvironmentOptions;

  /** Gets the unique identifier of this field. */
  id?: int32;

  /** Gets date on which it got modified. */
  modifiedOn?: utcDateTime;

  /** Gets name. */
  name?: string;

  /** Gets next scheduled UTC time. */
  nextScheduledUtcTime?: utcDateTime;

  owner?: IdentityRef;
  postApprovalsSnapshot?: ReleaseDefinitionApprovals;

  /** Gets list of post deploy approvals. */
  postDeployApprovals?: ReleaseApproval[];

  postDeploymentGatesSnapshot?: ReleaseDefinitionGatesStep;
  preApprovalsSnapshot?: ReleaseDefinitionApprovals;

  /** Gets list of pre deploy approvals. */
  preDeployApprovals?: ReleaseApproval[];

  preDeploymentGatesSnapshot?: ReleaseDefinitionGatesStep;
  processParameters?: ProcessParameters;

  /** Gets rank. */
  rank?: int32;

  release?: ReleaseShallowReference;
  releaseCreatedBy?: IdentityRef;
  releaseDefinition?: ReleaseDefinitionShallowReference;

  /** Gets release id. */
  releaseId?: int32;

  /** Gets schedule deployment time of release environment. */
  scheduledDeploymentTime?: utcDateTime;

  /** Gets list of schedules. */
  schedules?: ReleaseSchedule[];

  /** Gets environment status. */
  @extension(
    "x-ms-enum",
    #{
      name: "EnvironmentStatus",
      values: #[
        #{ value: "undefined", description: "Environment status not set." },
        #{ value: "notStarted", description: "Environment is in not started state." },
        #{ value: "inProgress", description: "Environment is in progress state." },
        #{ value: "succeeded", description: "Environment is in succeeded state." },
        #{ value: "canceled", description: "Environment is in canceled state." },
        #{ value: "rejected", description: "Environment is in rejected state." },
        #{ value: "queued", description: "Environment is in queued state." },
        #{ value: "scheduled", description: "Environment is in scheduled state." },
        #{
          value: "partiallySucceeded",
          description: "Environment is in partially succeeded state.",
        }
      ],
    }
  )
  status?:
    | "undefined"
    | "notStarted"
    | "inProgress"
    | "succeeded"
    | "canceled"
    | "rejected"
    | "queued"
    | "scheduled"
    | "partiallySucceeded";

  /** Gets time to deploy. */
  timeToDeploy?: float64;

  /** Gets trigger reason. */
  triggerReason?: string;

  /** Gets the list of variable groups. */
  variableGroups?: VariableGroup[];

  /** Gets the dictionary of variables. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseEnvironmentCompletedEvent {
  createdByName?: string;
  definitionId?: int32;
  definitionName?: string;
  environment?: ReleaseEnvironment;
  environmentId?: int32;
  projectName?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentReason",
      values: #[
        #{ value: "none", description: "The deployment reason is none." },
        #{ value: "manual", description: "The deployment reason is manual." },
        #{ value: "automated", description: "The deployment reason is automated." },
        #{ value: "scheduled", description: "The deployment reason is scheduled." },
        #{ value: "redeployTrigger", description: "The deployment reason is RedeployTrigger." }
      ],
    }
  )
  reason?: "none" | "manual" | "automated" | "scheduled" | "redeployTrigger";
  releaseCreatedBy?: IdentityRef;
  releaseLogsUri?: string;
  releaseName?: string;
  status?: string;
  title?: string;
  webAccessUri?: string;
}

model ReleaseEnvironmentShallowReference {
  _links?: ReferenceLinks;

  /** Gets the unique identifier of release environment. */
  id?: int32;

  /** Gets or sets the name of the release environment. */
  name?: string;

  /** Gets the REST API url to access the release environment. */
  url?: string;
}

model ReleaseEnvironmentStatusUpdatedEvent {
  ...RealtimeReleaseDefinitionEvent;
  environmentId?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "EnvironmentStatus",
      values: #[
        #{ value: "undefined", description: "Environment status not set." },
        #{ value: "notStarted", description: "Environment is in not started state." },
        #{ value: "inProgress", description: "Environment is in progress state." },
        #{ value: "succeeded", description: "Environment is in succeeded state." },
        #{ value: "canceled", description: "Environment is in canceled state." },
        #{ value: "rejected", description: "Environment is in rejected state." },
        #{ value: "queued", description: "Environment is in queued state." },
        #{ value: "scheduled", description: "Environment is in scheduled state." },
        #{
          value: "partiallySucceeded",
          description: "Environment is in partially succeeded state.",
        }
      ],
    }
  )
  environmentStatus?:
    | "undefined"
    | "notStarted"
    | "inProgress"
    | "succeeded"
    | "canceled"
    | "rejected"
    | "queued"
    | "scheduled"
    | "partiallySucceeded";
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentOperationStatus",
      values: #[
        #{ value: "undefined", description: "The deployment operation status is undefined." },
        #{ value: "queued", description: "The deployment operation status is queued." },
        #{ value: "scheduled", description: "The deployment operation status is scheduled." },
        #{ value: "pending", description: "The deployment operation status is pending." },
        #{ value: "approved", description: "The deployment operation status is approved." },
        #{ value: "rejected", description: "The deployment operation status is rejected." },
        #{ value: "deferred", description: "The deployment operation status is deferred." },
        #{
          value: "queuedForAgent",
          description: "The deployment operation status is queued for agent.",
        },
        #{
          value: "phaseInProgress",
          description: "The deployment operation status is phase in progress.",
        },
        #{
          value: "phaseSucceeded",
          description: "The deployment operation status is phase succeeded.",
        },
        #{
          value: "phasePartiallySucceeded",
          description: "The deployment operation status is phase partially succeeded.",
        },
        #{ value: "phaseFailed", description: "The deployment operation status is phase failed." },
        #{ value: "canceled", description: "The deployment operation status is canceled." },
        #{
          value: "phaseCanceled",
          description: "The deployment operation status is phase canceled.",
        },
        #{
          value: "manualInterventionPending",
          description: "The deployment operation status is manualintervention pending.",
        },
        #{
          value: "queuedForPipeline",
          description: "The deployment operation status is queued for pipeline.",
        },
        #{ value: "cancelling", description: "The deployment operation status is cancelling." },
        #{
          value: "evaluatingGates",
          description: "The deployment operation status is EvaluatingGates.",
        },
        #{ value: "gateFailed", description: "The deployment operation status is GateFailed." },
        #{ value: "all", description: "The deployment operation status is all." }
      ],
    }
  )
  latestDeploymentOperationStatus?:
    | "undefined"
    | "queued"
    | "scheduled"
    | "pending"
    | "approved"
    | "rejected"
    | "deferred"
    | "queuedForAgent"
    | "phaseInProgress"
    | "phaseSucceeded"
    | "phasePartiallySucceeded"
    | "phaseFailed"
    | "canceled"
    | "phaseCanceled"
    | "manualInterventionPending"
    | "queuedForPipeline"
    | "cancelling"
    | "evaluatingGates"
    | "gateFailed"
    | "all";
  @extension(
    "x-ms-enum",
    #{
      name: "DeploymentStatus",
      values: #[
        #{ value: "undefined", description: "The deployment status is undefined." },
        #{ value: "notDeployed", description: "The deployment status is not deployed." },
        #{ value: "inProgress", description: "The deployment status is in progress." },
        #{ value: "succeeded", description: "The deployment status is succeeded." },
        #{
          value: "partiallySucceeded",
          description: "The deployment status is partiallysucceeded.",
        },
        #{ value: "failed", description: "The deployment status is failed." },
        #{ value: "all", description: "The deployment status is all." }
      ],
    }
  )
  latestDeploymentStatus?:
    | "undefined"
    | "notDeployed"
    | "inProgress"
    | "succeeded"
    | "partiallySucceeded"
    | "failed"
    | "all";
  releaseId?: int32;
}

model ReleaseEnvironmentUpdateMetadata {
  /** Gets or sets comment. */
  comment?: string;

  /** Gets or sets scheduled deployment time. */
  scheduledDeploymentTime?: utcDateTime;

  /** Gets or sets status of environment. */
  @extension(
    "x-ms-enum",
    #{
      name: "EnvironmentStatus",
      values: #[
        #{ value: "undefined", description: "Environment status not set." },
        #{ value: "notStarted", description: "Environment is in not started state." },
        #{ value: "inProgress", description: "Environment is in progress state." },
        #{ value: "succeeded", description: "Environment is in succeeded state." },
        #{ value: "canceled", description: "Environment is in canceled state." },
        #{ value: "rejected", description: "Environment is in rejected state." },
        #{ value: "queued", description: "Environment is in queued state." },
        #{ value: "scheduled", description: "Environment is in scheduled state." },
        #{
          value: "partiallySucceeded",
          description: "Environment is in partially succeeded state.",
        }
      ],
    }
  )
  status?:
    | "undefined"
    | "notStarted"
    | "inProgress"
    | "succeeded"
    | "canceled"
    | "rejected"
    | "queued"
    | "scheduled"
    | "partiallySucceeded";

  /** Sets list of environment variables to be overridden at deployment time. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseEvent {
  id?: int32;
  url?: string;
}

model ReleaseGates {
  /** Contains the gates job details of each evaluation. */
  deploymentJobs?: DeploymentJob[];

  /** ID of release gates. */
  id?: int32;

  /** List of ignored gates. */
  ignoredGates?: IgnoredGate[];

  /** Gates last modified time. */
  lastModifiedOn?: utcDateTime;

  /** Run plan ID of the gates. */
  @format("uuid") runPlanId?: string;

  /** Gates stabilization completed date and time. */
  stabilizationCompletedOn?: utcDateTime;

  /** Gates evaluation started time. */
  startedOn?: utcDateTime;

  /** Status of release gates. */
  @extension(
    "x-ms-enum",
    #{
      name: "GateStatus",
      values: #[
        #{ value: "none", description: "The gate does not have the status set." },
        #{ value: "pending", description: "The gate is in pending state." },
        #{ value: "inProgress", description: "The gate is currently in progress." },
        #{ value: "succeeded", description: "The gate completed successfully." },
        #{ value: "failed", description: "The gate execution failed." },
        #{ value: "canceled", description: "The gate execution cancelled." }
      ],
    }
  )
  status?: "none" | "pending" | "inProgress" | "succeeded" | "failed" | "canceled";

  /** Date and time at which all gates executed successfully. */
  succeedingSince?: utcDateTime;
}

model ReleaseGatesPhase {
  ...ReleaseDeployPhase;

  /** List of ignored gates. */
  ignoredGates?: IgnoredGate[];

  /** Date and time at which stabilization of gates completed. */
  stabilizationCompletedOn?: utcDateTime;

  /** Date and time at which all gates executed successfully. */
  succeedingSince?: utcDateTime;
}

model ReleaseManagementInputValue {
  /** The text to show for the display of this value. */
  displayValue?: string;

  /** The value to store for this input. */
  value?: string;
}

model ReleaseNotCreatedEvent {
  definitionReference?: ReleaseDefinitionShallowReference;
  message?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseReason",
      values: #[
        #{ value: "none", description: "Indicates the release triggered reason not set." },
        #{ value: "manual", description: "Indicates the release triggered manually." },
        #{
          value: "continuousIntegration",
          description: "Indicates the release triggered by continuous integration.",
        },
        #{ value: "schedule", description: "Indicates the release triggered by schedule." },
        #{ value: "pullRequest", description: "Indicates the release triggered by PullRequest." }
      ],
    }
  )
  releaseReason?: "none" | "manual" | "continuousIntegration" | "schedule" | "pullRequest";
  requestedBy?: IdentityRef;
}

model ReleaseReference {
  _links?: ReferenceLinks;

  /** Gets list of artifacts. */
  artifacts?: Artifact[];

  createdBy?: IdentityRef;

  /** Gets date on when this release created. */
  createdOn?: utcDateTime;

  /** Gets description. */
  description?: string;

  /** ID of the Release. */
  id?: int32;

  modifiedBy?: IdentityRef;

  /** Gets name of release. */
  name?: string;

  /** Gets reason for release. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseReason",
      values: #[
        #{ value: "none", description: "Indicates the release triggered reason not set." },
        #{ value: "manual", description: "Indicates the release triggered manually." },
        #{
          value: "continuousIntegration",
          description: "Indicates the release triggered by continuous integration.",
        },
        #{ value: "schedule", description: "Indicates the release triggered by schedule." },
        #{ value: "pullRequest", description: "Indicates the release triggered by PullRequest." }
      ],
    }
  )
  reason?: "none" | "manual" | "continuousIntegration" | "schedule" | "pullRequest";

  releaseDefinition?: ReleaseDefinitionShallowReference;
}

model ReleaseRevision {
  changedBy?: IdentityRef;

  /** Change date of the revision. */
  changedDate?: utcDateTime;

  /** Change details of the revision. */
  changeDetails?: string;

  /** Change details of the revision. Typically ChangeDetails values are Add and Update. */
  changeType?: string;

  /** Comment of the revision. */
  comment?: string;

  /** Release ID of which this revision belongs. */
  definitionSnapshotRevision?: int32;

  /** Gets or sets the release ID of which this revision belongs. */
  releaseId?: int32;
}

model ReleaseSchedule {
  /** Days of the week to release. */
  @extension(
    "x-ms-enum",
    #{
      name: "ScheduleDays",
      values: #[
        #{ value: "none", description: "Scheduled day not set." },
        #{ value: "monday", description: "Scheduled on Monday." },
        #{ value: "tuesday", description: "Scheduled on Tuesday." },
        #{ value: "wednesday", description: "Scheduled on Wednesday." },
        #{ value: "thursday", description: "Scheduled on Thursday." },
        #{ value: "friday", description: "Scheduled on Friday." },
        #{ value: "saturday", description: "Scheduled on Saturday." },
        #{ value: "sunday", description: "Scheduled on Sunday." },
        #{ value: "all", description: "Scheduled on all the days in week." }
      ],
    }
  )
  daysToRelease?:
    | "none"
    | "monday"
    | "tuesday"
    | "wednesday"
    | "thursday"
    | "friday"
    | "saturday"
    | "sunday"
    | "all";

  /** Team Foundation Job Definition Job Id. */
  @format("uuid") jobId?: string;

  /** Flag to determine if this schedule should only release if the associated artifact has been changed or release definition changed. */
  scheduleOnlyWithChanges?: boolean;

  /** Local time zone hour to start. */
  startHours?: int32;

  /** Local time zone minute to start. */
  startMinutes?: int32;

  /** Time zone Id of release schedule, such as 'UTC'. */
  timeZoneId?: string;
}

model ReleaseSettings {
  complianceSettings?: ComplianceSettings;
  retentionSettings?: RetentionSettings;
}

model ReleaseShallowReference {
  _links?: ReferenceLinks;

  /** Gets the unique identifier of release. */
  id?: int32;

  /** Gets or sets the name of the release. */
  name?: string;

  /** Gets the REST API url to access the release. */
  url?: string;
}

model ReleaseStartEnvironmentMetadata {
  /** Sets release definition environment id. */
  definitionEnvironmentId?: int32;

  /** Sets list of environments variables to be overridden at deployment time. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseStartMetadata {
  /** Sets list of artifact to create a release. */
  artifacts?: ArtifactMetadata[];

  /** Sets definition Id to create a release. */
  definitionId?: int32;

  /** Sets description to create a release. */
  description?: string;

  /** Sets list of environments meta data. */
  environmentsMetadata?: ReleaseStartEnvironmentMetadata[];

  /** Sets 'true' to create release in draft mode, 'false' otherwise. */
  isDraft?: boolean;

  /** Sets list of environments to manual as condition. */
  manualEnvironments?: string[];

  properties?: PropertiesCollection;

  /** Sets reason to create a release. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseReason",
      values: #[
        #{ value: "none", description: "Indicates the release triggered reason not set." },
        #{ value: "manual", description: "Indicates the release triggered manually." },
        #{
          value: "continuousIntegration",
          description: "Indicates the release triggered by continuous integration.",
        },
        #{ value: "schedule", description: "Indicates the release triggered by schedule." },
        #{ value: "pullRequest", description: "Indicates the release triggered by PullRequest." }
      ],
    }
  )
  reason?: "none" | "manual" | "continuousIntegration" | "schedule" | "pullRequest";

  /** Sets list of release variables to be overridden at deployment time. */
  variables?: Record<ConfigurationVariableValue>;
}

model ReleaseTask {
  /** Agent name on which task executed. */
  agentName?: string;

  /** Finish time of the release task. */
  finishTime?: utcDateTime;

  /** ID of the release task. */
  id?: int32;

  /** List of issues occurred while execution of task. */
  issues?: Issue[];

  /** Number of lines log release task has. */
  lineCount?: int64;

  /** Log URL of the task. */
  logUrl?: string;

  /** Name of the task. */
  name?: string;

  /** Task execution complete precent. */
  percentComplete?: int32;

  /** Rank of the release task. */
  rank?: int32;

  /** Result code of the task. */
  resultCode?: string;

  /** ID of the release task. */
  startTime?: utcDateTime;

  /** Status of release task. */
  @extension(
    "x-ms-enum",
    #{
      name: "TaskStatus",
      values: #[
        #{ value: "unknown", description: "The task does not have the status set." },
        #{ value: "pending", description: "The task is in pending status." },
        #{ value: "inProgress", description: "The task is currently in progress." },
        #{ value: "success", description: "The task completed successfully." },
        #{ value: "failure", description: "The task execution failed." },
        #{ value: "canceled", description: "The task execution canceled." },
        #{ value: "skipped", description: "The task execution skipped." },
        #{ value: "succeeded", description: "The task completed successfully." },
        #{ value: "failed", description: "The task execution failed." },
        #{ value: "partiallySucceeded", description: "The task execution partially succeeded." }
      ],
    }
  )
  status?:
    | "unknown"
    | "pending"
    | "inProgress"
    | "success"
    | "failure"
    | "canceled"
    | "skipped"
    | "succeeded"
    | "failed"
    | "partiallySucceeded";

  task?: WorkflowTaskReference;

  /** Timeline record ID of the release task. */
  @format("uuid") timelineRecordId?: string;
}

model ReleaseTaskAttachment {
  _links?: ReferenceLinks;

  /** Data and time when it created. */
  createdOn?: utcDateTime;

  modifiedBy?: IdentityRef;

  /** Data and time when modified. */
  modifiedOn?: utcDateTime;

  /** Name of the task attachment. */
  name?: string;

  /** Record ID of the task. */
  @format("uuid") recordId?: string;

  /** Timeline ID of the task. */
  @format("uuid") timelineId?: string;

  /** Type of task attachment. */
  type?: string;
}

model ReleaseTaskLogUpdatedEvent {
  ...RealtimeReleaseEvent;
  lines?: string[];
  @format("uuid") stepRecordId?: string;
  @format("uuid") timelineRecordId?: string;
}

model ReleaseTasksUpdatedEvent {
  ...RealtimeReleaseEvent;
  job?: ReleaseTask;
  @format("uuid") planId?: string;
  releaseStepId?: int32;
  tasks?: ReleaseTask[];
}

model ReleaseTriggerBase {
  /** Type of release trigger. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseTriggerType",
      values: #[
        #{ value: "undefined", description: "Release trigger type not set." },
        #{ value: "artifactSource", description: "Artifact based release trigger." },
        #{ value: "schedule", description: "Schedule based release trigger." },
        #{ value: "sourceRepo", description: "Source repository based release trigger." },
        #{ value: "containerImage", description: "Container image based release trigger." },
        #{ value: "package", description: "Package based release trigger." },
        #{ value: "pullRequest", description: "Pull request based release trigger." }
      ],
    }
  )
  triggerType?:
    | "undefined"
    | "artifactSource"
    | "schedule"
    | "sourceRepo"
    | "containerImage"
    | "package"
    | "pullRequest";
}

model ReleaseUpdatedEvent {
  ...RealtimeReleaseEvent;
  release?: Release;
}

model ReleaseUpdateMetadata {
  /** Sets comment for release. */
  comment?: string;

  /** Set 'true' to exclude the release from retention policies. */
  keepForever?: boolean;

  /** Sets list of manual environments. */
  manualEnvironments?: string[];

  /** Sets name of the release. */
  name?: string;

  /** Sets status of the release. */
  @extension(
    "x-ms-enum",
    #{
      name: "ReleaseStatus",
      values: #[
        #{ value: "undefined", description: "Release status not set." },
        #{ value: "draft", description: "Release is in draft state." },
        #{ value: "active", description: "Release status is in active." },
        #{ value: "abandoned", description: "Release status is in abandoned." }
      ],
    }
  )
  status?: "undefined" | "draft" | "active" | "abandoned";
}

model ReleaseWorkItemRef {
  /** Gets or sets the ID. */
  id?: string;

  /** Gets or sets the provider. */
  provider?: string;

  /** Gets or sets the state. */
  state?: string;

  /** Gets or sets the title. */
  title?: string;

  /** Gets or sets the type. */
  type?: string;

  /** Gets or sets the workitem url. */
  url?: string;
}

/** Represents a reference to a resource. */
model ResourceReference {
  /** An alias to be used when referencing the resource. */
  `alias`?: string;
}

model RetentionPolicy {
  /** Indicates the number of days to keep deployment. */
  daysToKeep?: int32;
}

model RetentionSettings {
  /** Number of days to keep deleted releases. */
  daysToKeepDeletedReleases?: int32;

  defaultEnvironmentRetentionPolicy?: EnvironmentRetentionPolicy;
  maximumEnvironmentRetentionPolicy?: EnvironmentRetentionPolicy;
}

model RunOnServerDeployPhase {
  ...DeployPhase;
  deploymentInput?: ServerDeploymentInput;
}

model ScheduledReleaseTrigger {
  ...ReleaseTriggerBase;
  schedule?: ReleaseSchedule;
}

model ServerDeploymentInput {
  ...BaseDeploymentInput;
  parallelExecution?: ExecutionInput;

  /** Gets or sets the proof of presence data. */
  proofOfPresenceTenants?: Record<ProofOfPresenceTenant>;
}

/** Represents a reference to a service endpoint. */
model ServiceEndpointReference {
  ...ResourceReference;

  /** The ID of the service endpoint. */
  @format("uuid") id?: string;
}

model SourceIdInput {
  /** ID of source. */
  id?: string;

  /** Name of the source. */
  name?: string;
}

model SourcePullRequestVersion {
  /** Pull Request Iteration Id for which the release will publish status. */
  iterationId?: string;

  /** Pull Request Id for which the release will publish status. */
  pullRequestId?: string;

  /** Date and time of the pull request merge creation. It is required to keep timeline record of Releases created by pull request. */
  pullRequestMergedAt?: utcDateTime;

  /** Source branch of the Pull Request. */
  sourceBranch?: string;

  /** Source branch commit Id of the Pull Request for which the release will publish status. */
  sourceBranchCommitId?: string;

  /** Target branch of the Pull Request. */
  targetBranch?: string;
}

model SourceRepoTrigger {
  ...ReleaseTriggerBase;

  /** Alias of the source repo trigger. */
  `alias`?: string;

  branchFilters?: string[];
}

model SummaryMailSection {
  /** Html content of summary mail. */
  htmlContent?: string;

  /** Rank of the summary mail. */
  rank?: int32;

  /** Summary mail section type. MailSectionType has section types. */
  @extension(
    "x-ms-enum",
    #{
      name: "MailSectionType",
      values: #[
        #{ value: "details", description: "" },
        #{ value: "environments", description: "" },
        #{ value: "issues", description: "" },
        #{ value: "testResults", description: "" },
        #{ value: "workItems", description: "" },
        #{ value: "releaseInfo", description: "" }
      ],
    }
  )
  sectionType?: "details" | "environments" | "issues" | "testResults" | "workItems" | "releaseInfo";

  /** Title of the summary mail. */
  title?: string;
}

model TagFilter {
  /** Gets or sets the tag filter pattern. */
  pattern?: string;
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

model TaskOrchestrationPlanGroupReference {
  /** Gets or sets the plan group. */
  planGroup?: string;

  /** ID of the Project. */
  @format("uuid") projectId?: string;
}

model TaskOrchestrationPlanGroupsStartedEvent {
  planGroups?: TaskOrchestrationPlanGroupReference[];
}

model TaskSourceDefinitionBase {
  authKey?: string;
  endpoint?: string;
  keySelector?: string;
  selector?: string;
  target?: string;
}

model TfvcArtifactDownloadInput {
  ...ArtifactDownloadInputBase;
}

model TimeZone {
  /** Display name of the time zone. */
  displayName?: string;

  /** Id of the time zone. */
  id?: string;
}

model TimeZoneList {
  utcTimeZone?: TimeZone;

  /** List of valid timezones. */
  validTimeZones?: TimeZone[];
}

model VariableGroup {
  createdBy?: IdentityRef;

  /** Gets date on which it got created. */
  createdOn?: utcDateTime;

  /** Gets or sets description. */
  description?: string;

  /** Gets the unique identifier of this field. */
  id?: int32;

  /** Denotes if a variable group is shared with other project or not. */
  isShared?: boolean;

  modifiedBy?: IdentityRef;

  /** Gets date on which it got modified. */
  modifiedOn?: utcDateTime;

  /** Gets or sets name. */
  name?: string;

  providerData?: VariableGroupProviderData;

  /** Gets or sets type. */
  type?: string;

  /** all project references where the variable group is shared with other projects. */
  variableGroupProjectReferences?: VariableGroupProjectReference[];

  /** Gets and sets the dictionary of variables. */
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

model VariableGroupProviderData {}

model VariableValue {
  /** Gets or sets if the variable is read only or not. */
  isReadOnly?: boolean;

  /** Gets or sets as the variable is secret or not. */
  isSecret?: boolean;

  /** Gets or sets the value. */
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

model WorkflowTask {
  /** Gets or sets as the task always run or not. */
  alwaysRun?: boolean;

  checkConfig?: CheckConfigurationReference;

  /** Gets or sets the task condition. */
  condition?: string;

  /** Gets or sets as the task continue run on error or not. */
  continueOnError?: boolean;

  /** Gets or sets the task definition type. Example:- 'Agent', DeploymentGroup', 'Server' or 'ServerGate'. */
  definitionType?: string;

  /** Gets or sets as the task enabled or not. */
  enabled?: boolean;

  /** Gets or sets the task environment variables. */
  environment?: Record<string>;

  /** Gets or sets the task inputs. */
  inputs?: Record<string>;

  /** Gets or sets the name of the task. */
  name?: string;

  /** Gets or sets the task override inputs. */
  overrideInputs?: Record<string>;

  /** Gets or sets the reference name of the task. */
  refName?: string;

  /** Gets or sets the task retryCount. */
  retryCountOnTaskFailure?: int32;

  /** Gets or sets the ID of the task. */
  @format("uuid") taskId?: string;

  /** Gets or sets the task timeout. */
  timeoutInMinutes?: int32;

  /** Gets or sets the version of the task. */
  version?: string;
}

model WorkflowTaskReference {
  /** Task identifier. */
  @format("uuid") id?: string;

  /** Name of the task. */
  name?: string;

  /** Version of the task. */
  version?: string;
}

model YamlFileSource {
  /** Gets or sets definition reference. e.g. {'project':{'id':'fed755ea-49c5-4399-acea-fd5b5aa90a6c','name':'myProject'},'definition':{'id':'1','name':'mybuildDefinition'},'connection':{'id':'1','name':'myConnection'}} */
  sourceReference?: Record<YamlSourceReference>;

  @extension(
    "x-ms-enum",
    #{
      name: "YamlFileSourceTypes",
      values: #[#{ value: "none", description: "" }, #{ value: "tfsGit", description: "" }],
    }
  )
  type?: "none" | "tfsGit";
}

model YamlPipelineProcess {
  ...PipelineProcess;
  errors?: string[];
  filename?: string;
  fileSource?: YamlFileSource;
  resources?: YamlPipelineProcessResources;
}

model YamlPipelineProcessResources {
  endpoints?: ServiceEndpointReference[];
  queues?: AgentPoolQueueReference[];
}

model YamlSourceReference {
  id?: string;
  name?: string;
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
    model `8` {
      /** Version of the API to use. This should be set to '7.2-preview.8' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `9` {
      /** Version of the API to use. This should be set to '7.2-preview.9' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Approvals {
  /** Get a list of approvals */
  @tag("Approvals")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "approvals")
  @extension("x-ms-vss-method", "GetApprovals")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/approvals")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Approvals assigned to this user. */
    @query(#{ explode: true }) assignedToFilter?: string,

    /** Approvals with this status. Default is 'pending'. */
    @extension(
      "x-ms-enum",
      #{
        name: "ApprovalStatus",
        values: #[
          #{
            value: "undefined",
            description: "Indicates the approval does not have the status set.",
          },
          #{ value: "pending", description: "Indicates the approval is pending." },
          #{ value: "approved", description: "Indicates the approval is approved." },
          #{ value: "rejected", description: "Indicates the approval is rejected." },
          #{ value: "reassigned", description: "Indicates the approval is reassigned." },
          #{ value: "canceled", description: "Indicates the approval is canceled." },
          #{ value: "skipped", description: "Indicates the approval is skipped." }
        ],
      }
    )
    @query(#{ explode: true })
    statusFilter?:
      | "undefined"
      | "pending"
      | "approved"
      | "rejected"
      | "reassigned"
      | "canceled"
      | "skipped",

    /** Approvals for release id(s) mentioned in the filter. Multiple releases can be mentioned by separating them with ',' e.g. releaseIdsFilter=1,2,3,4. */
    @format("array (int32)") @query(#{ explode: true }) releaseIdsFilter?: string,

    /** Approval with this type. */
    @extension(
      "x-ms-enum",
      #{
        name: "ApprovalType",
        values: #[
          #{ value: "undefined", description: "Indicates the approval type does not set." },
          #{
            value: "preDeploy",
            description: "Indicates the approvals which executed before deployment.",
          },
          #{
            value: "postDeploy",
            description: "Indicates the approvals which executed after deployment.",
          },
          #{ value: "all", description: "Indicates all approvals." }
        ],
      }
    )
    @query(#{ explode: true })
    typeFilter?: "undefined" | "preDeploy" | "postDeploy" | "all",

    /** Number of approvals to get. Default is 50. */
    @query(#{ explode: true }) top?: int32,

    /** Gets the approvals after the continuation token provided. */
    @query(#{ explode: true }) continuationToken?: int32,

    /** Gets the results in the defined order of created approvals. Default is 'descending'. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseQueryOrder",
        values: #[
          #{ value: "descending", description: "Return results in descending order." },
          #{ value: "ascending", description: "Return results in ascending order." }
        ],
      }
    )
    @query(#{ explode: true })
    queryOrder?: "descending" | "ascending",

    /** 'true' to include my group approvals. Default is 'false'. */
    @query(#{ explode: true }) includeMyGroupApprovals?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): Body<ReleaseApproval[]>;

  /** Update status of an approval */
  @tag("Approvals")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "approvals")
  @extension("x-ms-vss-method", "UpdateReleaseApproval")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/approvals/{approvalId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the approval. */
    @path approvalId: int32,

    ...Parameters.`api-Version-preview`.`3`,

    /** ReleaseApproval object having status, approver and comments. */
    @body body: ReleaseApproval,
  ): ReleaseApproval;
}

interface Definitions {
  /** Get a list of release definitions. */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "definitions")
  @extension("x-ms-vss-method", "GetReleaseDefinitions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/definitions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Get release definitions with names containing searchText. */
    @query(#{ explode: true }) searchText?: string,

    /** The properties that should be expanded in the list of Release definitions. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseDefinitionExpands",
        values: #[
          #{ value: "none", description: "Returns top level properties of object." },
          #{ value: "environments", description: "Include environments in return object." },
          #{ value: "artifacts", description: "Include artifacts in return object." },
          #{ value: "triggers", description: "Include triggers in return object." },
          #{ value: "variables", description: "Include variables in return object." },
          #{ value: "tags", description: "Include tags in return object." },
          #{ value: "lastRelease", description: "Include last release in return object." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?:
      | "none"
      | "environments"
      | "artifacts"
      | "triggers"
      | "variables"
      | "tags"
      | "lastRelease",

    /** Release definitions with given artifactType will be returned. Values can be Build, Jenkins, GitHub, Nuget, Team Build (external), ExternalTFSBuild, Git, TFVC, ExternalTfsXamlBuild. */
    @query(#{ explode: true }) artifactType?: string,

    /** Release definitions with given artifactSourceId will be returned. e.g. For build it would be {projectGuid}:{BuildDefinitionId}, for Jenkins it would be {JenkinsConnectionId}:{JenkinsDefinitionId}, for TfsOnPrem it would be {TfsOnPremConnectionId}:{ProjectName}:{TfsOnPremDefinitionId}. For third-party artifacts e.g. TeamCity, BitBucket you may refer 'uniqueSourceIdentifier' inside vss-extension.json at https://github.com/Microsoft/vsts-rm-extensions/blob/master/Extensions. */
    @query(#{ explode: true }) artifactSourceId?: string,

    /** Number of release definitions to get. */
    @query(#{ explode: true }) $top?: int32,

    /** Gets the release definitions after the continuation token provided. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Gets the results in the defined order. Default is 'IdAscending'. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseDefinitionQueryOrder",
        values: #[
          #{
            value: "idAscending",
            description: "Return results based on release definition Id ascending order.",
          },
          #{
            value: "idDescending",
            description: "Return results based on release definition Id descending order.",
          },
          #{
            value: "nameAscending",
            description: "Return results based on release definition name ascending order.",
          },
          #{
            value: "nameDescending",
            description: "Return results based on release definition name descending order.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    queryOrder?: "idAscending" | "idDescending" | "nameAscending" | "nameDescending",

    /** Gets the release definitions under the specified path. */
    @query(#{ explode: true }) path?: string,

    /** 'true'to gets the release definitions with exact match as specified in searchText. Default is 'false'. */
    @query(#{ explode: true }) isExactNameMatch?: boolean,

    /** A comma-delimited list of tags. Only release definitions with these tags will be returned. */
    @format("array (string)") @query(#{ explode: true }) tagFilter?: string,

    /** A comma-delimited list of extended properties to be retrieved. If set, the returned Release Definitions will contain values for the specified property Ids (if they exist). If not set, properties will not be included. Note that this will not filter out any Release Definition from results irrespective of whether it has property set or not. */
    @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

    /** A comma-delimited list of release definitions to retrieve. */
    @format("array (string)") @query(#{ explode: true }) definitionIdFilter?: string,

    /** 'true' to get release definitions that has been deleted. Default is 'false' */
    @query(#{ explode: true }) isDeleted?: boolean,

    /** 'true' to get the release definitions under the folder with name as specified in searchText. Default is 'false'. */
    @query(#{ explode: true }) searchTextContainsFolderName?: boolean,

    ...Parameters.`api-Version-preview`.`4`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: ReleaseDefinition[];
  };

  /** Create a release definition */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "definitions")
  @extension("x-ms-vss-method", "CreateReleaseDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/definitions")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`4`,

    /** release definition object to create. */
    @body body: ReleaseDefinition,
  ): ReleaseDefinition;

  /** Update a release definition. */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "definitions")
  @extension("x-ms-vss-method", "UpdateReleaseDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/definitions")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Skip task validation boolean flag */
    @query(#{ explode: true }) skipTasksValidation?: boolean,

    ...Parameters.`api-Version-preview`.`4`,

    /** Release definition object to update. */
    @body body: ReleaseDefinition,
  ): ReleaseDefinition;

  /** Delete a release definition. */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "definitions")
  @extension("x-ms-vss-method", "DeleteReleaseDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/definitions/{definitionId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release definition. */
    @path definitionId: int32,

    /** Comment for deleting a release definition. */
    @query(#{ explode: true }) comment?: string,

    /** 'true' to automatically cancel any in-progress release deployments and proceed with release definition deletion . Default is 'false'. */
    @query(#{ explode: true }) forceDelete?: boolean,

    ...Parameters.`api-Version-preview`.`4`,
  ): OkResponse;

  /** Get a release definition. */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "definitions")
  @extension("x-ms-vss-method", "GetReleaseDefinition")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/definitions/{definitionId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release definition. */
    @path definitionId: int32,

    /** A comma-delimited list of extended properties to be retrieved. If set, the returned Release Definition will contain values for the specified property Ids (if they exist). If not set, properties will not be included. */
    @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

    /** Boolean flag to include disabled definitions. */
    @query(#{ explode: true }) includeDisabled?: boolean,

    ...Parameters.`api-Version-preview`.`4`,
  ): ReleaseDefinition;

  /** Get revision history for a release definition */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "revisions")
  @extension("x-ms-vss-method", "GetReleaseDefinitionHistory")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/definitions/{definitionId}/revisions")
  @get
  GetReleaseDefinitionHistory(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the definition. */
    @path definitionId: int32,

    ...Parameters.`api-Version-preview`.`4`,
  ): Body<ReleaseDefinitionRevision[]>;

  /** Get release definition for a given definitionId and revision */
  @tag("Definitions")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "revisions")
  @extension("x-ms-vss-method", "GetDefinitionRevision")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/definitions/{definitionId}/revisions/{revision}")
  @get
  GetDefinitionRevision(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the definition. */
    @path definitionId: int32,

    /** Id of the revision. */
    @path revision: int32,

    ...Parameters.`api-Version-preview`.`4`,
  ): {
    @header contentType: "text/plain";
    @body @format("Stream") body: string;
  };
}

interface Deployments {
  /** Get a list of deployments */
  @tag("Deployments")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "deployments")
  @extension("x-ms-vss-method", "GetDeployments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/deployments")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** List the deployments for a given definition id. */
    @query(#{ explode: true }) definitionId?: int32,

    /** List the deployments for a given definition environment id. */
    @query(#{ explode: true }) definitionEnvironmentId?: int32,

    /** List the deployments for which deployments are created as identity specified. */
    @query(#{ explode: true }) createdBy?: string,

    /** List the deployments with LastModified time >= minModifiedTime. */
    @query(#{ explode: true }) minModifiedTime?: utcDateTime,

    /** List the deployments with LastModified time <= maxModifiedTime. */
    @query(#{ explode: true }) maxModifiedTime?: utcDateTime,

    /** List the deployments with given deployment status. Default is 'All'. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentStatus",
        values: #[
          #{ value: "undefined", description: "The deployment status is undefined." },
          #{ value: "notDeployed", description: "The deployment status is not deployed." },
          #{ value: "inProgress", description: "The deployment status is in progress." },
          #{ value: "succeeded", description: "The deployment status is succeeded." },
          #{
            value: "partiallySucceeded",
            description: "The deployment status is partiallysucceeded.",
          },
          #{ value: "failed", description: "The deployment status is failed." },
          #{ value: "all", description: "The deployment status is all." }
        ],
      }
    )
    @query(#{ explode: true })
    deploymentStatus?:
      | "undefined"
      | "notDeployed"
      | "inProgress"
      | "succeeded"
      | "partiallySucceeded"
      | "failed"
      | "all",

    /** List the deployments with given operation status. Default is 'All'. */
    @extension(
      "x-ms-enum",
      #{
        name: "DeploymentOperationStatus",
        values: #[
          #{ value: "undefined", description: "The deployment operation status is undefined." },
          #{ value: "queued", description: "The deployment operation status is queued." },
          #{ value: "scheduled", description: "The deployment operation status is scheduled." },
          #{ value: "pending", description: "The deployment operation status is pending." },
          #{ value: "approved", description: "The deployment operation status is approved." },
          #{ value: "rejected", description: "The deployment operation status is rejected." },
          #{ value: "deferred", description: "The deployment operation status is deferred." },
          #{
            value: "queuedForAgent",
            description: "The deployment operation status is queued for agent.",
          },
          #{
            value: "phaseInProgress",
            description: "The deployment operation status is phase in progress.",
          },
          #{
            value: "phaseSucceeded",
            description: "The deployment operation status is phase succeeded.",
          },
          #{
            value: "phasePartiallySucceeded",
            description: "The deployment operation status is phase partially succeeded.",
          },
          #{ value: "phaseFailed", description: "The deployment operation status is phase failed." },
          #{ value: "canceled", description: "The deployment operation status is canceled." },
          #{
            value: "phaseCanceled",
            description: "The deployment operation status is phase canceled.",
          },
          #{
            value: "manualInterventionPending",
            description: "The deployment operation status is manualintervention pending.",
          },
          #{
            value: "queuedForPipeline",
            description: "The deployment operation status is queued for pipeline.",
          },
          #{ value: "cancelling", description: "The deployment operation status is cancelling." },
          #{
            value: "evaluatingGates",
            description: "The deployment operation status is EvaluatingGates.",
          },
          #{ value: "gateFailed", description: "The deployment operation status is GateFailed." },
          #{ value: "all", description: "The deployment operation status is all." }
        ],
      }
    )
    @query(#{ explode: true })
    operationStatus?:
      | "undefined"
      | "queued"
      | "scheduled"
      | "pending"
      | "approved"
      | "rejected"
      | "deferred"
      | "queuedForAgent"
      | "phaseInProgress"
      | "phaseSucceeded"
      | "phasePartiallySucceeded"
      | "phaseFailed"
      | "canceled"
      | "phaseCanceled"
      | "manualInterventionPending"
      | "queuedForPipeline"
      | "cancelling"
      | "evaluatingGates"
      | "gateFailed"
      | "all",

    /** 'true' to include deployments with latest attempt only. Default is 'false'. */
    @query(#{ explode: true }) latestAttemptsOnly?: boolean,

    /** List the deployments with given query order. Default is 'Descending'. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseQueryOrder",
        values: #[
          #{ value: "descending", description: "Return results in descending order." },
          #{ value: "ascending", description: "Return results in ascending order." }
        ],
      }
    )
    @query(#{ explode: true })
    queryOrder?: "descending" | "ascending",

    /** List the deployments with given top. Default top is '50' and Max top is '100'. */
    @query(#{ explode: true }) $top?: int32,

    /** List the deployments with deployment id >= continuationToken. */
    @query(#{ explode: true }) continuationToken?: int32,

    /** List the deployments for which deployments are requested as identity specified. */
    @query(#{ explode: true }) createdFor?: string,

    /** List the deployments with StartedOn time >= minStartedTime. */
    @query(#{ explode: true }) minStartedTime?: utcDateTime,

    /** List the deployments with StartedOn time <= maxStartedTime. */
    @query(#{ explode: true }) maxStartedTime?: utcDateTime,

    /** List the deployments that are deployed from given branch name. */
    @query(#{ explode: true }) sourceBranch?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<Deployment[]>;
}

interface Folders {
  /** Deletes a definition folder for given folder name and path and all it's existing definitions. */
  @tag("Folders")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "folders")
  @extension("x-ms-vss-method", "DeleteFolder")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/folders/{path}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Path of the folder to delete. */
    @path path: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Gets folders. */
  @tag("Folders")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "folders")
  @extension("x-ms-vss-method", "GetFolders")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/folders/{path}")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Path of the folder. */
    @extension("x-ms-required", false) @path path: string,

    /** Gets the results in the defined order. Default is 'None'. */
    @extension(
      "x-ms-enum",
      #{
        name: "FolderPathQueryOrder",
        values: #[
          #{ value: "none", description: "No order." },
          #{ value: "ascending", description: "Order by folder name and path ascending." },
          #{ value: "descending", description: "Order by folder name and path descending." }
        ],
      }
    )
    @query(#{ explode: true })
    queryOrder?: "none" | "ascending" | "descending",

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<Folder[]>;

  /** Updates an existing folder at given existing path. */
  @tag("Folders")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "folders")
  @extension("x-ms-vss-method", "UpdateFolder")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/folders/{path}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Path of the folder to update. */
    @path path: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** folder. */
    @body body: Folder,
  ): Folder;

  /** This method is no longer supported. Use CreateFolder with folder parameter API. */
  @tag("Folders")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "folders")
  @extension("x-ms-vss-method", "CreateFolder")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/folders/{path}")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Path of the folder. */
    @extension("x-ms-required", false) @path path: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** folder. */
    @body body: Folder,
  ): Folder;
}

interface Gates {
  /** Updates the gate for a deployment. */
  @tag("Gates")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "gates")
  @extension("x-ms-vss-method", "UpdateGates")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/gates/{gateStepId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Gate step Id. */
    @path gateStepId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Metadata to patch the Release Gates. */
    @body body: GateUpdateMetadata,
  ): ReleaseGates;
}

interface Releases {
  /** Get a list of releases */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.9")
  @extension("x-ms-vss-resource", "releases")
  @extension("x-ms-vss-method", "GetReleases")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    /** Releases from this release definition Id. */
    @query(#{ explode: true }) definitionId?: int32,

    /** Id of the definition environment. Required when using environmentStatusFilter. */
    @query(#{ explode: true }) definitionEnvironmentId?: int32,

    /** Releases with names containing searchText. */
    @query(#{ explode: true }) searchText?: string,

    /** Releases created by this user. */
    @query(#{ explode: true }) createdBy?: string,

    /** Releases that have this status. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseStatus",
        values: #[
          #{ value: "undefined", description: "Release status not set." },
          #{ value: "draft", description: "Release is in draft state." },
          #{ value: "active", description: "Release status is in active." },
          #{ value: "abandoned", description: "Release status is in abandoned." }
        ],
      }
    )
    @query(#{ explode: true })
    statusFilter?: "undefined" | "draft" | "active" | "abandoned",

    /** Filters releases by environment status. Must be used with definitionEnvironmentId. Values: Undefined (0), NotStarted (1), InProgress (2), Succeeded (4), Canceled (8), Rejected (16), Queued (32), Scheduled (64), PartiallySucceeded (128). These are [Flags] values and can be combined (e.g. 4|16 = 20 for Succeeded or Rejected). Cannot be used with sourceBranchFilter. */
    @query(#{ explode: true }) environmentStatusFilter?: int32,

    /** Releases that were created after this time. */
    @query(#{ explode: true }) minCreatedTime?: utcDateTime,

    /** Releases that were created before this time. */
    @query(#{ explode: true }) maxCreatedTime?: utcDateTime,

    /** Gets the results in the defined order of created date for releases. Default is descending. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseQueryOrder",
        values: #[
          #{ value: "descending", description: "Return results in descending order." },
          #{ value: "ascending", description: "Return results in ascending order." }
        ],
      }
    )
    @query(#{ explode: true })
    queryOrder?: "descending" | "ascending",

    /** Number of releases to get. Default is 50. */
    @query(#{ explode: true }) $top?: int32,

    /** Gets the releases after the continuation token provided. */
    @query(#{ explode: true }) continuationToken?: int32,

    /** The property that should be expanded in the list of releases. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseExpands",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "environments", description: "" },
          #{ value: "artifacts", description: "" },
          #{ value: "approvals", description: "" },
          #{ value: "manualInterventions", description: "" },
          #{ value: "variables", description: "" },
          #{ value: "tags", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?:
      | "none"
      | "environments"
      | "artifacts"
      | "approvals"
      | "manualInterventions"
      | "variables"
      | "tags",

    /** Releases with given artifactTypeId will be returned. Values can be Build, Jenkins, GitHub, Nuget, Team Build (external), ExternalTFSBuild, Git, TFVC, ExternalTfsXamlBuild. */
    @query(#{ explode: true }) artifactTypeId?: string,

    /** Unique identifier of the artifact used. e.g. For build it would be {projectGuid}:{BuildDefinitionId}, for Jenkins it would be {JenkinsConnectionId}:{JenkinsDefinitionId}, for TfsOnPrem it would be {TfsOnPremConnectionId}:{ProjectName}:{TfsOnPremDefinitionId}. For third-party artifacts e.g. TeamCity, BitBucket you may refer 'uniqueSourceIdentifier' inside vss-extension.json https://github.com/Microsoft/vsts-rm-extensions/blob/master/Extensions. */
    @query(#{ explode: true }) sourceId?: string,

    /** Releases with given artifactVersionId will be returned. E.g. in case of Build artifactType, it is buildId. */
    @query(#{ explode: true }) artifactVersionId?: string,

    /** Releases with given sourceBranchFilter will be returned (Not to be used with environmentStatusFilter). */
    @query(#{ explode: true }) sourceBranchFilter?: string,

    /** Gets the soft deleted releases, if true. */
    @query(#{ explode: true }) isDeleted?: boolean,

    /** A comma-delimited list of tags. Only releases with these tags will be returned. */
    @format("array (string)") @query(#{ explode: true }) tagFilter?: string,

    /** A comma-delimited list of extended properties to be retrieved. If set, the returned Releases will contain values for the specified property Ids (if they exist). If not set, properties will not be included. Note that this will not filter out any Release from results irrespective of whether it has property set or not. */
    @format("array (string)") @query(#{ explode: true }) propertyFilters?: string,

    /** A comma-delimited list of releases Ids. Only releases with these Ids will be returned. */
    @format("array (int32)") @query(#{ explode: true }) releaseIdFilter?: string,

    /** Releases under this folder path will be returned */
    @query(#{ explode: true }) path?: string,

    ...Parameters.`api-Version-preview`.`9`,
  ): Body<Release[]>;

  /** Create a release. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.9")
  @extension("x-ms-vss-resource", "releases")
  @extension("x-ms-vss-method", "CreateRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`9`,

    /** Metadata to create a release. */
    @body body: ReleaseStartMetadata,
  ): Release;

  /** Get release for a given revision number. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.9")
  @extension("x-ms-vss-resource", "releases")
  @extension("x-ms-vss-method", "GetReleaseRevision")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}")
  @get
  GetReleaseRevision(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Definition snapshot revision number. */
    @query(#{ explode: true }) definitionSnapshotRevision: int32,

    ...Parameters.`api-Version-preview`.`9`,
  ): {
    @header contentType: "text/plain";
    @body @format("Stream") body: string;
  };

  /** Update few properties of a release. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.9")
  @extension("x-ms-vss-resource", "releases")
  @extension("x-ms-vss-method", "UpdateReleaseResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}")
  @patch
  UpdateReleaseResource(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release to update. */
    @path releaseId: int32,

    ...Parameters.`api-Version-preview`.`9`,

    /** Properties of release to update. */
    @body body: ReleaseUpdateMetadata,
  ): Release;

  /** Update a complete release object. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.9")
  @extension("x-ms-vss-resource", "releases")
  @extension("x-ms-vss-method", "UpdateRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}")
  @put
  UpdateRelease(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release to update. */
    @path releaseId: int32,

    ...Parameters.`api-Version-preview`.`9`,

    /** Release object for update. */
    @body body: Release,
  ): Release;

  /** Get a release environment. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.8")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "GetReleaseEnvironment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/releases/{releaseId}/environments/{environmentId}")
  @get
  GetReleaseEnvironment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the release environment. */
    @path environmentId: int32,

    /** A property that should be expanded in the environment. */
    @extension(
      "x-ms-enum",
      #{
        name: "ReleaseEnvironmentExpands",
        values: #[
          #{ value: "none", description: "Return top level properties of object." },
          #{ value: "tasks", description: "Expand environment with tasks." }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "tasks",

    ...Parameters.`api-Version-preview`.`8`,
  ): ReleaseEnvironment;

  /** Update the status of a release environment */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.8")
  @extension("x-ms-vss-resource", "environments")
  @extension("x-ms-vss-method", "UpdateReleaseEnvironment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/releases/{releaseId}/environments/{environmentId}")
  @patch
  UpdateReleaseEnvironment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of release environment. */
    @path environmentId: int32,

    ...Parameters.`api-Version-preview`.`8`,

    /** Environment update meta data. */
    @body body: ReleaseEnvironmentUpdateMetadata,
  ): ReleaseEnvironment;

  /** Gets the task log of a release as a plain text file. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "logs")
  @extension("x-ms-vss-method", "GetTaskLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}/environments/{environmentId}/deployPhases/{releaseDeployPhaseId}/tasks/{taskId}/logs")
  @get
  GetTaskLog(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of release environment. */
    @path environmentId: int32,

    /** Release deploy phase Id. */
    @path releaseDeployPhaseId: int32,

    /** ReleaseTask Id for the log. */
    @path taskId: int32,

    /** Starting line number for logs */
    @query(#{ explode: true }) startLine?: int64,

    /** Ending line number for logs */
    @query(#{ explode: true }) endLine?: int64,

    ...Parameters.`api-Version-preview`.`2`,
  ): {
    @header contentType: "text/plain";
    @body @format("Stream") body: string;
  };

  /** Get logs for a release Id. */
  @tag("Releases")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "logs")
  @extension("x-ms-vss-method", "GetLogs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}/logs")
  @get
  GetLogs(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): {
    @header contentType: "application/zip";
    @body @format("Stream") body: string;
  };
}

interface Attachments {
  /** Get the release task attachments. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetReleaseTaskAttachments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}/environments/{environmentId}/attempts/{attemptId}/plan/{planId}/attachments/{type}")
  @get
  GetReleaseTaskAttachments(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the release environment. */
    @path environmentId: int32,

    /** Attempt number of deployment. */
    @path attemptId: int32,

    /** Plan Id of the deploy phase. */
    @format("uuid") @path planId: string,

    /** Type of the attachment. */
    @path type: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ReleaseTaskAttachment[]>;

  /** Get a release task attachment. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetReleaseTaskAttachmentContent")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}/environments/{environmentId}/attempts/{attemptId}/plan/{planId}/timelines/{timelineId}/records/{recordId}/attachments/{type}/{name}")
  @get
  GetReleaseTaskAttachmentContent(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the release environment. */
    @path environmentId: int32,

    /** Attempt number of deployment. */
    @path attemptId: int32,

    /** Plan Id of the deploy phase. */
    @format("uuid") @path planId: string,

    /** Timeline Id of the task. */
    @format("uuid") @path timelineId: string,

    /** Record Id of attachment. */
    @format("uuid") @path recordId: string,

    /** Type of the attachment. */
    @path type: string,

    /** Name of the attachment. */
    @path name: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/octet-stream";
    @body @format("Stream") body: string;
  };

  /** GetTaskAttachments API is deprecated. Use GetReleaseTaskAttachments API instead. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetTaskAttachments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}/environments/{environmentId}/attempts/{attemptId}/timelines/{timelineId}/attachments/{type}")
  @get
  GetTaskAttachments(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the release environment. */
    @path environmentId: int32,

    /** Attempt number of deployment. */
    @path attemptId: int32,

    /** Timeline Id of the task. */
    @format("uuid") @path timelineId: string,

    /** Type of the attachment. */
    @path type: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ReleaseTaskAttachment[]>;

  /** GetTaskAttachmentContent API is deprecated. Use GetReleaseTaskAttachmentContent API instead. */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetTaskAttachmentContent")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/release/releases/{releaseId}/environments/{environmentId}/attempts/{attemptId}/timelines/{timelineId}/records/{recordId}/attachments/{type}/{name}")
  @get
  GetTaskAttachmentContent(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the release environment. */
    @path environmentId: int32,

    /** Attempt number of deployment. */
    @path attemptId: int32,

    /** Timeline Id of the task. */
    @format("uuid") @path timelineId: string,

    /** Record Id of attachment. */
    @format("uuid") @path recordId: string,

    /** Type of the attachment. */
    @path type: string,

    /** Name of the attachment. */
    @path name: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/octet-stream";
    @body @format("Stream") body: string;
  };
}

interface ManualInterventions {
  /** List all manual interventions for a given release. */
  @tag("Manual Interventions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "manualInterventions")
  @extension("x-ms-vss-method", "GetManualInterventions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/releases/{releaseId}/manualinterventions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<ManualIntervention[]>;

  /** Get manual intervention for a given release and manual intervention id. */
  @tag("Manual Interventions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "manualInterventions")
  @extension("x-ms-vss-method", "GetManualIntervention")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/releases/{releaseId}/manualinterventions/{manualInterventionId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the manual intervention. */
    @path manualInterventionId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): ManualIntervention;

  /** Update manual intervention. */
  @tag("Manual Interventions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "manualInterventions")
  @extension("x-ms-vss-method", "UpdateManualIntervention")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/Release/releases/{releaseId}/manualinterventions/{manualInterventionId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the release. */
    @path releaseId: int32,

    /** Id of the manual intervention. */
    @path manualInterventionId: int32,

    ...Parameters.`api-Version-preview`.`2`,

    /** Meta data to update manual intervention. */
    @body body: ManualInterventionUpdateMetadata,
  ): ManualIntervention;
}
