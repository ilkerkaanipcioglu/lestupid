# LESTUPID Implementation Tracker

Last updated: 2026-06-09

This file is the working tracker for:

- the original implementation instruction set,
- the current technical sequence we are executing,
- notes coming from the separate visual design agent,
- the next concrete step to continue without losing context.

## Working Rules

For each component:

1. Scan the repo first.
2. Compare current code with the target approach.
3. If current code is equal or better, leave it alone.
4. If the proposed approach is better, implement incrementally.
5. Before each code edit, write one rationale line in this format:
   `# DEĞIŞIKLIK: [what changes] — [why it is better]`
6. Do not rewrite from scratch; preserve working code and build on top.

## Global Architecture Checklist

- [x] Canonical product IDs tracked in one source of truth
- [x] Registry validator checks canonical IDs
- [x] `les_core` lightweight contract package exists
- [x] `les_core` HTTP read endpoints exist
- [x] `les_core` app/channel activation write endpoints exist
- [x] `les_go` reads identity/activation state through adapter with mock fallback
- [x] `les_go` writes app activations through `les_core`
- [x] `Les_poke/api` check-in endpoint exists
- [x] Standard shared event envelope exists in `les_core`
- [x] `les_core` opportunity event write endpoint exists
- [x] Manifest consistency tests started
- [x] `les_contacts` receives draft timeline input from ecosystem event flow
- [x] `les_go` large files split into feature modules without behavior change
- [x] `les_certification` CI validation wiring
- [x] commerce wrapper contract around existing backend

## Phase Tracker

### Phase 1 - Contract Infrastructure

#### Canonical IDs
- [x] `docs/PRODUCT_IDS.md`
- [x] canonical product id validation in registry tooling

#### les-core
- [x] identity status contract
- [x] activations read contract
- [x] app activation write contract
- [x] channel activation write contract
- [x] manifest / well-known response
- [x] `POST /api/check-ins`
- [x] `POST /api/opportunity-events`

#### les-certification
- [x] registry validator works
- [x] CI execution for validator
- [ ] optional event/schema validation

### Phase 2 - Demo Shell + First Live Links

#### les-go
- [x] fallback-safe core adapter
- [x] live app activation write on activate actions
- [x] privacy-safe contacts draft preview hook
- [~] feature split of `main.tsx`, `data.ts`, `adapters.ts`
- [x] wire channel activation usage where needed
- [x] first major visual system refresh for shell/card surfaces
- [x] extracted Affiliate Oyun and Certification views into feature modules
- [x] extracted Wait view and removed hidden legacy wait markup from `main.tsx`
- [x] extracted Poke view and moved its inline card styling into CSS classes
- [x] extracted Match view and moved chat/swipe/popup inline styling into CSS classes
- [x] extracted hub/visual helper primitives out of `main.tsx`
- [x] extracted hub main shell into a dedicated feature component

#### les-poke
- [x] `POST /api/check-ins`
- [x] privacy-aware event publication
- [x] draft timeline handoff to `les-contacts`

#### les-contacts
- [x] first Elixir runtime slice exists
- [x] private draft timeline event from check-in context
- [x] ecosystem adapter boundary for incoming draft events
- [x] first integration from `les-poke`
- [x] minimal HTTP read/preview slice

#### les-affiliate
- [ ] not started in this run

#### les-wait
- [ ] not started in this run

### Phase 3 - Social + Matching

- [ ] `les-match` persisted opportunities and decisions
- [ ] `les-match` `les-core` activation adapter
- [ ] `les-harmonica` channel-activation gated flows
- [ ] `les-travel` runtime slice

### Phase 4 - Commerce

- [x] wrapper contract for current backend
- [ ] canonical commerce manifest alignment
- [ ] purchase/item events

### Phase 5 - AI + Tools

- [ ] not started in this run

## Current Technical Sequence

Completed:

1. Canonical ID standardization
2. `les_core` contract package
3. `les_core` HTTP API slice
4. `les_go` core adapter integration
5. `les_go` activation write integration
6. `les_contacts` private draft timeline MVP

Current:

1. Continue the visual cleanup pass only where old inline styling still leaks through
2. Reassess whether one more small `les_go` extraction is worth it before switching to live integration work

Next after current:

1. Decide whether `les_go` should consume live commerce discovery or keep mock-first data for now
2. Finish sidebar/skill-adapter inline styling cleanup so `main.tsx` loses more ad hoc UI code
3. Evaluate whether the legacy commerce warnings deserve a focused cleanup pass

## Visual Design Agent Notes

Use this section to evaluate notes coming from the other agent working on the
system visually.

Status:

- [x] Large shell refresh direction applied locally in `les_go`
- [ ] Awaiting any extra note from the separate visual design agent

Guidance for evaluation:

- accept notes that improve UX clarity without breaking current architecture
- prefer notes that fit existing component boundaries
- avoid visual rewrites that force backend or domain churn
- fold good design notes into implementation only when the relevant component
  is active in the current step

## Active Risks

- `les_go/src/main.tsx` is still too large, although one major slice is now extracted
- `les_contacts` is new runtime code and not yet connected to a live producer
- `les_core` runtime checks on Windows require workspace-local temp handling
- some directories are historical and should keep canonical IDs only in
  manifests/events/APIs, not necessarily in folder names

## Notes For Next Turn

- keep using this file as the single execution tracker
- after each completed step, update the "Current" and "Next" sections
- if the visual design agent leaves notes, summarize them under
  "Visual Design Agent Notes" before acting on them
- latest completed slice: `Les_Commerce/commerce-backend` now exposes `/.well-known/lestupid-app.json`, `/api/health`, and `/api/ecosystem/endpoints` as a LesTupid-friendly discovery layer backed by tests; before that `les_core` exposed both `POST /api/opportunity-events` and `POST /api/check-ins` with validation and tests, `les_go` wrote channel activations for Match/Harmonica flows, and the repo already had `les_certification` validator CI wiring in place
- latest completed slice after that: `les_go/src/styles.css` received the first major visual refresh, replacing the beige/demo-heavy look with a calmer dark-shell + neutral-surface system, removing key `vw`/negative-tracking headline treatments in the main shell, and verifying the change with `npm run typecheck`, `npm run build`, and a local dev server on `http://127.0.0.1:5174`
- newest completed slice: `les_go` moved the Affiliate Oyun and Certification screens into dedicated feature modules, removed another pocket of inline UI styling by introducing reusable CSS classes for those surfaces, and re-verified with `npm run typecheck` and `npm run build`
- newest completed slice after that: `les_go` moved the visible Wait screen into `src/features/wait/WaitView.tsx`, dropped the hidden legacy wait markup from `main.tsx`, and re-verified with `npm run typecheck`
- newest completed slice after that: `les_go` moved the Poke quest/map screen into `src/features/poke/PokeView.tsx`, replaced another batch of inline UI styling with named CSS classes, and re-verified with `npm run typecheck` and `npm run build`
- newest completed slice after that: `les_go` moved the Match swipe/chat/popup screen into `src/features/match/MatchView.tsx`, replaced another inline-style-heavy block with named CSS classes, and re-verified with `npm run typecheck` and `npm run build`
- newest completed slice after that: `les_go` moved `VisualFlowGallery` plus core hub presentational primitives (`CvSnapshot`, `FilterRow`, `PlaceDoor`, `FlowIntro`, `StatusGroup`, `CommerceFacetBar`, `Opportunity`) into dedicated feature files, reducing `main.tsx` helper weight while keeping the same behavior, then re-verified with `npm run typecheck` and `npm run build`
- newest completed slice after that: `les_go` moved the `hub` main shell into `src/features/hub/HubView.tsx`, so `main.tsx` now mainly coordinates state and routing instead of carrying the biggest UI surface directly; the repo was re-verified with `npm run typecheck` and `npm run build`
