import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Status" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://status.dev.azure.com")
namespace Status;

model EnterpriseStatus {
  ...Status;
  organizations?: OrganizationHealth[];
}

model Geography {
  id?: string;
  name?: string;
}

model GeographyWithHealth {
  ...Geography;
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeHealth",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "unhealthy", description: "" },
        #{ value: "degraded", description: "" },
        #{ value: "advisory", description: "" },
        #{ value: "healthy", description: "" }
      ],
    }
  )
  health?: "unknown" | "unhealthy" | "degraded" | "advisory" | "healthy";
}

model LiveSiteEvent {
  endTime?: utcDateTime;

  /** When IcMSyncStatus is Failed, contains the error message from the IcM API call. */
  icMSyncError?: string;

  /** Transient status of the IcM incident sync triggered by this create/update request. Not persisted — only populated in the response to the mutating request. */
  @extension(
    "x-ms-enum",
    #{
      name: "IcMSyncStatus",
      values: #[
        #{
          value: "skipped",
          description: "No IcM sync was attempted (e.g., delete/restore or no log entry).",
        },
        #{
          value: "succeeded",
          description: "The IcM update completed successfully within the deadline.",
        },
        #{
          value: "inProgress",
          description: "The IcM update did not complete within the deadline and is still running in the background.",
        },
        #{ value: "failed", description: "The IcM update failed within the deadline." }
      ],
    }
  )
  icMSyncStatus?: "skipped" | "succeeded" | "inProgress" | "failed";

  id?: int64;
  impact?: LiveSiteEventImpact[];
  incidentUri?: string;
  isDeleted?: boolean;
  logs?: LiveSiteEventLog[];
  nextUpdateTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "LiveSiteEventSeverity",
      values: #[
        #{ value: "unhealthy", description: "" },
        #{ value: "degraded", description: "" },
        #{ value: "advisory", description: "" }
      ],
    }
  )
  severity?: "unhealthy" | "degraded" | "advisory";
  startTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "LiveSiteEventState",
      values: #[#{ value: "active", description: "" }, #{ value: "resolved", description: "" }],
    }
  )
  state?: "active" | "resolved";
  title?: string;
}

model LiveSiteEventAuthor {
  displayName?: string;
  @format("uuid") id?: string;
}

model LiveSiteEventImpact {
  scopeName?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeType",
      values: #[
        #{ value: "geography", description: "" },
        #{ value: "organization", description: "" }
      ],
    }
  )
  scopeType?: "geography" | "organization";
  serviceId?: string;
}

model LiveSiteEventLog {
  author?: LiveSiteEventAuthor;
  creationDateTime?: utcDateTime;
  description?: string;
  descriptionMd?: string;
  id?: int32;
  isDeleted?: boolean;
  lastUpdatedDateTime?: utcDateTime;
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeType",
      values: #[
        #{ value: "geography", description: "" },
        #{ value: "organization", description: "" }
      ],
    }
  )
  scopeType?: "geography" | "organization";
  @extension(
    "x-ms-enum",
    #{
      name: "LiveSiteEventLogType",
      values: #[
        #{ value: "event", description: "" },
        #{ value: "postmortem", description: "" },
        #{ value: "notification", description: "" }
      ],
    }
  )
  type?: "event" | "postmortem" | "notification";
}

model LiveSiteEventLogAttachment {
  author?: LiveSiteEventAuthor;
  creationDateTime?: utcDateTime;
  displayName?: string;
  eventId?: int64;
  fileId?: int64;
  fileName?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeType",
      values: #[
        #{ value: "geography", description: "" },
        #{ value: "organization", description: "" }
      ],
    }
  )
  scopeType?: "geography" | "organization";
}

model LiveSiteEventScope {
  id?: int32;
  name?: string;
}

model LiveSiteEventTemplate {
  id?: string;
  initialDescription?: string;
  title?: string;
}

model LiveSiteEventTemplateData {
  defaultId?: string;
  finalDescription?: string;
  intermediateDescription?: string;
  templates?: LiveSiteEventTemplate[];
}

model MicroService {
  @format("uuid") id?: string;
  name?: string;
  scaleUnits?: MicroServiceScaleUnit[];
  services?: Service[];
}

model MicroServiceScaleUnit {
  geography?: Geography;
  id?: string;
  isInternal?: boolean;
}

model OrganizationHealth {
  @format("uuid") id?: string;
  name?: string;
  services?: ServiceWithHealth[];
}

model Service {
  id?: string;
  isInternal?: boolean;
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeState",
      values: #[
        #{ value: "active", description: "" },
        #{ value: "hidden", description: "" },
        #{ value: "deleted", description: "" }
      ],
    }
  )
  state?: "active" | "hidden" | "deleted";
}

model ServiceHealth {
  geographies?: GeographyWithHealth[];
  id?: string;
}

model ServiceStatus {
  ...Status;
  services?: ServiceHealth[];
}

model ServiceWithHealth {
  ...Service;
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeHealth",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "unhealthy", description: "" },
        #{ value: "degraded", description: "" },
        #{ value: "advisory", description: "" },
        #{ value: "healthy", description: "" }
      ],
    }
  )
  health?: "unknown" | "unhealthy" | "degraded" | "advisory" | "healthy";
}

model Status {
  lastUpdated?: utcDateTime;
  status?: StatusSummary;
}

/** Represents data for the impacted organization. Will be null if org is not impacted */
model StatusImpact {
  liveSiteEvents?: LiveSiteEvent[];
  serviceStatus?: ServiceStatus;
}

model StatusSummary {
  @extension(
    "x-ms-enum",
    #{
      name: "ScopeHealth",
      values: #[
        #{ value: "unknown", description: "" },
        #{ value: "unhealthy", description: "" },
        #{ value: "degraded", description: "" },
        #{ value: "advisory", description: "" },
        #{ value: "healthy", description: "" }
      ],
    }
  )
  health?: "unknown" | "unhealthy" | "degraded" | "advisory" | "healthy";
  message?: string;
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

/** Queries status information for the service all-up, or scoped to a particular service and/or geography */
@tag("Health")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "health")
@extension("x-ms-vss-method", "GetServiceStatus")
@extension("x-ms-preview", true)
@route("/_apis/status/health")
@get
op Health_Get(
  /** A comma-separated list of services for which to get status information for. Supported values: Artifacts, Boards, Core services, Other services, Pipelines, Repos, Test Plans. */
  @format("array (string)") @query(#{ explode: true }) services?: string,

  /** A comma-separated list of geographies for which to get status information for. Supported values: APAC, AU, BR, CA, EU, IN, UK, US. */
  @format("array (string)") @query(#{ explode: true }) geographies?: string,

  ...Parameters.`api-Version-preview`.`1`,
): ServiceStatus;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
