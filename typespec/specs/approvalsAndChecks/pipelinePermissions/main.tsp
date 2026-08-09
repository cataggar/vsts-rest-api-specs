import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "PipelinePermissions" })
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
namespace PipelinePermissions;

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

model Permission {
  authorized?: boolean;
  authorizedBy?: IdentityRef;
  authorizedOn?: utcDateTime;
}

model PipelinePermission {
  ...Permission;
  id?: int32;
}

model PipelineProcessResources {
  resources?: PipelineResourceReference[];
}

model PipelineResourceReference {
  authorized?: boolean;
  @format("uuid") authorizedBy?: string;
  authorizedOn?: utcDateTime;
  definitionId?: int32;
  id?: string;
  type?: string;
}

/** The class to represent a collection of REST reference links. */
model ReferenceLinks {
  /** The readonly view of the links. Because Reference links are readonly, we only want to expose them as read only. */
  links?: Record<{}>;
}

model Resource {
  /** Id of the resource. */
  id?: string;

  /** Name of the resource. */
  name?: string;

  /** Type of the resource. */
  type?: string;
}

model ResourcePipelinePermissions {
  allPipelines?: Permission;
  pipelines?: PipelinePermission[];
  resource?: Resource;
}

/** Batch API to authorize/unauthorize a list of definitions for a multiple resources. */
@tag("Pipeline Permissions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pipelinePermissions")
@extension("x-ms-vss-method", "UpdatePipelinePermisionsForResources")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/pipelinepermissions")
@patch
op PipelinePermissions_UpdatePipelinePermisionsForResources(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  ...Parameters.`api-Version-preview`.`1`,
  @body body: ResourcePipelinePermissions[],
): Body<ResourcePipelinePermissions[]>;

/** Given a ResourceType and ResourceId, returns authorized definitions for that resource. */
@tag("Pipeline Permissions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pipelinePermissions")
@extension("x-ms-vss-method", "GetPipelinePermissionsForResource")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/pipelinepermissions/{resourceType}/{resourceId}")
@get
op PipelinePermissions_Get(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path resourceType: string,
  @path resourceId: string,
  ...Parameters.`api-Version-preview`.`1`,
): ResourcePipelinePermissions;

/** Authorizes/Unauthorizes a list of definitions for a given resource. */
@tag("Pipeline Permissions")
@extension("x-ms-docs-override-version", "7.2-preview.1")
@extension("x-ms-vss-resource", "pipelinePermissions")
@extension("x-ms-vss-method", "UpdatePipelinePermisionsForResource")
@extension("x-ms-preview", true)
@route("/{organization}/{project}/_apis/pipelines/pipelinepermissions/{resourceType}/{resourceId}")
@patch
op PipelinePermissions_UpdatePipelinePermisionsForResource(
  /** The name of the Azure DevOps organization. */
  @path organization: string,

  /** Project ID or project name */
  @path project: string,

  @path resourceType: string,
  @path resourceId: string,
  ...Parameters.`api-Version-preview`.`1`,
  @body body: ResourcePipelinePermissions,
): ResourcePipelinePermissions;

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ explode: true }) `api-version`: string;
    }
  }
}
