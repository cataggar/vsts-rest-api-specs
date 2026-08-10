import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Alert" })
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
namespace Alert;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model Alert {
  /** Additional properties of this alert. */
  additionalProperties?: Record<{}>;

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

  /** Confidence level of the alert. */
  @extension(
    "x-ms-enum",
    #{
      name: "Confidence",
      values: #[
        #{ value: "high", description: "High confidence level for alert" },
        #{ value: "other", description: "Other confidence level for alert" }
      ],
    }
  )
  confidence?: "high" | "other" | string;

  dismissal?: Dismissal;

  /** This value is computed and returned by the service. This value represents the first time the service has seen this issue reported in an analysis instance. */
  firstSeenDate?: utcDateTime;

  /** This value is computed and returned by the service. If the issue is fixed, this value represents the time the service has seen this issue fixed in an analysis instance. */
  fixedDate?: utcDateTime;

  /** Reference to a git object, e.g. branch ref. */
  gitRef?: string;

  /** Value indicates whether the alert comes from a SARIF uploaded by a trusted source. */
  hasTrustedSourceOrigin?: boolean;

  /** This value is computed and returned by the service. This value represents the first time the vulnerability was introduced. */
  introducedDate?: utcDateTime;

  /** Value indicates whether the alert can be auto-fixed by Copilot Autofix. True when the alert is a code scanning alert detected by CodeQL with a supported rule. Null when the value has not been computed for this code path. */
  isAutoFixable?: boolean;

  /** This value is computed and returned by the service. This value represents the last time the service has seen this issue reported in an analysis instance. */
  lastSeenDate?: utcDateTime;

  /** Logical locations for the alert. This value is computed and returned by the service. It is a value based on the results from all analysis configurations. An example of a logical location is a component. */
  logicalLocations?: LogicalLocation[];

  /** This value is computed and returned by the service. It is a value based on the results from all analysis configurations. An example of a physical location is a file location. */
  physicalLocations?: PhysicalLocation[];

  /** Identifier of the project where the alert was detected. */
  @format("uuid") projectId?: string;

  /** Relations between alerts and other artifacts. */
  relations?: RelationMetadata[];

  /** Identifier of the repository where the alert was detected. */
  repositoryId?: string;

  /** Repository URL where the alert was detected. */
  repositoryUrl?: string;

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

  /** Tools that have detected this issue. */
  tools?: Tool[];

  /** A truncated/obfuscated version of the secret pertaining to the alert (if applicable). */
  truncatedSecret?: string;

  /** ValidationFingerprints for the secret liveness check. Only returned on demand in Get API with Expand parameter set to be ValidationFingerprint (not returned in List API) */
  validationFingerprints?: ValidationFingerprint[];

  validityDetails?: AlertValidityInfo;
}

/** Summary of the state of the alert for a given analysis configuration. */
model AlertAnalysisInstance {
  analysisConfiguration?: AnalysisConfiguration;
  firstSeen?: AnalysisInstance;
  fixedIn?: AnalysisInstance;
  lastSeen?: AnalysisInstance;
  recentAnalysisInstance?: AnalysisInstance;

  /** Result state for a given analysis configuration. */
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
}

/** Request model for getting alerts by IDs with optional alert type filter. */
model AlertBatchRequest {
  /** List of alert IDs to retrieve. */
  alertIds?: int64[];

  /** Alert type of the alert IDs. */
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
}

/** Alert metadata. */
model AlertMetadata {
  /** The ID of the alert. */
  alertId?: int64;

  /** A list of metadata to be associated with the alert. */
  metadata?: Metadata[];
}

/** Alert metadata. */
model AlertMetadataBatchRequest {
  /** List of alert IDs. */
  alertIds?: int64[];

  /** The flag to control error policy in a bulk get work items request. Possible options are {Fail, Omit}. */
  @extension(
    "x-ms-enum",
    #{
      name: "AlertMetadataErrorPolicy",
      values: #[
        #{
          value: "fail",
          description: "Fail error policy: if an alert id is not found, the whole request fails.",
        },
        #{
          value: "omit",
          description: "Omit error policy: if an alert id is not found, it will be omitted from the results.",
        }
      ],
    }
  )
  errorPolicy?: "fail" | "omit" | string;
}

/** Used to represent an update in a relationship between an alert and an artifact. */
model AlertMetadataChange {
  /** The ID of the alert. */
  alertId?: int64;

  metadataChange?: MetadataChange;
}

model AlertStateUpdate {
  dismissedComment?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "DismissalType",
      values: #[
        #{ value: "unknown", description: "Dismissal type unknown" },
        #{ value: "fixed", description: "Dismissal indicating alert has been fixed" },
        #{
          value: "acceptedRisk",
          description: "Dismissal indicating user is accepting a risk for the alert",
        },
        #{
          value: "falsePositive",
          description: "Dismissal indicating alert is a false positive and will likely not be fixed.",
        },
        #{
          value: "agreedToGuidance",
          description: "Dismissal indicating user is agreeing to follow license guidance.",
        },
        #{
          value: "toolUpgrade",
          description: "Dismissal indicating backend detection tool was upgraded and the alert is not detected by the new version of tool.",
        },
        #{
          value: "notDistributed",
          description: "Dismissal indicating the affected dependencency is not distributed to end users.",
        }
      ],
    }
  )
  dismissedReason?:
    | "unknown"
    | "fixed"
    | "acceptedRisk"
    | "falsePositive"
    | "agreedToGuidance"
    | "toolUpgrade"
    | "notDistributed"
    | string;
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
}

/** Represents the count of alerts for a specific alert type. */
model AlertTypeCount {
  /** The type of alert. */
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

  /** The number of alerts of this type. Null when scanning is not configured for this alert type. */
  count?: int32;
}

/** Validity data for an alert that will be part of Alerts APIs and UI. */
model AlertValidityInfo {
  validityLastCheckedDate?: utcDateTime;
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

/** AnalysisConfiguration class models a build definition. */
model AnalysisConfiguration {
  analysisConfigurationDetails?: AnalysisConfigurationDetails;

  /** Identifier for the analysis configuration. */
  analysisConfigurationId?: int32;

  /** Type of the configuration. */
  @extension(
    "x-ms-enum",
    #{
      name: "AnalysisConfigurationType",
      values: #[
        #{
          value: "default",
          description: "Default analysis configuration that is not attached to any other configuration data",
        },
        #{
          value: "adoPipeline",
          description: "Ado Pipeline, contains branch, pipeline, phase, and ADOPipelineId",
        }
      ],
    }
  )
  analysisConfigurationType?: "default" | "adoPipeline" | string;

  /** Name of the tool that ran on this configuration. */
  toolName?: string;

  /** The latest version of the tool that ran on this configuration. */
  toolVersion?: string;
}

model AnalysisConfigurationDetails {
  /** Properties of the pipeline. */
  additionalProperties?: Record<{}>;

  /** Reference to a git object, e.g. branch ref. */
  gitRef?: string;

  /** Is this the default branch? */
  isDefaultBranch?: boolean;

  /** Phase ID of the pipeline. */
  @format("uuid") phaseId?: string;

  /** Phase name. */
  phaseName?: string;

  /** AzureDevOps pipeline id. */
  pipelineId?: int32;

  /** Name of the pipeline. */
  pipelineName?: string;
}

/** AnalysisInstance class models a build. */
model AnalysisInstance {
  /** CommitId is a commit id for that instance */
  commitId?: string;

  configuration?: AnalysisConfiguration;

  /** Date when the analysis was created. */
  createdDate?: utcDateTime;

  /** InstanceIdentifier is a key that uniquely establishes this instance */
  instanceIdentifier?: string;

  /** Results that were reported by the analysis. */
  results?: AnalysisResult[];

  /** Url is the permalink to the build. */
  url?: string;
}

model AnalysisResult {
  analysisResultId?: int64;
  firstIntroducedInstanceId?: int64;
  fixedInstanceId?: int64;
  introducedInstanceId?: int64;
  lastSeenInstanceId?: int64;
  result?: Result;
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
}

/** Payload sent by the autofix pipeline to report the outcome of a run. */
model AutofixCallbackRequest {
  pullRequestId?: int32;
  requestId?: int64;

  /** Terminal status reported by the pipeline. */
  @extension(
    "x-ms-enum",
    #{
      name: "AutofixCallbackStatus",
      values: #[
        #{
          value: "done",
          description: "The pipeline completed successfully and a pull request was created.",
        },
        #{ value: "failed", description: "The pipeline or post-processing failed." }
      ],
    }
  )
  status?: "done" | "failed" | string;
}

/** Represents an autofix request resource. */
model AutofixRequest {
  createdDate?: utcDateTime;
  requestId?: int64;
  @extension(
    "x-ms-enum",
    #{
      name: "AutofixRequestStatus",
      values: #[
        #{ value: "none", description: "Default sentinel value; not a valid operational status." },
        #{
          value: "pending",
          description: "The request has been created and is waiting for a pipeline to be triggered.",
        },
        #{
          value: "pipelineRunning",
          description: "The pipeline has been triggered and is currently running.",
        },
        #{
          value: "done",
          description: "The pipeline completed successfully and a pull request was created.",
        },
        #{ value: "failed", description: "The pipeline or post-processing failed." }
      ],
    }
  )
  status?: "none" | "pending" | "pipelineRunning" | "done" | "failed" | string;
}

model Branch {
  branchId?: int32;
  deletedDate?: utcDateTime;
  name?: string;
}

/** Information about a vulnerable dependency */
model Dependency {
  /** Dependency name */
  componentName?: string;

  /** Source of the dependency */
  @extension(
    "x-ms-enum",
    #{
      name: "ComponentType",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "nuGet", description: "" },
        #{ value: "npm", description: "Indicates the component is an Npm package." },
        #{ value: "maven", description: "Indicates the component is a Maven artifact." },
        #{ value: "git", description: "Indicates the component is a Git repository." },
        #{
          value: "other",
          description: "Indicates the component is not any of the supported component types by Governance.",
        },
        #{ value: "rubyGems", description: "Indicates the component is a Ruby gem." },
        #{ value: "cargo", description: "Indicates the component is a Cargo package." },
        #{ value: "pip", description: "Indicates the component is a Pip package." },
        #{
          value: "file",
          description: "Indicates the component is a loose file. Not a package as understood by different package managers.",
        },
        #{ value: "go", description: "Indicates the component is a Go package." },
        #{ value: "dockerImage", description: "Indicates the component is a Docker Image" },
        #{ value: "pod", description: "Indicates the component is a CocoaPods pod." },
        #{
          value: "linux",
          description: "Indicates the component is found in a linux environment. A package understood by linux based package managers like apt and rpm.",
        },
        #{ value: "conda", description: "Indicates the component is a Conda package." },
        #{
          value: "dockerReference",
          description: "Indicates the component is a Docker Reference.",
        },
        #{ value: "vcpkg", description: "Indicates the component is a Vcpkg Package." }
      ],
    }
  )
  componentType?:
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
    | string;

  /** Version information */
  componentVersion?: string;

  /** Unique ID for the dependency */
  dependencyId?: int32;
}

/** An instance of a vulnerable dependency that was detected */
model DependencyResult {
  dependency?: Dependency;

  /** Unique ID for this dependency */
  dependencyResultId?: int32;

  /** ID for the Result that this instance belongs to */
  resultId?: int32;

  /** Heirarchal information when multiple instances are found */
  rootDependencyId?: int32;

  versionControlFilePath?: VersionControlFilePath;
}

/** Information about an alert dismissal */
model Dismissal {
  /** Unique ID for this dismissal */
  dismissalId?: int64;

  /** Reason for the dismissal */
  @extension(
    "x-ms-enum",
    #{
      name: "DismissalType",
      values: #[
        #{ value: "unknown", description: "Dismissal type unknown" },
        #{ value: "fixed", description: "Dismissal indicating alert has been fixed" },
        #{
          value: "acceptedRisk",
          description: "Dismissal indicating user is accepting a risk for the alert",
        },
        #{
          value: "falsePositive",
          description: "Dismissal indicating alert is a false positive and will likely not be fixed.",
        },
        #{
          value: "agreedToGuidance",
          description: "Dismissal indicating user is agreeing to follow license guidance.",
        },
        #{
          value: "toolUpgrade",
          description: "Dismissal indicating backend detection tool was upgraded and the alert is not detected by the new version of tool.",
        },
        #{
          value: "notDistributed",
          description: "Dismissal indicating the affected dependencency is not distributed to end users.",
        }
      ],
    }
  )
  dismissalType?:
    | "unknown"
    | "fixed"
    | "acceptedRisk"
    | "falsePositive"
    | "agreedToGuidance"
    | "toolUpgrade"
    | "notDistributed"
    | string;

  /** Informational message attached to the dismissal */
  message?: string;

  /** Identity that dismissed the alert */
  @format("uuid") stateChangedBy?: string;

  stateChangedByIdentity?: IdentityRef;
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

/** Details for a legal review for a given component */
model LegalReview {
  /** The review id. This indicates the associated work item id for dev it's witness-dev and for prod it's ossmsft. */
  id?: int32;

  /** The review state. */
  state?: string;

  /** The review web url. */
  webUrl?: string;
}

/** License information for dependencies */
model License {
  /** License name */
  name?: string;

  /** License state */
  @extension(
    "x-ms-enum",
    #{
      name: "LicenseState",
      values: #[
        #{
          value: "unknown",
          description: "Information of the license has not been harvested by ClearlyDefined",
        },
        #{
          value: "notHarvested",
          description: "Information of the license has not been harvested by ClearlyDefined",
        },
        #{
          value: "harvested",
          description: "Information of the license has been harvested by ClearlyDefined",
        }
      ],
    }
  )
  state?: "unknown" | "notHarvested" | "harvested" | string;

  /** License type */
  @extension(
    "x-ms-enum",
    #{
      name: "LicenseType",
      values: #[
        #{ value: "unknown", description: "The license type is unknown or not specified." },
        #{
          value: "permissive",
          description: "A permissive license allows software to be freely used, modified, and distributed with minimal restrictions. Examples: MIT, Apache 2.0.",
        },
        #{
          value: "weakCopyleft",
          description: "A weak copyleft license requires modifications to the software to be shared under the same license, but does not impose restrictions on larger works that include the software. Examples: LGPL.",
        },
        #{
          value: "strongCopyleft",
          description: "A strong copyleft license requires that any derivative works or larger works that include the software must also be distributed under the same license. Examples: GPL.",
        },
        #{
          value: "networkCopyleft",
          description: "A network copyleft license extends the copyleft requirement to software that is accessed over a network, requiring the source code to be made available. Examples: AGPL.",
        },
        #{
          value: "other",
          description: "A license that does not fit into the standard categories or is custom-defined. In CG, it indicates a commercial license.",
        },
        #{
          value: "noAssertion",
          description: "No assertion is made about the license type, leaving it unspecified.",
        }
      ],
    }
  )
  type?:
    | "unknown"
    | "permissive"
    | "weakCopyleft"
    | "strongCopyleft"
    | "networkCopyleft"
    | "other"
    | "noAssertion"
    | string;

  /** Url for license information */
  url?: string;
}

model LogicalLocation {
  fullyQualifiedName?: string;

  /** Dependency kind of this logical location. */
  @extension(
    "x-ms-enum",
    #{
      name: "DependencyKind",
      values: #[
        #{ value: "unknown", description: "" },
        #{
          value: "rootDependency",
          description: "The root dependency introduced the component being alerted.",
        },
        #{ value: "component", description: "The component being alerted." },
        #{
          value: "vulnerableDependency",
          description: "Vulnerable Dependency. Deprecating this value. Use Component instead.",
        }
      ],
    }
  )
  kind?: "unknown" | "rootDependency" | "component" | "vulnerableDependency" | string;

  license?: License;
}

/** The metadata operation to be performed on the alert. */
model Metadata {
  /** The type of operation to be performed. */
  @extension(
    "x-ms-enum",
    #{
      name: "MetadataOperation",
      values: #[
        #{
          value: "none",
          description: "Represents the defualt value if the operation is not specified or not supported.",
        },
        #{ value: "add", description: "Represents the addition of the metadata." },
        #{ value: "remove", description: "Represents the removal of the metadata." }
      ],
    }
  )
  `op`?: "none" | "add" | "remove" | string;

  value?: RelationMetadata;
}

/** The change that has been made to the metadata. */
model MetadataChange {
  /** The type of change on the metadata. */
  @extension(
    "x-ms-enum",
    #{
      name: "MetadataChangeType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "created", description: "" },
        #{ value: "updated", description: "" },
        #{ value: "deleted", description: "" }
      ],
    }
  )
  changeType?: "none" | "created" | "updated" | "deleted" | string;

  value?: RelationMetadata;
}

/** Location in the source control system where the issue was found */
model PhysicalLocation {
  /** Additional properties for where the issue was found */
  additionalProperties?: Record<{}>;

  /** Path of the file where the issue was found */
  filePath?: string;

  /** Indicates whether the path is a valid Git path that exists in the git repository associated with the alert. */
  isValidGitPath?: boolean;

  region?: Region;
  versionControl?: VersionControlDetails;
}

model Pipeline {
  adoPipelineId?: int32;
  name?: string;
  phase?: string;
  @format("uuid") phaseId?: string;
  properties?: Record<{}>;
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

/** The metadata to be associated with the alert. */
model RelationMetadata {
  /** Any additional attributes of the metadata. */
  attributes?: Record<{}>;

  /** The properties of the metadata. */
  properties?: Record<{}>;

  /** The type of the metadata. */
  rel?: string;

  /** The URL of the metadata. */
  url?: string;
}

model Result {
  dependencyResult?: DependencyResult;

  /** Full fingerprint of the Result. This is used to detect duplicate instances of the same alert */
  fingerprint?: string;

  /** Unique ID of the fingerprint of the Result */
  fingerprintId?: int64;

  /** Unique ID of the Result */
  resultId?: int32;

  /** Detailed description of the rule that triggered the alert */
  resultMessage?: string;

  /** The type of rule that triggered the alert */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultType",
      values: #[
        #{
          value: "unknown",
          description: "The result was found from an unspecified analysis type",
        },
        #{ value: "dependency", description: "The result was found from dependency analysis" },
        #{ value: "versionControl", description: "The result was found from static code analysis" }
      ],
    }
  )
  resultType?: "unknown" | "dependency" | "versionControl" | string;

  /** ID of the rule that the triggered the alert */
  ruleId?: int32;

  /** Short description of the rule that triggered the alert */
  ruleShortDescription?: string;

  /** The severity of the alert */
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

  versionControlResult?: VersionControlResult;
}

/** The analysis rule that caused the alert. */
model Rule {
  /** Additional properties of this rule dependent on the rule type. For example, dependency rules may include the CVE ID if it is available. */
  additionalProperties?: Record<{}>;

  /** Description of what this rule detects */
  description?: string;

  /** Plain-text rule identifier */
  friendlyName?: string;

  /** Additional information about this rule */
  helpMessage?: string;

  /** Tool-specific rule identifier */
  opaqueId?: string;

  /** Markdown-formatted list of resources to learn more about the Rule. In some cases, RuleInfo.AdditionalProperties.advisoryUrls is used instead. */
  resources?: string;

  /** Classification tags for this rule */
  tags?: string[];
}

model SarifUploadStatus {
  errors?: SarifValidationError[];
  @extension(
    "x-ms-enum",
    #{
      name: "SarifJobStatus",
      values: #[
        #{ value: "new", description: "The job type when it is new" },
        #{ value: "queued", description: "The job type when it is queued" },
        #{ value: "completed", description: "The job type when it is completed" },
        #{ value: "failed", description: "The job type when it fails" },
        #{ value: "requeued", description: "The job type when it is queued on exception" },
        #{
          value: "concurrentProcessing",
          description: "The job is currently being processed in the concurrent processing workflow exclusive for no autofix flows",
        }
      ],
    }
  )
  processingStatus?:
    | "new"
    | "queued"
    | "completed"
    | "failed"
    | "requeued"
    | "concurrentProcessing"
    | string;
}

model SarifValidationError {
  nodePointer?: string;
  ruleId?: string;
  validationError?: string;
}

model SearchCriteria {
  /** If provided, only return alerts with the ids specified. <br />Otherwise, return any alert. */
  alertIds?: int64[];

  /** If provided, only return alerts of this type. Otherwise, return alerts of all types. */
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

  /** If provided, only return alerts at these confidence levels. <br />Both High and Other need to be specified to fetch alerts of all confidence levels. <br />Otherwise, return alerts with high confidence level. <br />Only applicable for secret alerts. */
  confidenceLevels?: ("high" | "other" | string)[];

  /** If provided, only alerts for this dependency are returned. <br />Otherwise, return alerts for all dependencies. <br />In a sarif submission, a dependency (or a component) is specified in result.RelatedLocations[].logicalLocation. <br />Not applicable for secret alerts. */
  dependencyName?: string;

  /** If provided, only return alerts last seen after this date. <br />Otherwise return all alerts. */
  fromDate?: utcDateTime;

  /** If provided, filters alerts based on whether they have linked work items. <br />Set to 'true' to return only alerts with linked work items. <br />Set to 'false' to return only alerts without linked work items. <br />If not provided, returns all alerts regardless of linked work items. <br />Not applicable for secret and dependency scanning alerts. */
  hasLinkedWorkItems?: boolean;

  /** If provided with isTriaged, only return alerts that have been triaged. <br />Otherwise, return alerts regardless of triage status. */
  isTriaged?: boolean;

  /** If provided, only return alerts whose titles match this pattern. */
  keywords?: string;

  /** If provided, only return alerts that were modified since this date. <br />Otherwise return all alerts. */
  modifiedSince?: utcDateTime;

  /** If true or not set, only return alerts found on the default branch of the repository. <br />If there have been no runs completed on the default branch, the last run is used instead regardless of the branch used for that run. If false, return alerts from all branches. <br />This option is ignored if ref is provided. <br />Not applicable for secret alerts. */
  onlyDefaultBranch?: boolean;

  /** If provided with pipelineName, only return alerts detected in this pipeline phase <br />Otherwise, return alerts detected in all phases. <br />Not applicable for secret alerts. */
  @format("uuid") phaseId?: string;

  /** If provided with pipelineName, only return alerts detected in this pipeline phase <br />Otherwise, return alerts detected in all phases. <br />Not applicable for secret alerts. */
  phaseName?: string;

  /** If provided with pipelineId, only return alerts detected in this pipeline <br />Otherwise, return alerts detected in all pipelines. */
  pipelineId?: int32;

  /** If provided, only return alerts detected in this pipeline. <br />Otherwise, return alerts detected in all pipelines. <br />Not applicable for secret alerts. */
  pipelineName?: string;

  /** If provided, only include alerts for this ref. <br />If not provided and OnlyDefaultBranch is true, only include alerts found on the default branch or last run branch if there is no analysis configuration for the default branch. <br />Otherwise, include alerts from all branches. <br />Not applicable for secret alerts. */
  ref?: string;

  /** If provided, only return alerts for this rule. <br />Otherwise, return alerts of all rules. */
  ruleId?: string;

  /** If provided, only return alerts for this rule. <br />Otherwise, return alerts for all rules. */
  ruleName?: string;

  /** If provided, only return alerts at these severities. <br />Otherwise, return alerts at any severity. */
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

  /** If provided, only return alerts in these states. <br />Otherwise, return alerts in any state. */
  states?: ("unknown" | "active" | "dismissed" | "fixed" | "autoDismissed" | string)[];

  /** If provided, only return alerts last seen before this date. <br />Otherwise return all alerts. */
  toDate?: utcDateTime;

  /** If provided with toolName, only return alerts detected by this tool. <br />Otherwise, return alerts detected by all tools. */
  toolName?: string;

  /** If provided, only return alerts with the validity specified here. If the validity status is Unknown, fetch alerts of all validity results. <br />Only applicable for secret alerts. <br />Filtering by validity status may cause less alerts to be returned than requested with TOP parameter. <br />Due to this behavior, the ContinuationToken(<![CDATA[<header name>]]>) in the response header should be relied on to decide if another batch needs to be fetched. */
  validity?: ("none" | "unknown" | "active" | "inactive" | string)[];
}

/** An Analysis tool that can generate security alerts */
model Tool {
  /** Name of the tool */
  name?: string;

  /** The rules that the tool defines */
  rules?: Rule[];

  /** String representation of the tool version */
  toolVersion?: string;
}

model UxFilters {
  /** Display alerts for specified branches. Show alerts for all branches if none are specified. */
  branches?: Branch[];

  /** Display alerts for specified confidence levels. Show alerts for all confidence levels. if none are specified. */
  confidenceLevels?: ("high" | "other" | string)[];

  /** Display alerts for specified licenses. Show alerts for all licenses if none are specified. */
  licenses?: License[];

  /** Display alerts for specified packages. Show alerts for all packages if none are specified. */
  packages?: Dependency[];

  /** Display alerts for specified pipelines. Show alerts for all pipelines if none are specified. */
  pipelines?: Pipeline[];

  progressPercentage?: int32;

  /** Display alerts for specified rules. Show alerts for all rules if none are specified. */
  rules?: Rule[];

  /** Display alerts for specified secret types. Show alerts for all secret types if none are specified. */
  secretTypes?: string[];

  /** Display alerts for specified severities. Show alerts for all severities if none are specified. */
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

  /** Display alerts for specified states. Show alerts for all states if none are specified. */
  states?: ("unknown" | "active" | "dismissed" | "fixed" | "autoDismissed" | string)[];

  /** Display alerts for specified tools. Show alerts for all tools if none are specified. */
  tools?: Tool[];

  /** Display alerts for specified validity. Show alerts for all validities if none are specified. */
  validity?: ("none" | "unknown" | "active" | "inactive" | string)[];
}

model ValidationFingerprint {
  /** The key value representation of the asset fingerprint. */
  assetFingerprint?: Record<string>;

  /** Represents the CrossCompanyCorrelatingId for the secret in the ValidationFingerprintJson. */
  c3Id?: string;

  /** A normalized string representation of the validation tool version. */
  normalizedValidationToolVersion?: int32;

  /** The hash associated to the secret. */
  validationFingerprintHash?: string;

  /** The JSON representation of the secret. Be aware that this field may contain the secret in its unencrypted form. Please exercise caution when using this field. */
  validationFingerprintJson?: string;

  /** The date when the validity was last updated. */
  validityLastUpdatedDate?: utcDateTime;

  /** The result of the validation. */
  @extension(
    "x-ms-enum",
    #{
      name: "ValidationResult",
      values: #[
        #{
          value: "none",
          description: "Default value, no information about the secret can be inferred from this.",
        },
        #{
          value: "exploitable",
          description: "Represents a secret that can be used to connect to a resource.",
        },
        #{
          value: "notExploitable",
          description: "Represents a secret that can't be used to connect to a resource.",
        },
        #{
          value: "inconclusive",
          description: "Represents a secret where no determination can be made about its exploitability.",
        },
        #{
          value: "validationNotSupported",
          description: "Represents a secret where we are unable to validate, e.g. dynamic validator missing.",
        },
        #{
          value: "transientError",
          description: "Represents a secret where the validation process failed due to a transient error, e.g. network issue. This result indicates that the validation process should be retried.",
        }
      ],
    }
  )
  validityResult?:
    | "none"
    | "exploitable"
    | "notExploitable"
    | "inconclusive"
    | "validationNotSupported"
    | "transientError"
    | string;
}

/** Data associated to a validation request for an alert. Along with the request status, this includes the validity data that is part of Get Alert(s) response. */
model ValidationRequestInfo {
  ...AlertValidityInfo;
  @extension(
    "x-ms-enum",
    #{
      name: "AlertValidationRequestStatus",
      values: #[
        #{ value: "none", description: "Default, when the request status is not set/applicable." },
        #{
          value: "created",
          description: "First validation request for the alert's validation fingerprints, created when the sarif is submitted for processing.",
        },
        #{
          value: "inProgress",
          description: "The secret validation jobs for the alert's validation fingerprints have been manually queued and at least one is still in progress.",
        },
        #{
          value: "completed",
          description: "All the secret validation jobs for the alert's validation fingerprints have returned Completed or Failed.",
        },
        #{
          value: "failed",
          description: "This status is set only when there is an exception in the ValidationService.",
        }
      ],
    }
  )
  alertValidationRequestStatus?:
    | "none"
    | "created"
    | "inProgress"
    | "completed"
    | "failed"
    | string;
}

/** Information for locating files in a source control system */
model VersionControlDetails {
  commitHash?: string;
  itemUrl?: string;
}

model VersionControlFilePath {
  /** Path of the file in the version control system */
  filePath?: string;

  /** Hash of the file in the version control system */
  filePathHash?: bytes[];

  /** Unique ID for the file in the version control system */
  versionControlFilePathId?: int64;
}

model VersionControlResult {
  /** The ID to associate this structure with the cooresponding Result */
  resultId?: int32;

  versionControlSnippet?: VersionControlSnippet;
}

model VersionControlSnippet {
  /** column in the code file where the snippet ends */
  endColumn?: int32;

  /** line in the code file where the snippet ends */
  endLine?: int32;

  /** column in the code file where the snippet starts */
  startColumn?: int32;

  /** line in the code file where the snippet starts */
  startLine?: int32;

  versionControlFilePath?: VersionControlFilePath;

  /** Unique Id number for the file path */
  versionControlFilePathId?: int64;

  /** Unique Id number for this snippet */
  versionControlSnippetId?: int64;
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

/** A collection of `Alert` as returned by Azure DevOps. */
model AlertList {
  count?: int32;
  value?: Alert[];
}

/** A collection of `AlertAnalysisInstance` as returned by Azure DevOps. */
model AlertAnalysisInstanceList {
  count?: int32;
  value?: AlertAnalysisInstance[];
}

/** A collection of `AlertMetadata` as returned by Azure DevOps. */
model AlertMetadataList {
  count?: int32;
  value?: AlertMetadata[];
}

/** A collection of `Branch` as returned by Azure DevOps. */
model BranchList {
  count?: int32;
  value?: Branch[];
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

interface Alerts {
  /** Get alerts for a repository */
  @tag("Alerts")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "alerts")
  @extension("x-ms-vss-method", "GetAlertsAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/alerts")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository */
    @path repository: string,

    /** The maximum number of alerts to return */
    @query(#{ explode: true }) top?: int32,

    /** Must be 'id' 'firstSeen' 'lastSeen' 'fixedOn' or 'severity' Defaults to 'id' */
    @query(#{ explode: true }) orderBy?: string,

    /** If provided, only return alerts with the ids specified. <br />Otherwise, return any alert. */
    @query(#{ name: "criteria.alertIds" }) criteriaAlertIds?: int64[],

    /** If provided, only return alerts of this type. Otherwise, return alerts of all types. */
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

    /** If provided, only return alerts at these confidence levels. <br />Both High and Other need to be specified to fetch alerts of all confidence levels. <br />Otherwise, return alerts with high confidence level. <br />Only applicable for secret alerts. */
    @query(#{ name: "criteria.confidenceLevels" }) criteriaConfidenceLevels?: string[],

    /** If provided, only alerts for this dependency are returned. <br />Otherwise, return alerts for all dependencies. <br />In a sarif submission, a dependency (or a component) is specified in result.RelatedLocations[].logicalLocation. <br />Not applicable for secret alerts. */
    @query(#{ name: "criteria.dependencyName", explode: true }) criteriaDependencyName?: string,

    /** If provided, only return alerts last seen after this date. <br />Otherwise return all alerts. */
    @query(#{ name: "criteria.fromDate", explode: true }) criteriaFromDate?: utcDateTime,

    /** If provided, filters alerts based on whether they have linked work items. <br />Set to 'true' to return only alerts with linked work items. <br />Set to 'false' to return only alerts without linked work items. <br />If not provided, returns all alerts regardless of linked work items. <br />Not applicable for secret and dependency scanning alerts. */
    @query(#{ name: "criteria.hasLinkedWorkItems", explode: true }) criteriaHasLinkedWorkItems?: boolean,

    /** If provided with isTriaged, only return alerts that have been triaged. <br />Otherwise, return alerts regardless of triage status. */
    @query(#{ name: "criteria.isTriaged", explode: true }) criteriaIsTriaged?: boolean,

    /** If provided, only return alerts whose titles match this pattern. */
    @query(#{ name: "criteria.keywords", explode: true }) criteriaKeywords?: string,

    /** If provided, only alerts created for dependency with this license are returned. <br />Otherwise, return alerts for all licenses. <br />In a sarif submission, license for a dependency (or a component) is specified in result.RelatedLocations[].logicalLocation.properties.license. <br />Not applicable for secret alerts. */
    @query(#{ name: "criteria.licenseName", explode: true }) criteriaLicenseName?: string,

    /** If provided, only return alerts that were modified since this date. <br />Otherwise return all alerts. */
    @query(#{ name: "criteria.modifiedSince", explode: true }) criteriaModifiedSince?: utcDateTime,

    /** If true or not set, only return alerts found on the default branch of the repository. <br />If there have been no runs completed on the default branch, the last run is used instead regardless of the branch used for that run. If false, return alerts from all branches. <br />This option is ignored if ref is provided. <br />Not applicable for secret alerts. */
    @query(#{ name: "criteria.onlyDefaultBranch", explode: true }) criteriaOnlyDefaultBranch?: boolean,

    /** If provided with pipelineName, only return alerts detected in this pipeline phase <br />Otherwise, return alerts detected in all phases. <br />Not applicable for secret alerts. */
    @format("uuid") @query(#{ name: "criteria.phaseId", explode: true }) criteriaPhaseId?: string,

    /** If provided with pipelineName, only return alerts detected in this pipeline phase <br />Otherwise, return alerts detected in all phases. <br />Not applicable for secret alerts. */
    @query(#{ name: "criteria.phaseName", explode: true }) criteriaPhaseName?: string,

    /** If provided with pipelineId, only return alerts detected in this pipeline <br />Otherwise, return alerts detected in all pipelines. */
    @query(#{ name: "criteria.pipelineId", explode: true }) criteriaPipelineId?: int32,

    /** If provided, only return alerts detected in this pipeline. <br />Otherwise, return alerts detected in all pipelines. <br />Not applicable for secret alerts. */
    @query(#{ name: "criteria.pipelineName", explode: true }) criteriaPipelineName?: string,

    /** If provided, only include alerts for this ref. <br />If not provided and OnlyDefaultBranch is true, only include alerts found on the default branch or last run branch if there is no analysis configuration for the default branch. <br />Otherwise, include alerts from all branches. <br />Not applicable for secret alerts. */
    @query(#{ name: "criteria.ref", explode: true }) criteriaRef?: string,

    /** If provided, only return alerts for this rule. <br />Otherwise, return alerts of all rules. */
    @query(#{ name: "criteria.ruleId", explode: true }) criteriaRuleId?: string,

    /** If provided, only return alerts for this rule. <br />Otherwise, return alerts for all rules. */
    @query(#{ name: "criteria.ruleName", explode: true }) criteriaRuleName?: string,

    /** If provided, only return alerts at these severities. <br />Otherwise, return alerts at any severity. */
    @query(#{ name: "criteria.severities" }) criteriaSeverities?: string[],

    /** If provided, only return alerts in these states. <br />Otherwise, return alerts in any state. */
    @query(#{ name: "criteria.states" }) criteriaStates?: string[],

    /** If provided, only return alerts last seen before this date. <br />Otherwise return all alerts. */
    @query(#{ name: "criteria.toDate", explode: true }) criteriaToDate?: utcDateTime,

    /** If provided with toolName, only return alerts detected by this tool. <br />Otherwise, return alerts detected by all tools. */
    @query(#{ name: "criteria.toolName", explode: true }) criteriaToolName?: string,

    /** If provided, only return alerts with the validity specified here. If the validity status is Unknown, fetch alerts of all validity results. <br />Only applicable for secret alerts. <br />Filtering by validity status may cause less alerts to be returned than requested with TOP parameter. <br />Due to this behavior, the ContinuationToken(<![CDATA[<header name>]]>) in the response header should be relied on to decide if another batch needs to be fetched. */
    @query(#{ name: "criteria.validity" }) criteriaValidity?: string[],

    @extension(
      "x-ms-enum",
      #{
        name: "AlertListExpandOption",
        values: #[
          #{ value: "none", description: "No Expands." },
          #{ value: "minimal", description: "Return a minimal representation of an alert." },
          #{
            value: "count",
            description: "Return only the count of active alerts grouped by alert type.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    expand?: "none" | "minimal" | "count",

    /** If there are more alerts than can be returned, a continuation token is placed in the 'x-ms-continuationtoken' header. Use that token here to get the next page of alerts */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: AlertList;
  };

  /** Get an alert. */
  @tag("Alerts")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "alerts")
  @extension("x-ms-vss-method", "GetAlertAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/alerts/{alertId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of alert to retrieve */
    @path alertId: int64,

    /** Name or id of a repository that alert is part of */
    @path repository: string,

    @query(#{ explode: true }) ref?: string,

    /** Expand attributes of a secret alert. Possible values are `None` and `ValidationFingerprint`. Defaults to `None`. Be aware that if `expand` is set to `ValidationFingerprint`, the response may contain the secret in its unencrypted form. Please exercise caution when using this data. */
    @extension(
      "x-ms-enum",
      #{
        name: "ExpandOption",
        values: #[
          #{ value: "none", description: "No Expands." },
          #{ value: "validationFingerprint", description: "Return validationFingerprints in Alert." }
        ],
      }
    )
    @query(#{ explode: true })
    expand?: "none" | "validationFingerprint",

    ...Parameters.`api-Version-preview`.`1`,
  ): Alert;

  /** Update the status of an alert */
  @tag("Alerts")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "alerts")
  @extension("x-ms-vss-method", "UpdateAlertAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/alerts/{alertId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID of the alert */
    @path alertId: int64,

    /** The name or ID of the repository */
    @path repository: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The new status of the alert */
    @body body: AlertStateUpdate,
  ): Alert;
}

interface Instances {
  /** Get instances of an alert on a branch specified with \@ref. If \@ref is not provided, return instances of an alert on default branch(if the alert exist in default branch) or latest affected branch. */
  @tag("Instances")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "instances")
  @extension("x-ms-vss-method", "GetAlertInstancesAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/alerts/{alertId}/instances")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of alert to retrieve */
    @path alertId: int64,

    /** Name or id of a repository that alert is part of */
    @path repository: string,

    @query(#{ explode: true }) ref?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): AlertAnalysisInstanceList;
}

interface Metadata2 {
  /** Get an alert metadata. */
  @tag("Metadata2")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "metadata2")
  @extension("x-ms-vss-method", "GetAlertMetadataAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/alerts/{alertId}/metadata")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of alert to retrieve */
    @path alertId: int64,

    /** Name or id of a repository that alert is part of */
    @path repository: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AlertMetadata;
}

interface MetadataBatch {
  /** Get alerts metadata. */
  @tag("Metadata Batch")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "metadataBatch")
  @extension("x-ms-vss-method", "GetAlertMetadataBatchAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/alerts/metadatabatch")
  @post
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Name or id of a repository that alert is part of */
    @path repository: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: AlertMetadataBatchRequest,
  ): AlertMetadataList;
}

interface AlertsBatch {
  /** Get alerts by alert IDs Currently supports fetching secret alerts only. */
  @tag("Alerts Batch")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "alertsBatch")
  @extension("x-ms-vss-method", "GetAlertsByIdsAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/AlertsBatch")
  @post
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository */
    @path repository: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Request containing alert IDs and optional alert type filter */
    @body body: AlertBatchRequest,
  ): AlertList;
}

interface Analysis {
  /** Returns the branches for which analysis results were submitted. */
  @tag("Analysis")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "analysis")
  @extension("x-ms-vss-method", "GetBranchesAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/filters/branches")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path repository: string,

    /** The type of alert: Dependency Scanning (1), Secret (2), Code QL (3), etc. */
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
    alertType: "unknown" | "dependency" | "secret" | "code",

    /** A string variable that represents the branch name and is used to fetch branches that follow it in alphabetical order. */
    @query(#{ explode: true }) continuationToken?: string,

    /** A string variable used to fetch branches that contain this string anywhere in the branch name, case insensitive. */
    @query(#{ explode: true }) branchNameContains?: string,

    /** An int variable used to return the top k branches that satisfy the search criteria. */
    @query(#{ explode: true }) top?: int32,

    /** A bool variable indicating whether or not to include pull request branches. */
    @query(#{ explode: true }) includePullRequestBranches?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: BranchList;
  };
}

interface PipelineAnalyses {
  /** Soft-deletes analysis data for all pipelines in a repository, cleaning up the associated Advanced Security alerts. */
  @tag("Pipeline Analyses")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pipelineAnalyses")
  @extension("x-ms-vss-method", "DeleteAllPipelineAnalysesAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/pipelineAnalyses")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repository: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface PipelineAnalysis {
  /** Soft-deletes analysis data for a specific pipeline, cleaning up the associated Advanced Security alerts. */
  @tag("Pipeline Analysis")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pipelineAnalysis")
  @extension("x-ms-vss-method", "DeletePipelineAnalysisAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/alert/repositories/{repository}/pipelineAnalysis/{adoPipelineId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The name or ID of the repository. */
    @path repository: string,

    /** The ID of the ADO pipeline whose analysis data should be cleaned up. */
    @path adoPipelineId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}
