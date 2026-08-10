import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Dashboard" })
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
namespace Dashboard;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Copy options of a Dashboard. */
model CopyDashboardOptions {
  /** Dashboard Scope. Can be either Project or Project_Team */
  @extension(
    "x-ms-enum",
    #{
      name: "DashboardScope",
      values: #[
        #{
          value: "collection_User",
          description: "[DEPRECATED] Dashboard is scoped to the collection user.",
        },
        #{ value: "project_Team", description: "Dashboard is scoped to the team." },
        #{ value: "project", description: "Dashboard is scoped to the project." }
      ],
    }
  )
  copyDashboardScope?: "collection_User" | "project_Team" | "project" | string;

  /** When this flag is set to true,option to select the folder to copy Queries of copy dashboard will appear. */
  copyQueriesFlag?: boolean;

  /** Description of the dashboard */
  description?: string;

  /** Name of the dashboard */
  name?: string;

  /** ID of the project. Provided by service at creation time. */
  @format("uuid") projectId?: string;

  /** Path to which the queries should be copied of copy dashboard */
  @format("uuid") queryFolderPath?: string;

  /** Refresh interval of dashboard */
  refreshInterval?: int32;

  /** ID of the team. Provided by service at creation time */
  @format("uuid") teamId?: string;
}

model CopyDashboardResponse {
  copiedDashboard?: Dashboard;
  copyDashboardOptions?: CopyDashboardOptions;
}

/** Model of a Dashboard. */
model Dashboard {
  _links?: ReferenceLinks;

  /** Entity to which the dashboard is scoped. */
  @extension(
    "x-ms-enum",
    #{
      name: "DashboardScope",
      values: #[
        #{
          value: "collection_User",
          description: "[DEPRECATED] Dashboard is scoped to the collection user.",
        },
        #{ value: "project_Team", description: "Dashboard is scoped to the team." },
        #{ value: "project", description: "Dashboard is scoped to the project." }
      ],
    }
  )
  dashboardScope?: "collection_User" | "project_Team" | "project" | string;

  /** Description of the dashboard. */
  description?: string;

  /** Server defined version tracking value, used for edit collision detection. */
  eTag?: string;

  /** Dashboard Global Parameters Config */
  globalParametersConfig?: string;

  /** ID of the group for a dashboard. For team-scoped dashboards, this is the unique identifier for the team associated with the dashboard. For project-scoped dashboards this property is empty. */
  @format("uuid") groupId?: string;

  /** ID of the Dashboard. Provided by service at creation time. */
  @format("uuid") id?: string;

  /** Dashboard Last Accessed Date. */
  lastAccessedDate?: utcDateTime;

  /** Id of the person who modified Dashboard. */
  @format("uuid") modifiedBy?: string;

  /** Dashboard's last modified date. */
  modifiedDate?: utcDateTime;

  /** Name of the Dashboard. */
  name?: string;

  /** ID of the owner for a dashboard. For team-scoped dashboards, this is the unique identifier for the team associated with the dashboard. For project-scoped dashboards, this is the unique identifier for the user identity associated with the dashboard. */
  @format("uuid") ownerId?: string;

  /** Position of the dashboard, within a dashboard group. If unset at creation time, position is decided by the service. */
  position?: int32;

  /** Interval for client to automatically refresh the dashboard. Expressed in minutes. */
  refreshInterval?: int32;

  url?: string;

  /** The set of Widgets on the dashboard. */
  widgets?: Widget[];
}

/** Describes a list of dashboards associated to an owner. Currently, teams own dashboard groups. */
model DashboardGroup {
  _links?: ReferenceLinks;

  /** A list of Dashboards held by the Dashboard Group */
  dashboardEntries?: DashboardGroupEntry[];

  /** Deprecated: The old permission model describing the level of permissions for the current team. Pre-M125. */
  @extension(
    "x-ms-enum",
    #{
      name: "GroupMemberPermission",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "edit", description: "" },
        #{ value: "manage", description: "" },
        #{ value: "managePermissions", description: "" }
      ],
    }
  )
  permission?: "none" | "edit" | "manage" | "managePermissions" | string;

  /** A permissions bit mask describing the security permissions of the current team for dashboards. When this permission is the value None, use GroupMemberPermission. Permissions are evaluated based on the presence of a value other than None, else the GroupMemberPermission will be saved. */
  @extension(
    "x-ms-enum",
    #{
      name: "TeamDashboardPermission",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "read", description: "" },
        #{ value: "create", description: "" },
        #{ value: "edit", description: "" },
        #{ value: "delete", description: "" },
        #{ value: "managePermissions", description: "" }
      ],
    }
  )
  teamDashboardPermission?:
    | "none"
    | "read"
    | "create"
    | "edit"
    | "delete"
    | "managePermissions"
    | string;

  url?: string;
}

/** Dashboard group entry, wrapping around Dashboard (needed?) */
model DashboardGroupEntry {
  ...Dashboard;
}

/** Response from RestAPI when saving and editing DashboardGroupEntry */
model DashboardGroupEntryResponse {
  ...DashboardGroupEntry;
}

model DashboardResponse {
  ...DashboardGroupEntry;
}

/** Lightbox configuration */
model LightboxOptions {
  /** Height of desired lightbox, in pixels */
  height?: int32;

  /** True to allow lightbox resizing, false to disallow lightbox resizing, defaults to false. */
  resizable?: boolean;

  /** Width of desired lightbox, in pixels */
  width?: int32;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** versioning for an artifact as described at: http://semver.org/, of the form major.minor.patch. */
model SemanticVersion {
  /** Major version when you make incompatible API changes */
  major?: int32;

  /** Minor version when you add functionality in a backwards-compatible manner */
  minor?: int32;

  /** Patch version when you make backwards-compatible bug fixes */
  patch?: int32;
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

/** Widget data */
model Widget {
  _links?: ReferenceLinks;

  /** Refers to the allowed sizes for the widget. This gets populated when user wants to configure the widget */
  allowedSizes?: WidgetSize[];

  /** Read-Only Property from Dashboard Service. Indicates if settings are blocked for the current user. */
  areSettingsBlockedForUser?: boolean;

  /** Refers to unique identifier of a feature artifact. Used for pinning+unpinning a specific artifact. */
  artifactId?: string;

  configurationContributionId?: string;
  configurationContributionRelativeId?: string;
  contentUri?: string;

  /** The id of the underlying contribution defining the supplied Widget Configuration. */
  contributionId?: string;

  dashboard?: Dashboard;
  eTag?: string;
  @format("uuid") id?: string;
  isEnabled?: boolean;
  isNameConfigurable?: boolean;
  lightboxOptions?: LightboxOptions;
  loadingImageUrl?: string;
  name?: string;
  position?: WidgetPosition;
  settings?: string;
  settingsVersion?: SemanticVersion;
  size?: WidgetSize;
  typeId?: string;
  url?: string;
}

/** Contribution based information describing Dashboard Widgets. */
model WidgetMetadata {
  /** Sizes supported by the Widget. */
  allowedSizes?: WidgetSize[];

  /** Opt-in boolean that indicates if the widget requires the Analytics Service to function. Widgets requiring the analytics service are hidden from the catalog if the Analytics Service is not available. */
  analyticsServiceRequired?: boolean;

  /** Resource for an icon in the widget catalog. */
  catalogIconUrl?: string;

  /** Opt-in URL string pointing at widget information. Defaults to extension marketplace URL if omitted */
  catalogInfoUrl?: string;

  /** The id of the underlying contribution defining the supplied Widget custom configuration UI. Null if custom configuration UI is not available. */
  configurationContributionId?: string;

  /** The relative id of the underlying contribution defining the supplied Widget custom configuration UI. Null if custom configuration UI is not available. */
  configurationContributionRelativeId?: string;

  /** Indicates if the widget requires configuration before being added to dashboard. */
  configurationRequired?: boolean;

  /** Uri for the widget content to be loaded from . */
  contentUri?: string;

  /** The id of the underlying contribution defining the supplied Widget. */
  contributionId?: string;

  /** Optional default settings to be copied into widget settings. */
  defaultSettings?: string;

  /** Summary information describing the widget. */
  description?: string;

  /** Widgets can be disabled by the app store. We'll need to gracefully handle for: - persistence (Allow) - Requests (Tag as disabled, and provide context) */
  isEnabled?: boolean;

  /** Opt-out boolean that indicates if the widget supports widget name/title configuration. Widgets ignoring the name should set it to false in the manifest. */
  isNameConfigurable?: boolean;

  /** Opt-out boolean indicating if the widget is hidden from the catalog. Commonly, this is used to allow developers to disable creation of a deprecated widget. A widget must have a functional default state, or have a configuration experience, in order to be visible from the catalog. */
  isVisibleFromCatalog?: boolean;

  /** Keywords associated with this widget, non-filterable and invisible */
  keywords?: string[];

  lightboxOptions?: LightboxOptions;

  /** Resource for a loading placeholder image on dashboard */
  loadingImageUrl?: string;

  /** User facing name of the widget type. Each widget must use a unique value here. */
  name?: string;

  /** Publisher Name of this kind of widget. */
  publisherName?: string;

  /** Data contract required for the widget to function and to work in its container. */
  supportedScopes?: ("collection_User" | "project_Team" | string)[];

  /** Tags associated with this widget, visible on each widget and filterable. */
  tags?: string[];

  /** Contribution target IDs */
  targets?: string[];

  /** Deprecated: locally unique developer-facing id of this kind of widget. ContributionId provides a globally unique identifier for widget types. */
  typeId?: string;
}

model WidgetMetadataResponse {
  uri?: string;
  widgetMetadata?: WidgetMetadata;
}

model WidgetPosition {
  column?: int32;
  row?: int32;
}

/** Response from RestAPI when saving and editing Widget */
model WidgetResponse {
  ...Widget;
}

model WidgetSize {
  /** The Width of the widget, expressed in dashboard grid columns. */
  columnSpan?: int32;

  /** The height of the widget, expressed in dashboard grid rows. */
  rowSpan?: int32;
}

/** Wrapper class to support HTTP header generation using CreateResponse, ClientHeaderParameter and ClientResponseType in WidgetV2Controller */
model WidgetsVersionedList {
  eTag?: string[];
  widgets?: Widget[];
}

model WidgetTypesResponse {
  _links?: ReferenceLinks;
  uri?: string;
  widgetTypes?: WidgetMetadata[];
}

/** A collection of `Dashboard` as returned by Azure DevOps. */
model DashboardList {
  count?: int32;
  value?: Dashboard[];
}

/** A collection of `Widget` as returned by Azure DevOps. */
model WidgetList {
  count?: int32;
  value?: Widget[];
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
  }
}

interface WidgetTypes {
  /** Get all available widget metadata in alphabetical order, including widgets marked with isVisibleFromCatalog == false. */
  @tag("Widget Types")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "widgetTypes")
  @extension("x-ms-vss-method", "GetWidgetTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/dashboard/widgettypes")
  @get
  GetWidgetTypes(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @extension(
      "x-ms-enum",
      #{
        name: "WidgetScope",
        values: #[
          #{ value: "collection_User", description: "" },
          #{ value: "project_Team", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    $scope: "collection_User" | "project_Team",

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WidgetTypesResponse;

  /** Get the widget metadata satisfying the specified contribution ID. */
  @tag("Widget Types")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "widgetTypes")
  @extension("x-ms-vss-method", "GetWidgetMetadata")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/dashboard/widgettypes/{contributionId}")
  @get
  GetWidgetMetadata(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of Contribution for the Widget */
    @path contributionId: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): WidgetMetadataResponse;
}

interface Dashboards {
  /** Get a list of dashboards under a project. */
  @tag("Dashboards")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "dashboards")
  @extension("x-ms-vss-method", "GetDashboardsByProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): DashboardList;

  /** Create the supplied dashboard. */
  @tag("Dashboards")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "dashboards")
  @extension("x-ms-vss-method", "CreateDashboard")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`3`,

    /** The initial state of the dashboard */
    @body body: Dashboard,
  ): Dashboard;

  /** Update the name and position of dashboards in the supplied group, and remove omitted dashboards. Does not modify dashboard content. */
  @tag("Dashboards")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "dashboards")
  @extension("x-ms-vss-method", "ReplaceDashboards")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards")
  @put
  ReplaceDashboards(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`3`,
    @body body: DashboardGroup,
  ): DashboardGroup;

  /** Delete a dashboard given its ID. This also deletes the widgets associated with this dashboard. */
  @tag("Dashboards")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "dashboards")
  @extension("x-ms-vss-method", "DeleteDashboard")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard to delete. */
    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): OkResponse;

  /** Get a dashboard by its ID. */
  @tag("Dashboards")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "dashboards")
  @extension("x-ms-vss-method", "GetDashboard")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): Dashboard;

  /** Replace configuration for the specified dashboard. Replaces Widget list on Dashboard, only if property is supplied. */
  @tag("Dashboards")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "dashboards")
  @extension("x-ms-vss-method", "ReplaceDashboard")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}")
  @put
  ReplaceDashboard(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard to replace. */
    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`3`,

    /** The Configuration of the dashboard to replace. */
    @body body: Dashboard,
  ): Dashboard;
}

interface Widgets {
  /** Get widgets contained on the specified dashboard. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "GetWidgets")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets")
  @get
  GetWidgets(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard to read. */
    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    /** Dashboard Widgets Version */
    @header eTag?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): {
    @header ETag?: string;
    @body body: WidgetList;
  };

  /** Update the supplied widgets on the dashboard using supplied state. State of existing Widgets not passed in the widget list is preserved. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "UpdateWidgets")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets")
  @patch
  UpdateWidgets(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the Dashboard to modify. */
    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    /** Dashboard Widgets Version */
    @header eTag?: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** The set of widget states to update on the dashboard. */
    @body body: Widget[],
  ): {
    @header ETag?: string;
    @body body: WidgetList;
  };

  /** Create a widget on the specified dashboard. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "CreateWidget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of dashboard the widget will be added to. */
    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** State of the widget to add */
    @body body: Widget,
  ): Widget;

  /** Replace the widgets on specified dashboard with the supplied widgets. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "ReplaceWidgets")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets")
  @put
  ReplaceWidgets(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the Dashboard to modify. */
    @format("uuid") @path dashboardId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    /** Dashboard Widgets Version */
    @header eTag?: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Revised state of widgets to store for the dashboard. */
    @body body: Widget[],
  ): {
    @header ETag?: string;
    @body body: WidgetList;
  };

  /** Delete the specified widget. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "DeleteWidget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets/{widgetId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard containing the widget. */
    @format("uuid") @path dashboardId: string,

    /** ID of the widget to update. */
    @format("uuid") @path widgetId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Dashboard;

  /** Get the current state of the specified widget. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "GetWidget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets/{widgetId}")
  @get
  GetWidget(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard containing the widget. */
    @format("uuid") @path dashboardId: string,

    /** ID of the widget to read. */
    @format("uuid") @path widgetId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Widget;

  /** Perform a partial update of the specified widget. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "UpdateWidget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets/{widgetId}")
  @patch
  UpdateWidget(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard containing the widget. */
    @format("uuid") @path dashboardId: string,

    /** ID of the widget to update. */
    @format("uuid") @path widgetId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** Description of the widget changes to apply. All non-null fields will be replaced. */
    @body body: Widget,
  ): Widget;

  /** Override the state of the specified widget. */
  @tag("Widgets")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "widgets")
  @extension("x-ms-vss-method", "ReplaceWidget")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/{team}/_apis/dashboard/dashboards/{dashboardId}/widgets/{widgetId}")
  @put
  ReplaceWidget(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the dashboard containing the widget. */
    @format("uuid") @path dashboardId: string,

    /** ID of the widget to update. */
    @format("uuid") @path widgetId: string,

    /** Team ID or team name */
    @extension("x-ms-required", false) @path team: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** State to be written for the widget. */
    @body body: Widget,
  ): Widget;
}
