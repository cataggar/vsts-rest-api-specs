import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "MemberEntitlementManagement" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://vsaex.dev.azure.com")
namespace MemberEntitlementManagement;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AadGraphMember {
  ...GraphMember;

  /** The short, generally unique name for the user in the backing directory. For AAD users, this corresponds to the mail nickname, which is often but not necessarily similar to the part of the user's mail address before the \@ sign. For GitHub users, this corresponds to the GitHub user handle. */
  directoryAlias?: string;

  /** When true, the group has been deleted in the identity provider */
  isDeletedInOrigin?: boolean;

  /** The meta type of the user in the origin, such as 'member', 'guest', etc. See UserMetaType for the set of possible values. */
  metaType?: string;
}

/** License assigned to a user */
model AccessLevel {
  /** Type of Account License (e.g. Express, Stakeholder etc.). To use the AccountLicenseType, LicensingSource should be defined as 'account' in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "AccountLicenseType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "earlyAdopter", description: "" },
        #{ value: "express", description: "" },
        #{ value: "professional", description: "" },
        #{ value: "advanced", description: "" },
        #{ value: "stakeholder", description: "" }
      ],
    }
  )
  accountLicenseType?:
    | "none"
    | "earlyAdopter"
    | "express"
    | "professional"
    | "advanced"
    | "stakeholder"
    | string;

  /** Assignment Source of the License (e.g. Group, Unknown etc. */
  @extension(
    "x-ms-enum",
    #{
      name: "AssignmentSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "unknown", description: "" },
        #{ value: "groupRule", description: "" }
      ],
    }
  )
  assignmentSource?: "none" | "unknown" | "groupRule" | string;

  /** Type of GitHub License (only Enterprise for now). To use the GitHubLicenseType, LicensingSource should be defined as 'github' in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitHubLicenseType",
      values: #[#{ value: "none", description: "" }, #{ value: "enterprise", description: "" }],
    }
  )
  gitHubLicenseType?: "none" | "enterprise" | string;

  /** Display name of the License */
  licenseDisplayName?: string;

  /** Licensing Source (e.g. Account. MSDN etc.) */
  @extension(
    "x-ms-enum",
    #{
      name: "LicensingSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "account", description: "" },
        #{ value: "msdn", description: "" },
        #{ value: "profile", description: "" },
        #{ value: "auto", description: "" },
        #{ value: "trial", description: "" },
        #{ value: "gitHub", description: "" }
      ],
    }
  )
  licensingSource?: "none" | "account" | "msdn" | "profile" | "auto" | "trial" | "gitHub" | string;

  /** Type of MSDN License (e.g. Visual Studio Professional, Visual Studio Enterprise etc.). To use the MsdnLicenseType, LicensingSource should be defined as 'msdn' in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "MsdnLicenseType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "eligible", description: "" },
        #{ value: "professional", description: "" },
        #{ value: "platforms", description: "" },
        #{ value: "testProfessional", description: "" },
        #{ value: "premium", description: "" },
        #{ value: "ultimate", description: "" },
        #{ value: "enterprise", description: "" }
      ],
    }
  )
  msdnLicenseType?:
    | "none"
    | "eligible"
    | "professional"
    | "platforms"
    | "testProfessional"
    | "premium"
    | "ultimate"
    | "enterprise"
    | string;

  /** User status in the account */
  @extension(
    "x-ms-enum",
    #{
      name: "AccountUserStatus",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "active", description: "User has signed in at least once to the VSTS account" },
        #{
          value: "disabled",
          description: "User cannot sign in; primarily used by admin to temporarily remove a user due to absence or license reallocation",
        },
        #{
          value: "deleted",
          description: "User is removed from the VSTS account by the VSTS account admin",
        },
        #{
          value: "pending",
          description: "User is invited to join the VSTS account by the VSTS account admin, but has not signed up/signed in yet",
        },
        #{
          value: "expired",
          description: "User can sign in; primarily used when license is in expired state and we give a grace period",
        },
        #{
          value: "pendingDisabled",
          description: "User is disabled; if reenabled, they will still be in the Pending state",
        }
      ],
    }
  )
  status?:
    | "none"
    | "active"
    | "disabled"
    | "deleted"
    | "pending"
    | "expired"
    | "pendingDisabled"
    | string;

  /** Status message. */
  statusMessage?: string;
}

model BaseOperationResult {
  /** List of error codes paired with their corresponding error messages */
  errors?: {}[];

  /** Success status of the operation */
  isSuccess?: boolean;
}

model EntitlementBase {
  accessLevel?: AccessLevel;

  /** [Readonly] Date the member was added to the collection. */
  dateCreated?: utcDateTime;

  /** [Readonly] GroupEntitlements that this member belongs to. */
  groupAssignments?: GroupEntitlement[];

  /** The unique identifier which matches the Id of the Identity associated with the GraphMember. */
  @format("uuid") id?: string;

  /** [Readonly] Date the member last accessed the collection. */
  lastAccessedDate?: utcDateTime;

  /** Relation between a project and the member's effective permissions in that project. */
  projectEntitlements?: ProjectEntitlement[];
}

model EntitlementOperationResultBase {
  /** List of error codes paired with their corresponding error messages. */
  errors?: {}[];

  /** Success status of the operation. */
  isSuccess?: boolean;

  /** Resulting entitlement property. For specific implementations, see also: <seealso cref='T:Microsoft.VisualStudio.Services.MemberEntitlementManagement.WebApi.ServicePrincipalEntitlementOperationResult' /><seealso cref='T:Microsoft.VisualStudio.Services.MemberEntitlementManagement.WebApi.UserEntitlementOperationResult' /> */
  @format("T") result?: string;
}

/** An extension assigned to a user */
model Extension {
  /** Assignment source for this extension. I.e. explicitly assigned or from a group rule. */
  @extension(
    "x-ms-enum",
    #{
      name: "AssignmentSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "unknown", description: "" },
        #{ value: "groupRule", description: "" }
      ],
    }
  )
  assignmentSource?: "none" | "unknown" | "groupRule" | string;

  /** Gallery Id of the Extension. */
  id?: string;

  /** Friendly name of this extension. */
  name?: string;

  /** Source of this extension assignment. Ex: msdn, account, none, etc. */
  @extension(
    "x-ms-enum",
    #{
      name: "LicensingSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "account", description: "" },
        #{ value: "msdn", description: "" },
        #{ value: "profile", description: "" },
        #{ value: "auto", description: "" },
        #{ value: "trial", description: "" },
        #{ value: "gitHub", description: "" }
      ],
    }
  )
  source?: "none" | "account" | "msdn" | "profile" | "auto" | "trial" | "gitHub" | string;
}

/** Summary of Extensions in the organization. */
model ExtensionSummaryData {
  ...SummaryData;

  /** Count of Extension Licenses assigned to users through msdn. */
  assignedThroughSubscription?: int32;

  /** Gallery Id of the Extension */
  extensionId?: string;

  /** Friendly name of this extension */
  extensionName?: string;

  /** Whether its a Trial Version. */
  isTrialVersion?: boolean;

  /** Minimum License Required for the Extension. */
  @extension(
    "x-ms-enum",
    #{
      name: "MinimumRequiredServiceLevel",
      values: #[
        #{ value: "none", description: "No service rights. The user cannot access the account" },
        #{ value: "express", description: "Default or minimum service level" },
        #{
          value: "advanced",
          description: "Premium service level - either by purchasing on the Azure portal or by purchasing the appropriate MSDN subscription",
        },
        #{
          value: "advancedPlus",
          description: "Only available to a specific set of MSDN Subscribers",
        },
        #{ value: "stakeholder", description: "Stakeholder service level" }
      ],
    }
  )
  minimumLicenseRequired?:
    | "none"
    | "express"
    | "advanced"
    | "advancedPlus"
    | "stakeholder"
    | string;

  /** Days remaining for the Trial to expire. */
  remainingTrialDays?: int32;

  /** Date on which the Trial expires. */
  trialExpiryDate?: utcDateTime;
}

/** Graph group entity */
model GraphGroup {
  ...GraphMember;

  /** A short phrase to help human readers disambiguate groups with similar names */
  description?: string;
}

model GraphMember {
  ...GraphSubject;

  /** This represents the name of the container of origin for a graph member. (For MSA this is 'Windows Live ID', for AD the name of the domain, for AAD the tenantID of the directory, for VSTS groups the ScopeId, etc) */
  domain?: string;

  /** The email address of record for a given graph member. This may be different than the principal name. */
  mailAddress?: string;

  /** This is the PrincipalName of this graph member from the source provider. The source provider may change this field over time and it is not guaranteed to be immutable for the life of the graph member by VSTS. */
  principalName?: string;
}

model GraphServicePrincipal {
  ...AadGraphMember;
  applicationId?: string;
}

/** Top-level graph entity */
model GraphSubject {
  ...GraphSubjectBase;

  /** [Internal Use Only] The legacy descriptor is here in case you need to access old version IMS using identity descriptor. */
  legacyDescriptor?: string;

  /** The type of source provider for the origin identifier (ex:AD, AAD, MSA) */
  origin?: string;

  /** The unique identifier from the system of origin. Typically a sid, object id or Guid. Linking and unlinking operations can cause this value to change for a user because the user is not backed by a different provider and has a different unique id in the new provider. */
  originId?: string;

  /** This field identifies the type of the graph subject (ex: Group, Scope, User). */
  subjectKind?: string;
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

model GraphUser {
  ...AadGraphMember;
}

/** Project Group (e.g. Contributor, Reader etc.) */
model Group {
  /** Display Name of the Group */
  displayName?: string;

  /** Group Type */
  @extension(
    "x-ms-enum",
    #{
      name: "GroupType",
      values: #[
        #{ value: "projectStakeholder", description: "" },
        #{ value: "projectReader", description: "" },
        #{ value: "projectContributor", description: "" },
        #{ value: "projectAdministrator", description: "" },
        #{ value: "custom", description: "" }
      ],
    }
  )
  groupType?:
    | "projectStakeholder"
    | "projectReader"
    | "projectContributor"
    | "projectAdministrator"
    | "custom"
    | string;
}

/** A group entity with additional properties including its license, extensions, and project membership */
model GroupEntitlement {
  group?: GraphGroup;

  /** The unique identifier which matches the Id of the GraphMember. */
  @format("uuid") id?: string;

  /** [Readonly] The last time the group licensing rule was executed (regardless of whether any changes were made). */
  lastExecuted?: utcDateTime;

  licenseRule?: AccessLevel;

  /** Group members. Only used when creating a new group. */
  members?: UserEntitlement[];

  /** Relation between a project and the member's effective permissions in that project. */
  projectEntitlements?: ProjectEntitlement[];

  /** The status of the group rule. */
  @extension(
    "x-ms-enum",
    #{
      name: "GroupLicensingRuleStatus",
      values: #[
        #{
          value: "applyPending",
          description: "Rule is created or updated, but apply is pending",
        },
        #{ value: "applied", description: "Rule is applied" },
        #{ value: "incompatible", description: "The group rule was incompatible" },
        #{
          value: "unableToApply",
          description: "Rule failed to apply unexpectedly and should be retried",
        }
      ],
    }
  )
  status?: "applyPending" | "applied" | "incompatible" | "unableToApply" | string;
}

model GroupEntitlementOperationReference {
  ...OperationReference;

  /** Operation completed with success or failure. */
  completed?: boolean;

  /** True if all operations were successful. */
  haveResultsSucceeded?: boolean;

  /** List of results for each operation. */
  results?: GroupOperationResult[];
}

model GroupOperationResult {
  ...BaseOperationResult;

  /** Identifier of the Group being acted upon */
  @format("uuid") groupId?: string;

  result?: GroupEntitlement;
}

/** Group option to add a user to */
model GroupOption {
  accessLevel?: AccessLevel;
  group?: Group;
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
  `op`?: "add" | "remove" | "replace" | "move" | "copy" | "test" | string;

  /** The path for the operation. In the case of an array, a zero based index can be used to specify the position in the array (e.g. /biscuits/0/name). The '-' character can be used instead of an index to insert at the end of the array (e.g. /biscuits/-). */
  path?: string;

  /** The value for the operation. This is either a primitive or a JToken. */
  value?: {};
}

/** Summary of Licenses in the organization. */
model LicenseSummaryData {
  ...SummaryData;

  /** Type of Account License. To use the AccountLicenseType, LicensingSource should be defined as 'account' in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "AccountLicenseType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "earlyAdopter", description: "" },
        #{ value: "express", description: "" },
        #{ value: "professional", description: "" },
        #{ value: "advanced", description: "" },
        #{ value: "stakeholder", description: "" }
      ],
    }
  )
  accountLicenseType?:
    | "none"
    | "earlyAdopter"
    | "express"
    | "professional"
    | "advanced"
    | "stakeholder"
    | string;

  /** Count of Disabled Licenses. */
  disabled?: int32;

  /** Type of GitHub License. To use the GitHubLicenseType, LicensingSource should be defined as 'github' in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "GitHubLicenseType",
      values: #[#{ value: "none", description: "" }, #{ value: "enterprise", description: "" }],
    }
  )
  gitHubLicenseType?: "none" | "enterprise" | string;

  /** Designates if this license quantity can be changed through purchase */
  isPurchasable?: boolean;

  /** Name of the License. */
  licenseName?: string;

  /** Count of Expired MSDN Licenses. */
  msdnExpired?: int32;

  /** Type of MSDN License. To use the MsdnLicenseType, LicensingSource should be defined as 'msdn' in the request body. */
  @extension(
    "x-ms-enum",
    #{
      name: "MsdnLicenseType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "eligible", description: "" },
        #{ value: "professional", description: "" },
        #{ value: "platforms", description: "" },
        #{ value: "testProfessional", description: "" },
        #{ value: "premium", description: "" },
        #{ value: "ultimate", description: "" },
        #{ value: "enterprise", description: "" }
      ],
    }
  )
  msdnLicenseType?:
    | "none"
    | "eligible"
    | "professional"
    | "platforms"
    | "testProfessional"
    | "premium"
    | "ultimate"
    | "enterprise"
    | string;

  /** Specifies the date when billing will charge for paid licenses */
  nextBillingDate?: utcDateTime;

  /** Source of the License. */
  @extension(
    "x-ms-enum",
    #{
      name: "LicensingSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "account", description: "" },
        #{ value: "msdn", description: "" },
        #{ value: "profile", description: "" },
        #{ value: "auto", description: "" },
        #{ value: "trial", description: "" },
        #{ value: "gitHub", description: "" }
      ],
    }
  )
  source?: "none" | "account" | "msdn" | "profile" | "auto" | "trial" | "gitHub" | string;

  /** Total license count after next billing cycle */
  totalAfterNextBillingDate?: int32;
}

/** Deprecated: Use UserEntitlement instead */
model MemberEntitlement {
  ...UserEntitlement;
  member?: GraphMember;
}

/** An AAD member entity */
model MemberEntitlement2 {
  ...EntitlementBase;
  member?: AadGraphMember;
}

model MemberEntitlement2OperationReference {
  ...OperationReference;

  /** Operation completed with success or failure. */
  completed?: boolean;

  /** True if all operations were successful. */
  haveResultsSucceeded?: boolean;

  /** List of results for each operation. */
  results?: MemberEntitlement2OperationResult[];
}

model MemberEntitlement2OperationResult {
  ...EntitlementOperationResultBase;

  /** Identifier of the Member being acted upon. */
  @format("uuid") memberId?: string;
}

model MemberEntitlement2PatchResponse {
  ...MemberEntitlement2ResponseBase;

  /** List of results for each operation */
  operationResults?: MemberEntitlement2OperationResult[];
}

model MemberEntitlement2PostResponse {
  ...MemberEntitlement2ResponseBase;
  operationResult?: MemberEntitlement2OperationResult;
}

model MemberEntitlement2ResponseBase {
  /** True if all operations were successful. */
  isSuccess?: boolean;

  memberEntitlement?: MemberEntitlement2;
}

/** Obsolete: Please use UserEntitlementOperationReference instead */
model MemberEntitlementOperationReference {
  ...OperationReference;

  /** Operation completed with success or failure */
  completed?: boolean;

  /** True if all operations were successful */
  haveResultsSucceeded?: boolean;

  /** List of results for each operation */
  results?: OperationResult[];
}

/** Obsolete: Please use UserEntitlementsPatchResponse instead */
model MemberEntitlementsPatchResponse {
  ...MemberEntitlementsResponseBase;

  /** List of results for each operation */
  operationResults?: OperationResult[];
}

/** Obsolete: Please use UserEntitlementsPostResponse instead */
model MemberEntitlementsPostResponse {
  ...MemberEntitlementsResponseBase;
  operationResult?: OperationResult;
}

/** Obsolete: Please use UserEntitlementsResponseBase instead */
model MemberEntitlementsResponseBase {
  /** True if all operations were successful. */
  isSuccess?: boolean;

  memberEntitlement?: MemberEntitlement;
}

/** Reference for an async operation. */
model OperationReference {
  /** Unique identifier for the operation. */
  @format("uuid") id?: string;

  /** Unique identifier for the plugin. */
  @format("uuid") pluginId?: string;

  /** The current status of the operation. */
  @extension(
    "x-ms-enum",
    #{
      name: "OperationStatus",
      values: #[
        #{ value: "notSet", description: "The operation does not have a status set." },
        #{ value: "queued", description: "The operation has been queued." },
        #{ value: "inProgress", description: "The operation is in progress." },
        #{ value: "cancelled", description: "The operation was cancelled by the user." },
        #{ value: "succeeded", description: "The operation completed successfully." },
        #{ value: "failed", description: "The operation completed with a failure." }
      ],
    }
  )
  status?: "notSet" | "queued" | "inProgress" | "cancelled" | "succeeded" | "failed" | string;

  /** URL to get the full operation object. */
  url?: string;
}

/** Obsolete: Please use UserEntitlementOperationResult instead */
model OperationResult {
  /** List of error codes paired with their corresponding error messages. */
  errors?: {}[];

  /** Success status of the operation. */
  isSuccess?: boolean;

  /** Identifier of the Member being acted upon. */
  @format("uuid") memberId?: string;

  result?: MemberEntitlement;
}

/** A page of users */
model PagedGraphMemberList {
  continuationToken?: string;
  items?: UserEntitlement[];
  members?: UserEntitlement[];
  totalCount?: int32;
}

/** A page of user entitlements */
model PagedUserEntitlementsList {
  /** The continuation token for next page of data. Can be null, if no more data exists. */
  continuationToken?: string;

  /** The requested user entitlement items. */
  items?: UserEntitlement[];

  /** The total count of the existing user entitlement items. */
  totalCount?: int32;
}

/** Relation between a project and the user's effective permissions in that project. */
model ProjectEntitlement {
  /** Assignment Source (e.g. Group or Unknown). */
  @extension(
    "x-ms-enum",
    #{
      name: "AssignmentSource",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "unknown", description: "" },
        #{ value: "groupRule", description: "" }
      ],
    }
  )
  assignmentSource?: "none" | "unknown" | "groupRule" | string;

  group?: Group;

  /** Whether the user is inheriting permissions to a project through a Azure DevOps or AAD group membership. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectPermissionInherited",
      values: #[
        #{ value: "notSet", description: "" },
        #{ value: "notInherited", description: "" },
        #{ value: "inherited", description: "" }
      ],
    }
  )
  projectPermissionInherited?: "notSet" | "notInherited" | "inherited" | string;

  projectRef?: ProjectRef;

  /** Team Ref. */
  teamRefs?: TeamRef[];
}

/** A reference to a project */
model ProjectRef {
  /** Project ID. */
  @format("uuid") id?: string;

  /** Project Name. */
  name?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model ServicePrincipalEntitlement {
  ...EntitlementBase;
  servicePrincipal?: GraphServicePrincipal;
}

model ServicePrincipalEntitlementOperationReference {
  ...OperationReference;

  /** Operation completed with success or failure. */
  completed?: boolean;

  /** True if all operations were successful. */
  haveResultsSucceeded?: boolean;

  /** List of results for each operation. */
  results?: ServicePrincipalEntitlementOperationResult[];
}

model ServicePrincipalEntitlementOperationResult {
  ...EntitlementOperationResultBase;

  /** Identifier of the ServicePrincipal being acted upon. */
  @format("uuid") servicePrincipalId?: string;
}

model ServicePrincipalEntitlementsPatchResponse {
  ...ServicePrincipalEntitlementsResponseBase;
  operationResults?: ServicePrincipalEntitlementOperationResult[];
}

model ServicePrincipalEntitlementsPostResponse {
  ...ServicePrincipalEntitlementsResponseBase;
  operationResult?: ServicePrincipalEntitlementOperationResult;
}

model ServicePrincipalEntitlementsResponseBase {
  isSuccess?: boolean;
  servicePrincipalEntitlement?: ServicePrincipalEntitlement;
}

model SummaryData {
  /** Count of Licenses already assigned. */
  assigned?: int32;

  /** Available Count. */
  available?: int32;

  /** Quantity */
  includedQuantity?: int32;

  /** Total Count. */
  total?: int32;
}

/** A reference to a team */
model TeamRef {
  /** Team ID */
  @format("uuid") id?: string;

  /** Team Name */
  name?: string;
}

/** A user entity with additional properties including their license, extensions, and project membership */
model UserEntitlement {
  ...EntitlementBase;
  user?: GraphUser;
}

model UserEntitlementOperationReference {
  ...OperationReference;

  /** Operation completed with success or failure. */
  completed?: boolean;

  /** True if all operations were successful. */
  haveResultsSucceeded?: boolean;

  /** List of results for each operation. */
  results?: UserEntitlementOperationResult[];
}

model UserEntitlementOperationResult {
  ...EntitlementOperationResultBase;

  /** Identifier of the Member being acted upon. */
  @format("uuid") userId?: string;
}

model UserEntitlementsPatchResponse {
  ...UserEntitlementsResponseBase;

  /** List of results for each operation. */
  operationResults?: UserEntitlementOperationResult[];
}

model UserEntitlementsPostResponse {
  ...UserEntitlementsResponseBase;
  operationResult?: UserEntitlementOperationResult;
}

model UserEntitlementsResponseBase {
  /** True if all operations were successful. */
  isSuccess?: boolean;

  userEntitlement?: UserEntitlement;
}

/** Summary of licenses and extensions assigned to users in the organization */
model UsersSummary {
  /** Available Access Levels */
  availableAccessLevels?: AccessLevel[];

  defaultAccessLevel?: AccessLevel;

  /** Group Options */
  groupOptions?: GroupOption[];

  /** Summary of Licenses in the organization */
  licenses?: LicenseSummaryData[];

  /** Summary of Projects in the organization */
  projectRefs?: ProjectRef[];
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

/** A collection of `GroupEntitlement` as returned by Azure DevOps. */
model GroupEntitlementList {
  count?: int32;
  value?: GroupEntitlement[];
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
    model `5` {
      /** Version of the API to use. This should be set to '7.2-preview.5' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface GroupEntitlements {
  /** Get the group entitlements for an account. */
  @tag("Group Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groupEntitlements")
  @extension("x-ms-vss-method", "GetGroupEntitlements")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/groupentitlements")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): GroupEntitlementList;

  /** Create a group entitlement with license rule, extension rule. */
  @tag("Group Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groupEntitlements")
  @extension("x-ms-vss-method", "AddGroupEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/groupentitlements")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** RuleOption [ApplyGroupRule/TestApplyGroupRule] - specifies if the rules defined in group entitlement should be created and applied to it’s members (default option) or just be tested */
    @extension(
      "x-ms-enum",
      #{
        name: "RuleOption",
        values: #[
          #{ value: "applyGroupRule", description: "" },
          #{ value: "testApplyGroupRule", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    ruleOption?: "applyGroupRule" | "testApplyGroupRule",

    ...Parameters.`api-Version-preview`.`1`,

    /** GroupEntitlement object specifying License Rule, Extensions Rule for the group. Based on the rules the members of the group will be given licenses and extensions. The Group Entitlement can be used to add the group to another project level groups */
    @body body: GroupEntitlement,
  ): CreatedResponse & GroupEntitlementOperationReference;

  /** Delete a group entitlement. */
  @tag("Group Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groupEntitlements")
  @extension("x-ms-vss-method", "DeleteGroupEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/groupentitlements/{groupId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the group to delete. */
    @format("uuid") @path groupId: string,

    /** RuleOption [ApplyGroupRule/TestApplyGroupRule] - specifies if the rules defined in group entitlement should be deleted and the changes are applied to it’s members (default option) or just be tested */
    @extension(
      "x-ms-enum",
      #{
        name: "RuleOption",
        values: #[
          #{ value: "applyGroupRule", description: "" },
          #{ value: "testApplyGroupRule", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    ruleOption?: "applyGroupRule" | "testApplyGroupRule",

    /** Optional parameter that specifies whether the group with the given ID should be removed from all other groups */
    @query(#{ explode: true }) removeGroupMembership?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): GroupEntitlementOperationReference;

  /** Get a group entitlement. If the group entitlement does not exist, returns null. */
  @tag("Group Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groupEntitlements")
  @extension("x-ms-vss-method", "GetGroupEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/groupentitlements/{groupId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the group. */
    @format("uuid") @path groupId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): GroupEntitlement;

  /** Update entitlements (License Rule, Extensions Rule, Project memberships etc.) for a group. */
  @tag("Group Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "groupEntitlements")
  @extension("x-ms-vss-method", "UpdateGroupEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/groupentitlements/{groupId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the group. */
    @format("uuid") @path groupId: string,

    /** RuleOption [ApplyGroupRule/TestApplyGroupRule] - specifies if the rules defined in group entitlement should be updated and the changes are applied to it’s members (default option) or just be tested */
    @extension(
      "x-ms-enum",
      #{
        name: "RuleOption",
        values: #[
          #{ value: "applyGroupRule", description: "" },
          #{ value: "testApplyGroupRule", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    ruleOption?: "applyGroupRule" | "testApplyGroupRule",

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/json-patch+json",

    /** JsonPatchDocument containing the operations to perform on the group. */
    @body body: JsonPatchDocument,
  ): GroupEntitlementOperationReference;
}

interface Members {
  /** Get direct members of a Group. */
  @tag("Members")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "members")
  @extension("x-ms-vss-method", "GetGroupMembers")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/GroupEntitlements/{groupId}/members")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of the Group. */
    @format("uuid") @path groupId: string,

    /** Maximum number of results to retrieve. */
    @query(#{ explode: true }) maxResults?: int32,

    /** Paging Token from the previous page fetched. If the 'pagingToken' is null, the results would be fetched from the beginning of the Members List. */
    @query(#{ explode: true }) pagingToken?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): PagedGraphMemberList;

  /** Remove a member from a Group. */
  @tag("Members")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "members")
  @extension("x-ms-vss-method", "RemoveMemberFromGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/GroupEntitlements/{groupId}/members/{memberId}")
  @delete
  RemoveMemberFromGroup(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of the group. */
    @format("uuid") @path groupId: string,

    /** Id of the member to remove. */
    @format("uuid") @path memberId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Add a member to a Group. */
  @tag("Members")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "members")
  @extension("x-ms-vss-method", "AddMemberToGroup")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/GroupEntitlements/{groupId}/members/{memberId}")
  @put
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of the Group. */
    @format("uuid") @path groupId: string,

    /** Id of the member to add. */
    @format("uuid") @path memberId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;
}

interface MemberEntitlements {
  @tag("Member Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "memberEntitlements")
  @extension("x-ms-vss-method", "SearchMemberEntitlements")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/memberentitlements")
  @get
  SearchMemberEntitlements(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @query(#{ explode: true }) continuationToken?: string,
    @extension(
      "x-ms-enum",
      #{
        name: "UserEntitlementProperty",
        values: #[
          #{ value: "license", description: "" },
          #{ value: "extensions", description: "" },
          #{ value: "projects", description: "" },
          #{ value: "groupRules", description: "" },
          #{ value: "all", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    select?: "license" | "extensions" | "projects" | "groupRules" | "all",
    @query(#{ explode: true }) $filter?: string,
    @query(#{ explode: true }) $orderBy?: string,
    ...Parameters.`api-Version-preview`.`3`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: unknown[];
  };
}

interface ServicePrincipalEntitlements {
  /** Edit the entitlements (License, Extensions, Projects, Teams etc) for one or more service principals. */
  @tag("Service Principal Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "servicePrincipalEntitlements")
  @extension("x-ms-vss-method", "UpdateServicePrincipalEntitlements")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/serviceprincipalentitlements")
  @patch
  UpdateServicePrincipalEntitlements(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/json-patch+json",

    /** JsonPatchDocument containing the operations to perform. */
    @body body: JsonPatchDocument,
  ): ServicePrincipalEntitlementOperationReference;

  /** Add a service principal, assign license and extensions and make them a member of a project group in an account. NOTE: If you are working with AAD app registration, you can find service principal of your app in enterprise applications, and make sure to use service principal's object id as originId parameter in the request body */
  @tag("Service Principal Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "servicePrincipalEntitlements")
  @extension("x-ms-vss-method", "AddServicePrincipalEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/serviceprincipalentitlements")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** ServicePrincipalEntitlement object specifying License, Extensions and Project/Team groups the service principal should be added to. */
    @body body: ServicePrincipalEntitlement,
  ): ServicePrincipalEntitlementsPostResponse;

  /** Delete a service principal from the account. The delete operation includes unassigning Extensions and Licenses and removing the service principal from all project memberships. The service principal would continue to have access to the account if it is member of an AAD group, that is added directly to the account. */
  @tag("Service Principal Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "servicePrincipalEntitlements")
  @extension("x-ms-vss-method", "DeleteServicePrincipalEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/serviceprincipalentitlements/{servicePrincipalId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the service principal. */
    @format("uuid") @path servicePrincipalId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get Service principal Entitlement for a service principal. */
  @tag("Service Principal Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "servicePrincipalEntitlements")
  @extension("x-ms-vss-method", "GetServicePrincipalEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/serviceprincipalentitlements/{servicePrincipalId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the service principal. */
    @format("uuid") @path servicePrincipalId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): ServicePrincipalEntitlement;

  /** Edit the entitlements (License, Extensions, Projects, Teams etc) for a service principal. */
  @tag("Service Principal Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "servicePrincipalEntitlements")
  @extension("x-ms-vss-method", "UpdateServicePrincipalEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/serviceprincipalentitlements/{servicePrincipalId}")
  @patch
  UpdateServicePrincipalEntitlement(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the service principal. */
    @format("uuid") @path servicePrincipalId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/json-patch+json",

    /** JsonPatchDocument containing the operations to perform on the service principal. */
    @body body: JsonPatchDocument,
  ): ServicePrincipalEntitlementsPatchResponse;
}

interface UserEntitlements {
  /** Get a paged set of user entitlements matching the filter and sort criteria built with properties that match the select input. */
  @tag("User Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.5")
  @extension("x-ms-vss-resource", "userEntitlements")
  @extension("x-ms-vss-method", "SearchUserEntitlements")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlements")
  @get
  SearchUserEntitlements(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Continuation token for getting the next page of data set. If null is passed, gets the first page. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Comma (',') separated list of properties to select in the result entitlements. names of the properties are - 'Projects, 'Extensions' and 'Grouprules'. */
    @extension(
      "x-ms-enum",
      #{
        name: "UserEntitlementProperty",
        values: #[
          #{ value: "license", description: "" },
          #{ value: "extensions", description: "" },
          #{ value: "projects", description: "" },
          #{ value: "groupRules", description: "" },
          #{ value: "all", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    select?: "license" | "extensions" | "projects" | "groupRules" | "all",

    /** Equality operators relating to searching user entitlements separated by and clauses. Valid filters include: licenseId, licenseStatus, userType, and name. licenseId: filters based on license assignment using license names. i.e. licenseId eq 'Account-Stakeholder' or licenseId eq 'Account-Express'. licenseStatus: filters based on license status. currently only supports disabled. i.e. licenseStatus eq 'Disabled'. To get disabled basic licenses, you would pass (licenseId eq 'Account-Express' and licenseStatus eq 'Disabled'). userType: filters off identity type. Supported types are member or guest i.e. userType eq 'member'. name: filters on if the user's display name or email contains given input. i.e. get all users with 'test' in email or displayname is 'name eq 'test''. A valid query could be: (licenseId eq 'Account-Stakeholder' or (licenseId eq 'Account-Express' and licenseStatus eq 'Disabled')) and name eq 'test' and userType eq 'guest'. */
    @query(#{ explode: true }) $filter?: string,

    /** PropertyName and Order (separated by a space ( )) to sort on (e.g. lastAccessed desc). Order defaults to ascending. valid properties to order by are dateCreated, lastAccessed, and name */
    @query(#{ explode: true }) $orderBy?: string,

    ...Parameters.`api-Version-preview`.`5`,
  ): PagedUserEntitlementsList;

  /** Edit the entitlements (License, Extensions, Projects, Teams etc) for one or more users. MSA Backed organizations may face limitation when using this API. */
  @tag("User Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.5")
  @extension("x-ms-vss-resource", "userEntitlements")
  @extension("x-ms-vss-method", "UpdateUserEntitlements")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlements")
  @patch
  UpdateUserEntitlements(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Whether to send email invites to new users or not */
    @query(#{ explode: true }) doNotSendInviteForNewUsers?: boolean,

    ...Parameters.`api-Version-preview`.`5`,
    @header contentType: "application/json-patch+json",

    /** JsonPatchDocument containing the operations to perform. */
    @body body: JsonPatchDocument,
  ): UserEntitlementOperationReference;

  /** Add a user, assign license and extensions and make them a member of a project group in an account. */
  @tag("User Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.5")
  @extension("x-ms-vss-resource", "userEntitlements")
  @extension("x-ms-vss-method", "AddUserEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlements")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`5`,

    /** UserEntitlement object specifying License, Extensions and Project/Team groups the user should be added to. */
    @body body: UserEntitlement,
  ): UserEntitlementsPostResponse;

  /** Delete a user from the account. The delete operation includes unassigning Extensions and Licenses and removing the user from all project memberships. The user would continue to have access to the account if she is member of an AAD group, that is added directly to the account. */
  @tag("User Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.5")
  @extension("x-ms-vss-resource", "userEntitlements")
  @extension("x-ms-vss-method", "DeleteUserEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlements/{userId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the user. */
    @format("uuid") @path userId: string,

    ...Parameters.`api-Version-preview`.`5`,
  ): OkResponse;

  /** Get User Entitlement for a user. */
  @tag("User Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.5")
  @extension("x-ms-vss-resource", "userEntitlements")
  @extension("x-ms-vss-method", "GetUserEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlements/{userId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the user. */
    @format("uuid") @path userId: string,

    ...Parameters.`api-Version-preview`.`5`,
  ): UserEntitlement;

  /** Edit the entitlements (License, Extensions, Projects, Teams etc) for a user. MSA Backed organizations may face limitation when using this API. */
  @tag("User Entitlements")
  @extension("x-ms-docs-override-version", "7.2-preview.5")
  @extension("x-ms-vss-resource", "userEntitlements")
  @extension("x-ms-vss-method", "UpdateUserEntitlement")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlements/{userId}")
  @patch
  UpdateUserEntitlement(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the user. */
    @format("uuid") @path userId: string,

    ...Parameters.`api-Version-preview`.`5`,
    @header contentType: "application/json-patch+json",

    /** JsonPatchDocument containing the operations to perform on the user. */
    @body body: JsonPatchDocument,
  ): UserEntitlementsPatchResponse;
}

interface UserEntitlementSummary {
  /** Get summary of Licenses, Extension, Projects, Groups and their assignments in the collection. */
  @tag("User Entitlement Summary")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "userEntitlementSummary")
  @extension("x-ms-vss-method", "GetUsersSummary")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/userentitlementsummary")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Comma (',') separated list of properties to select. Supported property names are {AccessLevels, Licenses, Projects, Groups}. */
    @query(#{ explode: true }) select?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): UsersSummary;
}
