import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "PermissionsReport" })
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
namespace PermissionsReport;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Detailed report of permissions for a set of groups and users over a set of security namespaces */
model PermissionsReport {
  /** Error if the report creation failed or empty if successful */
  error?: string;

  @format("uuid") id?: string;

  /** Name of the report which typically includes the requestor's display name */
  reportName?: string;

  @extension(
    "x-ms-enum",
    #{
      name: "PermissionsReportStatus",
      values: #[
        #{ value: "created", description: "Request created but not started" },
        #{ value: "inProgress", description: "Request started" },
        #{
          value: "completedWithErrors",
          description: "Completed but with errors. Check the PermissionsReport error field",
        },
        #{ value: "completedSuccessfully", description: "Ready to download" },
        #{ value: "deleted", description: "Has been deleted" }
      ],
    }
  )
  reportStatus?:
    | "created"
    | "inProgress"
    | "completedWithErrors"
    | "completedSuccessfully"
    | "deleted";
  reportStatusLastUpdatedTime?: utcDateTime;
  requestedTime?: utcDateTime;

  /** User who requested the report be created */
  requestor?: string;
}

/** Details for creating a permissions report */
model PermissionsReportRequest {
  /** List of groups and users to fetch permissions on. An empty list will fetch all groups and users in the organization */
  descriptors?: string[];

  /** Name of the report to create, make it unique */
  reportName?: string;

  /** List of resources to fetch permisions on */
  resources?: PermissionsReportResource[];
}

/** Specifics of the resource for the permissions report */
model PermissionsReportResource {
  /** GUID, Name, or ref for the specified resource type */
  resourceId?: string;

  /** For repo resource type, resource name is the repo name */
  resourceName?: string;

  /** Specify the type of resource to report permissions on */
  @extension(
    "x-ms-enum",
    #{
      name: "ResourceType",
      values: #[
        #{
          value: "repo",
          description: "Permissions for the primary repo node. The resource ID should be RepoGuid, ProjectId/RepoGuid, or ProjectId/RepoName",
        },
        #{
          value: "ref",
          description: "Use repo/branch nodes using the ref format eg. RepoGuid/Refs/head/master, ProjectName/RepoName/Refs/head/master, ProjectGuid/RepoGuid/Refs/tags",
        },
        #{ value: "projectGit", description: "Use for the 'Git repositories' root node" },
        #{
          value: "release",
          description: "Use for the Release permission. eg. ProjectGuid, ProjectGuid/Path",
        },
        #{
          value: "tfvc",
          description: "Use for the Team Foundation Version Control permission using the item path, eg. $/test tfvc",
        }
      ],
    }
  )
  resourceType?: "repo" | "ref" | "projectGit" | "release" | "tfvc";
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
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

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface PermissionsReportOperations {
  /** Get a list of permissions reports */
  @tag("Permissions Report")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissionsReport")
  @extension("x-ms-vss-method", "GetPermissionsReports")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/permissionsreport")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<PermissionsReport[]>;

  /** Request a permissions report to be created asyncronously */
  @tag("Permissions Report")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissionsReport")
  @extension("x-ms-vss-method", "CreatePermissionsReport")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/permissionsreport")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** Request configuration to be included in the permissions report */
    @body body: PermissionsReportRequest,
  ): ReferenceLinks;

  /** Get a specific permissions report */
  @tag("Permissions Report")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissionsReport")
  @extension("x-ms-vss-method", "GetPermissionsReport")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/permissionsreport/{id}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID (GUID) of the permissions report */
    @format("uuid") @path id: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PermissionsReport;
}

interface PermissionsReportDownload {
  /** Download the json results of a permissions report */
  @tag("Permissions Report Download")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "permissionsReportDownload")
  @extension("x-ms-vss-method", "Download")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/permissionsreport/{id}/download")
  @get
  Download(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The ID (GUID) of the permissions report */
    @format("uuid") @path id: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): {
    @header contentType: "application/octet-stream";
    @body @format("Stream") body: string;
  };
}
