import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Approval" })
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
namespace Approval;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model Approval {
  _links?: ReferenceLinks;

  /** Identities which are not allowed to approve. */
  blockedApprovers?: IdentityRef[];

  /** Date on which approval got created. */
  createdOn?: utcDateTime;

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

  /** Unique identifier of the approval. */
  @format("uuid") id?: string;

  /** Instructions for the approvers. */
  instructions?: string;

  /** Date on which approval was last modified. */
  lastModifiedOn?: utcDateTime;

  /** Minimum number of approvers that should approve for the entire approval to be considered approved. */
  minRequiredApprovers?: int32;

  /** Current user permissions for approval object. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalPermissions",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "view", description: "" },
        #{ value: "update", description: "" },
        #{ value: "reassign", description: "" },
        #{ value: "resourceAdmin", description: "" },
        #{ value: "queueBuild", description: "" }
      ],
    }
  )
  permissions?: "none" | "view" | "update" | "reassign" | "resourceAdmin" | "queueBuild";

  pipeline?: JObject;

  /** Overall status of the approval. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalStatus",
      values: #[
        #{ value: "undefined", description: "" },
        #{
          value: "uninitiated",
          description: "Indicates the approval is Uninitiated. Used in case of in sequence order of execution where given approver is not yet actionable.",
        },
        #{ value: "pending", description: "Indicates the approval is Pending." },
        #{ value: "approved", description: "Indicates the approval is Approved." },
        #{ value: "rejected", description: "Indicates the approval is Rejected." },
        #{ value: "skipped", description: "Indicates the approval is Skipped." },
        #{ value: "canceled", description: "Indicates the approval is Canceled." },
        #{ value: "timedOut", description: "Indicates the approval is Timed out." },
        #{ value: "deferred", description: "Indicates the approval is Deferred." },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?:
    | "undefined"
    | "uninitiated"
    | "pending"
    | "approved"
    | "rejected"
    | "skipped"
    | "canceled"
    | "timedOut"
    | "deferred"
    | "failed"
    | "completed"
    | "all";

  /** List of steps associated with the approval. */
  steps?: ApprovalStep[];
}

model ApprovalCheckDefinitionReference {
  @format("uuid") id?: string;
}

model ApprovalCompletedNotificationEvent {
  ...ApprovalNotificationEventBase;
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

/** Data for notification base class for approval events. */
model ApprovalNotificationEventBase {
  approval?: Approval;
  @format("uuid") projectId?: string;
}

/** Request to create a new approval. */
model ApprovalRequest {
  /** Unique identifier with which the approval is to be registered. */
  @format("uuid") approvalId?: string;

  config?: ApprovalConfig;
}

model ApprovalsQueryParameters {
  /** Query approvals based on list of approval IDs. */
  approvalIds?: string[];

  /** Query approvals based on approval status */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalStatus",
      values: #[
        #{ value: "undefined", description: "" },
        #{
          value: "uninitiated",
          description: "Indicates the approval is Uninitiated. Used in case of in sequence order of execution where given approver is not yet actionable.",
        },
        #{ value: "pending", description: "Indicates the approval is Pending." },
        #{ value: "approved", description: "Indicates the approval is Approved." },
        #{ value: "rejected", description: "Indicates the approval is Rejected." },
        #{ value: "skipped", description: "Indicates the approval is Skipped." },
        #{ value: "canceled", description: "Indicates the approval is Canceled." },
        #{ value: "timedOut", description: "Indicates the approval is Timed out." },
        #{ value: "deferred", description: "Indicates the approval is Deferred." },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  approverStatus?:
    | "undefined"
    | "uninitiated"
    | "pending"
    | "approved"
    | "rejected"
    | "skipped"
    | "canceled"
    | "timedOut"
    | "deferred"
    | "failed"
    | "completed"
    | "all";

  /** Query approvals based on list of IDs approvals assigned to */
  assignedTo?: string[];

  /** Query approvals based on how many approvals to return. */
  top?: int32;

  /** Query approvals based on list of approver IDs. */
  userIds?: string[];
}

/** Data for a single approval step. */
model ApprovalStep {
  actualApprover?: IdentityRef;
  assignedApprover?: IdentityRef;

  /** Comment associated with this step. */
  comment?: string;

  /** Date to which approval got deferred. */
  deferredTo?: utcDateTime;

  /** History of the approval step */
  history?: ApprovalStepHistory[];

  /** Timestamp at which this step was initiated. */
  initiatedOn?: utcDateTime;

  lastModifiedBy?: IdentityRef;

  /** Timestamp at which this step was last modified. */
  lastModifiedOn?: utcDateTime;

  /** Order in which the approvers are allowed to approve. */
  order?: int32;

  /** Current user permissions for step. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalPermissions",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "view", description: "" },
        #{ value: "update", description: "" },
        #{ value: "reassign", description: "" },
        #{ value: "resourceAdmin", description: "" },
        #{ value: "queueBuild", description: "" }
      ],
    }
  )
  permissions?: "none" | "view" | "update" | "reassign" | "resourceAdmin" | "queueBuild";

  /** Current status of this step. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalStatus",
      values: #[
        #{ value: "undefined", description: "" },
        #{
          value: "uninitiated",
          description: "Indicates the approval is Uninitiated. Used in case of in sequence order of execution where given approver is not yet actionable.",
        },
        #{ value: "pending", description: "Indicates the approval is Pending." },
        #{ value: "approved", description: "Indicates the approval is Approved." },
        #{ value: "rejected", description: "Indicates the approval is Rejected." },
        #{ value: "skipped", description: "Indicates the approval is Skipped." },
        #{ value: "canceled", description: "Indicates the approval is Canceled." },
        #{ value: "timedOut", description: "Indicates the approval is Timed out." },
        #{ value: "deferred", description: "Indicates the approval is Deferred." },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?:
    | "undefined"
    | "uninitiated"
    | "pending"
    | "approved"
    | "rejected"
    | "skipped"
    | "canceled"
    | "timedOut"
    | "deferred"
    | "failed"
    | "completed"
    | "all";
}

/** Data for a single approval step history. */
model ApprovalStepHistory {
  assignedTo?: IdentityRef;

  /** Comment associated with this step history. */
  comment?: string;

  createdBy?: IdentityRef;

  /** Timestamp at which this step history was created. */
  createdOn?: utcDateTime;
}

/** Data to update an approval object or its individual step. */
model ApprovalUpdateParameters {
  /** ID of the approval to be updated. */
  @format("uuid") approvalId?: string;

  assignedApprover?: IdentityRef;

  /** Gets or sets comment. */
  comment?: string;

  /** Date (UTC) to which approval got deferred. */
  deferredTo?: utcDateTime;

  reassignTo?: IdentityRef;

  /** Gets or sets status. */
  @extension(
    "x-ms-enum",
    #{
      name: "ApprovalStatus",
      values: #[
        #{ value: "undefined", description: "" },
        #{
          value: "uninitiated",
          description: "Indicates the approval is Uninitiated. Used in case of in sequence order of execution where given approver is not yet actionable.",
        },
        #{ value: "pending", description: "Indicates the approval is Pending." },
        #{ value: "approved", description: "Indicates the approval is Approved." },
        #{ value: "rejected", description: "Indicates the approval is Rejected." },
        #{ value: "skipped", description: "Indicates the approval is Skipped." },
        #{ value: "canceled", description: "Indicates the approval is Canceled." },
        #{ value: "timedOut", description: "Indicates the approval is Timed out." },
        #{ value: "deferred", description: "Indicates the approval is Deferred." },
        #{ value: "failed", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  status?:
    | "undefined"
    | "uninitiated"
    | "pending"
    | "approved"
    | "rejected"
    | "skipped"
    | "canceled"
    | "timedOut"
    | "deferred"
    | "failed"
    | "completed"
    | "all";
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

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
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

/** A collection of `Approval` as returned by Azure DevOps. */
model ApprovalList {
  count?: int32;
  value?: Approval[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Approvals {
  /** List Approvals. This can be used to get a set of pending approvals in a pipeline, on an user or for a resource.. */
  @tag("Approvals")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "approvals")
  @extension("x-ms-vss-method", "QueryApprovals")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/approvals")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** List of approval Ids to get. */
    @format("array (uuid)") @query(#{ explode: true }) approvalIds?: string,

    /** Include these additional details in the returned objects. */
    @extension(
      "x-ms-enum",
      #{
        name: "ApprovalDetailsExpandParameter",
        values: #[
          #{ value: "none", description: "No additional properties." },
          #{ value: "steps", description: "Include approval steps associated with the approval." },
          #{
            value: "permissions",
            description: "Include current user permissions for approval object.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "steps" | "permissions",

    /** List of user Ids approvals assigned to. Accepts user Ids, user descriptors or user emails. */
    @format("array (string)") @query(#{ explode: true }) assignedTo?: string,

    /** Approval status. Returns approvals of any status if not provided */
    @extension(
      "x-ms-enum",
      #{
        name: "ApprovalStatus",
        values: #[
          #{ value: "undefined", description: "" },
          #{
            value: "uninitiated",
            description: "Indicates the approval is Uninitiated. Used in case of in sequence order of execution where given approver is not yet actionable.",
          },
          #{ value: "pending", description: "Indicates the approval is Pending." },
          #{ value: "approved", description: "Indicates the approval is Approved." },
          #{ value: "rejected", description: "Indicates the approval is Rejected." },
          #{ value: "skipped", description: "Indicates the approval is Skipped." },
          #{ value: "canceled", description: "Indicates the approval is Canceled." },
          #{ value: "timedOut", description: "Indicates the approval is Timed out." },
          #{ value: "deferred", description: "Indicates the approval is Deferred." },
          #{ value: "failed", description: "" },
          #{ value: "completed", description: "" },
          #{ value: "all", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    state?:
      | "undefined"
      | "uninitiated"
      | "pending"
      | "approved"
      | "rejected"
      | "skipped"
      | "canceled"
      | "timedOut"
      | "deferred"
      | "failed"
      | "completed"
      | "all",

    /** Maximum number of approvals to get. */
    @query(#{ explode: true }) top?: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): ApprovalList;

  /** Update approvals. */
  @tag("Approvals")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "approvals")
  @extension("x-ms-vss-method", "UpdateApprovals")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/approvals")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: ApprovalUpdateParameters[],
  ): ApprovalList;

  /** Get an approval. */
  @tag("Approvals")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "approvals")
  @extension("x-ms-vss-method", "GetApproval")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/pipelines/approvals/{approvalId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the approval. */
    @format("uuid") @path approvalId: string,

    @extension(
      "x-ms-enum",
      #{
        name: "ApprovalDetailsExpandParameter",
        values: #[
          #{ value: "none", description: "No additional properties." },
          #{ value: "steps", description: "Include approval steps associated with the approval." },
          #{
            value: "permissions",
            description: "Include current user permissions for approval object.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    $expand?: "none" | "steps" | "permissions",
    ...Parameters.`api-Version-preview`.`2`,
  ): Approval;
}
