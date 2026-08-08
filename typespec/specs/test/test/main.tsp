import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Test" })
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
namespace Test;

model AbortTestRunRequest {
  options?: int32;
  projectName?: string;
  revision?: int32;
  testRunId?: int32;
}

/** Actual Test Result Settings for a Test Plan */
model ActualTestResultSettings {
  /** Enable actual results field usage for test step result in the test plan during test execution */
  isActualTestResultEnabled?: boolean;

  /** Mandate actual results field usage for test step result in the test plan during test execution */
  isActualTestResultMandatory?: boolean;
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

model AfnStrip {
  /** Auxiliary Url to be consumed by MTM */
  auxiliaryUrl?: string;

  /** Creation date of the AfnStrip */
  creationDate?: utcDateTime;

  /** File name of the attachment created */
  fileName?: string;

  /** ID of AfnStrip. This is same as the attachment ID. */
  id?: int32;

  /** Project identifier which contains AfnStrip */
  project?: string;

  /** Service in which this attachment is stored in */
  storedIn?: string;

  /** Afn strip stream. */
  stream?: string;

  /** ID of the testcase. */
  testCaseId?: int32;

  /** Backing test result id. */
  testResultId?: int32;

  /** Backing test run id. */
  testRunId?: int32;

  /** Byte stream (uncompressed) length of Afn strip. */
  unCompressedStreamLength?: int64;

  /** Url of the attachment created. */
  url?: string;
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

model AttachmentReference {
  fileName?: string;
  url?: string;
}

model BatchResponse {
  error?: string;
  responses?: Response[];
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
  status?:
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

model BranchCoverageStatistics {
  /** number of covered branches */
  coveredBranches?: int32;

  /** total number of branches */
  totalBranches?: int32;
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

model BuildReference2 {
  branchName?: string;
  buildConfigurationId?: int32;
  buildDefinitionId?: int32;
  buildDeleted?: boolean;
  buildFlavor?: string;
  buildId?: int32;
  buildNumber?: string;
  buildPlatform?: string;
  buildSystem?: string;
  buildUri?: string;
  coverageId?: int32;
  createdDate?: utcDateTime;
  @format("uuid") projectId?: string;
  repoId?: string;
  repoType?: string;
  sourceVersion?: string;
}

model BulkResultUpdateRequest {
  projectName?: string;
  requests?: ResultUpdateRequest[];
}

/** Detail About Clone Operation. */
model CloneOperationInformation {
  cloneStatistics?: CloneStatistics;

  /** If the operation is complete, the DateTime of completion. If operation is not complete, this is DateTime.MaxValue */
  completionDate?: utcDateTime;

  /** DateTime when the operation was started */
  creationDate?: utcDateTime;

  destinationObject?: ShallowReference;
  destinationPlan?: ShallowReference;
  destinationProject?: ShallowReference;

  /** If the operation has Failed, Message contains the reason for failure. Null otherwise. */
  message?: string;

  /** The ID of the operation */
  opId?: int32;

  /** The type of the object generated as a result of the Clone operation */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultObjectType",
      values: #[
        #{ value: "testSuite", description: "Suite Clone" },
        #{ value: "testPlan", description: "Plan Clone" }
      ],
    }
  )
  resultObjectType?: "testSuite" | "testPlan";

  sourceObject?: ShallowReference;
  sourcePlan?: ShallowReference;
  sourceProject?: ShallowReference;

  /** Current state of the operation. When State reaches Succeeded or Failed, the operation is complete */
  @extension(
    "x-ms-enum",
    #{
      name: "CloneOperationState",
      values: #[
        #{ value: "failed", description: "value for Failed State" },
        #{ value: "inProgress", description: "value for Inprogress state" },
        #{ value: "queued", description: "Value for Queued State" },
        #{ value: "succeeded", description: "value for Success state" }
      ],
    }
  )
  state?: "failed" | "inProgress" | "queued" | "succeeded";

  /** Url for getting the clone information */
  url?: string;
}

/** Clone options for cloning the test suite. */
model CloneOptions {
  /** If set to true requirements will be cloned */
  cloneRequirements?: boolean;

  /** copy all suites from a source plan */
  copyAllSuites?: boolean;

  /** copy ancestor hierarchy */
  copyAncestorHierarchy?: boolean;

  /** Name of the workitem type of the clone */
  destinationWorkItemType?: string;

  /** Key value pairs where the key value is overridden by the value. */
  overrideParameters?: Record<string>;

  /** Comment on the link that will link the new clone test case to the original Set null for no comment */
  relatedLinkComment?: string;
}

/** Clone Statistics Details. */
model CloneStatistics {
  /** Number of requirements cloned so far. */
  clonedRequirementsCount?: int32;

  /** Number of shared steps cloned so far. */
  clonedSharedStepsCount?: int32;

  /** Number of test cases cloned so far */
  clonedTestCasesCount?: int32;

  /** Total number of requirements to be cloned */
  totalRequirementsCount?: int32;

  /** Total number of test cases to be cloned */
  totalTestCasesCount?: int32;
}

model CloneTestCaseOptions {
  /** If set to true, include the attachments */
  includeAttachments?: boolean;

  /** If set to true, include the links */
  includeLinks?: boolean;

  /** Comment on the link that will link the new clone test case to the original Set null for no comment */
  relatedLinkComment?: string;
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

model CodeCoverageSummary2 {
  buildConfigurationId?: int32;
  covered?: int32;
  label?: string;
  position?: int32;
  @format("uuid") projectId?: string;
  total?: int32;
}

model Coverage2 {
  coverageId?: int32;
  dateCreated?: utcDateTime;
  dateModified?: utcDateTime;
  lastError?: string;
  state?: bytes;
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

model CreateTestMessageLogEntryRequest {
  projectName?: string;
  testMessageLogEntry?: TestMessageLogEntry[];
  testRunId?: int32;
}

model CreateTestResultsRequest {
  projectName?: string;
  results?: LegacyTestCaseResult[];
}

model CreateTestRunRequest {
  projectName?: string;
  results?: LegacyTestCaseResult[];
  testRun?: LegacyTestRun;
  testSettings?: LegacyTestSettings;
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

model DatedTestFieldData {
  date?: utcDateTime;
  value?: TestFieldData;
}

model DefaultAfnStripBinding {
  testCaseId?: int32;
  testResultId?: int32;
  testRunId?: int32;
}

model DeleteTestRunRequest {
  projectName?: string;
  testRunIds?: int32[];
}

model DownloadAttachmentsRequest {
  ids?: int32[];
  lengths?: int64[];
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

model FetchTestResultsRequest {
  idAndRevs?: TestCaseResultIdAndRev[];
  includeActionResults?: boolean;
  projectName?: string;
}

model FetchTestResultsResponse {
  actionResults?: TestActionResult[];
  attachments?: TestResultAttachment[];
  deletedIds?: LegacyTestCaseResultIdentifier[];
  results?: LegacyTestCaseResult[];
  testParameters?: TestResultParameter[];
}

model FieldDetailsForTestResults {
  /** Group by field name */
  fieldName?: string;

  /** Group by field values */
  groupsForField?: {}[];
}

model FileCoverage {
  /** List of line blocks along with their coverage status */
  lineBlocksCoverage?: LineBlockCoverage[];

  /** File path for which coverage information is sought for */
  path?: string;
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

model FilterPointQuery {
  planId?: int32;
  pointIds?: int32[];
  pointOutcome?: bytes[];
  resultState?: bytes[];
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

model FunctionCoverage2 {
  blocksCovered?: int32;
  blocksNotCovered?: int32;
  class?: string;
  coverageId?: int32;
  functionId?: int32;
  linesCovered?: int32;
  linesNotCovered?: int32;
  linesPartiallyCovered?: int32;
  moduleId?: int32;
  name?: string;
  `namespace`?: string;
  sourceFile?: string;
}

model GenerateTestPlanFromWorkItemModel {
  userInstructions?: string;
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

model HttpPostedTcmAttachment {
  attachmentContent?: string;
  contentLength?: int32;
  contentType?: string;
  fileName?: string;
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

/** Job in pipeline. This is related to matrixing in YAML. */
model JobReference {
  /** Attempt number of the job */
  attempt?: int32;

  /** Matrixing in YAML generates copies of a job with different inputs in matrix. JobName is the name of those input. Maximum supported length for name is 256 character. */
  jobName?: string;
}

/** Last result details of test point. */
model LastResultDetails {
  /** Completed date of last result. */
  dateCompleted?: utcDateTime;

  /** Duration of the last result in milliseconds. */
  duration?: int64;

  runBy?: IdentityRef;
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

model LegacyBuildConfiguration {
  branchName?: string;
  buildConfigurationId?: int32;
  buildDefinitionId?: int32;
  buildDefinitionName?: string;
  buildFlavor?: string;
  buildId?: int32;
  buildNumber?: string;
  buildPlatform?: string;
  buildQuality?: string;
  buildSystem?: string;
  buildUri?: string;
  completedDate?: utcDateTime;
  createdDate?: utcDateTime;
  oldBuildConfigurationId?: int32;
  repositoryId?: string;
  repositoryType?: string;
  sourceVersion?: string;
  teamProjectName?: string;
}

model LegacyReleaseReference {
  attempt?: int32;
  environmentCreationDate?: utcDateTime;
  primaryArtifactBuildId?: int32;
  primaryArtifactProjectId?: string;
  primaryArtifactType?: string;
  releaseCreationDate?: utcDateTime;
  releaseDefId?: int32;
  releaseEnvDefId?: int32;
  releaseEnvId?: int32;
  releaseEnvName?: string;
  releaseEnvUri?: string;
  releaseId?: int32;
  releaseName?: string;
  releaseRefId?: int32;
  releaseUri?: string;
}

model LegacyTestCaseResult {
  afnStripId?: int32;
  areaId?: int32;
  areaUri?: string;
  automatedTestId?: string;
  automatedTestName?: string;
  automatedTestStorage?: string;
  automatedTestType?: string;
  automatedTestTypeId?: string;
  buildNumber?: string;
  buildReference?: LegacyBuildConfiguration;
  comment?: string;
  computerName?: string;
  configurationId?: int32;
  configurationName?: string;
  creationDate?: utcDateTime;
  customFields?: TestExtensionField[];
  dateCompleted?: utcDateTime;
  dateStarted?: utcDateTime;
  duration?: int64;
  errorMessage?: string;
  failingSince?: FailingSince;
  failureType?: bytes;
  id?: LegacyTestCaseResultIdentifier;
  isRerun?: boolean;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  lastUpdatedByName?: string;
  outcome?: bytes;
  @format("uuid") owner?: string;
  ownerName?: string;
  priority?: bytes;
  releaseReference?: LegacyReleaseReference;
  resetCount?: int32;
  resolutionStateId?: int32;
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
  revision?: int32;
  @format("uuid") runBy?: string;
  runByName?: string;
  sequenceId?: int32;
  stackTrace?: TestExtensionField;
  state?: bytes;
  subResultCount?: int32;
  suiteName?: string;
  testCaseArea?: string;
  testCaseAreaUri?: string;
  testCaseId?: int32;
  testCaseReferenceId?: int32;
  testCaseRevision?: int32;
  testCaseTitle?: string;
  testPlanId?: int32;
  testPointId?: int32;
  testResultId?: int32;
  testRunId?: int32;
  testRunTitle?: string;
  testSuiteId?: int32;
}

model LegacyTestCaseResultIdentifier {
  areaUri?: string;
  testResultId?: int32;
  testRunId?: int32;
}

model LegacyTestRun {
  bugsCount?: int32;
  buildConfigurationId?: int32;
  buildFlavor?: string;
  buildNumber?: string;
  buildPlatform?: string;
  buildReference?: LegacyBuildConfiguration;
  buildUri?: string;
  comment?: string;
  completeDate?: utcDateTime;
  configurationIds?: int32[];
  controller?: string;
  creationDate?: utcDateTime;
  csmContent?: string;
  csmParameters?: string;
  customFields?: TestExtensionField[];
  dropLocation?: string;
  dtlAutEnvironment?: ShallowReference;
  dtlTestEnvironment?: ShallowReference;
  dueDate?: utcDateTime;
  errorMessage?: string;
  filter?: RunFilter;
  incompleteTests?: int32;
  isAutomated?: boolean;
  isBvt?: boolean;
  iteration?: string;
  iterationId?: int32;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  lastUpdatedByName?: string;
  legacySharePath?: string;
  notApplicableTests?: int32;
  @format("uuid") owner?: string;
  ownerName?: string;
  passedTests?: int32;
  postProcessState?: bytes;
  publicTestSettingsId?: int32;
  releaseEnvironmentUri?: string;
  releaseReference?: LegacyReleaseReference;
  releaseUri?: string;
  revision?: int32;
  rowVersion?: bytes[];
  runHasDtlEnvironment?: boolean;
  @format("TimeSpan") runTimeout?: string;
  serviceVersion?: string;
  sourceWorkflow?: string;
  startDate?: utcDateTime;
  state?: bytes;
  subscriptionName?: string;
  substate?: bytes;
  teamProject?: string;
  teamProjectUri?: string;
  testConfigurationsMapping?: string;
  @format("uuid") testEnvironmentId?: string;
  testMessageLogEntries?: TestMessageLogDetails[];
  testMessageLogId?: int32;
  testPlanId?: int32;
  testRunId?: int32;
  testRunStatistics?: LegacyTestRunStatistic[];
  testSettingsId?: int32;
  title?: string;
  totalTests?: int32;
  type?: bytes;
  unanalyzedTests?: int32;
  version?: int32;
}

model LegacyTestRunStatistic {
  count?: int32;
  outcome?: bytes;
  resolutionState?: TestResolutionState;
  state?: bytes;
  testRunId?: int32;
}

model LegacyTestSettings {
  areaId?: int32;
  areaPath?: string;
  @format("uuid") createdBy?: string;
  createdByName?: string;
  createdDate?: utcDateTime;
  description?: string;
  id?: int32;
  isAutomated?: boolean;
  isPublic?: boolean;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  lastUpdatedByName?: string;
  machineRoles?: TestSettingsMachineRole[];
  name?: string;
  revision?: int32;
  settings?: string;
  teamProjectUri?: string;
}

model LineBlockCoverage {
  /** End of line block */
  end?: int32;

  /** Start of line block */
  start?: int32;

  /** Coverage status. Covered: 0, NotCovered: 1, PartiallyCovered: 2 */
  status?: int32;
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

model LinkedWorkItemsQuery {
  automatedTestNames?: string[];
  planId?: int32;
  pointIds?: int32[];
  suiteIds?: int32[];
  testCaseIds?: int32[];
  workItemCategory?: string;
}

model LinkedWorkItemsQueryResult {
  automatedTestName?: string;
  planId?: int32;
  pointId?: int32;
  suiteId?: int32;
  testCaseId?: int32;
  workItems?: WorkItemReference[];
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

model MetadataFile {
  @format("uuid") metadataId?: string;
  suites?: SuiteMetadata[];
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

model ModuleCoverage2 {
  blockCount?: int32;
  blockData?: bytes[];
  blockDataLength?: int32;
  blocksCovered?: int32;
  blocksNotCovered?: int32;
  coverageFileUrl?: string;
  coverageId?: int32;
  linesCovered?: int32;
  linesNotCovered?: int32;
  linesPartiallyCovered?: int32;
  moduleId?: int32;
  name?: string;
  @format("uuid") signature?: string;
  signatureAge?: int32;
}

/** Name value pair */
model NameValuePair {
  /** Name */
  name?: string;

  /** Value */
  value?: string;
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

model PipelineDebuggerJobState {
  /** Error message. Populated when state is 'Failed'. */
  error?: string;

  result?: PipelineDebuggerAnalysisOutput;

  /** Job state: Queued, Completed, or Failed. */
  state?: string;
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

/** A model class used for creating and updating test plans. */
model PlanUpdateModel {
  actualTestResultSettings?: ActualTestResultSettings;
  area?: ShallowReference;
  build?: ShallowReference;
  buildDefinition?: ShallowReference;

  /** IDs of configurations to be applied when new test suites and test cases are added to the test plan. */
  configurationIds?: int32[];

  /** Description of the test plan. */
  description?: string;

  /** End date for the test plan. */
  endDate?: string;

  /** Iteration path assigned to the test plan. This indicates when the target iteration by which the testing in this plan is supposed to be complete and the product is ready to be released. */
  iteration?: string;

  /** Name of the test plan. */
  name?: string;

  owner?: IdentityRef;
  releaseEnvironmentDefinition?: ReleaseEnvironmentDefinitionReference;

  /** Start date for the test plan. */
  startDate?: string;

  /** State of the test plan. */
  state?: string;

  testOutcomeSettings?: TestOutcomeSettings;
  yamlReleaseReference?: YamlReleaseReference;
}

/** Adding test cases to a suite creates one of more test points based on the default configurations and testers assigned to the test suite. PointAssignment is the list of test points that were created for each of the test cases that were added to the test suite. */
model PointAssignment {
  configuration?: ShallowReference;
  tester?: IdentityRef;
}

model PointLastResult {
  lastUpdatedDate?: utcDateTime;
  pointId?: int32;
}

/** Filter class for test point. */
model PointsFilter {
  /** List of Configurations for filtering. */
  configurationNames?: string[];

  /** List of test case id for filtering. */
  testcaseIds?: int32[];

  /** List of tester for filtering. */
  testers?: IdentityRef[];
}

model PointsReference2 {
  planId?: int32;
  pointId?: int32;
}

model PointsResults2 {
  changeNumber?: int32;
  lastFailureType?: bytes;
  lastResolutionStateId?: int32;
  lastResultOutcome?: bytes;
  lastResultState?: bytes;
  lastTestResultId?: int32;
  lastTestRunId?: int32;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  planId?: int32;
  pointId?: int32;
}

/** Model to update test point. */
model PointUpdateModel {
  /** Outcome to update. */
  outcome?: string;

  /** Reset test point to active. */
  resetToActive?: boolean;

  tester?: IdentityRef;
}

/** Test point workitem property. */
model PointWorkItemProperty {
  /** key value pair of test point work item property. */
  workItem?: {};
}

/** The class to represent a Generic store for test session data. */
model PropertyBag {
  /** Generic store for test session data */
  bag?: Record<string>;
}

model QueryByPointRequest {
  projectName?: string;
  testPlanId?: int32;
  testPointId?: int32;
}

model QueryByRunRequest {
  includeActionResults?: boolean;
  outcome?: bytes;
  @format("uuid") owner?: string;
  pageSize?: int32;
  projectName?: string;
  state?: bytes;
  testRunId?: int32;
}

model QueryModel {
  query?: string;
}

model QueryTestActionResultRequest {
  identifier?: LegacyTestCaseResultIdentifier;
  projectName?: string;
}

model QueryTestActionResultResponse {
  testActionResults?: TestActionResult[];
  testAttachments?: TestResultAttachment[];
  testResultParameters?: TestResultParameter[];
}

model QueryTestMessageLogEntryRequest {
  projectName?: string;
  testMessageLogId?: int32;
  testRunId?: int32;
}

model QueryTestRuns2Request {
  includeStatistics?: boolean;
  query?: ResultsStoreQuery;
}

model QueryTestRunsRequest {
  buildUri?: string;
  @format("uuid") owner?: string;
  planId?: int32;
  skip?: int32;
  teamProjectName?: string;
  testRunId?: int32;
  top?: int32;
}

model QueryTestRunStatsRequest {
  teamProjectName?: string;
  testRunId?: int32;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

/** Reference to release environment resource. */
model ReleaseEnvironmentDefinitionReference {
  /** ID of the release definition that contains the release environment definition. */
  definitionId?: int32;

  /** ID of the release environment definition. */
  environmentDefinitionId?: int32;
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

model ReleaseReference2 {
  attempt?: int32;
  environmentCreationDate?: utcDateTime;
  @format("uuid") projectId?: string;
  releaseCreationDate?: utcDateTime;
  releaseDefId?: int32;
  releaseEnvDefId?: int32;
  releaseEnvId?: int32;
  releaseEnvName?: string;
  releaseEnvUri?: string;
  releaseId?: int32;
  releaseName?: string;
  releaseRefId?: int32;
  releaseUri?: string;
}

model RequirementsToTestsMapping2 {
  @format("uuid") createdBy?: string;
  creationDate?: utcDateTime;
  @format("uuid") deletedBy?: string;
  deletionDate?: utcDateTime;
  isMigratedToWIT?: boolean;
  @format("uuid") projectId?: string;
  testMetadataId?: int32;
  workItemId?: int32;
}

model ResetTestResultsRequest {
  ids?: LegacyTestCaseResultIdentifier[];
  projectName?: string;
}

model Response {
  error?: string;
  @format("uuid") id?: string;
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
  status?:
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
  url?: string;
}

/** Test result retention settings */
model ResultRetentionSettings {
  /** Automated test result retention duration in days */
  automatedResultsRetentionDuration?: int32;

  lastUpdatedBy?: IdentityRef;

  /** Last updated date */
  lastUpdatedDate?: utcDateTime;

  /** Manual test result retention duration in days */
  manualResultsRetentionDuration?: int32;
}

/** Results insights for runs with state completed and NeedInvestigation. */
model ResultsAnalysis {
  previousContext?: PipelineReference;
  resultsDifference?: AggregatedResultsDifference;
  testFailuresAnalysis?: TestResultFailuresAnalysis;
}

model ResultsByQueryRequest {
  pageSize?: int32;
  query?: ResultsStoreQuery;
}

model ResultsByQueryResponse {
  excessIds?: LegacyTestCaseResultIdentifier[];
  testResults?: LegacyTestCaseResult[];
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

model ResultsStoreQuery {
  dayPrecision?: boolean;
  queryText?: string;
  teamProjectName?: string;
  timeZone?: string;
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

model ResultUpdateRequest {
  actionResultDeletes?: TestActionResult[];
  actionResults?: TestActionResult[];
  attachmentDeletes?: TestResultAttachmentIdentity[];
  attachments?: TestResultAttachment[];
  parameterDeletes?: TestResultParameter[];
  parameters?: TestResultParameter[];
  testCaseResult?: LegacyTestCaseResult;
  testResultId?: int32;
  testRunId?: int32;
}

model ResultUpdateRequestModel {
  actionResultDeletes?: TestActionResultModel[];
  actionResults?: TestActionResultModel[];
  parameterDeletes?: TestResultParameterModel[];
  parameters?: TestResultParameterModel[];
  testCaseResult?: TestCaseResultUpdateModel;
}

model ResultUpdateResponse {
  attachmentIds?: int32[];
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  lastUpdatedByName?: string;
  maxReservedSubResultId?: int32;
  revision?: int32;
  testPlanId?: int32;
  testResultId?: int32;
}

model ResultUpdateResponseModel {
  revision?: int32;
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

model StagedSuiteResponse {
  suiteId?: int32;
  suiteName?: string;
  testCaseMetadata?: StagedTestCaseMetadataResponse[];
}

model StagedSuitesRequestModel {
  suites?: StagingSuiteRequest[];
}

model StagedSuitesResponseModel {
  @format("uuid") metadataId?: string;
  success?: boolean;
}

model StagedTestCaseMetadataResponse {
  name?: string;
  testCaseId?: int32;
}

model StagedTestCaseResponse {
  name?: string;
  steps?: string;
  suiteId?: int32;
  testCaseId?: int32;
}

/** Stage in pipeline */
model StageReference {
  /** Attempt number of stage */
  attempt?: int32;

  /** Name of the stage. Maximum supported length for name is 256 character. */
  stageName?: string;
}

model StagingSuiteRequest {
  suiteId?: int32;
  suiteName?: string;
  testCaseMetadata?: TestCaseStagingMetadataRequest[];
}

/** Suite create model */
model SuiteCreateModel {
  /** Name of test suite. */
  name?: string;

  /** For query based suites, query string that defines the suite. */
  queryString?: string;

  /** For requirements test suites, the IDs of the requirements. */
  requirementIds?: int32[];

  /** Type of test suite to create. It can have value from DynamicTestSuite, StaticTestSuite and RequirementTestSuite. */
  suiteType?: string;
}

/** A suite entry defines properties for a test suite. */
model SuiteEntry {
  /** Id of child suite in the test suite. */
  childSuiteId?: int32;

  /** Sequence number for the test case or child test suite in the test suite. */
  sequenceNumber?: int32;

  /** Id for the test suite. */
  suiteId?: int32;

  /** Id of a test case in the test suite. */
  testCaseId?: int32;
}

/** A model to define sequence of test suite entries in a test suite. */
model SuiteEntryUpdateModel {
  /** Id of the child suite in the test suite. */
  childSuiteId?: int32;

  /** Updated sequence number for the test case or child test suite in the test suite. */
  sequenceNumber?: int32;

  /** Id of the test case in the test suite. */
  testCaseId?: int32;
}

model SuiteMetadata {
  suiteId?: int32;
  suiteName?: string;
  testCases?: TestCaseFileInfo[];
}

/** Test case for the suite. */
model SuiteTestCase {
  /** Point Assignment for test suite's test case. */
  pointAssignments?: PointAssignment[];

  testCase?: WorkItemReference;
}

/** Test suite update model. */
model SuiteTestCaseUpdateModel {
  /** Shallow reference of configurations for the test cases in the suite. */
  configurations?: ShallowReference[];
}

/** Test suite update model. */
model SuiteUpdateModel {
  /** Shallow reference of default configurations for the suite. */
  defaultConfigurations?: ShallowReference[];

  /** Shallow reference of test suite. */
  defaultTesters?: ShallowReference[];

  /** Specifies if the default configurations have to be inherited from the parent test suite in which the test suite is created. */
  inheritDefaultConfigurations?: boolean;

  /** Test suite name */
  name?: string;

  parent?: ShallowReference;

  /** For query based suites, the new query string. */
  queryString?: string;
}

model TCMPropertyBag2 {
  artifactId?: int32;
  artifactType?: int32;
  name?: string;
  value?: string;
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

/** Represents a shallow reference to a TeamProject. */
model TeamProjectReference {
  /** Project abbreviation. */
  abbreviation?: string;

  /** Url to default team identity image. */
  defaultTeamImageUrl?: string;

  /** The project's description (if any). */
  description?: string;

  /** Project identifier. */
  @format("uuid") id?: string;

  /** Project last update time. */
  lastUpdateTime?: utcDateTime;

  /** Project name. */
  name?: string;

  /** Project revision. */
  revision?: int64;

  /** Project state. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectState",
      values: #[
        #{ value: "deleting", description: "Project is in the process of being deleted." },
        #{ value: "new", description: "Project is in the process of being created." },
        #{ value: "wellFormed", description: "Project is completely created and ready to use." },
        #{
          value: "createPending",
          description: "Project has been queued for creation, but the process has not yet started.",
        },
        #{ value: "all", description: "All projects regardless of state except Deleted." },
        #{ value: "unchanged", description: "Project has not been changed." },
        #{ value: "deleted", description: "Project has been deleted." }
      ],
    }
  )
  state?: "deleting" | "new" | "wellFormed" | "createPending" | "all" | "unchanged" | "deleted";

  /** Url to the full version of the object. */
  url?: string;

  /** Project visibility. */
  @extension(
    "x-ms-enum",
    #{
      name: "ProjectVisibility",
      values: #[
        #{
          value: "private",
          description: "The project is only visible to users with explicit access.",
        },
        #{ value: "public", description: "The project is visible to all." }
      ],
    }
  )
  visibility?: "private" | "public";
}

model TestActionResult {
  actionPath?: string;
  comment?: string;
  creationDate?: utcDateTime;
  dateCompleted?: utcDateTime;
  dateStarted?: utcDateTime;
  duration?: int64;
  errorMessage?: string;
  id?: LegacyTestCaseResultIdentifier;
  iterationId?: int32;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  outcome?: bytes;
  sharedStepId?: int32;
  sharedStepRevision?: int32;
}

model TestActionResult2 {
  actionPath?: string;
  comment?: string;
  creationDate?: utcDateTime;
  dateCompleted?: utcDateTime;
  dateStarted?: utcDateTime;
  duration?: int64;
  errorMessage?: string;
  iterationId?: int32;
  lastUpdated?: utcDateTime;
  outcome?: bytes;
  sharedStepId?: int32;
  sharedStepRevision?: int32;
  testResultId?: int32;
  testRunId?: int32;
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

model TestAuthoringDetails {
  configurationId?: int32;
  isAutomated?: boolean;
  lastUpdated?: utcDateTime;
  pointId?: int32;
  priority?: bytes;
  @format("uuid") runBy?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "TestPointState",
      values: #[
        #{ value: "none", description: "Default" },
        #{
          value: "ready",
          description: "The test point needs to be executed in order for the test pass to be considered complete. Either the test has not been run before or the previous run failed.",
        },
        #{
          value: "completed",
          description: "The test has passed successfully and does not need to be re-run for the test pass to be considered complete.",
        },
        #{
          value: "notReady",
          description: "The test point needs to be executed but is not able to.",
        },
        #{ value: "inProgress", description: "The test is being executed." },
        #{ value: "maxValue", description: "" }
      ],
    }
  )
  state?: "none" | "ready" | "completed" | "notReady" | "inProgress" | "maxValue";
  suiteId?: int32;
  @format("uuid") testerId?: string;
}

model TestCaseFileInfo {
  fileName?: string;
  name?: string;
  testCaseId?: int32;
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

model TestCaseMetadata2 {
  container?: string;
  name?: string;
  @format("uuid") projectId?: string;
  testMetadataId?: int32;
}

model TestCaseReference2 {
  areaId?: int32;
  automatedTestId?: string;
  automatedTestName?: string;
  automatedTestNameHash?: bytes[];
  automatedTestStorage?: string;
  automatedTestStorageHash?: bytes[];
  automatedTestType?: string;
  configurationId?: int32;
  @format("uuid") createdBy?: string;
  creationDate?: utcDateTime;
  lastRefTestRunDate?: utcDateTime;
  owner?: string;
  priority?: bytes;
  @format("uuid") projectId?: string;
  testCaseId?: int32;
  testCaseRefId?: int32;
  testCaseRevision?: int32;
  testCaseTitle?: string;
  testPointId?: int32;
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

model TestCaseResultIdAndRev {
  id?: LegacyTestCaseResultIdentifier;
  revision?: int32;
}

/** Reference to a test result. */
model TestCaseResultIdentifier {
  /** Test result ID. */
  testResultId?: int32;

  /** Test run ID. */
  testRunId?: int32;
}

model TestCaseResultUpdateModel {
  associatedWorkItems?: int32[];
  automatedTestTypeId?: string;
  comment?: string;
  completedDate?: string;
  computerName?: string;
  customFields?: CustomTestField[];
  durationInMs?: string;
  errorMessage?: string;
  failureType?: string;
  outcome?: string;
  owner?: IdentityRef;
  resolutionState?: string;
  runBy?: IdentityRef;
  stackTrace?: string;
  startedDate?: string;
  state?: string;
  testCasePriority?: string;
  testResult?: ShallowReference;
}

model TestCaseStagingMetadataRequest {
  name?: string;
  steps?: string[];
  testCaseId?: int32;
}

/** Test configuration */
model TestConfiguration {
  area?: ShallowReference;

  /** Description of the configuration */
  description?: string;

  /** Id of the configuration */
  id?: int32;

  /** Is the configuration a default for the test plans */
  isDefault?: boolean;

  lastUpdatedBy?: IdentityRef;

  /** Last Updated Data */
  lastUpdatedDate?: utcDateTime;

  /** Name of the configuration */
  name?: string;

  project?: ShallowReference;

  /** Revision of the configuration */
  revision?: int32;

  /** State of the configuration */
  @extension(
    "x-ms-enum",
    #{
      name: "TestConfigurationState",
      values: #[
        #{ value: "active", description: "The configuration can be used for new test runs." },
        #{
          value: "inactive",
          description: "The configuration has been retired and should not be used for new test runs.",
        }
      ],
    }
  )
  state?: "active" | "inactive";

  /** Url of Configuration Resource */
  url?: string;

  /** Dictionary of Test Variable, Selected Value */
  values?: NameValuePair[];
}

/** Test environment Detail. */
model TestEnvironment {
  /** Test Environment Id. */
  @format("uuid") environmentId?: string;

  /** Test Environment Name. */
  environmentName?: string;
}

model TestExecutionReportData {
  reportData?: DatedTestFieldData[];
}

model TestExtensionField {
  field?: TestExtensionFieldDetails;
  value?: {};
}

model TestExtensionFieldDetails {
  id?: int32;
  isResultScoped?: boolean;
  isRunScoped?: boolean;
  isSystemField?: boolean;
  name?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "SqlDbType",
      values: #[
        #{ value: "bigInt", description: "" },
        #{ value: "binary", description: "" },
        #{ value: "bit", description: "" },
        #{ value: "char", description: "" },
        #{ value: "dateTime", description: "" },
        #{ value: "decimal", description: "" },
        #{ value: "float", description: "" },
        #{ value: "image", description: "" },
        #{ value: "int", description: "" },
        #{ value: "money", description: "" },
        #{ value: "nChar", description: "" },
        #{ value: "nText", description: "" },
        #{ value: "nVarChar", description: "" },
        #{ value: "real", description: "" },
        #{ value: "uniqueIdentifier", description: "" },
        #{ value: "smallDateTime", description: "" },
        #{ value: "smallInt", description: "" },
        #{ value: "smallMoney", description: "" },
        #{ value: "text", description: "" },
        #{ value: "timestamp", description: "" },
        #{ value: "tinyInt", description: "" },
        #{ value: "varBinary", description: "" },
        #{ value: "varChar", description: "" },
        #{ value: "variant", description: "" },
        #{ value: "xml", description: "" },
        #{ value: "udt", description: "" },
        #{ value: "structured", description: "" },
        #{ value: "date", description: "" },
        #{ value: "time", description: "" },
        #{ value: "dateTime2", description: "" },
        #{ value: "dateTimeOffset", description: "" }
      ],
    }
  )
  type?:
    | "bigInt"
    | "binary"
    | "bit"
    | "char"
    | "dateTime"
    | "decimal"
    | "float"
    | "image"
    | "int"
    | "money"
    | "nChar"
    | "nText"
    | "nVarChar"
    | "real"
    | "uniqueIdentifier"
    | "smallDateTime"
    | "smallInt"
    | "smallMoney"
    | "text"
    | "timestamp"
    | "tinyInt"
    | "varBinary"
    | "varChar"
    | "variant"
    | "xml"
    | "udt"
    | "structured"
    | "date"
    | "time"
    | "dateTime2"
    | "dateTimeOffset";
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

model TestFailureType {
  id?: int32;
  name?: string;
  project?: ShallowReference;
}

model TestFieldData {
  dimensions?: Record<{}>;
  measure?: int64;
}

model TestFieldsEx2 {
  fieldId?: int32;
  fieldName?: string;
  fieldType?: bytes;
  isResultScoped?: boolean;
  isRunScoped?: boolean;
  isSystemField?: boolean;
  @format("uuid") projectId?: string;
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

/** Represents Test Log Status object. */
model TestLogStatus {
  /** Exception message */
  exception?: string;

  /** Test Log Status code */
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

  /** Blob Transfer Error code */
  transferFailureType?: string;
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

model TestMessageLog2 {
  testMessageLogId?: int32;
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

model TestMessageLogEntry {
  dateCreated?: utcDateTime;
  entryId?: int32;
  logLevel?: bytes;
  @format("uuid") logUser?: string;
  logUserName?: string;
  message?: string;
  testMessageLogId?: int32;
}

model TestMessageLogEntry2 {
  dateCreated?: utcDateTime;
  entryId?: int32;
  logLevel?: bytes;
  @format("uuid") logUser?: string;
  message?: string;
  testMessageLogId?: int32;
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

/** Test outcome settings */
model TestOutcomeSettings {
  /** Value to configure how test outcomes for the same tests across suites are shown */
  syncOutcomeAcrossSuites?: boolean;
}

model TestParameter2 {
  actionPath?: string;
  actual?: bytes[];
  creationDate?: utcDateTime;
  dataType?: bytes;
  dateModified?: utcDateTime;
  expected?: bytes[];
  iterationId?: int32;
  parameterName?: string;
  testResultId?: int32;
  testRunId?: int32;
}

/** The test plan resource. */
model TestPlan {
  actualTestResultSettings?: ActualTestResultSettings;
  area?: ShallowReference;
  build?: ShallowReference;
  buildDefinition?: ShallowReference;

  /** Description of the test plan. */
  description?: string;

  /** End date for the test plan. */
  endDate?: utcDateTime;

  /** ID of the test plan. */
  id?: int32;

  /** Iteration path of the test plan. */
  iteration?: string;

  /** Name of the test plan. */
  name?: string;

  owner?: IdentityRef;
  previousBuild?: ShallowReference;
  project?: ShallowReference;
  releaseEnvironmentDefinition?: ReleaseEnvironmentDefinitionReference;

  /** Revision of the test plan. */
  revision?: int32;

  rootSuite?: ShallowReference;

  /** Start date for the test plan. */
  startDate?: utcDateTime;

  /** State of the test plan. */
  state?: string;

  testOutcomeSettings?: TestOutcomeSettings;
  updatedBy?: IdentityRef;
  updatedDate?: utcDateTime;

  /** URL of the test plan resource. */
  url?: string;

  yamlReleaseReference?: YamlReleaseReference;
}

model TestPlanCloneRequest {
  destinationTestPlan?: TestPlan;
  options?: CloneOptions;
  suiteIds?: int32[];
}

model TestPlanHubData {
  selectedSuiteId?: int32;
  testPlan?: TestPlan;
  testPoints?: TestPoint[];
  testSuites?: TestSuite[];
  totalTestPoints?: int32;
}

model TestPlansWithSelection {
  lastSelectedPlan?: int32;
  lastSelectedSuite?: int32;
  plans?: TestPlan[];
}

/** Test point. */
model TestPoint {
  assignedTo?: IdentityRef;

  /** Automated. */
  automated?: boolean;

  /** Comment associated with test point. */
  comment?: string;

  configuration?: ShallowReference;

  /** Failure type of test point. */
  failureType?: string;

  /** ID of the test point. */
  id?: int32;

  /** Last date when test point was reset to Active. */
  lastResetToActive?: utcDateTime;

  /** Last resolution state id of test point. */
  lastResolutionStateId?: int32;

  lastResult?: ShallowReference;
  lastResultDetails?: LastResultDetails;

  /** Last result state of test point. */
  lastResultState?: string;

  /** LastRun build number of test point. */
  lastRunBuildNumber?: string;

  lastTestRun?: ShallowReference;
  lastUpdatedBy?: IdentityRef;

  /** Last updated date of test point. */
  lastUpdatedDate?: utcDateTime;

  /** Outcome of test point. */
  outcome?: string;

  /** Revision number. */
  revision?: int32;

  /** State of test point. */
  state?: string;

  suite?: ShallowReference;
  testCase?: WorkItemReference;
  testPlan?: ShallowReference;

  /** Test point Url. */
  url?: string;

  /** Work item properties of test point. */
  workItemProperties?: {}[];
}

model TestPointReference {
  id?: int32;
  @extension(
    "x-ms-enum",
    #{
      name: "TestPointState",
      values: #[
        #{ value: "none", description: "Default" },
        #{
          value: "ready",
          description: "The test point needs to be executed in order for the test pass to be considered complete. Either the test has not been run before or the previous run failed.",
        },
        #{
          value: "completed",
          description: "The test has passed successfully and does not need to be re-run for the test pass to be considered complete.",
        },
        #{
          value: "notReady",
          description: "The test point needs to be executed but is not able to.",
        },
        #{ value: "inProgress", description: "The test is being executed." },
        #{ value: "maxValue", description: "" }
      ],
    }
  )
  state?: "none" | "ready" | "completed" | "notReady" | "inProgress" | "maxValue";
}

model TestPointsEvent {
  projectName?: string;
  testPoints?: TestPointReference[];
}

/** Test point query class. */
model TestPointsQuery {
  /** Order by results. */
  orderBy?: string;

  /** List of test points */
  points?: TestPoint[];

  pointsFilter?: PointsFilter;

  /** List of workitem fields to get. */
  witFields?: string[];
}

model TestPointsUpdatedEvent {
  ...TestPointsEvent;
}

/** Test Resolution State Details. */
model TestResolutionState {
  /** Test Resolution state Id. */
  id?: int32;

  /** Test Resolution State Name. */
  name?: string;

  project?: ShallowReference;
}

model TestResult2 {
  afnStripId?: int32;
  computerName?: string;
  creationDate?: utcDateTime;
  dateCompleted?: utcDateTime;
  dateStarted?: utcDateTime;
  effectivePointState?: bytes;
  failureType?: bytes;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  outcome?: bytes;
  @format("uuid") owner?: string;
  @format("uuid") projectId?: string;
  resetCount?: int32;
  resolutionStateId?: int32;
  revision?: int32;
  @format("uuid") runBy?: string;
  state?: bytes;
  testCaseRefId?: int32;
  testResultId?: int32;
  testRunId?: int32;
}

model TestResultAcrossProjectResponse {
  projectName?: string;
  testResult?: LegacyTestCaseResult;
}

model TestResultAttachment {
  actionPath?: string;
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
  comment?: string;
  creationDate?: utcDateTime;
  downloadQueryString?: string;
  fileName?: string;
  id?: int32;
  isComplete?: boolean;
  iterationId?: int32;
  length?: int64;
  sessionId?: int32;
  testResultId?: int32;
  testRunId?: int32;
  @format("uuid") tmiRunId?: string;
}

model TestResultAttachmentIdentity {
  attachmentId?: int32;
  sessionId?: int32;
  testResultId?: int32;
  testRunId?: int32;
}

model TestResultCreateModel {
  area?: ShallowReference;
  associatedWorkItems?: int32[];
  automatedTestId?: string;
  automatedTestName?: string;
  automatedTestStorage?: string;
  automatedTestType?: string;
  automatedTestTypeId?: string;
  comment?: string;
  completedDate?: string;
  computerName?: string;
  configuration?: ShallowReference;
  customFields?: CustomTestField[];
  durationInMs?: string;
  errorMessage?: string;
  failureType?: string;
  outcome?: string;
  owner?: IdentityRef;
  resolutionState?: string;
  runBy?: IdentityRef;
  stackTrace?: string;
  startedDate?: string;
  state?: string;
  testCase?: ShallowReference;
  testCasePriority?: string;
  testCaseTitle?: string;
  testPoint?: ShallowReference;
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

model TestResultMetaDataUpdateResponse {
  status?: string;
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

model TestResultParameter {
  actionPath?: string;
  actual?: bytes[];
  expected?: bytes[];
  iterationId?: int32;
  parameterName?: string;
  testResultId?: int32;
  testRunId?: int32;
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

model TestResultReset2 {
  @format("uuid") auditIdentity?: string;
  dateModified?: utcDateTime;
  @format("uuid") projectId?: string;
  revision?: int32;
  testResultId?: int32;
  testResultRV?: bytes[];
  testRunId?: int32;
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

model TestResultsEx2 {
  bitValue?: boolean;
  creationDate?: utcDateTime;
  dateTimeValue?: utcDateTime;
  fieldId?: int32;
  fieldName?: string;
  floatValue?: float64;
  @format("uuid") guidValue?: string;
  intValue?: int32;
  @format("uuid") projectId?: string;
  stringValue?: string;
  testResultId?: int32;
  testRunId?: int32;
}

model TestResultsGroupsForBuild {
  /** BuildId for which groupby result is fetched. */
  buildId?: int32;

  /** The group by results */
  fields?: FieldDetailsForTestResults[];
}

model TestResultsGroupsForRelease {
  /** The group by results */
  fields?: FieldDetailsForTestResults[];

  /** Release Environment Id for which groupby result is fetched. */
  releaseEnvId?: int32;

  /** ReleaseId for which groupby result is fetched. */
  releaseId?: int32;
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

model TestResultsWithWatermark {
  changedDate?: utcDateTime;
  pointsResults?: PointsResults2[];
  resultId?: int32;
  runId?: int32;
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

model TestRun2 {
  buildConfigurationId?: int32;
  buildNumber?: string;
  comment?: string;
  completeDate?: utcDateTime;
  controller?: string;
  coverageId?: int32;
  creationDate?: utcDateTime;
  deletedOn?: utcDateTime;
  dropLocation?: string;
  dueDate?: utcDateTime;
  errorMessage?: string;
  incompleteTests?: int32;
  isAutomated?: boolean;
  isBvt?: boolean;
  isMigrated?: boolean;
  iterationId?: int32;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  legacySharePath?: string;
  maxReservedResultId?: int32;
  notApplicableTests?: int32;
  @format("uuid") owner?: string;
  passedTests?: int32;
  postProcessState?: bytes;
  @format("uuid") projectId?: string;
  publicTestSettingsId?: int32;
  releaseEnvironmentUri?: string;
  releaseUri?: string;
  revision?: int32;
  startDate?: utcDateTime;
  state?: bytes;
  @format("uuid") testEnvironmentId?: string;
  testMessageLogId?: int32;
  testPlanId?: int32;
  testRunContextId?: int32;
  testRunId?: int32;
  testSettingsId?: int32;
  title?: string;
  totalTests?: int32;
  type?: bytes;
  unanalyzedTests?: int32;
  version?: int32;
}

model TestRunCanceledEvent {
  ...TestRunEvent;
}

model TestRunContext2 {
  buildRefId?: int32;
  @format("uuid") projectId?: string;
  releaseRefId?: int32;
  sourceWorkflow?: string;
  testRunContextId?: int32;
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

model TestRunCreatedEvent {
  ...TestRunEvent;
}

model TestRunEvent {
  testRun?: TestRun;
}

model TestRunEx2 {
  bitValue?: boolean;
  createdDate?: utcDateTime;
  dateTimeValue?: utcDateTime;
  fieldId?: int32;
  fieldName?: string;
  floatValue?: float64;
  @format("uuid") guidValue?: string;
  intValue?: int32;
  @format("uuid") projectId?: string;
  stringValue?: string;
  testRunId?: int32;
}

model TestRunExtended2 {
  autEnvironmentUrl?: string;
  csmContent?: string;
  csmParameters?: string;
  @format("uuid") projectId?: string;
  sourceFilter?: string;
  subscriptionName?: string;
  substate?: bytes;
  testCaseFilter?: string;
  testEnvironmentUrl?: string;
  testRunId?: int32;
}

model TestRunStartedEvent {
  ...TestRunEvent;
}

/** Test run statistics. */
model TestRunStatistic {
  run?: ShallowReference;
  runStatistics?: RunStatistic[];
}

model TestRunSummary2 {
  isRerun?: boolean;
  @format("uuid") projectId?: string;
  resultCount?: int32;
  resultDuration?: int64;
  runDuration?: int64;
  testOutcome?: bytes;
  testRunCompletedDate?: utcDateTime;
  testRunContextId?: int32;
  testRunId?: int32;
  testRunStatsId?: int64;
}

model TestRunWithDtlEnvEvent {
  ...TestRunEvent;
  configurationIds?: int32[];
  mappedTestRunEventType?: string;
  @format("TimeSpan") runTimeout?: string;
  testConfigurationsMapping?: string;
}

/** Test Session */
model TestSession {
  area?: ShallowReference;

  /** Comments in the test session */
  comment?: string;

  /** Duration of the session */
  endDate?: utcDateTime;

  /** Id of the test session */
  id?: int32;

  lastUpdatedBy?: IdentityRef;

  /** Last updated date */
  lastUpdatedDate?: utcDateTime;

  owner?: IdentityRef;
  project?: ShallowReference;
  propertyBag?: PropertyBag;

  /** Revision of the test session */
  revision?: int32;

  /** Source of the test session */
  @extension(
    "x-ms-enum",
    #{
      name: "TestSessionSource",
      values: #[
        #{ value: "unknown", description: "Source of test session uncertain as it is stale" },
        #{
          value: "xtDesktop",
          description: "The session was created from Microsoft Test Manager exploratory desktop tool.",
        },
        #{
          value: "feedbackDesktop",
          description: "The session was created from feedback client.",
        },
        #{ value: "xtWeb", description: "The session was created from browser extension." },
        #{ value: "feedbackWeb", description: "The session was created from browser extension." },
        #{
          value: "xtDesktop2",
          description: "The session was created from web access using Microsoft Test Manager exploratory desktop tool.",
        },
        #{
          value: "sessionInsightsForAll",
          description: "To show sessions from all supported sources.",
        }
      ],
    }
  )
  source?:
    | "unknown"
    | "xtDesktop"
    | "feedbackDesktop"
    | "xtWeb"
    | "feedbackWeb"
    | "xtDesktop2"
    | "sessionInsightsForAll";

  /** Start date */
  startDate?: utcDateTime;

  /** State of the test session */
  @extension(
    "x-ms-enum",
    #{
      name: "TestSessionState",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{ value: "notStarted", description: "The session is still being created." },
        #{ value: "inProgress", description: "The session is running." },
        #{ value: "paused", description: "The session has paused." },
        #{ value: "completed", description: "The session has completed." },
        #{
          value: "declined",
          description: "This is required for Feedback session which are declined",
        }
      ],
    }
  )
  state?: "unspecified" | "notStarted" | "inProgress" | "paused" | "completed" | "declined";

  /** Title of the test session */
  title?: string;

  /** Url of Test Session Resource */
  url?: string;
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

model TestSessionExploredWorkItemReference {
  ...TestSessionWorkItemReference;

  /** Workitem references of workitems filed as a part of the current workitem exploration. */
  associatedWorkItems?: TestSessionWorkItemReference[];

  /** Time when exploration of workitem ended. */
  endTime?: utcDateTime;

  /** Time when explore of workitem was started. */
  startTime?: utcDateTime;
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

model TestSessionWorkItemReference {
  /** Id of the workitem */
  id?: int32;

  /** Type of the workitem */
  type?: string;
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

/** Represents the test settings of the run. Used to create test settings and fetch test settings */
model TestSettings2 {
  /** Area path required to create test settings */
  areaPath?: string;

  createdBy?: IdentityRef;
  createdDate?: utcDateTime;

  /** Description of the test settings. Used in create test settings. */
  description?: string;

  /** Indicates if the tests settings is public or private.Used in create test settings. */
  isPublic?: boolean;

  lastUpdatedBy?: IdentityRef;
  lastUpdatedDate?: utcDateTime;

  /** Xml string of machine roles. Used in create test settings. */
  machineRoles?: string;

  /** Test settings content. */
  testSettingsContent?: string;

  /** Test settings id. */
  testSettingsId?: int32;

  /** Test settings name. */
  testSettingsName?: string;
}

model TestSettingsMachineRole {
  isExecution?: boolean;
  name?: string;
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

/** Test suite */
model TestSuite {
  /** Area uri of the test suite. */
  areaUri?: string;

  /** Child test suites of current test suite. */
  children?: TestSuite[];

  /** Test suite default configuration. */
  defaultConfigurations?: ShallowReference[];

  /** Test suite default testers. */
  defaultTesters?: ShallowReference[];

  /** Id of test suite. */
  id?: int32;

  /** Default configuration was inherited or not. */
  inheritDefaultConfigurations?: boolean;

  /** Last error for test suite. */
  lastError?: string;

  /** Last populated date. */
  lastPopulatedDate?: utcDateTime;

  lastUpdatedBy?: IdentityRef;

  /** Last update date. */
  lastUpdatedDate?: utcDateTime;

  /** Name of test suite. */
  name?: string;

  parent?: ShallowReference;
  plan?: ShallowReference;
  project?: ShallowReference;

  /** Test suite query string, for dynamic suites. */
  queryString?: string;

  /** Test suite requirement id. */
  requirementId?: int32;

  /** Test suite revision. */
  revision?: int32;

  /** State of test suite. */
  state?: string;

  /** List of shallow reference of suites. */
  suites?: ShallowReference[];

  /** Test suite type. */
  suiteType?: string;

  /** Test cases count. */
  testCaseCount?: int32;

  /** Test case url. */
  testCasesUrl?: string;

  /** Used in tree view. If test suite is root suite then, it is name of plan otherwise title of the suite. */
  text?: string;

  /** Url of test suite. */
  url?: string;
}

/** Test suite clone request */
model TestSuiteCloneRequest {
  cloneOptions?: CloneOptions;

  /** Suite id under which, we have to clone the suite. */
  destinationSuiteId?: int32;

  /** Destination suite project name. */
  destinationSuiteProjectName?: string;
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

model TestVariable {
  /** Description of the test variable */
  description?: string;

  /** Id of the test variable */
  id?: int32;

  /** Name of the test variable */
  name?: string;

  project?: ShallowReference;

  /** Revision */
  revision?: int32;

  /** Url of the test variable */
  url?: string;

  /** List of allowed values */
  values?: string[];
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

model UpdatedProperties {
  id?: int32;
  lastUpdated?: utcDateTime;
  @format("uuid") lastUpdatedBy?: string;
  lastUpdatedByName?: string;
  revision?: int32;
}

model UpdateTestRunRequest {
  attachmentsToAdd?: TestResultAttachment[];
  attachmentsToDelete?: TestResultAttachmentIdentity[];
  projectName?: string;
  shouldHyderate?: boolean;
  testRun?: LegacyTestRun;
}

model UpdateTestRunResponse {
  attachmentIds?: int32[];
  updatedProperties?: UpdatedProperties;
}

model UploadAttachmentsRequest {
  attachments?: HttpPostedTcmAttachment[];
  requestParams?: Record<string>;
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

/** Reference to yaml release resource. */
model YamlReleaseReference {
  /** ID of the yaml release definition */
  definitionId?: int32;

  /** Stages to skip while queuing yaml release. */
  stagesToSkip?: string;
}

/** Get code coverage data for a build. */
@tag("Code Coverage")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "codeCoverage")
@extension("x-ms-vss-method", "GetBuildCodeCoverage")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/codecoverage")
@get
op `Code Coverage_Get Build Code Coverage`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the build for which code coverage data needs to be fetched. */
  @query(#{ explode: true }) buildId: int32,

  /** Value of flags determine the level of code coverage details to be fetched. Flags are additive. Expected Values are 1 for Modules, 2 for Functions, 4 for BlockData. */
  @query(#{ explode: true }) flags: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Body<BuildCoverage[]>;

/** Get a list of test points. */
@tag("Points")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "points")
@extension("x-ms-vss-method", "GetPoints")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/Suites/{suiteId}/points")
@get
op Points_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan. */
  @path planId: int32,

  /** ID of the suite that contains the points. */
  @path suiteId: int32,

  /** Comma-separated list of work item field names. */
  @query(#{ explode: true }) witFields?: string,

  /** Get test points for specific configuration. */
  @query(#{ explode: true }) configurationId?: string,

  /** Get test points for a specific test case, valid when configurationId is not set. */
  @query(#{ explode: true }) testCaseId?: string,

  /** Get test points for comma-separated list of test point IDs, valid only when configurationId and testCaseId are not set. */
  @query(#{ explode: true }) testPointIds?: string,

  /** Include all properties for the test point. */
  @query(#{ explode: true }) includePointDetails?: boolean,

  /** Number of test points to skip.. */
  @query(#{ explode: true }) $skip?: int32,

  /** Number of test points to return. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`2`,
): Body<TestPoint[]>;

/** Get a test point. */
@tag("Points")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "points")
@extension("x-ms-vss-method", "GetPoint")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/Suites/{suiteId}/points/{pointIds}")
@get
op `Points_Get Point`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan. */
  @path planId: int32,

  /** ID of the suite that contains the point. */
  @path suiteId: int32,

  /** ID of the test point to get. */
  @path pointIds: int32,

  /** Comma-separated list of work item field names. */
  @query(#{ explode: true }) witFields?: string,

  ...Parameters.`api-Version-preview`.`2`,
): TestPoint;

/** Update test points. */
@tag("Points")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "points")
@extension("x-ms-vss-method", "UpdateTestPoints")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/Suites/{suiteId}/points/{pointIds}")
@patch
op Points_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan. */
  @path planId: int32,

  /** ID of the suite that contains the points. */
  @path suiteId: int32,

  /** ID of the test point to get. Use a comma-separated list of IDs to update multiple test points. */
  @path pointIds: string,

  ...Parameters.`api-Version-preview`.`2`,

  /** Data to update. */
  @body body: PointUpdateModel,
): Body<TestPoint[]>;

/** Get all test cases in a suite. */
@tag("Test  Suites")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "suites")
@extension("x-ms-vss-method", "GetTestCases")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/suites/{suiteId}/testcases")
@get
op `Test  Suites_List`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan that contains the suites. */
  @path planId: int32,

  /** ID of the suite to get. */
  @path suiteId: int32,

  ...Parameters.`api-Version-preview`.`3`,
): Body<SuiteTestCase[]>;

/** The test points associated with the test cases are removed from the test suite. The test case work item is not deleted from the system. See test cases resource to delete a test case permanently. */
@tag("Test  Suites")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "suites")
@extension("x-ms-vss-method", "RemoveTestCasesFromSuiteUrl")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/suites/{suiteId}/testcases/{testCaseIds}")
@delete
op `Test  Suites_Remove Test Cases From Suite Url`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan that contains the suite. */
  @path planId: int32,

  /** ID of the suite to get. */
  @path suiteId: int32,

  /** IDs of the test cases to remove from the suite. */
  @path testCaseIds: string,

  ...Parameters.`api-Version-preview`.`3`,
): OkResponse;

/** Get a specific test case in a test suite with test case id. */
@tag("Test  Suites")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "suites")
@extension("x-ms-vss-method", "GetTestCaseById")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/suites/{suiteId}/testcases/{testCaseIds}")
@get
op `Test  Suites_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan that contains the suites. */
  @path planId: int32,

  /** ID of the suite that contains the test case. */
  @path suiteId: int32,

  /** ID of the test case to get. */
  @path testCaseIds: int32,

  ...Parameters.`api-Version-preview`.`3`,
): SuiteTestCase;

/** Updates the properties of the test case association in a suite. */
@tag("Test  Suites")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "suites")
@extension("x-ms-vss-method", "UpdateSuiteTestCases")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/suites/{suiteId}/testcases/{testCaseIds}")
@patch
op `Test  Suites_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan that contains the suite. */
  @path planId: int32,

  /** ID of the test suite to which the test cases must be added. */
  @path suiteId: int32,

  /** IDs of the test cases to add to the suite. Ids are specified in comma separated format. */
  @path testCaseIds: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** Model for updation of the properties of test case suite association. */
  @body body: SuiteTestCaseUpdateModel,
): Body<SuiteTestCase[]>;

/** Add test cases to suite. */
@tag("Test  Suites")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "suites")
@extension("x-ms-vss-method", "AddTestCasesToSuite")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Plans/{planId}/suites/{suiteId}/testcases/{testCaseIds}")
@post
op `Test  Suites_Add`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test plan that contains the suite. */
  @path planId: int32,

  /** ID of the test suite to which the test cases must be added. */
  @path suiteId: int32,

  /** IDs of the test cases to add to the suite. Ids are specified in comma separated format. */
  @path testCaseIds: string,

  ...Parameters.`api-Version-preview`.`3`,
): Body<SuiteTestCase[]>;

/** Get test points using query. */
@tag("Points")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "points")
@extension("x-ms-vss-method", "GetPointsByQuery")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/points")
@post
op `Points_Get Points By Query`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Number of test points to skip.. */
  @query(#{ explode: true }) $skip?: int32,

  /** Number of test points to return. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`2`,

  /** TestPointsQuery to get test points. */
  @body body: TestPointsQuery,
): TestPointsQuery;

/** Get test result retention settings */
@tag("Result Retention Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "resultRetentionSettings")
@extension("x-ms-vss-method", "GetResultRetentionSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/resultretentionsettings")
@get
op `Result Retention Settings_Get`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
): ResultRetentionSettings;

/** Update test result retention settings */
@tag("Result Retention Settings")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "resultRetentionSettings")
@extension("x-ms-vss-method", "UpdateResultRetentionSettings")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/resultretentionsettings")
@patch
op `Result Retention Settings_Update`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Test result retention settings details to be updated */
  @body body: ResultRetentionSettings,
): ResultRetentionSettings;

/** Get history of a test method using TestHistoryQuery */
@tag("Test History")
@extension("x-ms-docs-override-version", "7.2-preview.2")
@extension("x-ms-vss-resource", "testHistory")
@extension("x-ms-vss-method", "QueryTestHistory")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Results/testhistory")
@post
op `Test History_Query`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`2`,

  /** TestHistoryQuery to get history */
  @body body: TestHistoryQuery,
): TestHistoryQuery;

/** Get a list of test runs. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "GetTestRuns")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/runs")
@get
op Runs_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** URI of the build that the runs used. */
  @query(#{ explode: true }) buildUri?: string,

  /** Team foundation ID of the owner of the runs. */
  @query(#{ explode: true }) owner?: string,

  @query(#{ explode: true }) tmiRunId?: string,

  /** ID of the test plan that the runs are a part of. */
  @query(#{ explode: true }) planId?: int32,

  /** If true, include all the properties of the runs. */
  @query(#{ explode: true }) includeRunDetails?: boolean,

  /** If true, only returns automated runs. */
  @query(#{ explode: true }) automated?: boolean,

  /** Number of test runs to skip. */
  @query(#{ explode: true }) $skip?: int32,

  /** Number of test runs to return. */
  @query(#{ explode: true }) $top?: int32,

  ...Parameters.`api-Version-preview`.`3`,
): Body<TestRun[]>;

/** Create new test run. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "CreateTestRun")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/runs")
@post
op Runs_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`3`,

  /** Run details RunCreateModel */
  @body body: RunCreateModel,
): TestRun;

/** Delete a test run by its ID. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "DeleteTestRun")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/runs/{runId}")
@delete
op Runs_Delete(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the run to delete. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`3`,
): OkResponse;

/** Get a test run by its ID. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "GetTestRunById")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/runs/{runId}")
@get
op `Runs_Get Test Run By Id`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the run to get. */
  @path runId: int32,

  /** Default value is true. It includes details like run statistics, release, build, test environment, post process state, and more. */
  @query(#{ explode: true }) includeDetails?: boolean,

  ...Parameters.`api-Version-preview`.`3`,
): TestRun;

/** Update test run by its ID. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "UpdateTestRun")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/runs/{runId}")
@patch
op Runs_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the run to update. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`3`,

  /** Run details RunUpdateModel */
  @body body: RunUpdateModel,
): TestRun;

/** Get list of test run attachments reference. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "GetTestRunAttachments")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/attachments")
@get
op `Attachments_Get Test Run Attachments`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Body<TestAttachment[]>;

/** Attach a file to a test run. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "CreateTestRunAttachment")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/attachments")
@post
op `Attachments_Create Test Run Attachment`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run against which attachment has to be uploaded. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`1`,

  /** Attachment details TestAttachmentRequestModel */
  @body body: TestAttachmentRequestModel,
): TestAttachmentReference;

/** Download a test run attachment by its ID. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "GetTestRunAttachment")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/attachments/{attachmentId}")
@get
op `Attachments_Get Test Run Attachment Zip`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run whose attachment has to be downloaded. */
  @path runId: int32,

  /** ID of the test run attachment to be downloaded. */
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

/** Get code coverage data for a test run */
@tag("Code Coverage")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "codeCoverage")
@extension("x-ms-vss-method", "GetTestRunCodeCoverage")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/codecoverage")
@get
op `Code Coverage_Get Test Run Code Coverage`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run for which code coverage data needs to be fetched. */
  @path runId: int32,

  /** Value of flags determine the level of code coverage details to be fetched. Flags are additive. Expected Values are 1 for Modules, 2 for Functions, 4 for BlockData. */
  @query(#{ explode: true }) flags: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Body<TestRunCoverage[]>;

/** Get test results for a test run. */
@tag("Results")
@extension("x-ms-docs-override-version", "7.2-preview.6")
@extension("x-ms-vss-resource", "results")
@extension("x-ms-vss-method", "GetTestResults")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/results")
@get
op Results_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Test run ID of test results to fetch. */
  @path runId: int32,

  /** Details to include with test results. Default is None. Other values are Iterations and WorkItems. */
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

  /** Number of test results to skip from beginning. */
  @query(#{ explode: true }) $skip?: int32,

  /** Number of test results to return. Maximum is 1000 when detailsToInclude is None and 200 otherwise. */
  @query(#{ explode: true }) $top?: int32,

  /** Comma separated list of test outcomes to filter test results. */
  @format("array (TestOutcome)") @query(#{ explode: true }) outcomes?: string,

  ...Parameters.`api-Version-preview`.`6`,
): Body<TestCaseResult[]>;

/** Update test results in a test run. */
@tag("Results")
@extension("x-ms-docs-override-version", "7.2-preview.6")
@extension("x-ms-vss-resource", "results")
@extension("x-ms-vss-method", "UpdateTestResults")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/results")
@patch
op Results_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Test run ID whose test results to update. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`6`,

  /** List of test results to update. */
  @body body: TestCaseResult[],
): Body<TestCaseResult[]>;

/** Add test results to a test run. */
@tag("Results")
@extension("x-ms-docs-override-version", "7.2-preview.6")
@extension("x-ms-vss-resource", "results")
@extension("x-ms-vss-method", "AddTestResultsToTestRun")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/results")
@post
op Results_Add(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Test run ID into which test results to add. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`6`,

  /** List of test results to add. */
  @body body: TestCaseResult[],
): Body<TestCaseResult[]>;

/** Get a test result for a test run. */
@tag("Results")
@extension("x-ms-docs-override-version", "7.2-preview.6")
@extension("x-ms-vss-resource", "results")
@extension("x-ms-vss-method", "GetTestResultById")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/results/{testCaseResultId}")
@get
op Results_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Test run ID of a test result to fetch. */
  @path runId: int32,

  /** Test result ID. */
  @path testCaseResultId: int32,

  /** Details to include with test results. Default is None. Other values are Iterations, WorkItems and SubResults. */
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

  ...Parameters.`api-Version-preview`.`6`,
): TestCaseResult;

/** Get list of test result attachments reference. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "GetTestResultAttachments")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/Results/{testCaseResultId}/attachments")
@get
op `Attachments_Get Test Result Attachments`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run that contains the result. */
  @path runId: int32,

  /** ID of the test result. */
  @path testCaseResultId: int32,

  ...Parameters.`api-Version-preview`.`1`,
): Body<TestAttachment[]>;

/** Attach a file to a test result. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "CreateTestResultAttachment")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/Results/{testCaseResultId}/attachments")
@post
op `Attachments_Create Test Result Attachment`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run that contains the result. */
  @path runId: int32,

  /** ID of the test result against which attachment has to be uploaded. */
  @path testCaseResultId: int32,

  ...Parameters.`api-Version-preview`.`1`,

  /** Attachment details TestAttachmentRequestModel */
  @body body: TestAttachmentRequestModel,
): TestAttachmentReference;

/** Download a test result attachment by its ID. */
@tag("Attachments")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "attachments")
@extension("x-ms-vss-method", "GetTestResultAttachment")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/Results/{testCaseResultId}/attachments/{attachmentId}")
@get
op `Attachments_Get Test Result Attachment Zip`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run that contains the testCaseResultId. */
  @path runId: int32,

  /** ID of the test result whose attachment has to be downloaded. */
  @path testCaseResultId: int32,

  /** ID of the test result attachment to be downloaded. */
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

/** Get iterations for a result */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "iterations")
@extension("x-ms-vss-method", "GetTestIterations")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/Results/{testCaseResultId}/iterations")
@get
op Iterations_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run that contains the result. */
  @path runId: int32,

  /** ID of the test result that contains the iterations. */
  @path testCaseResultId: int32,

  /** Include result details for each action performed in the test iteration. ActionResults refer to outcome (pass/fail) of test steps that are executed as part of a running a manual test. Including the ActionResults flag gets the outcome of test steps in the actionResults section and test parameters in the parameters section for each test iteration. */
  @query(#{ explode: true }) includeActionResults?: boolean,

  ...Parameters.`api-Version-preview`.`3`,
): Body<TestIterationDetailsModel[]>;

/** Get iteration for a result */
@tag("Iterations")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "iterations")
@extension("x-ms-vss-method", "GetTestIteration")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/Runs/{runId}/Results/{testCaseResultId}/iterations/{iterationId}")
@get
op Iterations_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the test run that contains the result. */
  @path runId: int32,

  /** ID of the test result that contains the iterations. */
  @path testCaseResultId: int32,

  /** Id of the test results Iteration. */
  @path iterationId: int32,

  /** Include result details for each action performed in the test iteration. ActionResults refer to outcome (pass/fail) of test steps that are executed as part of a running a manual test. Including the ActionResults flag gets the outcome of test steps in the actionResults section and test parameters in the parameters section for each test iteration. */
  @query(#{ explode: true }) includeActionResults?: boolean,

  ...Parameters.`api-Version-preview`.`3`,
): TestIterationDetailsModel;

/** Get test run statistics , used when we want to get summary of a run by outcome. */
@tag("Runs")
@extension("x-ms-docs-override-version", "7.2-preview.3")
@extension("x-ms-vss-resource", "runs")
@extension("x-ms-vss-method", "GetTestRunStatistics")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/runs/{runId}/Statistics")
@get
op `Runs_Get Test Run Statistics`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** ID of the run to get. */
  @path runId: int32,

  ...Parameters.`api-Version-preview`.`3`,
): TestRunStatistic;

/** Delete a test case. */
@tag("Test Cases")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "testCases")
@extension("x-ms-vss-method", "DeleteTestCase")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/test/testcases/{testCaseId}")
@delete
op `Test Cases_Delete`(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Id of test case to delete. */
  @path testCaseId: int32,

  ...Parameters.`api-Version-preview`.`1`,
): OkResponse;

/** Get a list of test sessions */
@tag("Session")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "session")
@extension("x-ms-vss-method", "GetTestSessions")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/test/session")
@get
op Session_List(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  /** Period in days from now, for which test sessions are fetched. */
  @query(#{ explode: true }) period?: int32,

  /** If false, returns test sessions for current user. Otherwise, it returns test sessions for all users */
  @query(#{ explode: true }) allSessions?: boolean,

  /** If true, it returns all properties of the test sessions. Otherwise, it returns the skinny version. */
  @query(#{ explode: true }) includeAllProperties?: boolean,

  /** Source of the test session. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestSessionSource",
      values: #[
        #{ value: "unknown", description: "Source of test session uncertain as it is stale" },
        #{
          value: "xtDesktop",
          description: "The session was created from Microsoft Test Manager exploratory desktop tool.",
        },
        #{
          value: "feedbackDesktop",
          description: "The session was created from feedback client.",
        },
        #{ value: "xtWeb", description: "The session was created from browser extension." },
        #{ value: "feedbackWeb", description: "The session was created from browser extension." },
        #{
          value: "xtDesktop2",
          description: "The session was created from web access using Microsoft Test Manager exploratory desktop tool.",
        },
        #{
          value: "sessionInsightsForAll",
          description: "To show sessions from all supported sources.",
        }
      ],
    }
  )
  @query(#{ explode: true })
  source?:
    | "unknown"
    | "xtDesktop"
    | "feedbackDesktop"
    | "xtWeb"
    | "feedbackWeb"
    | "xtDesktop2"
    | "sessionInsightsForAll",

  /** If true, it returns test sessions in completed state. Otherwise, it returns test sessions for all states */
  @query(#{ explode: true }) includeOnlyCompletedSessions?: boolean,

  ...Parameters.`api-Version-preview`.`1`,
): Body<TestSession[]>;

/** Update a test session */
@tag("Session")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "session")
@extension("x-ms-vss-method", "UpdateTestSession")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/test/session")
@patch
op Session_Update(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Test session details for update */
  @body body: TestSession,
): TestSession;

/** Create a test session */
@tag("Session")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "session")
@extension("x-ms-vss-method", "CreateTestSession")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/{team}/_apis/test/session")
@post
op Session_Create(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  /** Team ID or team name */
  @extension("x-ms-required", false) @path team: string,

  ...Parameters.`api-Version-preview`.`1`,

  /** Test session details for creation */
  @body body: TestSession,
): TestSession;

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
    model `6` {
      /** Version of the API to use. This should be set to '7.2-preview.6' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
    model `7` {
      /** Version of the API to use. This should be set to '7.2-preview.7' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
