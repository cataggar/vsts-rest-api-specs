import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "WorkItemTrackingProcessTemplate" })
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
namespace WorkItemTrackingProcessTemplate;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Describes an admin behavior for a process. */
model AdminBehavior {
  /** Is the behavior abstract (i.e. can not be associated with any work item type). */
  abstract?: boolean;

  /** The color associated with the behavior. */
  color?: string;

  /** Indicates if the behavior is custom. */
  custom?: boolean;

  /** The description of the behavior. */
  description?: string;

  /** List of behavior fields. */
  fields?: AdminBehaviorField[];

  /** Behavior ID. */
  id?: string;

  /** Parent behavior reference. */
  inherits?: string;

  /** The behavior name. */
  name?: string;

  /** Is the behavior overrides a behavior from system process. */
  overriden?: boolean;

  /** The rank. */
  rank?: int32;
}

/** Describes an admin behavior field. */
model AdminBehaviorField {
  /** The behavior field identifier. */
  behaviorFieldId?: string;

  /** The behavior ID. */
  id?: string;

  /** The behavior name. */
  name?: string;
}

/** Describes result of a check template existence request. */
model CheckTemplateExistenceResult {
  /** Indicates whether a template exists. */
  doesTemplateExist?: boolean;

  /** The name of the existing template. */
  existingTemplateName?: string;

  /** The existing template type identifier. */
  @format("uuid") existingTemplateTypeId?: string;

  /** The name of the requested template. */
  requestedTemplateName?: string;
}

/** Describes the result of a Process Import request. */
model ProcessImportResult {
  checkExistenceResult?: CheckTemplateExistenceResult;

  /** Help URL. */
  helpUrl?: string;

  /** ID of the import operation. */
  @format("uuid") id?: string;

  /** Whether this imported process is new. */
  isNew?: boolean;

  /** The promote job identifier. */
  @format("uuid") promoteJobId?: string;

  /** The list of validation results. */
  validationResults?: ValidationIssue[];
}

/** Describes result of process operation promote. */
model ProcessPromoteStatus {
  /** Number of projects for which promote is complete. */
  complete?: int32;

  /** ID of the promote operation. */
  @format("uuid") id?: string;

  /** The error message associated with the promote operation. The string will be empty if there are no errors. */
  message?: string;

  /** Number of projects for which promote is pending. */
  pending?: int32;

  /** The remaining retries. */
  remainingRetries?: int32;

  /** True if promote finished all the projects successfully. False if still in progress or any project promote failed. */
  successful?: boolean;
}

model ValidationIssue {
  description?: string;
  file?: string;
  helpLink?: string;
  @extension(
    "x-ms-enum",
    #{
      name: "ValidationIssueType",
      values: #[#{ value: "warning", description: "" }, #{ value: "error", description: "" }],
    }
  )
  issueType?: "warning" | "error";
  line?: int32;
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

/** A collection of `AdminBehavior` as returned by Azure DevOps. */
model AdminBehaviorList {
  count?: int32;
  value?: AdminBehavior[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Behaviors {
  /** Returns a list of behaviors for the process. */
  @tag("Behaviors")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "behaviors")
  @extension("x-ms-vss-method", "GetBehaviors")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processadmin/{processId}/behaviors")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path processId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): AdminBehaviorList;
}

interface Processes {
  /** Returns requested process template. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "Export")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processadmin/processes/export/{id}")
  @get
  ExportProcessTemplate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the process */
    @format("uuid") @path id: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/zip";
    @body @format("Stream") body: string;
  };

  /** Imports a process from zip file. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "Import")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processadmin/processes/import")
  @post
  ImportProcessTemplate(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Ignores validation warnings. Default value is false. */
    @query(#{ explode: true }) ignoreWarnings?: boolean,

    /** Replaces the existing template. Default value is true. */
    @query(#{ explode: true }) replaceExistingTemplate?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
    @header contentType: "application/octet-stream",

    /** Stream to upload */
    @body body: string,
  ): ProcessImportResult;

  /** Tells whether promote has completed for the specified promote job ID. */
  @tag("Processes")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "processes")
  @extension("x-ms-vss-method", "Status")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/work/processadmin/processes/status/{id}")
  @get
  ImportProcessTemplateStatus(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID of the promote job operation */
    @format("uuid") @path id: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): ProcessPromoteStatus;
}
