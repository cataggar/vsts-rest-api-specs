import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Audit" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://auditservice.dev.azure.com")
namespace Audit;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AuditActionInfo {
  /** The action id for the event, i.e Git.CreateRepo, Project.RenameProject */
  actionId?: string;

  /** Area of Azure DevOps the action occurred */
  area?: string;

  /** Type of action executed */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditActionCategory",
      values: #[
        #{ value: "unknown", description: "The category is not known" },
        #{ value: "modify", description: "An artifact has been Modified" },
        #{ value: "remove", description: "An artifact has been Removed" },
        #{ value: "create", description: "An artifact has been Created" },
        #{ value: "access", description: "An artifact has been Accessed" },
        #{ value: "execute", description: "An artifact has been Executed" }
      ],
    }
  )
  category?: "unknown" | "modify" | "remove" | "create" | "access" | "execute" | string;
}

model AuditLogEntry {
  /** The action if for the event, i.e Git.CreateRepo, Project.RenameProject */
  actionId?: string;

  /** ActivityId */
  @format("uuid") activityId?: string;

  /** The Actor's Client Id (if actor is a service principal) */
  @format("uuid") actorClientId?: string;

  /** The Actor's CUID */
  @format("uuid") actorCUID?: string;

  /** The Actor's UPN */
  actorUPN?: string;

  /** The Actor's User Id (if actor is a user) */
  @format("uuid") actorUserId?: string;

  /** Type of authentication used by the author */
  authenticationMechanism?: string;

  /** This allows us to group things together, like one user action that caused a cascade of event entries (project creation). */
  @format("uuid") correlationId?: string;

  /** External data such as CUIDs, item names, etc. */
  data?: Record<{}>;

  /** EventId, should be unique */
  @format("uuid") id?: string;

  /** IP Address where the event was originated */
  ipAddress?: string;

  /** When specified, the id of the project this event is associated to */
  @format("uuid") projectId?: string;

  /** The organization Id (Organization is the only scope currently supported) */
  @format("uuid") scopeId?: string;

  /** The type of the scope (Organization is only scope currently supported) */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditScopeType",
      values: #[
        #{ value: "unknown", description: "The scope is not known or has not been set" },
        #{ value: "deployment", description: "Deployment" },
        #{ value: "enterprise", description: "Enterprise" },
        #{ value: "organization", description: "Organization" },
        #{ value: "project", description: "Project" }
      ],
    }
  )
  scopeType?: "unknown" | "deployment" | "enterprise" | "organization" | "project" | string;

  /** The time when the event occurred in UTC */
  timestamp?: utcDateTime;

  /** The user agent from the request */
  userAgent?: string;
}

/** The object returned when the audit log is queried. It contains the log and the information needed to query more audit entries. */
model AuditLogQueryResult {
  /** The continuation token to pass to get the next set of results */
  continuationToken?: string;

  /** The list of audit log entries */
  decoratedAuditLogEntries?: DecoratedAuditLogEntry[];

  /** True when there are more matching results to be fetched, false otherwise. */
  hasMore?: boolean;
}

/** This class represents an audit stream */
model AuditStream {
  /** Inputs used to communicate with external service. Inputs could be url, a connection string, a token, etc. */
  consumerInputs?: Record<string>;

  /** Type of the consumer, i.e. splunk, azureEventHub, etc. */
  consumerType?: string;

  /** The time when the stream was created */
  createdTime?: utcDateTime;

  /** Used to identify individual streams */
  displayName?: string;

  /** Unique stream identifier */
  id?: int32;

  /** Status of the stream, Enabled, Disabled */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditStreamStatus",
      values: #[
        #{ value: "unknown", description: "The state has not been set, The stream is new" },
        #{ value: "enabled", description: "The stream is enabled and can deliver events" },
        #{ value: "disabledByUser", description: "The stream has been disabled by a user" },
        #{ value: "disabledBySystem", description: "The stream has been disabled by the system" },
        #{ value: "deleted", description: "The stream has been marked for deletion" },
        #{ value: "backfilling", description: "The stream is delivering old events" }
      ],
    }
  )
  status?:
    | "unknown"
    | "enabled"
    | "disabledByUser"
    | "disabledBySystem"
    | "deleted"
    | "backfilling"
    | string;

  /** Reason for the current stream status, i.e. Disabled by the system, Invalid credentials, etc. */
  statusReason?: string;

  /** The time when the stream was last updated */
  updatedTime?: utcDateTime;
}

model DecoratedAuditLogEntry {
  /** The action id for the event, i.e Git.CreateRepo, Project.RenameProject */
  actionId?: string;

  /** ActivityId */
  @format("uuid") activityId?: string;

  /** The Actor's Client Id (if actor is a service principal) */
  @format("uuid") actorClientId?: string;

  /** The Actor's CUID */
  @format("uuid") actorCUID?: string;

  /** DisplayName of the user who initiated the action */
  actorDisplayName?: string;

  /** URL of Actor's Profile image */
  actorImageUrl?: string;

  /** The Actor's UPN */
  actorUPN?: string;

  /** The Actor's User Id (if actor is a user) */
  @format("uuid") actorUserId?: string;

  /** Area of Azure DevOps the action occurred */
  area?: string;

  /** Type of authentication used by the actor */
  authenticationMechanism?: string;

  /** Type of action executed */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditActionCategory",
      values: #[
        #{ value: "unknown", description: "The category is not known" },
        #{ value: "modify", description: "An artifact has been Modified" },
        #{ value: "remove", description: "An artifact has been Removed" },
        #{ value: "create", description: "An artifact has been Created" },
        #{ value: "access", description: "An artifact has been Accessed" },
        #{ value: "execute", description: "An artifact has been Executed" }
      ],
    }
  )
  category?: "unknown" | "modify" | "remove" | "create" | "access" | "execute" | string;

  /** DisplayName of the category */
  categoryDisplayName?: string;

  /** This allows related audit entries to be grouped together. Generally this occurs when a single action causes a cascade of audit entries. For example, project creation. */
  @format("uuid") correlationId?: string;

  /** External data such as CUIDs, item names, etc. */
  data?: Record<{}>;

  /** Decorated details */
  details?: string;

  /** EventId - Needs to be unique per service */
  id?: string;

  /** IP Address where the event was originated */
  ipAddress?: string;

  /** When specified, the id of the project this event is associated to */
  @format("uuid") projectId?: string;

  /** When specified, the name of the project this event is associated to */
  projectName?: string;

  /** DisplayName of the scope */
  scopeDisplayName?: string;

  /** The organization Id (Organization is the only scope currently supported) */
  @format("uuid") scopeId?: string;

  /** The type of the scope (Organization is only scope currently supported) */
  @extension(
    "x-ms-enum",
    #{
      name: "AuditScopeType",
      values: #[
        #{ value: "unknown", description: "The scope is not known or has not been set" },
        #{ value: "deployment", description: "Deployment" },
        #{ value: "enterprise", description: "Enterprise" },
        #{ value: "organization", description: "Organization" },
        #{ value: "project", description: "Project" }
      ],
    }
  )
  scopeType?: "unknown" | "deployment" | "enterprise" | "organization" | "project" | string;

  /** The time when the event occurred in UTC */
  timestamp?: utcDateTime;

  /** The user agent from the request */
  userAgent?: string;
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

/** A collection of `AuditActionInfo` as returned by Azure DevOps. */
model AuditActionInfoList {
  count?: int32;
  value?: AuditActionInfo[];
}

/** A collection of `AuditStream` as returned by Azure DevOps. */
model AuditStreamList {
  count?: int32;
  value?: AuditStream[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Actions {
  /** Get all auditable actions filterable by area. */
  @tag("Actions")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "actions")
  @extension("x-ms-vss-method", "GetActions")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/actions")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Optional. Get actions scoped to area */
    @query(#{ explode: true }) areaName?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AuditActionInfoList;
}

interface AuditLog {
  /** Queries audit log entries */
  @tag("Audit Log")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "auditLog")
  @extension("x-ms-vss-method", "QueryLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/auditlog")
  @get
  Query(
    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** Start time of download window. Optional */
    @query(#{ explode: true }) startTime?: utcDateTime,

    /** End time of download window. Optional */
    @query(#{ explode: true }) endTime?: utcDateTime,

    /** Max number of results to return. Optional */
    @query(#{ explode: true }) batchSize?: int32,

    /** Token used for returning next set of results from previous query. Optional */
    @query(#{ explode: true }) continuationToken?: string,

    /** Skips aggregating events and leaves them as individual entries instead. By default events are aggregated. Event types that are aggregated: AuditLog.AccessLog. */
    @query(#{ explode: true }) skipAggregation?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): AuditLogQueryResult;
}

interface DownloadLog {
  /** Downloads audit log entries. */
  @tag("Download Log")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "downloadLog")
  @extension("x-ms-vss-method", "DownloadLog")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/downloadlog")
  @get
  DownloadLog(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** File format for download. Can be 'json' or 'csv'. */
    @query(#{ explode: true }) format: string,

    /** Start time of download window. Optional */
    @query(#{ explode: true }) startTime?: utcDateTime,

    /** End time of download window. Optional */
    @query(#{ explode: true }) endTime?: utcDateTime,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/octet-stream";
    @body @format("Stream") body: string;
  };
}

interface Streams {
  /** Return all Audit Streams scoped to an organization */
  @tag("Streams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "streams")
  @extension("x-ms-vss-method", "QueryAllStreams")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/streams")
  @get
  QueryAllStreams(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AuditStreamList;

  /** Create new Audit Stream */
  @tag("Streams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "streams")
  @extension("x-ms-vss-method", "CreateStream")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/streams")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The number of days of previously recorded audit data that will be replayed into the stream. A value of zero will result in only new events being streamed. */
    @query(#{ explode: true }) daysToBackfill: int32,

    ...Parameters.`api-Version-preview`.`1`,

    /** Stream entry */
    @body body: AuditStream,
  ): AuditStream;

  /** Update existing Audit Stream */
  @tag("Streams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "streams")
  @extension("x-ms-vss-method", "UpdateStream")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/streams")
  @put
  UpdateStream(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Stream entry */
    @body body: AuditStream,
  ): AuditStream;

  /** Delete Audit Stream */
  @tag("Streams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "streams")
  @extension("x-ms-vss-method", "DeleteStream")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/streams/{streamId}")
  @delete
  Delete(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of stream entry to delete */
    @path streamId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Return Audit Stream with id of streamId if one exists otherwise throw */
  @tag("Streams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "streams")
  @extension("x-ms-vss-method", "QueryStreamById")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/streams/{streamId}")
  @get
  QueryStreamById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of stream entry to retrieve */
    @path streamId: int32,

    ...Parameters.`api-Version-preview`.`1`,
  ): AuditStream;

  /** Update existing Audit Stream status */
  @tag("Streams")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "streams")
  @extension("x-ms-vss-method", "UpdateStatus")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/audit/streams/{streamId}")
  @put
  UpdateStatus(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Id of stream entry to be updated */
    @path streamId: int32,

    /** Status of the stream */
    @extension(
      "x-ms-enum",
      #{
        name: "AuditStreamStatus",
        values: #[
          #{ value: "unknown", description: "The state has not been set, The stream is new" },
          #{ value: "enabled", description: "The stream is enabled and can deliver events" },
          #{ value: "disabledByUser", description: "The stream has been disabled by a user" },
          #{ value: "disabledBySystem", description: "The stream has been disabled by the system" },
          #{ value: "deleted", description: "The stream has been marked for deletion" },
          #{ value: "backfilling", description: "The stream is delivering old events" }
        ],
      }
    )
    @query(#{ explode: true })
    status: "unknown" | "enabled" | "disabledByUser" | "disabledBySystem" | "deleted" | "backfilling",

    ...Parameters.`api-Version-preview`.`1`,
  ): AuditStream;
}
