import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Security" })
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
namespace Security;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Class for encapsulating the allowed and denied permissions for a given IdentityDescriptor. */
model AccessControlEntry {
  /** The set of permission bits that represent the actions that the associated descriptor is allowed to perform. */
  allow?: int32;

  /** The set of permission bits that represent the actions that the associated descriptor is not allowed to perform. */
  deny?: int32;

  descriptor?: IdentityDescriptor;
  extendedInfo?: AceExtendedInformation;
}

/** The AccessControlList class is meant to associate a set of AccessControlEntries with a security token and its inheritance settings. */
model AccessControlList {
  /** Storage of permissions keyed on the identity the permission is for. */
  acesDictionary?: Record<AccessControlEntry>;

  /** True if this ACL holds ACEs that have extended information. */
  includeExtendedInfo?: boolean;

  /** True if the given token inherits permissions from parents. */
  inheritPermissions?: boolean;

  /** The token that this AccessControlList is for. */
  token?: string;
}

/** A list of AccessControlList. An AccessControlList is meant to associate a set of AccessControlEntries with a security token and its inheritance settings. */
model AccessControlListsCollection {}

/** Holds the inherited and effective permission information for a given AccessControlEntry. */
model AceExtendedInformation {
  /** This is the combination of all of the explicit and inherited permissions for this identity on this token. These are the permissions used when determining if a given user has permission to perform an action. */
  effectiveAllow?: int32;

  /** This is the combination of all of the explicit and inherited permissions for this identity on this token. These are the permissions used when determining if a given user has permission to perform an action. */
  effectiveDeny?: int32;

  /** These are the permissions that are inherited for this identity on this token. If the token does not inherit permissions this will be 0. Note that any permissions that have been explicitly set on this token for this identity, or any groups that this identity is a part of, are not included here. */
  inheritedAllow?: int32;

  /** These are the permissions that are inherited for this identity on this token. If the token does not inherit permissions this will be 0. Note that any permissions that have been explicitly set on this token for this identity, or any groups that this identity is a part of, are not included here. */
  inheritedDeny?: int32;
}

model ActionDefinition {
  /** The bit mask integer for this action. Must be a power of 2. */
  bit?: int32;

  /** The localized display name for this action. */
  displayName?: string;

  /** The non-localized name for this action. */
  name?: string;

  /** The namespace that this action belongs to. This will only be used for reading from the database. */
  @format("uuid") namespaceId?: string;
}

/** An Identity descriptor is a wrapper for the identity type (Windows SID, Passport) along with a unique identifier such as the SID or PUID. */
model IdentityDescriptor {
  /** The unique identifier for this identity, not exceeding 256 chars, which will be persisted. */
  identifier?: string;

  /** Type of descriptor (for example, Windows, Passport, etc.). */
  identityType?: string;
}

/** Represents a JSON object. */
model JObject {
  @format("JToken") item?: string;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

/** Represents an evaluated permission. */
model PermissionEvaluation {
  /** Permission bit for this evaluated permission. */
  permissions?: int32;

  /** Security namespace identifier for this evaluated permission. */
  @format("uuid") securityNamespaceId?: string;

  /** Security namespace-specific token for this evaluated permission. */
  token?: string;

  /** Permission evaluation value. */
  value?: boolean;
}

/** Represents a set of evaluated permissions. */
model PermissionEvaluationBatch {
  /** True if members of the Administrators group should always pass the security check. */
  alwaysAllowAdministrators?: boolean;

  /** Array of permission evaluations to evaluate. */
  evaluations?: PermissionEvaluation[];
}

/** Class for describing the details of a TeamFoundationSecurityNamespace. */
model SecurityNamespaceDescription {
  /** The list of actions that this Security Namespace is responsible for securing. */
  actions?: ActionDefinition[];

  /** This is the dataspace category that describes where the security information for this SecurityNamespace should be stored. */
  dataspaceCategory?: string;

  /** This localized name for this namespace. */
  displayName?: string;

  /** If the security tokens this namespace will be operating on need to be split on certain character lengths to determine its elements, that length should be specified here. If not, this value will be -1. */
  elementLength?: int32;

  /** This is the type of the extension that should be loaded from the plugins directory for extending this security namespace. */
  extensionType?: string;

  /** If true, the security namespace is remotable, allowing another service to proxy the namespace. */
  isRemotable?: boolean;

  /** This non-localized for this namespace. */
  name?: string;

  /** The unique identifier for this namespace. */
  @format("uuid") namespaceId?: string;

  /** The permission bits needed by a user in order to read security data on the Security Namespace. */
  readPermission?: int32;

  /** If the security tokens this namespace will be operating on need to be split on certain characters to determine its elements that character should be specified here. If not, this value will be the null character. */
  @format("Char") separatorValue?: string;

  /** Used to send information about the structure of the security namespace over the web service. */
  structureValue?: int32;

  /** The bits reserved by system store */
  systemBitMask?: int32;

  /** If true, the security service will expect an ISecurityDataspaceTokenTranslator plugin to exist for this namespace */
  useTokenTranslator?: boolean;

  /** The permission bits needed by a user in order to modify security data on the Security Namespace. */
  writePermission?: int32;
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

interface AccessControlEntries {
  /** Remove the specified ACEs from the ACL belonging to the specified token. */
  @tag("Access Control Entries")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "accessControlEntries")
  @extension("x-ms-vss-method", "RemoveAccessControlEntries")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/accesscontrolentries/{securityNamespaceId}")
  @delete
  RemoveAccessControlEntries(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** The token whose ACL should be modified. */
    @query(#{ explode: true }) token?: string,

    /** String containing a list of identity descriptors separated by ',' whose entries should be removed. */
    @query(#{ explode: true }) descriptors?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<boolean>;

  /** Add or update ACEs in the ACL for the provided token. The request body contains the target token, a list of [ACEs](https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access-control-entries/set-access-control-entries?#accesscontrolentry) and a optional merge parameter. In the case of a collision (by identity descriptor) with an existing ACE in the ACL, the 'merge' parameter determines the behavior. If set, the existing ACE has its allow and deny merged with the incoming ACE's allow and deny. If unset, the existing ACE is displaced. For optimal performance and reliability, it is strongly recommended to batch multiple ACEs in a single request rather than sending individual requests. Batching requests improves efficiency, reduces overhead, and helps ensure successful completion of your operations. */
  @tag("Access Control Entries")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "accessControlEntries")
  @extension("x-ms-vss-method", "SetAccessControlEntries")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/accesscontrolentries/{securityNamespaceId}")
  @post
  SetAccessControlEntries(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: JObject,
  ): Body<AccessControlEntry[]>;
}

interface AccessControlLists {
  /** Remove access control lists under the specfied security namespace. */
  @tag("Access Control Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "accessControlLists")
  @extension("x-ms-vss-method", "RemoveAccessControlLists")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/accesscontrollists/{securityNamespaceId}")
  @delete
  RemoveAccessControlLists(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** One or more comma-separated security tokens */
    @query(#{ explode: true }) tokens?: string,

    /** If true and this is a hierarchical namespace, also remove child ACLs of the specified tokens. */
    @query(#{ explode: true }) recurse?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<boolean>;

  /** Return a list of access control lists for the specified security namespace and token. All ACLs in the security namespace will be retrieved if no optional parameters are provided. Note that the response will include all project IDs, including projects the current user does not have access to. */
  @tag("Access Control Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "accessControlLists")
  @extension("x-ms-vss-method", "QueryAccessControlLists")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/accesscontrollists/{securityNamespaceId}")
  @get
  Query(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** Security token */
    @query(#{ explode: true }) token?: string,

    /** An optional filter string containing a list of identity descriptors separated by ',' whose ACEs should be retrieved. If this is left null, entire ACLs will be returned. */
    @query(#{ explode: true }) descriptors?: string,

    /** If true, populate the extended information properties for the access control entries contained in the returned lists. */
    @query(#{ explode: true }) includeExtendedInfo?: boolean,

    /** If true and this is a hierarchical namespace, return child ACLs of the specified token. */
    @query(#{ explode: true }) recurse?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<AccessControlList[]>;

  /** Create or update one or more access control lists. All data that currently exists for the ACLs supplied will be overwritten. */
  @tag("Access Control Lists")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "accessControlLists")
  @extension("x-ms-vss-method", "SetAccessControlLists")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/accesscontrollists/{securityNamespaceId}")
  @post
  SetAccessControlLists(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** A list of ACLs to create or update. */
    @body body: VssJsonCollectionWrapper,
  ): OkResponse;
}

interface Permissions {
  /** Removes the specified permissions on a security token for a user or group. */
  @tag("Permissions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "permissions")
  @extension("x-ms-vss-method", "RemovePermission")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/permissions/{securityNamespaceId}/{permissions}")
  @delete
  RemovePermission(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** Identity descriptor of the user to remove permissions for. */
    @query(#{ explode: true }) descriptor: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** Permissions to remove. */
    @extension("x-ms-required", false) @path permissions: int32,

    /** Security token to remove permissions for. */
    @query(#{ explode: true }) token?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): AccessControlEntry;

  /** Evaluates whether the caller has the specified permissions on the specified set of security tokens. */
  @tag("Permissions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "permissions")
  @extension("x-ms-vss-method", "HasPermissions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/permissions/{securityNamespaceId}/{permissions}")
  @get
  HasPermissions(
    /** Security namespace identifier. */
    @format("uuid") @path securityNamespaceId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** Permissions to evaluate. */
    @extension("x-ms-required", false) @path permissions: int32,

    /** One or more security tokens to evaluate. */
    @query(#{ explode: true }) tokens?: string,

    /** If true and if the caller is an administrator, always return true. */
    @query(#{ explode: true }) alwaysAllowAdministrators?: boolean,

    /** Optional security token separator. Defaults to ','. */
    @query(#{ explode: true }) delimiter?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<boolean[]>;

  /** Evaluates multiple permissions for the calling user. Note: This method does not aggregate the results, nor does it short-circuit if one of the permissions evaluates to false. */
  @tag("Permissions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissionEvaluationBatch")
  @extension("x-ms-vss-method", "HasPermissionsBatch")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/security/permissionevaluationbatch")
  @post
  HasPermissionsBatch(
    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The set of evaluation requests. */
    @body body: PermissionEvaluationBatch,
  ): PermissionEvaluationBatch;
}

interface SecurityNamespaces {
  /** List all security namespaces or just the specified namespace. */
  @tag("Security Namespaces")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "securityNamespaces")
  @extension("x-ms-vss-method", "QuerySecurityNamespaces")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/securitynamespaces/{securityNamespaceId}")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** Security namespace identifier. */
    @extension("x-ms-required", false)
    @format("uuid")
    @path
    securityNamespaceId: string,

    /** If true, retrieve only local security namespaces. */
    @query(#{ explode: true }) localOnly?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<SecurityNamespaceDescription[]>;
}
