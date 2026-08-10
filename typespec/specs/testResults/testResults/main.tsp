import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "TestResults" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://vstmr.dev.azure.com")
namespace TestResults;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AdvancedFlakyDetectionParameter {
  /** Lookback period for the parameter in multiple of 24 hours */
  lookbackPeriod?: int32;

  /** Type of the parameter. */
  @extension(
    "x-ms-enum",
    #{
      name: "AdvancedFlakyDetectionParameterType",
      values: #[
        #{ value: "failureRate", description: "Failure rate parameter for flaky detection" },
        #{ value: "passRate", description: "Pass rate parameter for flaky detection" },
        #{
          value: "timingVariability",
          description: "Timing variability parameter for flaky detection",
        },
        #{ value: "rerunCount", description: "Rerun count parameter for flaky detection" }
      ],
    }
  )
  parameterType?: "failureRate" | "passRate" | "timingVariability" | "rerunCount";

  /** Weight for the parameter. Values between 0-100 */
  weight?: int32;
}

model AdvancedFlakyDetectionSettings {
  /** Threshold for filing a bug for a flaky test. */
  filingBugThreshold?: int32;

  flakyTestBugConfig?: FlakyTestBugConfig;

  /** Threshold for marking a test as flaky. */
  markingFlakyThreshold?: int32;

  /** List of parameters with their weights for advanced flaky detection. */
  weightedScores?: AdvancedFlakyDetectionParameter[];
}

model AggregatedDataForResultTrend {
  /** This is tests execution duration. */
  @format("TimeSpan") duration?: string;

  resultsByOutcome?: Record<AggregatedResultsByOutcome>;
  runSummaryByState?: Record<AggregatedRunsByState>;
  testResultsContext?: TestResultsContext;
  totalTests?: int32;
}

/** Result deatils for a particular test result outcome. */
model AggregatedResultDetailsByOutcome {
  /** Number of results for current outcome. */
  count?: int32;

  /** Time taken by results. */
  @format("TimeSpan") duration?: string;

  /** Test result outcome */
  @extension(
    "x-ms-enum",
    #{
      name: "TestOutcome",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{
          value: "none",
          description: "Test has not been completed, or the test type does not report pass/failure.",
        },
        #{ value: "passed", description: "Test was executed w/o any issues." },
        #{
          value: "failed",
          description: "Test was executed, but there were issues. Issues may involve exceptions or failed assertions.",
        },
        #{
          value: "inconclusive",
          description: "Test has completed, but we can't say if it passed or failed. May be used for aborted tests...",
        },
        #{ value: "timeout", description: "The test timed out" },
        #{
          value: "aborted",
          description: "Test was aborted. This was not caused by a user gesture, but rather by a framework decision.",
        },
        #{
          value: "blocked",
          description: "Test had it chance for been executed but was not, as ITestElement.IsRunnable == false.",
        },
        #{
          value: "notExecuted",
          description: "Test was not executed. This was caused by a user gesture - e.g. user hit stop button.",
        },
        #{
          value: "warning",
          description: "To be used by Run level results. This is not a failure.",
        },
        #{
          value: "error",
          description: "There was a system error while we were trying to execute a test.",
        },
        #{ value: "notApplicable", description: "Test is Not Applicable for execution." },
        #{ value: "paused", description: "Test is paused." },
        #{
          value: "inProgress",
          description: "Test is currently executing. Added this for TCM charts",
        },
        #{ value: "notImpacted", description: "Test is not impacted. Added fot TIA." }
      ],
    }
  )
  outcome?:
    | "unspecified"
    | "none"
    | "passed"
    | "failed"
    | "inconclusive"
    | "timeout"
    | "aborted"
    | "blocked"
    | "notExecuted"
    | "warning"
    | "error"
    | "notApplicable"
    | "paused"
    | "inProgress"
    | "notImpacted";

  /** Number of results on rerun */
  rerunResultCount?: int32;
}

model AggregatedResultsAnalysis {
  @format("TimeSpan") duration?: string;
  notReportedResultsByOutcome?: Record<AggregatedResultsByOutcome>;
  previousContext?: TestResultsContext;
  resultsByOutcome?: Record<AggregatedResultsByOutcome>;
  resultsDifference?: AggregatedResultsDifference;
  runSummaryByOutcome?: Record<AggregatedRunsByOutcome>;
  runSummaryByState?: Record<AggregatedRunsByState>;
  totalTests?: int32;
}

model AggregatedResultsByOutcome {
  count?: int32;
  @format("TimeSpan") duration?: string;
  groupByField?: string;
  groupByValue?: {};
  @extension(
    "x-ms-enum",
    #{
      name: "TestOutcome",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{
          value: "none",
          description: "Test has not been completed, or the test type does not report pass/failure.",
        },
        #{ value: "passed", description: "Test was executed w/o any issues." },
        #{
          value: "failed",
          description: "Test was executed, but there were issues. Issues may involve exceptions or failed assertions.",
        },
        #{
          value: "inconclusive",
          description: "Test has completed, but we can't say if it passed or failed. May be used for aborted tests...",
        },
        #{ value: "timeout", description: "The test timed out" },
        #{
          value: "aborted",
          description: "Test was aborted. This was not caused by a user gesture, but rather by a framework decision.",
        },
        #{
          value: "blocked",
          description: "Test had it chance for been executed but was not, as ITestElement.IsRunnable == false.",
        },
        #{
          value: "notExecuted",
          description: "Test was not executed. This was caused by a user gesture - e.g. user hit stop button.",
        },
        #{
          value: "warning",
          description: "To be used by Run level results. This is not a failure.",
        },
        #{
          value: "error",
          description: "There was a system error while we were trying to execute a test.",
        },
        #{ value: "notApplicable", description: "Test is Not Applicable for execution." },
        #{ value: "paused", description: "Test is paused." },
        #{
          value: "inProgress",
          description: "Test is currently executing. Added this for TCM charts",
        },
        #{ value: "notImpacted", description: "Test is not impacted. Added fot TIA." }
      ],
    }
  )
  outcome?:
    | "unspecified"
    | "none"
    | "passed"
    | "failed"
    | "inconclusive"
    | "timeout"
    | "aborted"
    | "blocked"
    | "notExecuted"
    | "warning"
    | "error"
    | "notApplicable"
    | "paused"
    | "inProgress"
    | "notImpacted";
  rerunResultCount?: int32;
}

model AggregatedResultsDifference {
  @format("TimeSpan") increaseInDuration?: string;
  increaseInFailures?: int32;
  increaseInNonImpactedTests?: int32;
  increaseInOtherTests?: int32;
  increaseInPassedTests?: int32;
  increaseInTotalTests?: int32;
}

model AggregatedRunsByOutcome {
  @extension(
    "x-ms-enum",
    #{
      name: "TestRunOutcome",
      values: #[
        #{
          value: "passed",
          description: "Run with zero failed tests and has at least one impacted test",
        },
        #{ value: "failed", description: "Run with at-least one failed test." },
        #{ value: "notImpacted", description: "Run with no impacted tests." },
        #{ value: "others", description: "Runs with All tests in other category." }
      ],
    }
  )
  outcome?: "passed" | "failed" | "notImpacted" | "others";
  runsCount?: int32;
}

model AggregatedRunsByState {
  resultsByOutcome?: Record<AggregatedResultsByOutcome>;
  runsCount?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "TestRunState",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{
          value: "notStarted",
          description: "The run is still being created. No tests have started yet.",
        },
        #{ value: "inProgress", description: "Tests are running." },
        #{ value: "completed", description: "All tests have completed or been skipped." },
        #{ value: "aborted", description: "Run is stopped and remaining tests have been aborted" },
        #{
          value: "waiting",
          description: "Run is currently initializing This is a legacy state and should not be used any more",
        },
        #{
          value: "needsInvestigation",
          description: "Run requires investigation because of a test point failure This is a legacy state and should not be used any more",
        }
      ],
    }
  )
  state?:
    | "unspecified"
    | "notStarted"
    | "inProgress"
    | "completed"
    | "aborted"
    | "waiting"
    | "needsInvestigation";
}

model AnalysisFailureGroupReturn {
  analysisFailureGroupId?: int64;
  failureGroupUid?: string;
}

model Attachment {
  compressionType?: string;
  fileName?: string;
  @format("Stream") stream?: string;
}

/** Branch information */
model BranchInfo {
  /** Branch name - simple name or full Git reference */
  branchName?: string;

  /** Branch reference type. Optional, defaults to 'none' if not specified. */
  @extension(
    "x-ms-enum",
    #{
      name: "BranchType",
      values: #[
        #{ value: "none", description: "Undefined branch type" },
        #{ value: "heads", description: "Branch reference" },
        #{ value: "tags", description: "Tag reference" },
        #{ value: "pull", description: "Pull request reference" }
      ],
    }
  )
  branchType?: "none" | "heads" | "tags" | "pull";
}

/** BuildConfiguration Details. */
model BuildConfiguration {
  /** Branch name for which build is generated. */
  branchName?: string;

  /** BuildDefinitionId for build. */
  buildDefinitionId?: int32;

  /** Build system. */
  buildSystem?: string;

  /** Build Creation Date. */
  creationDate?: utcDateTime;

  /** Build flavor (eg Build/Release). */
  flavor?: string;

  /** BuildConfiguration Id. */
  id?: int32;

  /** Build Number. */
  number?: string;

  /** BuildConfiguration Platform. */
  platform?: string;

  project?: ShallowReference;

  /** Repository Guid for the Build. */
  repositoryGuid?: string;

  /** Repository Type (eg. TFSGit). */
  repositoryType?: string;

  /** Source Version(/first commit) for the build was triggered. */
  sourceVersion?: string;

  /** Target BranchName. */
  targetBranchName?: string;

  /** Build Uri. */
  uri?: string;
}

/** Build Coverage Detail */
model BuildCoverage {
  /** Code Coverage File Url */
  codeCoverageFileUrl?: string;

  configuration?: BuildConfiguration;

  /** Last Error */
  lastError?: string;

  /** List of Modules */
  modules?: ModuleCoverage[];

  /** State */
  state?: string;
}

/** Reference to a build. */
model BuildReference {
  /** Branch name. */
  branchName?: string;

  /** Build system. */
  buildSystem?: string;

  /** Build Definition ID. */
  definitionId?: int32;

  /** Build ID. */
  id?: int32;

  /** Build Number. */
  number?: string;

  /** Repository ID. */
  repositoryId?: string;

  /** Build URI. */
  uri?: string;
}

/** Represents the build configuration (platform, flavor) and coverage data for the build */
model CodeCoverageData {
  /** Flavor of build for which data is retrieved/published */
  buildFlavor?: string;

  /** Platform of build for which data is retrieved/published */
  buildPlatform?: string;

  /** List of coverage data for the build */
  coverageStats?: CodeCoverageStatistics[];
}

/** Represents the code coverage statistics for a particular coverage label (modules, statements, blocks, etc.) */
model CodeCoverageStatistics {
  /** Covered units */
  covered?: int32;

  /** Delta of coverage */
  delta?: float64;

  /** Is delta valid */
  isDeltaAvailable?: boolean;

  /** Label of coverage data ('Blocks', 'Statements', 'Modules', etc.) */
  label?: string;

  /** Position of label */
  position?: int32;

  /** Total units */
  total?: int32;
}

/** Represents the code coverage summary results Used to publish or retrieve code coverage summary against a build */
model CodeCoverageSummary {
  build?: ShallowReference;

  /** List of coverage data and details for the build */
  coverageData?: CodeCoverageData[];

  @extension(
    "x-ms-enum",
    #{
      name: "CoverageDetailedSummaryStatus",
      values: #[
        #{ value: "none", description: "No coverage status" },
        #{ value: "inProgress", description: "The summary evaluation is in progress" },
        #{
          value: "finalized",
          description: "The summary evaluation is finalized and won't change",
        },
        #{ value: "pending", description: "The summary evaluation is pending" },
        #{
          value: "updateRequestQueued",
          description: "Summary evaluation may be ongoing but another merge has been requested.",
        },
        #{ value: "noModulesFound", description: "No coverage modules found" },
        #{ value: "numberOfFilesExceeded", description: "Number of Files exceeded" },
        #{ value: "noInputFiles", description: "TNo Input Files" },
        #{ value: "buildCancelled", description: "Build got cancelled by user" },
        #{ value: "failedJobs", description: "Coverage Jobs failed" },
        #{ value: "moduleMergeJobTimeout", description: "Module merge Timeout" },
        #{ value: "codeCoverageSuccess", description: "Coverage successfully completed" },
        #{ value: "invalidBuildConfiguration", description: "Invalid Build Configuration" },
        #{
          value: "coverageAnalyzerBuildNotFound",
          description: "Coverage Analyzer Build not found",
        },
        #{ value: "failedToRequeue", description: "Failed to requeue the build" },
        #{ value: "buildBailedOut", description: "Build got Bailed out" },
        #{ value: "noCodeCoverageTask", description: "No Code coverage configured" },
        #{ value: "mergeJobFailed", description: "CoverageMerge Job failed" },
        #{ value: "mergeInvokerJobFailed", description: "CoverageMergeInvoker Job failed" },
        #{ value: "monitorJobFailed", description: "CoverageMonitor Job failed" },
        #{
          value: "moduleMergeInvokerJobTimeout",
          description: "CoverageMergeInvoker Job timeout",
        },
        #{ value: "monitorJobTimeout", description: "CoverageMonitor Job timeout" },
        #{ value: "invalidCoverageInput", description: "Invalid Coverage Input file" }
      ],
    }
  )
  coverageDetailedSummaryStatus?:
    | "none"
    | "inProgress"
    | "finalized"
    | "pending"
    | "updateRequestQueued"
    | "noModulesFound"
    | "numberOfFilesExceeded"
    | "noInputFiles"
    | "buildCancelled"
    | "failedJobs"
    | "moduleMergeJobTimeout"
    | "codeCoverageSuccess"
    | "invalidBuildConfiguration"
    | "coverageAnalyzerBuildNotFound"
    | "failedToRequeue"
    | "buildBailedOut"
    | "noCodeCoverageTask"
    | "mergeJobFailed"
    | "mergeInvokerJobFailed"
    | "monitorJobFailed"
    | "moduleMergeInvokerJobTimeout"
    | "monitorJobTimeout"
    | "invalidCoverageInput";
  deltaBuild?: ShallowReference;

  /** Uri of build against which difference in coverage is computed */
  @extension(
    "x-ms-enum",
    #{
      name: "CoverageSummaryStatus",
      values: #[
        #{ value: "none", description: "No coverage status" },
        #{ value: "inProgress", description: "The summary evaluation is in progress" },
        #{
          value: "completed",
          description: "The summary evaluation for the previous request is completed. Summary can change in future",
        },
        #{
          value: "finalized",
          description: "The summary evaluation is finalized and won't change",
        },
        #{ value: "pending", description: "The summary evaluation is pending" },
        #{
          value: "updateRequestQueued",
          description: "Summary evaluation may be ongoing but another merge has been requested.",
        }
      ],
    }
  )
  status?: "none" | "inProgress" | "completed" | "finalized" | "pending" | "updateRequestQueued";
}

model CoverageStatistics {
  blocksCovered?: int32;
  blocksNotCovered?: int32;
  branchesCovered?: int32;
  branchesNotCovered?: int32;
  linesCovered?: int32;
  linesNotCovered?: int32;
  linesPartiallyCovered?: int32;
}

/** A custom field information. Allowed Key : Value pairs - ( AttemptId: int value, IsTestResultFlaky: bool) */
model CustomTestField {
  /** Name of the Custom Test Field */
  fieldName?: string;

  /** 1. If the CustomTestField is registered as Bit data type, value should be sent as case insensitive string - either 'true' or 'false'. 2. If the CustomTestField is registered as Datetime data type, value should be sent as string in the format of 'YYYY-MM-DD hh:mm:ss' 3. If the CustomTestField is registered as Int data type, value should be sent as string representation of 32 bit signed integer. Ex: '5'. 4. If the CustomTestField is registered as Float data type, value should be sent as string for example '4.237' 5. If the CustomTestField is registered as String data type, Any string up to 1kB is accepted. 6. If the CustomTestField is registered as Guid, value should be sent as case insensitive string representation of GUID in usual format 'XXXXXXXX-XXXX-XXXX-XXXXXXXXXXXX' where X can be either number 0-9 or letter A-F. For example 'f88d6b84-3549-4af0-a4f4-58139cd0a14f'. */
  value?: {};
}

/** Data structure which stores details for the customTestFields to be updated */
model CustomTestFieldDefinition {
  /** ID assigned to the custom test field upon creation, should be left empty when creating. */
  fieldId?: int32;

  /** The name of custom field cannot be longer than 50 characters (spaces, numbers, and special characters are not allowed) and must be unique in the project. The names are case insensitive. */
  fieldName?: string;

  /** Data type of the customTestField. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomTestFieldType",
      values: #[
        #{ value: "bit", description: "Boolean data type." },
        #{ value: "dateTime", description: "Datetime data type." },
        #{ value: "int", description: "Integer data type." },
        #{ value: "float", description: "Floating integer data type." },
        #{ value: "string", description: "String data type." },
        #{ value: "guid", description: "Unique identifier data type." }
      ],
    }
  )
  fieldType?: "bit" | "dateTime" | "int" | "float" | "string" | "guid";

  /** Artifact to which customTestField will be set. */
  @extension(
    "x-ms-enum",
    #{
      name: "CustomTestFieldScope",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "testRun", description: "Custom field can be used with TestRun artifact." },
        #{
          value: "testResult",
          description: "Custom field can be used with TestResult artifact.",
        },
        #{
          value: "testRunAndTestResult",
          description: "Custom test field can be used with either TestRun or TestResult artifact.",
        },
        #{
          value: "system",
          description: "Reserved for internal Azure DevOps functionality. Not to be used.",
        },
        #{ value: "all", description: "" }
      ],
    }
  )
  scope?: "none" | "testRun" | "testResult" | "testRunAndTestResult" | "system" | "all";
}

/** Data structure which stores details for the customTestField to be updated. */
model CustomTestFieldUpdateDefinition {
  /** Custom test field id which is to be updated. */
  fieldId?: int32;

  /** The name of custom field cannot be longer than 50 characters(spaces, numbers, and special characters are not allowed) and must be unique in the project.CustomTestField name is case insensitive. */
  fieldName?: string;
}

/** This is a temporary class to provide the details for the test run environment. */
model DtlEnvironmentDetails {
  csmContent?: string;
  csmParameters?: string;
  subscriptionName?: string;
}

/** Failing since information of a test result. */
model FailingSince {
  build?: BuildReference;

  /** Time since failing(UTC). */
  date?: utcDateTime;

  release?: ReleaseReference;
}

model FieldDetailsForTestResults {
  /** Group by field name */
  fieldName?: string;

  /** Group by field values */
  groupsForField?: {}[];
}

model FileCoverageData {
  coverageStatistics?: CoverageStatistics;
  name?: string;
}

model FileCoverageRequest {
  filePath?: string;
  pullRequestBaseIterationId?: int32;
  pullRequestId?: int32;
  pullRequestIterationId?: int32;
  repoId?: string;
}

model FlakyDetection {
  flakyDetectionPipelines?: FlakyDetectionPipelines;

  /** FlakyDetectionType defines Detection type i.e. 1. System or 2. Manual. */
  @extension(
    "x-ms-enum",
    #{
      name: "FlakyDetectionType",
      values: #[
        #{ value: "custom", description: "Custom defines manual detection type." },
        #{ value: "system", description: "Defines System detection type." }
      ],
    }
  )
  flakyDetectionType?: "custom" | "system";
}

model FlakyDetectionPipelines {
  /** AllowedPipelines - List All Pipelines allowed for detection. */
  allowedPipelines?: int32[];

  /** IsAllPipelinesAllowed if users configure all system's pipelines. */
  isAllPipelinesAllowed?: boolean;
}

model FlakySettings {
  /** Advanced flaky detection Mode */
  @extension(
    "x-ms-enum",
    #{
      name: "AdvancedFlakyDetectionMode",
      values: #[
        #{ value: "disabled", description: "Advanced Flaky Detection is Disabled Mode" },
        #{ value: "preview", description: "Advanced Flaky Detection is Preview Mode" },
        #{ value: "enabled", description: "Advanced Flaky Detection is Enabled Mode" }
      ],
    }
  )
  advancedSystemDetectionMode?: "disabled" | "preview" | "enabled";

  flakyDetection?: FlakyDetection;

  /** FlakyInSummaryReport defines flaky data should show in summary report or not. */
  flakyInSummaryReport?: boolean;

  /** IsFlakyBugCreated defines if there is any bug that has been created with flaky testresult. */
  isFlakyBugCreated?: boolean;

  /** ManualMarkUnmarkFlaky defines manual marking unmarking of flaky testcase. */
  manualMarkUnmarkFlaky?: boolean;
}

model FlakyTestBugConfig {
  /** Metadata properties for flaky test bug. */
  bugMetadata?: ("errorMessage" | "stackTrace" | "testName" | "machine")[];

  /** Bug Priority for flaky test bug. */
  bugPriority?: int32;

  /** Bug Template Id for flaky test bug. */
  bugTemplateId?: string;

  /** Team Id for the bug template */
  teamId?: string;
}

model FolderCoverageData {
  coverageStatistics?: CoverageStatistics;
  files?: FileCoverageData[];
  folders?: FolderCoverageData[];
  name?: string;
}

model FunctionCoverage {
  class?: string;
  name?: string;
  `namespace`?: string;
  sourceFile?: string;
  statistics?: CoverageStatistics;
}

model GenerateTestPlanFromWorkItemModel {
  userInstructions?: string;
}

model GraphSubjectBase {
  _links?: ReferenceLinks;
  descriptor?: string;
  displayName?: string;
  url?: string;
}

model IdentityRef {
  ...GraphSubjectBase;
  directoryAlias?: string;
  id?: string;
  imageUrl?: string;
  inactive?: boolean;
  isAadIdentity?: boolean;
  isContainer?: boolean;
  isDeletedInOrigin?: boolean;
  profileUrl?: string;
  uniqueName?: string;
}

/** Job in pipeline. This is related to matrixing in YAML. */
model JobReference {
  /** Attempt number of the job */
  attempt?: int32;

  /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
  jobName?: string;
}

/** Layout contract that defines the layouts of a session */
model Layout {
  /** Layout children */
  children?: Layout[];

  /** Layout end time */
  endTimeUTC?: utcDateTime;

  /** Layout name */
  name?: string;

  /** Layout properties */
  properties?: Record<string>;

  /** Layout start time */
  startTimeUTC?: utcDateTime;

  /** Layout type */
  type?: string;

  /** Layout uid */
  @format("uuid") uid?: string;
}

/** Links */
model Link {
  /** Display Name */
  displayName?: string;

  /** Link Operation Type Valid values = (Open, WebService) */
  operationType?: string;

  /** Link type (maps to enum value; see parent object for acceptable values) */
  type?: string;

  /** Link url */
  url?: string;
}

/** Computer which ran tests in the session */
model Machine {
  /** GUID identifier for the environment the machine was configured with */
  @format("uuid") environmentUid?: string;

  /** Machine instance id */
  instanceId?: int64;

  /** Name of the machine */
  name?: string;

  /** Session Machine timeline Valid values for 'type' property = (Requested, Ready, Released) */
  timeline?: Timeline[];
}

model ModuleCoverage {
  blockCount?: int32;
  blockData?: bytes[];

  /** Code Coverage File Url */
  fileUrl?: string;

  functions?: FunctionCoverage[];
  name?: string;
  @format("uuid") signature?: string;
  signatureAge?: int32;
  statistics?: CoverageStatistics;
}

model NewTestResultLoggingSettings {
  /** LogNewTests defines whether or not we will record new test cases coming into the system */
  logNewTests?: boolean;
}

/** Phase in pipeline */
model PhaseReference {
  /** Attempt number of the phase */
  attempt?: int32;

  /** Name of the phase. Maximum supported length for name is 256 character. */
  phaseName?: string;
}

/** Lightweight output for pipeline debugger AI analysis. */
model PipelineDebuggerAnalysisOutput {
  /** Failure category (e.g., 'Infrastructure', 'Code', 'Configuration'). */
  category?: string;

  /** Prevention strategies suggested by AI. */
  prevention?: string;

  /** Recommended fix provided by AI. */
  recommendedFix?: string;

  /** Root cause identified by AI. */
  rootCause?: string;
}

/** Response DTO returned by the pipeline debugger POST endpoint. */
model PipelineDebuggerResponse {
  analysisResult?: PipelineDebuggerAnalysisOutput;

  /** Human-readable status message (e.g. 'queued successfully', 'already running', or 'Analysis already completed'). */
  message?: string;
}

/** Pipeline reference */
model PipelineReference {
  jobReference?: JobReference;
  phaseReference?: PhaseReference;

  /** Reference of the BuildDefinitionId. */
  pipelineDefinitionId?: int32;

  /** Reference of the pipeline with which this pipeline instance is related. */
  pipelineId?: int32;

  stageReference?: StageReference;
}

/** Test summary of a pipeline instance. */
model PipelineTestMetrics {
  currentContext?: PipelineReference;
  resultsAnalysis?: ResultsAnalysis;
  resultSummary?: ResultSummary;
  runSummary?: RunSummary;

  /** Summary at child node. */
  summaryAtChild?: PipelineTestMetrics[];
}

model QueryModel {
  query?: string;
}

model ReferenceLinks {
  links?: Record<{}>;
}

/** Reference to a release. */
model ReleaseReference {
  /** Number of Release Attempt. */
  attempt?: int32;

  /** Release Creation Date(UTC). */
  creationDate?: utcDateTime;

  /** Release definition ID. */
  definitionId?: int32;

  /** Environment creation Date(UTC). */
  environmentCreationDate?: utcDateTime;

  /** Release environment definition ID. */
  environmentDefinitionId?: int32;

  /** Release environment definition name. */
  environmentDefinitionName?: string;

  /** Release environment ID. */
  environmentId?: int32;

  /** Release environment name. */
  environmentName?: string;

  /** Release ID. */
  id?: int32;

  /** Release name. */
  name?: string;
}

/** Results insights for runs with state completed and NeedInvestigation. */
model ResultsAnalysis {
  previousContext?: PipelineReference;
  resultsDifference?: AggregatedResultsDifference;
  testFailuresAnalysis?: TestResultFailuresAnalysis;
}

model ResultsFilter {
  automatedTestName?: string;
  branch?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "Service",
      values: #[
        #{ value: "any", description: "" },
        #{ value: "tcm", description: "" },
        #{ value: "tfs", description: "" }
      ],
    }
  )
  executedIn?: "any" | "tcm" | "tfs";
  groupBy?: string;
  maxCompleteDate?: utcDateTime;
  resultsCount?: int32;
  testCaseId?: int32;
  testCaseReferenceIds?: int32[];
  testPlanId?: int32;
  testPointIds?: int32[];
  testResultsContext?: TestResultsContext;
  trendDays?: int32;
}

/** Result summary by the outcome of test results. */
model ResultsSummaryByOutcome {
  /** Aggregated result details for each test result outcome. */
  aggregatedResultDetailsByOutcome?: Record<AggregatedResultDetailsByOutcome>;

  /** Time taken by results. */
  @format("TimeSpan") duration?: string;

  /** Total number of not reported test results. */
  notReportedTestCount?: int32;

  /** Total number of test results. (It includes NotImpacted test results as well which need to exclude while calculating pass/fail test result percentage). */
  totalTestCount?: int32;
}

/** Summary of results for a pipeline instance. */
model ResultSummary {
  /** Result summary of pipeline, group by TestRun state. */
  resultSummaryByRunState?: Record<ResultsSummaryByOutcome>;
}

/** Test run create details. */
model RunCreateModel {
  /** true if test run is automated, false otherwise. By default it will be false. */
  automated?: boolean;

  build?: ShallowReference;

  /** Drop location of the build used for test run. */
  buildDropLocation?: string;

  /** Flavor of the build used for test run. (E.g: Release, Debug) */
  buildFlavor?: string;

  /** Platform of the build used for test run. (E.g.: x86, amd64) */
  buildPlatform?: string;

  buildReference?: BuildConfiguration;

  /** Comments entered by those analyzing the run. */
  comment?: string;

  /** Completed date time of the run. */
  completeDate?: string;

  /** IDs of the test configurations associated with the run. */
  configurationIds?: int32[];

  /** Name of the test controller used for automated run. */
  controller?: string;

  /** List of custom data for additional categorization of the test run. Value of the CustomTestField cannot be more than 1KB. */
  customTestFields?: CustomTestField[];

  dtlAutEnvironment?: ShallowReference;
  dtlTestEnvironment?: ShallowReference;

  /** Due date and time for test run. */
  dueDate?: string;

  environmentDetails?: DtlEnvironmentDetails;

  /** Error message associated with the run. */
  errorMessage?: string;

  filter?: RunFilter;

  /** The iteration in which to create the run. Root iteration of the team project will be default */
  iteration?: string;

  /** Name of the test run. */
  name?: string;

  owner?: IdentityRef;
  pipelineReference?: PipelineReference;
  plan?: ShallowReference;

  /** IDs of the test points to use in the run. */
  pointIds?: int32[];

  /** URI of release environment associated with the run. */
  releaseEnvironmentUri?: string;

  releaseReference?: ReleaseReference;

  /** URI of release associated with the run. */
  releaseUri?: string;

  /** Run summary for run Type = NoConfigRun. */
  runSummary?: RunSummaryModel[];

  /** Timespan till the run times out. */
  @format("TimeSpan") runTimeout?: string;

  /** SourceWorkFlow(CI/CD) of the test run. */
  sourceWorkflow?: string;

  /** Start date time of the run. */
  startDate?: string;

  /** The state of the run. Type TestRunState Valid states - NotStarted, InProgress, Waiting */
  state?: string;

  /** Tags to attach with the test run, maximum of 5 tags can be added to run. */
  tags?: TestTag[];

  /** TestConfigurationMapping of the test run. */
  testConfigurationsMapping?: string;

  /** ID of the test environment associated with the run. */
  testEnvironmentId?: string;

  testSettings?: ShallowReference;

  /** Type of the run(RunType) Valid Values : (Unspecified, Normal, Blocking, Web, MtrRunInitiatedFromWeb, RunWithDtlEnv, NoConfigRun) */
  type?: string;
}

/** This class is used to provide the filters used for discovery */
model RunFilter {
  /** filter for the test case sources (test containers) */
  sourceFilter?: string;

  /** filter for the test cases */
  testCaseFilter?: string;
}

/** Test run statistics per outcome. */
model RunStatistic {
  /** Test result count fo the given outcome. */
  count?: int32;

  /** Test result outcome */
  outcome?: string;

  resolutionState?: TestResolutionState;

  /** ResultMetadata for the given outcome/count. */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultMetadata",
      values: #[
        #{ value: "rerun", description: "Rerun metadata" },
        #{ value: "flaky", description: "Flaky metadata" }
      ],
    }
  )
  resultMetadata?: "rerun" | "flaky";

  /** State of the test run */
  state?: string;
}

/** Summary of runs for a pipeline instance. */
model RunSummary {
  /** Total time taken by runs with state completed and NeedInvestigation. */
  @format("TimeSpan") duration?: string;

  /** NoConfig runs count. */
  noConfigRunsCount?: int32;

  /** Runs count by outcome for runs with state completed and NeedInvestigation runs. */
  runSummaryByOutcome?: Record<int32>;

  /** Runs count by state. */
  runSummaryByState?: Record<int32>;

  /** Total runs count. */
  totalRunsCount?: int32;
}

/** Run summary for each output type of test. */
model RunSummaryModel {
  /** Total time taken in milliseconds. */
  duration?: int64;

  /** Number of results for Outcome TestOutcome */
  resultCount?: int32;

  /** Summary is based on outcome */
  @extension(
    "x-ms-enum",
    #{
      name: "TestOutcome",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{
          value: "none",
          description: "Test has not been completed, or the test type does not report pass/failure.",
        },
        #{ value: "passed", description: "Test was executed w/o any issues." },
        #{
          value: "failed",
          description: "Test was executed, but there were issues. Issues may involve exceptions or failed assertions.",
        },
        #{
          value: "inconclusive",
          description: "Test has completed, but we can't say if it passed or failed. May be used for aborted tests...",
        },
        #{ value: "timeout", description: "The test timed out" },
        #{
          value: "aborted",
          description: "Test was aborted. This was not caused by a user gesture, but rather by a framework decision.",
        },
        #{
          value: "blocked",
          description: "Test had it chance for been executed but was not, as ITestElement.IsRunnable == false.",
        },
        #{
          value: "notExecuted",
          description: "Test was not executed. This was caused by a user gesture - e.g. user hit stop button.",
        },
        #{
          value: "warning",
          description: "To be used by Run level results. This is not a failure.",
        },
        #{
          value: "error",
          description: "There was a system error while we were trying to execute a test.",
        },
        #{ value: "notApplicable", description: "Test is Not Applicable for execution." },
        #{ value: "paused", description: "Test is paused." },
        #{
          value: "inProgress",
          description: "Test is currently executing. Added this for TCM charts",
        },
        #{ value: "notImpacted", description: "Test is not impacted. Added fot TIA." }
      ],
    }
  )
  testOutcome?:
    | "unspecified"
    | "none"
    | "passed"
    | "failed"
    | "inconclusive"
    | "timeout"
    | "aborted"
    | "blocked"
    | "notExecuted"
    | "warning"
    | "error"
    | "notApplicable"
    | "paused"
    | "inProgress"
    | "notImpacted";
}

model RunUpdateModel {
  build?: ShallowReference;

  /** Drop location of the build used for test run. */
  buildDropLocation?: string;

  /** Flavor of the build used for test run. (E.g: Release, Debug) */
  buildFlavor?: string;

  /** Platform of the build used for test run. (E.g.: x86, amd64) */
  buildPlatform?: string;

  /** Comments entered by those analyzing the run. */
  comment?: string;

  /** Completed date time of the run. */
  completedDate?: string;

  /** Name of the test controller used for automated run. */
  controller?: string;

  /** List of custom data for additional categorization of the test run. Value of the CustomTestField cannot be more than 1KB. */
  customTestFields?: CustomTestField[];

  /** true to delete inProgess Results , false otherwise. */
  deleteInProgressResults?: boolean;

  dtlAutEnvironment?: ShallowReference;
  dtlEnvironment?: ShallowReference;
  dtlEnvironmentDetails?: DtlEnvironmentDetails;

  /** Due date and time for test run. */
  dueDate?: string;

  /** Error message associated with the run. */
  errorMessage?: string;

  /** The iteration in which to create the run. */
  iteration?: string;

  /** Log entries associated with the run. Use a comma-separated list of multiple log entry objects. { logEntry }, { logEntry }, ... */
  logEntries?: TestMessageLogDetails[];

  /** Name of the test run. */
  name?: string;

  /** URI of release environment associated with the run. */
  releaseEnvironmentUri?: string;

  /** URI of release associated with the run. */
  releaseUri?: string;

  /** Run summary for run Type = NoConfigRun. */
  runSummary?: RunSummaryModel[];

  /** SourceWorkFlow(CI/CD) of the test run. */
  sourceWorkflow?: string;

  /** Start date time of the run. */
  startedDate?: string;

  /** The state of the test run Below are the valid values - NotStarted, InProgress, Completed, Aborted, Waiting */
  state?: string;

  /** The types of sub states for test run. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestRunSubstate",
      values: #[
        #{ value: "none", description: "Run with noState." },
        #{ value: "creatingEnvironment", description: "Run state while Creating Environment." },
        #{ value: "runningTests", description: "Run state while Running Tests." },
        #{ value: "canceledByUser", description: "Run state while Creating Environment." },
        #{ value: "abortedBySystem", description: "Run state when it is Aborted By the System." },
        #{ value: "timedOut", description: "Run state when run has timedOut." },
        #{ value: "pendingAnalysis", description: "Run state while Pending Analysis." },
        #{ value: "analyzed", description: "Run state after being Analysed." },
        #{
          value: "cancellationInProgress",
          description: "Run state when cancellation is in Progress.",
        }
      ],
    }
  )
  substate?:
    | "none"
    | "creatingEnvironment"
    | "runningTests"
    | "canceledByUser"
    | "abortedBySystem"
    | "timedOut"
    | "pendingAnalysis"
    | "analyzed"
    | "cancellationInProgress";

  /** Tags to attach with the test run. */
  tags?: TestTag[];

  /** ID of the test environment associated with the run. */
  testEnvironmentId?: string;

  testSettings?: ShallowReference;
}

/** Container class for TestSessionEnvironment and Machine objects related to a test session */
model SessionEnvironmentAndMachine {
  /** Session Environments */
  environments?: TestSessionEnvironment[];

  /** Session Machines */
  machines?: Machine[];
}

/** SessionSourcePipeline */
model SessionSourcePipeline {
  /** Source pipeline id */
  buildId?: int32;

  /** Source pipeline url */
  buildUrl?: string;
}

/** An abstracted reference to some other resource. This class is used to provide the build data contracts with a uniform way to reference other resources in a way that provides easy traversal through links. */
model ShallowReference {
  /** ID of the resource */
  id?: string;

  /** Name of the linked resource (definition name, controller name, etc.) */
  name?: string;

  /** Full http link to the resource */
  url?: string;
}

model ShallowTestCaseResult {
  automatedTestName?: string;
  automatedTestStorage?: string;
  durationInMs?: float64;
  id?: int32;
  isReRun?: boolean;
  outcome?: string;
  owner?: string;
  priority?: int32;
  refId?: int32;
  runId?: int32;
  tags?: string[];
  testCaseTitle?: string;
}

/** Reference to shared step workitem. */
model SharedStepModel {
  /** WorkItem shared step ID. */
  id?: int32;

  /** Shared step workitem revision. */
  revision?: int32;
}

/** Session source */
model Source {
  /** Source links Valid values for 'type' property = (SessionInfo, ResubmitSession) */
  links?: Link[];

  /** Source origin system */
  originSystem?: string;

  /** Source session id */
  @format("uuid") sessionId?: string;

  /** Source tenant Id */
  @format("uuid") tenantId?: string;

  /** Source tenant name */
  tenantName?: string;
}

model SourceViewBuildCoverage {
  configuration?: BuildConfiguration;
  folderCoverageData?: FolderCoverageData;
}

/** Stage in pipeline */
model StageReference {
  /** Attempt number of stage */
  attempt?: int32;

  /** Name of the stage. Maximum supported length for name is 256 character. */
  stageName?: string;
}

model TeamProjectReference {
  abbreviation?: string;
  defaultTeamImageUrl?: string;
  description?: string;
  @format("uuid") id?: string;
  lastUpdateTime?: utcDateTime;
  name?: string;
  revision?: int64;
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectState",
      values: #[
        #{ value: "deleting", description: "" },
        #{ value: "new", description: "" },
        #{ value: "wellFormed", description: "" },
        #{ value: "createPending", description: "" },
        #{ value: "all", description: "" },
        #{ value: "unchanged", description: "" },
        #{ value: "deleted", description: "" }
      ],
    }
  )
  state?: "deleting" | "new" | "wellFormed" | "createPending" | "all" | "unchanged" | "deleted";
  url?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectVisibility",
      values: #[#{ value: "private", description: "" }, #{ value: "public", description: "" }],
    }
  )
  visibility?: "private" | "public";
}

/** Represents a test step result. */
model TestActionResultModel {
  ...TestResultModelBase;

  /** Path identifier for test step in test case workitem. Note: 1) It is represented in Hexadecimal format with 8 digits for a step. 2) Internally, the step ID value for first step starts with 2 so actionPath = 00000002 step 9, will have an ID = 10 and actionPath = 0000000a step 15, will have an ID =16 and actionPath = 00000010 3) actionPath of shared step is concatenated with the parent step of test case. Example, it would be something of type - 0000000300000001 where 00000003 denotes action path of test step and 00000001 denotes action path for shared step */
  actionPath?: string;

  /** Actual result message of test action result. */
  actualResultMessage?: string;

  /** Iteration ID of test action result. */
  iterationId?: int32;

  sharedStepModel?: SharedStepModel;

  /** This is step Id of test case. For shared step, it is step Id of shared step in test case workitem; step Id in shared step. Example: TestCase workitem has two steps: 1) Normal step with Id = 1 2) Shared Step with Id = 2. Inside shared step: a) Normal Step with Id = 1 Value for StepIdentifier for First step: '1' Second step: '2;1' */
  stepIdentifier?: string;

  /** Url of test action result. Deprecated in hosted environment. */
  url?: string;
}

model TestAgentCallbackRequest {
  success?: boolean;
  task?: string;
  workItemId?: int32;
}

model TestAgentTriggerRequest {
  task?: string;
  workItemId?: int32;
}

/** Test analysis failure group object */
model TestAnalysisFailureGroup {
  /** classification category of the group Allowable values: 'Critical', 'System', 'Discounted' */
  classificationCategory?: string;

  /** analysis group dimensions */
  dimensions?: Record<{}>;

  /** reason for the analysis category */
  displayReason?: string;

  /** title of the analysis category display */
  displayTitle?: string;

  /** analysis failure group id */
  failureGroupId?: int64;

  /** unique id across the object */
  uid?: string;
}

model TestAttachment {
  /** Attachment type. */
  @extension(
    "x-ms-enum",
    #{
      name: "AttachmentType",
      values: #[
        #{
          value: "generalAttachment",
          description: "Attachment type GeneralAttachment , use this as default type unless you have other type.",
        },
        #{ value: "codeCoverage", description: "Attachment type CodeCoverage." },
        #{ value: "consoleLog", description: "Attachment type ConsoleLog." }
      ],
    }
  )
  attachmentType?: "generalAttachment" | "codeCoverage" | "consoleLog";

  /** Comment associated with attachment. */
  comment?: string;

  /** Attachment created date. */
  createdDate?: utcDateTime;

  /** Attachment file name */
  fileName?: string;

  /** ID of the attachment. */
  id?: int32;

  /** Attachment size. */
  size?: int64;

  /** Attachment Url. */
  url?: string;
}

/** Reference to test attachment. */
model TestAttachmentReference {
  /** ID of the attachment. */
  id?: int32;

  /** Url to download the attachment. */
  url?: string;
}

/** Test attachment request model */
model TestAttachmentRequestModel {
  /** Attachment type By Default it will be GeneralAttachment. It can be one of the following type. { GeneralAttachment, AfnStrip, BugFilingData, CodeCoverage, IntermediateCollectorData, RunConfig, TestImpactDetails, TmiTestRunDeploymentFiles, TmiTestRunReverseDeploymentFiles, TmiTestResultDetail, TmiTestRunSummary } */
  attachmentType?: string;

  /** Comment associated with attachment */
  comment?: string;

  /** Attachment filename */
  fileName?: string;

  /** Base64 encoded file stream */
  stream?: string;
}

/** Represents a Test Case Flakiness Branch Information. */
model TestCaseFlakinessBranchInfo {
  /** AutomatedTestName of test result. */
  automatedTestName?: string;

  /** AutomatedTestStorage of test result. */
  automatedTestStorage?: string;

  /** List of Branches where Test Case Reference Id has flaked. */
  flakyBranches?: string[];

  /** Time when the test was last run. */
  lastRefTestRunDate?: utcDateTime;

  /** ID of TestCaseReference. */
  testCaseReferenceId?: int32;

  /** TestCaseTitle of test result. */
  testCaseTitle?: string;
}

/** Represents a test result. */
model TestCaseResult {
  /** Test attachment ID of action recording. */
  afnStripId?: int32;

  area?: ShallowReference;

  /** Reference to bugs linked to test result. */
  associatedBugs?: ShallowReference[];

  /** ID representing test method in a dll. */
  automatedTestId?: string;

  /** Fully qualified name of test executed. */
  automatedTestName?: string;

  /** Container to which test belongs. */
  automatedTestStorage?: string;

  /** Type of automated test. */
  automatedTestType?: string;

  /** TypeId of automated test. */
  automatedTestTypeId?: string;

  build?: ShallowReference;
  buildReference?: BuildReference;

  /** Comment in a test result with maxSize= 1000 chars. */
  comment?: string;

  /** Time when test execution completed(UTC). Completed date should be greater than StartedDate. */
  completedDate?: utcDateTime;

  /** Machine name where test executed. */
  computerName?: string;

  configuration?: ShallowReference;

  /** Timestamp when test result created(UTC). */
  createdDate?: utcDateTime;

  /** Array of custom data for additional categorization of the test result. Value of the CustomTestField cannot be more than 1KB. */
  customFields?: CustomTestField[];

  /** Duration of test execution in milliseconds. If not provided value will be set as CompletedDate - StartedDate */
  durationInMs?: float64;

  /** Error message in test execution. */
  errorMessage?: string;

  failingSince?: FailingSince;

  /** Failure type of test result. Valid Value= (Known Issue, New Issue, Regression, Unknown, None) */
  failureType?: string;

  /** ID of a test result. */
  id?: int32;

  /** Test result details of test iterations used only for Manual Testing. */
  iterationDetails?: TestIterationDetailsModel[];

  lastUpdatedBy?: IdentityRef;

  /** Last updated datetime of test result(UTC). */
  lastUpdatedDate?: utcDateTime;

  /** Test outcome of test result. Valid values = (Unspecified, None, Passed, Failed, Inconclusive, Timeout, Aborted, Blocked, NotExecuted, Warning, Error, NotApplicable, Paused, InProgress, NotImpacted) */
  outcome?: string;

  owner?: IdentityRef;

  /** Priority of test executed. */
  priority?: int32;

  project?: ShallowReference;
  release?: ShallowReference;
  releaseReference?: ReleaseReference;

  /** ResetCount. */
  resetCount?: int32;

  /** Resolution state of test result. */
  resolutionState?: string;

  /** ID of resolution state. */
  resolutionStateId?: int32;

  /** Hierarchy type of the result, default value of None means its leaf node. */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultGroupType",
      values: #[
        #{ value: "none", description: "Leaf node of test result." },
        #{ value: "rerun", description: "Hierarchy type of test result." },
        #{ value: "dataDriven", description: "Hierarchy type of test result." },
        #{ value: "orderedTest", description: "Hierarchy type of test result." },
        #{ value: "generic", description: "Unknown hierarchy type." }
      ],
    }
  )
  resultGroupType?: "none" | "rerun" | "dataDriven" | "orderedTest" | "generic";

  /** Revision number of test result. */
  revision?: int32;

  runBy?: IdentityRef;

  /** Stacktrace with maxSize= 1000 chars. */
  stackTrace?: string;

  /** Time when test execution started(UTC). */
  startedDate?: utcDateTime;

  /** State of test result. Type TestRunState. */
  state?: string;

  /** List of sub results inside a test result, if ResultGroupType is not None, it holds corresponding type sub results. */
  subResults?: TestSubResult[];

  testCase?: ShallowReference;

  /** Reference ID of test used by test result. Type TestResultMetaData */
  testCaseReferenceId?: int32;

  /** TestCaseRevision Number. */
  testCaseRevision?: int32;

  /** Name of test. */
  testCaseTitle?: string;

  testPlan?: ShallowReference;
  testPoint?: ShallowReference;
  testRun?: ShallowReference;
  testSuite?: ShallowReference;

  /** Url of test result. */
  url?: string;
}

/** Test attachment information in a test iteration. */
model TestCaseResultAttachmentModel {
  /** Path identifier test step in test case workitem. */
  actionPath?: string;

  /** Attachment ID. */
  id?: int32;

  /** Iteration ID. */
  iterationId?: int32;

  /** Name of attachment. */
  name?: string;

  /** Attachment size. */
  size?: int64;

  /** Url to attachment. */
  url?: string;
}

/** Reference to a test result. */
model TestCaseResultIdentifier {
  /** Test result ID. */
  testResultId?: int32;

  /** Test run ID. */
  testRunId?: int32;
}

/** Test environment Detail. */
model TestEnvironment {
  /** Test Environment Id. */
  @format("uuid") environmentId?: string;

  /** Test Environment Name. */
  environmentName?: string;
}

model TestFailureDetails {
  count?: int32;
  testResults?: TestCaseResultIdentifier[];
}

model TestFailuresAnalysis {
  existingFailures?: TestFailureDetails;
  fixedTests?: TestFailureDetails;
  newFailures?: TestFailureDetails;
  previousContext?: TestResultsContext;
}

/** Test Flaky Identifier */
model TestFlakyIdentifier {
  /** Branch Name where Flakiness has to be Marked/Unmarked */
  branchName?: string;

  /** State for Flakiness */
  isFlaky?: boolean;
}

/** Filter to get TestCase result history. */
model TestHistoryQuery {
  /** Automated test name of the TestCase. */
  automatedTestName?: string;

  /** Results to be get for a particular branches. */
  branch?: string;

  /** Get the results history only for this BuildDefinitionId. This to get used in query GroupBy should be Branch. If this is provided, Branch will have no use. */
  buildDefinitionId?: int32;

  /** It will be filled by server. If not null means there are some results still to be get, and we need to call this REST API with this ContinuousToken. It is not supposed to be created (or altered, if received from server in last batch) by user. */
  continuationToken?: string;

  /** Group the result on the basis of TestResultGroupBy. This can be Branch, Environment or null(if results are fetched by BuildDefinitionId) */
  @extension(
    "x-ms-enum",
    #{
      name: "TestResultGroupBy",
      values: #[
        #{ value: "branch", description: "Group the results by branches" },
        #{ value: "environment", description: "Group the results by environment" }
      ],
    }
  )
  groupBy?: "branch" | "environment";

  /** History to get between time interval MaxCompleteDate and (MaxCompleteDate - TrendDays). Default is current date time. */
  maxCompleteDate?: utcDateTime;

  /** Get the results history only for this ReleaseEnvDefinitionId. This to get used in query GroupBy should be Environment. */
  releaseEnvDefinitionId?: int32;

  /** List of TestResultHistoryForGroup which are grouped by GroupBy */
  resultsForGroup?: TestResultHistoryForGroup[];

  /** Get the results history only for this testCaseId. This to get used in query to filter the result along with automatedtestname */
  testCaseId?: int32;

  /** Number of days for which history to collect. Maximum supported value is 7 days. Default is 7 days. */
  trendDays?: int32;
}

/** Represents a test iteration result. */
model TestIterationDetailsModel {
  /** Test step results in an iteration. */
  actionResults?: TestActionResultModel[];

  /** Reference to attachments in test iteration result. */
  attachments?: TestCaseResultAttachmentModel[];

  /** Comment in test iteration result. */
  comment?: string;

  /** Time when execution completed(UTC). */
  completedDate?: utcDateTime;

  /** Duration of execution. */
  durationInMs?: float64;

  /** Error message in test iteration result execution. */
  errorMessage?: string;

  /** ID of test iteration result. */
  id?: int32;

  /** Test outcome if test iteration result. */
  outcome?: string;

  /** Test parameters in an iteration. */
  parameters?: TestResultParameterModel[];

  /** Time when execution started(UTC). */
  startedDate?: utcDateTime;

  /** Url to test iteration result. */
  url?: string;
}

/** Represents Test Log Result object. */
model TestLog {
  logReference?: TestLogReference;

  /** Meta data for Log file */
  metaData?: Record<string>;

  /** LastUpdatedDate for Log file */
  modifiedOn?: utcDateTime;

  /** Size in Bytes for Log file */
  size?: int64;
}

/** Test Log Reference object */
model TestLogReference {
  /** BuildId for test log, if context is build */
  buildId?: int32;

  /** FileName for log file */
  filePath?: string;

  /** ReleaseEnvId for test log, if context is Release */
  releaseEnvId?: int32;

  /** ReleaseId for test log, if context is Release */
  releaseId?: int32;

  /** Resultid for test log, if context is run and log is related to result */
  resultId?: int32;

  /** runid for test log, if context is run */
  runId?: int32;

  /** Test Log Scope */
  @extension(
    "x-ms-enum",
    #{
      name: "TestLogScope",
      values: #[
        #{ value: "run", description: "Log file is associated with Run, result, subresult" }
      ],
    }
  )
  scope?: "run";

  /** SubResultid for test log, if context is run and log is related to subresult */
  subResultId?: int32;

  /** Log Type */
  @extension(
    "x-ms-enum",
    #{
      name: "TestLogType",
      values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
    }
  )
  type?: "generalAttachment";
}

/** Attachment metadata for test attachments from LogStore. */
model TestLogStoreAttachment {
  /** Attachment type. */
  @extension(
    "x-ms-enum",
    #{
      name: "AttachmentType",
      values: #[
        #{
          value: "generalAttachment",
          description: "Attachment type GeneralAttachment , use this as default type unless you have other type.",
        },
        #{ value: "codeCoverage", description: "Attachment type CodeCoverage." },
        #{ value: "consoleLog", description: "Attachment type ConsoleLog." }
      ],
    }
  )
  attachmentType?: "generalAttachment" | "codeCoverage" | "consoleLog";

  /** Comment associated with attachment. */
  comment?: string;

  /** Attachment created date. */
  createdDate?: utcDateTime;

  /** Attachment file name. */
  fileName?: string;

  /** Attachment size. */
  size?: int64;

  /** Attachment Url. */
  url?: string;
}

/** Reference to test attachment. */
model TestLogStoreAttachmentReference {
  /** Url to download the attachment. */
  url?: string;
}

/** Represents Test Log store endpoint details. */
model TestLogStoreEndpointDetails {
  /** Test log store connection Uri. */
  endpointSASUri?: string;

  /** Test log store endpoint type. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestLogStoreEndpointType",
      values: #[
        #{ value: "root", description: "Endpoint type is scoped to root" },
        #{ value: "file", description: "Endpoint type is scoped to file" }
      ],
    }
  )
  endpointType?: "root" | "file";

  /** Test log store status code */
  @extension(
    "x-ms-enum",
    #{
      name: "TestLogStatusCode",
      values: #[
        #{ value: "success", description: "Operation is successful" },
        #{ value: "failed", description: "Operation failed" },
        #{ value: "fileAlreadyExists", description: "Operation failed due to file already exist" },
        #{ value: "invalidInput", description: "Invalid input provided by user" },
        #{ value: "invalidFileName", description: "Invalid file name provided by user" },
        #{ value: "invalidContainer", description: "Error occurred while operating on container" },
        #{ value: "transferFailed", description: "Blob Transfer Error" },
        #{ value: "featureDisabled", description: "TestLogStore feature is not enabled" },
        #{
          value: "buildDoesNotExist",
          description: "Build for which operation is requested does not exist",
        },
        #{
          value: "runDoesNotExist",
          description: "Run for which operation is requested does not exist",
        },
        #{ value: "containerNotCreated", description: "Container cannot be created" },
        #{ value: "apiNotSupported", description: "Api is not supported" },
        #{ value: "fileSizeExceeds", description: "File size is greater than the limitation" },
        #{
          value: "containerNotFound",
          description: "Container is not found for which operation is requested",
        },
        #{ value: "fileNotFound", description: "File cannot be found" },
        #{ value: "directoryNotFound", description: "Directory cannot be found" },
        #{ value: "storageCapacityExceeded", description: "Storage capacity exceeded" }
      ],
    }
  )
  status?:
    | "success"
    | "failed"
    | "fileAlreadyExists"
    | "invalidInput"
    | "invalidFileName"
    | "invalidContainer"
    | "transferFailed"
    | "featureDisabled"
    | "buildDoesNotExist"
    | "runDoesNotExist"
    | "containerNotCreated"
    | "apiNotSupported"
    | "fileSizeExceeds"
    | "containerNotFound"
    | "fileNotFound"
    | "directoryNotFound"
    | "storageCapacityExceeded";
}

/** An abstracted reference to some other resource. This class is used to provide the build data contracts with a uniform way to reference other resources in a way that provides easy traversal through links. */
model TestMessageLogDetails {
  /** Date when the resource is created */
  dateCreated?: utcDateTime;

  /** Id of the resource */
  entryId?: int32;

  /** Message of the resource */
  message?: string;
}

model TestMethod {
  container?: string;
  name?: string;
  testResult?: TestCaseResult;
}

/** Class representing a reference to an operation. */
model TestOperationReference {
  id?: string;
  status?: string;
  url?: string;
}

/** Test Resolution State Details. */
model TestResolutionState {
  /** Test Resolution state Id. */
  id?: int32;

  /** Test Resolution State Name. */
  name?: string;

  project?: ShallowReference;
}

/** Represents dimensions */
model TestResultDimension {
  /** Test Result Dimension Name */
  name?: string;

  /** Test Result Dimension Value */
  value?: string;
}

model TestResultDocument {
  operationReference?: TestOperationReference;
  payload?: TestResultPayload;
}

model TestResultFailuresAnalysis {
  existingFailures?: TestFailureDetails;
  fixedTests?: TestFailureDetails;
  newFailures?: TestFailureDetails;
}

/** The test failure type resource */
model TestResultFailureType {
  /** ID of the test failure type */
  id?: int32;

  /** Name of the test failure type */
  name?: string;
}

/** The test failure type request model */
model TestResultFailureTypeRequestModel {
  /** Name of the test failure type */
  name?: string;
}

model TestResultHistory {
  groupByField?: string;
  resultsForGroup?: TestResultHistoryDetailsForGroup[];
}

model TestResultHistoryDetailsForGroup {
  groupByValue?: {};
  latestResult?: TestCaseResult;
}

/** List of test results filtered on the basis of GroupByValue */
model TestResultHistoryForGroup {
  /** Display name of the group. */
  displayName?: string;

  /** Name or Id of the group identifier by which results are grouped together. */
  groupByValue?: string;

  /** List of results for GroupByValue */
  results?: TestCaseResult[];
}

/** Class to capture logs associated with a TestResultMachine */
model TestResultLog {
  /** FileType of the log being attached to a TestResultMachine Valid values : AutomationLogFile, Screenshot, LogFolder, Other */
  fileType?: string;

  /** Path to the log file. Max length: 300 characters */
  path?: string;

  /** Type of the path for the log Valid values : AzureBlobStorage, UNC, URI */
  type?: string;
}

/** Class to map TestCaseResult to Machine objects the test ran on */
model TestResultMachine {
  configurationName?: string;
  isReportingMachine?: boolean;
  machineName?: string;
  processorArchitecture?: string;
  properties?: Record<{}>;
  sessionMachineInstanceId?: int64;
  testResultId?: int32;
  testResultLogs?: TestResultLog[];
}

/** Represents a Meta Data of a test result. */
model TestResultMetaData {
  /** AutomatedTestName of test result. */
  automatedTestName?: string;

  /** AutomatedTestStorage of test result. */
  automatedTestStorage?: string;

  /** List of Flaky Identifier for TestCaseReferenceId */
  flakyIdentifiers?: TestFlakyIdentifier[];

  /** Owner of test result. */
  owner?: string;

  /** Priority of test result. */
  priority?: int32;

  /** ID of TestCaseReference. */
  testCaseReferenceId?: int32;

  /** TestCaseTitle of test result. */
  testCaseTitle?: string;
}

/** Represents a TestResultMetaData Input */
model TestResultMetaDataUpdateInput {
  /** List of Flaky Identifiers */
  flakyIdentifiers?: TestFlakyIdentifier[];
}

model TestResultModelBase {
  /** Comment in result. */
  comment?: string;

  /** Time when execution completed(UTC). */
  completedDate?: utcDateTime;

  /** Duration of execution. */
  durationInMs?: float64;

  /** Error message in result. */
  errorMessage?: string;

  /** Test outcome of result. */
  outcome?: string;

  /** Time when execution started(UTC). */
  startedDate?: utcDateTime;
}

/** Test parameter information in a test iteration. */
model TestResultParameterModel {
  /** Test step path where parameter is referenced. */
  actionPath?: string;

  /** Iteration ID. */
  iterationId?: int32;

  /** Name of parameter. */
  parameterName?: string;

  /** This is step Id of test case. For shared step, it is step Id of shared step in test case workitem; step Id in shared step. Example: TestCase workitem has two steps: 1) Normal step with Id = 1 2) Shared Step with Id = 2. Inside shared step: a) Normal Step with Id = 1 Value for StepIdentifier for First step: '1' Second step: '2;1' */
  stepIdentifier?: string;

  /** Url of test parameter. Deprecated in hosted environment. */
  url?: string;

  /** Value of parameter. */
  value?: string;
}

model TestResultPayload {
  comment?: string;
  name?: string;
  stream?: string;
}

model TestResultsContext {
  build?: BuildReference;
  @extension(
    "x-ms-enum",
    #{
      name: "TestResultsContextType",
      values: #[
        #{ value: "build", description: "" },
        #{ value: "release", description: "" },
        #{ value: "pipeline", description: "" }
      ],
    }
  )
  contextType?: "build" | "release" | "pipeline";
  pipelineReference?: PipelineReference;
  release?: ReleaseReference;
}

model TestResultsDetails {
  groupByField?: string;
  resultsForGroup?: TestResultsDetailsForGroup[];
}

model TestResultsDetailsForGroup {
  groupByValue?: {};
  results?: TestCaseResult[];
  resultsCountByOutcome?: Record<AggregatedResultsByOutcome>;
  tags?: string[];
}

model TestResultsQuery {
  fields?: string[];
  results?: TestCaseResult[];
  resultsFilter?: ResultsFilter;
}

/** The TestResultSession is a higher-level container for test results by encapsulating multiple TestRun objects */
model TestResultsSession {
  /** TestResultsSession end time */
  endTimeUTC?: utcDateTime;

  /** Id of TestResultsSession */
  id?: int64;

  /** TestResultsSession layout */
  layout?: Layout[];

  /** TestResultsSession name */
  name?: string;

  /** TestResultsSession result */
  @extension(
    "x-ms-enum",
    #{
      name: "SessionResult",
      values: #[
        #{ value: "none", description: "Default" },
        #{ value: "passed", description: "Session result with Passed" },
        #{ value: "failed", description: "Session result with Failed" },
        #{ value: "pending", description: "Session result still Pending" }
      ],
    }
  )
  result?: "none" | "passed" | "failed" | "pending";

  sessionSourcePipeline?: SessionSourcePipeline;
  source?: Source;

  /** TestResultsSession start time */
  startTimeUTC?: utcDateTime;

  /** TestResultsSession state */
  @extension(
    "x-ms-enum",
    #{
      name: "TestResultsSessionState",
      values: #[
        #{ value: "none", description: "Default" },
        #{ value: "running", description: "Session state with Running" },
        #{ value: "completed", description: "Session state with Completed" },
        #{ value: "waiting", description: "Session state with Waiting" },
        #{ value: "cancelled", description: "Session state with Cancelled" }
      ],
    }
  )
  state?: "none" | "running" | "completed" | "waiting" | "cancelled";

  /** List of test run ids */
  testRuns?: int32[];

  /** TestResultsSession timeline Valid values for 'type' property = (Queued, Completed, Started) */
  timeline?: Timeline[];

  /** TestResultsSession type */
  type?: string;

  /** TestResultsSession Uid */
  @format("uuid") uid?: string;
}

model TestResultsSettings {
  advancedFlakyDetectionSettings?: AdvancedFlakyDetectionSettings;
  flakySettings?: FlakySettings;
  newTestResultLoggingSettings?: NewTestResultLoggingSettings;
}

model TestResultSummary {
  aggregatedResultsAnalysis?: AggregatedResultsAnalysis;
  noConfigRunsCount?: int32;
  teamProject?: TeamProjectReference;
  testFailures?: TestFailuresAnalysis;
  testResultsContext?: TestResultsContext;
  totalRunsCount?: int32;
}

model TestResultsUpdateSettings {
  advancedFlakyDetectionSettings?: AdvancedFlakyDetectionSettings;
  flakySettings?: FlakySettings;
  newTestResultLoggingSettings?: NewTestResultLoggingSettings;
}

model TestResultTrendFilter {
  branchNames?: string[];
  buildCount?: int32;
  definitionIds?: int32[];
  envDefinitionIds?: int32[];
  maxCompleteDate?: utcDateTime;
  publishContext?: string;
  testRunTitles?: string[];
  trendDays?: int32;
}

/** Test run details. */
model TestRun {
  build?: ShallowReference;
  buildConfiguration?: BuildConfiguration;

  /** Comments entered by those analyzing the run. */
  comment?: string;

  /** Completed date time of the run. */
  completedDate?: utcDateTime;

  /** Test Run Controller. */
  controller?: string;

  /** Test Run CreatedDate. */
  createdDate?: utcDateTime;

  /** List of Custom Fields for TestRun. */
  customFields?: CustomTestField[];

  /** Drop Location for the test Run. */
  dropLocation?: string;

  dtlAutEnvironment?: ShallowReference;
  dtlEnvironment?: ShallowReference;
  dtlEnvironmentCreationDetails?: DtlEnvironmentDetails;

  /** Due date and time for test run. */
  dueDate?: utcDateTime;

  /** Error message associated with the run. */
  errorMessage?: string;

  filter?: RunFilter;

  /** ID of the test run. */
  id?: int32;

  /** Number of Incomplete Tests. */
  incompleteTests?: int32;

  /** true if test run is automated, false otherwise. */
  isAutomated?: boolean;

  /** The iteration to which the run belongs. */
  iteration?: string;

  lastUpdatedBy?: IdentityRef;

  /** Last updated date and time */
  lastUpdatedDate?: utcDateTime;

  /** Name of the test run. */
  name?: string;

  /** Number of Not Applicable Tests. */
  notApplicableTests?: int32;

  owner?: IdentityRef;

  /** Number of passed tests in the run */
  passedTests?: int32;

  /** Phase/State for the testRun. */
  phase?: string;

  pipelineReference?: PipelineReference;
  plan?: ShallowReference;

  /** Post Process State. */
  postProcessState?: string;

  project?: ShallowReference;
  release?: ReleaseReference;

  /** Release Environment Uri for TestRun. */
  releaseEnvironmentUri?: string;

  /** Release Uri for TestRun. */
  releaseUri?: string;

  revision?: int32;

  /** RunSummary by outcome. */
  runStatistics?: RunStatistic[];

  /** Start date time of the run. */
  startedDate?: utcDateTime;

  /** The state of the run. Type TestRunState Valid states - Unspecified ,NotStarted, InProgress, Completed, Waiting, Aborted, NeedsInvestigation */
  state?: string;

  /** TestRun Substate. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestRunSubstate",
      values: #[
        #{ value: "none", description: "Run with noState." },
        #{ value: "creatingEnvironment", description: "Run state while Creating Environment." },
        #{ value: "runningTests", description: "Run state while Running Tests." },
        #{ value: "canceledByUser", description: "Run state while Creating Environment." },
        #{ value: "abortedBySystem", description: "Run state when it is Aborted By the System." },
        #{ value: "timedOut", description: "Run state when run has timedOut." },
        #{ value: "pendingAnalysis", description: "Run state while Pending Analysis." },
        #{ value: "analyzed", description: "Run state after being Analysed." },
        #{
          value: "cancellationInProgress",
          description: "Run state when cancellation is in Progress.",
        }
      ],
    }
  )
  substate?:
    | "none"
    | "creatingEnvironment"
    | "runningTests"
    | "canceledByUser"
    | "abortedBySystem"
    | "timedOut"
    | "pendingAnalysis"
    | "analyzed"
    | "cancellationInProgress";

  /** Tags attached with this test run. */
  tags?: TestTag[];

  testEnvironment?: TestEnvironment;
  testMessageLogId?: int32;
  testSettings?: ShallowReference;

  /** Total tests in the run */
  totalTests?: int32;

  /** Number of failed tests in the run. */
  unanalyzedTests?: int32;

  /** Url of the test run */
  url?: string;

  /** Web Access Url for TestRun. */
  webAccessUrl?: string;
}

/** Test Run Code Coverage Details */
model TestRunCoverage {
  /** Last Error */
  lastError?: string;

  /** List of Modules Coverage */
  modules?: ModuleCoverage[];

  /** State */
  state?: string;

  testRun?: ShallowReference;
}

/** Test run statistics. */
model TestRunStatistic {
  run?: ShallowReference;
  runStatistics?: RunStatistic[];
}

/** Test session anaylsis */
model TestSessionAnalysis {
  /** session analysis engine */
  analysisEngine?: string;

  /** analysis failure groups */
  analysisFailureGroups?: TestAnalysisFailureGroup[];

  /** session analysis type */
  analysisType?: string;
}

/** Test session environment */
model TestSessionEnvironment {
  /** Environment display name */
  displayName?: string;

  /** Processor architecture */
  processorArchitecture?: string;

  /** Uid of environment */
  @format("uuid") uid?: string;
}

/** Notifications for the TestResults Session */
model TestSessionNotification {
  /** Notification Body */
  body?: string;

  /** Notification Severity Valid values = (Informational, Warning, Error, Critical) */
  severity?: string;

  /** Notification Title */
  title?: string;
}

/** Notifications for the Test Session Test Run */
model TestSessionTestRun {
  /** Set of testRunIds for a test Session */
  testRuns?: int32[];
}

/** Represents the test settings of the run. Used to create test settings and fetch test settings */
model TestSettings {
  /** Area path required to create test settings */
  areaPath?: string;

  /** Description of the test settings. Used in create test settings. */
  description?: string;

  /** Indicates if the tests settings is public or private.Used in create test settings. */
  isPublic?: boolean;

  /** Xml string of machine roles. Used in create test settings. */
  machineRoles?: string;

  /** Test settings content. */
  testSettingsContent?: string;

  /** Test settings id. */
  testSettingsId?: int32;

  /** Test settings name. */
  testSettingsName?: string;
}

/** Represents a sub result of a test result. */
model TestSubResult {
  /** Comment in sub result. */
  comment?: string;

  /** Time when test execution completed(UTC). */
  completedDate?: utcDateTime;

  /** Machine where test executed. */
  computerName?: string;

  configuration?: ShallowReference;

  /** Additional properties of sub result. */
  customFields?: CustomTestField[];

  /** Name of sub result. */
  displayName?: string;

  /** Duration of test execution. */
  durationInMs?: int64;

  /** Error message in sub result. */
  errorMessage?: string;

  /** ID of sub result. */
  id?: int32;

  /** Time when result last updated(UTC). */
  lastUpdatedDate?: utcDateTime;

  /** Outcome of sub result. */
  outcome?: string;

  /** Immediate parent ID of sub result. */
  parentId?: int32;

  /** Hierarchy type of the result, default value of None means its leaf node. */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultGroupType",
      values: #[
        #{ value: "none", description: "Leaf node of test result." },
        #{ value: "rerun", description: "Hierarchy type of test result." },
        #{ value: "dataDriven", description: "Hierarchy type of test result." },
        #{ value: "orderedTest", description: "Hierarchy type of test result." },
        #{ value: "generic", description: "Unknown hierarchy type." }
      ],
    }
  )
  resultGroupType?: "none" | "rerun" | "dataDriven" | "orderedTest" | "generic";

  /** Index number of sub result. */
  sequenceId?: int32;

  /** Stacktrace. */
  stackTrace?: string;

  /** Time when test execution started(UTC). */
  startedDate?: utcDateTime;

  /** List of sub results inside a sub result, if ResultGroupType is not None, it holds corresponding type sub results. */
  subResults?: TestSubResult[];

  testResult?: TestCaseResultIdentifier;

  /** Url of sub result. */
  url?: string;
}

model TestSummaryForWorkItem {
  summary?: AggregatedDataForResultTrend;
  workItem?: WorkItemReference;
}

/** Tag attached to a run or result. */
model TestTag {
  /** Name of the tag, alphanumeric value less than 30 chars */
  name?: string;
}

/** Test tag summary for build or release grouped by test run. */
model TestTagSummary {
  /** Dictionary which contains tags associated with a test run. */
  tagsGroupByTestArtifact?: Record<TestTag[]>;
}

/** Tags to update to a run or result. */
model TestTagsUpdateModel {
  tags?: {}[];
}

model TestToWorkItemLinks {
  test?: TestMethod;
  workItems?: WorkItemReference[];
}

/** Timeline */
model Timeline {
  /** Timeline display name */
  display?: string;

  /** Timeline timestamp */
  timestampUTC?: utcDateTime;

  /** Timeline type */
  type?: string;
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

/** WorkItem reference Details. */
model WorkItemReference {
  /** WorkItem Id. */
  id?: string;

  /** WorkItem Name. */
  name?: string;

  /** WorkItem Type. */
  type?: string;

  /** WorkItem Url. Valid Values : (Bug, Task, User Story, Test Case) */
  url?: string;

  /** WorkItem WebUrl. */
  webUrl?: string;
}

model WorkItemToTestLinks {
  @extension(
    "x-ms-enum",
    #{
      name: "Service",
      values: #[
        #{ value: "any", description: "" },
        #{ value: "tcm", description: "" },
        #{ value: "tfs", description: "" }
      ],
    }
  )
  executedIn?: "any" | "tcm" | "tfs";
  tests?: TestMethod[];
  workItem?: WorkItemReference;
}

/** A collection of `SourceViewBuildCoverage` as returned by Azure DevOps. */
model SourceViewBuildCoverageList {
  count?: int32;
  value?: SourceViewBuildCoverage[];
}

/** A collection of `CustomTestFieldDefinition` as returned by Azure DevOps. */
model CustomTestFieldDefinitionList {
  count?: int32;
  value?: CustomTestFieldDefinition[];
}

/** A collection of `FieldDetailsForTestResults` as returned by Azure DevOps. */
model FieldDetailsForTestResultsList {
  count?: int32;
  value?: FieldDetailsForTestResults[];
}

/** A collection of `TestCaseResult` as returned by Azure DevOps. */
model TestCaseResultList {
  count?: int32;
  value?: TestCaseResult[];
}

/** A collection of `TestResultMetaData` as returned by Azure DevOps. */
model TestResultMetaDataList {
  count?: int32;
  value?: TestResultMetaData[];
}

/** A collection of `WorkItemReference` as returned by Azure DevOps. */
model WorkItemReferenceList {
  count?: int32;
  value?: WorkItemReference[];
}

/** A collection of `ShallowTestCaseResult` as returned by Azure DevOps. */
model ShallowTestCaseResultList {
  count?: int32;
  value?: ShallowTestCaseResult[];
}

/** A collection of `TestResultSummary` as returned by Azure DevOps. */
model TestResultSummaryList {
  count?: int32;
  value?: TestResultSummary[];
}

/** A collection of `TestSummaryForWorkItem` as returned by Azure DevOps. */
model TestSummaryForWorkItemList {
  count?: int32;
  value?: TestSummaryForWorkItem[];
}

/** A collection of `AggregatedDataForResultTrend` as returned by Azure DevOps. */
model AggregatedDataForResultTrendList {
  count?: int32;
  value?: AggregatedDataForResultTrend[];
}

/** A collection of `TestRun` as returned by Azure DevOps. */
model TestRunList {
  count?: int32;
  value?: TestRun[];
}

/** A collection of `TestAttachment` as returned by Azure DevOps. */
model TestAttachmentList {
  count?: int32;
  value?: TestAttachment[];
}

/** A collection of `TestRunCoverage` as returned by Azure DevOps. */
model TestRunCoverageList {
  count?: int32;
  value?: TestRunCoverage[];
}

/** A collection of `TestMessageLogDetails` as returned by Azure DevOps. */
model TestMessageLogDetailsList {
  count?: int32;
  value?: TestMessageLogDetails[];
}

/** A collection of `TestLog` as returned by Azure DevOps. */
model TestLogList {
  count?: int32;
  value?: TestLog[];
}

/** A collection of `TestTag` as returned by Azure DevOps. */
model TestTagList {
  count?: int32;
  value?: TestTag[];
}

/** A collection of `TestLogStoreAttachment` as returned by Azure DevOps. */
model TestLogStoreAttachmentList {
  count?: int32;
  value?: TestLogStoreAttachment[];
}

/** A collection of `TestResultFailureType` as returned by Azure DevOps. */
model TestResultFailureTypeList {
  count?: int32;
  value?: TestResultFailureType[];
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
    model `4` {
      /** Version of the API to use. This should be set to '7.2-preview.4' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
    model `7` {
      /** Version of the API to use. This should be set to '7.2-preview.7' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Codecoverage {
  /** http://(tfsserver):8080/tfs/DefaultCollection/_apis/test/CodeCoverage?buildId=10&deltaBuildId=9 Request: build id and delta build id (optional) */
  @tag("Codecoverage")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "codecoverage")
  @extension("x-ms-vss-method", "GetCodeCoverageSummary")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/codecoverage")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    @query(#{ explode: true }) deltaBuildId?: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): CodeCoverageSummary;

  /** http://(tfsserver):8080/tfs/DefaultCollection/_apis/test/CodeCoverage?buildId=10 Request: Json of code coverage summary */
  @tag("Codecoverage")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "codecoverage")
  @extension("x-ms-vss-method", "UpdateCodeCoverageSummary")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/codecoverage")
  @post
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: CodeCoverageData,
  ): OkResponse;

  @tag("Codecoverage")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "codecoverage")
  @extension("x-ms-vss-method", "FetchSourceCodeCoverageReport")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/codecoverage/sourceview")
  @get
  FetchSourceCodeCoverageReport(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): SourceViewBuildCoverageList;

  @tag("Codecoverage")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "codecoverage")
  @extension("x-ms-vss-method", "GetTestRunCodeCoverage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/codecoverage")
  @get
  GetTestRunCodeCoverage(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @query(#{ explode: true }) flags: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestRunCoverageList;
}

interface Filecoverage {
  /** Get file coverage for the specified file */
  @tag("Filecoverage")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "filecoverage")
  @extension("x-ms-vss-method", "GetFileLevelCodeCoverage")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/codecoverage/filecoverage")
  @post
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** File details with pull request iteration context */
    @body body: FileCoverageRequest,
  ): {
    @header contentType: "text/plain";
    @body @format("Stream") body: string;
  };
}

interface Status {
  /** <p>Gets the coverage status for the last successful build of a definition, optionally scoped to a specific branch</p> */
  @tag("Status")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "status")
  @extension("x-ms-vss-method", "GetCoverageStatusBadge")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/codecoverage/status/{definition}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID or name of the definition. */
    @path definition: string,

    /** The branch name. */
    @query(#{ explode: true }) branchName?: string,

    /** The String to replace the default text on the left side of the badge. */
    @query(#{ explode: true }) label?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<string>;
}

interface Extensionfields {
  /** Returns List of custom test fields for the given custom test field scope. */
  @tag("Extensionfields")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "extensionfields")
  @extension("x-ms-vss-method", "QueryCustomFields")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/extensionfields")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Scope of custom test fields which are to be returned. */
    @extension(
      "x-ms-enum",
      #{
        name: "CustomTestFieldScope",
        values: #[
          #{ value: "none", description: "" },
          #{ value: "testRun", description: "Custom field can be used with TestRun artifact." },
          #{
            value: "testResult",
            description: "Custom field can be used with TestResult artifact.",
          },
          #{
            value: "testRunAndTestResult",
            description: "Custom test field can be used with either TestRun or TestResult artifact.",
          },
          #{
            value: "system",
            description: "Reserved for internal Azure DevOps functionality. Not to be used.",
          },
          #{ value: "all", description: "" }
        ],
      }
    )
    @query(#{ explode: true })
    scopeFilter: "none" | "testRun" | "testResult" | "testRunAndTestResult" | "system" | "all",

    ...Parameters.`api-Version-preview`.`1`,
  ): CustomTestFieldDefinitionList;

  /** Returns details of the custom test field which is updated. */
  @tag("Extensionfields")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "extensionfields")
  @extension("x-ms-vss-method", "UpdateCustomField")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/extensionfields")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Custom test field which has to be updated. */
    @body body: CustomTestFieldUpdateDefinition,
  ): CustomTestFieldDefinition;

  /** Creates custom test fields based on the data provided. */
  @tag("Extensionfields")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "extensionfields")
  @extension("x-ms-vss-method", "AddCustomFields")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/extensionfields")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** NewFields is an array of type CustomTestFieldDefinition. */
    @body body: CustomTestFieldDefinition[],
  ): CustomTestFieldDefinitionList;

  /** Returns details of the custom test field for the specified testExtensionFieldId. */
  @tag("Extensionfields")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "extensionfields")
  @extension("x-ms-vss-method", "DeleteCustomFieldById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/extensionfields/{testExtensionFieldId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Custom test field id which has to be deleted. */
    @path testExtensionFieldId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface Metrics {
  /** Get summary of test results. */
  @tag("Metrics")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "metrics")
  @extension("x-ms-vss-method", "GetTestPipelineMetrics")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/metrics")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Pipeline Id. This is same as build Id. */
    @query(#{ explode: true }) pipelineId: int32,

    /** Name of the stage. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) stageName?: string,

    /** Name of the phase. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) phaseName?: string,

    /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) jobName?: string,

    @format("array (Metrics)") @query(#{ explode: true }) metricNames?: string,

    /** Group summary for each node of the pipleine heirarchy */
    @query(#{ explode: true }) groupByNode?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): PipelineTestMetrics;
}

interface Resultdetailsbybuild {
  @tag("Resultdetailsbybuild")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultdetailsbybuild")
  @extension("x-ms-vss-method", "GetTestResultDetailsForBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultdetailsbybuild")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    @query(#{ explode: true }) publishContext?: string,
    @query(#{ explode: true }) groupBy?: string,
    @query(#{ explode: true }) $filter?: string,
    @query(#{ explode: true }) $orderby?: string,
    @query(#{ explode: true }) shouldIncludeResults?: boolean,
    @query(#{ explode: true }) queryRunSummaryForInProgress?: boolean,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultsDetails;
}

interface Resultdetailsbyrelease {
  @tag("Resultdetailsbyrelease")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultdetailsbyrelease")
  @extension("x-ms-vss-method", "GetTestResultDetailsForRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultdetailsbyrelease")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) releaseId: int32,
    @query(#{ explode: true }) releaseEnvId: int32,
    @query(#{ explode: true }) publishContext?: string,
    @query(#{ explode: true }) groupBy?: string,
    @query(#{ explode: true }) $filter?: string,
    @query(#{ explode: true }) $orderby?: string,
    @query(#{ explode: true }) shouldIncludeResults?: boolean,
    @query(#{ explode: true }) queryRunSummaryForInProgress?: boolean,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultsDetails;
}

interface Resultgroupsbybuild {
  @tag("Resultgroupsbybuild")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultgroupsbybuild")
  @extension("x-ms-vss-method", "GetResultGroupsByBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultgroupsbybuild")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    @query(#{ explode: true }) publishContext: string,
    @format("array (string)") @query(#{ explode: true }) fields?: string,
    @query(#{ explode: true }) continuationToken?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: FieldDetailsForTestResultsList;
  };
}

interface Resultgroupsbyrelease {
  @tag("Resultgroupsbyrelease")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultgroupsbyrelease")
  @extension("x-ms-vss-method", "GetResultGroupsByRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultgroupsbyrelease")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) releaseId: int32,
    @query(#{ explode: true }) publishContext: string,
    @query(#{ explode: true }) releaseEnvId?: int32,
    @format("array (string)") @query(#{ explode: true }) fields?: string,
    @query(#{ explode: true }) continuationToken?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: FieldDetailsForTestResultsList;
  };
}

interface Results {
  @tag("Results")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "results")
  @extension("x-ms-vss-method", "GetTestResultsByQuery")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results")
  @post
  GetTestResultsByQuery(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: TestResultsQuery,
  ): TestResultsQuery;

  @tag("Results")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "results")
  @extension("x-ms-vss-method", "GetTestResultsByQueryWiql")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results/query")
  @post
  GetTestResultsByQueryWiql(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) includeResultDetails?: boolean,
    @query(#{ explode: true }) includeIterationDetails?: boolean,
    @query(#{ explode: true }) $skip?: int32,
    @query(#{ explode: true }) $top?: int32,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: QueryModel,
  ): TestCaseResultList;

  @tag("Results")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "results")
  @extension("x-ms-vss-method", "GetTestResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results")
  @get
  GetTestResults(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @extension(
      "x-ms-enum",
      #{
        name: "ResultDetails",
        values: #[
          #{
            value: "none",
            description: "Core fields of test result. Core fields includes State, Outcome, Priority, AutomatedTestName, AutomatedTestStorage, Comments, ErrorMessage etc.",
          },
          #{ value: "iterations", description: "Test iteration details in a test result." },
          #{ value: "workItems", description: "Workitems associated with a test result." },
          #{ value: "subResults", description: "Subresults in a test result." },
          #{ value: "point", description: "Point and plan detail in a test result." }
        ],
      }
    )
    @query(#{ explode: true })
    detailsToInclude?: "none" | "iterations" | "workItems" | "subResults" | "point",
    @query(#{ explode: true }) $skip?: int32,
    @query(#{ explode: true }) $top?: int32,
    @format("array (TestOutcome)") @query(#{ explode: true }) outcomes?: string,
    @query(#{ explode: true }) $newTestsOnly?: boolean,
    ...Parameters.`api-Version-preview`.`2`,
  ): TestCaseResultList;

  @tag("Results")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "results")
  @extension("x-ms-vss-method", "UpdateTestResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: TestCaseResult[],
  ): TestCaseResultList;

  @tag("Results")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "results")
  @extension("x-ms-vss-method", "AddTestResultsToTestRun")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`2`,
    @body body: TestCaseResult[],
  ): TestCaseResultList;

  @tag("Results")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "results")
  @extension("x-ms-vss-method", "GetTestResultById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testResultId}")
  @get
  GetTestResultById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testResultId: int32,
    @extension(
      "x-ms-enum",
      #{
        name: "ResultDetails",
        values: #[
          #{
            value: "none",
            description: "Core fields of test result. Core fields includes State, Outcome, Priority, AutomatedTestName, AutomatedTestStorage, Comments, ErrorMessage etc.",
          },
          #{ value: "iterations", description: "Test iteration details in a test result." },
          #{ value: "workItems", description: "Workitems associated with a test result." },
          #{ value: "subResults", description: "Subresults in a test result." },
          #{ value: "point", description: "Point and plan detail in a test result." }
        ],
      }
    )
    @query(#{ explode: true })
    detailsToInclude?: "none" | "iterations" | "workItems" | "subResults" | "point",
    ...Parameters.`api-Version-preview`.`2`,
  ): TestCaseResult;
}

interface History {
  @tag("History")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "history")
  @extension("x-ms-vss-method", "QueryTestResultHistory")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results/history")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: ResultsFilter,
  ): TestResultHistory;
}

interface ResultMetaData {
  /** Get list of test Result meta data details for corresponding testcasereferenceId */
  @tag("Result Meta Data")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "resultMetaData")
  @extension("x-ms-vss-method", "QueryTestResultsMetaData")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results/resultmetadata")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Details to include with test results metadata. Default is None. Other values are FlakyIdentifiers. */
    @extension(
      "x-ms-enum",
      #{
        name: "ResultMetaDataDetails",
        values: #[
          #{ value: "none", description: "Core fields of test result metadata." },
          #{
            value: "flakyIdentifiers",
            description: "Test FlakyIdentifiers details in test result metadata.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    detailsToInclude?: "none" | "flakyIdentifiers",

    ...Parameters.`api-Version-preview`.`4`,

    /** TestCaseReference Ids of the test Result to be queried, comma separated list of valid ids (limit no. of ids 200). */
    @body body: string[],
  ): TestResultMetaDataList;

  /** Update properties of test result meta data */
  @tag("Result Meta Data")
  @extension("x-ms-docs-override-version", "7.2-preview.4")
  @extension("x-ms-vss-resource", "resultMetaData")
  @extension("x-ms-vss-method", "UpdateTestResultsMetaData")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results/resultmetadata/{testCaseReferenceId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** TestCaseReference Id of Test Result to be updated. */
    @path testCaseReferenceId: int32,

    ...Parameters.`api-Version-preview`.`4`,

    /** TestResultMetaData update input TestResultMetaDataUpdateInput */
    @body body: TestResultMetaDataUpdateInput,
  ): TestResultMetaData;
}

interface TestHistory {
  /** Get history of a test method using TestHistoryQuery */
  @tag("Test History")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testHistory")
  @extension("x-ms-vss-method", "QueryTestHistory")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results/testhistory")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,

    /** TestHistoryQuery to get history */
    @body body: TestHistoryQuery,
  ): TestHistoryQuery;
}

interface Workitems {
  /** Query Test Result WorkItems based on filter */
  @tag("Workitems")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workitems")
  @extension("x-ms-vss-method", "QueryTestResultWorkItems")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/results/workitems")
  @get
  QueryTestResultWorkItems(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** can take values Microsoft.BugCategory or all(for getting all workitems) */
    @query(#{ explode: true }) workItemCategory: string,

    @query(#{ explode: true }) automatedTestName?: string,
    @query(#{ explode: true }) testCaseId?: int32,
    @query(#{ explode: true }) maxCompleteDate?: utcDateTime,
    @query(#{ explode: true }) days?: int32,
    @query(#{ explode: true }) $workItemCount?: int32,
    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemReferenceList;

  @tag("Workitems")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workitems")
  @extension("x-ms-vss-method", "GetTestResultWorkItemsById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testCaseResultId}/workitems")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testCaseResultId: int32,
    ...Parameters.`api-Version-preview`.`2`,
  ): WorkItemReferenceList;

  @tag("Workitems")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workitems")
  @extension("x-ms-vss-method", "DeleteTestMethodToWorkItemLink")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testmethods/workitems")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) testName: string,
    @query(#{ explode: true }) workItemId: int32,
    ...Parameters.`api-Version-preview`.`2`,
  ): Body<boolean>;

  @tag("Workitems")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "workitems")
  @extension("x-ms-vss-method", "AddWorkItemToTestLinks")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testmethods/workitems")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: WorkItemToTestLinks,
  ): WorkItemToTestLinks;
}

interface Resultsbybuild {
  @tag("Resultsbybuild")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsbybuild")
  @extension("x-ms-vss-method", "GetTestResultsByBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsbybuild")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    @query(#{ explode: true }) publishContext?: string,
    @format("array (TestOutcome)") @query(#{ explode: true }) outcomes?: string,
    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) continuationToken?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: ShallowTestCaseResultList;
  };
}

interface Resultsbypipeline {
  /** Get a list of results. */
  @tag("Resultsbypipeline")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsbypipeline")
  @extension("x-ms-vss-method", "GetTestResultsByPipeline")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsbypipeline")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Pipeline Id. This is same as build Id. */
    @query(#{ explode: true }) pipelineId: int32,

    /** Name of the stage. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) stageName?: string,

    /** Name of the phase. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) phaseName?: string,

    /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) jobName?: string,

    /** List of outcome of results */
    @format("array (TestOutcome)") @query(#{ explode: true }) outcomes?: string,

    /** Whether to include Test Runs from from all the build runs or not. */
    @query(#{ explode: true }) includeAllBuildRuns?: boolean,

    /** Maximum number of results to return */
    @query(#{ explode: true }) $top?: int32,

    /** Header to pass the continuationToken */
    @header continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): ShallowTestCaseResultList;
}

interface Resultsbyrelease {
  @tag("Resultsbyrelease")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsbyrelease")
  @extension("x-ms-vss-method", "GetTestResultsByRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsbyrelease")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) releaseId: int32,
    @query(#{ explode: true }) releaseEnvid?: int32,
    @query(#{ explode: true }) publishContext?: string,
    @format("array (TestOutcome)") @query(#{ explode: true }) outcomes?: string,
    @query(#{ explode: true }) $top?: int32,
    @query(#{ explode: true }) continuationToken?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: ShallowTestCaseResultList;
  };
}

interface ResultsgroupDetails {
  /** Get all the available groups details and for these groups get failed and aborted results. */
  @tag("Resultsgroup Details")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsgroupDetails")
  @extension("x-ms-vss-method", "TestResultsGroupDetails")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsgroupdetails")
  @get
  TestResultsGroupDetails(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Pipeline Id. This is same as build Id. */
    @query(#{ explode: true }) pipelineId: int32,

    /** Name of the stage. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) stageName?: string,

    /** Name of the phase. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) phaseName?: string,

    /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) jobName?: string,

    /** If true, it will return Ids of failed and aborted results for each test group */
    @query(#{ explode: true }) shouldIncludeFailedAndAbortedResults?: boolean,

    /** If true, it will calculate summary for InProgress runs as well. */
    @query(#{ explode: true }) queryGroupSummaryForInProgress?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultsDetails;
}

interface Resultsummarybybuild {
  @tag("Resultsummarybybuild")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsummarybybuild")
  @extension("x-ms-vss-method", "QueryTestResultsReportForBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsummarybybuild")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildId: int32,
    @query(#{ explode: true }) publishContext?: string,
    @query(#{ explode: true }) includeFailureDetails?: boolean,

    /** Branch name. */
    @query(#{ name: "buildToCompare.branchName", explode: true }) buildToCompareBranchName?: string,

    /** Build system. */
    @query(#{ name: "buildToCompare.buildSystem", explode: true }) buildToCompareBuildSystem?: string,

    /** Build Definition ID. */
    @query(#{ name: "buildToCompare.definitionId", explode: true }) buildToCompareDefinitionId?: int32,

    /** Build ID. */
    @query(#{ name: "buildToCompare.id", explode: true }) buildToCompareId?: int32,

    /** Build Number. */
    @query(#{ name: "buildToCompare.number", explode: true }) buildToCompareNumber?: string,

    /** Repository ID. */
    @query(#{ name: "buildToCompare.repositoryId", explode: true }) buildToCompareRepositoryId?: string,

    /** Build URI. */
    @query(#{ name: "buildToCompare.uri", explode: true }) buildToCompareUri?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultSummary;
}

interface Resultsummarybypipeline {
  /** Get summary of test results. */
  @tag("Resultsummarybypipeline")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsummarybypipeline")
  @extension("x-ms-vss-method", "QueryTestResultsReportForPipeline")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsummarybypipeline")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Pipeline Id. This is same as build Id. */
    @query(#{ explode: true }) pipelineId: int32,

    /** Name of the stage. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) stageName?: string,

    /** Name of the phase. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) phaseName?: string,

    /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
    @query(#{ explode: true }) jobName?: string,

    /** If true returns failure insights */
    @query(#{ explode: true }) includeFailureDetails?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultSummary;
}

interface Resultsummarybyrelease {
  @tag("Resultsummarybyrelease")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsummarybyrelease")
  @extension("x-ms-vss-method", "QueryTestResultsReportForRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsummarybyrelease")
  @get
  QueryTestResultsReportForRelease(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) releaseId: int32,
    @query(#{ explode: true }) releaseEnvId: int32,
    @query(#{ explode: true }) publishContext?: string,
    @query(#{ explode: true }) includeFailureDetails?: boolean,

    /** Number of Release Attempt. */
    @query(#{ name: "releaseToCompare.attempt", explode: true }) releaseToCompareAttempt?: int32,

    /** Release Creation Date(UTC). */
    @query(#{ name: "releaseToCompare.creationDate", explode: true }) releaseToCompareCreationDate?: utcDateTime,

    /** Release definition ID. */
    @query(#{ name: "releaseToCompare.definitionId", explode: true }) releaseToCompareDefinitionId?: int32,

    /** Environment creation Date(UTC). */
    @query(#{ name: "releaseToCompare.environmentCreationDate", explode: true }) releaseToCompareEnvironmentCreationDate?: utcDateTime,

    /** Release environment definition ID. */
    @query(#{ name: "releaseToCompare.environmentDefinitionId", explode: true }) releaseToCompareEnvironmentDefinitionId?: int32,

    /** Release environment definition name. */
    @query(#{ name: "releaseToCompare.environmentDefinitionName", explode: true }) releaseToCompareEnvironmentDefinitionName?: string,

    /** Release environment ID. */
    @query(#{ name: "releaseToCompare.environmentId", explode: true }) releaseToCompareEnvironmentId?: int32,

    /** Release environment name. */
    @query(#{ name: "releaseToCompare.environmentName", explode: true }) releaseToCompareEnvironmentName?: string,

    /** Release ID. */
    @query(#{ name: "releaseToCompare.id", explode: true }) releaseToCompareId?: int32,

    /** Release name. */
    @query(#{ name: "releaseToCompare.name", explode: true }) releaseToCompareName?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultSummary;

  @tag("Resultsummarybyrelease")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsummarybyrelease")
  @extension("x-ms-vss-method", "QueryTestResultsSummaryForReleases")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsummarybyrelease")
  @post
  QueryTestResultsSummaryForReleases(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: ReleaseReference[],
  ): TestResultSummaryList;
}

interface Resultsummarybyrequirement {
  @tag("Resultsummarybyrequirement")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultsummarybyrequirement")
  @extension("x-ms-vss-method", "QueryTestSummaryByRequirement")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resultsummarybyrequirement")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @format("array (int32)") @query(#{ explode: true }) workItemIds?: string,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestResultsContext,
  ): TestSummaryForWorkItemList;
}

interface ResultTrendByBuild {
  @tag("Result Trend By Build")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultTrendByBuild")
  @extension("x-ms-vss-method", "QueryResultTrendForBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resulttrendbybuild")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestResultTrendFilter,
  ): AggregatedDataForResultTrendList;
}

interface ResultTrendByRelease {
  @tag("Result Trend By Release")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultTrendByRelease")
  @extension("x-ms-vss-method", "QueryResultTrendForRelease")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/resulttrendbyrelease")
  @post
  Query(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestResultTrendFilter,
  ): AggregatedDataForResultTrendList;
}

interface Runs {
  @tag("Runs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "GetTestRuns")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) buildUri?: string,
    @query(#{ explode: true }) owner?: string,
    @query(#{ explode: true }) tmiRunId?: string,
    @query(#{ explode: true }) planId?: int32,
    @query(#{ explode: true }) includeRunDetails?: boolean,
    @query(#{ explode: true }) automated?: boolean,
    @query(#{ explode: true }) $skip?: int32,
    @query(#{ explode: true }) $top?: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestRunList;

  @tag("Runs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "CreateTestRun")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: RunCreateModel,
  ): TestRun;

  @tag("Runs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "DeleteTestRun")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  @tag("Runs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "GetTestRunById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @query(#{ explode: true }) includeDetails?: boolean,
    @query(#{ explode: true }) includeTags?: boolean,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestRun;

  @tag("Runs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runs")
  @extension("x-ms-vss-method", "UpdateTestRun")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: RunUpdateModel,
  ): TestRun;
}

interface Attachments {
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetTestRunAttachments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/attachments")
  @get
  GetTestRunAttachments(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestAttachmentList;

  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "CreateTestRunAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/attachments")
  @post
  CreateTestRunAttachment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestAttachmentRequestModel,
  ): TestAttachmentReference;

  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "DeleteTestRunAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/attachments/{attachmentId}")
  @delete
  DeleteTestRunAttachment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path attachmentId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Returns a test run attachment */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetTestRunAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/attachments/{attachmentId}")
  @get
  GetTestRunAttachmentZip(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path attachmentId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header contentType: "application/octet-stream";
        @body @format("Stream") body: string;
      }
    | {
        @header contentType: "application/zip";
        @body @format("Stream") body: string;
      };

  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetTestResultAttachments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testCaseResultId}/attachments")
  @get
  GetTestResultAttachments(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testCaseResultId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestAttachmentList;

  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "CreateTestResultAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testCaseResultId}/attachments")
  @post
  CreateTestResultAttachment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testCaseResultId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestAttachmentRequestModel,
  ): TestAttachmentReference;

  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "DeleteTestResultAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testCaseResultId}/attachments/{attachmentId}")
  @delete
  DeleteTestResultAttachment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testCaseResultId: int32,
    @path attachmentId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Returns a test result attachment */
  @tag("Attachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "attachments")
  @extension("x-ms-vss-method", "GetTestResultAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testCaseResultId}/attachments/{attachmentId}")
  @get
  GetTestResultAttachmentZip(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testCaseResultId: int32,
    @path attachmentId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ):
    | {
        @header contentType: "application/octet-stream";
        @body @format("Stream") body: string;
      }
    | {
        @header contentType: "application/zip";
        @body @format("Stream") body: string;
      };
}

interface MessageLogs {
  /** Get test run message logs */
  @tag("Message Logs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "messageLogs")
  @extension("x-ms-vss-method", "GetTestRunMessageLogs")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/messagelogs")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the run to get. */
    @path runId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestMessageLogDetailsList;
}

interface ResultDocument {
  @tag("Result Document")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "resultDocument")
  @extension("x-ms-vss-method", "PublishTestResultDocument")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/resultdocument")
  @post
  PublishTestResultDocument(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestResultDocument,
  ): TestResultDocument;
}

interface Testlog {
  /** Get list of test result attachments reference */
  @tag("Testlog")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlog")
  @extension("x-ms-vss-method", "GetTestResultLogsAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{resultId}/testlog")
  @get
  GetTestResultLogs(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the test run that contains the result */
    @path runId: int32,

    /** Id of the test result */
    @path resultId: int32,

    /** type of attachments to get */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    /** directory path of attachments to get */
    @query(#{ explode: true }) directoryPath?: string,

    /** file name prefix to filter the list of attachment */
    @query(#{ explode: true }) fileNamePrefix?: string,

    /** Default is false, set if metadata is needed */
    @query(#{ explode: true }) fetchMetaData?: boolean,

    /** Numbe of attachments reference to return */
    @query(#{ explode: true }) top?: int32,

    /** Header to pass the continuationToken */
    @header continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogList;

  /** Get list of test run attachments reference */
  @tag("Testlog")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlog")
  @extension("x-ms-vss-method", "GetTestRunLogsAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/testlog")
  @get
  GetTestRunLogs(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the test run */
    @path runId: int32,

    /** type of the attachments to get */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    /** directory path for which attachments are needed */
    @query(#{ explode: true }) directoryPath?: string,

    /** file name prefix to filter the list of attachment */
    @query(#{ explode: true }) fileNamePrefix?: string,

    /** Default is false, set if metadata is needed */
    @query(#{ explode: true }) fetchMetaData?: boolean,

    /** Number of attachments reference to return */
    @query(#{ explode: true }) top?: int32,

    /** Header to pass the continuationToken */
    @header continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogList;

  /** Get list of build attachments reference */
  @tag("Testlog")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlog")
  @extension("x-ms-vss-method", "GetTestLogsForBuildAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testlog")
  @get
  GetTestLogsForBuild(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the build to get */
    @query(#{ explode: true }) buildId: int32,

    /** type of the attachment to get */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    /** directory path for which attachments are needed */
    @query(#{ explode: true }) directoryPath?: string,

    /** file name prefix to filter the list of attachment */
    @query(#{ explode: true }) fileNamePrefix?: string,

    /** Default is false, set if metadata is needed */
    @query(#{ explode: true }) fetchMetaData?: boolean,

    /** Number of test attachments reference to return */
    @query(#{ explode: true }) top?: int32,

    /** Header to pass the continuationToken */
    @header continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogList;
}

interface Testlogstoreendpoint {
  /** Get SAS Uri of a test results attachment */
  @tag("Testlogstoreendpoint")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlogstoreendpoint")
  @extension("x-ms-vss-method", "GetTestLogStoreEndpointDetailsForResultLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{resultId}/testlogstoreendpoint")
  @get
  GetTestLogStoreEndpointDetailsForResultLog(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the test run that contains result */
    @path runId: int32,

    /** Id of the test result whose files need to be downloaded */
    @path resultId: int32,

    /** type of the file */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    /** filePath for which sas uri is needed */
    @query(#{ explode: true }) filePath: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreEndpointDetails;

  /** Create empty file for a result and Get Sas uri for the file */
  @tag("Testlogstoreendpoint")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlogstoreendpoint")
  @extension("x-ms-vss-method", "TestLogStoreEndpointDetailsForResult")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{resultId}/testlogstoreendpoint")
  @post
  TestLogStoreEndpointDetailsForResult(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the test run that contains the result */
    @path runId: int32,

    /** Id of the test results that contains sub result */
    @path resultId: int32,

    /** Id of the test sub result whose file sas uri is needed */
    @query(#{ explode: true }) subResultId: int32,

    /** file path inside the sub result for which sas uri is needed */
    @query(#{ explode: true }) filePath: string,

    /** Type of the file for download */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreEndpointDetails;

  /** Get SAS Uri of a test run attachment */
  @tag("Testlogstoreendpoint")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlogstoreendpoint")
  @extension("x-ms-vss-method", "GetTestLogStoreEndpointDetailsForRunLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/testlogstoreendpoint")
  @get
  GetTestLogStoreEndpointDetailsForRunLog(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the test run whose file has to be downloaded */
    @path runId: int32,

    /** type of the file */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    /** filePath for which sas uri is needed */
    @query(#{ explode: true }) filePath: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreEndpointDetails;

  /** Create empty file for a run and Get Sas uri for the file */
  @tag("Testlogstoreendpoint")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlogstoreendpoint")
  @extension("x-ms-vss-method", "TestLogStoreEndpointDetailsForRun")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/testlogstoreendpoint")
  @post
  TestLogStoreEndpointDetailsForRun(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the run to get endpoint details */
    @path runId: int32,

    /** Type of operation to perform using sas uri */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogStoreOperationType",
        values: #[#{ value: "read", description: "Operation is scoped to read data only." }],
      }
    )
    @query(#{ explode: true })
    testLogStoreOperationType: "read",

    /** file path to create an empty file */
    @query(#{ explode: true }) filePath?: string,

    /** Default is GeneralAttachment, type of empty file to be created */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type?: "generalAttachment",

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreEndpointDetails;

  /** Get SAS Uri of a build attachment */
  @tag("Testlogstoreendpoint")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlogstoreendpoint")
  @extension("x-ms-vss-method", "GetTestLogStoreEndpointDetailsForBuildLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testlogstoreendpoint")
  @get
  GetTestLogStoreEndpointDetailsForBuildLog(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the build to get */
    @query(#{ explode: true }) build: int32,

    /** type of the file */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogType",
        values: #[#{ value: "generalAttachment", description: "Any gereric attachment." }],
      }
    )
    @query(#{ explode: true })
    type: "generalAttachment",

    /** filePath for which sas uri is needed */
    @query(#{ explode: true }) filePath: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreEndpointDetails;

  /** Create and Get sas uri of the build container */
  @tag("Testlogstoreendpoint")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testlogstoreendpoint")
  @extension("x-ms-vss-method", "TestLogStoreEndpointDetailsForBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testlogstoreendpoint")
  @post
  TestLogStoreEndpointDetailsForBuild(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the build to get */
    @query(#{ explode: true }) buildId: int32,

    /** Type of operation to perform using sas uri */
    @extension(
      "x-ms-enum",
      #{
        name: "TestLogStoreOperationType",
        values: #[#{ value: "read", description: "Operation is scoped to read data only." }],
      }
    )
    @query(#{ explode: true })
    testLogStoreOperationType: "read",

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreEndpointDetails;
}

interface Bugs {
  @tag("Bugs")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "bugs")
  @extension("x-ms-vss-method", "GetBugsLinkedToTestResult")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testCaseResultId}/bugs")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path runId: int32,
    @path testCaseResultId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): WorkItemReferenceList;
}

interface SimilarTestResults {
  /** Gets the list of results whose failure matches with the provided one. */
  @tag("Similar Test Results")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "similarTestResults")
  @extension("x-ms-vss-method", "GetSimilarTestResults")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/results/{testResultId}/similartestresults")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** id of test run */
    @path runId: int32,

    /** id of test result inside a test run */
    @path testResultId: int32,

    /** id of subresult inside a test result */
    @query(#{ explode: true }) testSubResultId: int32,

    /** Maximum number of results to return */
    @query(#{ explode: true }) $top?: int32,

    /** Header to pass the continuationToken */
    @header continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestCaseResultList;
}

interface Runsummary {
  /** Get test run summary, used when we want to get summary of a run by outcome. Test run should be in completed state. */
  @tag("Runsummary")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "runsummary")
  @extension("x-ms-vss-method", "GetTestRunSummaryByOutcome")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/runsummary")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the run to get. */
    @path runId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestRunStatistic;
}

interface Statistics {
  /** Get test run statistics , used when we want to get summary of a run by outcome. */
  @tag("Statistics")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "statistics")
  @extension("x-ms-vss-method", "GetTestRunStatistics")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/statistics")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the run to get. */
    @path runId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): TestRunStatistic;
}

interface Tags {
  /** Update tags of a run, Tags can be Added and Deleted */
  @tag("Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tags")
  @extension("x-ms-vss-method", "UpdateTestRunTags")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/tags")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** RunId of the run */
    @path runId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** TestTagsUpdateModel */
    @body body: TestTagsUpdateModel,
  ): TestTagList;

  /** Get all the tags in a build. */
  @tag("Tags")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tags")
  @extension("x-ms-vss-method", "GetTestTagsForBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/tags")
  @get
  GetTestTagsForBuild(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Build ID */
    @query(#{ explode: true }) buildId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestTagList;
}

interface Testattachments {
  /** Deletes the attachment with the specified filename for the specified runId from the LogStore. */
  @tag("Testattachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testattachments")
  @extension("x-ms-vss-method", "DeleteTestRunLogStoreAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/testattachments")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Test RunId */
    @path runId: int32,

    /** Attachment FileName */
    @query(#{ explode: true }) filename: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Returns a list of attachments for the specified runId from the LogStore. */
  @tag("Testattachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testattachments")
  @extension("x-ms-vss-method", "GetTestRunLogStoreAttachments")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/testattachments")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Test RunId */
    @path runId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestLogStoreAttachmentList;

  /** Creates an attachment in the LogStore for the specified runId. */
  @tag("Testattachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testattachments")
  @extension("x-ms-vss-method", "CreateTestRunLogStoreAttachment")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/runs/{runId}/testattachments")
  @post
  CreateTestRunLogStoreAttachment(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Test RunId */
    @path runId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Contains attachment info like stream, filename, comment, attachmentType */
    @body body: TestAttachmentRequestModel,
  ): TestLogStoreAttachmentReference;

  /** Creates an attachment in the LogStore for the specified buildId. */
  @tag("Testattachments")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testattachments")
  @extension("x-ms-vss-method", "CreateBuildAttachmentInLogStore")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/uploadbuildattachments/{buildId}")
  @post
  CreateBuildAttachmentInLogStore(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** BuildId */
    @path buildId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Contains attachment info like stream, filename, comment, attachmentType */
    @body body: TestAttachmentRequestModel,
  ): OkResponse;
}

interface Settings {
  /** Get TestResultsSettings data */
  @tag("Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "settings")
  @extension("x-ms-vss-method", "GetTestResultsSettings")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/settings")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @extension(
      "x-ms-enum",
      #{
        name: "TestResultsSettingsType",
        values: #[
          #{ value: "all", description: "Returns All Test Settings." },
          #{ value: "flaky", description: "Returns Flaky Test Settings." },
          #{ value: "newTestLogging", description: "Returns whether to log new tests or not" },
          #{
            value: "advancedFlakyDetection",
            description: "Returns Advanced Flaky Test Detection Settings.",
          }
        ],
      }
    )
    @query(#{ explode: true })
    settingsType?: "all" | "flaky" | "newTestLogging" | "advancedFlakyDetection",
    ...Parameters.`api-Version-preview`.`3`,
  ): TestResultsSettings;

  /** Update project settings of test results */
  @tag("Settings")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "settings")
  @extension("x-ms-vss-method", "UpdatePipelinesTestSettings")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/settings")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`3`,
    @body body: TestResultsUpdateSettings,
  ): TestResultsSettings;
}

interface Tagsummary {
  /** Get all the tags in a build. */
  @tag("Tagsummary")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "tagsummary")
  @extension("x-ms-vss-method", "GetTestTagSummaryForBuild")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/tagsummary")
  @get
  GetTestTagSummaryForBuild(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Build ID */
    @query(#{ explode: true }) buildId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestTagSummary;
}

interface Testai {
  /** OAuth callback endpoint. GitHub redirects here after user authorizes. Exchanges the authorization code for tokens and stores them in TCM StrongBox. Requires the callback URL to be registered in the GitHub OAuth App settings. */
  @tag("Testai")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testai")
  @extension("x-ms-vss-method", "CompleteGitHubAuth")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testai/completegithubauth")
  @get
  CompleteGitHubAuth(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The authorization code returned by GitHub after user consent */
    @query(#{ explode: true }) code: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<string>;
}

interface Testfailuretype {
  /** Returns the list of test failure types. */
  @tag("Testfailuretype")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testfailuretype")
  @extension("x-ms-vss-method", "GetFailureTypes")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testfailuretype")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestResultFailureTypeList;

  /** Creates a new test failure type */
  @tag("Testfailuretype")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testfailuretype")
  @extension("x-ms-vss-method", "CreateFailureType")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testfailuretype")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestResultFailureTypeRequestModel,
  ): TestResultFailureType;

  /** Deletes a test failure type with specified failureTypeId */
  @tag("Testfailuretype")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testfailuretype")
  @extension("x-ms-vss-method", "DeleteFailureType")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testfailuretype/{failureTypeId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @path failureTypeId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface Testsettings {
  @tag("Testsettings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testsettings")
  @extension("x-ms-vss-method", "DeleteTestSettings")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testsettings")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) testSettingsId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  @tag("Testsettings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testsettings")
  @extension("x-ms-vss-method", "GetTestSettingsById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testsettings")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    @query(#{ explode: true }) testSettingsId: int32,
    ...Parameters.`api-Version-preview`.`1`,
  ): TestSettings;

  @tag("Testsettings")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testsettings")
  @extension("x-ms-vss-method", "CreateTestSettings")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testresults/testsettings")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: TestSettings,
  ): Body<int32>;
}
