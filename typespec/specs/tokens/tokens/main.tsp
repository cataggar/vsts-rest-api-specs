import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Tokens" })
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
namespace Tokens;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model AccessTokenResult {
  accessToken?: JsonWebToken;
  @extension(
    "x-ms-enum",
    #{
      name: "TokenError",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "grantTypeRequired", description: "" },
        #{ value: "authorizationGrantRequired", description: "" },
        #{ value: "clientSecretRequired", description: "" },
        #{ value: "redirectUriRequired", description: "" },
        #{ value: "invalidAuthorizationGrant", description: "" },
        #{ value: "invalidAuthorizationScopes", description: "" },
        #{ value: "invalidRefreshToken", description: "" },
        #{ value: "authorizationNotFound", description: "" },
        #{ value: "authorizationGrantExpired", description: "" },
        #{ value: "accessAlreadyIssued", description: "" },
        #{ value: "invalidRedirectUri", description: "" },
        #{ value: "accessTokenNotFound", description: "" },
        #{ value: "invalidAccessToken", description: "" },
        #{ value: "accessTokenAlreadyRefreshed", description: "" },
        #{ value: "invalidClientSecret", description: "" },
        #{ value: "clientSecretExpired", description: "" },
        #{ value: "serverError", description: "" },
        #{ value: "accessDenied", description: "" },
        #{ value: "accessTokenKeyRequired", description: "" },
        #{ value: "invalidAccessTokenKey", description: "" },
        #{ value: "failedToGetAccessToken", description: "" },
        #{ value: "invalidClientId", description: "" },
        #{ value: "invalidClient", description: "" },
        #{ value: "invalidValidTo", description: "" },
        #{ value: "invalidUserId", description: "" },
        #{ value: "failedToIssueAccessToken", description: "" },
        #{ value: "authorizationGrantScopeMissing", description: "" },
        #{ value: "invalidPublicAccessTokenKey", description: "" },
        #{ value: "invalidPublicAccessToken", description: "" },
        #{ value: "publicFeatureFlagNotEnabled", description: "" },
        #{ value: "sshPolicyDisabled", description: "" },
        #{ value: "hostAuthorizationNotFound", description: "" },
        #{ value: "hostAuthorizationIsNotValid", description: "" },
        #{ value: "invalidScope", description: "" },
        #{ value: "globalPatUsageDisabled", description: "" }
      ],
    }
  )
  accessTokenError?:
    | "none"
    | "grantTypeRequired"
    | "authorizationGrantRequired"
    | "clientSecretRequired"
    | "redirectUriRequired"
    | "invalidAuthorizationGrant"
    | "invalidAuthorizationScopes"
    | "invalidRefreshToken"
    | "authorizationNotFound"
    | "authorizationGrantExpired"
    | "accessAlreadyIssued"
    | "invalidRedirectUri"
    | "accessTokenNotFound"
    | "invalidAccessToken"
    | "accessTokenAlreadyRefreshed"
    | "invalidClientSecret"
    | "clientSecretExpired"
    | "serverError"
    | "accessDenied"
    | "accessTokenKeyRequired"
    | "invalidAccessTokenKey"
    | "failedToGetAccessToken"
    | "invalidClientId"
    | "invalidClient"
    | "invalidValidTo"
    | "invalidUserId"
    | "failedToIssueAccessToken"
    | "authorizationGrantScopeMissing"
    | "invalidPublicAccessTokenKey"
    | "invalidPublicAccessToken"
    | "publicFeatureFlagNotEnabled"
    | "sshPolicyDisabled"
    | "hostAuthorizationNotFound"
    | "hostAuthorizationIsNotValid"
    | "invalidScope"
    | "globalPatUsageDisabled"
    | string;
  @format("uuid") authorizationId?: string;
  errorDescription?: string;
  hasError?: boolean;
  isFirstPartyClient?: boolean;
  refreshToken?: RefreshTokenGrant;
  scope?: string;
  tokenType?: string;
  validTo?: utcDateTime;
}

model AuthorizationGrant {
  @extension(
    "x-ms-enum",
    #{
      name: "GrantType",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "jwtBearer", description: "" },
        #{ value: "refreshToken", description: "" },
        #{ value: "implicit", description: "" },
        #{ value: "clientCredentials", description: "" }
      ],
    }
  )
  grantType?: "none" | "jwtBearer" | "refreshToken" | "implicit" | "clientCredentials" | string;
}

model IssuedToken {
  isAuthenticated?: boolean;
  properties?: Record<string>;
}

model JsonWebToken {
  ...IssuedToken;
}

/** Returned by the List method; contains a list of personal access tokens (PATs) and the continuation token to get the next page of results */
model PagedPatTokens {
  /** Used to access the next page of results in successive API calls to list personal access tokens (PATs) */
  continuationToken?: string;

  /** The list of personal access tokens (PATs) */
  patTokens?: PatToken[];
}

/** Represents a personal access token (PAT) used to access Azure DevOps resources */
model PatToken {
  /** Unique guid identifier */
  @format("uuid") authorizationId?: string;

  /** The token name */
  displayName?: string;

  /** The token scopes for accessing Azure DevOps resources */
  scope?: string;

  /** The organizations for which the token is valid; null if the token applies to all of the user's accessible organizations */
  targetAccounts?: string[];

  /** The unique token string generated at creation */
  token?: string;

  /** The token creation date */
  validFrom?: utcDateTime;

  /** The token expiration date */
  validTo?: utcDateTime;
}

/** Encapsulates the request parameters for creating a new personal access token (PAT) */
model PatTokenCreateRequest {
  /** True, if this personal access token (PAT) is for all of the user's accessible organizations. False, if otherwise (e.g. if the token is for a specific organization) */
  allOrgs?: boolean;

  /** The token name */
  displayName?: string;

  /** The token scopes for accessing Azure DevOps resources */
  scope?: string;

  /** The token expiration date. If the 'Enforce maximum personal access token lifespan' policy is enabled and the provided token expiration date is past the maximum allowed lifespan, it will return back a PAT with a validTo date equal to the current date + maximum allowed lifespan. */
  validTo?: utcDateTime;
}

/** Contains the resulting personal access token (PAT) and the error (if any) that occurred during the operation */
model PatTokenResult {
  patToken?: PatToken;

  /** The error (if any) that occurred */
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
  patTokenError?:
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

  /** The error message (if any) that occurred */
  patTokenErrorMessage?: string;
}

/** Encapsulates the request parameters for updating a personal access token (PAT) */
model PatTokenUpdateRequest {
  /** (Optional) True if this personal access token (PAT) is for all of the user's accessible organizations. False if otherwise (e.g. if the token is for a specific organization) */
  allOrgs?: boolean;

  /** The authorizationId identifying a single, unique personal access token (PAT) */
  @format("uuid") authorizationId?: string;

  /** (Optional) The token name */
  displayName?: string;

  /** (Optional) The token scopes for accessing Azure DevOps resources */
  scope?: string;

  /** (Optional) The token expiration date. If the 'Enforce maximum personal access token lifespan' policy is enabled and the provided token expiration date is past the maximum allowed lifespan, it will return back a PAT with a validTo date equal to the date when the PAT was intially created + maximum allowed lifespan. */
  validTo?: utcDateTime;
}

model RefreshTokenGrant {
  ...AuthorizationGrant;
  jwt?: JsonWebToken;
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

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Pats {
  /** Revokes a personal access token (PAT) by authorizationId. */
  @tag("Pats")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pats")
  @extension("x-ms-vss-method", "Revoke")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokens/pats")
  @delete
  Revoke(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The authorizationId identifying a single, unique personal access token (PAT) */
    @format("uuid") @query(#{ explode: true }) authorizationId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Gets a single personal access token (PAT). */
  @tag("Pats")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pats")
  @extension("x-ms-vss-method", "GetPat")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokens/pats")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The authorizationId identifying a single, unique personal access token (PAT) */
    @format("uuid") @query(#{ explode: true }) authorizationId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): PatTokenResult;

  /** Creates a new personal access token (PAT) for the requesting user. */
  @tag("Pats")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pats")
  @extension("x-ms-vss-method", "CreatePat")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokens/pats")
  @post
  Create(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: PatTokenCreateRequest,
  ): PatTokenResult;

  /** Updates an existing personal access token (PAT) with the new parameters. To update a token, it must be valid (has not been revoked). */
  @tag("Pats")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "pats")
  @extension("x-ms-vss-method", "UpdatePat")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/tokens/pats")
  @put
  Update(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: PatTokenUpdateRequest,
  ): PatTokenResult;
}
