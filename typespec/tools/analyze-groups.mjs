import fs from "node:fs";
import path from "node:path";

const root = "C:/Users/cataggar/k/vsts-rest-api-specs/typespec/specs";
let total = 0;
let withPrefix = 0;
const areaStats = [];

function walk(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...walk(p));
    else if (e.name === "main.tsp") out.push(p);
  }
  return out;
}

for (const file of walk(root)) {
  const src = fs.readFileSync(file, "utf8");
  const ops = [...src.matchAll(/^op\s+([A-Za-z_][A-Za-z0-9_]*)\(/gm)].map((m) => m[1]);
  const groups = new Map();
  let noPrefix = 0;
  for (const op of ops) {
    const i = op.indexOf("_");
    if (i <= 0) {
      noPrefix++;
      continue;
    }
    const g = op.slice(0, i);
    const rest = op.slice(i + 1);
    if (!groups.has(g)) groups.set(g, new Set());
    if (groups.get(g).has(rest)) console.log(`COLLISION ${file}: ${g}.${rest}`);
    groups.get(g).add(rest);
  }
  total += ops.length;
  withPrefix += ops.length - noPrefix;
  areaStats.push({
    spec: path.relative(root, path.dirname(file)).replace(/\\/g, "/"),
    ops: ops.length,
    groups: groups.size,
    noPrefix,
  });
}

console.log(`total ops ${total}, with Group_ prefix ${withPrefix}, without ${total - withPrefix}`);
console.log("specs with un-prefixed ops:");
for (const a of areaStats.filter((a) => a.noPrefix > 0)) console.log(` ${a.spec}: ${a.noPrefix}/${a.ops}`);
const groupsTotal = areaStats.reduce((a, s) => a + s.groups, 0);
console.log(`total interface groups if grouped: ${groupsTotal}`);
