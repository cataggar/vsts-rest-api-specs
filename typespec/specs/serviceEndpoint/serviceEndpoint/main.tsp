import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "ServiceEndpoint" })
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
namespace ServiceEndpoint;

model AadOauthTokenRequest {
  refresh?: boolean;
  resource?: string;
  tenantId?: string;
  token?: string;
}

model AadOauthTokenResult {
  accessToken?: string;
  refreshTokenCache?: string;
}

model AuthConfiguration {
  ...OAuthConfiguration;

  /** Gets or sets parameters contained in configuration object. */
  parameters?: Record<Parameter>;
}

/** Specifies the authentication scheme to be used for authentication. */
model AuthenticationSchemeReference {
  /** Gets or sets the key and value of the fields used for authentication. */
  inputs?: Record<string>;

  /** Gets or sets the type of authentication scheme of an endpoint. */
  type?: string;
}

/** Represents the header of the REST request. */
model AuthorizationHeader {
  /** Gets or sets the name of authorization header. */
  name?: string;

  /** Gets or sets the value of authorization header. */
  value?: string;
}

model AzureAppService {
  id?: string;
  name?: string;
}

model AzureKeyVaultPermission {
  ...AzureResourcePermission;
  vault?: string;
}

model AzureManagedIdentity {
  clientId?: string;
  id?: string;
  name?: string;
}

/** Azure Management Group */
model AzureManagementGroup {
  /** Display name of azure management group */
  displayName?: string;

  /** Id of azure management group */
  id?: string;

  /** Azure management group name */
  name?: string;

  /** Id of tenant from which azure management group belogs */
  tenantId?: string;
}

/** Azure management group query result */
model AzureManagementGroupQueryResult {
  /** Error message in case of an exception */
  errorMessage?: string;

  /** List of azure management groups */
  value?: AzureManagementGroup[];
}

model AzureMLWorkspace {
  id?: string;
  location?: string;
  name?: string;
}

model AzurePermission {
  provisioned?: boolean;
  resourceProvider?: string;
}

model AzureResourcePermission {
  ...AzurePermission;
  resourceGroup?: string;
}

model AzureRoleAssignmentPermission {
  ...AzurePermission;
  @format("uuid") roleAssignmentId?: string;
}

model AzureSpnOperationStatus {
  @extension(
    "x-ms-enum",
    #{
      name: "SpnEndpointErrorCode",
      values: #[
        #{
          value: "appRegistrationFailed",
          description: "Indicates whether user does not have required permissions to register the app in Entra or WIF is disabled.",
        }
      ],
    }
  )
  errorCode?: "appRegistrationFailed";
  severity?: string;
  state?: string;
  statusMessage?: string;
}

model AzureSubscription {
  displayName?: string;
  subscriptionId?: string;
  subscriptionTenantId?: string;
  subscriptionTenantName?: string;
}

model AzureSubscriptionQueryResult {
  errorMessage?: string;
  value?: AzureSubscription[];
}

/** Specifies the client certificate to be used for the endpoint request. */
model ClientCertificate {
  /** Gets or sets the value of client certificate. */
  value?: string;
}

/** Specifies the data sources for this endpoint. */
model DataSource {
  authenticationScheme?: AuthenticationSchemeReference;

  /** Gets or sets the pagination format supported by this data source(ContinuationToken/SkipTop). */
  callbackContextTemplate?: string;

  /** Gets or sets the template to check if subsequent call is needed. */
  callbackRequiredTemplate?: string;

  /** Gets or sets the endpoint url of the data source. */
  endpointUrl?: string;

  /** Gets or sets the authorization headers of the request. */
  headers?: AuthorizationHeader[];

  /** Gets or sets the initial value of the query params. */
  initialContextTemplate?: string;

  /** Gets or sets the name of the data source. */
  name?: string;

  /** Gets or sets the request content of the endpoint request. */
  requestContent?: string;

  /** Gets or sets the request method of the endpoint request. */
  requestVerb?: string;

  /** Gets or sets the resource url of the endpoint request. */
  resourceUrl?: string;

  /** Gets or sets the result selector to filter the response of the endpoint request. */
  resultSelector?: string;
}

/** Represents the data source binding of the endpoint. */
model DataSourceBinding {
  ...DataSourceBindingBase;
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

/** Represents details of the service endpoint data source. */
model DataSourceDetails {
  /** Gets or sets the data source name. */
  dataSourceName?: string;

  /** Gets or sets the data source url. */
  dataSourceUrl?: string;

  /** Gets or sets the request headers. */
  headers?: AuthorizationHeader[];

  /** Gets or sets the initialization context used for the initial call to the data source */
  initialContextTemplate?: string;

  /** Gets the parameters of data source. */
  parameters?: Record<string>;

  /** Gets or sets the data source request content. */
  requestContent?: string;

  /** Gets or sets the data source request verb. Get/Post are the only implemented types */
  requestVerb?: string;

  /** Gets or sets the resource url of data source. */
  resourceUrl?: string;

  /** Gets or sets the result selector. */
  resultSelector?: string;
}

/** Represents the details of the input on which a given input is dependent. */
model DependencyBinding {
  /** Gets or sets the value of the field on which url is dependent. */
  key?: string;

  /** Gets or sets the corresponding value of url. */
  value?: string;
}

/** Represents the dependency data for the endpoint inputs. */
model DependencyData {
  /** Gets or sets the category of dependency data. */
  input?: string;

  /** Gets or sets the key-value pair to specify properties and their values. */
  map?: {}[];
}

/** Represents the inputs on which any given input is dependent. */
model DependsOn {
  /** Gets or sets the ID of the field on which URL's value is dependent. */
  input?: string;

  /** Gets or sets key-value pair containing other's field value and corresponding url value. */
  map?: DependencyBinding[];
}

/** Represents the authorization used for service endpoint. */
model EndpointAuthorization {
  /** Gets or sets the parameters for the selected authorization scheme. */
  parameters?: Record<string>;

  /** Gets or sets the scheme used for service endpoint authentication. */
  scheme?: string;
}

model EndpointOperationStatus {
  state?: string;
  statusMessage?: string;
}

/** Represents url of the service endpoint. */
model EndpointUrl {
  dependsOn?: DependsOn;

  /** Gets or sets the display name of service endpoint url. */
  displayName?: string;

  /** Gets or sets the format of the url. */
  format?: string;

  /** Gets or sets the help text of service endpoint url. */
  helpText?: string;

  /** Gets or sets the visibility of service endpoint url. */
  isVisible?: string;

  /** Gets or sets the value of service endpoint url. */
  value?: string;
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

/** Specifies the public url of the help documentation. */
model HelpLink {
  /** Gets or sets the help text. */
  text?: string;

  /** Gets or sets the public url of the help documentation. */
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

/** Represents a JSON object. */
model JObject {
  item?: JToken;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

/** Represents an abstract JSON token. */
model JToken {
  first?: JToken;

  /** Gets a value indicating whether this token has child tokens. */
  hasValues?: boolean;

  item?: JToken;
  last?: JToken;
  next?: JToken;

  /** Gets or sets the parent. */
  @format("JContainer") parent?: string;

  /** Gets the path of the JSON token. */
  path?: string;

  previous?: JToken;
  root?: JToken;

  /** Gets the node type for this JToken. */
  @format("JTokenType") type?: string;
}

model OAuth2TokenResult {
  accessToken?: string;
  error?: string;
  errorDescription?: string;
  expiresIn?: string;
  issuedAt?: string;
  refreshToken?: string;
  scope?: string;
}

model OAuthConfiguration {
  /** Gets or sets the ClientId */
  clientId?: string;

  /** Gets or sets the ClientSecret */
  clientSecret?: string;

  createdBy?: IdentityRef;

  /** Gets or sets the time when config was created. */
  createdOn?: utcDateTime;

  /** Gets or sets the type of the endpoint. */
  endpointType?: string;

  /** Gets or sets the unique identifier of this field */
  @format("uuid") id?: string;

  modifiedBy?: IdentityRef;

  /** Gets or sets the time when variable group was modified */
  modifiedOn?: utcDateTime;

  /** Gets or sets the name */
  name?: string;

  /** Gets or sets the Url */
  url?: string;
}

model OAuthConfigurationParams {
  /** Gets or sets the ClientId */
  clientId?: string;

  /** Gets or sets the ClientSecret */
  clientSecret?: string;

  /** Gets or sets the type of the endpoint. */
  endpointType?: string;

  /** Gets or sets the name */
  name?: string;

  /** Gets or sets the Url */
  url?: string;
}

model OAuthEndpointStatus {
  state?: string;
  statusMessage?: string;
}

model Parameter {
  isSecret?: boolean;
  value?: string;
}

model ProjectReference {
  @format("uuid") id?: string;
  name?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** Specify the properties for refreshing the endpoint authentication object being queried */
model RefreshAuthenticationParameters {
  /** EndpointId which needs new authentication params */
  @format("uuid") endpointId?: string;

  /** Scope of the token requested. For GitHub marketplace apps, scope contains repository Ids */
  scope?: int32[];

  /** The requested endpoint authentication should be valid for _ minutes. Authentication params will not be refreshed if the token contained in endpoint already has active token. */
  tokenValidityInMinutes?: int16;
}

/** Represents template to transform the result data. */
model ResultTransformationDetails {
  /** Gets or sets the template for callback parameters */
  callbackContextTemplate?: string;

  /** Gets or sets the template to decide whether to callback or not */
  callbackRequiredTemplate?: string;

  /** Gets or sets the template for result transformation. */
  resultTemplate?: string;
}

/** Represents an endpoint which may be used by an orchestration job. */
model ServiceEndpoint {
  administratorsGroup?: IdentityRef;
  authorization?: EndpointAuthorization;
  createdBy?: IdentityRef;

  /** Gets or sets the date, when the Service endpoint has been created. */
  creationDate?: utcDateTime;

  data?: Record<string>;

  /** Gets or sets the description of endpoint. */
  description?: string;

  /** This is a deprecated field. */
  @format("uuid") groupScopeId?: string;

  /** Gets or sets the identifier of this endpoint. */
  @format("uuid") id?: string;

  /** Whether service endpoint is disabled or not. */
  isDisabled?: boolean;

  /** Indicates whether service endpoint is outdated or not. */
  isOutdated?: boolean;

  /** EndPoint state indicator */
  isReady?: boolean;

  /** Indicates whether service endpoint is shared with other projects or not. */
  isShared?: boolean;

  /** Gets or sets the date, when the Service endpoint has been modified. */
  modificationDate?: utcDateTime;

  modifiedBy?: IdentityRef;

  /** Gets the project-specific friendly name of the endpoint, as defined in the name field of ServiceEndpointProjectReferences. */
  name?: string;

  operationStatus?: JObject;

  /** Owner of the endpoint Supported values are 'library', 'agentcloud' */
  owner?: string;

  readersGroup?: IdentityRef;

  /** All other project references where the service endpoint is shared. */
  serviceEndpointProjectReferences?: ServiceEndpointProjectReference[];

  /** Service Tree ID */
  serviceManagementReference?: string;

  /** Gets or sets the type of the endpoint. */
  type?: string;

  /** Gets or sets the url of the endpoint. */
  url?: string;
}

/** Represents the authentication scheme used to authenticate the endpoint. */
model ServiceEndpointAuthenticationScheme {
  /** Gets or sets the authorization headers of service endpoint authentication scheme. */
  authorizationHeaders?: AuthorizationHeader[];

  /** Gets or sets the Authorization url required to authenticate using OAuth2 */
  authorizationUrl?: string;

  /** Gets or sets the certificates of service endpoint authentication scheme. */
  clientCertificates?: ClientCertificate[];

  /** Gets or sets the data source bindings of the endpoint. */
  dataSourceBindings?: DataSourceBinding[];

  /** Gets or sets the display name for the service endpoint authentication scheme. */
  displayName?: string;

  /** Gets or sets the input descriptors for the service endpoint authentication scheme. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets the properties of service endpoint authentication scheme. */
  properties?: Record<string>;

  /** Gets or sets whether this auth scheme requires OAuth2 configuration or not. */
  requiresOAuth2Configuration?: boolean;

  /** Gets or sets the scheme for service endpoint authentication. */
  scheme?: string;
}

/** Represents details of the service endpoint. */
model ServiceEndpointDetails {
  authorization?: EndpointAuthorization;

  /** Gets or sets the data of service endpoint. */
  data?: Record<string>;

  /** Gets or sets the type of service endpoint. */
  type?: string;

  /** Gets or sets the connection url of service endpoint. */
  url?: string;
}

model ServiceEndpointEvent {
  authorization?: EndpointAuthorization;
  @format("uuid") id?: string;
  name?: string;
  projectIds?: string[];
  type?: string;
}

/** Represents service endpoint execution data. */
model ServiceEndpointExecutionData {
  definition?: ServiceEndpointExecutionOwner;

  /** Gets the finish time of service endpoint execution. */
  finishTime?: utcDateTime;

  /** Gets the Id of service endpoint execution data. */
  id?: int64;

  owner?: ServiceEndpointExecutionOwner;

  /** Gets the additional details about the instance that used the service endpoint. */
  ownerDetails?: string;

  /** Gets the plan type of service endpoint execution data. */
  planType?: string;

  /** Gets the result of service endpoint execution. */
  @extension(
    "x-ms-enum",
    #{
      name: "ServiceEndpointExecutionResult",
      values: #[
        #{ value: "succeeded", description: "'Service endpoint request succeeded." },
        #{
          value: "succeededWithIssues",
          description: "'Service endpoint request succeeded but with some issues.",
        },
        #{ value: "failed", description: "'Service endpoint request failed." },
        #{ value: "canceled", description: "'Service endpoint request was cancelled." },
        #{ value: "skipped", description: "'Service endpoint request was skipped." },
        #{ value: "abandoned", description: "'Service endpoint request was abandoned." }
      ],
    }
  )
  result?: "succeeded" | "succeededWithIssues" | "failed" | "canceled" | "skipped" | "abandoned";

  /** Gets the start time of service endpoint execution. */
  startTime?: utcDateTime;
}

/** Represents execution owner of the service endpoint. */
model ServiceEndpointExecutionOwner {
  _links?: ReferenceLinks;

  /** Gets or sets the Id of service endpoint execution owner. */
  id?: int32;

  /** Gets or sets the name of service endpoint execution owner. */
  name?: string;
}

/** Represents the details of service endpoint execution. */
model ServiceEndpointExecutionRecord {
  data?: ServiceEndpointExecutionData;

  /** Gets the Id of service endpoint. */
  @format("uuid") endpointId?: string;
}

model ServiceEndpointExecutionRecordsInput {
  data?: ServiceEndpointExecutionData;
  endpointIds?: string[];
}

model ServiceEndpointOAuthConfigurationReference {
  @format("uuid") configurationId?: string;
  @format("uuid") serviceEndpointId?: string;
  @format("uuid") serviceEndpointProjectId?: string;
}

model ServiceEndpointProjectReference {
  /** Gets or sets description of the service endpoint. */
  description?: string;

  /** Gets or sets name of the service endpoint. */
  name?: string;

  projectReference?: ProjectReference;
}

model ServiceEndpointRequest {
  dataSourceDetails?: DataSourceDetails;
  resultTransformationDetails?: ResultTransformationDetails;
  serviceEndpointDetails?: ServiceEndpointDetails;
}

/** Represents result of the service endpoint request. */
model ServiceEndpointRequestResult {
  /** Gets or sets the activity id of the service endpoint request result. */
  @format("uuid") activityId?: string;

  /** Gets or sets the parameters used to make subsequent calls to the data source */
  callbackContextParameters?: Record<string>;

  /** Gets or sets the flat that decides if another call to the data source is to be made */
  callbackRequired?: boolean;

  /** Gets or sets the error message of the service endpoint request result. */
  errorMessage?: string;

  result?: JToken;

  /** Gets or sets the status code of the service endpoint request result. */
  @extension(
    "x-ms-enum",
    #{
      name: "HttpStatusCode",
      values: #[
        #{ value: "continue", description: "" },
        #{ value: "switchingProtocols", description: "" },
        #{ value: "ok", description: "" },
        #{ value: "created", description: "" },
        #{ value: "accepted", description: "" },
        #{ value: "nonAuthoritativeInformation", description: "" },
        #{ value: "noContent", description: "" },
        #{ value: "resetContent", description: "" },
        #{ value: "partialContent", description: "" },
        #{ value: "multipleChoices", description: "" },
        #{ value: "ambiguous", description: "" },
        #{ value: "movedPermanently", description: "" },
        #{ value: "moved", description: "" },
        #{ value: "found", description: "" },
        #{ value: "redirect", description: "" },
        #{ value: "seeOther", description: "" },
        #{ value: "redirectMethod", description: "" },
        #{ value: "notModified", description: "" },
        #{ value: "useProxy", description: "" },
        #{ value: "unused", description: "" },
        #{ value: "temporaryRedirect", description: "" },
        #{ value: "redirectKeepVerb", description: "" },
        #{ value: "badRequest", description: "" },
        #{ value: "unauthorized", description: "" },
        #{ value: "paymentRequired", description: "" },
        #{ value: "forbidden", description: "" },
        #{ value: "notFound", description: "" },
        #{ value: "methodNotAllowed", description: "" },
        #{ value: "notAcceptable", description: "" },
        #{ value: "proxyAuthenticationRequired", description: "" },
        #{ value: "requestTimeout", description: "" },
        #{ value: "conflict", description: "" },
        #{ value: "gone", description: "" },
        #{ value: "lengthRequired", description: "" },
        #{ value: "preconditionFailed", description: "" },
        #{ value: "requestEntityTooLarge", description: "" },
        #{ value: "requestUriTooLong", description: "" },
        #{ value: "unsupportedMediaType", description: "" },
        #{ value: "requestedRangeNotSatisfiable", description: "" },
        #{ value: "expectationFailed", description: "" },
        #{ value: "upgradeRequired", description: "" },
        #{ value: "internalServerError", description: "" },
        #{ value: "notImplemented", description: "" },
        #{ value: "badGateway", description: "" },
        #{ value: "serviceUnavailable", description: "" },
        #{ value: "gatewayTimeout", description: "" },
        #{ value: "httpVersionNotSupported", description: "" }
      ],
    }
  )
  statusCode?:
    | "continue"
    | "switchingProtocols"
    | "ok"
    | "created"
    | "accepted"
    | "nonAuthoritativeInformation"
    | "noContent"
    | "resetContent"
    | "partialContent"
    | "multipleChoices"
    | "ambiguous"
    | "movedPermanently"
    | "moved"
    | "found"
    | "redirect"
    | "seeOther"
    | "redirectMethod"
    | "notModified"
    | "useProxy"
    | "unused"
    | "temporaryRedirect"
    | "redirectKeepVerb"
    | "badRequest"
    | "unauthorized"
    | "paymentRequired"
    | "forbidden"
    | "notFound"
    | "methodNotAllowed"
    | "notAcceptable"
    | "proxyAuthenticationRequired"
    | "requestTimeout"
    | "conflict"
    | "gone"
    | "lengthRequired"
    | "preconditionFailed"
    | "requestEntityTooLarge"
    | "requestUriTooLong"
    | "unsupportedMediaType"
    | "requestedRangeNotSatisfiable"
    | "expectationFailed"
    | "upgradeRequired"
    | "internalServerError"
    | "notImplemented"
    | "badGateway"
    | "serviceUnavailable"
    | "gatewayTimeout"
    | "httpVersionNotSupported";
}

/** Represents the details of service endpoint execution. */
model ServiceEndpointTokenResult {
  /** Gets the access token */
  accessToken?: string;
}

/** Represents type of the service endpoint. */
model ServiceEndpointType {
  /** Authentication scheme of service endpoint type. */
  authenticationSchemes?: ServiceEndpointAuthenticationScheme[];

  /** Data sources of service endpoint type. */
  dataSources?: DataSource[];

  /** Dependency data of service endpoint type. */
  dependencyData?: DependencyData[];

  /** Gets or sets the description of service endpoint type. */
  description?: string;

  /** Gets or sets the display name of service endpoint type. */
  displayName?: string;

  endpointUrl?: EndpointUrl;
  helpLink?: HelpLink;

  /** Gets or sets the help text shown at the endpoint create dialog. */
  helpMarkDown?: string;

  /** Gets or sets the icon url of service endpoint type. */
  iconUrl?: string;

  /** Input descriptor of service endpoint type. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets visibility parameter for the list of endpoint types. */
  isHidden?: boolean;

  /** Gets or sets the name of service endpoint type. */
  name?: string;

  /** Trusted hosts of a service endpoint type. */
  trustedHosts?: string[];

  /** Gets or sets the ui contribution id of service endpoint type. */
  uiContributionId?: string;
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

/** Creates a new service endpoint */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "CreateServiceEndpoint")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/endpoints")
@post
op Endpoints_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  ...Parameters.`api-Version-preview`.`4`,

  /** Service endpoint to create */
  @body body: ServiceEndpoint,
): ServiceEndpoint;

/** Update the service endpoints. */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "UpdateServiceEndpoints")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/endpoints")
@put
op `Endpoints_Update Service Endpoints`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  ...Parameters.`api-Version-preview`.`4`,

  /** Names of the service endpoints to update. */
  @body body: ServiceEndpoint[],
): Body<ServiceEndpoint[]>;

/** Delete a service endpoint */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "DeleteServiceEndpoint")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/endpoints/{endpointId}")
@delete
op Endpoints_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Endpoint Id of endpoint to delete */
  @format("uuid") @path endpointId: string,

  /** project Ids from which endpoint needs to be deleted */
  @format("array (string)") @query(#{ explode: true }) projectIds: string,

  /** delete the spn created by endpoint */
  @query(#{ explode: true }) deep?: boolean,

  ...Parameters.`api-Version-preview`.`4`,
): OkResponse;

/** Share service endpoint across projects */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "ShareServiceEndpoint")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/endpoints/{endpointId}")
@patch
op `Endpoints_Share Service Endpoint`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Endpoint Id of the endpoint to share */
  @format("uuid") @path endpointId: string,

  ...Parameters.`api-Version-preview`.`4`,

  /** Project reference details of the target project */
  @body body: ServiceEndpointProjectReference[],
): OkResponse;

/** Update the service endpoint */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "UpdateServiceEndpoint")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/endpoints/{endpointId}")
@put
op `Endpoints_Update Service Endpoint`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Endpoint Id of the endpoint to update */
  @format("uuid") @path endpointId: string,

  /** operation type */
  @query(#{ explode: true }) operation?: string,

  ...Parameters.`api-Version-preview`.`4`,

  /** Updated data for the endpoint */
  @body body: ServiceEndpoint,
): ServiceEndpoint;

/** Get service endpoint types. */
@tag("Types")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "types")
@extension("x-ms-vss-method", "GetServiceEndpointTypes")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/types")
@get
op `Types_Get Service Endpoint Types`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Type of service endpoint. */
  @query(#{ explode: true }) type?: string,

  /** Scheme of service endpoint. */
  @query(#{ explode: true }) scheme?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<ServiceEndpointType[]>;

/** Get service endpoint types with passed types filter. */
@tag("Types")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "types")
@extension("x-ms-vss-method", "GetFilteredServiceEndpointTypes")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/serviceendpoint/types")
@post
op `Types_Get Filtered Service Endpoint Types`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Filter to limit returned types */
  @body body: string[],
): Body<ServiceEndpointType[]>;

/** Get service endpoint execution records. */
@tag("Executionhistory")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "executionhistory")
@extension("x-ms-vss-method", "GetServiceEndpointExecutionRecords")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/serviceendpoint/{endpointId}/executionhistory")
@get
op Executionhistory_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Id of the service endpoint. */
  @format("uuid") @path endpointId: string,

  /** Number of service endpoint execution records to get. */
  @query(#{ explode: true }) top?: int32,

  /** A continuation token, returned by a previous call to this method, that can be used to return the next set of records */
  @query(#{ explode: true }) continuationToken?: int64,

  ...Parameters.`api-Version-preview`.`1`,
): Body<ServiceEndpointExecutionRecord[]>;

/** Use ExecuteServiceEndpointRequest API Instead */
@tag("Endpointproxy")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "endpointproxy")
@extension("x-ms-vss-method", "QueryServiceEndpoint")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/serviceendpoint/endpointproxy")
@post
op Endpointproxy_Query(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Describes the data source to fetch. */
  @body body: DataSourceBinding,
): Body<string[]>;

/** Get the service endpoints by name. */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "GetServiceEndpointsByNames")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/serviceendpoint/endpoints")
@get
op `Endpoints_Get Service Endpoints By Names`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Names of the service endpoints. */
  @format("array (string)") @query(#{ explode: true }) endpointNames: string,

  /** Type of the service endpoints. */
  @query(#{ explode: true }) type?: string,

  /** Authorization schemes used for service endpoints. */
  @format("array (string)") @query(#{ explode: true }) authSchemes?: string,

  /** Owner for service endpoints. */
  @query(#{ explode: true }) owner?: string,

  /** Failed flag for service endpoints. */
  @query(#{ explode: true }) includeFailed?: boolean,

  /** Flag to include more details for service endpoints. This is for internal use only and the flag will be treated as false for all other requests */
  @query(#{ explode: true }) includeDetails?: boolean,

  ...Parameters.`api-Version-preview`.`4`,
): Body<ServiceEndpoint[]>;

/** Gets the service endpoints and patch new authorization parameters */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "GetServiceEndpointsWithRefreshedAuthentication")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/serviceendpoint/endpoints")
@post
op `Endpoints_Get Service Endpoints With Refreshed Authentication`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Ids of the service endpoints. */
  @format("array (uuid)") @query(#{ explode: true }) endpointIds: string,

  ...Parameters.`api-Version-preview`.`4`,

  /** Scope, Validity of Token requested. */
  @body body: RefreshAuthenticationParameters[],
): Body<ServiceEndpoint[]>;

/** Get the service endpoint details. */
@tag("Endpoints")
@extension("x-ms-docs-override-version", "7.2-preview.4")
@extension("x-ms-vss-resource", "endpoints")
@extension("x-ms-vss-method", "GetServiceEndpointDetails")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/serviceendpoint/endpoints/{endpointId}")
@get
op Endpoints_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Id of the service endpoint. */
  @format("uuid") @path endpointId: string,

  /** Action filter for the service connection. It specifies the action which can be performed on the service connection. */
  @extension(
    "x-ms-enum",
    #{
      name: "ServiceEndpointActionFilter",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "manage", description: "" },
        #{ value: "use", description: "" },
        #{ value: "view", description: "" }
      ],
    }
  )
  @query(#{ explode: true })
  actionFilter?: "none" | "manage" | "use" | "view",

  /** Flag to include confidential details of service endpoint. This is for internal use only. */
  @query(#{ explode: true }) loadConfidentialData?: boolean,

  ...Parameters.`api-Version-preview`.`4`,
): ServiceEndpoint;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `4` {
      /** Version of the API to use. This should be set to '7.2-preview.4' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
