import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Work" })
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
namespace Work;

model Activity {
  capacityPerDay?: float32;
  name?: string;
}

model attribute {}

model BacklogColumn {
  columnFieldReference?: WorkItemFieldReference;
  width?: int32;
}

model BacklogConfiguration {
  backlogFields?: BacklogFields;

  /** Bugs behavior */
  @extension(
    "x-ms-enum",
    #{
      name: "BugsBehavior",
      values: #[
        #{ value: "off", description: "" },
        #{ value: "asRequirements", description: "" },
        #{ value: "asTasks", description: "" }
      ],
    }
  )
  bugsBehavior?: "off" | "asRequirements" | "asTasks";

  /** Hidden Backlog */
  hiddenBacklogs?: string[];

  /** Is BugsBehavior Configured in the process */
  isBugsBehaviorConfigured?: boolean;

  /** Portfolio backlog descriptors */
  portfolioBacklogs?: BacklogLevelConfiguration[];

  requirementBacklog?: BacklogLevelConfiguration;
  taskBacklog?: BacklogLevelConfiguration;
  url?: string;

  /** Mapped states for work item types */
  workItemTypeMappedStates?: WorkItemTypeStateInfo[];
}

model BacklogFields {
  /** Field Type (e.g. Order, Activity) to Field Reference Name map */
  typeFields?: Record<string>;
}

/** Contract representing a backlog level */
model BacklogLevel {
  /** Reference name of the corresponding WIT category */
  categoryReferenceName?: string;

  /** Plural name for the backlog level */
  pluralName?: string;

  /** Collection of work item states that are included in the plan. The server will filter to only these work item types. */
  workItemStates?: string[];

  /** Collection of valid workitem type names for the given backlog level */
  workItemTypes?: string[];
}

model BacklogLevelConfiguration {
  /** List of fields to include in Add Panel */
  addPanelFields?: WorkItemFieldReference[];

  /** Color for the backlog level */
  color?: string;

  /** Default list of columns for the backlog */
  columnFields?: BacklogColumn[];

  defaultWorkItemType?: WorkItemTypeReference;

  /** Backlog Id (for Legacy Backlog Level from process config it can be categoryref name) */
  id?: string;

  /** Indicates whether the backlog level is hidden */
  isHidden?: boolean;

  /** Backlog Name */
  name?: string;

  /** Backlog Rank (Taskbacklog is 0) */
  rank?: int32;

  /** The type of this backlog level */
  @extension(
    "x-ms-enum",
    #{
      name: "BacklogType",
      values: #[
        #{ value: "portfolio", description: "Portfolio backlog level" },
        #{ value: "requirement", description: "Requirement backlog level" },
        #{ value: "task", description: "Task backlog level" }
      ],
    }
  )
  type?: "portfolio" | "requirement" | "task";

  /** Max number of work items to show in the given backlog */
  workItemCountLimit?: int32;

  /** Work Item types participating in this backlog as known by the project/Process, can be overridden by team settings for bugs */
  workItemTypes?: WorkItemTypeReference[];
}

/** Represents work items in a backlog level */
model BacklogLevelWorkItems {
  /** A list of work items within a backlog level */
  workItems?: WorkItemLink[];
}

model Board {
  ...BoardReference;
  _links?: ReferenceLinks;
  allowedMappings?: Record<Record<string[]>>;
  canEdit?: boolean;
  columns?: BoardColumn[];
  fields?: BoardFields;
  isValid?: boolean;
  revision?: int32;
  rows?: BoardRow[];
}

/** Represents a board badge. */
model BoardBadge {
  /** The ID of the board represented by this badge. */
  @format("uuid") boardId?: string;

  /** A link to the SVG resource. */
  imageUrl?: string;
}

model BoardCardRuleSettings {
  _links?: ReferenceLinks;
  rules?: Record<Rule[]>;
  url?: string;
}

model BoardCardSettings {
  cards?: Record<FieldSetting[]>;
}

model BoardChart {
  ...BoardChartReference;
  _links?: ReferenceLinks;

  /** The settings for the resource */
  settings?: Record<{}>;
}

model BoardChartReference {
  /** Name of the resource */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

model BoardColumn {
  @extension(
    "x-ms-enum",
    #{
      name: "BoardColumnType",
      values: #[
        #{ value: "incoming", description: "" },
        #{ value: "inProgress", description: "" },
        #{ value: "outgoing", description: "" }
      ],
    }
  )
  columnType?: "incoming" | "inProgress" | "outgoing";
  description?: string;
  @format("uuid") id?: string;
  isSplit?: boolean;
  itemLimit?: int32;
  name?: string;
  stateMappings?: Record<string>;
}

model BoardFields {
  columnField?: FieldReference;
  doneField?: FieldReference;
  rowField?: FieldReference;
}

model BoardReference {
  /** Id of the resource */
  @format("uuid") id?: string;

  /** Name of the resource */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

model BoardRow {
  color?: string;
  @format("uuid") id?: string;
  name?: string;
}

model BoardSuggestedValue {
  name?: string;
}

model BoardUserSettings {
  autoRefreshState?: boolean;
}

model CapacityContractBase {
  ...TeamSettingsDataContractBase;

  /** Collection of capacities associated with the team member */
  activities?: Activity[];

  /** The days off associated with the team member */
  daysOff?: DateRange[];
}

/** Expected data from PATCH */
model CapacityPatch {
  activities?: Activity[];
  daysOff?: DateRange[];
}

/** Card settings, such as fields and rules */
model CardFieldSettings {
  /** A collection of field information of additional fields on cards. The index in the collection signifies the order of the field among the additional fields. Currently unused. Should be used with User Story 691539: Card setting: additional fields */
  additionalFields?: FieldInfo[];

  /** Display format for the assigned to field */
  @extension(
    "x-ms-enum",
    #{
      name: "IdentityDisplayFormat",
      values: #[
        #{ value: "avatarOnly", description: "Display avatar only" },
        #{ value: "fullName", description: "Display Full name only" },
        #{ value: "avatarAndFullName", description: "Display Avatar and Full name" }
      ],
    }
  )
  assignedToDisplayFormat?: "avatarOnly" | "fullName" | "avatarAndFullName";

  /** A collection of field information of rendered core fields on cards. */
  coreFields?: FieldInfo[];

  /** Flag indicating whether to show assigned to field on cards. When true, AssignedToDisplayFormat will determine how the field will be displayed */
  showAssignedTo?: boolean;

  /** Flag indicating whether to show child rollup on cards */
  showChildRollup?: boolean;

  /** Flag indicating whether to show empty fields on cards */
  showEmptyFields?: boolean;

  /** Flag indicating whether to show ID on cards */
  showId?: boolean;

  /** Flag indicating whether to show parent field on cards */
  showParent?: boolean;

  /** Flag indicating whether to show state field on cards */
  showState?: boolean;

  /** Flag indicating whether to show tags on cards */
  showTags?: boolean;
}

/** Card settings, such as fields and rules */
model CardSettings {
  fields?: CardFieldSettings;
}

/** Details about a given backlog category */
model CategoryConfiguration {
  /** Name */
  name?: string;

  /** Category Reference Name */
  referenceName?: string;

  /** Work item types for the backlog category */
  workItemTypes?: WorkItemTypeReference[];
}

model CreatePlan {
  /** Description of the plan */
  description?: string;

  /** Name of the plan to create. */
  name?: string;

  /** Plan properties. */
  properties?: {};

  /** Type of plan to create. */
  @extension(
    "x-ms-enum",
    #{ name: "PlanType", values: #[#{ value: "deliveryTimelineView", description: "" }] }
  )
  type?: "deliveryTimelineView";
}

model DateRange {
  /** End of the date range. */
  end?: utcDateTime;

  /** Start of the date range. */
  start?: utcDateTime;
}

/** Data contract for Data of Delivery View */
model DeliveryViewData {
  ...PlanViewData;

  /** Work item child id to parent id map */
  childIdToParentIdMap?: Record<int32>;

  criteriaStatus?: TimelineCriteriaStatus;

  /** The end date of the delivery view data */
  endDate?: utcDateTime;

  /** Max number of teams that can be configured for a delivery plan */
  maxExpandedTeams?: int32;

  /** Mapping between parent id, title and all the child work item ids */
  parentItemMaps?: ParentChildWIMap[];

  /** The start date for the delivery view data */
  startDate?: utcDateTime;

  /** All the team data */
  teams?: TimelineTeamData[];

  /** List of all work item ids that have a dependency but not a violation */
  workItemDependencies?: int32[];

  /** List of all work item ids that have a violation */
  workItemViolations?: int32[];
}

/** Collection of properties, specific to the DeliveryTimelineView */
model DeliveryViewPropertyCollection {
  cardSettings?: CardSettings;

  /** Field criteria */
  criteria?: FilterClause[];

  /** Markers. Will be missing/null if there are no markers. */
  markers?: Marker[];

  /** Card style settings */
  styleSettings?: Rule[];

  /** tag style settings */
  tagStyleSettings?: Rule[];

  /** Team backlog mappings */
  teamBacklogMappings?: TeamBacklogMapping[];
}

/** Object bag storing the set of permissions relevant to this plan */
model FieldInfo {
  /** The additional field display name */
  displayName?: string;

  /** The additional field type */
  @extension(
    "x-ms-enum",
    #{
      name: "FieldType",
      values: #[
        #{ value: "string", description: "" },
        #{ value: "plainText", description: "" },
        #{ value: "integer", description: "" },
        #{ value: "dateTime", description: "" },
        #{ value: "treePath", description: "" },
        #{ value: "boolean", description: "" },
        #{ value: "double", description: "" }
      ],
    }
  )
  fieldType?: "string" | "plainText" | "integer" | "dateTime" | "treePath" | "boolean" | "double";

  /** Indicates if the field definition is for an identity field. */
  isIdentity?: boolean;

  /** The additional field reference name */
  referenceName?: string;
}

/** An abstracted reference to a field */
model FieldReference {
  /** fieldRefName for the field */
  referenceName?: string;

  /** Full http link to more information about the field */
  url?: string;
}

model FieldSetting {}

model FilterClause {
  fieldName?: string;
  index?: int32;
  logicalOperator?: string;
  operator?: string;
  value?: string;
}

model FilterGroup {
  end?: int32;
  level?: int32;
  start?: int32;
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

model ITaskboardColumnMapping {
  state?: string;
  workItemType?: string;
}

/** Capacity and teams for all teams in an iteration */
model IterationCapacity {
  teams?: TeamCapacityTotals[];
  totalIterationCapacityPerDay?: float64;
  totalIterationDaysOff?: int32;
}

/** Represents work items in an iteration backlog */
model IterationWorkItems {
  ...TeamSettingsDataContractBase;

  /** Work item relations */
  workItemRelations?: WorkItemLink[];
}

/** Link description. */
model Link {
  /** Collection of link attributes. */
  attributes?: Record<{}>;

  /** Relation type. */
  rel?: string;

  /** Link url. */
  url?: string;
}

/** Client serialization contract for Delivery Timeline Markers. */
model Marker {
  /** Color associated with the marker. */
  color?: string;

  /** Where the marker should be displayed on the timeline. */
  date?: utcDateTime;

  /** Label/title for the marker. */
  label?: string;
}

model Member {
  displayName?: string;
  @format("uuid") id?: string;
  imageUrl?: string;
  uniqueName?: string;
  url?: string;
}

model ParentChildWIMap {
  childWorkItemIds?: int32[];
  id?: int32;
  teamProject?: string;
  title?: string;
  workItemTypeName?: string;
}

/** Data contract for the plan definition */
model Plan {
  createdByIdentity?: IdentityRef;

  /** Date when the plan was created */
  createdDate?: utcDateTime;

  /** Description of the plan */
  description?: string;

  /** Id of the plan */
  @format("uuid") id?: string;

  /** Date when the plan was last accessed. Default is null. */
  lastAccessed?: utcDateTime;

  modifiedByIdentity?: IdentityRef;

  /** Date when the plan was last modified. Default to CreatedDate when the plan is first created. */
  modifiedDate?: utcDateTime;

  /** Name of the plan */
  name?: string;

  /** The PlanPropertyCollection instance associated with the plan. These are dependent on the type of the plan. For example, DeliveryTimelineView, it would be of type DeliveryViewPropertyCollection. */
  properties?: {};

  /** Revision of the plan. Used to safeguard users from overwriting each other's changes. */
  revision?: int32;

  /** Type of the plan */
  @extension(
    "x-ms-enum",
    #{ name: "PlanType", values: #[#{ value: "deliveryTimelineView", description: "" }] }
  )
  type?: "deliveryTimelineView";

  /** The resource url to locate the plan via rest api */
  url?: string;

  /** Bit flag indicating set of permissions a user has to the plan. */
  @extension(
    "x-ms-enum",
    #{
      name: "PlanUserPermissions",
      values: #[
        #{ value: "none", description: "None" },
        #{ value: "view", description: "Permission to view this plan." },
        #{ value: "edit", description: "Permission to update this plan." },
        #{ value: "delete", description: "Permission to delete this plan." },
        #{ value: "manage", description: "Permission to manage this plan." },
        #{ value: "allPermissions", description: "Full control permission for this plan." }
      ],
    }
  )
  userPermissions?: "none" | "view" | "edit" | "delete" | "manage" | "allPermissions";
}

/** Metadata about a plan definition that is stored in favorites service */
model PlanMetadata {
  createdByIdentity?: IdentityRef;

  /** Description of plan */
  description?: string;

  /** Last modified date of the plan */
  modifiedDate?: utcDateTime;

  /** Bit flag indicating set of permissions a user has to the plan. */
  @extension(
    "x-ms-enum",
    #{
      name: "PlanUserPermissions",
      values: #[
        #{ value: "none", description: "None" },
        #{ value: "view", description: "Permission to view this plan." },
        #{ value: "edit", description: "Permission to update this plan." },
        #{ value: "delete", description: "Permission to delete this plan." },
        #{ value: "manage", description: "Permission to manage this plan." },
        #{ value: "allPermissions", description: "Full control permission for this plan." }
      ],
    }
  )
  userPermissions?: "none" | "view" | "edit" | "delete" | "manage" | "allPermissions";
}

/** Base class for plan view data contracts. Anything common goes here. */
model PlanViewData {
  @format("uuid") id?: string;
  revision?: int32;
}

/** Represents a single pre-defined query. */
model PredefinedQuery {
  /** Whether or not the query returned the complete set of data or if the data was truncated. */
  hasMore?: boolean;

  /** Id of the query */
  id?: string;

  /** Localized name of the query */
  name?: string;

  /** The results of the query. This will be a set of WorkItem objects with only the 'id' set. The client is responsible for paging in the data as needed. */
  results?: WorkItem[];

  /** REST API Url to use to retrieve results for this query */
  url?: string;

  /** Url to use to display a page in the browser with the results of this query */
  webUrl?: string;
}

/** Process Configurations for the project */
model ProcessConfiguration {
  bugWorkItems?: CategoryConfiguration;

  /** Details about portfolio backlogs */
  portfolioBacklogs?: CategoryConfiguration[];

  requirementBacklog?: CategoryConfiguration;
  taskBacklog?: CategoryConfiguration;

  /** Type fields for the process configuration */
  typeFields?: Record<WorkItemFieldReference>;

  url?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** Represents a reorder request for one or more work items. */
model ReorderOperation {
  /** IDs of the work items to be reordered. Must be valid WorkItem Ids. */
  ids?: int32[];

  /** IterationPath for reorder operation. This is only used when we reorder from the Iteration Backlog */
  iterationPath?: string;

  /** ID of the work item that should be after the reordered items. Can use 0 to specify the end of the list. */
  nextId?: int32;

  /** Parent ID for all of the work items involved in this operation. Can use 0 to indicate the items don't have a parent. */
  parentId?: int32;

  /** ID of the work item that should be before the reordered items. Can use 0 to specify the beginning of the list. */
  previousId?: int32;
}

/** Represents a reorder result for a work item. */
model ReorderResult {
  /** The ID of the work item that was reordered. */
  id?: int32;

  /** The updated order value of the work item that was reordered. */
  order?: float64;
}

model Rule {
  clauses?: FilterClause[];
  filter?: string;
  isEnabled?: string;
  name?: string;
  settings?: attribute;
}

/** Represents the taskbord column */
model TaskboardColumn {
  /** Column ID */
  @format("uuid") id?: string;

  /** Work item type states mapped to this column to support auto state update when column is updated. */
  mappings?: ITaskboardColumnMapping[];

  /** Column name */
  name?: string;

  /** Column position relative to other columns in the same board */
  order?: int32;
}

/** Represents the state to column mapping per work item type This allows auto state update when the column changes */
model TaskboardColumnMapping {
  /** State of the work item type mapped to the column */
  state?: string;

  /** Work Item Type name who's state is mapped to the column */
  workItemType?: string;
}

model TaskboardColumns {
  columns?: TaskboardColumn[];

  /** Are the columns cutomized for this team */
  isCustomized?: boolean;

  /** Specifies if the referenced WIT and State is valid */
  isValid?: boolean;

  /** Details of validation failure if the state to column mapping is invalid */
  validationMesssage?: string;
}

/** Column value of a work item in the taskboard */
model TaskboardWorkItemColumn {
  /** Work item column value in the taskboard */
  column?: string;

  /** Work item column id in the taskboard */
  @format("uuid") columnId?: string;

  /** Work Item state value */
  state?: string;

  /** Work item id */
  workItemId?: int32;
}

model TeamAutomationRulesSettingsRequestModel {
  backlogLevelName?: string;
  rulesStates?: Record<boolean>;
}

/** Mapping of teams to the corresponding work item category */
model TeamBacklogMapping {
  categoryReferenceName?: string;
  @format("uuid") teamId?: string;
}

/** Represents team member capacity with totals aggregated */
model TeamCapacity {
  teamMembers?: TeamMemberCapacityIdentityRef[];
  totalCapacityPerDay?: float64;
  totalDaysOff?: int32;
}

/** Team information with total capacity and days off */
model TeamCapacityTotals {
  teamCapacityPerDay?: float64;
  @format("uuid") teamId?: string;
  teamTotalDaysOff?: int32;
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

/** Represents a single TeamFieldValue */
model TeamFieldValue {
  includeChildren?: boolean;
  value?: string;
}

/** Essentially a collection of team field values */
model TeamFieldValues {
  ...TeamSettingsDataContractBase;

  /** The default team field value */
  defaultValue?: string;

  field?: FieldReference;

  /** Collection of all valid team field values */
  values?: TeamFieldValue[];
}

/** Expected data from PATCH */
model TeamFieldValuesPatch {
  defaultValue?: string;
  values?: TeamFieldValue[];
}

model TeamIterationAttributes {
  /** Finish date of the iteration. Date-only, correct unadjusted at midnight in UTC. */
  finishDate?: utcDateTime;

  /** Start date of the iteration. Date-only, correct unadjusted at midnight in UTC. */
  startDate?: utcDateTime;

  /** Time frame of the iteration, such as past, current or future. */
  @extension(
    "x-ms-enum",
    #{
      name: "TimeFrame",
      values: #[
        #{ value: "past", description: "" },
        #{ value: "current", description: "" },
        #{ value: "future", description: "" }
      ],
    }
  )
  timeFrame?: "past" | "current" | "future";
}

/** Represents capacity for a specific team member */
model TeamMemberCapacity {
  ...CapacityContractBase;
  teamMember?: Member;
}

/** Represents capacity for a specific team member */
model TeamMemberCapacityIdentityRef {
  ...CapacityContractBase;
  teamMember?: IdentityRef;
}

/** Data contract for TeamSettings */
model TeamSetting {
  ...TeamSettingsDataContractBase;
  backlogIteration?: TeamSettingsIteration;

  /** Information about categories that are visible on the backlog. */
  backlogVisibilities?: Record<boolean>;

  /** BugsBehavior (Off, AsTasks, AsRequirements, ...) */
  @extension(
    "x-ms-enum",
    #{
      name: "BugsBehavior",
      values: #[
        #{ value: "off", description: "" },
        #{ value: "asRequirements", description: "" },
        #{ value: "asTasks", description: "" }
      ],
    }
  )
  bugsBehavior?: "off" | "asRequirements" | "asTasks";

  defaultIteration?: TeamSettingsIteration;

  /** Default Iteration macro (if any) */
  defaultIterationMacro?: string;

  /** Days that the team is working */
  workingDays?: (
    | "sunday"
    | "monday"
    | "tuesday"
    | "wednesday"
    | "thursday"
    | "friday"
    | "saturday")[];
}

/** Base class for TeamSettings data contracts. Anything common goes here. */
model TeamSettingsDataContractBase {
  _links?: ReferenceLinks;

  /** Full http link to the resource */
  url?: string;
}

model TeamSettingsDaysOff {
  ...TeamSettingsDataContractBase;
  daysOff?: DateRange[];
}

model TeamSettingsDaysOffPatch {
  daysOff?: DateRange[];
}

/** Represents a shallow ref for a single iteration. */
model TeamSettingsIteration {
  ...TeamSettingsDataContractBase;
  attributes?: TeamIterationAttributes;

  /** Id of the iteration. */
  @format("uuid") id?: string;

  /** Name of the iteration. */
  name?: string;

  /** Relative path of the iteration. */
  path?: string;
}

/** Data contract for what we expect to receive when PATCH */
model TeamSettingsPatch {
  @format("uuid") backlogIteration?: string;
  backlogVisibilities?: Record<boolean>;
  @extension(
    "x-ms-enum",
    #{
      name: "BugsBehavior",
      values: #[
        #{ value: "off", description: "" },
        #{ value: "asRequirements", description: "" },
        #{ value: "asTasks", description: "" }
      ],
    }
  )
  bugsBehavior?: "off" | "asRequirements" | "asTasks";
  @format("uuid") defaultIteration?: string;
  defaultIterationMacro?: string;
  workingDays?: (
    | "sunday"
    | "monday"
    | "tuesday"
    | "wednesday"
    | "thursday"
    | "friday"
    | "saturday")[];
}

model TimelineCriteriaStatus {
  message?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "TimelineCriteriaStatusCode",
      values: #[
        #{ value: "ok", description: "No error - filter is good." },
        #{ value: "invalidFilterClause", description: "One of the filter clause is invalid." },
        #{ value: "unknown", description: "Unknown error." }
      ],
    }
  )
  type?: "ok" | "invalidFilterClause" | "unknown";
}

model TimelineIterationStatus {
  message?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "TimelineIterationStatusCode",
      values: #[
        #{ value: "ok", description: "No error - iteration data is good." },
        #{
          value: "isOverlapping",
          description: "This iteration overlaps with another iteration, no data is returned for this iteration.",
        }
      ],
    }
  )
  type?: "ok" | "isOverlapping";
}

model TimelineTeamData {
  backlog?: BacklogLevel;

  /** The field reference names of the work item data */
  fieldReferenceNames?: string[];

  /** The id of the team */
  @format("uuid") id?: string;

  /** Was iteration and work item data retrieved for this team. <remarks> Teams with IsExpanded false have not had their iteration, work item, and field related data queried and will never contain this data. If true then these items are queried and, if there are items in the queried range, there will be data. </remarks> */
  isExpanded?: boolean;

  /** The iteration data, including the work items, in the queried date range. */
  iterations?: TimelineTeamIteration[];

  /** The name of the team */
  name?: string;

  /** The order by field name of this team */
  orderByField?: string;

  /** The field reference names of the partially paged work items, such as ID, WorkItemType */
  partiallyPagedFieldReferenceNames?: string[];

  partiallyPagedWorkItems?: {}[][];

  /** The project id the team belongs team */
  @format("uuid") projectId?: string;

  /** Work item types for which we will collect roll up data on the client side */
  rollupWorkItemTypes?: string[];

  status?: TimelineTeamStatus;

  /** The team field default value */
  teamFieldDefaultValue?: string;

  /** The team field name of this team */
  teamFieldName?: string;

  /** The team field values */
  teamFieldValues?: TeamFieldValue[];

  /** Work items associated with the team that are not under any of the team's iterations */
  workItems?: {}[][];

  /** Colors for the work item types. */
  workItemTypeColors?: WorkItemColor[];
}

model TimelineTeamIteration {
  /** The iteration CSS Node Id */
  cssNodeId?: string;

  /** The end date of the iteration */
  finishDate?: utcDateTime;

  /** The iteration name */
  name?: string;

  /** All the partially paged workitems in this iteration. */
  partiallyPagedWorkItems?: {}[][];

  /** The iteration path */
  path?: string;

  /** The start date of the iteration */
  startDate?: utcDateTime;

  status?: TimelineIterationStatus;

  /** The work items that have been paged in this iteration */
  workItems?: {}[][];
}

model TimelineTeamStatus {
  message?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "TimelineTeamStatusCode",
      values: #[
        #{ value: "ok", description: "No error - all data for team is good." },
        #{
          value: "doesntExistOrAccessDenied",
          description: "Team does not exist or access is denied.",
        },
        #{
          value: "maxTeamsExceeded",
          description: "Maximum number of teams was exceeded. No team data will be returned for this team.",
        },
        #{
          value: "maxTeamFieldsExceeded",
          description: "Maximum number of team fields (ie Area paths) have been exceeded. No team data will be returned for this team.",
        },
        #{
          value: "backlogInError",
          description: "Backlog does not exist or is missing crucial information.",
        },
        #{
          value: "missingTeamFieldValue",
          description: "Team field value is not set for this team. No team data will be returned for this team",
        },
        #{
          value: "noIterationsExist",
          description: "Team does not have a single iteration with date range.",
        }
      ],
    }
  )
  type?:
    | "ok"
    | "doesntExistOrAccessDenied"
    | "maxTeamsExceeded"
    | "maxTeamFieldsExceeded"
    | "backlogInError"
    | "missingTeamFieldValue"
    | "noIterationsExist";
}

model UpdatePlan {
  /** Description of the plan */
  description?: string;

  /** Name of the plan to create. */
  name?: string;

  /** Plan properties. */
  properties?: {};

  /** Revision of the plan that was updated - the value used here should match the one the server gave the client in the Plan. */
  revision?: int32;

  /** Type of the plan */
  @extension(
    "x-ms-enum",
    #{ name: "PlanType", values: #[#{ value: "deliveryTimelineView", description: "" }] }
  )
  type?: "deliveryTimelineView";
}

model UpdateTaskboardColumn {
  /** Column ID, keep it null for new column */
  @format("uuid") id?: string;

  /** Work item type states mapped to this column to support auto state update when column is updated. */
  mappings?: TaskboardColumnMapping[];

  /** Column name is required */
  name?: string;

  /** Column position relative to other columns in the same board */
  order?: int32;
}

model UpdateTaskboardWorkItemColumn {
  newColumn?: string;
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

/** Describes a work item. */
model WorkItem {
  ...WorkItemTrackingResource;
  commentVersionRef?: WorkItemCommentVersionRef;

  /** Map of field and values for the work item. */
  fields?: Record<{}>;

  /** The work item ID. */
  id?: int32;

  /** Dictionary describing the Format for multiline fields selected by the last edit user. */
  multilineFieldsFormat?: Record<"markdown" | "html">;

  /** Relations of the work item. */
  relations?: WorkItemRelation[];

  /** Revision number of the work item. */
  rev?: int32;
}

/** Work item color and icon. */
model WorkItemColor {
  icon?: string;
  primaryColor?: string;
  workItemTypeName?: string;
}

/** Represents the reference to a specific version of a comment on a Work Item. */
model WorkItemCommentVersionRef {
  ...WorkItemTrackingResourceReference;

  /** The id assigned to the comment. */
  commentId?: int32;

  /** [Internal] The work item revision where this comment was originally added. */
  createdInRevision?: int32;

  /** [Internal] Specifies whether comment was deleted. */
  isDeleted?: boolean;

  /** [Internal] The text of the comment. */
  text?: string;

  /** The version number. */
  version?: int32;
}

/** Reference to a field in a work item */
model WorkItemFieldReference {
  /** The friendly name of the field. */
  name?: string;

  /** The reference name of the field. */
  referenceName?: string;

  /** The REST URL of the resource. */
  url?: string;
}

/** A link between two work items. */
model WorkItemLink {
  /** The type of link. */
  rel?: string;

  source?: WorkItemReference;
  target?: WorkItemReference;
}

/** Contains reference to a work item. */
model WorkItemReference {
  /** Work item ID. */
  id?: int32;

  /** REST API URL of the resource */
  url?: string;
}

model WorkItemRelation {
  ...Link;
}

/** Base class for WIT REST resources. */
model WorkItemTrackingResource {
  ...WorkItemTrackingResourceReference;
  _links?: ReferenceLinks;
}

/** Base class for work item tracking resource references. */
model WorkItemTrackingResourceReference {
  /** REST URL for the resource. */
  url?: string;
}

/** Reference to a work item type. */
model WorkItemTypeReference {
  ...WorkItemTrackingResourceReference;

  /** Name of the work item type. */
  name?: string;
}

model WorkItemTypeStateInfo {
  /** State name to state category map */
  states?: Record<string>;

  /** Work Item type name */
  workItemTypeName?: string;
}

/** Get available board columns in a project */
@tag("Boardcolumns")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boardcolumns")
@extension("x-ms-vss-method", "GetColumnSuggestedValues")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/boardcolumns")
@get
op Boardcolumns_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BoardSuggestedValue[]>;

/** Get available board rows in a project */
@tag("Boardrows")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boardrows")
@extension("x-ms-vss-method", "GetRowSuggestedValues")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/boardrows")
@get
op Boardrows_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @extension("x-ms-required", false) @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BoardSuggestedValue[]>;

/** Get an iteration's capacity for all teams in iteration */
@tag("Iterationcapacities")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "iterationcapacities")
@extension("x-ms-vss-method", "GetTotalIterationCapacities")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/iterations/{iterationId}/iterationcapacities")
@get
op Iterationcapacities_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  ...Parameters.`api-Version-preview`.`1`,
): IterationCapacity;

/** Get the information for all the plans configured for the given team */
@tag("Plans")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "plans")
@extension("x-ms-vss-method", "GetPlans")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/plans")
@get
op Plans_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<Plan[]>;

/** Add a new plan for the team */
@tag("Plans")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "plans")
@extension("x-ms-vss-method", "CreatePlan")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/plans")
@post
op Plans_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Plan definition */
  @body body: CreatePlan,
): Plan;

/** Delete the specified plan */
@tag("Plans")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "plans")
@extension("x-ms-vss-method", "DeletePlan")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/plans/{id}")
@delete
op Plans_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier of the plan */
  @path id: string,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Get the information for the specified plan */
@tag("Plans")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "plans")
@extension("x-ms-vss-method", "GetPlan")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/plans/{id}")
@get
op Plans_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier of the plan */
  @path id: string,

  ...Parameters.`api-Version-preview`.`1`,
): Plan;

/** Update the information for the specified plan */
@tag("Plans")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "plans")
@extension("x-ms-vss-method", "UpdatePlan")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/plans/{id}")
@put
op Plans_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier of the plan */
  @path id: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Plan definition to be updated */
  @body body: UpdatePlan,
): Plan;

/** Get Delivery View Data */
@tag("Deliverytimeline")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "deliverytimeline")
@extension("x-ms-vss-method", "GetDeliveryTimelineData")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/plans/{id}/deliverytimeline")
@get
op Deliverytimeline_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier for delivery view */
  @path id: string,

  /** Revision of the plan for which you want data. If the current plan is a different revision you will get an ViewRevisionMismatchException exception. If you do not supply a revision you will get data for the latest revision. */
  @query(#{ explode: true }) revision?: int32,

  /** The start date of timeline */
  @query(#{ explode: true }) startDate?: utcDateTime,

  /** The end date of timeline */
  @query(#{ explode: true }) endDate?: utcDateTime,

  ...Parameters.`api-Version-preview`.`1`,
): DeliveryViewData;

/** Retrieves the set of known queries */
@tag("Predefined Queries")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "predefinedQueries")
@extension("x-ms-vss-method", "GetPredefinedQueries")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/predefinedqueries")
@get
op `Predefined Queries_List`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<PredefinedQuery[]>;

/** Retrieves the specified predefined query including the query results */
@tag("Predefined Queries")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "predefinedQueries")
@extension("x-ms-vss-method", "GetPredefinedQueryResults")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/predefinedqueries/{id}")
@get
op `Predefined Queries_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Id of the query to run */
  @path id: string,

  /** The maximum number of items to return */
  @query(#{ explode: true }) $top?: int32,

  /** Whether or not to retrieve the 'completed' work items (work items in the 'completed' meta state) */
  @query(#{ explode: true }) includeCompleted?: boolean,

  ...Parameters.`api-Version-preview`.`1`,
): PredefinedQuery;

/** Get process configuration */
@tag("Processconfiguration")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "processconfiguration")
@extension("x-ms-vss-method", "GetProcessConfiguration")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/work/processconfiguration")
@get
op Processconfiguration_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): ProcessConfiguration;

/** Gets backlog configuration for a team */
@tag("Backlogconfiguration")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "backlogconfiguration")
@extension("x-ms-vss-method", "GetBacklogConfigurations")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/backlogconfiguration")
@get
op Backlogconfiguration_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): BacklogConfiguration;

/** List all backlog levels */
@tag("Backlogs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "backlogs")
@extension("x-ms-vss-method", "GetBacklogs")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/backlogs")
@get
op Backlogs_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BacklogLevelConfiguration[]>;

/** Get a list of work items within a backlog level */
@tag("Backlogs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "backlogs")
@extension("x-ms-vss-method", "GetBacklogLevelWorkItems")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/backlogs/{backlogId}/workItems")
@get
op `Backlogs_Get Backlog Level Work Items`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  @path backlogId: string,
  ...Parameters.`api-Version-preview`.`1`,
): BacklogLevelWorkItems;

/** Get a backlog level */
@tag("Backlogs")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "backlogs")
@extension("x-ms-vss-method", "GetBacklog")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/backlogs/{id}")
@get
op `Backlogs_Get Backlog`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  /** The id of the backlog level */
  @path id: string,

  ...Parameters.`api-Version-preview`.`1`,
): BacklogLevelConfiguration;

/** Get boards */
@tag("Boards")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boards")
@extension("x-ms-vss-method", "GetBoards")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards")
@get
op Boards_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BoardReference[]>;

/** Get board user settings for a board id */
@tag("Boardusersettings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boardusersettings")
@extension("x-ms-vss-method", "GetBoardUserSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/boardusersettings")
@get
op Boardusersettings_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Board ID or Name */
  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): BoardUserSettings;

/** Update board user settings for the board id We don't want stakeholders to update board settings (currently just autorefresh). The BacklogManagement feature check validates this. */
@tag("Boardusersettings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boardusersettings")
@extension("x-ms-vss-method", "UpdateBoardUserSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/boardusersettings")
@patch
op Boardusersettings_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: Record<string>,
): BoardUserSettings;

/** Get board card Rule settings for the board id or board by name */
@tag("Cardrulesettings")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "cardrulesettings")
@extension("x-ms-vss-method", "GetBoardCardRuleSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/cardrulesettings")
@get
op Cardrulesettings_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`2`,
): BoardCardRuleSettings;

/** Update board card Rule settings for the board id or board by name */
@tag("Cardrulesettings")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "cardrulesettings")
@extension("x-ms-vss-method", "UpdateBoardCardRuleSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/cardrulesettings")
@patch
op `Cardrulesettings_Update Board Card Rule Settings`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`2`,
  @body body: BoardCardRuleSettings,
): BoardCardRuleSettings;

/** Get board card settings for the board id or board by name */
@tag("Cardsettings")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "cardsettings")
@extension("x-ms-vss-method", "GetBoardCardSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/cardsettings")
@get
op Cardsettings_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`2`,
): BoardCardSettings;

/** Update board card settings for the board id or board by name */
@tag("Cardsettings")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "cardsettings")
@extension("x-ms-vss-method", "UpdateBoardCardSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/cardsettings")
@put
op `Cardsettings_Update Board Card Settings`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`2`,
  @body body: BoardCardSettings,
): BoardCardSettings;

/** Get a board chart image. */
@tag("Chartimages")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "chartimages")
@extension("x-ms-vss-method", "GetBoardChartImage")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/chartimages/{name}")
@get
op `Chartimages_Get Board Chart Image`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  /** Identifier for board, either board's backlog level name (e.g. 'Issues') or Id. */
  @path board: string,

  /** The chart name. e.g. CumulativeFlow. */
  @path name: string,

  /** The width of the chart in pixels. Must be greater than 0. */
  @query(#{ explode: true }) width?: int32,

  /** The height of the chart in pixels. Must be greater than 0. */
  @query(#{ explode: true }) height?: int32,

  /** Whether or not the chart should include detailed information (e.g. axis labels, titles, trend lines, etc.). */
  @query(#{ explode: true }) showDetails?: boolean,

  /** The title of the chart. Can only be dislayed if ShowLabels is true. */
  @query(#{ explode: true }) title?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<string>;

/** Get board charts */
@tag("Charts")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "charts")
@extension("x-ms-vss-method", "GetBoardCharts")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/charts")
@get
op Charts_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier for board, either board's backlog level name (Eg:'Stories') or Id */
  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BoardChartReference[]>;

/** Get a board chart */
@tag("Charts")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "charts")
@extension("x-ms-vss-method", "GetBoardChart")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/charts/{name}")
@get
op Charts_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier for board, either board's backlog level name (Eg:'Stories') or Id */
  @path board: string,

  /** The chart name */
  @path name: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): BoardChart;

/** Update a board chart */
@tag("Charts")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "charts")
@extension("x-ms-vss-method", "UpdateBoardChart")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/charts/{name}")
@patch
op Charts_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Identifier for board, either board's backlog level name (Eg:'Stories') or Id */
  @path board: string,

  /** The chart name */
  @path name: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: BoardChart,
): BoardChart;

/** Get columns on a board */
@tag("Columns")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "columns")
@extension("x-ms-vss-method", "GetBoardColumns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/columns")
@get
op Columns_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Name or ID of the specific board */
  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BoardColumn[]>;

/** Update columns on a board */
@tag("Columns")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "columns")
@extension("x-ms-vss-method", "UpdateBoardColumns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/columns")
@put
op Columns_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Name or ID of the specific board */
  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** List of board columns to update */
  @body body: BoardColumn[],
): Body<BoardColumn[]>;

/** Get rows on a board */
@tag("Rows")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "rows")
@extension("x-ms-vss-method", "GetBoardRows")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/rows")
@get
op Rows_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Name or ID of the specific board */
  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BoardRow[]>;

/** Update rows on a board */
@tag("Rows")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "rows")
@extension("x-ms-vss-method", "UpdateBoardRows")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{board}/rows")
@put
op Rows_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Name or ID of the specific board */
  @path board: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** List of board rows to update */
  @body body: BoardRow[],
): Body<BoardRow[]>;

/** Get board */
@tag("Boards")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boards")
@extension("x-ms-vss-method", "GetBoard")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{id}")
@get
op Boards_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** identifier for board, either board's backlog level name (Eg:'Stories') or Id */
  @path id: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Board;

/** Update board options */
@tag("Boards")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boards")
@extension("x-ms-vss-method", "SetBoardOptions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/{id}")
@put
op `Boards_Set Board Options`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** identifier for board, either category plural name (Eg:'Stories') or guid */
  @path id: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** options to updated */
  @body body: Record<string>,
): Body<Record<string>>;

/** Returns the list of parent field filter model for the given list of workitem ids */
@tag("Boardparents")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "boardparents")
@extension("x-ms-vss-method", "GetBoardMappingParentItems")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/boards/boardparents")
@get
op Boardparents_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @query(#{ explode: true }) childBacklogContextCategoryRefName: string,
  @format("array (int32)") @query(#{ explode: true }) workitemIds: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<ParentChildWIMap[]>;

/** Get an iteration chart image. */
@tag("Chartimages")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "chartimages")
@extension("x-ms-vss-method", "GetIterationChartImage")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/iterations/{iterationId}/chartimages/{name}")
@get
op `Chartimages_Get Iteration Chart Image`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  /** ID of the iteration. */
  @format("uuid") @path iterationId: string,

  /** The chart name. e.g. Burndown. */
  @path name: string,

  /** The width of the chart in pixels. Must be greater than 0. */
  @query(#{ explode: true }) width?: int32,

  /** The height of the chart in pixels. Must be greater than 0. */
  @query(#{ explode: true }) height?: int32,

  /** Whether or not the chart should include detailed information (e.g. axis labels, titles, trend lines, etc.) */
  @query(#{ explode: true }) showDetails?: boolean,

  /** The title of the chart. Can only be dislayed if ShowLabels is true. */
  @query(#{ explode: true }) title?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<string>;

/** Reorder Sprint Backlog/Taskboard Work Items */
@tag("Workitemsorder")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "workitemsorder")
@extension("x-ms-vss-method", "ReorderIterationWorkItems")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/iterations/{iterationId}/workitemsorder")
@patch
op `Workitemsorder_Reorder Iteration Work Items`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  /** The id of the iteration */
  @format("uuid") @path iterationId: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: ReorderOperation,
): Body<ReorderResult[]>;

/** Get an iterations chart image. */
@tag("Chartimages")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "chartimages")
@extension("x-ms-vss-method", "GetIterationsChartImage")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/iterations/chartimages/{name}")
@get
op `Chartimages_Get Iterations Chart Image`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  /** The chart name. e.g. Velocity. */
  @path name: string,

  /** Number of iterations the chart is for. */
  @query(#{ explode: true }) iterationsNumber?: int32,

  /** The width of the chart in pixels. Must be greater than 0. */
  @query(#{ explode: true }) width?: int32,

  /** The height of the chart in pixels. Must be greater than 0. */
  @query(#{ explode: true }) height?: int32,

  /** Whether or not the chart should include detailed information (e.g. axis labels, titles, trend lines, etc.) */
  @query(#{ explode: true }) showDetails?: boolean,

  /** The title of the chart. Can only be dislayed if ShowLabels is true. */
  @query(#{ explode: true }) title?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<string>;

/** Update taskboard card Rule settings */
@tag("Cardrulesettings")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "cardrulesettings")
@extension("x-ms-vss-method", "UpdateTaskboardCardRuleSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/taskboard/cardrulesettings")
@patch
op `Cardrulesettings_Update Taskboard Card Rule Settings`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  ...Parameters.`api-Version-preview`.`2`,
  @body body: BoardCardRuleSettings,
): OkResponse;

/** Update taskboard card settings */
@tag("Cardsettings")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "cardsettings")
@extension("x-ms-vss-method", "UpdateTaskboardCardSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/taskboard/cardsettings")
@put
op `Cardsettings_Update Taskboard Card Settings`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  ...Parameters.`api-Version-preview`.`2`,
  @body body: BoardCardSettings,
): OkResponse;

@tag("Taskboard Columns")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "taskboardColumns")
@extension("x-ms-vss-method", "GetColumns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/taskboardcolumns")
@get
op `Taskboard Columns_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): TaskboardColumns;

@tag("Taskboard Columns")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "taskboardColumns")
@extension("x-ms-vss-method", "UpdateColumns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/taskboardcolumns")
@put
op `Taskboard Columns_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: UpdateTaskboardColumn[],
): TaskboardColumns;

@tag("Taskboard Work Items")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "taskboardWorkItems")
@extension("x-ms-vss-method", "GetWorkItemColumns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/taskboardworkitems/{iterationId}")
@get
op `Taskboard Work Items_List`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  @format("uuid") @path iterationId: string,
  ...Parameters.`api-Version-preview`.`1`,
): Body<TaskboardWorkItemColumn[]>;

@tag("Taskboard Work Items")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "taskboardWorkItems")
@extension("x-ms-vss-method", "UpdateWorkItemColumn")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/taskboardworkitems/{iterationId}/{workItemId}")
@patch
op `Taskboard Work Items_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  @format("uuid") @path iterationId: string,
  @path workItemId: int32,
  ...Parameters.`api-Version-preview`.`1`,
  @body body: UpdateTaskboardWorkItemColumn,
): OkResponse;

/** Get a team's settings */
@tag("Teamsettings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "teamsettings")
@extension("x-ms-vss-method", "GetTeamSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings")
@get
op Teamsettings_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): TeamSetting;

/** Update a team's settings */
@tag("Teamsettings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "teamsettings")
@extension("x-ms-vss-method", "UpdateTeamSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings")
@patch
op Teamsettings_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** TeamSettings changes */
  @body body: TeamSettingsPatch,
): TeamSetting;

/** Get a team's iterations using timeframe filter */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "iterations")
@extension("x-ms-vss-method", "GetTeamIterations")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations")
@get
op Iterations_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  /** A filter for which iterations are returned based on relative time. Only Current is supported currently. */
  @query(#{ explode: true }) $timeframe?: string,

  ...Parameters.`api-Version-preview`.`1`,
): Body<TeamSettingsIteration[]>;

/** Add an iteration to the team */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "iterations")
@extension("x-ms-vss-method", "PostTeamIteration")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations")
@post
op `Iterations_Post Team Iteration`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Iteration to add */
  @body body: TeamSettingsIteration,
): TeamSettingsIteration;

/** Delete a team's iteration by iterationId */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "iterations")
@extension("x-ms-vss-method", "DeleteTeamIteration")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{id}")
@delete
op Iterations_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path id: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Get team's iteration by iterationId */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "iterations")
@extension("x-ms-vss-method", "GetTeamIteration")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{id}")
@get
op Iterations_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path id: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): TeamSettingsIteration;

/** Get a team's capacity including total capacity and days off */
@tag("Capacities")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "capacities")
@extension("x-ms-vss-method", "GetCapacitiesWithIdentityRefAndTotals")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/capacities")
@get
op `Capacities_Get Capacities With Identity Ref And Totals`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`3`,
): TeamCapacity;

/** Replace a team's capacity */
@tag("Capacities")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "capacities")
@extension("x-ms-vss-method", "ReplaceCapacitiesWithIdentityRef")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/capacities")
@put
op `Capacities_Replace Capacities With Identity Ref`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** Team capacity to replace */
  @body body: TeamMemberCapacityIdentityRef[],
): Body<TeamMemberCapacityIdentityRef[]>;

/** Get a team member's capacity */
@tag("Capacities")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "capacities")
@extension("x-ms-vss-method", "GetCapacityWithIdentityRef")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/capacities/{teamMemberId}")
@get
op `Capacities_Get Capacity With Identity Ref`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** ID of the team member */
  @format("uuid") @path teamMemberId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`3`,
): TeamMemberCapacityIdentityRef;

/** Update a team member's capacity */
@tag("Capacities")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "capacities")
@extension("x-ms-vss-method", "UpdateCapacityWithIdentityRef")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/capacities/{teamMemberId}")
@patch
op Capacities_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** ID of the team member */
  @format("uuid") @path teamMemberId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** Updated capacity */
  @body body: CapacityPatch,
): TeamMemberCapacityIdentityRef;

/** Get team's days off for an iteration */
@tag("Teamdaysoff")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "teamdaysoff")
@extension("x-ms-vss-method", "GetTeamDaysOff")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/teamdaysoff")
@get
op Teamdaysoff_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): TeamSettingsDaysOff;

/** Set a team's days off for an iteration */
@tag("Teamdaysoff")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "teamdaysoff")
@extension("x-ms-vss-method", "UpdateTeamDaysOff")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/teamdaysoff")
@patch
op Teamdaysoff_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Team's days off patch containing a list of start and end dates */
  @body body: TeamSettingsDaysOffPatch,
): TeamSettingsDaysOff;

/** Get work items for iteration */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "workitems")
@extension("x-ms-vss-method", "GetIterationWorkItems")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/iterations/{iterationId}/workitems")
@get
op `Iterations_Get Iteration Work Items`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the iteration */
  @format("uuid") @path iterationId: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): IterationWorkItems;

/** Get a collection of team field values */
@tag("Teamfieldvalues")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "teamfieldvalues")
@extension("x-ms-vss-method", "GetTeamFieldValues")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/teamfieldvalues")
@get
op Teamfieldvalues_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
): TeamFieldValues;

/** Update team field values */
@tag("Teamfieldvalues")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "teamfieldvalues")
@extension("x-ms-vss-method", "UpdateTeamFieldValues")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/teamsettings/teamfieldvalues")
@patch
op Teamfieldvalues_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: TeamFieldValuesPatch,
): TeamFieldValues;

/** Reorder Product Backlog/Boards Work Items */
@tag("Workitemsorder")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "workitemsorder")
@extension("x-ms-vss-method", "ReorderBacklogWorkItems")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/work/workitemsorder")
@patch
op `Workitemsorder_Reorder Backlog Work Items`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @path team: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: ReorderOperation,
): Body<ReorderResult[]>;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `3` {
      /** Version of the API to use. This should be set to '7.2-preview.3' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
