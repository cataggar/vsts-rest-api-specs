import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "SBOM" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://pkgs.dev.azure.com")
namespace SBOM;

/** This holds the configuration for the ManifestTool. The values in this file are populated from the command line, config file and default. */
model Configuration {
  additionalComponentDetectorArgs?: ConfigurationSetting;
  buildComponentPath?: ConfigurationSetting;
  buildDropPath?: ConfigurationSetting;
  buildListFile?: ConfigurationSetting;
  catalogFilePath?: ConfigurationSetting;
  configFilePath?: ConfigurationSetting;
  dockerImagesToScan?: ConfigurationSetting;
  externalDocumentReferenceListFile?: ConfigurationSetting;
  hashAlgorithm?: ConfigurationSetting;
  ignoreMissing?: ConfigurationSetting;
  manifestDirPath?: ConfigurationSetting;
  manifestInfo?: ConfigurationSetting;

  /** The action currently being performed by the manifest tool. */
  @extension(
    "x-ms-enum",
    #{
      name: "ManifestToolActions",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "validate", description: "" },
        #{ value: "generate", description: "" },
        #{ value: "all", description: "" }
      ],
    }
  )
  manifestToolAction?: "none" | "validate" | "generate" | "all";

  packageName?: ConfigurationSetting;
  packageVersion?: ConfigurationSetting;
  parallelism?: ConfigurationSetting;
  rootPathFilter?: ConfigurationSetting;
  telemetryFilePath?: ConfigurationSetting;
  validateSignature?: ConfigurationSetting;
}

/** Encapsulates a configuration setting to provide metadata about the setting source and type. */
model ConfigurationSetting {
  /** The source where this setting came from. */
  source?: string;

  /** The actual value of the setting. */
  @format("T") value?: string;
}

/** Used to provide the filename and hash of the SBOM file to be added to the catalog file. */
model FileHash {
  /** The filename of the SBOM. */
  fileName?: string;

  /** The string hash of the SBOM file. */
  hash?: string;

  /** The HashAlgorithmName used to generate the hash of the file. */
  @format("HashAlgorithmName") hashAlgorithmName?: string;
}

/** Defines a manifest name and version. */
model ManifestInfo {
  /** The name of the manifest. */
  name?: string;

  /** The version of the manifest. */
  version?: string;
}

/** Represents a SBOM file object and contains additional properties related to the file. */
model SBOMFile {
  /** The size of the SBOM file in bytes. */
  fileSizeInBytes?: int64;

  /** The path where the final generated SBOM is placed. */
  sbomFilePath?: string;

  sbomFormatName?: ManifestInfo;
}

model SbomFileValidationResult {
  errorType?: string;
  path?: string;
}

model SbomStorageResult {
  failureReason?: string;
  result?: string;
  sbomStorageApiUrl?: string;
  sbomZipFileSizeInBytes?: string;
}

model SbomTaskErrors {
  count?: int32;
  errors?: SbomFileValidationResult[];
}

model SbomTaskTiming {
  eventName?: string;
  timeSpan?: string;
}

/** The telemetry that is logged to a file/console for the given SBOM execution. */
model SBOMTelemetry {
  /** Additional SBOM task properties */
  additionalProperties?: Record<string>;

  /** Timing data for additional operations performed in task */
  additionalTimings?: SbomTaskTiming[];

  /** All available bsi data from the task build execution which includes build and system environment variables like repository and build information. */
  bsiData?: Record<string>;

  /** The source of the bsi data. */
  bsiSource?: string;

  /** The end to end results of the extension task. */
  e2ETaskResult?: string;

  errors?: SbomTaskErrors;

  /** Operation IDs for ESRP signing operations */
  esrpOperationIds?: string[];

  /** Exceptions thrown during task run */
  exceptions?: Record<string>;

  parameters?: Configuration;

  /** Pipeline release variables set during task run */
  pipelineReleaseVariables?: Record<string>;

  /** Pipeline variables set during task run */
  pipelineVariables?: Record<string>;

  /** The result of the execution */
  result?: string;

  /** A list of the SBOM formats and related file properties that was used in the generation/validation of the SBOM. */
  sbomFormatsUsed?: SBOMFile[];

  /** Results from SBOM storage service calls during task run */
  sbomStorageResults?: SbomStorageResult[];

  /** Any internal switches and their value that were used during the execution. A switch can be something that was provided through a configuraiton or an environment variable. */
  switches?: Record<{}>;

  /** Error messages that came from the extension task. */
  taskErrorMessage?: string;

  /** The name of the task that logged SBOM telemetry */
  taskName?: string;

  /** The unique id for this telemetry */
  telemetryId?: string;

  /** Task timeout value */
  timeoutValueInMins?: int32;

  /** Timing data for SBOM generation operations */
  timings?: SbomTaskTiming[];

  /** The result of the tool as a numeric value. */
  toolExecutionResult?: int32;
}

/** Used to provide the FileHash of the SBOM file and EBOM ID to be added to the catalog file. */
model SignRequest {
  /** The EBOM ID for the associated image. */
  ebomId?: string;

  fileHash?: FileHash;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
