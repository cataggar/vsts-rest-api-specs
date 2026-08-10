import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Symbol" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://artifacts.dev.azure.com")
namespace Symbol;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

/** A dual-purpose data object, the debug entry is used by the client to publish the symbol file (with file's blob identifier, which can be calculated from VSTS hashing algorithm) or query the file (with a client key). Since the symbol server tries to return a matched symbol file with the richest information level, it may not always point to the same symbol file for different queries with same client key. */
model DebugEntry {
  ...ResourceBase;
  blobDetails?: JsonBlobIdentifierWithBlocks;
  blobIdentifier?: JsonBlobIdentifier;

  /** The URI to get the symbol file. Provided by the server, the URI contains authentication information and is readily accessible by plain HTTP GET request. The client is recommended to retrieve the file as soon as it can since the URI will expire in a short period. */
  blobUri?: string;

  /** A key the client (debugger, for example) uses to find the debug entry. Note it is not unique for each different symbol file as it does not distinguish between those which only differ by information level. */
  clientKey?: string;

  domainId?: IDomainId;

  /** The information level this debug entry contains. */
  @extension(
    "x-ms-enum",
    #{
      name: "DebugInformationLevel",
      values: #[
        #{ value: "none", description: "If set, the .pdb file contains no debug information." },
        #{
          value: "binary",
          description: "If set, the .pdb file contains debug information which is binary.",
        },
        #{ value: "publics", description: "If set, the .pdb file contains public symbols." },
        #{
          value: "traceFormatPresent",
          description: "If set, the .pdb file contains trace format.",
        },
        #{ value: "typeInfo", description: "If set, the .pdb file contains type information." },
        #{
          value: "lineNumbers",
          description: "If set, the .pdb file contains line number information.",
        },
        #{
          value: "globalSymbols",
          description: "If set, the .pdb file contains symbol information.",
        },
        #{
          value: "private",
          description: "If set, the .pdb file contains public symbols and has type, line number and symbol information.",
        },
        #{
          value: "sourceIndexed",
          description: "If set, the .pdb file supports the source server.",
        }
      ],
    }
  )
  informationLevel?:
    | "none"
    | "binary"
    | "publics"
    | "traceFormatPresent"
    | "typeInfo"
    | "lineNumbers"
    | "globalSymbols"
    | "private"
    | "sourceIndexed";

  /** The identifier of symbol request to which this debug entry belongs. */
  requestId?: string;

  /** The size for the debug entry. */
  size?: int64;

  /** The status of debug entry. */
  @extension(
    "x-ms-enum",
    #{
      name: "DebugEntryStatus",
      values: #[
        #{
          value: "none",
          description: "The status of this debug entry is undefined or irrelevant in the current context.",
        },
        #{ value: "created", description: "The debug entry is created and read to use." },
        #{
          value: "blobMissing",
          description: "The symbol file for the requested debug entry is missing.",
        }
      ],
    }
  )
  status?: "none" | "created" | "blobMissing";
}

/** A batch of debug entry to create. */
model DebugEntryCreateBatch {
  /** Defines what to do when a debug entry in the batch already exists. */
  @extension(
    "x-ms-enum",
    #{
      name: "DebugEntryCreateBehavior",
      values: #[
        #{
          value: "throwIfExists",
          description: "Throw exceptions at server end. This will translate to 409 (Conflict) HTTP status code.",
        },
        #{
          value: "skipIfExists",
          description: "Do not add this debug entry. The rest of the batch, if any, is not affected.",
        },
        #{ value: "overwriteIfExists", description: "Overwrite the existing debug entry." }
      ],
    }
  )
  createBehavior?: "throwIfExists" | "skipIfExists" | "overwriteIfExists";

  /** The debug entries. */
  debugEntries?: DebugEntry[];

  /** Serialized Proof nodes, used to verify uploads on server side for Chunk Dedup DebugEntry */
  proofNodes?: string[];
}

model IDomainId {}

/** BlobBlock hash formatted to be deserialized for symbol service. */
model JsonBlobBlockHash {
  /** Array of hash bytes. */
  hashBytes?: bytes[];
}

model JsonBlobIdentifier {
  identifierValue?: bytes[];
}

/** BlobIdentifier with block hashes formatted to be deserialzied for symbol service. */
model JsonBlobIdentifierWithBlocks {
  /** List of blob block hashes. */
  blockHashes?: JsonBlobBlockHash[];

  /** Array of blobId bytes. */
  identifierValue?: bytes[];
}

/** Symbol request. */
model Request {
  ...ResourceBase;

  /** An optional human-facing description. */
  description?: string;

  domainId?: IDomainId;

  /** An optional expiration date for the request. The request will become inaccessible and get deleted after the date, regardless of its status. On an HTTP POST, if expiration date is null/missing, the server will assign a default expiration data (30 days unless overwridden in the registry at the account level). On PATCH, if expiration date is null/missing, the behavior is to not change whatever the request's current expiration date is. */
  expirationDate?: utcDateTime;

  /** Indicates if request should be chunk dedup */
  isChunked?: boolean;

  /** Date of the last change to the symbol request. */
  key?: string;

  /** Date of the last change to the symbol request. */
  lastOperationDate?: utcDateTime;

  /** Last Operation to symbol request. */
  lastOperationName?: string;

  /** A human-facing name for the request. Required on POST, ignored on PATCH. */
  name?: string;

  /** The total Size for this request. */
  size?: int64;

  /** The status for this request. */
  @extension(
    "x-ms-enum",
    #{
      name: "RequestStatus",
      values: #[
        #{
          value: "none",
          description: "The status of this request is undefined or irrelevant in the current context.",
        },
        #{
          value: "created",
          description: "The request is created, and is open to accepting debug entries.",
        },
        #{
          value: "sealed",
          description: "The request is sealed. No more debug entries can be added to it.",
        },
        #{
          value: "unavailable",
          description: "The request is no longer available, possibly deleted.",
        }
      ],
    }
  )
  status?: "none" | "created" | "sealed" | "unavailable";
}

model ResourceBase {
  /** The ID of user who created this item. Optional. */
  @format("uuid") createdBy?: string;

  /** The date time when this item is created. Optional. */
  createdDate?: utcDateTime;

  /** An identifier for this item. Optional. */
  id?: string;

  /** An opaque ETag used to synchronize with the version stored at server end. Optional. */
  storageETag?: string;

  /** A URI which can be used to retrieve this item in its raw format. Optional. Note this is distinguished from other URIs that are present in a derived resource. */
  url?: string;
}

/** A collection of `DebugEntry` as returned by Azure DevOps. */
model DebugEntryList {
  count?: int32;
  value?: DebugEntry[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Availability {
  /** Check the availability of symbol service. This includes checking for feature flag, and possibly license in future. Note this is NOT an anonymous endpoint, and the caller will be redirected to authentication before hitting it. */
  @tag("Availability")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "availability")
  @extension("x-ms-vss-method", "CheckAvailabilityAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/availability")
  @get
  CheckAvailability(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;
}

interface Client {
  /** Get client version information. */
  @tag("Client")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "client")
  @extension("x-ms-vss-method", "HeadClient")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/client")
  @head
  HeadClient(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get the client package. */
  @tag("Client")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "client")
  @extension("x-ms-vss-method", "GetClient")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/client/{clientType}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** Either 'EXE' for a zip file containing a Windows symbol client (a.k.a. symbol.exe) along with dependencies, or 'TASK' for a VSTS task that can be run on a VSTS build agent. All the other values are invalid. The parameter is case-insensitive. */
    @path clientType: string,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | Body<string>
    | {
        @statusCode statusCode: 404;
        @body @format("Stream") body: string;
      };
}

interface Requests {
  /** Delete a symbol request by request name. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "DeleteRequestsRequestNameAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests")
  @delete
  DeleteRequestsRequestName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request name. */
    @query(#{ explode: true }) requestName: string,

    /** If true, delete all the debug entries under this request synchronously in the current session. If false, the deletion will be postponed to a later point and be executed automatically by the system. */
    @query(#{ explode: true }) synchronous?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a symbol request by request name. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "GetRequestsRequestNameAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests")
  @get
  GetRequestsRequestName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request name. */
    @query(#{ explode: true }) requestName: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Request | (NotFoundResponse & Request);

  /** Update a symbol request by request name. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "UpdateRequestsRequestNameAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests")
  @patch
  UpdateRequestsRequestName(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request name. */
    @query(#{ explode: true }) requestName: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The symbol request. */
    @body body: Request,
  ): Request | (NotFoundResponse & Request) | (ConflictResponse & Request);

  /** Create a new symbol request. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "CreateRequestsAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests")
  @post
  CreateRequests(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The symbol request to create. */
    @body body: Request,
  ): (CreatedResponse & Request) | (ConflictResponse & Request);

  /** Delete a symbol request by request identifier. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "DeleteRequestsRequestIdAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests/{requestId}")
  @delete
  DeleteRequestsRequestId(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request identifier. */
    @path requestId: string,

    /** If true, delete all the debug entries under this request synchronously in the current session. If false, the deletion will be postponed to a later point and be executed automatically by the system. */
    @query(#{ explode: true }) synchronous?: boolean,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse;

  /** Get a symbol request by request identifier. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "GetRequestsRequestIdAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests/{requestId}")
  @get
  GetRequestsRequestId(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request identifier. */
    @path requestId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): Request | (NotFoundResponse & Request);

  /** Update a symbol request by request identifier. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "UpdateRequestsRequestIdAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests/{requestId}")
  @patch
  UpdateRequestsRequestId(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request identifier. */
    @path requestId: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** The symbol request. */
    @body body: Request,
  ): Request | (NotFoundResponse & Request) | (ConflictResponse & Request);

  /** Create debug entries for a symbol request as specified by its identifier. */
  @tag("Requests")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "requests")
  @extension("x-ms-vss-method", "CreateRequestsRequestIdDebugEntriesAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests/{requestId}")
  @post
  CreateRequestsRequestIdDebugEntries(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request identifier. */
    @path requestId: string,

    /** A valid debug entry collection name. Must be 'debugentries'. */
    @query(#{ explode: true }) collection: string,

    ...Parameters.`api-Version-preview`.`1`,

    /** A batch that contains debug entries to create. */
    @body body: DebugEntryCreateBatch,
  ): DebugEntryList | (BadRequestResponse & DebugEntryList) | (ConflictResponse & DebugEntryList);
}

interface Contents {
  /** Get a stitched debug entry for a symbol request as specified by symbol request identifier and debug entry identifier. */
  @tag("Contents")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "contents")
  @extension("x-ms-vss-method", "GetDebugEntryContentAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/requests/{requestId}/contents/{debugEntryId}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** The symbol request identifier. */
    @path requestId: string,

    /** The debug entry identifier. */
    @path debugEntryId: string,

    ...Parameters.`api-Version-preview`.`1`,
  ): OkResponse | NotFoundResponse;
}

interface Symsrv {
  /** Given a client key, returns the best matched debug entry. */
  @tag("Symsrv")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "symsrv")
  @extension("x-ms-vss-method", "GetSymSrvDebugEntryClientKeyAsync")
  @extension("x-ms-preview", true)
  @route("/{organization}/_apis/symbol/symsrv/{debugEntryClientKey}")
  @get
  Get(
    /** The name of the Azure DevOps organization. */
    @path organization: string,

    /** A 'client key' used by both ends of Microsoft's symbol protocol to identify a debug entry. The semantics of client key is governed by symsrv and is beyond the scope of this documentation. */
    @path debugEntryClientKey: string,

    ...Parameters.`api-Version-preview`.`1`,
  ):
    | OkResponse
    | {
        @statusCode statusCode: 302;
      }
    | NotFoundResponse;
}
