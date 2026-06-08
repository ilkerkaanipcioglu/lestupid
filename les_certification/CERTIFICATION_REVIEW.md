# Les Certification Review

Review date: 2026-06-02

## Verdict

Les Certification is viable as the ecosystem policy and registry layer, provided
it stays simple: JSON registry now, PostgreSQL service later.

It should be treated as its own app/system, not as a loose document folder.

## What Is Good

- Registry has a clear schema version and product status list.
- Identity activation and app portability are documented separately.
- Every app can be modeled as `standalone_app` and
  `ecosystem_activated_app`.
- Policy is explicit: Web3 is proof/portability only, AI is recommendation and
  evidence summary only, final certification needs human review.
- Registry can include internal products and expected external products without
  pretending everything is in this repo.

## Fixed In This Pass

- Added `les_certification/README.md`.
- Added `les_certification/lestupid.app.json`.
- Added `les_certification/validate-registry.mjs`.
- Added missing manifests for:
  - `lestupid-roof`
  - `lescommerce-quick-commerce`
  - `lescommerce-diydiy`
- Registered the certification app itself as `les-certification`.
- Connected all internal manifest paths in `certification-registry.json`.
- Fixed the certification criteria punctuation in the identity spec.

## Current Boundaries

Les Certification owns:

- product registry;
- certification criteria;
- identity activation policy;
- portability policy;
- loyalty and proof policy;
- validation tooling.

It must not own:

- Les Match matching logic;
- Les Poke quest logic;
- Les Commerce checkout logic;
- Les Wait queue logic;
- another app's deployment or database.

Those products connect through manifests and optional adapters.

## Certification Criteria For This App

Before Les Certification becomes `certified`, it needs:

- persistent registry storage or a clear migration path from JSON to Postgres;
- signed or auditable registry change history;
- evidence model for each certification decision;
- human review workflow;
- public certificate lookup endpoint;
- export format for registry and evidence;
- validator included in CI or release checks.

## Next Recommended Step

Keep the current JSON registry for speed. When the first real review workflow is
needed, create a small Phoenix API around the same schema:

- `GET /api/certification/products`
- `GET /api/certification/products/:id`
- `POST /api/certification/products/:id/evidence`
- `POST /api/certification/products/:id/reviews`
- `GET /agent-manifest.json`

Do not build a heavy admin platform yet.
