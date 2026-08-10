import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "t" })
@info(#{ version: "1.0" })
namespace t;

union Vis {
  "private" | "public",
  string,
}

model B {
  v?: "private" | "public" | string;
}

model A {
  v?: Vis;
}
