import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "ResourceUsage" })
@info(#{
  version: "7.1-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://dev.azure.com")
namespace ResourceUsage;

enum ServiceApiVersions {
  v7_1_preview: "7.1-preview",
}

/** Represents usage data that includes a count and a limit for a specific aspect. */
model Usage {
  /** Gets the current count or usage. */
  count?: int32;

  /** Gets the maximum limit or capacity. */
  limit?: int32;
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
      /** Version of the API to use. This should be set to '7.1-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface TeamProjectCollection {
  @tag("Team Project Collection")
  @extension("x-ms-docs-override-version", "7.1-preview.1")
  @extension("x-ms-vss-resource", "teamProjectCollection")
  @extension("x-ms-vss-method", "GetLimits")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/resourceusage")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Record<Usage>>;
}

interface Project {
  /** Gets the Project Level limits and Usage for a project. */
  @tag("Project")
  @extension("x-ms-docs-override-version", "7.1-preview.1")
  @extension("x-ms-vss-resource", "project")
  @extension("x-ms-vss-method", "GetProjectLimit")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/resourceusage")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Project ID or project name */
    @path project: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Record<Usage>>;
}
