import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Management" })
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
namespace Management;

model AdvSecEnablementFeatures {
  /** Copilot Autofix enablement status set to False when disabled and True when enabled; Null is never explicitly set. Setting Autofix enablement state is only supported for repo enablement and not org or project enablement at this time. */
  autofixEnabled?: boolean;

  /** CodeQL default setup enablement status set to False when not using default setup and True when using default setup; Null is never explicitly set. */
  codeQLEnabled?: boolean;

  /** Dependency Scanning Injection enablement status set to False when disabled and True when enabled; Null is never explicitly set. <br /> If Advanced Security is NOT already enabled, behavior will depend on if Advanced Security is to be enabled/disabled. DependencyScanningInjectionEnabled will not affect anything in this scenario. <br /> If Advanced Security is to be disabled, the value of DependencyScanningInjectionEnabled will have no effect. <br /> Setting Dependency Scanning enablement state is only supported for repo enablement and not org or project enablement at this time. */
  dependencyScanningInjectionEnabled?: boolean;
}

model AdvSecEnablementSettings {
  /** Automatically enable blocking of pushes that contain secrets. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableBlockPushesOnCreate?: boolean;

  /** Automatically enable CodeQL. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableCodeQLOnCreate?: boolean;

  /** Automatically enable Dependabot. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableDependabotOnCreate?: boolean;

  /** Automatically enable Dependency Scanning Injection. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableDependencyScanningInjectionOnCreate?: boolean;

  /** Automatically enable Advanced Security on newly created repositories. */
  enableOnCreate?: boolean;

  reposEnablementStatus?: AdvSecEnablementStatus[];
}

model AdvSecEnablementSettingsUpdate {
  ...AdvSecEnablementStatusUpdate;

  /** Automatically enable blocking of pushes that contain secrets. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableBlockPushesOnCreate?: boolean;

  /** Automatically enable CodeQL. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableCodeQLOnCreate?: boolean;

  /** Automatically enable Dependabot. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableDependabotOnCreate?: boolean;

  /** Automatically enable Dependency Scanning Injection. If EnableOnCreate is not enabled this feature cannot be enabled. */
  enableDependencyScanningInjectionOnCreate?: boolean;

  /** Automatically enable Advanced Security on newly created repositories. */
  enableOnCreate?: boolean;
}

model AdvSecEnablementStatus {
  ...AdvSecEnablementStatusUpdate;

  /** The last time the status of Advanced Security for this repository was updated */
  advSecEnablementLastChangedDate?: utcDateTime;

  @format("uuid") projectId?: string;
  @format("uuid") repositoryId?: string;
}

model AdvSecEnablementStatusUpdate {
  /** Advanced Security enablement status set to False when disabled and True when enabled; Null is never explicitly set. */
  advSecEnabled?: boolean;

  advSecEnablementFeatures?: AdvSecEnablementFeatures;

  /** When true, pushes containing secrets will be blocked. <br />When false, pushes are scanned for secrets and are not blocked. <br />If includeAllProperties in the request is false, this value will be null. */
  blockPushes?: boolean;
}

/** This Data Contract contains the Advanced Security CodeQL One Click Details Panel Information */
model AgentPoolDetails {
  /** List of All Available agent pools in the org */
  allAvailableAgentPools?: string[];

  /** Currently selected pool Advanced Security is Using */
  currentAgentPool?: string;
}

/** Billable Committers Details for Advanced Security Services */
model BillableCommitterDetails {
  /** ID (SHA-1) of the commit. */
  commitId?: string;

  /** Committer email address after parsing. */
  committerEmail?: string;

  /** Time reported by the commit. */
  commitTime?: utcDateTime;

  /** DisplayName of the Pusher. */
  displayName?: string;

  /** MailNickName of the Pusher. */
  mailNickName?: string;

  /** Project Id commit was pushed to. */
  @format("uuid") projectId?: string;

  /** Project name commit was pushed to. */
  projectName?: string;

  /** Time of the push that contained the commit. */
  pushedTime?: utcDateTime;

  /** Pusher Id for the push. */
  @format("uuid") pusherId?: string;

  /** Push Id that contained the commit. */
  pushId?: int32;

  /** RepositoryId commit was pushed to. */
  @format("uuid") repoId?: string;

  /** Repository name commit was pushed to. */
  repoName?: string;

  /** SamAccountName of the Pusher. */
  samAccountName?: string;

  /** Visual Studio ID /Team Foundation ID */
  @format("uuid") vsid?: string;
}

/** Information related to billed committers using Advanced Security services */
model BilledCommitter {
  /** Cuid of the billed committer. CUID is unique across an Azure Subscription. */
  @format("uuid") cuid?: string;

  userIdentity?: IdentityRef;
}

/** A list of billed committers */
model BilledCommittersList {
  /** A list of BilledCommitter objects that contain the identityRef of committers. */
  billedUsers?: BilledCommitter[];

  /** Count of billed committers in BilledUsers */
  uniqueCommitterCount?: int32;
}

model BulkEnablementSettingsBase {
  codeSecurityFeatures?: CodeSecurityFeatures;
  enablementOnCreateSettings?: EnablementOnCreateSettings;

  /** A list of enablement statuses for repositories within the specified organization or project. */
  reposEnablementStatus?: RepoEnablementSettings[];

  secretProtectionFeatures?: SecretProtectionFeatures;
}

/** Contains the CodeQL default setup schedule configuration for an organization. */
model CodeQLScheduleDetails {
  /** The date and time (UTC) when the CodeQL default setup job last ran for this organization. Null if the job has never successfully run. */
  lastRunDate?: utcDateTime;

  /** The result code of the last job execution. 0=Succeeded, 1=PartiallySucceeded, 2=Failed, etc. Null if the job has never run. */
  lastRunResult?: int32;

  /** The day of the week (0=Sunday through 6=Saturday) when the CodeQL default setup scan should run. A value of -1 means no custom schedule is configured and the job runs on its default cadence. */
  scheduleDayOfWeek?: int32;
}

model CodeSecurityFeatures {
  /** Copilot Autofix enablement status set to False when disabled and True when enabled; Null is never explicitly set. Setting Autofix enablement state is only supported for repo enablement and not org or project enablement at this time. */
  autofixEnabled?: boolean;

  /** CodeQL default setup enablement status set to False when not using default setup and True when using default setup; Null is never explicitly set. */
  codeQLEnabled?: boolean;

  /** The VSID of the last user who modified the enablement status of Code Security. */
  @format("uuid") codeSecurityChangedBy?: string;

  /** Code Security enablement status set to False when disabled and True when enabled; Null is never explicitly set. */
  codeSecurityEnabled?: boolean;

  /** The last time the status of Code Security for this repository was updated */
  codeSecurityEnablementLastChangedDate?: utcDateTime;

  /** Dependency Scanning Injection enablement status set to False when disabled and True when enabled; Null is never explicitly set. <br /> If Advanced Security is NOT already enabled, behavior will depend on if Advanced Security is to be enabled/disabled. DependencyScanningInjectionEnabled will not affect anything in this scenario. <br /> If Advanced Security is to be disabled, the value of DependencyScanningInjectionEnabled will have no effect. */
  dependencyScanningInjectionEnabled?: boolean;
}

model EnablementOnCreateSettings {
  /** Automatically enable blocking of pushes that contain secrets when Secret Protection is auto-enabled. If EnableSecretProtectionOnCreate is not true this flag is ignored. */
  enableBlockPushesOnCreate?: boolean;

  /** Automatically enable CodeQL when Code Security is auto-enabled. If EnableCodeSecurityOnCreate is not true this flag is ignored. */
  enableCodeQLOnCreate?: boolean;

  /** Automatically enable Code Security on newly created repositories. */
  enableCodeSecurityOnCreate?: boolean;

  /** Automatically enable Dependabot when Code Security is auto-enabled. If EnableCodeSecurityOnCreate is not true this flag is ignored. */
  enableDependabotOnCreate?: boolean;

  /** Automatically enable Dependency Scanning Injection when Code Security is auto-enabled. If EnableCodeSecurityOnCreate is not true this flag is ignored. */
  enableDependencyScanningInjectionOnCreate?: boolean;

  /** Automatically enable Secret Protection on newly created repositories. */
  enableSecretProtectionOnCreate?: boolean;
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

/** Information related to billing for Advanced Security services */
model MeterUsage {
  /** The Azure DevOps account */
  @format("uuid") accountId?: string;

  @format("uuid") azureSubscriptionId?: string;

  /** Deprecated - use BilledCommittersIdentities instead A list of Cuids for the commiters to the repositories that have Advanced Security features enabled */
  billedCommitters?: string[];

  /** A list of BilledCommitter objects that contain the identityRef of committers that have AdvSec enabled */
  billedUsers?: BilledCommitter[];

  /** The date this billing information pertains to */
  billingDate?: utcDateTime;

  /** True when a bill is generated for Advanced Security feature usage in this organziation */
  isAdvSecBillable?: boolean;

  /** True when Advanced Security features are enabled in this organization */
  isAdvSecEnabled?: boolean;

  /** The Azure subscription */
  @format("uuid") tenantId?: string;

  /** The number of commiters to repositories that have Advanced Security features enabled */
  uniqueCommitterCount?: int32;
}

/** Information related to meter usage estimate for Code Security plan and/or Secret Protection plan */
model MeterUsageEstimate {
  codeSecurityMeterUsageEstimate?: BilledCommittersList;
  secretProtectionMeterUsageEstimate?: BilledCommittersList;
}

/** Information related to meter usage for a Scanning plan */
model MeterUsageForPlan {
  /** The Azure DevOps account */
  @format("uuid") accountId?: string;

  @format("uuid") azureSubscriptionId?: string;
  billedUsers?: BilledCommittersList;

  /** The date this billing information pertains to */
  billingDate?: utcDateTime;

  /** True when the Scanning plan is enabled in this organization */
  isPlanEnabled?: boolean;

  /** The Azure subscription */
  @format("uuid") tenantId?: string;
}

model OrgEnablementSettings {
  ...BulkEnablementSettingsBase;
}

model ProjectEnablementSettings {
  ...BulkEnablementSettingsBase;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model RepoEnablementSettings {
  codeSecurityFeatures?: CodeSecurityFeatures;

  /** The project Id */
  @format("uuid") projectId?: string;

  /** The repository Id */
  @format("uuid") repositoryId?: string;

  secretProtectionFeatures?: SecretProtectionFeatures;
}

model SecretProtectionFeatures {
  /** When true, pushes containing secrets will be blocked. <br />When false, pushes are scanned for secrets and are not blocked. <br />If includeAllProperties in the request is false, this value will be null. */
  blockPushes?: boolean;

  /** The VSID of the last user who modified the enablement status of Secret Protection. */
  @format("uuid") secretProtectionChangedBy?: string;

  /** Secret Protection enablement status set to False when disabled and True when enabled; Null is never explicitly set. */
  secretProtectionEnabled?: boolean;

  /** The last time the status of Secret Protection for this repository was updated */
  secretProtectionEnablementLastChangedDate?: utcDateTime;
}

/** Get the current status of Advanced Security for the organization */
@tag("Org Enablement")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "orgEnablement")
@extension("x-ms-vss-method", "GetOrgEnablementStatus2")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/management/enablement")
@get
op `Org Enablement_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** When true, also determine if pushes are blocked if they contain secrets */
  @query(#{ explode: true }) includeAllProperties?: boolean,

  ...Parameters.`api-Version-preview`.`3`,
): OrgEnablementSettings;

/** Update the status of Advanced Security for the organization */
@tag("Org Enablement")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "orgEnablement")
@extension("x-ms-vss-method", "UpdateOrgEnablementStatus2")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/management/enablement")
@patch
op `Org Enablement_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** The new status */
  @body body: OrgEnablementSettings,
): OkResponse;

/** Get commiters used when calculating billing information. */
@tag("Meter Usage")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "meterUsage")
@extension("x-ms-vss-method", "GetMeterUsage2")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/management/meterusage/default")
@get
op `Meter Usage_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The plan to query. Plans supported: CodeSecurity and SecretProtection. This is a mandatory parameter. */
  @extension(
    "x-ms-enum",
    #{
      name: "Plan",
      values: #[
        #{ value: "codeSecurity", description: "The Code Security plan" },
        #{ value: "secretProtection", description: "The Secret Protection plan" },
        #{ value: "all", description: "Include all plans" }
      ],
    }
  )
  @query(#{ explode: true })
  plan: "codeSecurity" | "secretProtection" | "all",

  /** The date to query, or if not provided, today */
  @query(#{ explode: true }) billingDate?: utcDateTime,

  ...Parameters.`api-Version-preview`.`3`,
): MeterUsageForPlan;

/** Estimate the pushers that would be added to the customer's usage if Advanced Security was enabled for this organization. */
@tag("Org Meter Usage Estimate")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "orgMeterUsageEstimate")
@extension("x-ms-vss-method", "GetEstimatedBillablePushersDetailsForOrg2")
@extension("x-ms-preview", true)
@route("/{organization}/_apis/management/meterUsageEstimate/default")
@get
op `Org Meter Usage Estimate_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** The plan to query. */
  @extension(
    "x-ms-enum",
    #{
      name: "Plan",
      values: #[
        #{ value: "codeSecurity", description: "The Code Security plan" },
        #{ value: "secretProtection", description: "The Secret Protection plan" },
        #{ value: "all", description: "Include all plans" }
      ],
    }
  )
  @query(#{ explode: true })
  plan?: "codeSecurity" | "secretProtection" | "all",

  ...Parameters.`api-Version-preview`.`3`,
): MeterUsageEstimate;

/** Get the current status of Advanced Security for a project */
@tag("Project Enablement")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "projectEnablement")
@extension("x-ms-vss-method", "GetProjectEnablementStatus2")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/management/enablement")
@get
op `Project Enablement_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** When true, also determine if pushes are blocked if they contain secrets */
  @query(#{ explode: true }) includeAllProperties?: boolean,

  ...Parameters.`api-Version-preview`.`3`,
): ProjectEnablementSettings;

/** Update the status of Advanced Security for the project */
@tag("Project Enablement")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "projectEnablement")
@extension("x-ms-vss-method", "UpdateProjectEnablementStatus2")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/management/enablement")
@patch
op `Project Enablement_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** The new status */
  @body body: ProjectEnablementSettings,
): OkResponse;

/** Estimate the pushers that would be added to the customer's usage if Advanced Security was enabled for this project. */
@tag("Project Meter Usage Estimate")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "projectMeterUsageEstimate")
@extension("x-ms-vss-method", "GetEstimatedBillablePushersDetailsForProject2")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/management/meterUsageEstimate/default")
@get
op `Project Meter Usage Estimate_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @extension(
    "x-ms-enum",
    #{
      name: "Plan",
      values: #[
        #{ value: "codeSecurity", description: "The Code Security plan" },
        #{ value: "secretProtection", description: "The Secret Protection plan" },
        #{ value: "all", description: "Include all plans" }
      ],
    }
  )
  @query(#{ explode: true })
  plan?: "codeSecurity" | "secretProtection" | "all",
  ...Parameters.`api-Version-preview`.`3`,
): MeterUsageEstimate;

/** Determines if Code Security, Secret Protection, and their features are enabled for the repository. */
@tag("Repo Enablement")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "repoEnablement")
@extension("x-ms-vss-method", "GetRepoEnablementStatus2")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/management/repositories/{repository}/enablement")
@get
op `Repo Enablement_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name or ID of the repository */
  @path repository: string,

  /** When true, will also determine if pushes are blocked when secrets are detected */
  @query(#{ explode: true }) includeAllProperties?: boolean,

  ...Parameters.`api-Version-preview`.`3`,
): RepoEnablementSettings;

/** Update the enablement status of Code Security and Secret Protection, along with their respective features, for a given repository. */
@tag("Repo Enablement")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "repoEnablement")
@extension("x-ms-vss-method", "UpdateRepoAdvSecEnablementStatus2")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/management/repositories/{repository}/enablement")
@patch
op `Repo Enablement_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Name or ID of the repository */
  @path repository: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** new status */
  @body body: RepoEnablementSettings,
): OkResponse;

/** Estimate the pushers that would be added to the customer's usage if Advanced Security was enabled for this repository. */
@tag("Repo Meter Usage Estimate")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "repoMeterUsageEstimate")
@extension("x-ms-vss-method", "GetEstimatedBillableCommittersDetailsForRepo2")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/management/repositories/{repository}/meterUsageEstimate/default")
@get
op `Repo Meter Usage Estimate_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** The name or ID of the repository */
  @path repository: string,

  /** The plan to query. */
  @extension(
    "x-ms-enum",
    #{
      name: "Plan",
      values: #[
        #{ value: "codeSecurity", description: "The Code Security plan" },
        #{ value: "secretProtection", description: "The Secret Protection plan" },
        #{ value: "all", description: "Include all plans" }
      ],
    }
  )
  @query(#{ explode: true })
  plan?: "codeSecurity" | "secretProtection" | "all",

  ...Parameters.`api-Version-preview`.`3`,
): MeterUsageEstimate;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `3` {
      /** Version of the API to use. This should be set to '7.2-preview.3' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
