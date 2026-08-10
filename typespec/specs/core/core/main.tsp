import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Core" })
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
namespace Core;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model CategorizedWebApiTeams {
  /** Teams that the user is a member of. */
  myTeams?: WebApiTeam[];

  /** Teams that the user can read but is not member of. */
  otherReadableTeams?: WebApiTeam[];
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

model IdentityData {
  identityIds?: string[];
}

/** An Identity descriptor is a wrapper for the identity type (Windows SID, Passport) along with a unique identifier such as the SID or PUID. */
model IdentityDescriptor {
  /** The unique identifier for this identity, not exceeding 256 chars, which will be persisted. */
  identifier?: string;

  /** Type of descriptor (for example, Windows, Passport, etc.). */
  identityType?: string;
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

model Process {
  ...ProcessReference;
  _links?: ReferenceLinks;
  description?: string;
  @format("uuid") id?: string;
  isDefault?: boolean;
  @extension(
    "x-ms-enum",
    #{
      name: "ProcessType",
      values: #[
        #{ value: "system", description: "" },
        #{ value: "custom", description: "" },
        #{ value: "inherited", description: "" }
      ],
    }
  )
  type?: "system" | "custom" | "inherited" | string;
}

model ProcessReference {
  name?: string;
  url?: string;
}

/** Contains the image data for project avatar. */
model ProjectAvatar {
  /** The avatar image represented as a byte array. */
  image?: bytes[];
}

/** Contains information describing a project. */
model ProjectInfo {
  /** The abbreviated name of the project. */
  abbreviation?: string;

  /** The description of the project. */
  description?: string;

  /** The id of the project. */
  @format("uuid") id?: string;

  /** The time that this project was last updated. */
  lastUpdateTime?: utcDateTime;

  /** The name of the project. */
  name?: string;

  /** A set of name-value pairs storing additional property data related to the project. */
  properties?: ProjectProperty[];

  /** The current revision of the project. */
  revision?: int64;

  /** The current state of the project. */
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
  state?:
    | "deleting"
    | "new"
    | "wellFormed"
    | "createPending"
    | "all"
    | "unchanged"
    | "deleted"
    | string;

  /** A Uri that can be used to refer to this project. */
  uri?: string;

  /** The version number of the project. */
  version?: int64;

  /** Indicates whom the project is visible to. */
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
  visibility?: "private" | "public" | string;
}

model ProjectMessage {
  project?: ProjectInfo;
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectChangeType",
      values: #[
        #{ value: "modified", description: "" },
        #{ value: "deleted", description: "" },
        #{ value: "added", description: "" }
      ],
    }
  )
  projectChangeType?: "modified" | "deleted" | "added" | string;
  shouldInvalidateSystemStore?: boolean;
}

model ProjectProperties {
  /** The team project Id */
  @format("uuid") projectId?: string;

  /** The collection of team project properties */
  properties?: ProjectProperty[];
}

/** A named value associated with a project. */
model ProjectProperty {
  /** The name of the property. */
  name?: string;

  /** The value of the property. */
  value?: {};
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

model Proxy {
  authorization?: ProxyAuthorization;

  /** This is a description string */
  description?: string;

  /** The friendly name of the server */
  friendlyName?: string;

  globalDefault?: boolean;

  /** This is a string representation of the site that the proxy server is located in (e.g. 'NA-WA-RED') */
  site?: string;

  siteDefault?: boolean;

  /** The URL of the proxy server */
  url?: string;
}

model ProxyAuthorization {
  /** Gets or sets the endpoint used to obtain access tokens from the configured token service. */
  authorizationUrl?: string;

  /** Gets or sets the client identifier for this proxy. */
  @format("uuid") clientId?: string;

  identity?: IdentityDescriptor;
  publicKey?: PublicKey;
}

/** Represents the public key portion of an RSA asymmetric key. */
model PublicKey {
  /** Gets or sets the exponent for the public key. */
  exponent?: bytes[];

  /** Gets or sets the modulus for the public key. */
  modulus?: bytes[];
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** The Team Context for an operation. */
model TeamContext {
  /** The team project Id or name. Ignored if ProjectId is set. */
  project?: string;

  /** The Team Project ID. Required if Project is not set. */
  @format("uuid") projectId?: string;

  /** The Team Id or name. Ignored if TeamId is set. */
  team?: string;

  /** The Team Id */
  @format("uuid") teamId?: string;
}

model TeamMember {
  identity?: IdentityRef;
  isTeamAdmin?: boolean;
}

/** Represents a Team Project object. */
model TeamProject {
  ...TeamProjectReference;
  _links?: ReferenceLinks;

  /** Set of capabilities this project has (such as process template & version control). */
  capabilities?: Record<Record<string>>;

  defaultTeam?: WebApiTeamRef;
}

/** Data contract for a TeamProjectCollection. */
model TeamProjectCollection {
  ...TeamProjectCollectionReference;
  _links?: ReferenceLinks;

  /** Project collection description. */
  description?: string;

  /** Process customization type on this collection. It can be Xml or Inherited. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProcessCustomizationType",
      values: #[
        #{ value: "unknown", description: "Process customization can't be computed." },
        #{ value: "xml", description: "Customization based on project-scoped xml customization" },
        #{ value: "inherited", description: "Customization based on process inheritance" }
      ],
    }
  )
  processCustomizationType?: "unknown" | "xml" | "inherited" | string;

  /** Project collection state. */
  state?: string;
}

/** Reference object for a TeamProjectCollection. */
model TeamProjectCollectionReference {
  /** Collection avatar Url. */
  avatarUrl?: string;

  /** Collection Id. */
  @format("uuid") id?: string;

  /** Collection Name. */
  name?: string;

  /** Collection REST Url. */
  url?: string;
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
  state?:
    | "deleting"
    | "new"
    | "wellFormed"
    | "createPending"
    | "all"
    | "unchanged"
    | "deleted"
    | string;

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
  visibility?: "private" | "public" | string;
}

/** A data transfer object that stores the metadata associated with the creation of temporary data. */
model TemporaryDataCreatedDTO {
  ...TemporaryDataDTO;

  /** Temporary data expiration date. */
  expirationDate?: utcDateTime;

  /** Temporary data id. */
  @format("uuid") id?: string;

  /** Rest url for the temporary data. */
  url?: string;
}

/** A data transfer object that stores the metadata associated with the temporary data. */
model TemporaryDataDTO {
  /** Temporary data expire in seconds */
  expirationSeconds?: int32;

  /** Temporary data origin */
  origin?: string;

  /** Temporary data. */
  value?: {};
}

/** Updateable properties for a WebApiTeam. */
model UpdateTeam {
  /** New description for the team. */
  description?: string;

  /** New name for the team. */
  name?: string;
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

model WebApiConnectedService {
  ...WebApiConnectedServiceRef;
  authenticatedBy?: IdentityRef;

  /** Extra description on the service. */
  description?: string;

  /** Friendly Name of service connection */
  friendlyName?: string;

  /** The kind of service. */
  kind?: string;

  project?: TeamProjectReference;

  /** Optional uri to connect directly to the service such as https://windows.azure.com */
  serviceUri?: string;
}

model WebApiConnectedServiceDetails {
  ...WebApiConnectedServiceRef;
  connectedServiceMetaData?: WebApiConnectedService;

  /** Credential info */
  credentialsXml?: string;

  /** Optional uri to connect directly to the service such as https://windows.azure.com */
  endPoint?: string;
}

model WebApiConnectedServiceRef {
  id?: string;
  url?: string;
}

/** The representation of data needed to create a tag definition which is sent across the wire. */
model WebApiCreateTagRequestData {
  /** Name of the tag definition that will be created. */
  name?: string;
}

model WebApiProject {
  ...TeamProjectReference;

  /** Set of capabilities this project has */
  capabilities?: Record<Record<string>>;

  collection?: WebApiProjectCollectionRef;
  defaultTeam?: WebApiTeamRef;
}

model WebApiProjectCollection {
  ...WebApiProjectCollectionRef;

  /** Project collection description */
  description?: string;

  /** Project collection state */
  state?: string;
}

model WebApiProjectCollectionRef {
  /** Collection Tfs Url (Host Url) */
  collectionUrl?: string;

  /** Collection Guid */
  @format("uuid") id?: string;

  /** Collection Name */
  name?: string;

  /** Collection REST Url */
  url?: string;
}

/** The representation of a tag definition which is sent across the wire. */
model WebApiTagDefinition {
  /** Whether or not the tag definition is active. */
  active?: boolean;

  /** ID of the tag definition. */
  @format("uuid") id?: string;

  /** The name of the tag definition. */
  name?: string;

  /** Resource URL for the Tag Definition. */
  url?: string;
}

model WebApiTeam {
  ...WebApiTeamRef;

  /** Team description */
  description?: string;

  identity?: Identity;

  /** Identity REST API Url to this team */
  identityUrl?: string;

  @format("uuid") projectId?: string;
  projectName?: string;
}

model WebApiTeamRef {
  /** Team (Identity) Guid. A Team Foundation ID. */
  @format("uuid") id?: string;

  /** Team name */
  name?: string;

  /** Team REST API Url */
  url?: string;
}

/** A collection of `Process` as returned by Azure DevOps. */
model ProcessList {
  count?: int32;
  value?: Process[];
}

/** A collection of `TeamProjectReference` as returned by Azure DevOps. */
model TeamProjectReferenceList {
  count?: int32;
  value?: TeamProjectReference[];
}

/** A collection of `ProjectProperty` as returned by Azure DevOps. */
model ProjectPropertyList {
  count?: int32;
  value?: ProjectProperty[];
}

/** A collection of `WebApiTeam` as returned by Azure DevOps. */
model WebApiTeamList {
  count?: int32;
  value?: WebApiTeam[];
}

/** A collection of `TeamMember` as returned by Azure DevOps. */
model TeamMemberList {
  count?: int32;
  value?: TeamMember[];
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
  }
}

interface Processes {
  /** Get a list of processes. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "GetProcesses")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/process/processes")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): ProcessList;

  /** Get a process by ID. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "GetProcessById")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/process/processes/{processId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a process. */
    @format("uuid") @path processId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Process;
}

interface Projects {
  /** Get all projects in the organization that the authenticated user has access to. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "projects")
  @extension("x-ms-vss-method", "GetProjects")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Filter on team projects in a specific team project state (default: WellFormed). */
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
    @query(#{ explode: true })
    stateFilter?:
      | "deleting"
      | "new"
      | "wellFormed"
      | "createPending"
      | "all"
      | "unchanged"
      | "deleted",

    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) $skip?: int32,

    /** Pointer that shows how many projects already been fetched. */
    @query(#{ explode: true }) continuationToken?: int32,

    @query(#{ explode: true }) getDefaultTeamImageUrl?: boolean,
    ...Parameters.`api-Version-preview`.`4`,
  ): TeamProjectReferenceList;

  /** Queues a project to be created. Use the [GetOperation](../../operations/operations/get) to periodically check for create project status. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "projects")
  @extension("x-ms-vss-method", "QueueCreateProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`4`,

    /** The project to create. */
    @body body: TeamProject,
  ): OperationReference;

  /** Queues a project to be deleted. Use the [GetOperation](../../operations/operations/get) to periodically check for delete project status. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "projects")
  @extension("x-ms-vss-method", "QueueDeleteProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project id of the project to delete. */
    @format("uuid") @path projectId: string,

    ...Parameters.`api-Version-preview`.`4`,
  ): OperationReference;

  /** Get project with the specified id or name, optionally including capabilities. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "projects")
  @extension("x-ms-vss-method", "GetProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path projectId: string,

    /** Include capabilities (such as source control) in the team project result (default: false). */
    @query(#{ explode: true }) includeCapabilities?: boolean,

    /** Search within renamed projects (that had such name in the past). */
    @query(#{ explode: true }) includeHistory?: boolean,

    ...Parameters.`api-Version-preview`.`4`,
  ): TeamProject;

  /** Update an existing project's name, abbreviation, description, or restore a project. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "projects")
  @extension("x-ms-vss-method", "UpdateProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The project id of the project to update. */
    @format("uuid") @path projectId: string,

    ...Parameters.`api-Version-preview`.`4`,

    /** The updates for the project. The state must be set to wellFormed to restore the project. */
    @body body: TeamProject,
  ): OperationReference;

  /** Get a collection of team project properties. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "properties")
  @extension("x-ms-vss-method", "GetProjectProperties")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/properties")
  @get
  GetProjectProperties(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The team project ID. */
    @format("uuid") @path projectId: string,

    /** A comma-delimited string of team project property names. Wildcard characters ('?' and '*') are supported. If no key is specified, all properties will be returned. */
    @format("array (string)") @query(#{ explode: true }) keys?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): ProjectPropertyList;

  /** Create, update, and delete team project properties. */
  @tag("Projects")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "properties")
  @extension("x-ms-vss-method", "SetProjectProperties")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/properties")
  @patch
  SetProjectProperties(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The team project ID. */
    @format("uuid") @path projectId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/json-patch+json",

    /** A JSON Patch document that represents an array of property operations. See RFC 6902 for more details on JSON Patch. The accepted operation verbs are Add and Remove, where Add is used for both creating and updating properties. The path consists of a forward slash and a property name. */
    @body body: JsonPatchDocument,
  ): OkResponse;
}

interface Avatar {
  /** Removes the avatar for the project. */
  @tag("Avatar")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "avatar")
  @extension("x-ms-vss-method", "RemoveProjectAvatar")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/avatar")
  @delete
  RemoveProjectAvatar(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID or name of the project. */
    @path projectId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Sets the avatar for the project. */
  @tag("Avatar")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "avatar")
  @extension("x-ms-vss-method", "SetProjectAvatar")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/avatar")
  @put
  SetProjectAvatar(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID or name of the project. */
    @path projectId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The avatar blob data object to upload. */
    @body body: ProjectAvatar,
  ): OkResponse;
}

interface CategorizedTeams {
  /** Gets list of user readable teams in a project and teams user is member of (excluded from readable list). */
  @tag("Categorized Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "categorizedTeams")
  @extension("x-ms-vss-method", "GetProjectTeamsByCategory")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/categorizedteams/")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID (GUID) of the team project containing the teams to retrieve. */
    @path projectId: string,

    /** A value indicating whether or not to expand Identity information in the result WebApiTeam object. */
    @query(#{ explode: true }) $expandIdentity?: boolean,

    /** Maximum number of teams to return. */
    @query(#{ explode: true }) $top?: int32,

    /** Number of teams to skip. */
    @query(#{ explode: true }) $skip?: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): CategorizedWebApiTeams;
}

interface Teams {
  /** Get a list of teams. */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "teams")
  @extension("x-ms-vss-method", "GetTeams")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/teams")
  @get
  GetTeams(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path projectId: string,

    /** If true return all the teams requesting user is member, otherwise return all the teams user has read access. */
    @query(#{ explode: true }) $mine?: boolean,

    /** Maximum number of teams to return. */
    @query(#{ explode: true }) $top?: int32,

    /** Number of teams to skip. */
    @query(#{ explode: true }) $skip?: int32,

    /** A value indicating whether or not to expand Identity information in the result WebApiTeam object. */
    @query(#{ explode: true }) $expandIdentity?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): WebApiTeamList;

  /** Create a team in a team project. Possible failure scenarios Invalid project name/ID (project doesn't exist) 404 Invalid team name or description 400 Team already exists 400 Insufficient privileges 400 */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "teams")
  @extension("x-ms-vss-method", "CreateTeam")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/teams")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID (GUID) of the team project in which to create the team. */
    @path projectId: string,

    ...Parameters.`api-Version-preview`.`3`,

    /** The team data used to create the team. */
    @body body: WebApiTeam,
  ): WebApiTeam;

  /** Delete a team. */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "teams")
  @extension("x-ms-vss-method", "DeleteTeam")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/teams/{teamId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID (GUID) of the team project containing the team to delete. */
    @path projectId: string,

    /** The name or ID of the team to delete. */
    @path teamId: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): OkResponse;

  /** Get a specific team. */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "teams")
  @extension("x-ms-vss-method", "GetTeam")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/teams/{teamId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID (GUID) of the team project containing the team. */
    @path projectId: string,

    /** The name or ID (GUID) of the team. */
    @path teamId: string,

    /** A value indicating whether or not to expand Identity information in the result WebApiTeam object. */
    @query(#{ explode: true }) $expandIdentity?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): WebApiTeam;

  /** Update a team's name and/or description. */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "teams")
  @extension("x-ms-vss-method", "UpdateTeam")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/teams/{teamId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID (GUID) of the team project containing the team to update. */
    @path projectId: string,

    /** The name of ID of the team to update. */
    @path teamId: string,

    ...Parameters.`api-Version-preview`.`3`,
    @body body: WebApiTeam,
  ): WebApiTeam;

  /** Get a list of members for a specific team. */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "members")
  @extension("x-ms-vss-method", "GetTeamMembersWithExtendedProperties")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/projects/{projectId}/teams/{teamId}/members")
  @get
  GetTeamMembersWithExtendedProperties(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The name or ID (GUID) of the team project the team belongs to. */
    @path projectId: string,

    /** The name or ID (GUID) of the team . */
    @path teamId: string,

    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) $skip?: int32,
    ...Parameters.`api-Version-preview`.`2`,
  ): TeamMemberList;

  /** Get a list of all teams. */
  @tag("Teams")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "teams")
  @extension("x-ms-vss-method", "GetAllTeams")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/teams")
  @get
  GetAllTeams(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** If true, then return all teams requesting user is member. Otherwise return all teams user has read access. */
    @query(#{ explode: true }) $mine?: boolean,

    /** Maximum number of teams to return. */
    @query(#{ explode: true }) $top?: int32,

    /** Number of teams to skip. */
    @query(#{ explode: true }) $skip?: int32,

    /** A value indicating whether or not to expand Identity information in the result WebApiTeam object. */
    @query(#{ explode: true }) $expandIdentity?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): WebApiTeamList;
}
