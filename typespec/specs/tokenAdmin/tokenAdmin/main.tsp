import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "TokenAdmin" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://vssps.dev.azure.com")
namespace TokenAdmin;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** Represents a session token used to access Azure DevOps resources */
model SessionToken {
  @format("uuid") accessId?: string;

  /** This is populated when user requests a compact token. The alternate token value is self describing token. */
  alternateToken?: string;

  @format("uuid") authorizationId?: string;
  claims?: Record<string>;
  @format("uuid") clientId?: string;

  /** Hash of the Token conforming to the C3ID standard, used for PATs. */
  crossCompanyCorrelatingId?: string;

  displayName?: string;
  @format("uuid") hostAuthorizationId?: string;
  isPublic?: boolean;
  isValid?: boolean;
  publicData?: string;
  scope?: string;
  source?: string;
  targetAccounts?: string[];

  /** This is computed and not returned in Get queries */
  token?: string;

  @format("uuid") userId?: string;
  validFrom?: utcDateTime;
  validTo?: utcDateTime;
}

model SessionTokenResult {
  hasError?: boolean;
  sessionToken?: SessionToken;
  @extension(
    "x-ms-enum",
    #{
      name: "SessionTokenError",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "displayNameRequired", description: "" },
        #{ value: "invalidDisplayName", description: "" },
        #{ value: "invalidValidTo", description: "" },
        #{ value: "invalidScope", description: "" },
        #{ value: "userIdRequired", description: "" },
        #{ value: "invalidUserId", description: "" },
        #{ value: "invalidUserType", description: "" },
        #{ value: "accessDenied", description: "" },
        #{ value: "failedToIssueAccessToken", description: "" },
        #{ value: "invalidClient", description: "" },
        #{ value: "invalidClientType", description: "" },
        #{ value: "invalidClientId", description: "" },
        #{ value: "invalidTargetAccounts", description: "" },
        #{ value: "hostAuthorizationNotFound", description: "" },
        #{ value: "authorizationNotFound", description: "" },
        #{ value: "failedToUpdateAccessToken", description: "" },
        #{ value: "sourceNotSupported", description: "" },
        #{ value: "invalidSourceIP", description: "" },
        #{ value: "invalidSource", description: "" },
        #{ value: "duplicateHash", description: "" },
        #{ value: "sshPolicyDisabled", description: "" },
        #{ value: "invalidToken", description: "" },
        #{ value: "tokenNotFound", description: "" },
        #{ value: "invalidAuthorizationId", description: "" },
        #{ value: "failedToReadTenantPolicy", description: "" },
        #{ value: "globalPatPolicyViolation", description: "" },
        #{ value: "fullScopePatPolicyViolation", description: "" },
        #{ value: "patLifespanPolicyViolation", description: "" },
        #{ value: "invalidTokenType", description: "" },
        #{ value: "invalidAudience", description: "" },
        #{ value: "invalidSubject", description: "" },
        #{ value: "deploymentHostNotSupported", description: "" },
        #{ value: "disablePatCreationPolicyViolation", description: "" },
        #{ value: "failedToReadOrgPolicy", description: "" },
        #{ value: "globalPATCreationBlocked", description: "" },
        #{ value: "expiredPatCannotBeExtended", description: "" }
      ],
    }
  )
  sessionTokenError?:
    | "none"
    | "displayNameRequired"
    | "invalidDisplayName"
    | "invalidValidTo"
    | "invalidScope"
    | "userIdRequired"
    | "invalidUserId"
    | "invalidUserType"
    | "accessDenied"
    | "failedToIssueAccessToken"
    | "invalidClient"
    | "invalidClientType"
    | "invalidClientId"
    | "invalidTargetAccounts"
    | "hostAuthorizationNotFound"
    | "authorizationNotFound"
    | "failedToUpdateAccessToken"
    | "sourceNotSupported"
    | "invalidSourceIP"
    | "invalidSource"
    | "duplicateHash"
    | "sshPolicyDisabled"
    | "invalidToken"
    | "tokenNotFound"
    | "invalidAuthorizationId"
    | "failedToReadTenantPolicy"
    | "globalPatPolicyViolation"
    | "fullScopePatPolicyViolation"
    | "patLifespanPolicyViolation"
    | "invalidTokenType"
    | "invalidAudience"
    | "invalidSubject"
    | "deploymentHostNotSupported"
    | "disablePatCreationPolicyViolation"
    | "failedToReadOrgPolicy"
    | "globalPATCreationBlocked"
    | "expiredPatCannotBeExtended"
    | string;
  sessionTokenErrorMessage?: string;
}

/** A paginated list of session tokens. Session tokens correspond to OAuth credentials such as personal access tokens (PATs) and other OAuth authorizations. */
model TokenAdminPagedSessionTokens {
  /** The continuation token that can be used to retrieve the next page of session tokens, or <code>null</code> if there is no next page. */
  @format("uuid") continuationToken?: string;

  /** The list of all session tokens in the current page. */
  value?: SessionToken[];
}

/** A request to revoke a particular delegated authorization. */
model TokenAdminRevocation {
  /** The authorization ID of the OAuth authorization to revoke. */
  @format("uuid") authorizationId?: string;
}

/** A rule which is applied to disable any incoming delegated authorization which matches the given properties. */
model TokenAdminRevocationRule {
  /** A datetime cutoff. Tokens created before this time will be rejected. This is an optional parameter. If omitted, defaults to the time at which the rule was created. */
  createdBefore?: utcDateTime;

  /** A string containing a space-delimited list of OAuth scopes. A token matching any one of the scopes will be rejected. For a list of all OAuth scopes supported by Azure DevOps, see: https://docs.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/oauth?view=azure-devops#scopes This is a mandatory parameter. */
  scopes?: string;
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface PersonalAccessTokens {
  /** Lists of all the session token details of the personal access tokens (PATs) for a particular user. */
  @tag("Personal Access Tokens")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "personalAccessTokens")
  @extension("x-ms-vss-method", "ListPersonalAccessTokens")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokenadmin/personalaccesstokens/{subjectDescriptor}")
  @get
  List(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The descriptor of the target user. */
    @path subjectDescriptor: string,

    /** The maximum number of results to return on each page. */
    @query(#{ explode: true }) pageSize?: int32,

    /** An opaque data blob that allows the next page of data to resume immediately after where the previous page ended. The only reliable way to know if there is more data left is the presence of a continuation token. */
    @query(#{ explode: true }) continuationToken?: string,

    /** Set to false for PAT tokens and true for SSH tokens. */
    @query(#{ explode: true }) isPublic?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): TokenAdminPagedSessionTokens | BadRequestResponse | UnauthorizedResponse | NotFoundResponse;
}

interface RevocationRules {
  /** Creates a revocation rule to prevent the further usage of any OAuth authorizations that were created before the current point in time and which match the conditions in the rule. Not all kinds of OAuth authorizations can be revoked directly. Some, such as self-describing session tokens, must instead by revoked by creating a rule which will be evaluated and used to reject matching OAuth credentials at authentication time. Revocation rules created through this endpoint will apply to all credentials that were issued before the datetime at which the rule was created and which match one or more additional conditions. */
  @tag("Revocation Rules")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "revocationRules")
  @extension("x-ms-vss-method", "CreateRevocationRule")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokenadmin/revocationrules")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The revocation rule to create. The rule must specify a space-separated list of scopes, after which preexisting OAuth authorizations that match that any of the scopes will be rejected. For a list of all OAuth scopes supported by VSTS, see: https://docs.microsoft.com/en-us/vsts/integrate/get-started/authentication/oauth?view=vsts#scopes The rule may also specify the time before which to revoke tokens. */
    @body body: TokenAdminRevocationRule,
  ): CreatedResponse | BadRequestResponse | UnauthorizedResponse;
}

interface Revocations {
  /** Revokes the listed OAuth authorizations. */
  @tag("Revocations")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "revocations")
  @extension("x-ms-vss-method", "RevokeAuthorizations")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokenadmin/revocations")
  @post
  RevokeAuthorizations(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Set to false for PAT tokens and true for SSH tokens. */
    @query(#{ explode: true }) isPublic?: boolean,

    ...Parameters.`api-Version-preview`.`1`,

    /** The list of objects containing the authorization IDs of the OAuth authorizations, such as session tokens retrieved by listed a users PATs, that should be revoked. */
    @body body: TokenAdminRevocation[],
  ): NoContentResponse | BadRequestResponse | UnauthorizedResponse;
}
