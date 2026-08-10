import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Operations" })
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
namespace Operations;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Contains information about the progress or result of an async operation. */
model Operation {
  ...OperationReference;
  _links?: ReferenceLinks;

  /** Detailed messaged about the status of an operation. */
  detailedMessage?: string;

  /** Result message for an operation. */
  resultMessage?: string;

  resultUrl?: OperationResultReference;
}

/** Reference for an async operation. */
model OperationReference {
  /** Unique identifier for the operation. */
  @format("uuid") id?: string;

  /** Unique identifier for the plugin. */
  @format("uuid") pluginId?: string;

  /** The current status of the operation. */
  @extension(
    "x-ms-enum",
    #{
      name: "OperationStatus",
      values: #[
        #{ value: "notSet", description: "The operation does not have a status set." },
        #{ value: "queued", description: "The operation has been queued." },
        #{ value: "inProgress", description: "The operation is in progress." },
        #{ value: "cancelled", description: "The operation was cancelled by the user." },
        #{ value: "succeeded", description: "The operation completed successfully." },
        #{ value: "failed", description: "The operation completed with a failure." }
      ],
    }
  )
  status?: "notSet" | "queued" | "inProgress" | "cancelled" | "succeeded" | "failed" | string;

  /** URL to get the full operation object. */
  url?: string;
}

model OperationResultReference {
  /** URL to the operation result. */
  resultUrl?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Operations {
  /** Gets an operation from the operationId using the given pluginId. Some scenarios don’t require a pluginId. If a pluginId is not included in the call then just the operationId will be used to find an operation. */
  @tag("Operations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "operations")
  @extension("x-ms-vss-method", "GetOperation")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/operations/{operationId}")
  @get
  Get(
    /** The ID for the operation. */
    @format("uuid") @path operationId: string,

    /** The name of the Azure DevOps organization. */
    @extension("x-ms-required", false) @path organization: string,

    /** The ID for the plugin. */
    @format("uuid") @query(#{ explode: true }) pluginId?: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Operation;
}
