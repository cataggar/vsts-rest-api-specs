import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "DelegatedAuthorization" })
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
namespace DelegatedAuthorization;

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

model Authorization {
  accessIssued?: utcDateTime;
  audience?: string;
  @format("uuid") authorizationId?: string;
  @format("uuid") identityId?: string;
  isAccessUsed?: boolean;
  isValid?: boolean;
  redirectUri?: string;
  @format("uuid") registrationId?: string;
  scopes?: string;
  source?: string;
  validFrom?: utcDateTime;
  validTo?: utcDateTime;
}

model AuthorizationDecision {
  authorization?: Authorization;
  @extension(
    "x-ms-enum",
    #{
      name: "AuthorizationError",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "clientIdRequired", description: "" },
        #{ value: "invalidClientId", description: "" },
        #{ value: "responseTypeRequired", description: "" },
        #{ value: "responseTypeNotSupported", description: "" },
        #{ value: "scopeRequired", description: "" },
        #{ value: "invalidScope", description: "" },
        #{ value: "redirectUriRequired", description: "" },
        #{ value: "insecureRedirectUri", description: "" },
        #{ value: "invalidRedirectUri", description: "" },
        #{ value: "invalidUserId", description: "" },
        #{ value: "invalidUserType", description: "" },
        #{ value: "accessDenied", description: "" }
      ],
    }
  )
  authorizationError?:
    | "none"
    | "clientIdRequired"
    | "invalidClientId"
    | "responseTypeRequired"
    | "responseTypeNotSupported"
    | "scopeRequired"
    | "invalidScope"
    | "redirectUriRequired"
    | "insecureRedirectUri"
    | "invalidRedirectUri"
    | "invalidUserId"
    | "invalidUserType"
    | "accessDenied"
    | string;
  authorizationGrant?: AuthorizationGrant;
  hasError?: boolean;
  isAuthorized?: boolean;
}

model AuthorizationDescription {
  clientRegistration?: Registration;
  hasError?: boolean;
  @extension(
    "x-ms-enum",
    #{
      name: "InitiationError",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "clientIdRequired", description: "" },
        #{ value: "invalidClientId", description: "" },
        #{ value: "responseTypeRequired", description: "" },
        #{ value: "responseTypeNotSupported", description: "" },
        #{ value: "scopeRequired", description: "" },
        #{ value: "invalidScope", description: "" },
        #{ value: "redirectUriRequired", description: "" },
        #{ value: "insecureRedirectUri", description: "" },
        #{ value: "invalidRedirectUri", description: "" }
      ],
    }
  )
  initiationError?:
    | "none"
    | "clientIdRequired"
    | "invalidClientId"
    | "responseTypeRequired"
    | "responseTypeNotSupported"
    | "scopeRequired"
    | "invalidScope"
    | "redirectUriRequired"
    | "insecureRedirectUri"
    | "invalidRedirectUri"
    | string;
  scopeDescriptions?: AuthorizationScopeDescription[];
}

model AuthorizationDetails {
  authorization?: Authorization;
  clientRegistration?: Registration;
  scopeDescriptions?: AuthorizationScopeDescription[];
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

model AuthorizationScopeDescription {
  description?: string;
  market?: string;
  title?: string;
}

model HostAuthorization {
  @format("uuid") hostId?: string;
  @format("uuid") id?: string;
  isValid?: boolean;
  @format("uuid") registrationId?: string;
}

model HostAuthorizationDecision {
  @extension(
    "x-ms-enum",
    #{
      name: "ClientType",
      values: #[
        #{
          value: "confidential",
          description: "Confidential App Registrations, this is the default type for Apps created using UI.",
        },
        #{ value: "public", description: "Public App Registrations" },
        #{ value: "mediumTrust", description: "Medium Trust App Registrations" },
        #{ value: "highTrust", description: "High Trust App Registrations" },
        #{ value: "fullTrust", description: "Full Trust App Registrations" },
        #{ value: "application", description: "Application based OAuth App Registrations" }
      ],
    }
  )
  clientType?:
    | "confidential"
    | "public"
    | "mediumTrust"
    | "highTrust"
    | "fullTrust"
    | "application"
    | string;
  hasError?: boolean;
  @extension(
    "x-ms-enum",
    #{
      name: "HostAuthorizationError",
      values: #[
        #{ value: "none", description: "" },
        #{ value: "clientIdRequired", description: "" },
        #{ value: "accessDenied", description: "" },
        #{ value: "failedToAuthorizeHost", description: "" },
        #{ value: "clientIdNotFound", description: "" },
        #{ value: "invalidClientId", description: "" }
      ],
    }
  )
  hostAuthorizationError?:
    | "none"
    | "clientIdRequired"
    | "accessDenied"
    | "failedToAuthorizeHost"
    | "clientIdNotFound"
    | "invalidClientId"
    | string;
  @format("uuid") hostAuthorizationId?: string;
  @format("uuid") registrationId?: string;
  registrationName?: string;
  setupUri?: string;
}

model IssuedToken {
  isAuthenticated?: boolean;
  properties?: Record<string>;
}

model JsonWebToken {
  ...IssuedToken;
}

model RefreshTokenGrant {
  ...AuthorizationGrant;
  jwt?: JsonWebToken;
}

/** ADO OAuth App Registration */
model Registration {
  accessHash?: string;

  /** Alternative Secret */
  alternativeSecret?: string;

  /** Alternative Secret valid from */
  alternativeSecretValidFrom?: utcDateTime;

  /** Alternative Secret valid to */
  alternativeSecretValidTo?: utcDateTime;

  /** Alternative Secret Version Id of the ADO OAuth App Registration */
  @format("uuid") alternativeSecretVersionId?: string;

  /** Differentiate the different registration types */
  @extension(
    "x-ms-enum",
    #{
      name: "ClientType",
      values: #[
        #{
          value: "confidential",
          description: "Confidential App Registrations, this is the default type for Apps created using UI.",
        },
        #{ value: "public", description: "Public App Registrations" },
        #{ value: "mediumTrust", description: "Medium Trust App Registrations" },
        #{ value: "highTrust", description: "High Trust App Registrations" },
        #{ value: "fullTrust", description: "Full Trust App Registrations" },
        #{ value: "application", description: "Application based OAuth App Registrations" }
      ],
    }
  )
  clientType?:
    | "confidential"
    | "public"
    | "mediumTrust"
    | "highTrust"
    | "fullTrust"
    | "application"
    | string;

  /** Identity Id of the owner of the ADO OAuth App Registration */
  @format("uuid") identityId?: string;

  issuer?: string;

  /** Validity of the ADO OAuth App Registration */
  isValid?: boolean;

  isWellKnown?: boolean;

  /** URL of the organization that that is registering the app to use OAuthURL of the organization that that is registering the app to use OAuth */
  organizationLocation?: string;

  /** Name of the organization that that is registering the app to use OAuth */
  organizationName?: string;

  /** Raw cert data string from public key. This will be used for authenticating medium trust clients. */
  publicKey?: string;

  /** Redirect URIs of the ADO OAuth App Registration */
  redirectUris?: string[];

  /** Description of the ADO OAuth App Registration */
  registrationDescription?: string;

  /** Registration Id of the ADO OAuth App Registration */
  @format("uuid") registrationId?: string;

  /** URL of the ADO OAuth App Registration */
  registrationLocation?: string;

  /** URL of the ADO OAuth App Registration Logo */
  registrationLogoSecureLocation?: string;

  /** Name of the ADO OAuth App Registration */
  registrationName?: string;

  /** URL of the ADO OAuth App Registration Privacy Statement */
  registrationPrivacyStatementLocation?: string;

  /** URL of the ADO OAuth App Registration Terms of Service */
  registrationTermsOfServiceLocation?: string;

  responseTypes?: string;

  /** Scopes that the app will have access to in ADO on behalf of the users */
  scopes?: string;

  secondaryHash?: string;

  /** Primary Secret */
  secret?: string;

  /** Primary Secret valid to */
  secretValidTo?: utcDateTime;

  /** Primary Secret Version Id of the ADO OAuth App Registration */
  @format("uuid") secretVersionId?: string;

  /** URL of the ADO OAuth App Registration Setup */
  setupUri?: string;

  tenantIds?: string[];

  /** Primary Secret valid from */
  validFrom?: utcDateTime;
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
    model `2` {
      /** Version of the API to use. This should be set to '7.2-preview.2' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface RegistrationSecret {
  /** Create Alternative Secret for the ADO OAuth App Registration */
  @tag("Registration Secret")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "registrationSecret")
  @extension("x-ms-vss-method", "CreateAlternativeSecret")
  @extension("x-ms-preview", true)
  @route("/_apis/delegatedauth/registrationsecret/{registrationId}")
  @post
  Create(
    /** The registration id of the ADO OAuth App Registration */
    @format("uuid") @path registrationId: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): JsonWebToken;

  /** Rotate one of the two secrets for the ADO OAuth App Registration */
  @tag("Registration Secret")
  @extension("x-ms-docs-override-version", "7.2-preview.2")
  @extension("x-ms-vss-resource", "registrationSecret")
  @extension("x-ms-vss-method", "RotateSecret")
  @extension("x-ms-preview", true)
  @route("/_apis/delegatedauth/registrationsecret/{registrationId}")
  @put
  RotateSecret(
    /** The registration id of the ADO OAuth App Registration */
    @format("uuid") @path registrationId: string,

    /** The secret type to rotate, either primary or alternative */
    @query(#{ explode: true }) secretType?: string,

    ...Parameters.`api-Version-preview`.`2`,
  ): Registration;
}
