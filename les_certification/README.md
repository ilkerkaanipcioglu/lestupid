# Les Certification

Les Certification is the LesTupid review, registry, portability, identity,
activation, loyalty, and proof policy layer.

It is not just a document folder. It should work as:

- `standalone_app`: a certification registry and review system that can run by
  itself.
- `ecosystem_activated_app`: the policy and discovery layer used by Les Poke,
  Les Match, Les Wait, Les Commerce, and future LesTupid apps.

## Source Of Truth

- `certification-registry.json`: current product registry.
- `lestupid-identity-activation-spec.md`: one identity, many app activations.
- `lestupid-app-portability-spec.md`: standalone plus ecosystem activation
  contract.
- `lestupid-loyalty-network-spec.md`: certification, loyalty, and token ledger
  rules.
- `pseudonymous-trust-credentials-spec.md`: identity-hidden trust credentials
  for places, apps, commerce, queues, delivery, learning and contribution.
- `lestupid-ecosystem-rollout-plan.md`: rollout sequence.
- `lestupid-brand-scope.md`: brand and ecosystem scope.
- `lestupid.app.json`: machine-readable app manifest for this certification
  layer.

## Current Architecture Rule

Keep certification simple and API-first.

Certification may later become a Phoenix service backed by PostgreSQL, but the
current repo state keeps the registry as JSON and specs as Markdown. Apps should
read the registry and manifests without importing each other's business logic.

## Validate

```powershell
node les_certification/validate-registry.mjs
```

The validator checks JSON shape, required policy spec paths, internal product
directories, app manifest paths, and required manifest fields when a manifest is
present.
