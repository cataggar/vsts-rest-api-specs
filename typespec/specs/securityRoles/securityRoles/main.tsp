import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "SecurityRoles" })
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
namespace SecurityRoles;

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

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model RoleAssignment {
  /** Designates the role as explicitly assigned or inherited. */
  @extension(
    "x-ms-enum",
    #{
      name: "RoleAccess",
      values: #[
        #{ value: "assigned", description: "Access has been explicitly set." },
        #{ value: "inherited", description: "Access has been inherited from a higher scope." }
      ],
    }
  )
  access?: "assigned" | "inherited";

  /** User friendly description of access assignment. */
  accessDisplayName?: string;

  identity?: IdentityRef;
  role?: SecurityRole;
}

model SecurityRole {
  /** Permissions the role is allowed. */
  allowPermissions?: int32;

  /** Permissions the role is denied. */
  denyPermissions?: int32;

  /** Description of user access defined by the role */
  description?: string;

  /** User friendly name of the role. */
  displayName?: string;

  /** Globally unique identifier for the role. */
  identifier?: string;

  /** Unique name of the role in the scope. */
  name?: string;

  /** Returns the id of the ParentScope. */
  scope?: string;
}

model UserRoleAssignmentRef {
  /** The name of the role assigned. */
  roleName?: string;

  /** Identifier of the user given the role assignment. */
  uniqueName?: string;

  /** Unique id of the user given the role assignment. */
  @format("uuid") userId?: string;
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

/** Get role assignments for the resource */
@tag("Roleassignments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "roleassignments")
@extension("x-ms-vss-method", "GetRoleAssignments")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/securityroles/scopes/{scopeId}/roleassignments/resources/{resourceId}")
@get
op Roleassignments_List(
  /** Id of the assigned scope */
  @path scopeId: string,

  /** Id of the resource that is assigned the scope */
  @path resourceId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<RoleAssignment[]>;

@tag("Roleassignments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "roleassignments")
@extension("x-ms-vss-method", "RemoveRoleAssignments")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/securityroles/scopes/{scopeId}/roleassignments/resources/{resourceId}")
@patch
op `Roleassignments_Remove Role Assignments`(
  @path scopeId: string,
  @path resourceId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: string[],
): OkResponse;

/** Set role assignments on a resource */
@tag("Roleassignments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "roleassignments")
@extension("x-ms-vss-method", "SetRoleAssignments")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/securityroles/scopes/{scopeId}/roleassignments/resources/{resourceId}")
@put
op `Roleassignments_Set Role Assignments`(
  /** Id of the assigned scope */
  @path scopeId: string,

  /** Id of the resource on which the role is to be assigned */
  @path resourceId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  @query(#{ explode: true }) limitToCallerIdentityDomain?: boolean,
  ...Parameters.`api-Version-preview`.`1`,

  /** Roles to be assigned */
  @body body: UserRoleAssignmentRef[],
): Body<RoleAssignment[]>;

/** Remove the role assignment on a resource */
@tag("Roleassignments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "roleassignments")
@extension("x-ms-vss-method", "RemoveRoleAssignment")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/securityroles/scopes/{scopeId}/roleassignments/resources/{resourceId}/{identityId}")
@delete
op `Roleassignments_Remove Role Assignment`(
  /** Id of the assigned scope */
  @path scopeId: string,

  /** Id of the resource on which the role is to be removed */
  @path resourceId: string,

  /** Identity on which the assignment is to be removed */
  @format("uuid") @path identityId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Set role assignment on a resource */
@tag("Roleassignments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "roleassignments")
@extension("x-ms-vss-method", "SetRoleAssignment")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/securityroles/scopes/{scopeId}/roleassignments/resources/{resourceId}/{identityId}")
@put
op `Roleassignments_Set Role Assignment`(
  /** Id of the assigned scope */
  @path scopeId: string,

  /** Id of the resource on which the role is to be assigned */
  @path resourceId: string,

  @format("uuid") @path identityId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Roles to be assigned */
  @body body: UserRoleAssignmentRef,
): RoleAssignment;

@tag("Roledefinitions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "roledefinitions")
@extension("x-ms-vss-method", "GetRoleDefinitions")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/securityroles/scopes/{scopeId}/roledefinitions")
@get
op Roledefinitions_List(
  @path scopeId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<SecurityRole[]>;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
