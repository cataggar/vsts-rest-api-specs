import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Policy" })
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
namespace Policy;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
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

/** The full policy configuration with settings. */
model PolicyConfiguration {
  ...VersionedPolicyConfigurationRef;
  _links?: ReferenceLinks;
  createdBy?: IdentityRef;

  /** The date and time when the policy was created. */
  createdDate?: utcDateTime;

  /** Indicates whether the policy is blocking. */
  isBlocking?: boolean;

  /** Indicates whether the policy has been (soft) deleted. */
  isDeleted?: boolean;

  /** Indicates whether the policy is enabled. */
  isEnabled?: boolean;

  /** If set, this policy requires 'Manage Enterprise Policies' permission to create, edit, or delete. */
  isEnterpriseManaged?: boolean;

  settings?: JObject;
}

/** Policy configuration reference. */
model PolicyConfigurationRef {
  /** The policy configuration ID. */
  id?: int32;

  type?: PolicyTypeRef;

  /** The URL where the policy configuration can be retrieved. */
  url?: string;
}

/** This record encapsulates the current state of a policy as it applies to one specific pull request. Each pull request has a unique PolicyEvaluationRecord for each pull request which the policy applies to. */
model PolicyEvaluationRecord {
  _links?: ReferenceLinks;

  /** A string which uniquely identifies the target of a policy evaluation. */
  artifactId?: string;

  /** Time when this policy finished evaluating on this pull request. */
  completedDate?: utcDateTime;

  configuration?: PolicyConfiguration;
  context?: JObject;

  /** Guid which uniquely identifies this evaluation record (one policy running on one pull request). */
  @format("uuid") evaluationId?: string;

  /** Time when this policy was first evaluated on this pull request. */
  startedDate?: utcDateTime;

  /** Status of the policy (Running, Approved, Failed, etc.) */
  @extension(
    "x-ms-enum",
    #{
      name: "PolicyEvaluationStatus",
      values: #[
        #{
          value: "queued",
          description: "The policy is either queued to run, or is waiting for some event before progressing.",
        },
        #{ value: "running", description: "The policy is currently running." },
        #{
          value: "approved",
          description: "The policy has been fulfilled for this pull request.",
        },
        #{ value: "rejected", description: "The policy has rejected this pull request." },
        #{
          value: "notApplicable",
          description: "The policy does not apply to this pull request.",
        },
        #{ value: "broken", description: "The policy has encountered an unexpected error." }
      ],
    }
  )
  status?: "queued" | "running" | "approved" | "rejected" | "notApplicable" | "broken" | string;
}

/** User-friendly policy type with description (used for querying policy types). */
model PolicyType {
  ...PolicyTypeRef;
  _links?: ReferenceLinks;

  /** Detailed description of the policy type. */
  description?: string;
}

/** Policy type reference. */
model PolicyTypeRef {
  /** Display name of the policy type. */
  displayName?: string;

  /** The policy type ID. */
  @format("uuid") id?: string;

  /** The URL where the policy type can be retrieved. */
  url?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** A particular revision for a policy configuration. */
model VersionedPolicyConfigurationRef {
  ...PolicyConfigurationRef;

  /** The policy configuration revision ID. */
  revision?: int32;
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

/** A collection of `PolicyConfiguration` as returned by Azure DevOps. */
model PolicyConfigurationList {
  count?: int32;
  value?: PolicyConfiguration[];
}

/** A collection of `PolicyEvaluationRecord` as returned by Azure DevOps. */
model PolicyEvaluationRecordList {
  count?: int32;
  value?: PolicyEvaluationRecord[];
}

/** A collection of `PolicyType` as returned by Azure DevOps. */
model PolicyTypeList {
  count?: int32;
  value?: PolicyType[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Configurations {
  /** Get a list of policy configurations in a project. The 'scope' parameter for this API should not be used, except for legacy compatability reasons. It returns specifically scoped policies and does not support heirarchical nesting. Instead, use the /_apis/git/policy/configurations API, which provides first class scope filtering support. The optional `policyType` parameter can be used to filter the set of policies returned from this method. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "GetPolicyConfigurations")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** [Provided for legacy reasons] The scope on which a subset of policies is defined. */
    @query(#{ explode: true }) scope?: string,

    /** Maximum number of policies to return. */
    @query(#{ explode: true }) $top?: int32,

    /** The continuation token used for pagination. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Filter returned policies to only this type */
    @format("uuid") @query(#{ explode: true }) policyType?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: PolicyConfigurationList;
  };

  /** Create a policy configuration of a given policy type. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "CreatePolicyConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The policy configuration to create. */
    @body body: PolicyConfiguration,
  ): PolicyConfiguration;

  /** Delete a policy configuration by its ID. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "DeletePolicyConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations/{configurationId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the policy configuration to delete. */
    @path configurationId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): NoContentResponse;

  /** Get a policy configuration by its ID. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "GetPolicyConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations/{configurationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the policy configuration */
    @path configurationId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyConfiguration;

  /** Update a policy configuration by its ID. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "UpdatePolicyConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations/{configurationId}")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the existing policy configuration to be updated. */
    @path configurationId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** The policy configuration to update. */
    @body body: PolicyConfiguration,
  ): PolicyConfiguration;
}

interface Revisions {
  /** Retrieve all revisions for a given policy. */
  @tag("Revisions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "revisions")
  @extension("x-ms-vss-method", "GetPolicyConfigurationRevisions")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations/{configurationId}/revisions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The policy configuration ID. */
    @path configurationId: int32,

    /** The number of revisions to retrieve. */
    @query(#{ explode: true }) $top?: int32,

    /** The number of revisions to ignore. For example, to retrieve results 101-150, set top to 50 and skip to 100. */
    @query(#{ explode: true }) $skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyConfigurationList;

  /** Retrieve a specific revision of a given policy by ID. */
  @tag("Revisions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "revisions")
  @extension("x-ms-vss-method", "GetPolicyConfigurationRevision")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/configurations/{configurationId}/revisions/{revisionId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The policy configuration ID. */
    @path configurationId: int32,

    /** The revision ID. */
    @path revisionId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyConfiguration;
}

interface Evaluations {
  /** Retrieves a list of all the policy evaluation statuses for a specific pull request. Evaluations are retrieved using an artifact ID which uniquely identifies the pull request. To generate an artifact ID for a pull request, use this template: ``` vstfs:///CodeReview/CodeReviewId/{projectId}/{pullRequestId} ``` */
  @tag("Evaluations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "evaluations")
  @extension("x-ms-vss-method", "GetPolicyEvaluations")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/evaluations")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** A string which uniquely identifies the target of a policy evaluation. */
    @query(#{ explode: true }) artifactId: string,

    /** Some policies might determine that they do not apply to a specific pull request. Setting this parameter to true will return evaluation records even for policies which don't apply to this pull request. */
    @query(#{ explode: true }) includeNotApplicable?: boolean,

    /** The number of policy evaluation records to retrieve. */
    @query(#{ explode: true }) $top?: int32,

    /** The number of policy evaluation records to ignore. For example, to retrieve results 101-150, set top to 50 and skip to 100. */
    @query(#{ explode: true }) $skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyEvaluationRecordList;

  /** Gets the present evaluation state of a policy. Each policy which applies to a pull request will have an evaluation state which is specific to that policy running in the context of that pull request. Each evaluation is uniquely identified via a Guid. You can find all the policy evaluations for a specific pull request using the List operation of this controller. */
  @tag("Evaluations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "evaluations")
  @extension("x-ms-vss-method", "GetPolicyEvaluation")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/evaluations/{evaluationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the policy evaluation to be retrieved. */
    @format("uuid") @path evaluationId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyEvaluationRecord;

  /** Requeue the policy evaluation. Some policies define a 'requeue' action which performs some policy-specific operation. You can trigger this operation by updating an existing policy evaluation and setting the PolicyEvaluationRecord.Status field to Queued. Although any policy evaluation can be requeued, at present only build policies perform any action in response. Requeueing a build policy will queue a new build to run (cancelling any existing build which is running). */
  @tag("Evaluations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "evaluations")
  @extension("x-ms-vss-method", "RequeuePolicyEvaluation")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/evaluations/{evaluationId}")
  @patch
  RequeuePolicyEvaluation(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the policy evaluation to be retrieved. */
    @format("uuid") @path evaluationId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyEvaluationRecord;
}

interface Types {
  /** Retrieve all available policy types. */
  @tag("Types")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "types")
  @extension("x-ms-vss-method", "GetPolicyTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/types")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyTypeList;

  /** Retrieve a specific policy type by ID. */
  @tag("Types")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "types")
  @extension("x-ms-vss-method", "GetPolicyType")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/policy/types/{typeId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The policy ID. */
    @format("uuid") @path typeId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PolicyType;
}
