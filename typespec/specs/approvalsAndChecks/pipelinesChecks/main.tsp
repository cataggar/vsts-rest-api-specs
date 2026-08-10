import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "PipelinesChecks" })
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
namespace PipelinesChecks;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model ApprovalCheckConfiguration {
  ...CheckConfiguration;
  settings?: ApprovalConfigSettings;
}

model ApprovalCheckDefinitionReference {
  @format("uuid") id?: string;
}

/** Config to create a new approval. */
model ApprovalConfig {
  /** Ordered list of approvers. */
  approvers?: IdentityRef[];

  /** Identities which are not allowed to approve. */
  blockedApprovers?: IdentityRef[];

  definitionRef?: ApprovalCheckDefinitionReference;

  /** Order in which approvers will be actionable. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalExecutionOrder",
      values: #[
        #{
          value: "anyOrder",
          description: "Indicates that the approvers can approve in any order.",
        },
        #{
          value: "inSequence",
          description: "Indicates that the approvers can only approve in a sequential order(Order in which they were assigned).",
        }
      ],
    }
  )
  executionOrder?: "anyOrder" | "inSequence";

  /** Instructions for the approver. */
  instructions?: string;

  /** Minimum number of approvers that should approve for the entire approval to be considered approved. Defaults to all. */
  minRequiredApprovers?: int32;
}

/** Config to create a new approval. */
model ApprovalConfigSettings {
  ...ApprovalConfig;

  /** Determines whether check requester can approve the check. */
  requesterCannotBeApprover?: boolean;
}

model CheckConfiguration {
  ...CheckConfigurationRef;
  _links?: ReferenceLinks;
  createdBy?: IdentityRef;

  /** Time when check got configured. */
  createdOn?: utcDateTime;

  /** Is check disabled. */
  isDisabled?: boolean;

  issue?: CheckIssue;
  modifiedBy?: IdentityRef;

  /** Time when configured check was modified. */
  modifiedOn?: utcDateTime;

  /** Timeout in minutes for the check. */
  timeout?: int32;
}

model CheckConfigurationData {
  checkConfiguration?: CheckConfiguration;

  /** Definition Ref Id of the particular check. */
  @format("uuid") definitionRefId?: string;
}

model CheckConfigurationRef {
  /** Check configuration id. */
  id?: int32;

  resource?: Resource;
  type?: CheckType;

  /** The URL from which one can fetch the configured check. */
  url?: string;

  /** Check configuration version. */
  version?: int32;
}

model CheckData {
  /** List of check configuration data */
  checkConfigurationDataList?: CheckConfigurationData[];

  /** List of check definitions */
  checkDefinitions?: CheckDefinitionData[];

  /** List of default check settings */
  defaultCheckSettings?: Record<string>;

  /** List of time zones. */
  timeZoneList?: TimeZone[];
}

model CheckDefinitionData {
  /** Flag to allow multiple configurations of a particular check on a resource. */
  allowMultipleConfigurations?: boolean;

  checkDefinition?: JObject;

  /** Checks evaluation order category. */
  @extension(
    "x-ms-enum",
    #{
      name: "CheckEvaluationOrder",
      values: #[
        #{ value: "system", description: "" },
        #{ value: "sanityChecks", description: "" },
        #{ value: "preChecks", description: "" },
        #{ value: "productionReadinessCheck", description: "" },
        #{ value: "proofOfPresence", description: "" },
        #{ value: "productionReadinessCheckDeprecated", description: "" },
        #{ value: "main", description: "" },
        #{ value: "postChecks", description: "" },
        #{ value: "proofOfPresenceTemp", description: "" },
        #{ value: "final", description: "" }
      ],
    }
  )
  checkEvaluationOrder?:
    | "system"
    | "sanityChecks"
    | "preChecks"
    | "productionReadinessCheck"
    | "proofOfPresence"
    | "productionReadinessCheckDeprecated"
    | "main"
    | "postChecks"
    | "proofOfPresenceTemp"
    | "final";

  /** Check DefinitionRef Id */
  @format("uuid") definitionRefId?: string;

  /** Description about the check */
  description?: string;

  icon?: CheckIcon;

  /** Name of the check */
  name?: string;

  /** Check UI contribution Dependencies */
  uiContributionDependencies?: string[];

  /** Check UI contribution Type */
  uiContributionType?: string;
}

model CheckIcon {
  /** Asset Location of the icon */
  assetLocation?: string;

  /** Name of the icon */
  name?: string;

  /** Url of the icon */
  url?: string;
}

/** An issue (error, warning) associated with a check configuration. */
model CheckIssue {
  /** Short summary of the check - its name and resource. */
  description?: string;

  /** A more detailed description of issue. */
  detailedMessage?: string;

  /** A description of issue. */
  message?: string;

  /** The type (error, warning) of the issue. */
  @extension(
    "x-ms-enum",
    #{
      name: "CheckIssueType",
      values: #[#{ value: "error", description: "" }, #{ value: "warning", description: "" }],
    }
  )
  type?: "error" | "warning";
}

model CheckIssueData {
  /** List of default check issue settings */
  defaultCheckIssueSettings?: Record<string>;

  /** List of resources with check issues */
  resourcesWithCheckIssuesList?: ResourceCheckIssue[];
}

model CheckRun {
  ...CheckRunResult;
  checkConfigurationRef?: CheckConfigurationRef;
  completedDate?: utcDateTime;
  createdDate?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "CheckEvaluationOrder",
      values: #[
        #{ value: "system", description: "" },
        #{ value: "sanityChecks", description: "" },
        #{ value: "preChecks", description: "" },
        #{ value: "productionReadinessCheck", description: "" },
        #{ value: "proofOfPresence", description: "" },
        #{ value: "productionReadinessCheckDeprecated", description: "" },
        #{ value: "main", description: "" },
        #{ value: "postChecks", description: "" },
        #{ value: "proofOfPresenceTemp", description: "" },
        #{ value: "final", description: "" }
      ],
    }
  )
  evaluationOrder?:
    | "system"
    | "sanityChecks"
    | "preChecks"
    | "productionReadinessCheck"
    | "proofOfPresence"
    | "productionReadinessCheckDeprecated"
    | "main"
    | "postChecks"
    | "proofOfPresenceTemp"
    | "final";
  @format("uuid") id?: string;

  /** List of check run result updates. */
  resultUpdates?: CheckRunUpdate[];
}

model CheckRunResult {
  modifiedBy?: IdentityRef;
  resultMessage?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "CheckRunStatus",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "running", description: "" },
        #{ value: "approved", description: "" },
        #{ value: "rejected", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "timedOut", description: "" },
        #{ value: "rerunning", description: "" },
        #{ value: "bypassed", description: "" },
        #{ value: "deferred", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?:
    | "none"
    | "queued"
    | "running"
    | "approved"
    | "rejected"
    | "canceled"
    | "timedOut"
    | "rerunning"
    | "bypassed"
    | "deferred"
    | "failed"
    | "completed"
    | "all";
}

model CheckRunUpdate {
  modifiedBy?: IdentityRef;

  /** Time of check run's result modification. */
  modifiedOn?: utcDateTime;

  /** New check run status introduced by result update. */
  @extension(
    "x-ms-enum",
    #{
      name: "CheckRunStatus",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "running", description: "" },
        #{ value: "approved", description: "" },
        #{ value: "rejected", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "timedOut", description: "" },
        #{ value: "rerunning", description: "" },
        #{ value: "bypassed", description: "" },
        #{ value: "deferred", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?:
    | "none"
    | "queued"
    | "running"
    | "approved"
    | "rejected"
    | "canceled"
    | "timedOut"
    | "rerunning"
    | "bypassed"
    | "deferred"
    | "failed"
    | "completed"
    | "all";
}

model CheckSuite {
  ...CheckSuiteRef;
  _links?: ReferenceLinks;

  /** List of check runs associated with the given check suite request. */
  checkRuns?: CheckRun[];

  /** Completed date of the given check suite request */
  completedDate?: utcDateTime;

  /** Optional message for the given check suite request */
  message?: string;

  /** Overall check runs status for the given suite request. This is check suite status */
  @extension(
    "x-ms-enum",
    #{
      name: "CheckRunStatus",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "running", description: "" },
        #{ value: "approved", description: "" },
        #{ value: "rejected", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "timedOut", description: "" },
        #{ value: "rerunning", description: "" },
        #{ value: "bypassed", description: "" },
        #{ value: "deferred", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?:
    | "none"
    | "queued"
    | "running"
    | "approved"
    | "rejected"
    | "canceled"
    | "timedOut"
    | "rerunning"
    | "bypassed"
    | "deferred"
    | "failed"
    | "completed"
    | "all";
}

/** The check run property. */
model CheckSuiteProperty {
  /** The create time of check run property. */
  createdOn?: utcDateTime;

  /** The name of the check run property. */
  name?: string;

  /** The value of the check run property. */
  value?: string;
}

model CheckSuiteRef {
  context?: JObject;

  /** Unique suite id generated by the pipeline orchestrator for the pipeline check runs request on the list of resources Pipeline orchestrator will used this identifier to map the check requests on a stage */
  @format("uuid") id?: string;
}

model CheckSuiteRequest {
  context?: JObject;
  @format("uuid") id?: string;
  resources?: Resource[];
}

model CheckSuiteUpdateParameter {
  /** Action that has to be taken for the specified check. */
  @extension(
    "x-ms-enum",
    #{
      name: "UpdateAction",
      values: #[
        #{ value: "rerun", description: "" },
        #{ value: "bypass", description: "" },
        #{ value: "defer", description: "" }
      ],
    }
  )
  action?: "rerun" | "bypass" | "defer";

  /** Check id of the check run to be updated. */
  @format("uuid") checkId?: string;
}

model CheckType {
  /** Gets or sets check type id. */
  @format("uuid") id?: string;

  /** Name of the check type. */
  name?: string;
}

model GenericCheckConfiguration {
  ...CheckConfiguration;
  settings?: JObject;
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

/** Represents a JSON object. */
model JObject {
  @format("JToken") item?: string;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

model ProofOfPresenceCheckConfig {
  displayName?: string;
  @format("uuid") tenantId?: string;
}

model ProofOfPresenceCheckConfiguration {
  ...CheckConfiguration;
  settings?: ProofOfPresenceCheckConfig;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model Resource {
  /** Id of the resource. */
  id?: string;

  /** Name of the resource. */
  name?: string;

  /** Type of the resource. */
  type?: string;
}

/** A check configuration issue (error, warning) associated with a resource. */
model ResourceCheckIssue {
  checkIssue?: CheckIssue;
  resource?: Resource;
}

/** Config to facilitate task check */
model TaskCheckConfig {
  definitionRef?: TaskCheckDefinitionReference;
  displayName?: string;
  inputs?: Record<string>;
  linkedVariableGroup?: string;
  retryInterval?: int32;
}

model TaskCheckConfiguration {
  ...CheckConfiguration;
  settings?: TaskCheckConfig;
}

model TaskCheckDefinitionReference {
  @format("uuid") id?: string;
  name?: string;
  version?: string;
}

model TimeZone {
  /** Display name of the time zone. */
  displayName?: string;

  /** Id of the time zone. */
  id?: string;
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

/** A collection of `CheckConfiguration` as returned by Azure DevOps. */
model CheckConfigurationList {
  count?: int32;
  value?: CheckConfiguration[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface CheckConfigurations {
  /** Get Check configuration by resource type and id */
  @tag("Check Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "GetCheckConfigurationsOnResource")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/configurations")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** resource type */
    @query(#{ explode: true }) resourceType?: string,

    /** resource id */
    @query(#{ explode: true }) resourceId?: string,

    @extension(
      "x-ms-enum",
      #{
        name: "CheckConfigurationExpandParameter",
        values: #[#{ value: "none", description: "" }, #{ value: "settings", description: "" }],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "settings",
    ...Parameters.`api-Version-preview`.`1`,
  ): CheckConfigurationList;

  /** Add a check configuration */
  @tag("Check Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "AddCheckConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/configurations")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: CheckConfiguration,
  ): CheckConfiguration;

  /** Delete check configuration by id */
  @tag("Check Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "DeleteCheckConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/configurations/{id}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** check configuration id */
    @path id: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get Check configuration by Id */
  @tag("Check Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "GetCheckConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/configurations/{id}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path id: int32,
    @extension(
      "x-ms-enum",
      #{
        name: "CheckConfigurationExpandParameter",
        values: #[#{ value: "none", description: "" }, #{ value: "settings", description: "" }],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "settings",
    ...Parameters.`api-Version-preview`.`1`,
  ): CheckConfiguration;

  /** Update check configuration */
  @tag("Check Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "UpdateCheckConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/configurations/{id}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** check configuration id */
    @path id: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** check configuration */
    @body body: CheckConfiguration,
  ): CheckConfiguration;

  /** Get check configurations for multiple resources by resource type and id. */
  @tag("Check Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "queryconfigurations")
  @extension("x-ms-vss-method", "QueryCheckConfigurationsOnResources")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/queryconfigurations")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The properties that should be expanded in the list of check configurations. */
    @extension(
      "x-ms-enum",
      #{
        name: "CheckConfigurationExpandParameter",
        values: #[#{ value: "none", description: "" }, #{ value: "settings", description: "" }],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "settings",

    ...Parameters.`api-Version-preview`.`1`,

    /** List of resources. */
    @body body: Resource[],
  ): CheckConfigurationList;
}

interface CheckEvaluations {
  /** Initiate an evaluation for a check in a pipeline */
  @tag("Check Evaluations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "EvaluateCheckSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/runs")
  @post
  Evaluate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @extension(
      "x-ms-enum",
      #{
        name: "CheckSuiteExpandParameter",
        values: #[#{ value: "none", description: "" }, #{ value: "resources", description: "" }],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "resources",
    ...Parameters.`api-Version-preview`.`1`,
    @body body: CheckSuiteRequest,
  ): CheckSuite;

  /** Get details for a specific check evaluation */
  @tag("Check Evaluations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "GetCheckSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/runs/{checkSuiteId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @format("uuid") @path checkSuiteId: string,
    @extension(
      "x-ms-enum",
      #{
        name: "CheckSuiteExpandParameter",
        values: #[#{ value: "none", description: "" }, #{ value: "resources", description: "" }],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "resources",
    ...Parameters.`api-Version-preview`.`1`,
  ): CheckSuite;

  /** Update a check run of a check suite Following update actions are supported: * rerun - allows to rerun an already completed check, if the check retry interval is 0 * bypass - applied on a check which has not already been bypassed and whose check suite is not completed yet */
  @tag("Check Evaluations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "UpdateCheckSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/checks/runs/{checkSuiteId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @format("uuid") @path checkSuiteId: string,
    @extension(
      "x-ms-enum",
      #{
        name: "CheckSuiteExpandParameter",
        values: #[#{ value: "none", description: "" }, #{ value: "resources", description: "" }],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "resources",
    ...Parameters.`api-Version-preview`.`1`,
    @body body: CheckSuiteUpdateParameter,
  ): CheckSuite;
}
