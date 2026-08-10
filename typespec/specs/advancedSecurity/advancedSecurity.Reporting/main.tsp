import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Reporting" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://advsec.dev.azure.com")
namespace Reporting;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Represents an advanced filter configuration for the Reporting dashboard. */
model AdvancedFilter {
  ...AdvancedFilterCreate;
  _links?: ReferenceLinks;

  /** The identity of the user who last changed the advanced filter. */
  @format("uuid") changedBy?: string;

  /** The date and time when the advanced filter was last changed. */
  changedDate?: utcDateTime;

  /** The identity of the user who created the advanced filter. */
  @format("uuid") createdBy?: string;

  createdByIdentity?: IdentityRef;

  /** The date and time when the advanced filter was created. */
  createdDate?: utcDateTime;

  /** Unique identifier for the advanced filter. */
  @format("uuid") id?: string;

  /** Indicates whether the advanced filter has been soft-deleted. */
  isDeleted?: boolean;

  /** The URL of the advanced filter. */
  url?: string;
}

/** Represents the data required to create an advanced filter configuration for the Reporting dashboard. Also serves as the base class for AdvancedFilter. */
model AdvancedFilterCreate {
  filterCriteria?: CombinedAlertFilterCriteria;

  /** User-provided name for the advanced filter. */
  name?: string;
}

/** Represents the data required to update an advanced filter configuration. Only the name can be updated. */
model AdvancedFilterUpdate {
  /** The new name for the advanced filter. */
  name?: string;
}

/** Alert Summary by severity. */
model AlertSummaryBySeverity {
  /** Total Critical severity alerts. */
  critical?: int32;

  /** Total High severity alerts. */
  high?: int32;

  /** Total low severity alerts. */
  low?: int32;

  /** Total Medium severity alerts. */
  medium?: int32;

  /** Total Note severity alerts. */
  note?: int32;
}

/** Alert Summary by state. */
model AlertSummaryByState {
  /** Total Dismissed state alerts. */
  dismissed?: int32;

  /** Total Fixed state alerts. */
  fixed?: int32;

  /** Total New state alerts. */
  new?: int32;
}

/** Represents code scanning rule information for filtering purposes. */
model CodeScanningRuleInfo {
  /** The human-readable name of the rule. */
  friendlyName?: string;

  /** The opaque identifier of the rule (e.g., SARIF rule ID). */
  opaqueId?: string;

  /** The name of the tool that defines this rule. */
  toolName?: string;
}

model CombinedAlertFilterCriteria {
  /** If provided, only return alerts of the specified alert type. */
  @extension(
    "x-ms-enum",
    #{
      name: "AlertType",
      values: #[
        #{ value: "unknown", description: "The code has an unspecified vulnerability type" },
        #{
          value: "dependency",
          description: "The code uses a dependency with a known vulnerability.",
        },
        #{
          value: "secret",
          description: "The code contains a secret that has now been compromised and must be revoked.",
        },
        #{
          value: "code",
          description: "The code contains a weakness determined by static analysis.",
        }
      ],
    }
  )
  alertType?: "unknown" | "dependency" | "secret" | "code" | string;

  /** If provided, only return alerts with the specified validity status. */
  @extension(
    "x-ms-enum",
    #{
      name: "AlertValidityStatus",
      values: #[
        #{
          value: "none",
          description: "When there are no validation fingerprints attached to the alert.",
        },
        #{
          value: "unknown",
          description: "When the validations for validation fingerprints associated to the alert have not been conclusive.",
        },
        #{
          value: "active",
          description: "When at least one validation fingerprint associated to the alert is exploitable.",
        },
        #{
          value: "inactive",
          description: "When all validation fingerprints associated to the alert are not exploitable.",
        }
      ],
    }
  )
  alertValidityStatus?: "none" | "unknown" | "active" | "inactive" | string;

  /** If provided, only return dependency alerts for the specified package names. */
  componentNames?: string[];

  /** If provided, only return dependency alerts for the specified ecosystems (e.g., NuGet, Npm, Maven). */
  componentTypes?: (
    | "unknown"
    | "nuGet"
    | "npm"
    | "maven"
    | "git"
    | "other"
    | "rubyGems"
    | "cargo"
    | "pip"
    | "file"
    | "go"
    | "dockerImage"
    | "pod"
    | "linux"
    | "conda"
    | "dockerReference"
    | "vcpkg"
    | string)[];

  /** If provided, only return alerts with one of the specified dismissal types (closure reasons). Applicable only when filtering for closed/dismissed alerts. */
  dismissalTypes?: (
    | "unknown"
    | "fixed"
    | "acceptedRisk"
    | "falsePositive"
    | "agreedToGuidance"
    | "toolUpgrade"
    | "notDistributed"
    | string)[];

  /** If provided, only return alerts fixed on or before this date. */
  fixedDateEnd?: utcDateTime;

  /** If provided, only return alerts fixed on or after this date. */
  fixedDateStart?: utcDateTime;

  /** If provided, only return alerts introduced on or before this date. */
  introducedDateEnd?: utcDateTime;

  /** If provided, only return alerts introduced on or after this date. */
  introducedDateStart?: utcDateTime;

  /** If provided, only return alerts whose titles match this pattern. */
  keywords?: string;

  /** If provided, only return alerts for projects whose names are in this list. */
  projects?: string[];

  /** If provided, only return alerts for repositories whose names are in this list. */
  repositories?: string[];

  /** If provided, only return alerts for repositories whose IDs (GitRepositoryId) are in this list. */
  repositoryIds?: string[];

  /** If provided, only return code scanning alerts or secret alerts matching the specified rule names. */
  ruleNames?: string[];

  /** If provided, only return secret alerts matching the specified secret types (rule friendly name or opaque ID). */
  secretTypes?: string[];

  /** If provided, only return alerts with the specified severities. Otherwise, return alerts at any severity. */
  severities?: (
    | "low"
    | "medium"
    | "high"
    | "critical"
    | "note"
    | "warning"
    | "error"
    | "undefined"
    | string)[];

  /** If provided, return alerts that are active or inactive based on this value. <br />Otherwise, return alerts in any state. */
  @extension(
    "x-ms-enum",
    #{
      name: "DashboardAlertState",
      values: #[
        #{
          value: "open",
          description: "Alert has been detected in the code and corresponds to 'Active' state.",
        },
        #{
          value: "closed",
          description: "Alert corresponds to 'Unknown', 'Dismissed', 'Fixed' or 'AutoDismissed' states.",
        }
      ],
    }
  )
  state?: "open" | "closed" | string;

  /** If provided, only return code scanning alerts detected by the specified tools. */
  toolNames?: string[];
}

/** An alert entity used in the dashboard for combined alerts. */
model DashboardAlert {
  /** Identifier for the alert. It is unique within Azure DevOps organization. */
  alertId?: int64;

  /** Type of the alert. E.g. secret, code, etc. */
  @extension(
    "x-ms-enum",
    #{
      name: "AlertType",
      values: #[
        #{ value: "unknown", description: "The code has an unspecified vulnerability type" },
        #{
          value: "dependency",
          description: "The code uses a dependency with a known vulnerability.",
        },
        #{
          value: "secret",
          description: "The code contains a secret that has now been compromised and must be revoked.",
        },
        #{
          value: "code",
          description: "The code contains a weakness determined by static analysis.",
        }
      ],
    }
  )
  alertType?: "unknown" | "dependency" | "secret" | "code" | string;

  /** This value is computed and returned by the service. This value represents the first time the vulnerability was introduced. */
  introducedDate?: utcDateTime;

  /** This value is computed and returned by the service. It is a value based on the results from all analysis configurations. An example of a physical location is a file location. */
  locations?: DashboardAlertPhysicalLocation[];

  /** Name of the project where the alert was detected. */
  projectName?: string;

  /** Name of the repository where the alert was detected. */
  repositoryName?: string;

  /** Severity of the alert. */
  @extension(
    "x-ms-enum",
    #{
      name: "Severity",
      values: #[
        #{ value: "low", description: "" },
        #{ value: "medium", description: "" },
        #{ value: "high", description: "" },
        #{ value: "critical", description: "" },
        #{ value: "note", description: "" },
        #{ value: "warning", description: "" },
        #{ value: "error", description: "" },
        #{ value: "undefined", description: "" }
      ],
    }
  )
  severity?:
    | "low"
    | "medium"
    | "high"
    | "critical"
    | "note"
    | "warning"
    | "error"
    | "undefined"
    | string;

  /** This value is computed and returned by the service. It is a value based on the results from all analysis configurations. */
  @extension(
    "x-ms-enum",
    #{
      name: "State",
      values: #[
        #{ value: "unknown", description: "Alert is in an indeterminate state" },
        #{ value: "active", description: "Alert has been detected in the code" },
        #{ value: "dismissed", description: "Alert was dismissed by a user" },
        #{ value: "fixed", description: "The issue is no longer detected in the code" },
        #{
          value: "autoDismissed",
          description: "The tool has determined that the issue is no longer a risk",
        }
      ],
    }
  )
  state?: "unknown" | "active" | "dismissed" | "fixed" | "autoDismissed" | string;

  /** Title will only be rendered as text and does not support markdown formatting. There is a maximum character limit of 256. */
  title?: string;

  /** A truncated/obfuscated version of the secret pertaining to the alert (if applicable). */
  truncatedSecret?: string;

  /** Validity status of an alert. Currently, this is only applicable to secret alerts. In case of secret alerts, the validity status is computed by looking at the liveness results for validation fingerprints associated to an alert. */
  @extension(
    "x-ms-enum",
    #{
      name: "AlertValidityStatus",
      values: #[
        #{
          value: "none",
          description: "When there are no validation fingerprints attached to the alert.",
        },
        #{
          value: "unknown",
          description: "When the validations for validation fingerprints associated to the alert have not been conclusive.",
        },
        #{
          value: "active",
          description: "When at least one validation fingerprint associated to the alert is exploitable.",
        },
        #{
          value: "inactive",
          description: "When all validation fingerprints associated to the alert are not exploitable.",
        }
      ],
    }
  )
  validityStatus?: "none" | "unknown" | "active" | "inactive" | string;
}

/** Location in the source control system where the issue was found */
model DashboardAlertPhysicalLocation {
  alertId?: int64;

  /** Path of the file where the issue was found */
  filePath?: string;

  region?: Region;
}

model EnablementFilterCriteria {
  /** If provided, only return repos whose titles match this pattern. */
  keywords?: string;

  /** If provided, only return summary data for these projects. Otherwise, return summary data for all projects. */
  projects?: string[];

  states?: EnablementStateTypes;
}

model EnablementStateTypes {
  /** True if any tool is enabled for the repository, false if any tool is disabled. */
  anyTool?: boolean;

  /** True if code scanning alerts are enabled for the repository, false if disabled. */
  codeAlerts?: boolean;

  /** True if code scanning pull request alerts are enabled for the repository, false if disabled. */
  codePRAlerts?: boolean;

  /** True if dependency alerts are enabled for the repository, false if disabled. */
  dependencyAlerts?: boolean;

  /** True if dependency pull request alerts are enabled for the repository, false if disabled. */
  dependencyPRAlerts?: boolean;

  /** True if pushes containing secrets will be blocked, false if they will not. */
  pushProtection?: boolean;

  /** True if secret scanning is enabled for the repository, false if disabled. */
  secretAlerts?: boolean;
}

model FilterCriteria {
  /** If provided, only return summary data for alerts of this type. Otherwise, return summary data for alerts of all types. */
  alertTypes?: ("unknown" | "dependency" | "secret" | "code" | string)[];

  /** If provided, only return repos whose titles match this pattern. */
  keywords?: string;

  /** If provided, summary data will be scoped to this time period. */
  @extension(
    "x-ms-enum",
    #{
      name: "TimePeriod",
      values: #[
        #{ value: "undefined", description: "" },
        #{ value: "last24Hours", description: "" },
        #{ value: "last7Days", description: "" },
        #{ value: "last14Days", description: "" },
        #{ value: "last30Days", description: "" },
        #{ value: "last90Days", description: "" }
      ],
    }
  )
  period?:
    | "undefined"
    | "last24Hours"
    | "last7Days"
    | "last14Days"
    | "last30Days"
    | "last90Days"
    | string;

  /** If provided, only return summary data for these projects Otherwise, return summary data for all projects. */
  projects?: string[];

  /** If provided, only return summary data for alerts at these severities. <br />Otherwise, return summary data for alerts at any severity. */
  severities?: (
    | "low"
    | "medium"
    | "high"
    | "critical"
    | "note"
    | "warning"
    | "error"
    | "undefined"
    | string)[];
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

/** Org Alert Summary. */
model OrgAlertSummary {
  /** Org Id. */
  @format("uuid") orgId?: string;

  /** A list of Project summary data. */
  projects?: ProjectAlertSummary[];
}

/** Org Enablement Summary. */
model OrgEnablementSummary {
  /** Org Id. */
  @format("uuid") orgId?: string;

  /** A list of Project Enablement data. */
  projects?: ProjectEnablementSummary[];
}

model Project {
  @format("uuid") id?: string;
  name?: string;
}

/** Project Alert Summary. */
model ProjectAlertSummary {
  /** Project Id. */
  @format("uuid") projectId?: string;

  /** Project Name. */
  projectName?: string;

  /** A list of RepoAlertSummary data. */
  repos?: RepoAlertSummary[];
}

/** Represents project and repository information for filtering purposes. */
model ProjectAndRepoInfo {
  /** The unique identifier of the project. */
  @format("uuid") projectId?: string;

  /** The name of the project. */
  projectName?: string;

  /** The unique identifier of the repository. */
  @format("uuid") repositoryId?: string;

  /** The name of the repository. */
  repositoryName?: string;
}

/** Project Enablement Summary. */
model ProjectEnablementSummary {
  /** Project Id. */
  @format("uuid") projectId?: string;

  /** Project Name. */
  projectName?: string;

  /** A list of RepoEnablementSummary data. */
  repos?: RepoEnablementSummary[];
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model Region {
  /** The column where the code snippet ends */
  columnEnd?: int32;

  /** The column where the code snippet starts */
  columnStart?: int32;

  /** The line number where the code snippet ends */
  lineEnd?: int32;

  /** The line number where the code snippet starts */
  lineStart?: int32;
}

/** Repo Alert Summary. */
model RepoAlertSummary {
  alertsBySeverity?: AlertSummaryBySeverity;
  alertsByState?: AlertSummaryByState;

  /** Total active alerts in the repo. */
  openAlerts?: int32;

  /** RepoId. */
  @format("uuid") repoId?: string;

  /** Repo Name. */
  repoName?: string;

  /** Total active alerts in the repo. */
  totalAlerts?: int32;
}

/** Repo Enablement Summary. */
model RepoEnablementSummary {
  /** AdvSec is enabled for the repo. */
  advSecIsEnabled?: boolean;

  /** Code Security plan is enabled for the repo. Only present for Azure Dev Ops orgs who had enabled Advanced security after billing sku split has went live. */
  codeSecurityEnabled?: boolean;

  /** RepoId. */
  @format("uuid") repoId?: string;

  /** Repo Name. */
  repoName?: string;

  /** Repo scan type metadata for different scan types. */
  scanTypeMetadata?: Record<ScanTypeSummaryMetadata>;

  /** Repo enablement summary for different scan types. */
  scanTypeSummary?: Record<ScanTypeSummaryProperties>;

  /** Secret Protection plan is enabled for the repo. Only present for Azure Dev Ops orgs who had enabled Advanced security after billing sku split has went live. */
  secretProtectionEnabled?: boolean;
}

model ReportingUXComputedFilters {
  /** Display reporting for specified projects. Show reporting for all projects if none are specified. */
  projects?: Project[];
}

/** Metadata for a scan type. */
model ScanTypeSummaryMetadata {
  /** The date and time of the last scan for the associated alert type/repo combination. Null if no scan has been performed. */
  lastScanDate?: utcDateTime;
}

model ScanTypeSummaryProperties {
  alerts?: ScanTypeSummaryPropertiesData;
  prAlerts?: ScanTypeSummaryPropertiesData;
  pushProtection?: ScanTypeSummaryPropertiesData;
}

model ScanTypeSummaryPropertiesData {
  /** Represents the state of the scan type summary property. */
  enabled?: boolean;
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

/** A collection of `AdvancedFilter` as returned by Azure DevOps. */
model AdvancedFilterList {
  count?: int32;
  value?: AdvancedFilter[];
}

/** A collection of `DashboardAlert` as returned by Azure DevOps. */
model DashboardAlertList {
  count?: int32;
  value?: DashboardAlert[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface FiltersSettings {
  /** Gets all advanced filters for the organization. */
  @tag("Filters Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "filtersSettings")
  @extension("x-ms-vss-method", "ListAdvancedFilters")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/filtersSettings/alertsbatch")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Whether to include soft-deleted filters. */
    @query(#{ explode: true }) includeDeleted?: boolean,

    /** Optional filter to search filters by name (case-insensitive, partial match). */
    @query(#{ explode: true }) keywords?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AdvancedFilterList;

  /** Creates a new advanced filter for the organization. */
  @tag("Filters Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "filtersSettings")
  @extension("x-ms-vss-method", "CreateAdvancedFilter")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/filtersSettings/alertsbatch")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The advanced filter to create. */
    @body body: AdvancedFilterCreate,
  ): AdvancedFilter;

  /** Deletes an advanced filter. */
  @tag("Filters Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "filtersSettings")
  @extension("x-ms-vss-method", "DeleteAdvancedFilter")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/filtersSettings/alertsbatch/{filterId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the advanced filter to delete. */
    @format("uuid") @path filterId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Gets a specific advanced filter by its ID. */
  @tag("Filters Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "filtersSettings")
  @extension("x-ms-vss-method", "GetAdvancedFilter")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/filtersSettings/alertsbatch/{filterId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the advanced filter to retrieve. */
    @format("uuid") @path filterId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AdvancedFilter;

  /** Updates an advanced filter. Only the name can be updated. */
  @tag("Filters Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "filtersSettings")
  @extension("x-ms-vss-method", "UpdateAdvancedFilter")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/filtersSettings/alertsbatch/{filterId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the advanced filter to update. */
    @format("uuid") @path filterId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The update data containing the new name. */
    @body body: AdvancedFilterUpdate,
  ): OkResponse;
}

interface SummaryDashboard {
  /** Get Alert summary by severity for the org */
  @tag("Summary Dashboard")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "summaryDashboard")
  @extension("x-ms-vss-method", "GetAlertSummaryForOrg")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/summary/alerts")
  @get
  GetAlertSummaryForOrg(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** If provided, only return summary data for alerts of this type. Otherwise, return summary data for alerts of all types. */
    @query(#{ name: "criteria.alertTypes" }) criteriaAlertTypes?: string[],

    /** If provided, only return repos whose titles match this pattern. */
    @query(#{ name: "criteria.keywords", explode: true }) criteriaKeywords?: string,

    /** If provided, summary data will be scoped to this time period. */
    @extension(
      "x-ms-enum",
      #{
        name: "TimePeriod",
        values: #[
          #{ value: "undefined", description: "" },
          #{ value: "last24Hours", description: "" },
          #{ value: "last7Days", description: "" },
          #{ value: "last14Days", description: "" },
          #{ value: "last30Days", description: "" },
          #{ value: "last90Days", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    `criteria.period`?:
      | "undefined"
      | "last24Hours"
      | "last7Days"
      | "last14Days"
      | "last30Days"
      | "last90Days",

    /** If provided, only return summary data for these projects Otherwise, return summary data for all projects. */
    @query(#{ name: "criteria.projects" }) criteriaProjects?: string[],

    /** If provided, only return summary data for alerts at these severities. <br />Otherwise, return summary data for alerts at any severity. */
    @query(#{ name: "criteria.severities" }) criteriaSeverities?: string[],

    ...Parameters.`api-Version-preview`.`1`,
  ): OrgAlertSummary;

  /** Get Combined Alerts for the org */
  @tag("Summary Dashboard")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "summaryDashboard")
  @extension("x-ms-vss-method", "GetCombinedAlertsForOrg")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/summary/alertsbatch")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** If provided, only return alerts of the specified alert type. */
    @extension(
      "x-ms-enum",
      #{
        name: "AlertType",
        values: #[
          #{ value: "unknown", description: "The code has an unspecified vulnerability type" },
          #{
            value: "dependency",
            description: "The code uses a dependency with a known vulnerability.",
          },
          #{
            value: "secret",
            description: "The code contains a secret that has now been compromised and must be revoked.",
          },
          #{
            value: "code",
            description: "The code contains a weakness determined by static analysis.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `criteria.alertType`?: "unknown" | "dependency" | "secret" | "code",

    /** If provided, only return alerts with the specified validity status. */
    @extension(
      "x-ms-enum",
      #{
        name: "AlertValidityStatus",
        values: #[
          #{
            value: "none",
            description: "When there are no validation fingerprints attached to the alert.",
          },
          #{
            value: "unknown",
            description: "When the validations for validation fingerprints associated to the alert have not been conclusive.",
          },
          #{
            value: "active",
            description: "When at least one validation fingerprint associated to the alert is exploitable.",
          },
          #{
            value: "inactive",
            description: "When all validation fingerprints associated to the alert are not exploitable.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `criteria.alertValidityStatus`?: "none" | "unknown" | "active" | "inactive",

    /** If provided, only return dependency alerts for the specified package names. */
    @query(#{ name: "criteria.componentNames" }) criteriaComponentNames?: string[],

    /** If provided, only return dependency alerts for the specified ecosystems (e.g., NuGet, Npm, Maven). */
    @query(#{ name: "criteria.componentTypes" }) criteriaComponentTypes?: string[],

    /** If provided, only return alerts with one of the specified dismissal types (closure reasons). Applicable only when filtering for closed/dismissed alerts. */
    @query(#{ name: "criteria.dismissalTypes" }) criteriaDismissalTypes?: string[],

    /** If provided, only return alerts fixed on or before this date. */
    @query(#{ name: "criteria.fixedDateEnd", explode: true }) criteriaFixedDateEnd?: utcDateTime,

    /** If provided, only return alerts fixed on or after this date. */
    @query(#{ name: "criteria.fixedDateStart", explode: true }) criteriaFixedDateStart?: utcDateTime,

    /** If provided, only return alerts introduced on or before this date. */
    @query(#{ name: "criteria.introducedDateEnd", explode: true }) criteriaIntroducedDateEnd?: utcDateTime,

    /** If provided, only return alerts introduced on or after this date. */
    @query(#{ name: "criteria.introducedDateStart", explode: true }) criteriaIntroducedDateStart?: utcDateTime,

    /** If provided, only return alerts whose titles match this pattern. */
    @query(#{ name: "criteria.keywords", explode: true }) criteriaKeywords?: string,

    /** If provided, only return alerts for projects whose names are in this list. */
    @query(#{ name: "criteria.projects" }) criteriaProjects?: string[],

    /** If provided, only return alerts for repositories whose names are in this list. */
    @query(#{ name: "criteria.repositories" }) criteriaRepositories?: string[],

    /** If provided, only return alerts for repositories whose IDs (GitRepositoryId) are in this list. */
    @query(#{ name: "criteria.repositoryIds" }) criteriaRepositoryIds?: string[],

    /** If provided, only return code scanning alerts or secret alerts matching the specified rule names. */
    @query(#{ name: "criteria.ruleNames" }) criteriaRuleNames?: string[],

    /** If provided, only return secret alerts matching the specified secret types (rule friendly name or opaque ID). */
    @query(#{ name: "criteria.secretTypes" }) criteriaSecretTypes?: string[],

    /** If provided, only return alerts with the specified severities. Otherwise, return alerts at any severity. */
    @query(#{ name: "criteria.severities" }) criteriaSeverities?: string[],

    /** If provided, return alerts that are active or inactive based on this value. <br />Otherwise, return alerts in any state. */
    @extension(
      "x-ms-enum",
      #{
        name: "DashboardAlertState",
        values: #[
          #{
            value: "open",
            description: "Alert has been detected in the code and corresponds to 'Active' state.",
          },
          #{
            value: "closed",
            description: "Alert corresponds to 'Unknown', 'Dismissed', 'Fixed' or 'AutoDismissed' states.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    `criteria.state`?: "open" | "closed",

    /** If provided, only return code scanning alerts detected by the specified tools. */
    @query(#{ name: "criteria.toolNames" }) criteriaToolNames?: string[],

    /** The maximum number of alerts to return */
    @query(#{ explode: true }) top?: int32,

    /** If there are more alerts than can be returned, a continuation token is placed in the 'x-ms-continuationtoken' header. Use that token here to get the next page of alerts */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: DashboardAlertList;
  };

  /** Get Enablement summary for the org */
  @tag("Summary Dashboard")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "summaryDashboard")
  @extension("x-ms-vss-method", "GetEnablementSummaryForOrg")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/reporting/summary/enablement")
  @get
  GetEnablementSummaryForOrg(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** If provided, only return repos whose titles match this pattern. */
    @query(#{ name: "criteria.keywords", explode: true }) criteriaKeywords?: string,

    /** If provided, only return summary data for these projects. Otherwise, return summary data for all projects. */
    @query(#{ name: "criteria.projects" }) criteriaProjects?: string[],

    /** True if any tool is enabled for the repository, false if any tool is disabled. */
    @query(#{ name: "criteria.states.anyTool", explode: true }) criteriaStatesAnyTool?: boolean,

    /** True if code scanning alerts are enabled for the repository, false if disabled. */
    @query(#{ name: "criteria.states.codeAlerts", explode: true }) criteriaStatesCodeAlerts?: boolean,

    /** True if code scanning pull request alerts are enabled for the repository, false if disabled. */
    @query(#{ name: "criteria.states.codePRAlerts", explode: true }) criteriaStatesCodePRAlerts?: boolean,

    /** True if dependency alerts are enabled for the repository, false if disabled. */
    @query(#{ name: "criteria.states.dependencyAlerts", explode: true }) criteriaStatesDependencyAlerts?: boolean,

    /** True if dependency pull request alerts are enabled for the repository, false if disabled. */
    @query(#{ name: "criteria.states.dependencyPRAlerts", explode: true }) criteriaStatesDependencyPRAlerts?: boolean,

    /** True if pushes containing secrets will be blocked, false if they will not. */
    @query(#{ name: "criteria.states.pushProtection", explode: true }) criteriaStatesPushProtection?: boolean,

    /** True if secret scanning is enabled for the repository, false if disabled. */
    @query(#{ name: "criteria.states.secretAlerts", explode: true }) criteriaStatesSecretAlerts?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): OrgEnablementSummary;
}
