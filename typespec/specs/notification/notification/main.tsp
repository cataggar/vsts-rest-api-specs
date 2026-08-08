import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Notification" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server(
  "https://{service}dev.azure.com",
  "",
  {
    service: string = "unknown",
  }
)
@server(
  "https://{service}dev.azure.com/",
  "",
  {
    /** The service to which this request is directed. */
    service: string = "none",
  }
)
namespace Notification;

model ActorFilter {
  ...RoleBasedFilter;
}

model ActorNotificationReason {
  ...NotificationReason;
  matchedRoles?: string[];
}

/** Artifact filter options. Used in 'follow' subscriptions. */
model ArtifactFilter {
  ...BaseSubscriptionFilter;
  artifactId?: string;
  artifactType?: string;
  artifactUri?: string;
}

model BaseSubscriptionFilter {
  eventType?: string;
  type?: string;
}

model BatchNotificationOperation {
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationOperation",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "suspendUnprocessed", description: "" }
      ],
    }
  )
  notificationOperation?: "none" | "suspendUnprocessed";
  notificationQueryConditions?: NotificationQueryCondition[];
}

model BlockFilter {
  ...RoleBasedFilter;
}

model BlockSubscriptionChannel {
  type?: string;
}

model DiagnosticIdentity {
  displayName?: string;
  emailAddress?: string;
  @format("uuid") id?: string;
}

model DiagnosticNotification {
  eventId?: int32;
  eventType?: string;
  id?: int64;
  messages?: NotificationDiagnosticLogMessage[];
  recipients?: Record<DiagnosticRecipient>;
  result?: string;
  stats?: Record<int32>;
  subscriptionId?: string;
}

model DiagnosticRecipient {
  recipient?: DiagnosticIdentity;
  status?: string;
}

model EmailHtmlSubscriptionChannel {
  ...SubscriptionChannelWithAddress;
}

model EmailPlaintextSubscriptionChannel {
  ...SubscriptionChannelWithAddress;
}

/** Defines an 'actor' for an event. */
model EventActor {
  /** Required: This is the identity of the user for the specified role. */
  @format("uuid") id?: string;

  /** Required: The event specific name of a role. */
  role?: string;
}

model EventBacklogStatus {
  captureTime?: utcDateTime;
  @format("uuid") jobId?: string;
  lastEventBatchStartTime?: utcDateTime;
  lastEventProcessedTime?: utcDateTime;
  lastJobBatchStartTime?: utcDateTime;
  lastJobProcessedTime?: utcDateTime;
  oldestPendingEventTime?: utcDateTime;
  publisher?: string;
  unprocessedEvents?: int32;
}

model EventBatch {
  @format("TimeSpan") endTime?: string;
  eventCounts?: Record<int32>;
  eventIds?: string;
  notificationCounts?: Record<int32>;
  @format("TimeSpan") preProcessEndTime?: string;
  @format("TimeSpan") preProcessStartTime?: string;
  @format("TimeSpan") processEndTime?: string;
  @format("TimeSpan") processStartTime?: string;
  @format("TimeSpan") startTime?: string;
  subscriptionCounts?: Record<int32>;
}

model EventProcessingLog {
  ...NotificationJobDiagnosticLog;
  batches?: EventBatch[];
  matcherResults?: MatcherResult[];
}

/** Defines a scope for an event. */
model EventScope {
  /** Required: This is the identity of the scope for the type. */
  @format("uuid") id?: string;

  /** Optional: The display name of the scope */
  name?: string;

  /** Required: The event specific type of a scope. */
  type?: string;
}

/** Encapsulates events result properties. It defines the total number of events used and the number of matched events. */
model EventsEvaluationResult {
  /** Count of events evaluated. */
  count?: int32;

  /** Count of matched events. */
  matchedCount?: int32;
}

/** A transform request specify the properties of a notification event to be transformed. */
model EventTransformRequest {
  /** Event payload. */
  eventPayload?: string;

  /** Event type. */
  eventType?: string;

  /** System inputs. */
  systemInputs?: Record<string>;
}

/** Result of transforming a notification event. */
model EventTransformResult {
  /** Transformed html content. */
  content?: string;

  /** Calculated data. */
  data?: {};

  /** Calculated system inputs. */
  systemInputs?: Record<string>;
}

model ExpressionFilter {
  ...BaseSubscriptionFilter;
  criteria?: ExpressionFilterModel;
}

/** Subscription Filter Clause represents a single clause in a subscription filter e.g. If the subscription has the following criteria 'Project Name = [Current Project] AND Assigned To = [Me] it will be represented as two Filter Clauses Clause 1: Index = 1, Logical Operator: NULL , FieldName = 'Project Name', Operator = '=', Value = '[Current Project]' Clause 2: Index = 2, Logical Operator: 'AND' , FieldName = 'Assigned To' , Operator = '=', Value = '[Me]' */
model ExpressionFilterClause {
  fieldName?: string;

  /** The order in which this clause appeared in the filter query */
  index?: int32;

  /** Logical Operator 'AND', 'OR' or NULL (only for the first clause in the filter) */
  logicalOperator?: string;

  operator?: string;
  value?: string;
}

/** Represents a hierarchy of SubscritionFilterClauses that have been grouped together through either adding a group in the WebUI or using parethesis in the Subscription condition string */
model ExpressionFilterGroup {
  /** The index of the last FilterClause in this group */
  end?: int32;

  /** Level of the group, since groups can be nested for each nested group the level will increase by 1 */
  level?: int32;

  /** The index of the first FilterClause in this group */
  start?: int32;
}

/** This class represents the Subscription Filter associated with a subscription in a user readable format e.g. 'filterModel':{ 'clauses':[ { 'logicalOperator':'', 'fieldName':'PortfolioProject', 'operator':'=', 'value':'\@\@MyProjectName\@\@', 'index':1 } ], 'groups':[ ], 'maxGroupLevel':0 } */
model ExpressionFilterModel {
  /** Flat list of clauses in this subscription */
  clauses?: ExpressionFilterClause[];

  /** Grouping of clauses in the subscription */
  groups?: ExpressionFilterGroup[];

  /** Max depth of the Subscription tree */
  maxGroupLevel?: int32;
}

model FieldInputValues {
  ...InputValues;
  operators?: bytes[];
}

model FieldValuesQuery {
  ...InputValuesQuery;
  scope?: string;
}

model GeneratedNotification {
  recipients?: DiagnosticIdentity[];
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

model GroupSubscriptionChannel {
  ...SubscriptionChannelWithAddress;
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

/** Abstraction interface for the diagnostic log. Primarily for deserialization. */
model INotificationDiagnosticLog {
  /** Identifier used for correlating to other diagnostics that may have been recorded elsewhere. */
  @format("uuid") activityId?: string;

  /** Description of what subscription or notification job is being logged. */
  description?: string;

  /** Time the log ended. */
  endTime?: utcDateTime;

  /** Unique instance identifier. */
  @format("uuid") id?: string;

  /** Type of information being logged. */
  logType?: string;

  /** List of log messages. */
  messages?: NotificationDiagnosticLogMessage[];

  /** Dictionary of log properties and settings for the job. */
  properties?: Record<string>;

  /** This identifier depends on the logType. For notification jobs, this will be the job Id. For subscription tracing, this will be a special root Guid with the subscription Id encoded. */
  @format("uuid") source?: string;

  /** Time the log started. */
  startTime?: utcDateTime;
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

model ISubscriptionChannel {
  type?: string;
}

model ISubscriptionFilter {
  eventType?: string;
  type?: string;
}

model MatcherResult {
  matcher?: string;
  stats?: Record<Record<unknown>>;
}

model MessageQueueSubscriptionChannel {
  type?: string;
}

model NotificationAdminSettings {
  /** The default group delivery preference for groups in this collection */
  @extension(
    "x-ms-enum",
    #{
      name: "DefaultGroupDeliveryPreference",
      values: #[
        #{
          value: "noDelivery",
          description: "Do not send notifications by default. Note: notifications can still be delivered to subscribers, for example via a custom subscription.",
        },
        #{
          value: "eachMember",
          description: "Deliver notifications to each member of the group representing the subscriber. Only applicable when the subscriber is a group.",
        }
      ],
    }
  )
  defaultGroupDeliveryPreference?: "noDelivery" | "eachMember";
}

model NotificationAdminSettingsUpdateParameters {
  @extension(
    "x-ms-enum",
    #{
      name: "DefaultGroupDeliveryPreference",
      values: #[
        #{
          value: "noDelivery",
          description: "Do not send notifications by default. Note: notifications can still be delivered to subscribers, for example via a custom subscription.",
        },
        #{
          value: "eachMember",
          description: "Deliver notifications to each member of the group representing the subscriber. Only applicable when the subscriber is a group.",
        }
      ],
    }
  )
  defaultGroupDeliveryPreference?: "noDelivery" | "eachMember";
}

model NotificationBacklogStatus {
  captureTime?: utcDateTime;
  channel?: string;
  @format("uuid") jobId?: string;
  lastJobBatchStartTime?: utcDateTime;
  lastJobProcessedTime?: utcDateTime;
  lastNotificationBatchStartTime?: utcDateTime;
  lastNotificationProcessedTime?: utcDateTime;
  oldestPendingNotificationTime?: utcDateTime;
  publisher?: string;

  /** Null status is unprocessed */
  status?: string;

  unprocessedNotifications?: int32;
}

model NotificationBatch {
  @format("TimeSpan") endTime?: string;
  notificationCount?: int32;
  notificationIds?: string;
  problematicNotifications?: DiagnosticNotification[];
  @format("TimeSpan") startTime?: string;
}

model NotificationDeliveryLog {
  ...NotificationJobDiagnosticLog;
  batches?: NotificationBatch[];
}

/** Abstract base class for all of the diagnostic logs. */
model NotificationDiagnosticLog {
  /** Identifier used for correlating to other diagnostics that may have been recorded elsewhere. */
  @format("uuid") activityId?: string;

  description?: string;
  endTime?: utcDateTime;
  errors?: int32;

  /** Unique instance identifier. */
  @format("uuid") id?: string;

  logType?: string;
  messages?: NotificationDiagnosticLogMessage[];
  properties?: Record<string>;

  /** This identifier depends on the logType. For notification jobs, this will be the job Id. For subscription tracing, this will be a special root Guid with the subscription Id encoded. */
  @format("uuid") source?: string;

  startTime?: utcDateTime;
  warnings?: int32;
}

model NotificationDiagnosticLogMessage {
  /** Corresponds to .Net TraceLevel enumeration */
  level?: int32;

  message?: string;
  @format("TimeSpan") time?: string;
}

model NotificationEventBacklogStatus {
  eventBacklogStatus?: EventBacklogStatus[];
  notificationBacklogStatus?: NotificationBacklogStatus[];
}

/** Encapsulates the properties of a filterable field. A filterable field is a field in an event that can used to filter notifications for a certain event type. */
model NotificationEventField {
  fieldType?: NotificationEventFieldType;

  /** Gets or sets the unique identifier of this field. */
  id?: string;

  /** Gets or sets the name of this field. */
  name?: string;

  /** Gets or sets the path to the field in the event object. This path can be either Json Path or XPath, depending on if the event will be serialized into Json or XML */
  path?: string;

  /** Gets or sets the scopes that this field supports. If not specified then the event type scopes apply. */
  supportedScopes?: string[];
}

/** Encapsulates the properties of a field type. It includes a unique id for the operator and a localized string for display name */
model NotificationEventFieldOperator {
  /** Gets or sets the display name of an operator */
  displayName?: string;

  /** Gets or sets the id of an operator */
  id?: string;
}

/** Encapsulates the properties of a field type. It describes the data type of a field, the operators it support and how to populate it in the UI */
model NotificationEventFieldType {
  /** Gets or sets the unique identifier of this field type. */
  id?: string;

  operatorConstraints?: OperatorConstraint[];

  /** Gets or sets the list of operators that this type supports. */
  operators?: NotificationEventFieldOperator[];

  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionFieldType",
      values: #[
        #{ value: "string", description: "" },
        #{ value: "integer", description: "" },
        #{ value: "dateTime", description: "" },
        #{ value: "plainText", description: "" },
        #{ value: "html", description: "" },
        #{ value: "treePath", description: "" },
        #{ value: "history", description: "" },
        #{ value: "double", description: "" },
        #{ value: "guid", description: "" },
        #{ value: "boolean", description: "" },
        #{ value: "identity", description: "" },
        #{ value: "picklistInteger", description: "" },
        #{ value: "picklistString", description: "" },
        #{ value: "picklistDouble", description: "" },
        #{ value: "teamProject", description: "" }
      ],
    }
  )
  subscriptionFieldType?:
    | "string"
    | "integer"
    | "dateTime"
    | "plainText"
    | "html"
    | "treePath"
    | "history"
    | "double"
    | "guid"
    | "boolean"
    | "identity"
    | "picklistInteger"
    | "picklistString"
    | "picklistDouble"
    | "teamProject";
  value?: ValueDefinition;
}

/** Encapsulates the properties of a notification event publisher. */
model NotificationEventPublisher {
  id?: string;
  subscriptionManagementInfo?: SubscriptionManagement;
  url?: string;
}

/** Encapsulates the properties of an event role. An event Role is used for role based subscription for example for a buildCompletedEvent, one role is request by field */
model NotificationEventRole {
  /** Gets or sets an Id for that role, this id is used by the event. */
  id?: string;

  /** Gets or sets the Name for that role, this name is used for UI display. */
  name?: string;

  /** Gets or sets whether this role can be a group or just an individual user */
  supportsGroups?: boolean;
}

/** Encapsulates the properties of an event type. It defines the fields, that can be used for filtering, for that event type. */
model NotificationEventType {
  category?: NotificationEventTypeCategory;

  /** Gets or sets the color representing this event type. Example: rgb(128,245,211) or #fafafa */
  color?: string;

  customSubscriptionsAllowed?: boolean;
  eventPublisher?: NotificationEventPublisher;
  fields?: Record<NotificationEventField>;
  hasInitiator?: boolean;

  /** Gets or sets the icon representing this event type. Can be a URL or a CSS class. Example: css://some-css-class */
  icon?: string;

  /** Gets or sets the unique identifier of this event definition. */
  id?: string;

  /** Gets or sets the name of this event definition. */
  name?: string;

  roles?: NotificationEventRole[];

  /** Gets or sets the scopes that this event type supports */
  supportedScopes?: string[];

  /** Gets or sets the rest end point to get this event type details (fields, fields types) */
  url?: string;
}

/** Encapsulates the properties of a category. A category will be used by the UI to group event types */
model NotificationEventTypeCategory {
  /** Gets or sets the unique identifier of this category. */
  id?: string;

  /** Gets or sets the friendly name of this category. */
  name?: string;
}

model NotificationJobDiagnosticLog {
  ...NotificationDiagnosticLog;
  result?: string;
  stats?: Record<Record<unknown>>;
}

model NotificationQueryCondition {
  @format("uuid") eventInitiator?: string;
  eventType?: string;
  @format("uuid") subscriber?: string;
  subscriptionId?: string;
}

model NotificationReason {
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationReasonType",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "follows", description: "" },
        #{ value: "personal", description: "" },
        #{ value: "personalAlias", description: "" },
        #{ value: "directMember", description: "" },
        #{ value: "indirectMember", description: "" },
        #{ value: "groupAlias", description: "" },
        #{ value: "subscriptionAlias", description: "" },
        #{ value: "singleRole", description: "" },
        #{ value: "directMemberGroupRole", description: "" },
        #{ value: "inDirectMemberGroupRole", description: "" },
        #{ value: "aliasMemberGroupRole", description: "" }
      ],
    }
  )
  notificationReasonType?:
    | "unknown"
    | "follows"
    | "personal"
    | "personalAlias"
    | "directMember"
    | "indirectMember"
    | "groupAlias"
    | "subscriptionAlias"
    | "singleRole"
    | "directMemberGroupRole"
    | "inDirectMemberGroupRole"
    | "aliasMemberGroupRole";
  targetIdentities?: IdentityRef[];
}

/** Encapsulates notifications result properties. It defines the number of notifications and the recipients of notifications. */
model NotificationsEvaluationResult {
  /** Count of generated notifications */
  count?: int32;
}

model NotificationStatistic {
  date?: utcDateTime;
  hitCount?: int32;
  path?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationStatisticType",
      values: #[
        #{ value: "notificationBySubscription", description: "" },
        #{ value: "eventsByEventType", description: "" },
        #{ value: "notificationByEventType", description: "" },
        #{ value: "eventsByEventTypePerUser", description: "" },
        #{ value: "notificationByEventTypePerUser", description: "" },
        #{ value: "events", description: "" },
        #{ value: "notifications", description: "" },
        #{ value: "notificationFailureBySubscription", description: "" },
        #{ value: "unprocessedRangeStart", description: "" },
        #{ value: "unprocessedEventsByPublisher", description: "" },
        #{ value: "unprocessedEventDelayByPublisher", description: "" },
        #{ value: "unprocessedNotificationsByChannelByPublisher", description: "" },
        #{ value: "unprocessedNotificationDelayByChannelByPublisher", description: "" },
        #{ value: "delayRangeStart", description: "" },
        #{ value: "totalPipelineTime", description: "" },
        #{ value: "notificationPipelineTime", description: "" },
        #{ value: "eventPipelineTime", description: "" },
        #{ value: "hourlyRangeStart", description: "" },
        #{ value: "hourlyNotificationBySubscription", description: "" },
        #{ value: "hourlyEventsByEventTypePerUser", description: "" },
        #{ value: "hourlyEvents", description: "" },
        #{ value: "hourlyNotifications", description: "" },
        #{ value: "hourlyUnprocessedEventsByPublisher", description: "" },
        #{ value: "hourlyUnprocessedEventDelayByPublisher", description: "" },
        #{ value: "hourlyUnprocessedNotificationsByChannelByPublisher", description: "" },
        #{ value: "hourlyUnprocessedNotificationDelayByChannelByPublisher", description: "" },
        #{ value: "hourlyTotalPipelineTime", description: "" },
        #{ value: "hourlyNotificationPipelineTime", description: "" },
        #{ value: "hourlyEventPipelineTime", description: "" }
      ],
    }
  )
  type?:
    | "notificationBySubscription"
    | "eventsByEventType"
    | "notificationByEventType"
    | "eventsByEventTypePerUser"
    | "notificationByEventTypePerUser"
    | "events"
    | "notifications"
    | "notificationFailureBySubscription"
    | "unprocessedRangeStart"
    | "unprocessedEventsByPublisher"
    | "unprocessedEventDelayByPublisher"
    | "unprocessedNotificationsByChannelByPublisher"
    | "unprocessedNotificationDelayByChannelByPublisher"
    | "delayRangeStart"
    | "totalPipelineTime"
    | "notificationPipelineTime"
    | "eventPipelineTime"
    | "hourlyRangeStart"
    | "hourlyNotificationBySubscription"
    | "hourlyEventsByEventTypePerUser"
    | "hourlyEvents"
    | "hourlyNotifications"
    | "hourlyUnprocessedEventsByPublisher"
    | "hourlyUnprocessedEventDelayByPublisher"
    | "hourlyUnprocessedNotificationsByChannelByPublisher"
    | "hourlyUnprocessedNotificationDelayByChannelByPublisher"
    | "hourlyTotalPipelineTime"
    | "hourlyNotificationPipelineTime"
    | "hourlyEventPipelineTime";
  user?: IdentityRef;
}

model NotificationStatisticsQuery {
  conditions?: NotificationStatisticsQueryConditions[];
}

model NotificationStatisticsQueryConditions {
  endDate?: utcDateTime;
  hitCountMinimum?: int32;
  path?: string;
  startDate?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationStatisticType",
      values: #[
        #{ value: "notificationBySubscription", description: "" },
        #{ value: "eventsByEventType", description: "" },
        #{ value: "notificationByEventType", description: "" },
        #{ value: "eventsByEventTypePerUser", description: "" },
        #{ value: "notificationByEventTypePerUser", description: "" },
        #{ value: "events", description: "" },
        #{ value: "notifications", description: "" },
        #{ value: "notificationFailureBySubscription", description: "" },
        #{ value: "unprocessedRangeStart", description: "" },
        #{ value: "unprocessedEventsByPublisher", description: "" },
        #{ value: "unprocessedEventDelayByPublisher", description: "" },
        #{ value: "unprocessedNotificationsByChannelByPublisher", description: "" },
        #{ value: "unprocessedNotificationDelayByChannelByPublisher", description: "" },
        #{ value: "delayRangeStart", description: "" },
        #{ value: "totalPipelineTime", description: "" },
        #{ value: "notificationPipelineTime", description: "" },
        #{ value: "eventPipelineTime", description: "" },
        #{ value: "hourlyRangeStart", description: "" },
        #{ value: "hourlyNotificationBySubscription", description: "" },
        #{ value: "hourlyEventsByEventTypePerUser", description: "" },
        #{ value: "hourlyEvents", description: "" },
        #{ value: "hourlyNotifications", description: "" },
        #{ value: "hourlyUnprocessedEventsByPublisher", description: "" },
        #{ value: "hourlyUnprocessedEventDelayByPublisher", description: "" },
        #{ value: "hourlyUnprocessedNotificationsByChannelByPublisher", description: "" },
        #{ value: "hourlyUnprocessedNotificationDelayByChannelByPublisher", description: "" },
        #{ value: "hourlyTotalPipelineTime", description: "" },
        #{ value: "hourlyNotificationPipelineTime", description: "" },
        #{ value: "hourlyEventPipelineTime", description: "" }
      ],
    }
  )
  type?:
    | "notificationBySubscription"
    | "eventsByEventType"
    | "notificationByEventType"
    | "eventsByEventTypePerUser"
    | "notificationByEventTypePerUser"
    | "events"
    | "notifications"
    | "notificationFailureBySubscription"
    | "unprocessedRangeStart"
    | "unprocessedEventsByPublisher"
    | "unprocessedEventDelayByPublisher"
    | "unprocessedNotificationsByChannelByPublisher"
    | "unprocessedNotificationDelayByChannelByPublisher"
    | "delayRangeStart"
    | "totalPipelineTime"
    | "notificationPipelineTime"
    | "eventPipelineTime"
    | "hourlyRangeStart"
    | "hourlyNotificationBySubscription"
    | "hourlyEventsByEventTypePerUser"
    | "hourlyEvents"
    | "hourlyNotifications"
    | "hourlyUnprocessedEventsByPublisher"
    | "hourlyUnprocessedEventDelayByPublisher"
    | "hourlyUnprocessedNotificationsByChannelByPublisher"
    | "hourlyUnprocessedNotificationDelayByChannelByPublisher"
    | "hourlyTotalPipelineTime"
    | "hourlyNotificationPipelineTime"
    | "hourlyEventPipelineTime";
  user?: IdentityRef;
}

/** A subscriber is a user or group that has the potential to receive notifications. */
model NotificationSubscriber {
  /** Indicates how the subscriber should be notified by default. */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationSubscriberDeliveryPreference",
      values: #[
        #{
          value: "noDelivery",
          description: "Do not send notifications by default. Note: notifications can still be delivered to this subscriber, for example via a custom subscription.",
        },
        #{
          value: "preferredEmailAddress",
          description: "Deliver notifications to the subscriber's preferred email address.",
        },
        #{
          value: "eachMember",
          description: "Deliver notifications to each member of the group representing the subscriber. Only applicable when the subscriber is a group.",
        },
        #{ value: "useDefault", description: "Use default" }
      ],
    }
  )
  deliveryPreference?: "noDelivery" | "preferredEmailAddress" | "eachMember" | "useDefault";

  @extension(
    "x-ms-enum",
    #{
      name: "SubscriberFlags",
      values: #[
        #{ value: "none", description: "" },
        #{
          value: "deliveryPreferencesEditable",
          description: "Subscriber's delivery preferences could be updated",
        },
        #{
          value: "supportsPreferredEmailAddressDelivery",
          description: "Subscriber's delivery preferences supports email delivery",
        },
        #{
          value: "supportsEachMemberDelivery",
          description: "Subscriber's delivery preferences supports individual members delivery(group expansion)",
        },
        #{
          value: "supportsNoDelivery",
          description: "Subscriber's delivery preferences supports no delivery",
        },
        #{ value: "isUser", description: "Subscriber is a user" },
        #{ value: "isGroup", description: "Subscriber is a group" },
        #{ value: "isTeam", description: "Subscriber is a team" }
      ],
    }
  )
  flags?:
    | "none"
    | "deliveryPreferencesEditable"
    | "supportsPreferredEmailAddressDelivery"
    | "supportsEachMemberDelivery"
    | "supportsNoDelivery"
    | "isUser"
    | "isGroup"
    | "isTeam";

  /** Identifier of the subscriber. */
  @format("uuid") id?: string;

  /** Preferred email address of the subscriber. A null or empty value indicates no preferred email address has been set. */
  preferredEmailAddress?: string;
}

/** Updates to a subscriber. Typically used to change (or set) a preferred email address or default delivery preference. */
model NotificationSubscriberUpdateParameters {
  /** New delivery preference for the subscriber (indicates how the subscriber should be notified). */
  @extension(
    "x-ms-enum",
    #{
      name: "NotificationSubscriberDeliveryPreference",
      values: #[
        #{
          value: "noDelivery",
          description: "Do not send notifications by default. Note: notifications can still be delivered to this subscriber, for example via a custom subscription.",
        },
        #{
          value: "preferredEmailAddress",
          description: "Deliver notifications to the subscriber's preferred email address.",
        },
        #{
          value: "eachMember",
          description: "Deliver notifications to each member of the group representing the subscriber. Only applicable when the subscriber is a group.",
        },
        #{ value: "useDefault", description: "Use default" }
      ],
    }
  )
  deliveryPreference?: "noDelivery" | "preferredEmailAddress" | "eachMember" | "useDefault";

  /** New preferred email address for the subscriber. Specify an empty string to clear the current address. */
  preferredEmailAddress?: string;
}

/** A subscription defines criteria for matching events and how the subscription's subscriber should be notified about those events. */
model NotificationSubscription {
  _links?: ReferenceLinks;
  adminSettings?: SubscriptionAdminSettings;
  channel?: ISubscriptionChannel;

  /** Description of the subscription. Typically describes filter criteria which helps identity the subscription. */
  description?: string;

  diagnostics?: SubscriptionDiagnostics;

  /** Any extra properties like detailed description for different contexts, user/group contexts */
  extendedProperties?: Record<string>;

  filter?: ISubscriptionFilter;

  /** Read-only indicators that further describe the subscription. */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionFlags",
      values: #[
        #{ value: "none", description: "None" },
        #{
          value: "groupSubscription",
          description: "Subscription's subscriber is a group, not a user",
        },
        #{
          value: "contributedSubscription",
          description: "Subscription is contributed and not persisted. This means certain fields of the subscription, like Filter, are read-only.",
        },
        #{
          value: "canOptOut",
          description: "A user that is member of the subscription's subscriber group can opt in/out of the subscription.",
        },
        #{ value: "teamSubscription", description: "If the subscriber is a group, is it a team." },
        #{
          value: "oneActorMatches",
          description: "For role based subscriptions, there is an expectation that there will always be at least one actor that matches",
        }
      ],
    }
  )
  flags?:
    | "none"
    | "groupSubscription"
    | "contributedSubscription"
    | "canOptOut"
    | "teamSubscription"
    | "oneActorMatches";

  /** Subscription identifier. */
  id?: string;

  lastModifiedBy?: IdentityRef;

  /** Date when the subscription was last modified. If the subscription has not been updated since it was created, this value will indicate when the subscription was created. */
  modifiedDate?: utcDateTime;

  /** The permissions the user have for this subscriptions. */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionPermissions",
      values: #[
        #{ value: "none", description: "None" },
        #{ value: "view", description: "full view of description, filters, etc. Not limited." },
        #{ value: "edit", description: "update subscription" },
        #{ value: "delete", description: "delete subscription" }
      ],
    }
  )
  permissions?: "none" | "view" | "edit" | "delete";

  scope?: SubscriptionScope;

  /** Status of the subscription. Typically indicates whether the subscription is enabled or not. */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionStatus",
      values: #[
        #{
          value: "jailedByNotificationsVolume",
          description: "Subscription is disabled because it generated a high volume of notifications.",
        },
        #{
          value: "pendingDeletion",
          description: "Subscription is disabled and will be deleted.",
        },
        #{
          value: "disabledArgumentException",
          description: "Subscription is disabled because of an Argument Exception while processing the subscription",
        },
        #{
          value: "disabledProjectInvalid",
          description: "Subscription is disabled because the project is invalid",
        },
        #{
          value: "disabledMissingPermissions",
          description: "Subscription is disabled because the identity does not have the appropriate permissions",
        },
        #{
          value: "disabledFromProbation",
          description: "Subscription is disabled service due to failures.",
        },
        #{
          value: "disabledInactiveIdentity",
          description: "Subscription is disabled because the identity is no longer active",
        },
        #{
          value: "disabledMessageQueueNotSupported",
          description: "Subscription is disabled because message queue is not supported.",
        },
        #{
          value: "disabledMissingIdentity",
          description: "Subscription is disabled because its subscriber is unknown.",
        },
        #{
          value: "disabledInvalidRoleExpression",
          description: "Subscription is disabled because it has an invalid role expression.",
        },
        #{
          value: "disabledInvalidPathClause",
          description: "Subscription is disabled because it has an invalid filter expression.",
        },
        #{
          value: "disabledAsDuplicateOfDefault",
          description: "Subscription is disabled because it is a duplicate of a default subscription.",
        },
        #{
          value: "disabledByAdmin",
          description: "Subscription is disabled by an administrator, not the subscription's subscriber.",
        },
        #{
          value: "disabled",
          description: "Subscription is disabled, typically by the owner of the subscription, and will not produce any notifications.",
        },
        #{ value: "enabled", description: "Subscription is active." },
        #{
          value: "enabledOnProbation",
          description: "Subscription is active, but is on probation due to failed deliveries or other issues with the subscription.",
        }
      ],
    }
  )
  status?:
    | "jailedByNotificationsVolume"
    | "pendingDeletion"
    | "disabledArgumentException"
    | "disabledProjectInvalid"
    | "disabledMissingPermissions"
    | "disabledFromProbation"
    | "disabledInactiveIdentity"
    | "disabledMessageQueueNotSupported"
    | "disabledMissingIdentity"
    | "disabledInvalidRoleExpression"
    | "disabledInvalidPathClause"
    | "disabledAsDuplicateOfDefault"
    | "disabledByAdmin"
    | "disabled"
    | "enabled"
    | "enabledOnProbation";

  /** Message that provides more details about the status of the subscription. */
  statusMessage?: string;

  subscriber?: IdentityRef;

  /** REST API URL of the subscription. */
  url?: string;

  userSettings?: SubscriptionUserSettings;
}

/** Parameters for creating a new subscription. A subscription defines criteria for matching events and how the subscription's subscriber should be notified about those events. */
model NotificationSubscriptionCreateParameters {
  channel?: ISubscriptionChannel;

  /** Brief description for the new subscription. Typically describes filter criteria which helps identity the subscription. */
  description?: string;

  filter?: ISubscriptionFilter;
  scope?: SubscriptionScope;
  subscriber?: IdentityRef;
}

model NotificationSubscriptionTemplate {
  description?: string;
  filter?: ISubscriptionFilter;
  id?: string;
  notificationEventInformation?: NotificationEventType;
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionTemplateType",
      values: #[
        #{ value: "user", description: "" },
        #{ value: "team", description: "" },
        #{ value: "both", description: "" },
        #{ value: "none", description: "" }
      ],
    }
  )
  type?: "user" | "team" | "both" | "none";
}

/** Parameters for updating an existing subscription. A subscription defines criteria for matching events and how the subscription's subscriber should be notified about those events. Note: only the fields to be updated should be set. */
model NotificationSubscriptionUpdateParameters {
  adminSettings?: SubscriptionAdminSettings;
  channel?: ISubscriptionChannel;

  /** Updated description for the subscription. Typically describes filter criteria which helps identity the subscription. */
  description?: string;

  filter?: ISubscriptionFilter;
  scope?: SubscriptionScope;

  /** Updated status for the subscription. Typically used to enable or disable a subscription. */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionStatus",
      values: #[
        #{
          value: "jailedByNotificationsVolume",
          description: "Subscription is disabled because it generated a high volume of notifications.",
        },
        #{
          value: "pendingDeletion",
          description: "Subscription is disabled and will be deleted.",
        },
        #{
          value: "disabledArgumentException",
          description: "Subscription is disabled because of an Argument Exception while processing the subscription",
        },
        #{
          value: "disabledProjectInvalid",
          description: "Subscription is disabled because the project is invalid",
        },
        #{
          value: "disabledMissingPermissions",
          description: "Subscription is disabled because the identity does not have the appropriate permissions",
        },
        #{
          value: "disabledFromProbation",
          description: "Subscription is disabled service due to failures.",
        },
        #{
          value: "disabledInactiveIdentity",
          description: "Subscription is disabled because the identity is no longer active",
        },
        #{
          value: "disabledMessageQueueNotSupported",
          description: "Subscription is disabled because message queue is not supported.",
        },
        #{
          value: "disabledMissingIdentity",
          description: "Subscription is disabled because its subscriber is unknown.",
        },
        #{
          value: "disabledInvalidRoleExpression",
          description: "Subscription is disabled because it has an invalid role expression.",
        },
        #{
          value: "disabledInvalidPathClause",
          description: "Subscription is disabled because it has an invalid filter expression.",
        },
        #{
          value: "disabledAsDuplicateOfDefault",
          description: "Subscription is disabled because it is a duplicate of a default subscription.",
        },
        #{
          value: "disabledByAdmin",
          description: "Subscription is disabled by an administrator, not the subscription's subscriber.",
        },
        #{
          value: "disabled",
          description: "Subscription is disabled, typically by the owner of the subscription, and will not produce any notifications.",
        },
        #{ value: "enabled", description: "Subscription is active." },
        #{
          value: "enabledOnProbation",
          description: "Subscription is active, but is on probation due to failed deliveries or other issues with the subscription.",
        }
      ],
    }
  )
  status?:
    | "jailedByNotificationsVolume"
    | "pendingDeletion"
    | "disabledArgumentException"
    | "disabledProjectInvalid"
    | "disabledMissingPermissions"
    | "disabledFromProbation"
    | "disabledInactiveIdentity"
    | "disabledMessageQueueNotSupported"
    | "disabledMissingIdentity"
    | "disabledInvalidRoleExpression"
    | "disabledInvalidPathClause"
    | "disabledAsDuplicateOfDefault"
    | "disabledByAdmin"
    | "disabled"
    | "enabled"
    | "enabledOnProbation";

  /** Optional message that provides more details about the updated status. */
  statusMessage?: string;

  userSettings?: SubscriptionUserSettings;
}

/** Encapsulates the properties of an operator constraint. An operator constraint defines if some operator is available only for specific scope like a project scope. */
model OperatorConstraint {
  operator?: string;

  /** Gets or sets the list of scopes that this type supports. */
  supportedScopes?: string[];
}

model ProcessedEvent {
  /** All of the users that were associated with this event and their role. */
  actors?: EventActor[];

  allowedChannels?: string;
  artifactUri?: string;
  deliveryIdentities?: ProcessingIdentities;

  /** Evaluations for each user */
  evaluations?: Record<SubscriptionEvaluation>;

  eventId?: int64;

  /** Which members were excluded from evaluation (only applies to ActorMatcher subscriptions) */
  exclusions?: EventActor[];

  /** Which members were included for evaluation (only applies to ActorMatcher subscriptions) */
  inclusions?: EventActor[];

  notifications?: GeneratedNotification[];
}

model ProcessingDiagnosticIdentity {
  ...DiagnosticIdentity;
  deliveryPreference?: string;
  isActive?: boolean;
  isGroup?: boolean;
  message?: string;
}

model ProcessingIdentities {
  excludedIdentities?: Record<ProcessingDiagnosticIdentity>;
  includedIdentities?: Record<ProcessingDiagnosticIdentity>;
  messages?: NotificationDiagnosticLogMessage[];
  missingIdentities?: string[];
  properties?: Record<string>;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model RoleBasedFilter {
  ...ExpressionFilter;
  exclusions?: string[];
  inclusions?: string[];
}

model ServiceBusSubscriptionChannel {
  type?: string;
}

model ServiceHooksSubscriptionChannel {
  type?: string;
}

model SoapSubscriptionChannel {
  ...SubscriptionChannelWithAddress;
}

/** Admin-managed settings for a group subscription. */
model SubscriptionAdminSettings {
  /** If true, members of the group subscribed to the associated subscription cannot opt (choose not to get notified) */
  blockUserOptOut?: boolean;
}

model SubscriptionChannelWithAddress {
  address?: string;
  type?: string;
  useCustomAddress?: boolean;
}

/** Contains all the diagnostics settings for a subscription. */
model SubscriptionDiagnostics {
  deliveryResults?: SubscriptionTracing;
  deliveryTracing?: SubscriptionTracing;
  evaluationTracing?: SubscriptionTracing;
}

model SubscriptionEvaluation {
  clauses?: SubscriptionEvaluationClause[];
  user?: DiagnosticIdentity;
}

model SubscriptionEvaluationClause {
  clause?: string;
  order?: int32;
  result?: boolean;
}

/** Encapsulates the properties of a SubscriptionEvaluationRequest. It defines the subscription to be evaluated and time interval for events used in evaluation. */
model SubscriptionEvaluationRequest {
  /** The min created date for the events used for matching in UTC. Use all events created since this date */
  minEventsCreatedDate?: utcDateTime;

  subscriptionCreateParameters?: NotificationSubscriptionCreateParameters;
}

/** Encapsulates the subscription evaluation results. It defines the Date Interval that was used, number of events evaluated and events and notifications results */
model SubscriptionEvaluationResult {
  /** Subscription evaluation job status */
  @extension(
    "x-ms-enum",
    #{
      name: "EvaluationOperationStatus",
      values: #[
        #{ value: "notSet", description: "The operation object does not have the status set." },
        #{ value: "queued", description: "The operation has been queued." },
        #{ value: "inProgress", description: "The operation is in progress." },
        #{ value: "cancelled", description: "The operation was cancelled by the user." },
        #{ value: "succeeded", description: "The operation completed successfully." },
        #{ value: "failed", description: "The operation completed with a failure." },
        #{ value: "timedOut", description: "The operation timed out." },
        #{ value: "notFound", description: "The operation could not be found." }
      ],
    }
  )
  evaluationJobStatus?:
    | "notSet"
    | "queued"
    | "inProgress"
    | "cancelled"
    | "succeeded"
    | "failed"
    | "timedOut"
    | "notFound";

  events?: EventsEvaluationResult;

  /** The requestId which is the subscription evaluation jobId */
  @format("uuid") id?: string;

  notifications?: NotificationsEvaluationResult;
}

/** Encapsulates the subscription evaluation settings needed for the UI */
model SubscriptionEvaluationSettings {
  /** Indicates whether subscription evaluation before saving is enabled or not */
  enabled?: boolean;

  /** Time interval to check on subscription evaluation job in seconds */
  interval?: int32;

  /** Threshold on the number of notifications for considering a subscription too noisy */
  threshold?: int32;

  /** Time out for the subscription evaluation check in seconds */
  timeOut?: int32;
}

/** Encapsulates the properties needed to manage subscriptions, opt in and out of subscriptions. */
model SubscriptionManagement {
  @format("uuid") serviceInstanceType?: string;
  url?: string;
}

/** Notification subscriptions query input. */
model SubscriptionQuery {
  /** One or more conditions to query on. If more than 2 conditions are specified, the combined results of each condition is returned (i.e. conditions are logically OR'ed). */
  conditions?: SubscriptionQueryCondition[];

  /** Flags the refine the types of subscriptions that will be returned from the query. */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionQueryFlags",
      values: #[
        #{ value: "none", description: "" },
        #{
          value: "includeInvalidSubscriptions",
          description: "Include subscriptions with invalid subscribers.",
        },
        #{
          value: "includeDeletedSubscriptions",
          description: "Include subscriptions marked for deletion.",
        },
        #{
          value: "includeFilterDetails",
          description: "Include the full filter details with each subscription.",
        },
        #{
          value: "alwaysReturnBasicInformation",
          description: "For a subscription the caller does not have permission to view, return basic (non-confidential) information.",
        },
        #{ value: "includeSystemSubscriptions", description: "Include system subscriptions." }
      ],
    }
  )
  queryFlags?:
    | "none"
    | "includeInvalidSubscriptions"
    | "includeDeletedSubscriptions"
    | "includeFilterDetails"
    | "alwaysReturnBasicInformation"
    | "includeSystemSubscriptions";
}

/** Conditions a subscription must match to qualify for the query result set. Not all fields are required. A subscription must match all conditions specified in order to qualify for the result set. */
model SubscriptionQueryCondition {
  filter?: ISubscriptionFilter;

  /** Flags to specify the type subscriptions to query for. */
  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionFlags",
      values: #[
        #{ value: "none", description: "None" },
        #{
          value: "groupSubscription",
          description: "Subscription's subscriber is a group, not a user",
        },
        #{
          value: "contributedSubscription",
          description: "Subscription is contributed and not persisted. This means certain fields of the subscription, like Filter, are read-only.",
        },
        #{
          value: "canOptOut",
          description: "A user that is member of the subscription's subscriber group can opt in/out of the subscription.",
        },
        #{ value: "teamSubscription", description: "If the subscriber is a group, is it a team." },
        #{
          value: "oneActorMatches",
          description: "For role based subscriptions, there is an expectation that there will always be at least one actor that matches",
        }
      ],
    }
  )
  flags?:
    | "none"
    | "groupSubscription"
    | "contributedSubscription"
    | "canOptOut"
    | "teamSubscription"
    | "oneActorMatches";

  /** Scope that matching subscriptions must have. */
  scope?: string;

  /** ID of the subscriber (user or group) that matching subscriptions must be subscribed to. */
  @format("uuid") subscriberId?: string;

  /** ID of the subscription to query for. */
  subscriptionId?: string;
}

/** A resource, typically an account or project, in which events are published from. */
model SubscriptionScope {
  ...EventScope;
}

model SubscriptionTraceDiagnosticLog {
  ...NotificationDiagnosticLog;

  /** Indicates the job Id that processed or delivered this subscription */
  @format("uuid") jobId?: string;

  /** Indicates unique instance identifier for the job that processed or delivered this subscription */
  @format("uuid") jobInstanceId?: string;

  subscriptionId?: string;
}

model SubscriptionTraceEventProcessingLog {
  ...SubscriptionTraceDiagnosticLog;
  channel?: string;
  evaluationIdentities?: ProcessingIdentities;

  /** Which members opted out from receiving notifications from this subscription */
  optedOut?: DiagnosticIdentity[];

  processedEvents?: Record<ProcessedEvent>;
}

model SubscriptionTraceNotificationDeliveryLog {
  ...SubscriptionTraceDiagnosticLog;
  notifications?: DiagnosticNotification[];
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

/** User-managed settings for a group subscription. */
model SubscriptionUserSettings {
  /** Indicates whether the user will receive notifications for the associated group subscription. */
  optedOut?: boolean;
}

model UnsupportedFilter {
  ...BaseSubscriptionFilter;
}

model UnsupportedSubscriptionChannel {
  type?: string;
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

model UserSubscriptionChannel {
  ...SubscriptionChannelWithAddress;
}

model UserSystemSubscriptionChannel {
  ...SubscriptionChannelWithAddress;
}

/** Encapsulates the properties of a field value definition. It has the information needed to retrieve the list of possible values for a certain field and how to handle that field values in the UI. This information includes what type of object this value represents, which property to use for UI display and which property to use for saving the subscription */
model ValueDefinition {
  /** Gets or sets the data source. */
  dataSource?: InputValue[];

  /** Gets or sets the rest end point. */
  endPoint?: string;

  /** Gets or sets the result template. */
  resultTemplate?: string;
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

/** This is the type used for firing notifications intended for the subsystem in the Notifications SDK. For components that can't take a dependency on the Notifications SDK directly, they can use ITeamFoundationEventService.PublishNotification and the Notifications SDK ISubscriber implementation will get it. */
model VssNotificationEvent {
  /** Optional: A list of actors which are additional identities with corresponding roles that are relevant to the event. */
  actors?: EventActor[];

  /** Optional: A list of artifacts referenced or impacted by this event. */
  artifactUris?: string[];

  /** Required: The event payload. If Data is a string, it must be in Json or XML format. Otherwise it must have a serialization format attribute. */
  data?: {};

  /** Required: The name of the event. This event must be registered in the context it is being fired. */
  eventType?: string;

  /** How long before the event expires and will be cleaned up. The default is to use the system default. */
  @format("TimeSpan") expiresIn?: string;

  /** The id of the item, artifact, extension, project, etc. */
  itemId?: string;

  /** How long to wait before processing this event. The default is to process immediately. */
  @format("TimeSpan") processDelay?: string;

  /** Optional: A list of scopes which are relevant to the event. */
  scopes?: EventScope[];

  /** This is the time the original source event for this VssNotificationEvent was created. For example, for something like a build completion notification SourceEventCreatedTime should be the time the build finished not the time this event was raised. */
  sourceEventCreatedTime?: utcDateTime;
}

/** Get a list of diagnostic logs for this service. */
@tag("Diagnostic Logs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "diagnosticLogs")
@extension("x-ms-vss-method", "ListLogs")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/diagnosticlogs/{source}/entries/{entryId}")
@get
op `Diagnostic Logs_List`(
  /** ID specifying which type of logs to check diagnostics for. */
  @format("uuid") @path source: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  /** The ID of the specific log to query for. */
  @extension("x-ms-required", false)
  @format("uuid")
  @path
  entryId: string,

  /** Start time for the time range to query in. */
  @query(#{ explode: true }) startTime?: utcDateTime,

  /** End time for the time range to query in. */
  @query(#{ explode: true }) endTime?: utcDateTime,

  ...Parameters.`api-Version-preview`.`1`,
): Body<INotificationDiagnosticLog[]>;

/** List available event types for this service. Optionally filter by only event types for the specified publisher. */
@tag("Event Types")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "eventTypes")
@extension("x-ms-vss-method", "ListEventTypes")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/eventtypes")
@get
op `Event Types_List`(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  /** Limit to event types for this publisher */
  @query(#{ explode: true }) publisherId?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<NotificationEventType[]>;

/** Get a specific event type. */
@tag("Event Types")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "eventTypes")
@extension("x-ms-vss-method", "GetEventType")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/eventtypes/{eventType}")
@get
op `Event Types_Get`(
  /** The ID of the event type. */
  @path eventType: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): NotificationEventType;

@tag("Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "settings")
@extension("x-ms-vss-method", "GetSettings")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/settings")
@get
op Settings_Get(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): NotificationAdminSettings;

@tag("Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "settings")
@extension("x-ms-vss-method", "UpdateSettings")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/settings")
@patch
op Settings_Update(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: NotificationAdminSettingsUpdateParameters,
): NotificationAdminSettings;

/** Get delivery preferences of a notifications subscriber. */
@tag("Subscribers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscribers")
@extension("x-ms-vss-method", "GetSubscriber")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscribers/{subscriberId}")
@get
op Subscribers_Get(
  /** ID of the user or group. */
  @format("uuid") @path subscriberId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): NotificationSubscriber;

/** Update delivery preferences of a notifications subscriber. */
@tag("Subscribers")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscribers")
@extension("x-ms-vss-method", "UpdateSubscriber")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscribers/{subscriberId}")
@patch
op Subscribers_Update(
  /** ID of the user or group. */
  @format("uuid") @path subscriberId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: NotificationSubscriberUpdateParameters,
): NotificationSubscriber;

/** Query for subscriptions. A subscription is returned if it matches one or more of the specified conditions. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptionQuery")
@extension("x-ms-vss-method", "QuerySubscriptions")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptionquery")
@post
op Subscriptions_Query(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: SubscriptionQuery,
): Body<NotificationSubscription[]>;

/** Get a list of notification subscriptions, either by subscription IDs or by all subscriptions for a given user or group. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptions")
@extension("x-ms-vss-method", "ListSubscriptions")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions")
@get
op Subscriptions_List(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  /** User or Group ID */
  @format("uuid") @query(#{ explode: true }) targetId?: string,

  /** List of subscription IDs */
  @format("array (string)") @query(#{ explode: true }) ids?: string,

  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionQueryFlags",
      values: #[
        #{ value: "none", description: "" },
        #{
          value: "includeInvalidSubscriptions",
          description: "Include subscriptions with invalid subscribers.",
        },
        #{
          value: "includeDeletedSubscriptions",
          description: "Include subscriptions marked for deletion.",
        },
        #{
          value: "includeFilterDetails",
          description: "Include the full filter details with each subscription.",
        },
        #{
          value: "alwaysReturnBasicInformation",
          description: "For a subscription the caller does not have permission to view, return basic (non-confidential) information.",
        },
        #{ value: "includeSystemSubscriptions", description: "Include system subscriptions." }
      ],
    }
  )
  @query(#{ explode: true })
  queryFlags?:
    | "none"
    | "includeInvalidSubscriptions"
    | "includeDeletedSubscriptions"
    | "includeFilterDetails"
    | "alwaysReturnBasicInformation"
    | "includeSystemSubscriptions",
  ...Parameters.`api-Version-preview`.`1`,
): Body<NotificationSubscription[]>;

/** Create a new subscription. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptions")
@extension("x-ms-vss-method", "CreateSubscription")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions")
@post
op Subscriptions_Create(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: NotificationSubscriptionCreateParameters,
): NotificationSubscription;

/** Delete a subscription. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptions")
@extension("x-ms-vss-method", "DeleteSubscription")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions/{subscriptionId}")
@delete
op Subscriptions_Delete(
  @path subscriptionId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Get a notification subscription by its ID. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptions")
@extension("x-ms-vss-method", "GetSubscription")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions/{subscriptionId}")
@get
op Subscriptions_Get(
  @path subscriptionId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  @extension(
    "x-ms-enum",
    #{
      name: "SubscriptionQueryFlags",
      values: #[
        #{ value: "none", description: "" },
        #{
          value: "includeInvalidSubscriptions",
          description: "Include subscriptions with invalid subscribers.",
        },
        #{
          value: "includeDeletedSubscriptions",
          description: "Include subscriptions marked for deletion.",
        },
        #{
          value: "includeFilterDetails",
          description: "Include the full filter details with each subscription.",
        },
        #{
          value: "alwaysReturnBasicInformation",
          description: "For a subscription the caller does not have permission to view, return basic (non-confidential) information.",
        },
        #{ value: "includeSystemSubscriptions", description: "Include system subscriptions." }
      ],
    }
  )
  @query(#{ explode: true })
  queryFlags?:
    | "none"
    | "includeInvalidSubscriptions"
    | "includeDeletedSubscriptions"
    | "includeFilterDetails"
    | "alwaysReturnBasicInformation"
    | "includeSystemSubscriptions",
  ...Parameters.`api-Version-preview`.`1`,
): NotificationSubscription;

/** Update an existing subscription. Depending on the type of subscription and permissions, the caller can update the description, filter settings, channel (delivery) settings and more. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptions")
@extension("x-ms-vss-method", "UpdateSubscription")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions/{subscriptionId}")
@patch
op Subscriptions_Update(
  @path subscriptionId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: NotificationSubscriptionUpdateParameters,
): NotificationSubscription;

/** Get the diagnostics settings for a subscription. */
@tag("Diagnostics")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "diagnostics")
@extension("x-ms-vss-method", "GetSubscriptionDiagnostics")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions/{subscriptionId}/diagnostics")
@get
op Diagnostics_Get(
  /** The id of the notifications subscription. */
  @path subscriptionId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): SubscriptionDiagnostics;

/** Update the diagnostics settings for a subscription. */
@tag("Diagnostics")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "diagnostics")
@extension("x-ms-vss-method", "UpdateSubscriptionDiagnostics")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptions/{subscriptionId}/diagnostics")
@put
op Diagnostics_Update(
  /** The id of the notifications subscription. */
  @path subscriptionId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: UpdateSubscripitonDiagnosticsParameters,
): SubscriptionDiagnostics;

/** Update the specified user's settings for the specified subscription. This API is typically used to opt in or out of a shared subscription. User settings can only be applied to shared subscriptions, like team subscriptions or default subscriptions. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "userSettings")
@extension("x-ms-vss-method", "UpdateSubscriptionUserSettings")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/Subscriptions/{subscriptionId}/usersettings/{userId}")
@put
op `Subscriptions_Update Subscription User Settings`(
  @path subscriptionId: string,

  /** ID of the user */
  @format("uuid") @path userId: string,

  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: SubscriptionUserSettings,
): SubscriptionUserSettings;

/** Get available subscription templates. */
@tag("Subscriptions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "subscriptionTemplates")
@extension("x-ms-vss-method", "GetSubscriptionTemplates")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/notification/subscriptiontemplates")
@get
op `Subscriptions_Get Subscription Templates`(
  /** The name of the Azure DevOps organization. */
  @extension("x-ms-required", false) @path organization: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<NotificationSubscriptionTemplate[]>;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
