# LESTUPID Current State And Recommendations

Report date: 2026-06-09

## Scope

This report summarizes the current repository shape, the strongest existing
patterns, the main risks, the work already completed, and a recommended
development path.

It is based on the current code and documents under:

- `README.md`
- `ROADMAP.md`
- `LESTUPID_APP_CATALOG.md`
- `docs/AGENTIC_AUTH_STRATEGY.md`
- `les_certification/`
- `les_contacts/`
- `les_go/`
- `les_match/api/`
- `Les_poke/api/`
- `Les_Commerce/commerce-backend/`

The repository has since been updated in small, incremental slices aligned with
the recommendations below.

## Executive Summary

The repository is not currently a single Elixir umbrella project. It is closer
to a product ecosystem made of independently runnable apps, manifests, specs,
and a few Phoenix/React implementations.

That is not a weakness at this stage. The current separable-app model fits the
product direction better than a premature umbrella migration. The strongest
path is to keep each product independently runnable, then add a small shared
identity/event contract layer that apps can use through adapters.

Recommended headline direction:

1. Keep the current separable product model.
2. Add a lightweight `les_core` contract API before a full identity platform.
3. Standardize manifests, product ids, event names, and adapter boundaries.
4. Refactor `les_go` into feature modules without changing its behavior.
5. Reuse the `Ecosystem` module pattern from `les_match/api` and `Les_poke/api`.
6. Wrap the commerce backend with LesTupid-compatible contracts before deep
   renaming or restructuring.

## Current Repository Shape

Current top-level product areas include:

- `les_go`: working Vite/React/TypeScript PWA shell.
- `les_match/api`: Phoenix JSON API skeleton with tests.
- `Les_poke/api`: Phoenix JSON API skeleton with tests.
- `les_certification`: JSON registry, specs, manifests, validator.
- `les_contacts`: spec and manifest for private contact/place/product graph.
- `Les_Commerce/commerce-backend`: larger Phoenix commerce application,
  currently named around `Dukkadee`.
- `Les_Commerce/*`: commerce sub-app specs/storefronts.
- `les_ai/*`: AgentAndBot/KADRO related Phoenix projects, data and specs.
- `les_wait`, `les_care`, `les_harmonica`, `les_travel`,
  `les_affiliate_oyun`: mostly specs/manifests/prototypes.

The root docs explicitly describe an architecture where each product can run as:

- `standalone_app`
- `ecosystem_activated_app`

This is the most important architectural rule already present in the repo.

## Verified Status

The following checks were run successfully:

```powershell
node les_certification\validate-registry.mjs
```

Result:

```text
CERTIFICATION_REGISTRY_OK
```

```powershell
mix test
```

In `les_core`:

```text
13 tests, 0 failures
```

In `les_match/api`:

```text
11 tests, 0 failures
```

```powershell
mix test
```

In `Les_poke/api`:

```text
7 tests, 0 failures
```

```powershell
npm run typecheck
```

In `les_go`:

```text
tsc --noEmit completed successfully
```

In `les_contacts`:

```text
9 tests, 0 failures
```

In `Les_poke/api` after contacts draft integration:

```text
7 tests, 0 failures
```

## Work Completed Since Assessment

- Added `docs/PRODUCT_IDS.md` as the canonical product id source.
- Extended `les_certification/validate-registry.mjs` to validate canonical ids
  against `docs/PRODUCT_IDS.md`.
- Aligned manifest and registry ids for `les-wait`, `les-affiliate`, and
  `e-any`.
- Added a lightweight `les_core` Elixir contract package with:
  - canonical product ids
  - activation contract helpers
  - ecosystem metadata
  - standard event envelope validation
  - minimal Plug HTTP surface
  - tested app/channel activation write endpoints
- Added manifest consistency tests in:
  - `les_match/api`
  - `Les_poke/api`
- Added `Les_poke/api` check-in event handling with privacy-aware request
  validation and controller tests.
- Wired `les_go` to a new fallback-safe core adapter:
  - loads identity/activation snapshot from `les_core` when available
  - submits check-ins to `Les_poke/api` when available
  - writes app activations to `les_core` when activate actions are used
  - falls back to mock state when APIs are offline
- Verified the `les_core` HTTP surface and `les_go` HTTP-mode startup in local
  runtime checks.
- Added a first `les_contacts` Elixir runtime slice for private draft timeline
  events created from check-in context.
- Added a minimal `les_contacts` HTTP preview surface for private draft
  check-in timeline events.
- Connected `Les_poke/api` check-in flow to the `les_contacts` private draft
  timeline boundary through a small adapter module.
- Started the `les_go` UI decomposition by moving the Contacts, Care, and
  Harmonica screens into dedicated feature components without changing the
  shell contract.
- Corrected the contacts draft preview placement so it renders in the Contacts
  CRM flow instead of the Match chat surface.
- Continued the `les_go` decomposition by moving Commerce Family, Item Otel,
  and AI/KADRO into feature components while keeping the shell behavior
  type-safe and unchanged.
- Added the first HTTP write surface for shared opportunity events in
  `les_core`, backed by the existing event envelope validator and covered by
  HTTP tests.
- Added the matching `les_core` HTTP write surface for shared check-in events,
  so the manifest-declared core contract is now implemented rather than only
  documented.
- Extended `les_go` core activation flow so activating `les-match` also opens
  the `matchmaking` channel and activating `les-harmonica` also opens the
  `safe_contact` channel.
- Verified that the repository already includes GitHub Actions wiring for the
  `les_certification` registry validator, so that tracker item should be
  considered complete without additional code changes.
- Added a first LesTupid-specific wrapper surface on top of the existing
  Dukkadee commerce backend by serving `/.well-known/lestupid-app.json`
  directly from the repo-level commerce manifest, with runtime endpoint URLs
  injected and covered by a backend test.
- Extended that wrapper into a usable discovery layer with `/api/health` and
  `/api/ecosystem/endpoints`, so existing product, video, appointment, and
  Item Otel APIs are now grouped behind a LesTupid-friendly contract without
  rewriting the underlying commerce engine.

## Strong Existing Patterns

### Separable Apps

The repo already avoids forcing every product into one hard dependency graph.
This is good. Apps can mature at different speeds and later split into separate
repos or deploys if needed.

### Manifest-First Ecosystem Contract

The registry and app manifests are already acting as a lightweight integration
contract. `les_certification/certification-registry.json` plus
`*/lestupid.app.json` provide a useful source of truth.

### Explicit Activation And Consent

The identity specs correctly separate:

- registration
- app activation
- channel activation
- sensitive feature consent
- revocation/pause/export controls

This is especially important for `les_match`, `les_contacts`, `les_care`,
`les_harmonica`, adult contexts, minor-safe contexts, and AI agents.

### Typed Adapter Boundary In Les Go

`les_go/src/types.ts`, `les_go/src/adapters.ts`, and `les_go/src/config.ts`
create a useful boundary between the PWA and future APIs.

The current mock-first approach is appropriate. It keeps the demo deterministic
while future Phoenix APIs are added.

That boundary is now extended by `les_go/src/coreAdapter.ts`, which gives Go a
separate identity/activation/check-in integration path without breaking the
existing mock opportunity feed.

### Ecosystem Modules In Phoenix APIs

Both `les_match/api` and `Les_poke/api` use an `Ecosystem` module to keep
product identity, discovery, manifest data, integrations, and endpoint metadata
in one place.

This is a strong pattern and should become standard for every backend product.

## Main Risks

### Premature Umbrella Migration

Moving everything into a single Elixir umbrella now would create churn without
solving the immediate product risk. The repo has several real apps, prototypes,
spec folders, and older imported code. A forced umbrella structure would likely
slow development and blur product ownership.

Recommendation: defer umbrella migration. Use contracts and adapters first.

### Product Id Drift

There were several naming variants across files, especially around wait,
commerce, affiliate and e-any product ids. The canonical list now lives in
`docs/PRODUCT_IDS.md`; older ids are documented there as legacy aliases.

Folder names such as `Les_Commerce`, `Les_poke`, or
`les_wait/lestupid-waiting-app-spec.md` may remain historical file paths. API
metadata, activation records, manifests, registry ids and event envelopes
should use canonical product ids.

This will become painful once events, activations, manifests, and APIs start
talking to one another.

Recommendation: define one canonical product id list and keep display names
separate from ids.

### Les Go File Growth

`les_go/src/main.tsx`, `les_go/src/data.ts`, and `les_go/src/adapters.ts` are
large and carry many responsibilities. The product behavior is useful, but the
files will become hard to maintain if more apps are added.

Recommendation: split by feature while preserving the current user loop.

### Commerce Backend Boundary

`Les_Commerce/commerce-backend` contains real Phoenix code, auth, product APIs,
Item Otel endpoints, LiveViews, importers, and tests. However, the app is still
named `Dukkadee`, and the router contains repeated/overlapping route groups.

Recommendation: do not rewrite it. First add LesTupid-compatible wrapper
contracts and tests, then gradually clean naming and routes.

### Spec-Only Apps Need A Small Runtime Path

`les_contacts`, `les_wait`, `les_care`, `les_harmonica`, `les_travel`, and
`les_affiliate_oyun` have useful specs, but most lack a minimal backend or
testable contract.

Recommendation: do not build all at once. Give each one a tiny contract surface
only when it becomes needed by the current user loop.

## Component Notes

### les_core

Current state:

- Lightweight contract package exists.
- Shared identity, activation, product ids, and event envelope helpers exist.
- Thin Plug HTTP surface exists for health, identity, activations and manifest
  reads.
- App and channel activation write endpoints exist.
- No full OAuth/OIDC implementation exists.

Recommended approach:

Keep the current package lightweight and add a thin Phoenix or Plug HTTP
surface on top of it, not a heavy identity platform.

Minimum endpoints:

- `GET /api/identity/status`
- `GET /api/activations`
- `POST /api/activations/apps/:product_id`
- `POST /api/activations/channels/:channel_id`
- `POST /api/check-ins`
- `POST /api/opportunity-events`

Minimum records:

- identity
- app activation
- channel activation
- check-in
- opportunity event

OAuth/OIDC, refresh tokens, external providers, billing, notifications, and
full user management can come later.

### les_certification

Current state:

- Good JSON registry and policy docs.
- Working validator.
- Clear boundary: registry and proof policy, not product business logic.

Recommended approach:

Keep it lightweight for now. Do not build a heavy admin panel yet.

Next useful additions:

- CI check for `validate-registry.mjs`
- canonical product id validation
- optional event/schema validation
- signed or auditable registry change history when real reviews begin

### les_go

Current state:

- Working PWA demo shell.
- Strong typed models and adapter concept.
- Mock feed demonstrates cross-app opportunities clearly.
- Main files are becoming too large.

Recommended approach:

Refactor without changing behavior:

```text
les_go/src/
  app/
  features/
    feed/
    places/
    commerceFacets/
    skillAdapters/
    appModes/
  adapters/
    opportunity/
    lesCore/
  mock/
    fixtures/
  shared/
    types/
    ui/
```

The first live integration should be `les_core` activation/check-in state. This
is now partially in place through a fallback-safe adapter, plus live app
activation writes from Go. Keep opportunity cards mock-backed until the backend
contracts are stable.

### les_match/api

Current state:

- Good Phoenix JSON skeleton.
- Explainable static matching read model.
- Safety and consent metadata are visible.
- Tests pass.

Recommended approach:

Keep this pattern. Add Ecto only when decisions/opportunities need persistence.

Next useful additions:

- persisted match opportunities
- persisted user decisions
- event input validation
- `les_core` activation check adapter
- manifest consistency tests against registry product id

### Les_poke/api

Current state:

- Good Phoenix JSON skeleton.
- Static city/quest catalog.
- Manifest/discovery endpoint exists.
- Tests pass.

Recommended approach:

Add check-in events before building a large map system.

Next useful additions:

- `POST /api/check-ins`
- check-in event publication
- quest completion event publication
- coarse/private/public location handling
- registry/manifest consistency tests

### les_contacts

Current state:

- Strong privacy, context-space, and adapter specification.
- Lightweight Elixir runtime now exists for private draft timeline generation.
- Check-in context can become a private review-required draft event.

Recommended approach:

Do not start with external imports. Start with private draft timeline events
created from Les Go / Les Poke check-ins.

First runtime slice:

- contact/place record structs or schemas
- relationship event draft
- explicit visibility and sensitivity fields
- no raw address book upload
- no AI training by default

### Les_Commerce

Current state:

- Commerce family has several sub-areas.
- `commerce-backend` has real Phoenix code and tests.
- Existing code is older and not fully aligned with LesTupid naming.

Recommended approach:

Stabilize through a wrapper rather than a rewrite.

First wrapper contracts:

- product/listing facet API
- purchase completed event
- Item Otel item/listing/care event
- `/.well-known/lestupid-app.json`
- canonical `lescommerce-core` manifest alignment

Then clean router duplication and naming incrementally.

## Recommended Architecture

### Keep The Product Model

Use the existing model:

```text
standalone app
  + optional LesTupid identity adapter
  + optional event publisher/listener
  + optional certification manifest
```

Avoid direct business-logic imports between apps.

### Add A Small Core Contract Layer

`les_core` should initially be a small API and event contract provider.

It should not own every domain. It should own only:

- identity status
- activation status
- channel activation
- scoped consent
- event envelope definitions
- recommendation rules that depend only on public activation/check-in state

### Standardize Event Envelope

Use one event envelope shape across apps:

```json
{
  "schema_version": "lestupid.event.v1",
  "event_id": "evt_123",
  "event_type": "place_checkin_recorded",
  "source_app": "les-poke",
  "identity_id": "id_123",
  "occurred_at": "2026-06-09T12:00:00Z",
  "privacy_level": "coarse_location",
  "payload": {}
}
```

Start with these events:

- `user_registered`
- `app_activated`
- `channel_activated`
- `place_checkin_recorded`
- `match_opportunity_created`
- `match_decision_recorded`
- `purchase_completed`
- `itemotel_item_listed`
- `queue_ticket_created`
- `certification_signal_recorded`

### Standardize Phoenix App Shape

Every Phoenix API should have:

```text
lib/<app>/ecosystem.ex
lib/<app>/events.ex
lib/<app>_web/controllers/agent_manifest_controller.ex
test/<app>_web/controllers/*_test.exs
```

Every backend should expose:

- `/api/health`
- `/.well-known/lestupid-app.json`
- `/agent-manifest.json` when agent-compatible

### Use Manifest Consistency Tests

For each app:

- manifest product id must match registry product id
- `Ecosystem.product_id()` must match manifest product id
- runtime modes must include `standalone_app`
- activation info must exist
- portability info must exist

## Suggested Work Order

### Step 1: Product Id Canonicalization

Create a small canonical id table and update docs/manifests gradually.

Deliverable:

- `docs/PRODUCT_IDS.md`
- registry validation for canonical ids

### Step 2: les_core Contract API

Next move: extend the current minimal Plug service for:

- identity status
- activations
- channels
- check-ins
- opportunity events

Deliverable:

- passing tests
- `/.well-known/lestupid-app.json`
- no full OAuth yet

### Step 3: Les Go Feature Split

Split large files into feature modules while keeping UI behavior unchanged.

Deliverable:

- `npm run typecheck` passes
- no visual redesign required

### Step 4: Wire Les Go To les_core

Use `VITE_CORE_ADAPTER=http` for:

- identity status
- app activation state
- check-in submission
- opportunity event logging

Current status:

- implemented with mock fallback
- identity and activation HTTP endpoints are live
- app activation writes are live
- check-in submission already targets `Les_poke/api`
- channel activation and opportunity-event usage are not yet wired from the UI

Deliverable:

- mock fallback remains
- HTTP adapter tested

### Step 5: Add Poke Check-In Event

Add a minimal check-in endpoint to `Les_poke/api`.

Deliverable:

- event envelope returned or published
- tests for privacy levels
- no precise private trail by default

### Step 6: Contacts Draft Timeline MVP

Add private draft relationship events from check-ins.

Deliverable:

- no external imports yet
- sensitivity and consent fields included
- tests for private defaults

### Step 7: Commerce Wrapper Contract

Add a LesTupid-facing commerce contract around the existing backend.

Deliverable:

- manifest/discovery endpoints aligned
- facet API
- purchase/listing/item events
- existing Dukkadee code preserved

## What Not To Do Yet

- Do not move everything into an umbrella immediately.
- Do not build full OAuth/OIDC before the lightweight activation API.
- Do not rewrite Commerce from scratch.
- Do not implement every spec-only app at once.
- Do not make Les Go own other products' business logic.
- Do not let Match consume Contacts, Care, Travel, or social data without
  explicit activation and consent.
- Do not put private check-in trails, health data, address books, or raw
  receipts into shared events.

## Final Recommendation

The best next move is small and structural:

Build `les_core` as a lightweight contract API, standardize product ids and
event envelopes, then connect Les Go to that API while keeping the mock
opportunity feed. This gives the ecosystem a real spine without freezing the
products into a heavy platform too early.

The system should grow like this:

```text
Les Go demo shell
  -> lightweight les_core activation/check-in API
  -> Poke check-in events
  -> Contacts private draft timeline
  -> Match persisted opportunities
  -> Commerce wrapper events
  -> Certification review workflow
```

That path preserves the repo's current strengths: independent apps, explicit
consent, clear manifests, and fast demo iteration.
