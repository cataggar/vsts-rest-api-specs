import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Reporting" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://advsec.dev.azure.com")
namespace Reporting;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Alert Summary by severity. */
model AlertSummaryBySeverity {
  /** Total Critical severity alerts. */
  critical?: int32;

  /** Total High severity alerts. */
  high?: int32;

  /** Total low severity alerts. */
  low?: int32;

  /** Total Medium severity alerts. */
  medium?: int32;
}

/** Org Alert Summary. */
model OrgAlertSummary {
  /** Org Id. */
  @format("uuid") orgId?: string;

  /** A list of Project summary data. */
  projects?: ProjectAlertSummary[];
}

/** Project Alert Summary. */
model ProjectAlertSummary {
  /** Project Id. */
  @format("uuid") projectId?: string;

  /** A list of RepoAlertSummary data. */
  repos?: RepoAlertSummary[];
}

/** Repo Alert Summary. */
model RepoAlertSummary {
  alertsBySeverity?: AlertSummaryBySeverity;

  /** RepoId. */
  @format("uuid") repoId?: string;

  /** Repo Name. */
  repoName?: string;

  /** Total active alerts in the repo. */
  totalAlerts?: int32;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}
