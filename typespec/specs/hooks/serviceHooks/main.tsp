import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "ServiceHooks" })
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
namespace ServiceHooks;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Defines the data contract of a consumer. */
model Consumer {
  _links?: ReferenceLinks;

  /** Gets this consumer's actions. */
  actions?: ConsumerAction[];

  /** Gets or sets this consumer's authentication type. */
  @extension(
    "x-ms-enum",
    #{
      name: "AuthenticationType",
      values: #[
        #{ value: "none", description: "No authentication is required." },
        #{ value: "oAuth", description: "OAuth authentication." },
        #{ value: "external", description: "Externally-configured authentication." }
      ],
    }
  )
  authenticationType?: "none" | "oAuth" | "external";

  /** Gets or sets this consumer's localized description. */
  description?: string;

  externalConfiguration?: ExternalConfigurationDescriptor;

  /** Gets or sets this consumer's identifier. */
  id?: string;

  /** Gets or sets this consumer's image URL, if any. */
  imageUrl?: string;

  /** Gets or sets this consumer's information URL, if any. */
  informationUrl?: string;

  /** Gets or sets this consumer's input descriptors. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets this consumer's localized name. */
  name?: string;

  /** The url for this resource */
  url?: string;
}

/** Defines the data contract of a consumer action. */
model ConsumerAction {
  _links?: ReferenceLinks;

  /** Gets or sets the flag indicating if resource version can be overridden when creating or editing a subscription. */
  allowResourceVersionOverride?: boolean;

  /** Gets or sets the identifier of the consumer to which this action belongs. */
  consumerId?: string;

  /** Gets or sets this action's localized description. */
  description?: string;

  /** Gets or sets this action's identifier. */
  id?: string;

  /** Gets or sets this action's input descriptors. */
  inputDescriptors?: InputDescriptor[];

  /** Gets or sets this action's localized name. */
  name?: string;

  /** Gets or sets this action's supported event identifiers. */
  supportedEventTypes?: string[];

  /** Gets or sets this action's supported resource versions. */
  supportedResourceVersions?: Record<string[]>;

  /** The url for this resource */
  url?: string;
}

/** Encapsulates the properties of an event. */
model Event {
  /** Gets or sets the UTC-based date and time that this event was created. */
  createdDate?: utcDateTime;

  detailedMessage?: FormattedEventMessage;

  /** Gets or sets the type of this event. */
  eventType?: string;

  /** Gets or sets the unique identifier of this event. */
  @format("uuid") id?: string;

  message?: FormattedEventMessage;

  /** Gets or sets the identifier of the publisher that raised this event. */
  publisherId?: string;

  /** Gets or sets the data associated with this event. */
  resource?: {};

  /** Gets or sets the resource containers. */
  resourceContainers?: Record<ResourceContainer>;

  /** Gets or sets the version of the data associated with this event. */
  resourceVersion?: string;

  sessionToken?: SessionToken;
}

/** Describes a type of event */
model EventTypeDescriptor {
  /** A localized description of the event type */
  description?: string;

  /** A unique id for the event type */
  id?: string;

  /** Event-specific inputs */
  inputDescriptors?: InputDescriptor[];

  /** A localized friendly name for the event type */
  name?: string;

  /** A unique id for the publisher of this event type */
  publisherId?: string;

  /** Supported versions for the event's resource payloads. */
  supportedResourceVersions?: string[];

  /** The url for this resource */
  url?: string;
}

/** Describes how to configure a subscription that is managed externally. */
model ExternalConfigurationDescriptor {
  /** Url of the site to create this type of subscription. */
  createSubscriptionUrl?: string;

  /** The name of an input property that contains the URL to edit a subscription. */
  editSubscriptionPropertyName?: string;

  /** True if the external configuration applies only to hosted. */
  hostedOnly?: boolean;
}

/** Provides different formats of an event message */
model FormattedEventMessage {
  /** Gets or sets the html format of the message */
  html?: string;

  /** Gets or sets the markdown format of the message */
  markdown?: string;

  /** Gets or sets the raw text of the message */
  text?: string;
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

/** Defines a filter for subscription inputs. The filter matches a set of inputs if any (one or more) of the groups evaluates to true. */
model InputFilter {
  /** Groups of input filter expressions. This filter matches a set of inputs if any (one or more) of the groups evaluates to true. */
  conditions?: InputFilterCondition[];
}

/** An expression which can be applied to filter a list of subscription inputs */
model InputFilterCondition {
  /** Whether or not to do a case sensitive match */
  caseSensitive?: boolean;

  /** The Id of the input to filter on */
  inputId?: string;

  /** The 'expected' input value to compare with the actual input value */
  inputValue?: string;

  /** The operator applied between the expected and actual input value */
  @extension(
    "x-ms-enum",
    #{
      name: "InputFilterOperator",
      values: #[#{ value: "equals", description: "" }, #{ value: "notEquals", description: "" }],
    }
  )
  operator?: "equals" | "notEquals";
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

model InputValuesQuery {
  currentValues?: Record<string>;

  /** The input values to return on input, and the result from the consumer on output. */
  inputValues?: InputValues[];

  /** Subscription containing information about the publisher/consumer and the current input values */
  resource?: {};
}

/** Defines the data contract of the result of processing an event for a subscription. */
model Notification {
  /** Gets or sets date and time that this result was created. */
  createdDate?: utcDateTime;

  details?: NotificationDetails;

  /** The event id associated with this notification */
  @format("uuid") eventId?: string;

  /** The notification id */
  id?: int64;

  /** Gets or sets date and time that this result was last modified. */
  modifiedDate?: utcDateTime;

  /** Result of the notification */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationResult",
      values: #[
        #{ value: "pending", description: "The notification has not yet completed" },
        #{ value: "succeeded", description: "The notification was sent successfully" },
        #{
          value: "failed",
          description: "The notification failed to be sent successfully to the consumer",
        },
        #{ value: "filtered", description: "The notification was filtered by the Delivery Job" }
      ],
    }
  )
  result?: "pending" | "succeeded" | "failed" | "filtered";

  /** Status of the notification */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationStatus",
      values: #[
        #{ value: "queued", description: "The notification has been queued" },
        #{
          value: "processing",
          description: "The notification has been dequeued and has begun processing.",
        },
        #{
          value: "requestInProgress",
          description: "The consumer action has processed the notification. The request is in progress.",
        },
        #{
          value: "queuedForRetry",
          description: "The notification failed and is queued for retry.",
        },
        #{ value: "completed", description: "The request completed" }
      ],
    }
  )
  status?: "queued" | "processing" | "requestInProgress" | "queuedForRetry" | "completed";

  /** The subscriber Id associated with this notification. This is the last identity who touched in the subscription. In case of test notifications it can be the tester if the subscription is not created yet. */
  @format("uuid") subscriberId?: string;

  /** The subscription id associated with this notification */
  @format("uuid") subscriptionId?: string;
}

/** Defines the data contract of notification details. */
model NotificationDetails {
  /** Gets or sets the time that this notification was completed (response received from the consumer) */
  completedDate?: utcDateTime;

  /** Gets or sets this notification detail's consumer action identifier. */
  consumerActionId?: string;

  /** Gets or sets this notification detail's consumer identifier. */
  consumerId?: string;

  /** Gets or sets this notification detail's consumer inputs. */
  consumerInputs?: Record<string>;

  /** Gets or sets the time that this notification was dequeued for processing */
  dequeuedDate?: utcDateTime;

  /** Gets or sets this notification detail's error detail. */
  errorDetail?: string;

  /** Gets or sets this notification detail's error message. */
  errorMessage?: string;

  event?: Event;

  /** Gets or sets this notification detail's event type. */
  eventType?: string;

  /** Gets or sets the next delivery retry time for this notification */
  nextRetryTime?: utcDateTime;

  /** Gets or sets the time that this notification was finished processing (just before the request is sent to the consumer) */
  processedDate?: utcDateTime;

  /** Gets or sets this notification detail's publisher identifier. */
  publisherId?: string;

  /** Gets or sets this notification detail's publisher inputs. */
  publisherInputs?: Record<string>;

  /** Gets or sets the time that this notification was queued (created) */
  queuedDate?: utcDateTime;

  /** Gets or sets this notification detail's request. */
  request?: string;

  /** Number of requests attempted to be sent to the consumer */
  requestAttempts?: int32;

  /** Duration of the request to the consumer in seconds */
  requestDuration?: float64;

  /** Gets or sets this notification detail's response. */
  response?: string;

  /** Number of delivery retries attempted for this notification */
  retryCount?: int16;
}

/** Summary of a particular result and count. */
model NotificationResultsSummaryDetail {
  /** Count of notification sent out with a matching result. */
  notificationCount?: int32;

  /** Result of the notification */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationResult",
      values: #[
        #{ value: "pending", description: "The notification has not yet completed" },
        #{ value: "succeeded", description: "The notification was sent successfully" },
        #{
          value: "failed",
          description: "The notification failed to be sent successfully to the consumer",
        },
        #{ value: "filtered", description: "The notification was filtered by the Delivery Job" }
      ],
    }
  )
  result?: "pending" | "succeeded" | "failed" | "filtered";
}

/** Defines a query for service hook notifications. */
model NotificationsQuery {
  /** The subscriptions associated with the notifications returned from the query */
  associatedSubscriptions?: Subscription[];

  /** If true, we will return all notification history for the query provided; otherwise, the summary is returned. */
  includeDetails?: boolean;

  /** Optional maximum date at which the notification was created */
  maxCreatedDate?: utcDateTime;

  /** Optional maximum number of overall results to include */
  maxResults?: int32;

  /** Optional maximum number of results for each subscription. Only takes effect when a list of subscription ids is supplied in the query. */
  maxResultsPerSubscription?: int32;

  /** Optional minimum date at which the notification was created */
  minCreatedDate?: utcDateTime;

  /** Optional publisher id to restrict the results to */
  publisherId?: string;

  /** Results from the query */
  results?: Notification[];

  /** Optional notification result type to filter results to */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationResult",
      values: #[
        #{ value: "pending", description: "The notification has not yet completed" },
        #{ value: "succeeded", description: "The notification was sent successfully" },
        #{
          value: "failed",
          description: "The notification failed to be sent successfully to the consumer",
        },
        #{ value: "filtered", description: "The notification was filtered by the Delivery Job" }
      ],
    }
  )
  resultType?: "pending" | "succeeded" | "failed" | "filtered";

  /** Optional notification status to filter results to */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationStatus",
      values: #[
        #{ value: "queued", description: "The notification has been queued" },
        #{
          value: "processing",
          description: "The notification has been dequeued and has begun processing.",
        },
        #{
          value: "requestInProgress",
          description: "The consumer action has processed the notification. The request is in progress.",
        },
        #{
          value: "queuedForRetry",
          description: "The notification failed and is queued for retry.",
        },
        #{ value: "completed", description: "The request completed" }
      ],
    }
  )
  status?: "queued" | "processing" | "requestInProgress" | "queuedForRetry" | "completed";

  /** Optional list of subscription ids to restrict the results to */
  subscriptionIds?: string[];

  /** Summary of notifications - the count of each result type (success, fail, ..). */
  summary?: NotificationSummary[];
}

/** Summary of the notifications for a subscription. */
model NotificationSummary {
  /** The notification results for this particular subscription. */
  results?: NotificationResultsSummaryDetail[];

  /** The subscription id associated with this notification */
  @format("uuid") subscriptionId?: string;
}

/** Defines the data contract of an event publisher. */
model Publisher {
  _links?: ReferenceLinks;

  /** Gets this publisher's localized description. */
  description?: string;

  /** Gets this publisher's identifier. */
  id?: string;

  /** Publisher-specific inputs */
  inputDescriptors?: InputDescriptor[];

  /** Gets this publisher's localized name. */
  name?: string;

  /** The service instance type of the first party publisher. */
  serviceInstanceType?: string;

  /** Gets this publisher's supported event types. */
  supportedEvents?: EventTypeDescriptor[];

  /** The url for this resource */
  url?: string;
}

/** Wrapper around an event which is being published */
model PublisherEvent {
  /** Add key/value pairs which will be stored with a published notification in the SH service DB. This key/value pairs are for diagnostic purposes only and will have not effect on the delivery of a notification. */
  diagnostics?: Record<string>;

  event?: Event;

  /** Gets or sets flag for filtered events */
  isFilteredEvent?: boolean;

  /** Additional data that needs to be sent as part of notification to complement the Resource data in the Event */
  notificationData?: Record<string>;

  /** Gets or sets the array of older supported resource versions. */
  otherResourceVersions?: VersionedResource[];

  /** Optional publisher-input filters which restricts the set of subscriptions which are triggered by the event */
  publisherInputFilters?: InputFilter[];

  subscription?: Subscription;
}

/** Defines a query for service hook publishers. */
model PublishersQuery {
  /** Optional list of publisher ids to restrict the results to */
  publisherIds?: string[];

  /** Filter for publisher inputs */
  publisherInputs?: Record<string>;

  /** Results from the query */
  results?: Publisher[];
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** The base class for all resource containers, i.e. Account, Collection, Project */
model ResourceContainer {
  /** Gets or sets the container's base URL, i.e. the URL of the host (collection, application, or deployment) containing the container resource. */
  baseUrl?: string;

  /** Gets or sets the container's specific Id. */
  @format("uuid") id?: string;

  /** Gets or sets the container's name. */
  name?: string;

  /** Gets or sets the container's REST API URL. */
  url?: string;
}

/** Represents a session token to be attached in Events for Consumer actions that need it. */
model SessionToken {
  /** The error message in case of error */
  error?: string;

  /** The access token */
  token?: string;

  /** The expiration date in UTC */
  validTo?: utcDateTime;
}

/** Encapsulates an event subscription. */
model Subscription {
  _links?: ReferenceLinks;
  actionDescription?: string;
  consumerActionId?: string;
  consumerId?: string;

  /** Consumer input values */
  consumerInputs?: Record<string>;

  createdBy?: IdentityRef;
  createdDate?: utcDateTime;
  eventDescription?: string;
  eventType?: string;
  @format("uuid") id?: string;
  lastProbationRetryDate?: utcDateTime;

  /** Date of the last successful notification delivery attempt. */
  lastSuccessfulAttemptDate?: utcDateTime;

  modifiedBy?: IdentityRef;
  modifiedDate?: utcDateTime;
  probationRetries?: bytes;
  publisherId?: string;

  /** Publisher input values */
  publisherInputs?: Record<string>;

  resourceVersion?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionStatus",
      values: #[
        #{ value: "enabled", description: "The subscription is enabled." },
        #{
          value: "onProbation",
          description: "The subscription is temporarily on probation by the system.",
        },
        #{ value: "disabledByUser", description: "The subscription is disabled by a user." },
        #{ value: "disabledBySystem", description: "The subscription is disabled by the system." },
        #{
          value: "disabledByInactiveIdentity",
          description: "The subscription is disabled because the owner is inactive or is missing permissions.",
        }
      ],
    }
  )
  status?:
    | "enabled"
    | "onProbation"
    | "disabledByUser"
    | "disabledBySystem"
    | "disabledByInactiveIdentity";
  subscriber?: IdentityRef;
  url?: string;
}

/** Contains all the diagnostics settings for a subscription. */
model SubscriptionDiagnostics {
  deliveryResults?: SubscriptionTracing;
  deliveryTracing?: SubscriptionTracing;
  evaluationTracing?: SubscriptionTracing;
}

/** Query for obtaining information about the possible/allowed values for one or more subscription inputs */
model SubscriptionInputValuesQuery {
  /** The input values to return on input, and the result from the consumer on output. */
  inputValues?: InputValues[];

  /** The scope at which the properties to query belong */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionInputScope",
      values: #[
        #{
          value: "publisher",
          description: "An input defined and consumed by a Publisher or Publisher Event Type",
        },
        #{
          value: "consumer",
          description: "An input defined and consumed by a Consumer or Consumer Action",
        }
      ],
    }
  )
  scope?: "publisher" | "consumer";

  subscription?: Subscription;
}

/** Defines a query for service hook subscriptions. */
model SubscriptionsQuery {
  /** Optional consumer action id to restrict the results to (null for any) */
  consumerActionId?: string;

  /** Optional consumer id to restrict the results to (null for any) */
  consumerId?: string;

  /** Filter for subscription consumer inputs */
  consumerInputFilters?: InputFilter[];

  /** Optional event type id to restrict the results to (null for any) */
  eventType?: string;

  /** Optional publisher id to restrict the results to (null for any) */
  publisherId?: string;

  /** Filter for subscription publisher inputs */
  publisherInputFilters?: InputFilter[];

  /** Results from the query */
  results?: Subscription[];

  /** Optional subscriber filter. */
  @format("uuid") subscriberId?: string;
}

/** Data controlling a single diagnostic setting for a subscription. */
model SubscriptionTracing {
  /** Indicates whether the diagnostic tracing is enabled or not. */
  enabled?: boolean;

  /** Trace until the specified end date. */
  endDate?: utcDateTime;

  /** The maximum number of result details to trace. */
  maxTracedEntries?: int32;

  /** The date and time tracing started. */
  startDate?: utcDateTime;

  /** Trace until remaining count reaches 0. */
  tracedEntries?: int32;
}

/** Parameters to update diagnostics settings for a subscription. */
model UpdateSubscripitonDiagnosticsParameters {
  deliveryResults?: UpdateSubscripitonTracingParameters;
  deliveryTracing?: UpdateSubscripitonTracingParameters;
  evaluationTracing?: UpdateSubscripitonTracingParameters;
}

/** Parameters to update a specific diagnostic setting. */
model UpdateSubscripitonTracingParameters {
  /** Indicates whether to enable to disable the diagnostic tracing. */
  enabled?: boolean;
}

/** Encapsulates the resource version and its data or reference to the compatible version. Only one of the two last fields should be not null. */
model VersionedResource {
  /** Gets or sets the reference to the compatible version. */
  compatibleWith?: string;

  /** Gets or sets the resource data. */
  resource?: {};

  /** Gets or sets the version of the resource data. */
  resourceVersion?: string;
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
  }
}

interface Consumers {
  /** Get a list of available service hook consumer services. Optionally filter by consumers that support at least one event type from the specific publisher. */
  @tag("Consumers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "consumers")
  @extension("x-ms-vss-method", "ListConsumers")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/consumers")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @query(#{ explode: true }) publisherId?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Consumer[]>;

  /** Get a specific consumer service. Optionally filter out consumer actions that do not support any event types for the specified publisher. */
  @tag("Consumers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "consumers")
  @extension("x-ms-vss-method", "GetConsumer")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/consumers/{consumerId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a consumer. */
    @path consumerId: string,

    @query(#{ explode: true }) publisherId?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): Consumer;

  /** Get a list of consumer actions for a specific consumer. */
  @tag("Consumers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "actions")
  @extension("x-ms-vss-method", "ListConsumerActions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/consumers/{consumerId}/actions")
  @get
  ListConsumerActions(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a consumer. */
    @path consumerId: string,

    @query(#{ explode: true }) publisherId?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<ConsumerAction[]>;

  /** Get details about a specific consumer action. */
  @tag("Consumers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "actions")
  @extension("x-ms-vss-method", "GetConsumerAction")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/consumers/{consumerId}/actions/{consumerActionId}")
  @get
  GetConsumerAction(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a consumer. */
    @path consumerId: string,

    /** ID for a consumerActionId. */
    @path consumerActionId: string,

    @query(#{ explode: true }) publisherId?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): ConsumerAction;
}

interface Notifications {
  /** Query for notifications. A notification includes details about the event, the request to and the response from the consumer service. */
  @tag("Notifications")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "notificationsQuery")
  @extension("x-ms-vss-method", "QueryNotifications")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/notificationsquery")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: NotificationsQuery,
  ): NotificationsQuery;

  /** Get a list of notifications for a specific subscription. A notification includes details about the event, the request to and the response from the consumer service. */
  @tag("Notifications")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "notifications")
  @extension("x-ms-vss-method", "GetNotifications")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}/notifications")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a subscription. */
    @format("uuid") @path subscriptionId: string,

    /** Maximum number of notifications to return. Default is **100**. */
    @query(#{ explode: true }) maxResults?: int32,

    /** Get only notifications with this status. */
    @extension(
      "x-ms-enum",
      #{
        name: "NotificationStatus",
        values: #[
          #{ value: "queued", description: "The notification has been queued" },
          #{
            value: "processing",
            description: "The notification has been dequeued and has begun processing.",
          },
          #{
            value: "requestInProgress",
            description: "The consumer action has processed the notification. The request is in progress.",
          },
          #{
            value: "queuedForRetry",
            description: "The notification failed and is queued for retry.",
          },
          #{ value: "completed", description: "The request completed" }
        ],
      }
    )
    @query(#{ explode: true })
    status?: "queued" | "processing" | "requestInProgress" | "queuedForRetry" | "completed",

    /** Get only notifications with this result type. */
    @extension(
      "x-ms-enum",
      #{
        name: "NotificationResult",
        values: #[
          #{ value: "pending", description: "The notification has not yet completed" },
          #{ value: "succeeded", description: "The notification was sent successfully" },
          #{
            value: "failed",
            description: "The notification failed to be sent successfully to the consumer",
          },
          #{ value: "filtered", description: "The notification was filtered by the Delivery Job" }
        ],
      }
    )
    @query(#{ explode: true })
    result?: "pending" | "succeeded" | "failed" | "filtered",

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Notification[]>;

  /** Get a specific notification for a subscription. */
  @tag("Notifications")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "notifications")
  @extension("x-ms-vss-method", "GetNotification")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}/notifications/{notificationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a subscription. */
    @format("uuid") @path subscriptionId: string,

    @path notificationId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): Notification;

  /** Sends a test notification. This is useful for verifying the configuration of an updated or new service hooks subscription. */
  @tag("Notifications")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testNotifications")
  @extension("x-ms-vss-method", "CreateTestNotification")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/testnotifications")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Only allow testing with real data in existing subscriptions. */
    @query(#{ explode: true }) useRealData?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: Notification,
  ): Notification;
}

interface Publishers {
  /** Get a list of publishers. */
  @tag("Publishers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "publishers")
  @extension("x-ms-vss-method", "ListPublishers")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/publishers")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Publisher[]>;

  /** Get a specific service hooks publisher. */
  @tag("Publishers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "publishers")
  @extension("x-ms-vss-method", "GetPublisher")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/publishers/{publisherId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a publisher. */
    @path publisherId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Publisher;

  /** Get the event types for a specific publisher. */
  @tag("Publishers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "eventTypes")
  @extension("x-ms-vss-method", "ListEventTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/publishers/{publisherId}/eventtypes")
  @get
  ListEventTypes(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a publisher. */
    @path publisherId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<EventTypeDescriptor[]>;

  /** Get a specific event type. */
  @tag("Publishers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "eventTypes")
  @extension("x-ms-vss-method", "GetEventType")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/publishers/{publisherId}/eventtypes/{eventTypeId}")
  @get
  GetEventType(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a publisher. */
    @path publisherId: string,

    @path eventTypeId: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): EventTypeDescriptor;

  @tag("Publishers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "publisherInputValuesQuery")
  @extension("x-ms-vss-method", "QueryInputValues")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/publishers/{publisherId}/inputValuesQuery")
  @post
  QueryInputValues(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path publisherId: string,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: InputValuesQuery,
  ): InputValuesQuery;

  /** Query for service hook publishers. */
  @tag("Publishers")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "publishersQuery")
  @extension("x-ms-vss-method", "QueryPublishers")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/publishersquery")
  @post
  QueryPublishers(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: PublishersQuery,
  ): PublishersQuery;
}

interface Subscriptions {
  /** Get a list of subscriptions. */
  @tag("Subscriptions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "subscriptions")
  @extension("x-ms-vss-method", "ListSubscriptions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a subscription. */
    @query(#{ explode: true }) publisherId?: string,

    /** The event type to filter on (if any). */
    @query(#{ explode: true }) eventType?: string,

    /** ID for a consumer. */
    @query(#{ explode: true }) consumerId?: string,

    /** ID for a consumerActionId. */
    @query(#{ explode: true }) consumerActionId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Subscription[]>;

  /** Create a subscription. */
  @tag("Subscriptions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "subscriptions")
  @extension("x-ms-vss-method", "CreateSubscription")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Subscription to be created. */
    @body body: Subscription,
  ): Subscription;

  /** Delete a specific service hooks subscription. */
  @tag("Subscriptions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "subscriptions")
  @extension("x-ms-vss-method", "DeleteSubscription")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a subscription. */
    @format("uuid") @path subscriptionId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a specific service hooks subscription. */
  @tag("Subscriptions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "subscriptions")
  @extension("x-ms-vss-method", "GetSubscription")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID for a subscription. */
    @format("uuid") @path subscriptionId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Subscription;

  /** Update a subscription. <param name='subscriptionId'>ID for a subscription that you wish to update.</param> */
  @tag("Subscriptions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "subscriptions")
  @extension("x-ms-vss-method", "ReplaceSubscription")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}")
  @put
  ReplaceSubscription(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @extension("x-ms-required", false)
    @format("uuid")
    @path
    subscriptionId: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: Subscription,
  ): Subscription;

  /** Query for service hook subscriptions. */
  @tag("Subscriptions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "subscriptionsQuery")
  @extension("x-ms-vss-method", "CreateSubscriptionsQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptionsquery")
  @post
  CreateSubscriptionsQuery(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: SubscriptionsQuery,
  ): SubscriptionsQuery;
}

interface Diagnostics {
  @tag("Diagnostics")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "diagnostics")
  @extension("x-ms-vss-method", "GetSubscriptionDiagnostics")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}/diagnostics")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path subscriptionId: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): SubscriptionDiagnostics;

  @tag("Diagnostics")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "diagnostics")
  @extension("x-ms-vss-method", "UpdateSubscriptionDiagnostics")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/hooks/subscriptions/{subscriptionId}/diagnostics")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @path subscriptionId: string,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: UpdateSubscripitonDiagnosticsParameters,
  ): SubscriptionDiagnostics;
}
