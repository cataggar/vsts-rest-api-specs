import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "ExtensionManagement" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://extmgmt.dev.azure.com")
namespace ExtensionManagement;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AcquisitionOperation {
  /** State of the AcquisitionOperation for the current user */
  @extension(
    "x-ms-enum",
    #{
      name: "AcquisitionOperationState",
      values: #[
        #{ value: "disallow", description: "Not allowed to use this AcquisitionOperation" },
        #{ value: "allow", description: "Allowed to use this AcquisitionOperation" },
        #{
          value: "completed",
          description: "Operation has already been completed and is no longer available",
        }
      ],
    }
  )
  operationState?: "disallow" | "allow" | "completed" | string;

  /** AcquisitionOperationType: install, request, buy, etc... */
  @extension(
    "x-ms-enum",
    #{
      name: "AcquisitionOperationType",
      values: #[
        #{ value: "get", description: "Not yet used" },
        #{ value: "install", description: "Install this extension into the host provided" },
        #{
          value: "buy",
          description: "Buy licenses for this extension and install into the host provided",
        },
        #{ value: "try", description: "Try this extension" },
        #{ value: "request", description: "Request this extension for installation" },
        #{ value: "none", description: "No action found" },
        #{ value: "purchaseRequest", description: "Request admins for purchasing extension" }
      ],
    }
  )
  operationType?:
    | "get"
    | "install"
    | "buy"
    | "try"
    | "request"
    | "none"
    | "purchaseRequest"
    | string;

  /** Optional reason to justify current state. Typically used with Disallow state. */
  reason?: string;

  /** List of reasons indicating why the operation is not allowed. */
  reasons?: AcquisitionOperationDisallowReason[];
}

model AcquisitionOperationDisallowReason {
  /** User-friendly message clarifying the reason for disallowance */
  message?: string;

  /** Type of reason for disallowance - AlreadyInstalled, UnresolvedDemand, etc. */
  type?: string;
}

/** Market item acquisition options (install, buy, etc) for an installation target. */
model AcquisitionOptions {
  defaultOperation?: AcquisitionOperation;

  /** The item id that this options refer to */
  itemId?: string;

  /** Operations allowed for the ItemId in this target */
  operations?: AcquisitionOperation[];

  properties?: JObject;

  /** The target that this options refer to */
  target?: string;
}

/** Representation of a ContributionNode that can be used for serialized to clients. */
model ClientContribution {
  /** Description of the contribution/type */
  description?: string;

  /** Fully qualified identifier of the contribution/type */
  id?: string;

  /** Includes is a set of contributions that should have this contribution included in their targets list. */
  includes?: string[];

  properties?: JObject;

  /** The ids of the contribution(s) that this contribution targets. (parent contributions) */
  targets?: string[];

  /** Id of the Contribution Type */
  type?: string;
}

/** Representation of a ContributionNode that can be used for serialized to clients. */
model ClientContributionNode {
  /** List of ids for contributions which are children to the current contribution. */
  children?: string[];

  contribution?: ClientContribution;

  /** List of ids for contributions which are parents to the current contribution. */
  parents?: string[];
}

model ClientContributionProviderDetails {
  /** Friendly name for the provider. */
  displayName?: string;

  /** Unique identifier for this provider. The provider name can be used to cache the contribution data and refer back to it when looking for changes */
  name?: string;

  /** Properties associated with the provider */
  properties?: Record<string>;

  /** Version of contributions associated with this contribution provider. */
  version?: string;
}

/** A client data provider are the details needed to make the data provider request from the client. */
model ClientDataProviderQuery {
  ...DataProviderQuery;

  /** The Id of the service instance type that should be communicated with in order to resolve the data providers from the client given the query values. */
  @format("uuid") queryServiceInstanceType?: string;
}

/** An individual contribution made by an extension */
model Contribution {
  ...ContributionBase;

  /** List of constraints (filters) that should be applied to the availability of this contribution */
  constraints?: ContributionConstraint[];

  /** Includes is a set of contributions that should have this contribution included in their targets list. */
  includes?: string[];

  properties?: JObject;

  /** List of demanded claims in order for the user to see this contribution (like anonymous, public, member...). */
  restrictedTo?: string[];

  /** The ids of the contribution(s) that this contribution targets. (parent contributions) */
  targets?: string[];

  /** Id of the Contribution Type */
  type?: string;
}

/** Base class shared by contributions and contribution types */
model ContributionBase {
  /** Description of the contribution/type */
  description?: string;

  /** Fully qualified identifier of the contribution/type */
  id?: string;

  /** VisibleTo can be used to restrict whom can reference a given contribution/type. This value should be a list of publishers or extensions access is restricted too. Examples: 'ms' - Means only the 'ms' publisher can reference this. 'ms.vss-web' - Means only the 'vss-web' extension from the 'ms' publisher can reference this. */
  visibleTo?: string[];
}

/** Specifies a constraint that can be used to dynamically include/exclude a given contribution */
model ContributionConstraint {
  /** An optional property that can be specified to group constraints together. All constraints within a group are AND'd together (all must be evaluate to True in order for the contribution to be included). Different groups of constraints are OR'd (only one group needs to evaluate to True for the contribution to be included). */
  group?: int32;

  /** Fully qualified identifier of a shared constraint */
  id?: string;

  /** If true, negate the result of the filter (include the contribution if the applied filter returns false instead of true) */
  inverse?: boolean;

  /** Name of the IContributionFilter plugin */
  name?: string;

  properties?: JObject;

  /** Constraints can be optionally be applied to one or more of the relationships defined in the contribution. If no relationships are defined then all relationships are associated with the constraint. This means the default behaviour will eliminate the contribution from the tree completely if the constraint is applied. */
  relationships?: string[];
}

/** A query that can be issued for contribution nodes */
model ContributionNodeQuery {
  /** The contribution ids of the nodes to find. */
  contributionIds?: string[];

  dataProviderContext?: DataProviderContext;

  /** Indicator if contribution provider details should be included in the result. */
  includeProviderDetails?: boolean;

  /** Query options tpo be used when fetching ContributionNodes */
  @extension(
    "x-ms-enum",
    #{
      name: "ContributionQueryOptions",
      values: #[
        #{ value: "none", description: "" },
        #{
          value: "includeSelf",
          description: "Include the direct contributions that have the ids queried.",
        },
        #{
          value: "includeChildren",
          description: "Include the contributions that directly target the contributions queried.",
        },
        #{
          value: "includeSubTree",
          description: "Include the contributions from the entire sub-tree targeting the contributions queried.",
        },
        #{
          value: "includeAll",
          description: "Include the contribution being queried as well as all contributions that target them recursively.",
        },
        #{
          value: "ignoreConstraints",
          description: "Some callers may want the entire tree back without constraint evaluation being performed.",
        }
      ],
    }
  )
  queryOptions?:
    | "none"
    | "includeSelf"
    | "includeChildren"
    | "includeSubTree"
    | "includeAll"
    | "ignoreConstraints"
    | string;
}

/** Result of a contribution node query. Wraps the resulting contribution nodes and provider details. */
model ContributionNodeQueryResult {
  /** Map of contribution ids to corresponding node. */
  nodes?: Record<ClientContributionNode>;

  /** Map of provider ids to the corresponding provider details object. */
  providerDetails?: Record<ClientContributionProviderDetails>;
}

/** Description about a property of a contribution type */
model ContributionPropertyDescription {
  /** Description of the property */
  description?: string;

  /** Name of the property */
  name?: string;

  /** True if this property is required */
  required?: boolean;

  /** The type of value used for this property */
  @extension(
    "x-ms-enum",
    #{
      name: "ContributionPropertyType",
      values: #[
        #{ value: "unknown", description: "Contribution type is unknown (value may be anything)" },
        #{ value: "string", description: "Value is a string" },
        #{ value: "uri", description: "Value is a Uri" },
        #{ value: "guid", description: "Value is a GUID" },
        #{ value: "boolean", description: "Value is True or False" },
        #{ value: "integer", description: "Value is an integer" },
        #{ value: "double", description: "Value is a double" },
        #{ value: "dateTime", description: "Value is a DateTime object" },
        #{
          value: "dictionary",
          description: "Value is a generic Dictionary/JObject/property bag",
        },
        #{ value: "array", description: "Value is an array" },
        #{ value: "object", description: "Value is an arbitrary/custom object" }
      ],
    }
  )
  type?:
    | "unknown"
    | "string"
    | "uri"
    | "guid"
    | "boolean"
    | "integer"
    | "double"
    | "dateTime"
    | "dictionary"
    | "array"
    | "object"
    | string;
}

model ContributionProviderDetails {
  /** Friendly name for the provider. */
  displayName?: string;

  /** Unique identifier for this provider. The provider name can be used to cache the contribution data and refer back to it when looking for changes */
  name?: string;

  /** Properties associated with the provider */
  properties?: Record<string>;

  /** Version of contributions associated with this contribution provider. */
  version?: string;
}

/** A contribution type, given by a json schema */
model ContributionType {
  ...ContributionBase;

  /** Controls whether or not contributions of this type have the type indexed for queries. This allows clients to find all extensions that have a contribution of this type. NOTE: Only TrustedPartners are allowed to specify indexed contribution types. */
  indexed?: boolean;

  /** Friendly name of the contribution/type */
  name?: string;

  /** Describes the allowed properties for this contribution type */
  properties?: Record<ContributionPropertyDescription>;
}

/** Contextual information that data providers can examine when populating their data */
model DataProviderContext {
  /** Generic property bag that contains context-specific properties that data providers can use when populating their data dictionary */
  properties?: Record<{}>;
}

model DataProviderExceptionDetails {
  /** The type of the exception that was thrown. */
  exceptionType?: string;

  /** Message that is associated with the exception. */
  message?: string;

  /** The StackTrace from the exception turned into a string. */
  stackTrace?: string;
}

/** A query that can be issued for data provider data */
model DataProviderQuery {
  context?: DataProviderContext;

  /** The contribution ids of the data providers to resolve */
  contributionIds?: string[];
}

/** Result structure from calls to GetDataProviderData */
model DataProviderResult {
  /** This is the set of data providers that were requested, but either they were defined as client providers, or as remote providers that failed and may be retried by the client. */
  clientProviders?: Record<ClientDataProviderQuery>;

  /** Property bag of data keyed off of the data provider contribution id */
  data?: Record<{}>;

  /** Set of exceptions that occurred resolving the data providers. */
  exceptions?: Record<DataProviderExceptionDetails>;

  /** List of data providers resolved in the data-provider query */
  resolvedProviders?: ResolvedDataProvider[];

  /** Scope name applied to this data provider result. */
  scopeName?: string;

  /** Scope value applied to this data provider result. */
  scopeValue?: string;

  /** Property bag of shared data that was contributed to by any of the individual data providers */
  sharedData?: Record<{}>;
}

/** Data bag that any data provider can contribute to. This shared dictionary is returned in the data provider result. */
model DataProviderSharedData {}

/** Contract for handling the extension acquisition process */
model ExtensionAcquisitionRequest {
  /** How the item is being assigned */
  @extension(
    "x-ms-enum",
    #{
      name: "AcquisitionAssignmentType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "me", description: "Just assign for me" },
        #{ value: "all", description: "Assign for all users in the account" }
      ],
    }
  )
  assignmentType?: "none" | "me" | "all" | string;

  /** The id of the subscription used for purchase */
  billingId?: string;

  /** The marketplace id (publisherName.extensionName) for the item */
  itemId?: string;

  /** The type of operation, such as install, request, purchase */
  @extension(
    "x-ms-enum",
    #{
      name: "AcquisitionOperationType",
      values: #[
        #{ value: "get", description: "Not yet used" },
        #{ value: "install", description: "Install this extension into the host provided" },
        #{
          value: "buy",
          description: "Buy licenses for this extension and install into the host provided",
        },
        #{ value: "try", description: "Try this extension" },
        #{ value: "request", description: "Request this extension for installation" },
        #{ value: "none", description: "No action found" },
        #{ value: "purchaseRequest", description: "Request admins for purchasing extension" }
      ],
    }
  )
  operationType?:
    | "get"
    | "install"
    | "buy"
    | "try"
    | "request"
    | "none"
    | "purchaseRequest"
    | string;

  properties?: JObject;

  /** How many licenses should be purchased */
  quantity?: int32;
}

/** Audit log for an extension */
model ExtensionAuditLog {
  /** Collection of audit log entries */
  entries?: ExtensionAuditLogEntry[];

  /** Extension that the change was made for */
  extensionName?: string;

  /** Publisher that the extension is part of */
  publisherName?: string;
}

/** An audit log entry for an extension */
model ExtensionAuditLogEntry {
  /** Change that was made to extension */
  auditAction?: string;

  /** Date at which the change was made */
  auditDate?: utcDateTime;

  /** Extra information about the change */
  comment?: string;

  updatedBy?: IdentityRef;
}

model ExtensionAuthorization {
  @format("uuid") id?: string;
  scopes?: string[];
}

model ExtensionBadge {
  description?: string;
  imgUri?: string;
  link?: string;
}

/** Represents a single collection for extension data documents */
model ExtensionDataCollection {
  /** The name of the collection */
  collectionName?: string;

  /** A list of documents belonging to the collection */
  documents?: JObject[];

  /** The type of the collection's scope, such as Default or User */
  scopeType?: string;

  /** The value of the collection's scope, such as Current or Me */
  scopeValue?: string;
}

/** Represents a query to receive a set of extension data collections */
model ExtensionDataCollectionQuery {
  /** A list of collections to query */
  collections?: ExtensionDataCollection[];
}

model ExtensionEvent {
  extension?: PublishedExtension;

  /** The current version of the extension that was updated */
  extensionVersion?: string;

  host?: ExtensionHost;
  links?: ExtensionEventUrls;
  modifiedBy?: IdentityRef;

  /** The type of update that was made */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionUpdateType",
      values: #[
        #{ value: "installed", description: "" },
        #{ value: "uninstalled", description: "" },
        #{ value: "enabled", description: "" },
        #{ value: "disabled", description: "" },
        #{ value: "versionUpdated", description: "" },
        #{ value: "actionRequired", description: "" },
        #{ value: "actionResolved", description: "" }
      ],
    }
  )
  updateType?:
    | "installed"
    | "uninstalled"
    | "enabled"
    | "disabled"
    | "versionUpdated"
    | "actionRequired"
    | "actionResolved"
    | string;
}

/** Base class for an event callback for an extension */
model ExtensionEventCallback {
  /** The uri of the endpoint that is hit when an event occurs */
  uri?: string;
}

/** Collection of event callbacks - endpoints called when particular extension events occur. */
model ExtensionEventCallbackCollection {
  postDisable?: ExtensionEventCallback;
  postEnable?: ExtensionEventCallback;
  postInstall?: ExtensionEventCallback;
  postUninstall?: ExtensionEventCallback;
  postUpdate?: ExtensionEventCallback;
  preInstall?: ExtensionEventCallback;
  versionCheck?: ExtensionEventCallback;
}

model ExtensionEventUrls {
  ...ExtensionUrls;

  /** Url of the extension management page */
  manageExtensionsPage?: string;
}

model ExtensionFile {
  assetType?: string;
  language?: string;
  source?: string;
}

model ExtensionHost {
  @format("uuid") id?: string;
  name?: string;
}

/** Represents the component pieces of an extensions fully qualified name, along with the fully qualified name. */
model ExtensionIdentifier {
  /** The ExtensionName component part of the fully qualified ExtensionIdentifier */
  extensionName?: string;

  /** The PublisherName component part of the fully qualified ExtensionIdentifier */
  publisherName?: string;
}

/** How an extension should handle including contributions based on licensing */
model ExtensionLicensing {
  /** A list of contributions which deviate from the default licensing behavior */
  overrides?: LicensingOverride[];
}

/** Base class for extension properties which are shared by the extension manifest and the extension model */
model ExtensionManifest {
  /** Uri used as base for other relative uri's defined in extension */
  baseUri?: string;

  /** List of shared constraints defined by this extension */
  constraints?: ContributionConstraint[];

  /** List of contributions made by this extension */
  contributions?: Contribution[];

  /** List of contribution types defined by this extension */
  contributionTypes?: ContributionType[];

  /** List of explicit demands required by this extension */
  demands?: string[];

  eventCallbacks?: ExtensionEventCallbackCollection;

  /** Secondary location that can be used as base for other relative uri's defined in extension */
  fallbackBaseUri?: string;

  /** Language Culture Name set by the Gallery */
  language?: string;

  licensing?: ExtensionLicensing;

  /** Version of the extension manifest format/content */
  manifestVersion?: float64;

  /** Marketplace uri used as base for other relative uris defined in extension. Uri might be the same as BaseUri. */
  marketplaceBaseUri?: string;

  /** Default user claims applied to all contributions (except the ones which have been specified restrictedTo explicitly) to control the visibility of a contribution. */
  restrictedTo?: string[];

  /** List of all oauth scopes required by this extension */
  scopes?: string[];

  /** The ServiceInstanceType(Guid) of the VSTS service that must be available to an account in order for the extension to be installed */
  @format("uuid") serviceInstanceType?: string;
}

/** Policy with a set of permissions on extension operations */
model ExtensionPolicy {
  /** Permissions on 'Install' operation */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionPolicyFlags",
      values: #[
        #{ value: "none", description: "No permission" },
        #{ value: "private", description: "Permission on private extensions" },
        #{ value: "public", description: "Permission on public extensions" },
        #{ value: "preview", description: "Permission in extensions that are in preview" },
        #{ value: "released", description: "Permission in released extensions" },
        #{ value: "firstParty", description: "Permission in 1st party extensions" },
        #{ value: "all", description: "Mask that defines all permissions" }
      ],
    }
  )
  install?: "none" | "private" | "public" | "preview" | "released" | "firstParty" | "all" | string;

  /** Permission on 'Request' operation */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionPolicyFlags",
      values: #[
        #{ value: "none", description: "No permission" },
        #{ value: "private", description: "Permission on private extensions" },
        #{ value: "public", description: "Permission on public extensions" },
        #{ value: "preview", description: "Permission in extensions that are in preview" },
        #{ value: "released", description: "Permission in released extensions" },
        #{ value: "firstParty", description: "Permission in 1st party extensions" },
        #{ value: "all", description: "Mask that defines all permissions" }
      ],
    }
  )
  request?: "none" | "private" | "public" | "preview" | "released" | "firstParty" | "all" | string;
}

/** A request for an extension (to be installed or have a license assigned) */
model ExtensionRequest {
  /** Required message supplied if the request is rejected */
  rejectMessage?: string;

  /** Date at which the request was made */
  requestDate?: utcDateTime;

  requestedBy?: IdentityRef;

  /** Optional message supplied by the requester justifying the request */
  requestMessage?: string;

  /** Represents the state of the request */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionRequestState",
      values: #[
        #{ value: "open", description: "The request has been opened, but not yet responded to" },
        #{
          value: "accepted",
          description: "The request was accepted (extension installed or license assigned)",
        },
        #{
          value: "rejected",
          description: "The request was rejected (extension not installed or license not assigned)",
        }
      ],
    }
  )
  requestState?: "open" | "accepted" | "rejected" | string;

  /** Date at which the request was resolved */
  resolveDate?: utcDateTime;

  resolvedBy?: IdentityRef;
}

model ExtensionRequestEvent {
  extension?: PublishedExtension;
  host?: ExtensionHost;

  /** Name of the collection for which the extension was requested */
  hostName?: string;

  links?: ExtensionRequestUrls;
  request?: ExtensionRequest;

  /** The type of update that was made */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionRequestUpdateType",
      values: #[
        #{ value: "created", description: "" },
        #{ value: "approved", description: "" },
        #{ value: "rejected", description: "" },
        #{ value: "deleted", description: "" }
      ],
    }
  )
  updateType?: "created" | "approved" | "rejected" | "deleted" | string;
}

model ExtensionRequestsEvent {
  extension?: PublishedExtension;
  host?: ExtensionHost;
  links?: ExtensionRequestUrls;

  /** The extension request object */
  requests?: ExtensionRequest[];

  /** The type of update that was made */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionRequestUpdateType",
      values: #[
        #{ value: "created", description: "" },
        #{ value: "approved", description: "" },
        #{ value: "rejected", description: "" },
        #{ value: "deleted", description: "" }
      ],
    }
  )
  updateType?: "created" | "approved" | "rejected" | "deleted" | string;
}

model ExtensionRequestUrls {
  ...ExtensionUrls;

  /** Link to view the extension request */
  requestPage?: string;
}

model ExtensionShare {
  id?: string;
  isOrg?: boolean;
  name?: string;
  type?: string;
}

/** The state of an extension */
model ExtensionState {
  ...InstalledExtensionState;
  extensionName?: string;

  /** The time at which the version was last checked */
  lastVersionCheck?: utcDateTime;

  publisherName?: string;
  version?: string;
}

model ExtensionStatistic {
  statisticName?: string;
  value?: float64;
}

model ExtensionUrls {
  /** Url of the extension icon */
  extensionIcon?: string;

  /** Link to view the extension details page */
  extensionPage?: string;
}

model ExtensionVersion {
  assetUri?: string;
  badges?: ExtensionBadge[];
  fallbackAssetUri?: string;
  files?: ExtensionFile[];
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionVersionFlags",
      values: #[
        #{ value: "none", description: "No flags exist for this version." },
        #{
          value: "validated",
          description: "The Validated flag for a version means the extension version has passed validation and can be used.",
        },
        #{
          value: "prerelease",
          description: "The Prerelease flag for a version means the extension version is prerelease. This flag is runtime only.",
        },
        #{ value: "deleted", description: "This version has been deleted." }
      ],
    }
  )
  flags?: "none" | "validated" | "prerelease" | "deleted" | string;
  lastUpdated?: utcDateTime;
  properties?: {}[];
  targetPlatform?: string;
  validationResultMessage?: string;
  version?: string;
  versionDescription?: string;
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

model InstallationTarget {
  extensionVersion?: string;
  productArchitecture?: string;
  target?: string;
  targetPlatform?: string;
  targetVersion?: string;
}

/** Represents a VSTS extension along with its installation state */
model InstalledExtension {
  ...ExtensionManifest;

  /** The friendly extension id for this extension - unique for a given publisher. */
  extensionId?: string;

  /** The display name of the extension. */
  extensionName?: string;

  /** This is the set of files available from the extension. */
  files?: ExtensionFile[];

  /** Extension flags relevant to contribution consumers */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionFlags",
      values: #[
        #{
          value: "builtIn",
          description: "A built-in extension is installed for all VSTS accounts by default",
        },
        #{ value: "trusted", description: "The extension comes from a fully-trusted publisher" }
      ],
    }
  )
  flags?: "builtIn" | "trusted" | string;

  installState?: InstalledExtensionState;

  /** This represents the date/time the extensions was last updated in the gallery. This doesnt mean this version was updated the value represents changes to any and all versions of the extension. */
  lastPublished?: utcDateTime;

  /** Unique id of the publisher of this extension */
  publisherId?: string;

  /** The display name of the publisher */
  publisherName?: string;

  /** Unique id for this extension (the same id is used for all versions of a single extension) */
  @format("uuid") registrationId?: string;

  /** Version of this extension */
  version?: string;
}

model InstalledExtensionQuery {
  assetTypes?: string[];
  monikers?: ExtensionIdentifier[];
}

/** The state of an installed extension */
model InstalledExtensionState {
  /** States of an installed extension */
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionStateFlags",
      values: #[
        #{ value: "none", description: "No flags set" },
        #{ value: "disabled", description: "Extension is disabled" },
        #{ value: "builtIn", description: "Extension is a built in" },
        #{ value: "multiVersion", description: "Extension has multiple versions" },
        #{
          value: "unInstalled",
          description: "Extension is not installed. This is for builtin extensions only and can not otherwise be set.",
        },
        #{ value: "versionCheckError", description: "Error performing version check" },
        #{
          value: "trusted",
          description: "Trusted extensions are ones that are given special capabilities. These tend to come from Microsoft and can't be published by the general public. Note: BuiltIn extensions are always trusted.",
        },
        #{ value: "error", description: "Extension is currently in an error state" },
        #{
          value: "needsReauthorization",
          description: "Extension scopes have changed and the extension requires re-authorization",
        },
        #{
          value: "autoUpgradeError",
          description: "Error performing auto-upgrade. For example, if the new version has demands not supported the extension cannot be auto-upgraded.",
        },
        #{
          value: "warning",
          description: "Extension is currently in a warning state, that can cause a degraded experience. The degraded experience can be caused for example by some installation issues detected such as implicit demands not supported.",
        },
        #{
          value: "unpublished",
          description: "Extension is currently unpublished in the marketplace. Extension usage should be reviewed and removed if it is no longer needed",
        }
      ],
    }
  )
  flags?:
    | "none"
    | "disabled"
    | "builtIn"
    | "multiVersion"
    | "unInstalled"
    | "versionCheckError"
    | "trusted"
    | "error"
    | "needsReauthorization"
    | "autoUpgradeError"
    | "warning"
    | "unpublished"
    | string;

  /** List of installation issues */
  installationIssues?: InstalledExtensionStateIssue[];

  /** The time at which this installation was last updated */
  lastUpdated?: utcDateTime;
}

/** Represents an installation issue */
model InstalledExtensionStateIssue {
  /** The error message */
  message?: string;

  /** Source of the installation issue, for example 'Demands' */
  source?: string;

  /** Installation issue type (Warning, Error) */
  @extension(
    "x-ms-enum",
    #{
      name: "InstalledExtensionStateIssueType",
      values: #[
        #{
          value: "warning",
          description: "Represents an installation warning, for example an implicit demand not supported",
        },
        #{
          value: "error",
          description: "Represents an installation error, for example an explicit demand not supported",
        }
      ],
    }
  )
  type?: "warning" | "error" | string;
}

/** Represents a JSON object. */
model JObject {
  @format("JToken") item?: string;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

/** Maps a contribution to a licensing behavior */
model LicensingOverride {
  /** How the inclusion of this contribution should change based on licensing */
  @extension(
    "x-ms-enum",
    #{
      name: "ContributionLicensingBehaviorType",
      values: #[
        #{
          value: "onlyIfLicensed",
          description: "Default value - only include the contribution if the user is licensed for the extension",
        },
        #{
          value: "onlyIfUnlicensed",
          description: "Only include the contribution if the user is NOT licensed for the extension",
        },
        #{
          value: "alwaysInclude",
          description: "Always include the contribution regardless of whether or not the user is licensed for the extension",
        }
      ],
    }
  )
  behavior?: "onlyIfLicensed" | "onlyIfUnlicensed" | "alwaysInclude" | string;

  /** Fully qualified contribution id which we want to define licensing behavior for */
  id?: string;
}

model PublishedExtension {
  categories?: string[];
  @extension(
    "x-ms-enum",
    #{
      name: "ExtensionDeploymentTechnology",
      values: #[
        #{ value: "exe", description: "" },
        #{ value: "msi", description: "" },
        #{ value: "vsix", description: "" },
        #{ value: "referralLink", description: "" }
      ],
    }
  )
  deploymentType?: "exe" | "msi" | "vsix" | "referralLink" | string;
  displayName?: string;
  @format("uuid") extensionId?: string;
  extensionName?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "PublishedExtensionFlags",
      values: #[
        #{ value: "none", description: "No flags exist for this extension." },
        #{
          value: "disabled",
          description: "The Disabled flag for an extension means the extension can't be changed and won't be used by consumers. The disabled flag is managed by the service and can't be supplied by the Extension Developers.",
        },
        #{
          value: "builtIn",
          description: "BuiltIn Extension are available to all Tenants. An explicit registration is not required. This attribute is reserved and can't be supplied by Extension Developers. BuiltIn extensions are by definition Public. There is no need to set the public flag for extensions marked BuiltIn.",
        },
        #{
          value: "validated",
          description: "This extension has been validated by the service. The extension meets the requirements specified. This attribute is reserved and can't be supplied by the Extension Developers. Validation is a process that ensures that all contributions are well formed. They meet the requirements defined by the contribution type they are extending. Note this attribute will be updated asynchronously as the extension is validated by the developer of the contribution type. There will be restricted access to the extension while this process is performed.",
        },
        #{
          value: "trusted",
          description: "Trusted extensions are ones that are given special capabilities. These tend to come from Microsoft and can't be published by the general public. Note: BuiltIn extensions are always trusted.",
        },
        #{
          value: "paid",
          description: "The Paid flag indicates that the commerce can be enabled for this extension. Publisher needs to setup Offer/Pricing plan in Azure. If Paid flag is set and a corresponding Offer is not available, the extension will automatically be marked as Preview. If the publisher intends to make the extension Paid in the future, it is mandatory to set the Preview flag. This is currently available only for VSTS extensions only.",
        },
        #{
          value: "public",
          description: "This extension registration is public, making its visibility open to the public. This means all tenants have the ability to install this extension. Without this flag the extension will be private and will need to be shared with the tenants that can install it.",
        },
        #{
          value: "multiVersion",
          description: "This extension has multiple versions active at one time and version discovery should be done using the defined 'Version Discovery' protocol to determine the version available to a specific user or tenant. @TODO: Link to Version Discovery Protocol.",
        },
        #{
          value: "system",
          description: "The system flag is reserved, and cant be used by publishers.",
        },
        #{
          value: "preview",
          description: "The Preview flag indicates that the extension is still under preview (not yet of 'release' quality). These extensions may be decorated differently in the gallery and may have different policies applied to them.",
        },
        #{
          value: "unpublished",
          description: "The Unpublished flag indicates that the extension can't be installed/downloaded. Users who have installed such an extension can continue to use the extension.",
        },
        #{
          value: "trial",
          description: "The Trial flag indicates that the extension is in Trial version. The flag is right now being used only with respect to Visual Studio extensions.",
        },
        #{
          value: "locked",
          description: "The Locked flag indicates that extension has been locked from Marketplace. Further updates/acquisitions are not allowed on the extension until this is present. This should be used along with making the extension private/unpublished.",
        },
        #{
          value: "hidden",
          description: "This flag is set for extensions we want to hide from Marketplace home and search pages. This will be used to override the exposure of builtIn flags.",
        },
        #{
          value: "deleted",
          description: "This flag is set for extensions that are marked as deleted. The deleted flag is managed by the service and can't be supplied by the Extension Developers.",
        }
      ],
    }
  )
  flags?:
    | "none"
    | "disabled"
    | "builtIn"
    | "validated"
    | "trusted"
    | "paid"
    | "public"
    | "multiVersion"
    | "system"
    | "preview"
    | "unpublished"
    | "trial"
    | "locked"
    | "hidden"
    | "deleted"
    | string;
  installationTargets?: InstallationTarget[];
  lastUpdated?: utcDateTime;
  longDescription?: string;

  /** Check if Extension is in conflict list or not. Taking as String and not as boolean because we don't want end customer to see this flag and by making it Boolean it is coming as false for all the cases. */
  presentInConflictList?: string;

  /** Date on which the extension was first uploaded. */
  publishedDate?: utcDateTime;

  publisher?: PublisherFacts;

  /** Date on which the extension first went public. */
  releaseDate?: utcDateTime;

  sharedWith?: ExtensionShare[];
  shortDescription?: string;
  statistics?: ExtensionStatistic[];
  tags?: string[];
  versions?: ExtensionVersion[];
}

/** High-level information about the publisher, like id's and names */
model PublisherFacts {
  displayName?: string;
  domain?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "PublisherFlags",
      values: #[
        #{
          value: "unChanged",
          description: "This should never be returned, it is used to represent a publisher who's flags haven't changed during update calls.",
        },
        #{ value: "none", description: "No flags exist for this publisher." },
        #{
          value: "disabled",
          description: "The Disabled flag for a publisher means the publisher can't be changed and won't be used by consumers, this extends to extensions owned by the publisher as well. The disabled flag is managed by the service and can't be supplied by the Extension Developers.",
        },
        #{
          value: "verified",
          description: "A verified publisher is one that Microsoft has done some review of and ensured the publisher meets a set of requirements. The requirements to become a verified publisher are not listed here. They can be found in public documentation (TBD).",
        },
        #{
          value: "certified",
          description: "A Certified publisher is one that is Microsoft verified and in addition meets a set of requirements for its published extensions. The requirements to become a certified publisher are not listed here. They can be found in public documentation (TBD).",
        },
        #{
          value: "serviceFlags",
          description: "This is the set of flags that can't be supplied by the developer and is managed by the service itself.",
        }
      ],
    }
  )
  flags?: "unChanged" | "none" | "disabled" | "verified" | "certified" | "serviceFlags" | string;
  isDomainVerified?: boolean;
  @format("uuid") publisherId?: string;
  publisherName?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** A request for an extension (to be installed or have a license assigned) */
model RequestedExtension {
  /** The unique name of the extension */
  extensionName?: string;

  /** A list of each request for the extension */
  extensionRequests?: ExtensionRequest[];

  /** DisplayName of the publisher that owns the extension being published. */
  publisherDisplayName?: string;

  /** Represents the Publisher of the requested extension */
  publisherName?: string;

  /** The total number of requests for an extension */
  requestCount?: int32;
}

/** Entry for a specific data provider's resulting data */
model ResolvedDataProvider {
  /** The total time the data provider took to resolve its data (in milliseconds) */
  duration?: float32;

  error?: string;
  id?: string;
}

model Scope {
  description?: string;
  title?: string;
  value?: string;
}

/** Information about the extension */
model SupportedExtension {
  /** Unique Identifier for this extension */
  extension?: string;

  /** Unique Identifier for this publisher */
  publisher?: string;

  /** Supported version for this extension */
  version?: string;
}

/** Represents the extension policy applied to a given user */
model UserExtensionPolicy {
  /** User display name that this policy refers to */
  displayName?: string;

  permissions?: ExtensionPolicy;

  /** User id that this policy refers to */
  userId?: string;
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

/** A collection of `InstalledExtension` as returned by Azure DevOps. */
model InstalledExtensionList {
  count?: int32;
  value?: InstalledExtension[];
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

interface InstalledExtensions {
  /** List the installed extensions in the account / project collection. */
  @tag("Installed Extensions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "installedExtensions")
  @extension("x-ms-vss-method", "GetInstalledExtensions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/extensionmanagement/installedextensions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** If true (the default), include disabled extensions in the results. */
    @query(#{ explode: true }) includeDisabledExtensions?: boolean,

    /** If true, include installed extensions with errors. */
    @query(#{ explode: true }) includeErrors?: boolean,

    /** Determines which files are returned in the files array. Provide the wildcard '*' to return all files, or a colon separated list to retrieve files with specific asset types. */
    @format("array (string)") @query(#{ explode: true }) assetTypes?: string,

    @query(#{ explode: true }) includeInstallationIssues?: boolean,
    ...Parameters.`api-Version-preview`.`2`,
  ): InstalledExtensionList;

  /** Update an installed extension. Typically this API is used to enable or disable an extension. */
  @tag("Installed Extensions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "installedExtensions")
  @extension("x-ms-vss-method", "UpdateInstalledExtension")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/extensionmanagement/installedextensions")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: InstalledExtension,
  ): InstalledExtension;

  /** Uninstall the specified extension from the account / project collection. */
  @tag("Installed Extensions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "installedExtensionsByName")
  @extension("x-ms-vss-method", "UninstallExtensionByName")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/extensionmanagement/installedextensionsbyname/{publisherName}/{extensionName}")
  @delete
  UninstallExtensionByName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name of the publisher. Example: 'fabrikam'. */
    @path publisherName: string,

    /** Name of the extension. Example: 'ops-tools'. */
    @path extensionName: string,

    @query(#{ explode: true }) reason?: string,
    @query(#{ explode: true }) reasonCode?: string,
    ...Parameters.`api-Version-preview`.`2`,
  ): OkResponse;

  /** Get an installed extension by its publisher and extension name. */
  @tag("Installed Extensions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "installedExtensionsByName")
  @extension("x-ms-vss-method", "GetInstalledExtensionByName")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/extensionmanagement/installedextensionsbyname/{publisherName}/{extensionName}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name of the publisher. Example: 'fabrikam'. */
    @path publisherName: string,

    /** Name of the extension. Example: 'ops-tools'. */
    @path extensionName: string,

    /** Determines which files are returned in the files array. Provide the wildcard '*' to return all files, or a colon separated list to retrieve files with specific asset types. */
    @format("array (string)") @query(#{ explode: true }) assetTypes?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): InstalledExtension;

  /** Install the specified extension into the account / project collection. */
  @tag("Installed Extensions")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "installedExtensionsByName")
  @extension("x-ms-vss-method", "InstallExtensionByName")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/extensionmanagement/installedextensionsbyname/{publisherName}/{extensionName}/{version}")
  @post
  InstallExtensionByName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Name of the publisher. Example: 'fabrikam'. */
    @path publisherName: string,

    /** Name of the extension. Example: 'ops-tools'. */
    @path extensionName: string,

    @extension("x-ms-required", false) @path version: string,
    ...Parameters.`api-Version-preview`.`2`,
  ): InstalledExtension;
}
