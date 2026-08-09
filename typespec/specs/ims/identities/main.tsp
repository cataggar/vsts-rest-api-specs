import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Identity" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://vssps.dev.azure.com")
namespace Identity;

/** Container class for changed identities */
model ChangedIdentities {
  /** Changed Identities */
  identities?: Identity[];

  /** More data available, set to true if pagesize is specified. */
  moreData?: boolean;

  sequenceContext?: ChangedIdentitiesContext;
}

/** Context class for changed identities */
model ChangedIdentitiesContext {
  /** Last Group SequenceId */
  groupSequenceId?: int32;

  /** Last Identity SequenceId */
  identitySequenceId?: int32;

  /** Last Group OrganizationIdentitySequenceId */
  organizationIdentitySequenceId?: int32;

  /** Page size */
  pageSize?: int32;
}

model CreateScopeInfo {
  adminGroupDescription?: string;
  adminGroupName?: string;
  @format("uuid") creatorId?: string;
  @format("uuid") parentScopeId?: string;
  scopeName?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "GroupScopeType",
      values: #[
        #{ value: "generic", description: "" },
        #{ value: "serviceHost", description: "" },
        #{ value: "teamProject", description: "" }
      ],
    }
  )
  scopeType?: "generic" | "serviceHost" | "teamProject";
}

model FrameworkIdentityInfo {
  displayName?: string;
  identifier?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "FrameworkIdentityType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "serviceIdentity", description: "" },
        #{ value: "aggregateIdentity", description: "" },
        #{ value: "importedIdentity", description: "" }
      ],
    }
  )
  identityType?: "none" | "serviceIdentity" | "aggregateIdentity" | "importedIdentity";
  isActive?: boolean;
  role?: string;
}

model GroupMembership {
  active?: boolean;
  descriptor?: IdentityDescriptor;
  @format("uuid") id?: string;
  @format("uuid") queriedId?: string;
}

model Identity {
  ...IdentityBase;
}

/** Base Identity class to allow 'trimmed' identity class in the GetConnectionData API Makes sure that on-the-wire representations of the derived classes are compatible with each other (e.g. Server responds with PublicIdentity object while client deserializes it as Identity object) Derived classes should not have additional [DataMember] properties */
model IdentityBase {
  /** The custom display name for the identity (if any). Setting this property to an empty string will clear the existing custom display name. Setting this property to null will not affect the existing persisted value (since null values do not get sent over the wire or to the database) */
  customDisplayName?: string;

  descriptor?: IdentityDescriptor;

  /** Identity Identifier. Also called Storage Key, or VSID */
  @format("uuid") id?: string;

  /** True if the identity has a membership in any Azure Devops group in the organization. */
  isActive?: boolean;

  /** True if the identity is a group. */
  isContainer?: boolean;

  @format("uuid") masterId?: string;

  /** Id of the members of the identity (groups only). */
  memberIds?: string[];

  memberOf?: IdentityDescriptor[];
  members?: IdentityDescriptor[];
  metaTypeId?: int32;
  properties?: PropertiesCollection;

  /** The display name for the identity as specified by the source identity provider. */
  providerDisplayName?: string;

  resourceVersion?: int32;
  socialDescriptor?: string;

  /** Subject descriptor of a Graph entity. */
  subjectDescriptor?: string;

  uniqueUserId?: int32;
}

model IdentityBatchInfo {
  descriptors?: IdentityDescriptor[];
  identityIds?: string[];
  includeRestrictedVisibility?: boolean;
  propertyNames?: string[];
  @extension(
    "x-ms-enum",
    #{
      name: "QueryMembership",
      values: #[
        #{ value: "none", description: "Query will not return any membership data" },
        #{ value: "direct", description: "Query will return only direct membership data" },
        #{ value: "expanded", description: "Query will return expanded membership data" },
        #{
          value: "expandedUp",
          description: "Query will return expanded up membership data (parents only)",
        },
        #{
          value: "expandedDown",
          description: "Query will return expanded down membership data (children only)",
        }
      ],
    }
  )
  queryMembership?: "none" | "direct" | "expanded" | "expandedUp" | "expandedDown";
  socialDescriptors?: string[];
  subjectDescriptors?: string[];
}

/** An Identity descriptor is a wrapper for the identity type (Windows SID, Passport) along with a unique identifier such as the SID or PUID. */
model IdentityDescriptor {
  /** The unique identifier for this identity, not exceeding 256 chars, which will be persisted. */
  identifier?: string;

  /** Type of descriptor (for example, Windows, Passport, etc.). */
  identityType?: string;
}

model IdentityRightsTransferData {
  userPrincipalNameMappings?: Record<string>;
}

model IdentityScope {
  administrators?: IdentityDescriptor;
  @format("uuid") id?: string;
  isActive?: boolean;
  isGlobal?: boolean;
  @format("uuid") localScopeId?: string;
  name?: string;
  @format("uuid") parentId?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "GroupScopeType",
      values: #[
        #{ value: "generic", description: "" },
        #{ value: "serviceHost", description: "" },
        #{ value: "teamProject", description: "" }
      ],
    }
  )
  scopeType?: "generic" | "serviceHost" | "teamProject";
  @format("uuid") securingHostId?: string;
  subjectDescriptor?: string;
}

/** Identity information. */
model IdentitySelf {
  /** The UserPrincipalName (UPN) of the account. This value comes from the source provider. */
  accountName?: string;

  /** The display name. For AAD accounts with multiple tenants this is the display name of the profile in the home tenant. */
  displayName?: string;

  /** This represents the name of the container of origin. For AAD accounts this is the tenantID of the home tenant. For MSA accounts this is the string 'Windows Live ID'. */
  domain?: string;

  /** This is the VSID of the home tenant profile. If the profile is signed into the home tenant or if the profile has no tenants then this Id is the same as the Id returned by the profile/profiles/me endpoint. Going forward it is recommended that you use the combined values of Origin, OriginId and Domain to uniquely identify a user rather than this Id. */
  @format("uuid") id?: string;

  /** The type of source provider for the origin identifier. For MSA accounts this is 'msa'. For AAD accounts this is 'aad'. */
  origin?: string;

  /** The unique identifier from the system of origin. If there are multiple tenants this is the unique identifier of the account in the home tenant. (For MSA this is the PUID in hex notation, for AAD this is the object id.) */
  originId?: string;

  /** For AAD accounts this is all of the tenants that this account is a member of. */
  tenants?: TenantInfo[];
}

model IdentitySnapshot {
  groups?: Identity[];
  identityIds?: string[];
  memberships?: GroupMembership[];
  @format("uuid") scopeId?: string;
  scopes?: IdentityScope[];
}

model IdentityTranslation {
  @format("uuid") localId?: string;
  @format("uuid") masterId?: string;
}

model IdentityUpdateData {
  @format("uuid") id?: string;
  index?: int32;
  updated?: boolean;
}

/** Represents a JSON object. */
model JObject {
  @format("JToken") item?: string;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
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

model PagedIdentities {
  continuationToken?: string[];
  identities?: Identity[];
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

model SwapIdentityInfo {
  @format("uuid") id1?: string;
  @format("uuid") id2?: string;
}

model TenantInfo {
  homeTenant?: boolean;
  @format("uuid") tenantId?: string;
  tenantName?: string;
  verifiedDomains?: string[];
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

/** Resolve legacy identity information for use with older APIs such as the Security APIs */
@tag("Identities")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "identities")
@extension("x-ms-vss-method", "ReadIdentities")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/identities")
@get
op Identities_ReadIdentities(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  /** A comma separated list of identity descriptors to resolve */
  @query(#{ explode: true }) descriptors?: string,

  /** A comma seperated list of storage keys to resolve */
  @query(#{ explode: true }) identityIds?: string,

  /** A comma seperated list of subject descriptors to resolve */
  @query(#{ explode: true }) subjectDescriptors?: string,

  /** The type of search to perform. Values can be AccountName (domainalias), DisplayName, MailAddress, General (display name, account name, or unique name), or LocalGroupName (only search Azure Devops groups). */
  @query(#{ explode: true }) searchFilter?: string,

  /** The search value, as specified by the searchFilter. */
  @query(#{ explode: true }) filterValue?: string,

  /** The membership information to include with the identities. Values can be None for no membership data or Direct to include the groups that the identity is a member of and the identities that are a member of this identity (groups only) */
  @extension(
    "x-ms-enum",
    #{
      name: "QueryMembership",
      values: #[
        #{ value: "none", description: "Query will not return any membership data" },
        #{ value: "direct", description: "Query will return only direct membership data" },
        #{ value: "expanded", description: "Query will return expanded membership data" },
        #{
          value: "expandedUp",
          description: "Query will return expanded up membership data (parents only)",
        },
        #{
          value: "expandedDown",
          description: "Query will return expanded down membership data (children only)",
        }
      ],
    }
  )
  @query(#{ explode: true })
  queryMembership?: "none" | "direct" | "expanded" | "expandedUp" | "expandedDown",

  ...Parameters.`api-Version-preview`.`1`,
): Body<Identity[]>;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
