import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Provenance" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://pkgs.dev.azure.com")
namespace Provenance;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model SessionRequest {
  /** Generic property bag to store data about the session */
  data?: Record<string>;

  /** The feed name or id for the session */
  feed?: string;

  /** The type of session If a known value is provided, the Data dictionary will be validated for the presence of properties required by that type */
  source?: string;
}

model SessionResponse {
  /** The unique identifier for the session */
  sessionId?: string;

  /** The name for the session */
  sessionName?: string;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Provenance {
  /** Creates a session, a wrapper around a feed that can store additional metadata on the packages published to it. */
  @tag("Provenance")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "session")
  @extension("x-ms-vss-method", "CreateSession")
  @extension("x-ms-preview", true)
  @route("/{organization}/{project}/_apis/provenance/session/{protocol}")
  @post
  CreateSession(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The protocol that the session will target */
    @path protocol: string,

    /** Project ID or project name */
    @extension("x-ms-required", false) @path project: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The feed and metadata for the session */
    @body body: SessionRequest,
  ): SessionResponse;
}
