import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Favorite" })
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
namespace Favorite;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model ArtifactProperties {}

/** Describes the scope a favorited Artifact resides in. e.g. A team project. */
model ArtifactScope {
  /** The identifier of the scope the artifact resides in. For a TFS Project, this refers to the Project GUID string. For a Collection, marked this property with an empty string. */
  id?: string;

  /** Name of the artifact scope (e.g. Project Name) Note: This property is a read-only extension over the stored favorite model. This value cannot be overridden on writes. */
  name?: string;

  /** Type of scope the favorite artifact resides in. Known scopes include 'Project' or 'Collection' */
  type?: string;
}

/** Implementation of Favorite contract following modern storage */
model Favorite {
  _links?: ReferenceLinks;

  /** ID of the favorited artifact, unique in context of this artifact type. */
  artifactId?: string;

  /** Indicates if the artifact described by this favorite could not be located. */
  artifactIsDeleted?: boolean;

  /** Last known name of the artifact. */
  artifactName?: string;

  artifactProperties?: ArtifactProperties;
  artifactScope?: ArtifactScope;

  /** Type of artifact. */
  artifactType?: string;

  /** Date and time this Favorite was created on server. */
  creationDate?: utcDateTime;

  /** Unique Id of the favorite item, defined by server at creation time. */
  @format("uuid") id?: string;

  owner?: IdentityRef;

  /** Fully-Qualified link to this Resource */
  url?: string;
}

model FavoriteCreateParameters {
  artifactId?: string;
  artifactName?: string;
  artifactProperties?: ArtifactProperties;
  artifactScope?: ArtifactScope;
  artifactType?: string;
}

/** Exposes a provider of favorites. */
model FavoriteProvider {
  ...FavoritesSecuredObject;

  /** Favorite artifact type */
  artifactType?: string;

  /** URI for retrieving favorite artifacts */
  artifactUri?: string;

  /** contributed client side service that is available for this provider to provide dynamic associated data. */
  clientServiceIdentifier?: string;

  /** Contribution Id */
  contributionId?: string;

  /** Css class to be applied to the icon for the artifact. */
  iconClass?: string;

  /** Name of the fabric icon to be applied for the artifact */
  iconName?: string;

  /** Group of favorites will be rendered in this order, 0 is top If 2 types share order, they will be coalesced into a single group */
  order?: int32;

  /** Name used for rendering the title of each group of favorites */
  pluralName?: string;

  /** Service identifier of the service. */
  @format("uuid") serviceIdentifier?: string;

  /** Base URI of the service */
  serviceUri?: string;
}

model FavoritesSecuredObject {
  token?: string;
}

model GraphSubjectBase {
  _links?: ReferenceLinks;

  /** The descriptor is the primary way to reference the graph subject while the system is running. This field will uniquely identify the same graph subject across both Accounts and Organizations. */
  descriptor?: string;

  /** This is the non-unique display name of the graph subject. To change this field, you must alter its value in the source provider. */
  displayName?: string;

  /** This url is the full route to the source resource of this graph subject. */
  url?: string;
}

model IdentityRef {
  ...GraphSubjectBase;

  /** Deprecated - Can be retrieved by querying the Graph user referenced in the 'self' entry of the IdentityRef '_links' dictionary */
  directoryAlias?: string;

  id?: string;

  /** Deprecated - Available in the 'avatar' entry of the IdentityRef '_links' dictionary */
  imageUrl?: string;

  /** Deprecated - Can be retrieved by querying the Graph membership state referenced in the 'membershipState' entry of the GraphUser '_links' dictionary */
  inactive?: boolean;

  /** Deprecated - Can be inferred from the subject type of the descriptor (Descriptor.IsAadUserType/Descriptor.IsAadGroupType) */
  isAadIdentity?: boolean;

  /** Deprecated - Can be inferred from the subject type of the descriptor (Descriptor.IsGroupType) */
  isContainer?: boolean;

  isDeletedInOrigin?: boolean;

  /** Deprecated - not in use in most preexisting implementations of ToIdentityRef */
  profileUrl?: string;

  /** Deprecated - use Domain+PrincipalName instead */
  uniqueName?: string;
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

interface Favorites {
  @tag("Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "favorites")
  @extension("x-ms-vss-method", "GetFavorites")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/favorite/favorites")
  @get
  GetFavorites(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @query(#{ explode: true }) artifactType?: string,
    @query(#{ explode: true }) artifactScopeType?: string,
    @query(#{ explode: true }) artifactScopeId?: string,
    @query(#{ explode: true }) includeExtendedDetails?: boolean,
    ...Parameters.`api-Version-preview`.`1`,
  ): Body<Favorite[]>;

  @tag("Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "favorites")
  @extension("x-ms-vss-method", "CreateFavorite")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/favorite/favorites")
  @post
  CreateFavorite(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
    @body body: FavoriteCreateParameters,
  ): Favorite;

  @tag("Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "favorites")
  @extension("x-ms-vss-method", "DeleteFavoriteById")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/favorite/favorites/{favoriteId}")
  @delete
  DeleteFavoriteById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @format("uuid") @path favoriteId: string,
    @query(#{ explode: true }) artifactType: string,
    @query(#{ explode: true }) artifactScopeType: string,
    @query(#{ explode: true }) artifactScopeId?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  @tag("Favorites")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "favorites")
  @extension("x-ms-vss-method", "GetFavoriteById")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/favorite/favorites/{favoriteId}")
  @get
  GetFavoriteById(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    @format("uuid") @path favoriteId: string,
    @query(#{ explode: true }) artifactScopeType: string,
    @query(#{ explode: true }) artifactType: string,
    @query(#{ explode: true }) artifactScopeId?: string,
    @query(#{ explode: true }) includeExtendedDetails?: boolean,
    ...Parameters.`api-Version-preview`.`1`,
  ): Favorite;
}
