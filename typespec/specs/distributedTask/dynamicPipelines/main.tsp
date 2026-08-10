import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "DynamicPipelines" })
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
namespace DynamicPipelines;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model DynamicPipelinesData {
  artifactId?: string;
  repoName?: string;
  yaml?: string;
}

/** Represents an option that may affect the way an agent runs the job. */
model JobOption {
  data?: Record<string>;

  /** Gets the id of the option. */
  @format("uuid") id?: string;
}

model MaskHint {
  @extension(
    "x-ms-enum",
    #{
      name: "MaskType",
      values: #[#{ value: "variable", description: "" }, #{ value: "regex", description: "" }],
    }
  )
  type?: "variable" | "regex" | string;
  value?: string;
}

model PlanEnvironment {
  mask?: MaskHint[];
  options?: Record<JobOption>;
  variables?: Record<string>;
}

model ReferenceLinks {
  links?: Record<{}>;
}

/** A reference to a task log. This class contains information about the output printed to the timeline record's logs console during pipeline run. */
model TaskLogReference {
  /** The ID of the task log. */
  id?: int32;

  /** The REST URL of the task log. */
  location?: string;
}

model TaskOrchestrationContainer {
  ...TaskOrchestrationItem;
  children?: TaskOrchestrationItem[];
  continueOnError?: boolean;
  data?: Record<string>;
  maxConcurrency?: int32;
  parallel?: boolean;
  rollback?: TaskOrchestrationContainer;
}

model TaskOrchestrationItem {
  @extension(
    "x-ms-enum",
    #{
      name: "TaskOrchestrationItemType",
      values: #[#{ value: "container", description: "" }, #{ value: "job", description: "" }],
    }
  )
  itemType?: "container" | "job" | string;
}

model TaskOrchestrationOwner {
  _links?: ReferenceLinks;
  id?: int32;
  name?: string;
}

model TaskOrchestrationPlan {
  ...TaskOrchestrationPlanReference;
  environment?: PlanEnvironment;
  expandedYaml?: TaskLogReference;
  finishTime?: utcDateTime;
  implementation?: TaskOrchestrationContainer;
  initializationLog?: TaskLogReference;
  @format("uuid") requestedById?: string;
  @format("uuid") requestedForId?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskResult",
      values: #[
        #{ value: "succeeded", description: "" },
        #{ value: "succeededWithIssues", description: "" },
        #{ value: "failed", description: "" },
        #{ value: "canceled", description: "" },
        #{ value: "skipped", description: "" },
        #{ value: "abandoned", description: "" }
      ],
    }
  )
  result?:
    | "succeeded"
    | "succeededWithIssues"
    | "failed"
    | "canceled"
    | "skipped"
    | "abandoned"
    | string;
  resultCode?: string;
  startTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "TaskOrchestrationPlanState",
      values: #[
        #{ value: "inProgress", description: "" },
        #{ value: "queued", description: "" },
        #{ value: "completed", description: "" },
        #{ value: "throttled", description: "" }
      ],
    }
  )
  state?: "inProgress" | "queued" | "completed" | "throttled" | string;
  timeline?: TimelineReference;
}

model TaskOrchestrationPlanReference {
  artifactLocation?: string;
  artifactUri?: string;
  definition?: TaskOrchestrationOwner;
  owner?: TaskOrchestrationOwner;
  planGroup?: string;
  @format("uuid") planId?: string;
  planType?: string;
  @format("uuid") scopeIdentifier?: string;
  version?: int32;
}

/** A reference to a timeline. */
model TimelineReference {
  /** The change ID. */
  changeId?: int32;

  /** The ID of the timeline. */
  @format("uuid") id?: string;

  /** The REST URL of the timeline. */
  location?: string;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}
