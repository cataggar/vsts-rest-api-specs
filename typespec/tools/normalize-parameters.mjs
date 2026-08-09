// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// normalize-parameters.mjs — give query parameters a legal TypeSpec
// identifier while preserving the wire name.
//
// Azure DevOps flattens nested search objects onto the query string, so
// `tsp-openapi3` has to emit back-tick identifiers:
//
//   @query(#{ explode: true }) `searchCriteria.creatorId`?: string;
//
// Those names leak into every generated language as awkward quoted
// symbols. Moving the wire name into the decorator keeps the request
// identical while giving code generators something they can spell:
//
//   @query(#{ name: "searchCriteria.creatorId", explode: true })
//   searchCriteriaCreatorId?: string;

/** `searchCriteria.creatorId` → `searchCriteriaCreatorId`, `api-version` → `apiVersion`. */
export function toIdentifier(wireName) {
  const segments = wireName.split(/[^A-Za-z0-9]+/).filter(Boolean);
  if (segments.length === 0) return null;
  const name = segments
    .map((segment, index) => (index === 0 ? segment : segment[0].toUpperCase() + segment.slice(1)))
    .join("");
  const identifier = /^[0-9]/.test(name) ? `_${name}` : name;
  return /^[A-Za-z_][A-Za-z0-9_]*$/.test(identifier) ? identifier : null;
}

export function normalizeParameters(source) {
  const renames = new Map();

  const result = source.replace(
    /@query(?:\(#\{ explode: (true|false) \}\))?[ \t]+`([^`]+)`/g,
    (match, explode, wireName) => {
      const identifier = toIdentifier(wireName);
      if (identifier === null || identifier === wireName) return match;
      renames.set(wireName, identifier);
      const options = explode === undefined ? "" : `, explode: ${explode}`;
      return `@query(#{ name: "${wireName}"${options} }) ${identifier}`;
    },
  );

  return { source: result, renames: Object.fromEntries(renames) };
}
