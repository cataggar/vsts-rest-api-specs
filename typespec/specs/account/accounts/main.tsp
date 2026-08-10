import "@typespec/http";
import "@typespec/openapi";
import "@typespec/versioning";

using Http;
using OpenAPI;
using Versioning;

@versioned(ServiceApiVersions)
@service(#{ title: "Account" })
@info(#{
  version: "7.2-preview",
  contact: #{ name: "nugetvss", email: "nugetvss@microsoft.com" },
  license: #{
    name: "MICROSOFT SOFTWARE LICENSE TERMS",
    url: "https://go.microsoft.com/fwlink/?LinkId=329770",
  },
  termsOfService: "https://go.microsoft.com/fwlink/?LinkId=329770",
})
@server("https://app.vssps.visualstudio.com")
namespace Account;

enum ServiceApiVersions {
  v7_2_preview: "7.2-preview",
}

model Account {
  /** Identifier for an Account */
  @format("uuid") accountId?: string;

  /** Name for an account */
  accountName?: string;

  /** Owner of account */
  @format("uuid") accountOwner?: string;

  /** Current account status */
  @extension(
    "x-ms-enum",
    #{
      name: "AccountStatus",
      values: #[
        #{ value: "none", description: "" },
        #{
          value: "enabled",
          description: "This hosting account is active and assigned to a customer.",
        },
        #{ value: "disabled", description: "This hosting account is disabled." },
        #{
          value: "deleted",
          description: "This account is part of deletion batch and scheduled for deletion.",
        },
        #{
          value: "moved",
          description: "This account is not mastered locally and has physically moved.",
        }
      ],
    }
  )
  accountStatus?: "none" | "enabled" | "disabled" | "deleted" | "moved" | string;

  /** Type of account: Personal, Organization */
  @extension(
    "x-ms-enum",
    #{
      name: "AccountType",
      values: #[
        #{ value: "personal", description: "" },
        #{ value: "organization", description: "" }
      ],
    }
  )
  accountType?: "personal" | "organization" | string;

  /** Uri for an account */
  accountUri?: string;

  /** Who created the account */
  @format("uuid") createdBy?: string;

  /** Date account was created */
  createdDate?: utcDateTime;

  hasMoved?: boolean;

  /** Identity of last person to update the account */
  @format("uuid") lastUpdatedBy?: string;

  /** Date account was last updated */
  lastUpdatedDate?: utcDateTime;

  /** Namespace for an account */
  @format("uuid") namespaceId?: string;

  @format("uuid") newCollectionId?: string;

  /** Organization that created the account */
  organizationName?: string;

  properties?: PropertiesCollection;

  /** Reason for current status */
  statusReason?: string;
}

model AccountCreateInfoInternal {
  accountName?: string;
  @format("uuid") creator?: string;
  organization?: string;
  preferences?: AccountPreferencesInternal;
  properties?: PropertiesCollection;
  serviceDefinitions?: {}[];
}

model AccountPreferencesInternal {
  @format("CultureInfo") culture?: string;
  @format("CultureInfo") language?: string;
  @format("TimeZoneInfo") timeZone?: string;
}

/** The class represents a property bag as a collection of key-value pairs. Values of all primitive types (any type with a `TypeCode != TypeCode.Object`) except for `DBNull` are accepted. Values of type Byte[], Int32, Double, DateType and String preserve their type, other primitives are retuned as a String. Byte[] expected as base64 encoded string. */
model PropertiesCollection {
  /** The count of properties in the collection. */
  count?: int32;

  item?: {};

  /** The set of keys in the collection. */
  keys?: string[];

  /** The set of values in the collection. */
  values?: string[];
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

/** A collection of `Account` as returned by Azure DevOps. */
model AccountList {
  count?: int32;
  value?: Account[];
}

namespace Parameters {
  namespace `api-Version-preview` {
    model `1` {
      /** Version of the API to use. This should be set to '7.2-preview.1' to use this version of the api. */
      @query(#{ name: "api-version", explode: true }) apiVersion: string;
    }
  }
}

interface Accounts {
  /** Get a list of accounts for a specific owner or a specific member. One of the following parameters is required: ownerId, memberId. */
  @tag("Accounts")
  @extension("x-ms-docs-override-version", "7.2-preview.1")
  @extension("x-ms-vss-resource", "accounts")
  @extension("x-ms-vss-method", "GetAccounts")
  @extension("x-ms-preview", true)
  @route("/_apis/accounts")
  @get
  List(
    /** ID for the owner of the accounts. */
    @format("uuid") @query(#{ explode: true }) ownerId?: string,

    /** ID for a member of the accounts. */
    @format("uuid") @query(#{ explode: true }) memberId?: string,

    @query(#{ explode: true }) properties?: string,
    ...Parameters.`api-Version-preview`.`1`,
  ): AccountList;
}
