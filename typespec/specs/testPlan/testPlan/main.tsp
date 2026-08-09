import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "TestPlan" })
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
namespace TestPlan;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Actual Test Result Settings for a Test Plan */
model ActualTestResultSettings {
  /** Enable actual results field usage for test step result in the test plan during test execution */
  isActualTestResultEnabled?: boolean;

  /** Mandate actual results field usage for test step result in the test plan during test execution */
  isActualTestResultMandatory?: boolean;
}

/** The build definition reference resource */
model BuildDefinitionReference {
  /** ID of the build definition */
  id?: int32;

  /** Name of the build definition */
  name?: string;
}

/** Common Response for clone operation */
model CloneOperationCommonResponse {
  cloneStatistics?: CloneStatistics;

  /** Completion data of the operation */
  completionDate?: utcDateTime;

  /** Creation data of the operation */
  creationDate?: utcDateTime;

  links?: ReferenceLinks;

  /** Message related to the job */
  message?: string;

  /** Clone operation Id */
  opId?: int32;

  /** Clone operation state */
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

model CloneTestCaseOperationInformation {
  cloneOperationResponse?: CloneOperationCommonResponse;
  cloneOptions?: CloneTestCaseOptions;
  destinationTestSuite?: TestSuiteReferenceWithProject;
  sourceTestSuite?: SourceTestSuiteResponse;
}

model CloneTestCaseOptions {
  /** If set to true, include the attachments */
  includeAttachments?: boolean;

  /** If set to true, include the links */
  includeLinks?: boolean;

  /** Comment on the link that will link the new clone test case to the original Set null for no comment */
  relatedLinkComment?: string;
}

/** Parameters for Test Suite clone operation */
model CloneTestCaseParams {
  cloneOptions?: CloneTestCaseOptions;
  destinationTestPlan?: TestPlanReference;
  destinationTestSuite?: DestinationTestSuiteInfo;
  sourceTestPlan?: TestPlanReference;
  sourceTestSuite?: SourceTestSuiteInfo;

  /** Test Case IDs */
  testCaseIds?: int32[];
}

/** Response for Test Plan clone operation */
model CloneTestPlanOperationInformation {
  cloneOperationResponse?: CloneOperationCommonResponse;
  cloneOptions?: CloneOptions;
  destinationTestPlan?: TestPlan;
  sourceTestPlan?: SourceTestplanResponse;
}

/** Parameters for Test Plan clone operation */
model CloneTestPlanParams {
  cloneOptions?: CloneOptions;
  destinationTestPlan?: DestinationTestPlanCloneParams;
  sourceTestPlan?: SourceTestPlanInfo;
}

/** Response for Test Suite clone operation */
model CloneTestSuiteOperationInformation {
  clonedTestSuite?: TestSuiteReferenceWithProject;
  cloneOperationResponse?: CloneOperationCommonResponse;
  cloneOptions?: CloneOptions;
  destinationTestSuite?: TestSuiteReferenceWithProject;
  sourceTestSuite?: TestSuiteReferenceWithProject;
}

/** Parameters for Test Suite clone operation */
model CloneTestSuiteParams {
  cloneOptions?: CloneOptions;
  destinationTestSuite?: DestinationTestSuiteInfo;
  sourceTestSuite?: SourceTestSuiteInfo;
}

/** Configuration of the Test Point */
model Configuration {
  /** Id of the Configuration Assigned to the Test Point */
  configurationId?: int32;
}

/** This data model is used in TestRunDataProvider and provides the TestCaseResultsData for a Test run */
model CustomTestCaseResultData {
  area?: ShallowReference;

  /** Reference to bugs linked to test result. */
  associatedBugs?: ShallowReference[];

  /** Fully qualified name of test executed. */
  automatedTestName?: string;

  /** Container to which test belongs. */
  automatedTestStorage?: string;

  build?: ShallowReference;

  /** Machine name where test executed. */
  computerName?: string;

  configuration?: ShallowReference;

  /** Duration of test execution in milliseconds. If not provided value will be set as CompletedDate - StartedDate */
  durationInMs?: float64;

  /** Error message in test execution. */
  errorMessage?: string;

  /** ID of a test result. */
  id?: int32;

  /** Iteration path of test. */
  iterationPath?: string;

  /** Test outcome of test result. Valid values = (Unspecified, None, Passed, Failed, Inconclusive, Timeout, Aborted, Blocked, NotExecuted, Warning, Error, NotApplicable, Paused, InProgress, NotImpacted) */
  outcome?: string;

  owner?: IdentityRef;

  /** Priority of test executed. */
  priority?: int32;

  runBy?: IdentityRef;

  /** Stacktrace with maxSize= 1000 chars. */
  stackTrace?: string;

  testCase?: ShallowReference;

  /** Reference ID of test used by test result. Type TestResultMetaData */
  testCaseReferenceId?: int32;

  testRun?: ShallowReference;
  testSuite?: ShallowReference;
}

/** This data model is used in TestRunsListDataProvider and provides Test Run Data */
model CustomTestRunData {
  /** Build Id. */
  buildId?: int32;

  /** Build Name. */
  buildName?: string;

  /** Completed date time of the run. */
  completedDate?: utcDateTime;

  /** Created date time of the run. */
  createdDate?: utcDateTime;

  /** Duration of the run execution in milliseconds */
  durationInMs?: float64;

  /** No. of tests failed in the run */
  failedTestsCount?: int32;

  /** ID of the Test run. */
  id?: int32;

  /** Last updated date time of the run. */
  lastUpdatedDate?: utcDateTime;

  /** Name of the Test run. */
  name?: string;

  owner?: IdentityRef;

  /** Pass rate of the run */
  passRate?: string;

  /** Pipeline run Id where test run is executed. It can either be a build or a release. */
  pipelineRunId?: string;

  /** Pipeline run name where test run is executed. It can either be a build or a release. */
  pipelineRunName?: string;

  /** Release Id where test run is executed. */
  releaseId?: int32;

  /** Release Name where test run is executed. */
  releaseUri?: string;

  /** The state of the run. Type TestRunState Valid states - Unspecified ,NotStarted, InProgress, Completed, Waiting, Aborted, NeedsInvestigation */
  state?: string;

  /** Id of the Test plan associated with this Test run. */
  testPlanId?: int32;

  /** Name of the Test plan associated with this Test run. */
  testPlanName?: string;
}

/** Destination Test Plan create parameters */
model DestinationTestPlanCloneParams {
  ...TestPlanCreateParams;

  /** Destination Project Name */
  project?: string;
}

/** Destination Test Suite information for Test Suite clone operation */
model DestinationTestSuiteInfo {
  /** Destination Suite Id */
  id?: int32;

  /** Destination Project Name */
  project?: string;
}

/** Parameters for test case export operation */
model ExportTestCaseParams {
  /** Columns needs to be exported */
  columnOptions?: string[];

  /** Test Case IDs to exported */
  testCaseIds?: int32[];

  /** ID of test plan containing test cases */
  testPlanId?: int32;

  /** ID of test suite containing test cases */
  testSuiteId?: int32;
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

/** Last result details of test point. */
model LastResultDetails {
  /** Completed date of last result. */
  dateCompleted?: utcDateTime;

  /** Duration of the last result in milliseconds. */
  duration?: int64;

  runBy?: IdentityRef;
}

/** This data model is used in Work item-based tabs of Test Plans Library. */
model LibraryWorkItemsData {
  /** Specifies the column option field names */
  columnOptions?: string[];

  /** Continuation token to fetch next set of elements. Present only when HasMoreElements is true. */
  continuationToken?: string;

  /** Boolean indicating if the WIQL query has exceeded the limit of items returned. */
  exceededWorkItemQueryLimit?: boolean;

  /** Boolean indicating if there are more elements present than what are being sent. */
  hasMoreElements?: boolean;

  /** Specifies if there was an error while execution of data provider. */
  @extension(
    "x-ms-enum",
    #{
      name: "LibraryTestCasesDataReturnCode",
      values: #[#{ value: "success", description: "" }, #{ value: "error", description: "" }],
    }
  )
  returnCode?: "success" | "error";

  /** List of work items returned when OrderByField is sent something other than Id. */
  workItemIds?: int32[];

  /** List of work items to be returned. */
  workItems?: WorkItemDetails[];
}

/** This is the request data contract for LibraryTestCaseDataProvider. */
model LibraryWorkItemsDataProviderRequest {
  /** Specifies the list of column options to show in test cases table. */
  columnOptions?: string[];

  /** The continuation token required for paging of work items. This is required when getting subsequent sets of work items when OrderByField is Id. */
  continuationToken?: string;

  /** List of filter values to be supplied. Currently supported filters are Title, State, AssignedTo, Priority, AreaPath. */
  filterValues?: TestPlansLibraryWorkItemFilter[];

  /** Whether the data is to be sorted in ascending or descending order. When not supplied, defaults to descending. */
  isAscending?: boolean;

  /** The type of query to run. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestPlansLibraryQuery",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "allTestCases", description: "" },
        #{ value: "testCasesWithActiveBugs", description: "" },
        #{ value: "testCasesNotLinkedToRequirements", description: "" },
        #{ value: "testCasesLinkedToRequirements", description: "" },
        #{ value: "allSharedSteps", description: "" },
        #{ value: "sharedStepsNotLinkedToRequirement", description: "" }
      ],
    }
  )
  libraryQueryType?:
    | "none"
    | "allTestCases"
    | "testCasesWithActiveBugs"
    | "testCasesNotLinkedToRequirements"
    | "testCasesLinkedToRequirements"
    | "allSharedSteps"
    | "sharedStepsNotLinkedToRequirement";

  /** Work item field on which to order the results. When not supplied, defaults to work item IDs. */
  orderByField?: string;

  /** List of work items to query for field details. This is required when getting subsequent sets of work item fields when OrderByField is other than Id. */
  workItemIds?: int32[];
}

/** Name value pair */
model NameValuePair {
  /** Name */
  name?: string;

  /** Value */
  value?: string;
}

/** Assignments for the Test Point */
model PointAssignment {
  ...Configuration;

  /** Name of the Configuration Assigned to the Test Point */
  configurationName?: string;

  /** Id of the Test Point */
  id?: int32;

  tester?: IdentityRef;
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

/** Results class for Test Point */
model Results {
  /** Outcome of the Test Point */
  @extension(
    "x-ms-enum",
    #{
      name: "Outcome",
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
        #{ value: "notImpacted", description: "Test is not impacted. Added fot TIA." },
        #{ value: "maxValue", description: "" }
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
    | "notImpacted"
    | "maxValue";
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

/** This data model is used in SkinnyTestCaseResultDataProvider and provides the skinny TestCaseResultsData for a Test run */
model SkinnyTestCaseResultData {
  /** Container to which test belongs. */
  automatedTestStorage?: string;

  configuration?: ShallowReference;

  /** ID of a test result. */
  id?: int32;

  /** Test outcome of test result. Valid values = (Unspecified, None, Passed, Failed, Inconclusive, Timeout, Aborted, Blocked, NotExecuted, Warning, Error, NotApplicable, Paused, InProgress, NotImpacted) */
  outcome?: string;

  owner?: IdentityRef;

  /** Priority of the test case result. */
  priority?: int32;

  testCase?: ShallowReference;
}

/** Source Test Plan information for Test Plan clone operation */
model SourceTestPlanInfo {
  /** ID of the source Test Plan */
  id?: int32;

  /** Id of suites to be cloned inside source Test Plan */
  suiteIds?: int32[];
}

/** Source Test Plan Response for Test Plan clone operation */
model SourceTestplanResponse {
  ...TestPlanReference;
  project?: TeamProjectReference;

  /** Id of suites to be cloned inside source Test Plan */
  suiteIds?: int32[];
}

/** Source Test Suite information for Test Suite clone operation */
model SourceTestSuiteInfo {
  /** Id of the Source Test Suite */
  id?: int32;
}

/** Source Test Suite Response for Test Case clone operation */
model SourceTestSuiteResponse {
  ...TestSuiteReference;
  project?: TeamProjectReference;

  /** Id of suites to be cloned inside source Test Plan */
  testCaseIds?: int32[];
}

/** A suite entry defines properties for a test suite. */
model SuiteEntry {
  ...SuiteEntryUpdateParams;

  /** Id for the test suite. */
  suiteId?: int32;
}

/** A suite entry defines properties for a test suite. */
model SuiteEntryUpdateParams {
  /** Id of the suite entry in the test suite: either a test case id or child suite id. */
  id?: int32;

  /** Sequence number for the suite entry object in the test suite. */
  sequenceNumber?: int32;

  /** Defines whether the entry is of type test case or suite. */
  @extension(
    "x-ms-enum",
    #{
      name: "SuiteEntryTypes",
      values: #[
        #{ value: "testCase", description: "Test Case" },
        #{ value: "suite", description: "Child Suite" }
      ],
    }
  )
  suiteEntryType?: "testCase" | "suite";
}

/** Create and Update Suite Test Case Parameters */
model SuiteTestCaseCreateUpdateParameters {
  /** Configurations Ids */
  pointAssignments?: Configuration[];

  workItem?: WorkItem;
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

/** Test Case Class */
model TestCase {
  links?: ReferenceLinks;

  /** Order of the TestCase in the Suite */
  order?: int32;

  /** List of Points associated with the Test Case */
  pointAssignments?: PointAssignment[];

  project?: TeamProjectReference;
  testPlan?: TestPlanReference;
  testSuite?: TestSuiteReference;
  workItem?: WorkItemDetails;
}

model TestCaseAssociatedResult {
  completedDate?: utcDateTime;
  configuration?: TestConfigurationReference;
  @extension(
    "x-ms-enum",
    #{
      name: "UserFriendlyTestOutcome",
      values: #[
        #{ value: "inProgress", description: "" },
        #{ value: "blocked", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "passed", description: "" },
        #{ value: "ready", description: "" },
        #{ value: "notApplicable", description: "" },
        #{ value: "paused", description: "" },
        #{ value: "timeout", description: "" },
        #{ value: "warning", description: "" },
        #{ value: "error", description: "" },
        #{ value: "notExecuted", description: "" },
        #{ value: "inconclusive", description: "" },
        #{ value: "aborted", description: "" },
        #{ value: "none", description: "" },
        #{ value: "notImpacted", description: "" },
        #{ value: "unspecified", description: "" },
        #{ value: "maxValue", description: "" }
      ],
    }
  )
  outcome?:
    | "inProgress"
    | "blocked"
    | "failed"
    | "passed"
    | "ready"
    | "notApplicable"
    | "paused"
    | "timeout"
    | "warning"
    | "error"
    | "notExecuted"
    | "inconclusive"
    | "aborted"
    | "none"
    | "notImpacted"
    | "unspecified"
    | "maxValue";
  plan?: TestPlanReference;
  pointId?: int32;
  resultId?: int32;
  runBy?: IdentityRef;
  runId?: int32;
  suite?: TestSuiteReference;
  tester?: IdentityRef;
}

model TestCaseAssociatedResultExtended {
  ...TestCaseAssociatedResult;
  areaPath?: string;
  buildPipeline?: ShallowReference;
  iterationPath?: string;
  owner?: IdentityRef;
}

/** Data for a test case. */
model TestCaseData {
  /** Steps for the test case. */
  steps?: string;

  /** Title of the test case. */
  title?: string;
}

/** This data model is used in TestCaseLatestOutcomeDataProvider and provides latest outcome data for test case */
model TestCaseLatestOutcomeData {
  /** Date when the test result was completed. */
  completedDate?: utcDateTime;

  /** Reference to test configuration. */
  configurationId?: int32;

  /** Date when the test result was last updated. */
  lastUpdatedDate?: utcDateTime;

  /** Outcome of the test case. Valid values = (Unspecified, None, Passed, Failed, Inconclusive, Timeout, Aborted, Blocked, NotExecuted, Warning, Error, NotApplicable, Paused, InProgress, NotImpacted) */
  outcome?: string;

  /** Test Point ID whose outcome is represented by this object. */
  pointId?: int32;

  /** Test Case ID whose outcome is represented by this object. */
  testCaseId?: int32;

  /** Reference ID of test used by test result. */
  testCaseReferenceId?: int32;

  /** Test Result ID whose outcome is represented by this object. */
  testResultId?: int32;

  /** Test Run ID whose outcome is represented by this object. */
  testRunId?: int32;
}

/** Test Case Reference */
model TestCaseReference {
  assignedTo?: IdentityRef;

  /** Test Case Id */
  id?: int32;

  /** Test Case Name */
  name?: string;

  /** State of the test case work item */
  state?: string;
}

/** This data model is used in TestCaseResultsDataProvider and populates the data required for initial page load */
model TestCaseResultsData {
  contextPoint?: TestPointDetailedReference;

  /** Use to store the results displayed in the table */
  results?: TestCaseAssociatedResult[];

  /** Test Case Name to be displayed in the table header */
  testCaseName?: string;
}

/** This data model is used in TestCaseResultsDataProvider for extended data to populates the data required for initial page load */
model TestCaseResultsDataExtended {
  contextPoint?: TestPointDetailedReference;

  /** Use to store the results displayed in the table */
  results?: TestCaseAssociatedResultExtended[];

  /** Test Case Name to be displayed in the table header */
  testCaseName?: string;
}

/** Test configuration */
model TestConfiguration {
  ...TestConfigurationCreateUpdateParameters;

  /** Id of the configuration */
  id?: int32;

  project?: TeamProjectReference;
}

/** Test Configuration Create or Update Parameters */
model TestConfigurationCreateUpdateParameters {
  /** Description of the configuration */
  description?: string;

  /** Is the configuration a default for the test plans */
  isDefault?: boolean;

  /** Name of the configuration */
  name?: string;

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

  /** Dictionary of Test Variable, Selected Value */
  values?: NameValuePair[];
}

/** Test Configuration Reference */
model TestConfigurationReference {
  /** Id of the configuration */
  id?: int32;

  /** Name of the configuration */
  name?: string;
}

/** Test Entity Count Used to store test cases count (define tab) and test point count (execute tab) Used to store test cases count (define tab) and test point count (execute tab) */
model TestEntityCount {
  /** Test Entity Count */
  count?: int32;

  /** Test Plan under which the Test Entities are */
  testPlanId?: int32;

  /** Test Suite under which the Test Entities are */
  testSuiteId?: int32;

  /** Total test entities in the suite without the applied filters */
  totalCount?: int32;
}

/** Test environment Detail. */
model TestEnvironment {
  /** Test Environment Id. */
  @format("uuid") environmentId?: string;

  /** Test Environment Name. */
  environmentName?: string;
}

/** Test outcome settings */
model TestOutcomeSettings {
  /** Value to configure how test outcomes for the same tests across suites are shown */
  syncOutcomeAcrossSuites?: boolean;
}

/** The test plan resource. */
model TestPlan {
  ...TestPlanUpdateParams;
  _links?: ReferenceLinks;

  /** ID of the test plan. */
  id?: int32;

  /** Previous build Id associated with the test plan */
  previousBuildId?: int32;

  project?: TeamProjectReference;
  rootSuite?: TestSuiteReference;
  updatedBy?: IdentityRef;

  /** Updated date of the test plan */
  updatedDate?: utcDateTime;
}

/** Test Plan/Suite restore request body params */
model TestPlanAndSuiteRestoreModel {
  /** Indicates whether the deleted test plan/suite should be restored. */
  isDeleted?: boolean;
}

/** The test plan create parameters. */
model TestPlanCreateParams {
  actualTestResultSettings?: ActualTestResultSettings;

  /** Area of the test plan. */
  areaPath?: string;

  buildDefinition?: BuildDefinitionReference;

  /** Build to be tested. */
  buildId?: int32;

  /** Description of the test plan. */
  description?: string;

  /** End date for the test plan. */
  endDate?: utcDateTime;

  /** Iteration path of the test plan. */
  iteration?: string;

  /** Name of the test plan. */
  name?: string;

  owner?: IdentityRef;
  releaseEnvironmentDefinition?: ReleaseEnvironmentDefinitionReference;

  /** Start date for the test plan. */
  startDate?: utcDateTime;

  /** State of the test plan. */
  state?: string;

  testOutcomeSettings?: TestOutcomeSettings;
  yamlReleaseReference?: YamlReleaseReference;
}

/** The test plan detailed reference resource. Contains additional workitem realted information */
model TestPlanDetailedReference {
  ...TestPlanReference;

  /** Area of the test plan. */
  areaPath?: string;

  /** End date for the test plan. */
  endDate?: utcDateTime;

  /** Iteration path of the test plan. */
  iteration?: string;

  /** Root Suite Id */
  rootSuiteId?: int32;

  /** Start date for the test plan. */
  startDate?: utcDateTime;
}

/** The test plan reference resource. */
model TestPlanReference {
  /** ID of the test plan. */
  id?: int32;

  /** Name of the test plan. */
  name?: string;
}

/** This data model is used in TestPlansHubRefreshDataProvider and populates the data required for initial page load */
model TestPlansHubRefreshData {
  defineColumnOptionFields?: string[];
  defineTabCustomColumnFieldMap?: Record<string>;
  errorMessage?: string;
  executeColumnOptionFields?: string[];
  executeTabCustomColumnFieldMap?: Record<string>;
  isAdvancedExtensionEnabled?: boolean;
  selectedPivotId?: string;
  selectedSuiteId?: int32;
  testCasePageSize?: int32;
  testCases?: TestCase[];
  testCasesContinuationToken?: string;
  testPlan?: TestPlanDetailedReference;
  testPointPageSize?: int32;
  testPoints?: TestPoint[];
  testPointsContinuationToken?: string;
  testSuites?: TestSuite[];
  testSuitesContinuationToken?: string;
}

/** Container to hold information about a filter being applied in Test Plans Library. */
model TestPlansLibraryWorkItemFilter {
  /** Work item field name on which the items are to be filtered. */
  fieldName?: string;

  /** Work item field values corresponding to the field name. */
  fieldValues?: string[];

  /** Mode of the filter. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestPlansLibraryWorkItemFilterMode",
      values: #[
        #{ value: "or", description: "Default. Have the field values separated by an OR clause." },
        #{ value: "and", description: "Have the field values separated by an AND clause." }
      ],
    }
  )
  filterMode?: "or" | "and";
}

/** The test plan update parameters. */
model TestPlanUpdateParams {
  ...TestPlanCreateParams;

  /** Revision of the test plan. */
  revision?: int32;
}

/** Parameters for creating a test plan with test cases. */
model TestPlanWithTestCasesCreateParams {
  /** Area path for the test plan. */
  areaPath?: string;

  /** Feature work item ID associated with the test plan. */
  featureWorkItemId?: int32;

  /** List of test case data. */
  testCaseData?: TestCaseData[];

  /** Description of the test plan. */
  testPlanDescription?: string;

  /** Name of the test plan. */
  testPlanName?: string;
}

/** Test Point Class */
model TestPoint {
  /** Comment associated to the Test Point */
  comment?: string;

  configuration?: TestConfigurationReference;

  /** Id of the Test Point */
  id?: int32;

  /** Variable to decide whether the test case is Active or not */
  isActive?: boolean;

  /** Is the Test Point for Automated Test Case or Manual */
  isAutomated?: boolean;

  /** Last Reset to Active Time Stamp for the Test Point */
  lastResetToActive?: utcDateTime;

  lastUpdatedBy?: IdentityRef;

  /** Last Update Time Stamp for the Test Point */
  lastUpdatedDate?: utcDateTime;

  links?: ReferenceLinks;
  project?: TeamProjectReference;
  results?: TestPointResults;
  testCaseReference?: TestCaseReference;
  tester?: IdentityRef;
  testPlan?: TestPlanReference;
  testSuite?: TestSuiteReference;
}

model TestPointDetailedReference {
  configuration?: TestConfigurationReference;
  plan?: TestPlanReference;
  pointId?: int32;
  suite?: TestSuiteReference;
  tester?: IdentityRef;
}

/** Test Point Results */
model TestPointResults {
  /** Failure Type for the Test Point */
  @extension(
    "x-ms-enum",
    #{
      name: "FailureType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "regression", description: "" },
        #{ value: "new_Issue", description: "" },
        #{ value: "known_Issue", description: "" },
        #{ value: "unknown", description: "" },
        #{ value: "null_Value", description: "" },
        #{ value: "maxValue", description: "" }
      ],
    }
  )
  failureType?:
    | "none"
    | "regression"
    | "new_Issue"
    | "known_Issue"
    | "unknown"
    | "null_Value"
    | "maxValue";

  /** Last Resolution State Id for the Test Point */
  @extension(
    "x-ms-enum",
    #{
      name: "LastResolutionState",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "needsInvestigation", description: "" },
        #{ value: "testIssue", description: "" },
        #{ value: "productIssue", description: "" },
        #{ value: "configurationIssue", description: "" },
        #{ value: "nullValue", description: "" },
        #{ value: "maxValue", description: "" }
      ],
    }
  )
  lastResolutionState?:
    | "none"
    | "needsInvestigation"
    | "testIssue"
    | "productIssue"
    | "configurationIssue"
    | "nullValue"
    | "maxValue";

  lastResultDetails?: LastResultDetails;

  /** Last Result Id */
  lastResultId?: int32;

  /** Last Result State of the Test Point */
  @extension(
    "x-ms-enum",
    #{
      name: "ResultState",
      values: #[
        #{
          value: "unspecified",
          description: "Only used during an update to preserve the existing value.",
        },
        #{ value: "pending", description: "Test is in the execution queue, was not started yet." },
        #{
          value: "queued",
          description: "Test has been queued. This is applicable when a test case is queued for execution",
        },
        #{ value: "inProgress", description: "Test is currently executing." },
        #{
          value: "paused",
          description: "Test has been paused. This is applicable when a test case is paused by the user (For e.g. Manual Tester can pause the execution of the manual test case)",
        },
        #{
          value: "completed",
          description: "Test has completed, but there is no quantitative measure of completeness. This may apply to load tests.",
        },
        #{ value: "maxValue", description: "" }
      ],
    }
  )
  lastResultState?:
    | "unspecified"
    | "pending"
    | "queued"
    | "inProgress"
    | "paused"
    | "completed"
    | "maxValue";

  /** Last RUn Build Number for the Test Point */
  lastRunBuildNumber?: string;

  /** Last Test Run Id for the Test Point */
  lastTestRunId?: int32;

  /** Outcome of the Test Point */
  @extension(
    "x-ms-enum",
    #{
      name: "Outcome",
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
        #{ value: "notImpacted", description: "Test is not impacted. Added fot TIA." },
        #{ value: "maxValue", description: "" }
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
    | "notImpacted"
    | "maxValue";

  /** State of the Test Point */
  @extension(
    "x-ms-enum",
    #{
      name: "PointState",
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

/** Test Point Update Parameters */
model TestPointUpdateParams {
  /** Id of Test Point to be updated */
  id?: int32;

  /** Reset the Test Point to Active */
  isActive?: boolean;

  results?: Results;
  tester?: IdentityRef;
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

/** Test suite */
model TestSuite {
  ...TestSuiteCreateParams;
  _links?: ReferenceLinks;

  /** Child test suites of current test suite. */
  children?: TestSuite[];

  /** Boolean value dictating if Child test suites are present */
  hasChildren?: boolean;

  /** Id of test suite. */
  id?: int32;

  /** Last error for test suite. */
  lastError?: string;

  /** Last populated date. */
  lastPopulatedDate?: utcDateTime;

  lastUpdatedBy?: IdentityRef;

  /** Last update date. */
  lastUpdatedDate?: utcDateTime;

  plan?: TestPlanReference;
  project?: TeamProjectReference;

  /** Test suite revision. */
  revision?: int32;
}

/** Test suite Create Parameters */
model TestSuiteCreateParams {
  ...TestSuiteCreateUpdateCommonParams;

  /** Test suite requirement id. */
  requirementId?: int32;

  /** Test suite type. */
  @extension(
    "x-ms-enum",
    #{
      name: "TestSuiteType",
      values: #[
        #{ value: "none", description: "Default suite type" },
        #{ value: "dynamicTestSuite", description: "Query Based test Suite" },
        #{ value: "staticTestSuite", description: "Static Test Suite" },
        #{ value: "requirementTestSuite", description: "Requirement based Test Suite" }
      ],
    }
  )
  suiteType?: "none" | "dynamicTestSuite" | "staticTestSuite" | "requirementTestSuite";
}

/** Test Suite Create/Update Common Parameters */
model TestSuiteCreateUpdateCommonParams {
  /** Test suite default configurations. */
  defaultConfigurations?: TestConfigurationReference[];

  /** Test suite default testers. */
  defaultTesters?: IdentityRef[];

  /** Default configuration was inherited or not. */
  inheritDefaultConfigurations?: boolean;

  /** Name of test suite. */
  name?: string;

  parentSuite?: TestSuiteReference;

  /** Test suite query string, for dynamic suites. */
  queryString?: string;
}

/** The test suite reference resource. */
model TestSuiteReference {
  /** ID of the test suite. */
  id?: int32;

  /** Name of the test suite. */
  name?: string;
}

/** Test Suite Reference with Project */
model TestSuiteReferenceWithProject {
  ...TestSuiteReference;
  project?: TeamProjectReference;
}

/** Test Suite Update Parameters */
model TestSuiteUpdateParams {
  ...TestSuiteCreateUpdateCommonParams;

  /** Test suite revision. */
  revision?: int32;
}

/** Test Variable */
model TestVariable {
  ...TestVariableCreateUpdateParameters;

  /** Id of the test variable */
  id?: int32;

  project?: TeamProjectReference;
}

/** Test Variable Create or Update Parameters */
model TestVariableCreateUpdateParameters {
  /** Description of the test variable */
  description?: string;

  /** Name of the test variable */
  name?: string;

  /** List of allowed values */
  values?: string[];
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

/** Work Item */
model WorkItem {
  /** Id of the Work Item */
  id?: int32;
}

/** Work Item Class */
model WorkItemDetails {
  /** Work Item Id */
  id?: int32;

  /** Work Item Name */
  name?: string;

  /** Work Item Fields */
  workItemFields?: {}[];
}

/** Reference to yaml release resource. */
model YamlReleaseReference {
  /** ID of the yaml release definition */
  definitionId?: int32;

  /** Stages to skip while queuing yaml release. */
  stagesToSkip?: string;
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

interface TestSuites {
  /** Find the list of all test suites in which a given test case is present. This is helpful if you need to find out which test suites are using a test case, when you need to make changes to a test case. */
  @tag("Test  Suites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suites")
  @extension("x-ms-vss-method", "GetSuitesByTestCaseId")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/testplan/suites")
  @get
  GetSuitesByTestCaseId(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** ID of the test case for which suites need to be fetched. */
    @query(#{ explode: true }) testCaseId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<TestSuite[]>;

  /** Get test suites for plan. */
  @tag("Test  Suites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suites")
  @extension("x-ms-vss-method", "GetTestSuitesForPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/suites")
  @get
  GetTestSuitesForPlan(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan for which suites are requested. */
    @path planId: int32,

    /** Include the children suites and testers details. */
    @extension(
      "x-ms-enum",
      #{
        name: "SuiteExpand",
        values: #[
          #{ value: "none", description: "Dont include any of the expansions in output." },
          #{ value: "children", description: "Include children in response." },
          #{ value: "defaultTesters", description: "Include default testers in response." }
        ],
      }
    )
    @query(#{ explode: true })
    expand?: "none" | "children" | "defaultTesters",

    /** If the list of suites returned is not complete, a continuation token to query next batch of suites is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test suites. */
    @query(#{ explode: true }) continuationToken?: string,

    /** If the suites returned should be in a tree structure. */
    @query(#{ explode: true }) asTreeView?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestSuite[];
  };

  /** Create test suite. */
  @tag("Test  Suites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suites")
  @extension("x-ms-vss-method", "CreateTestSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/suites")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan that contains the suites. */
    @path planId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Parameters for suite creation */
    @body body: TestSuiteCreateParams,
  ): TestSuite;

  /** Delete test suite. */
  @tag("Test  Suites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suites")
  @extension("x-ms-vss-method", "DeleteTestSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/suites/{suiteId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan that contains the suite. */
    @path planId: int32,

    /** ID of the test suite to delete. */
    @path suiteId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get test suite by suite id. */
  @tag("Test  Suites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suites")
  @extension("x-ms-vss-method", "GetTestSuiteById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/suites/{suiteId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan that contains the suites. */
    @path planId: int32,

    /** ID of the suite to get. */
    @path suiteId: int32,

    /** Include the children suites and testers details */
    @extension(
      "x-ms-enum",
      #{
        name: "SuiteExpand",
        values: #[
          #{ value: "none", description: "Dont include any of the expansions in output." },
          #{ value: "children", description: "Include children in response." },
          #{ value: "defaultTesters", description: "Include default testers in response." }
        ],
      }
    )
    @query(#{ explode: true })
    expand?: "none" | "children" | "defaultTesters",

    ...Parameters.`api-Version-preview`.`1`,
  ): TestSuite;

  /** Update test suite. */
  @tag("Test  Suites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suites")
  @extension("x-ms-vss-method", "UpdateTestSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/suites/{suiteId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan that contains the suites. */
    @path planId: int32,

    /** ID of the parent suite. */
    @path suiteId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Parameters for suite updation */
    @body body: TestSuiteUpdateParams,
  ): TestSuite;
}

interface Configurations {
  /** Delete a test configuration by its ID. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "DeleteTestConfguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/configurations")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test configuration to delete. */
    @query(#{ explode: true }) testConfiguartionId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a list of test configurations. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "GetTestConfigurations")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/configurations")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** If the list of configurations returned is not complete, a continuation token to query next batch of configurations is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test configurations. */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestConfiguration[];
  };

  /** Update a test configuration by its ID. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "UpdateTestConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/configurations")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test configuration to update. */
    @query(#{ explode: true }) testConfiguartionId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** TestConfigurationCreateUpdateParameters */
    @body body: TestConfigurationCreateUpdateParameters,
  ): TestConfiguration;

  /** Create a test configuration. */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "CreateTestConfiguration")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/configurations")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** TestConfigurationCreateUpdateParameters */
    @body body: TestConfigurationCreateUpdateParameters,
  ): TestConfiguration;

  /** Get a test configuration */
  @tag("Configurations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "configurations")
  @extension("x-ms-vss-method", "GetTestConfigurationById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/configurations/{testConfigurationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test configuration to get. */
    @path testConfigurationId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestConfiguration;
}

interface TestPlans {
  /** Get a list of test plans */
  @tag("Test  Plans")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "plans")
  @extension("x-ms-vss-method", "GetTestPlans")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/plans")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Filter for test plan by owner ID or name */
    @query(#{ explode: true }) owner?: string,

    /** If the list of plans returned is not complete, a continuation token to query next batch of plans is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test plans. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Get all properties of the test plan */
    @query(#{ explode: true }) includePlanDetails?: boolean,

    /** Get just the active plans */
    @query(#{ explode: true }) filterActivePlans?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestPlan[];
  };

  /** Create a test plan. */
  @tag("Test  Plans")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "plans")
  @extension("x-ms-vss-method", "CreateTestPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/plans")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** A testPlanCreateParams object.TestPlanCreateParams */
    @body body: TestPlanCreateParams,
  ): TestPlan;

  /** Delete a test plan. */
  @tag("Test  Plans")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "plans")
  @extension("x-ms-vss-method", "DeleteTestPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/plans/{planId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan to be deleted. */
    @path planId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a test plan by Id. */
  @tag("Test  Plans")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "plans")
  @extension("x-ms-vss-method", "GetTestPlanById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/plans/{planId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan to get. */
    @path planId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestPlan;

  /** Update a test plan. */
  @tag("Test  Plans")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "plans")
  @extension("x-ms-vss-method", "UpdateTestPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/plans/{planId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan to be updated. */
    @path planId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** A testPlanUpdateParams object.TestPlanUpdateParams */
    @body body: TestPlanUpdateParams,
  ): TestPlan;
}

interface SuiteTestCase {
  /** Removes test cases from a suite based on the list of test case Ids provided. This API can be used to remove a larger number of test cases. */
  @tag("Suite Test Case")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "suiteTestCase")
  @extension("x-ms-vss-method", "RemoveTestCasesListFromSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestCase")
  @delete
  RemoveTestCasesListFromSuite(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan from which test cases are to be removed. */
    @path planId: int32,

    /** ID of the test suite from which test cases are to be removed. */
    @path suiteId: int32,

    /** Comma separated string of Test Case Ids to be removed. */
    @query(#{ explode: true }) testIds: string,

    ...Parameters.`api-Version-preview`.`3`,
  ): OkResponse;

  /** Get Test Case List return those test cases which have all the configuration Ids as mentioned in the optional parameter. If configuration Ids is null, it return all the test cases */
  @tag("Suite Test Case")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "suiteTestCase")
  @extension("x-ms-vss-method", "GetTestCaseList")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestCase")
  @get
  GetTestCaseList(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan for which test cases are requested. */
    @path planId: int32,

    /** ID of the test suite for which test cases are requested. */
    @path suiteId: int32,

    /** Test Case Ids to be fetched. */
    @query(#{ explode: true }) testIds?: string,

    /** Fetch Test Cases which contains all the configuration Ids specified. */
    @query(#{ explode: true }) configurationIds?: string,

    /** Get the list of witFields. */
    @query(#{ explode: true }) witFields?: string,

    /** If the list of test cases returned is not complete, a continuation token to query next batch of test cases is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test cases. */
    @query(#{ explode: true }) continuationToken?: string,

    /** If set to true, returns all identity fields, like AssignedTo, ActivatedBy etc., as IdentityRef objects. If set to false, these fields are returned as unique names in string format. This is false by default. */
    @query(#{ explode: true }) returnIdentityRef?: boolean,

    /** If set to false, will get a smaller payload containing only basic details about the suite test case object */
    @query(#{ explode: true }) expand?: boolean,

    /** Flag to exclude various values from payload. For example to remove point assignments pass exclude = 1. To remove extra information (links, test plan , test suite) pass exclude = 2. To remove both extra information and point assignments pass exclude = 3 (1 + 2). */
    @extension(
      "x-ms-enum",
      #{
        name: "ExcludeFlags",
        values: #[
          #{ value: "none", description: "To exclude nothing" },
          #{
            value: "pointAssignments",
            description: "To exclude point assignments, pass exclude = 1",
          },
          #{
            value: "extraInformation",
            description: "To exclude extra information (links, test plan, test suite), pass exclude = 2",
          }
        ],
      }
    )
    @query(#{ explode: true })
    excludeFlags?: "none" | "pointAssignments" | "extraInformation",

    @query(#{ explode: true }) isRecursive?: boolean,
    ...Parameters.`api-Version-preview`.`3`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestCase[];
  };

  /** Update the configurations for test cases */
  @tag("Suite Test Case")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "suiteTestCase")
  @extension("x-ms-vss-method", "UpdateSuiteTestCases")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestCase")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan to which test cases are to be updated. */
    @path planId: int32,

    /** ID of the test suite to which test cases are to be updated. */
    @path suiteId: int32,

    ...Parameters.`api-Version-preview`.`3`,

    /** A SuiteTestCaseCreateUpdateParameters object. */
    @body body: SuiteTestCaseCreateUpdateParameters[],
  ): Body<TestCase[]>;

  /** Add test cases to a suite with specified configurations */
  @tag("Suite Test Case")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "suiteTestCase")
  @extension("x-ms-vss-method", "AddTestCasesToSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestCase")
  @post
  Add(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan to which test cases are to be added. */
    @path planId: int32,

    /** ID of the test suite to which test cases are to be added. */
    @path suiteId: int32,

    ...Parameters.`api-Version-preview`.`3`,

    /** SuiteTestCaseCreateUpdateParameters object. */
    @body body: SuiteTestCaseCreateUpdateParameters[],
  ): Body<TestCase[]>;

  /** Get a particular Test Case from a Suite. */
  @tag("Suite Test Case")
  @extension("x-ms-docs-override-version", "7.2-preview.3")
  @extension("x-ms-vss-resource", "suiteTestCase")
  @extension("x-ms-vss-method", "GetTestCase")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestCase/{testCaseId}")
  @get
  GetTestCase(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan for which test cases are requested. */
    @path planId: int32,

    /** ID of the test suite for which test cases are requested. */
    @path suiteId: int32,

    /** Test Case Id to be fetched. */
    @path testCaseId: string,

    /** Get the list of witFields. */
    @query(#{ explode: true }) witFields?: string,

    /** If set to true, returns all identity fields, like AssignedTo, ActivatedBy etc., as IdentityRef objects. If set to false, these fields are returned as unique names in string format. This is false by default. */
    @query(#{ explode: true }) returnIdentityRef?: boolean,

    ...Parameters.`api-Version-preview`.`3`,
  ): Body<TestCase[]>;
}

interface TestPointOperations {
  /** Get a particular Test Point from a suite. */
  @tag("Test Point")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testPoint")
  @extension("x-ms-vss-method", "GetPoints")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestPoint")
  @get
  GetPoints(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan for which test points are requested. */
    @path planId: int32,

    /** ID of the test suite for which test points are requested. */
    @path suiteId: int32,

    /** ID of test point to be fetched. */
    @query(#{ explode: true }) pointId: string,

    /** If set to true, returns the AssignedTo field in TestCaseReference as IdentityRef object. */
    @query(#{ explode: true }) returnIdentityRef?: boolean,

    /** If set to false, will get a smaller payload containing only basic details about the test point object */
    @query(#{ explode: true }) includePointDetails?: boolean,

    ...Parameters.`api-Version-preview`.`2`,
  ): Body<TestPoint[]>;

  /** Update Test Points. This is used to Reset test point to active, update the outcome of a test point or update the tester of a test point */
  @tag("Test Point")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testPoint")
  @extension("x-ms-vss-method", "UpdateTestPoints")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/{planId}/Suites/{suiteId}/TestPoint")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan for which test points are requested. */
    @path planId: int32,

    /** ID of the test suite for which test points are requested. */
    @path suiteId: int32,

    /** If set to false, will get a smaller payload containing only basic details about the test point object */
    @query(#{ explode: true }) includePointDetails?: boolean,

    /** If set to true, returns the AssignedTo field in TestCaseReference as IdentityRef object. */
    @query(#{ explode: true }) returnIdentityRef?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** A TestPointUpdateParams Object. */
    @body body: TestPointUpdateParams[],
  ): Body<TestPoint[]>;
}

interface TestPlanClone {
  /** Clone test plan */
  @tag("Test Plan Clone")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testPlanClone")
  @extension("x-ms-vss-method", "CloneTestPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/CloneOperation")
  @post
  CloneTestPlan(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Clones all the associated test cases as well */
    @query(#{ explode: true }) deepClone?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** Plan Clone Request Body detail TestPlanCloneRequest */
    @body body: CloneTestPlanParams,
  ): CloneTestPlanOperationInformation;

  /** Get clone information. */
  @tag("Test Plan Clone")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testPlanClone")
  @extension("x-ms-vss-method", "GetCloneInformation")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Plans/CloneOperation/{cloneOperationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Operation ID returned when we queue a clone operation */
    @path cloneOperationId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): CloneTestPlanOperationInformation;
}

interface TestPlanRecycleBin {
  /** Get a list of deleted test plans */
  @tag("Test  Plan  Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testPlan")
  @extension("x-ms-vss-method", "GetDeletedTestPlans")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/recycleBin/testplan")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** If the list of plans returned is not complete, a continuation token to query next batch of plans is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test plans. */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestPlan[];
  };

  /** Restores the deleted test plan */
  @tag("Test  Plan  Recycle  Bin")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testPlan")
  @extension("x-ms-vss-method", "RestoreDeletedTestPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/recycleBin/testplan/{planId}")
  @patch
  RestoreDeletedTestPlan(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID of the test plan to restore */
    @path planId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** The model containing the restore information */
    @body body: TestPlanAndSuiteRestoreModel,
  ): OkResponse;
}

interface TestSuiteRecycleBinOperations {
  /** Get Deleted Test Suites for a Test Plan. */
  @tag("Test  Suite  Recycle  Bin  Operations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testSuite")
  @extension("x-ms-vss-method", "GetDeletedTestSuitesForPlan")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/recycleBin/TestPlan/{planId}/testsuite")
  @get
  GetDeletedTestSuitesForPlan(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test plan for which suites are requested. */
    @path planId: int32,

    /** Include the children suites and testers details. */
    @extension(
      "x-ms-enum",
      #{
        name: "SuiteExpand",
        values: #[
          #{ value: "none", description: "Dont include any of the expansions in output." },
          #{ value: "children", description: "Include children in response." },
          #{ value: "defaultTesters", description: "Include default testers in response." }
        ],
      }
    )
    @query(#{ explode: true })
    expand?: "none" | "children" | "defaultTesters",

    /** If the list of suites returned is not complete, a continuation token to query next batch of suites is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test suites. */
    @query(#{ explode: true }) continuationToken?: string,

    /** If the suites returned should be in a tree structure. */
    @query(#{ explode: true }) asTreeView?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestSuite[];
  };

  /** Get Deleted Test Suites within a Project. */
  @tag("Test  Suite  Recycle  Bin  Operations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testSuite")
  @extension("x-ms-vss-method", "GetDeletedTestSuitesForProject")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/recycleBin/testsuite")
  @get
  GetDeletedTestSuitesForProject(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Include the children suites and testers details. */
    @extension(
      "x-ms-enum",
      #{
        name: "SuiteExpand",
        values: #[
          #{ value: "none", description: "Dont include any of the expansions in output." },
          #{ value: "children", description: "Include children in response." },
          #{ value: "defaultTesters", description: "Include default testers in response." }
        ],
      }
    )
    @query(#{ explode: true })
    expand?: "none" | "children" | "defaultTesters",

    /** If the list of suites returned is not complete, a continuation token to query next batch of suites is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test suites. */
    @query(#{ explode: true }) continuationToken?: string,

    /** If the suites returned should be in a tree structure. */
    @query(#{ explode: true }) asTreeView?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestSuite[];
  };

  /** Restores the deleted test suite */
  @tag("Test  Suite  Recycle  Bin  Operations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testSuite")
  @extension("x-ms-vss-method", "RestoreDeletedTestSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/recycleBin/testsuite/{suiteId}")
  @patch
  RestoreDeletedTestSuite(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** The ID of the test suite to restore */
    @path suiteId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** The model containing the restore information */
    @body body: TestPlanAndSuiteRestoreModel,
  ): OkResponse;
}

interface TestSuiteEntry {
  /** Get a list of test suite entries in the test suite. */
  @tag("Test  Suite  Entry")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suiteEntry")
  @extension("x-ms-vss-method", "GetSuiteEntries")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/suiteentry/{suiteId}")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the parent suite. */
    @path suiteId: int32,

    @extension(
      "x-ms-enum",
      #{
        name: "SuiteEntryTypes",
        values: #[
          #{ value: "testCase", description: "Test Case" },
          #{ value: "suite", description: "Child Suite" }
        ],
      }
    )
    @query(#{ explode: true })
    suiteEntryType?: "testCase" | "suite",
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<SuiteEntry[]>;

  /** Reorder test suite entries in the test suite. */
  @tag("Test  Suite  Entry")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "suiteEntry")
  @extension("x-ms-vss-method", "ReorderSuiteEntries")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/suiteentry/{suiteId}")
  @patch
  ReorderSuiteEntries(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of the parent test suite. */
    @path suiteId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** List of SuiteEntry to reorder. */
    @body body: SuiteEntryUpdateParams[],
  ): Body<SuiteEntry[]>;
}

interface TestSuiteClone {
  /** Clone test suite */
  @tag("Test Suite Clone")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testSuiteClone")
  @extension("x-ms-vss-method", "CloneTestSuite")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Suites/CloneOperation")
  @post
  CloneTestSuite(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Clones all the associated test cases as well */
    @query(#{ explode: true }) deepClone?: boolean,

    ...Parameters.`api-Version-preview`.`2`,

    /** Suite Clone Request Body detail TestSuiteCloneRequest */
    @body body: CloneTestSuiteParams,
  ): CloneTestSuiteOperationInformation;

  /** Get clone information. */
  @tag("Test Suite Clone")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testSuiteClone")
  @extension("x-ms-vss-method", "GetSuiteCloneInformation")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/Suites/CloneOperation/{cloneOperationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Operation ID returned when we queue a clone operation */
    @path cloneOperationId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): CloneTestSuiteOperationInformation;
}

interface TestCases {
  /** Delete a test case. */
  @tag("Test Cases")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "testCases")
  @extension("x-ms-vss-method", "DeleteTestCase")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/testcases/{testCaseId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Id of test case to be deleted. */
    @path testCaseId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface TestCaseClone {
  @tag("Test Case Clone")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testCaseClone")
  @extension("x-ms-vss-method", "CloneTestCase")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/TestCases/CloneTestCaseOperation")
  @post
  CloneTestCase(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`2`,
    @body body: CloneTestCaseParams,
  ): CloneTestCaseOperationInformation;

  /** Get clone information. */
  @tag("Test Case Clone")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "testCaseClone")
  @extension("x-ms-vss-method", "GetTestCaseCloneInformation")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/TestCases/CloneTestCaseOperation/{cloneOperationId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** Operation ID returned when we queue a clone operation */
    @path cloneOperationId: int32,

    ...Parameters.`api-Version-preview`.`2`,
  ): CloneTestCaseOperationInformation;
}

interface Variables {
  /** Get a list of test variables. */
  @tag("Variables")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "variables")
  @extension("x-ms-vss-method", "GetTestVariables")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/variables")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** If the list of variables returned is not complete, a continuation token to query next batch of variables is included in the response header as 'x-ms-continuationtoken'. Omit this parameter to get the first batch of test variables. */
    @query(#{ explode: true }) continuationToken?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    /** A continuation token for the next page of results. Absent on the last page. Pass it back as the `continuationToken` query parameter. */
    @header("x-ms-continuationtoken") xMsContinuationtoken?: string;

    @body body: TestVariable[];
  };

  /** Create a test variable. */
  @tag("Variables")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "variables")
  @extension("x-ms-vss-method", "CreateTestVariable")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/variables")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** TestVariableCreateUpdateParameters */
    @body body: TestVariableCreateUpdateParameters,
  ): TestVariable;

  /** Delete a test variable by its ID. */
  @tag("Variables")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "variables")
  @extension("x-ms-vss-method", "DeleteTestVariable")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/variables/{testVariableId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test variable to delete. */
    @path testVariableId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a test variable by its ID. */
  @tag("Variables")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "variables")
  @extension("x-ms-vss-method", "GetTestVariableById")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/variables/{testVariableId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test variable to get. */
    @path testVariableId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): TestVariable;

  /** Update a test variable by its ID. */
  @tag("Variables")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "variables")
  @extension("x-ms-vss-method", "UpdateTestVariable")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/testplan/variables/{testVariableId}")
  @patch
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    /** ID of the test variable to update. */
    @path testVariableId: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** TestVariableCreateUpdateParameters */
    @body body: TestVariableCreateUpdateParameters,
  ): TestVariable;
}
