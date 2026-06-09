import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const registryPath = path.join(root, "les_certification", "certification-registry.json");
const productIdsPath = path.join(root, "docs", "PRODUCT_IDS.md");
const registry = JSON.parse(fs.readFileSync(registryPath, "utf8"));

const errors = [];
const warnings = [];

function exists(relativePath) {
  return fs.existsSync(path.join(root, relativePath));
}

function requirePath(relativePath, label) {
  if (!relativePath || !exists(relativePath)) {
    errors.push(`${label} missing: ${relativePath || "(empty)"}`);
  }
}

function warnPath(relativePath, label) {
  if (!relativePath || !exists(relativePath)) {
    warnings.push(`${label} missing: ${relativePath || "(empty)"}`);
  }
}

function canonicalProductIds() {
  if (!fs.existsSync(productIdsPath)) {
    errors.push("docs/PRODUCT_IDS.md missing");
    return new Set();
  }

  const text = fs.readFileSync(productIdsPath, "utf8");
  const match = text.match(/<!-- canonical-product-ids:start -->([\s\S]*?)<!-- canonical-product-ids:end -->/);

  if (!match) {
    errors.push("docs/PRODUCT_IDS.md missing canonical-product-ids markers");
    return new Set();
  }

  return new Set(
    match[1]
      .split(/\r?\n/)
      .map((line) => line.match(/^\|\s*`([^`]+)`\s*\|/))
      .filter(Boolean)
      .map((lineMatch) => lineMatch[1])
  );
}

const canonicalIds = canonicalProductIds();
const idPattern = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

if (registry.schema_version !== "lestupid.certification_registry.v1") {
  errors.push("schema_version must be lestupid.certification_registry.v1");
}

requirePath(registry.policy?.identity_spec, "policy.identity_spec");
requirePath(registry.policy?.portability_spec, "policy.portability_spec");
if (registry.policy?.web3_adapter_spec) {
  requirePath(registry.policy.web3_adapter_spec, "policy.web3_adapter_spec");
}
if (registry.policy?.trust_credentials_spec) {
  requirePath(registry.policy.trust_credentials_spec, "policy.trust_credentials_spec");
}

const ids = new Set();
const priorities = new Set();
const requiredManifestFields = registry.policy?.required_manifest_fields ?? [];

for (const product of registry.products ?? []) {
  if (!product.id) errors.push("product without id");
  if (ids.has(product.id)) errors.push(`duplicate product id: ${product.id}`);
  ids.add(product.id);

  if (product.id && !idPattern.test(product.id)) {
    errors.push(`${product.id} must be lowercase and hyphen-separated`);
  }

  if (product.id && canonicalIds.size > 0 && !canonicalIds.has(product.id)) {
    errors.push(`${product.id} is not listed in docs/PRODUCT_IDS.md`);
  }

  if (product.priority == null) errors.push(`${product.id} missing priority`);
  if (priorities.has(product.priority)) warnings.push(`duplicate priority: ${product.priority}`);
  priorities.add(product.priority);

  if (!product.repository_scope && product.directory) {
    warnPath(product.directory, `${product.id}.directory`);
  }

  if (!Array.isArray(product.runtime_modes) || product.runtime_modes.length === 0) {
    errors.push(`${product.id} missing runtime_modes`);
  }

  if (!product.portability) {
    errors.push(`${product.id} missing portability`);
  }

  if (product.manifest) {
    requirePath(product.manifest, `${product.id}.manifest`);
    if (exists(product.manifest)) {
      const manifest = JSON.parse(fs.readFileSync(path.join(root, product.manifest), "utf8"));
      for (const field of requiredManifestFields) {
        if (manifest[field] == null) {
          errors.push(`${product.id} manifest missing ${field}`);
        }
      }
      if (manifest.product_id !== product.id) {
        errors.push(`${product.id} manifest product_id mismatch: ${manifest.product_id}`);
      }
    }
  } else if (!product.repository_scope) {
    warnings.push(`${product.id} has no manifest yet`);
  }
}

if (warnings.length > 0) {
  console.warn("Warnings:");
  for (const warning of warnings) console.warn(`- ${warning}`);
}

if (errors.length > 0) {
  console.error("Errors:");
  for (const error of errors) console.error(`- ${error}`);
  process.exit(1);
}

console.log("CERTIFICATION_REGISTRY_OK");
