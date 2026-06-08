# LesTupid Roadmap

## Current Decision

Prioritize the LesTupid Go demo loop before building a heavy central auth
service. The ecosystem should stay React/TypeScript for PWA surfaces,
Elixir/Phoenix for APIs and realtime services, and JSON/Markdown for manifests
and specs.

From now on, complete MVPs one by one. Each MVP should be simple, working,
portable and boringly reliable before the next layer is added.

MVP rule:

- one clear user loop;
- one small data contract;
- mock/local first if backend is not needed yet;
- typed adapter boundary before cross-app integration;
- no hidden dependency on another LesTupid app;
- build/test must pass before moving to the next product.

## Phase 0: Repo Hardening

- Add Les Go runtime config and keep `.env` values out of source control.
- Keep registry validation and Les Go typecheck/build in CI.
- Prepare, but do not execute, the snake_case directory rename.
- Maintain manifest validation as the ecosystem contract.

## Phase 1: Les Go Demo Loop

- Keep the mock opportunity adapter as the deterministic demo source.
- Keep an explicit HTTP adapter boundary for future Phoenix APIs.
- Focus the first live-feeling loop on:
  `place check-in -> local listings -> opportunities -> activation prompt`.
- Demo places should include campus, workplace, cafe, canteen, club, concert,
  library and adult-safety mode.
- Add feed-first commerce filtering: visible values on commerce/listing cards
  become tap-to-filter facets for brand, model, size, place, listing type,
  service type, item type, care type and rental period.

## MVP Completion Order

1. Les Go: contextual shell, check-in feed, app activation prompts, tap-to-filter
   commerce facets, visual flow gallery.
2. Les Commerce: marketplace/listing/DIY/Item Otel shared facet contract and one
   simple API/search path.
3. Les Wait: Phoenix service-flow core for queue, booking, service status and
   entry surfaces.
4. Les Match: opt-in matching backend with safety/reporting and no hidden people
   exposure.
5. Les Poke: quest/drop feed with safe public-space rules.
6. Les Contacts: private contact/place/product graph MVP.
7. Les Harmonica: secure anonymous contact handoff MVP.
8. Les AI/KADRO: agent roster/search adapter and labeled task launch.

## Phase 2: Lightweight Identity And Activation

- Build a small v1 core API before full OAuth/OIDC.
- Minimum records: demo user identity, app activation, channel activation,
  place check-in and feed state.
- Tamper-resistant session tokens are enough for v1; full OIDC can wait.

## Phase 3: Les Match Backend

- Move candidates/opportunities/matches from in-memory data to Ecto schemas.
- Keep people discovery explicit opt-in.
- Keep local listings and paid memberships labeled separately from organic
  matching.

## Phase 4: Les Poke Creator Drops

- Add API-backed quest/drop feed.
- Keep public quests free.
- Label paid creator drops and fan club content before unlock.
- Adult creator content requires 18+, legal review and explicit labels.

## Phase 5: Les AI / KADRO

- Do not import the large KADRO roster directly into Les Go.
- Provide a search/roster adapter.
- Label every KADRO agent as AI worker/persona/operator-owned.

## Phase 6: LesTupid_Lan Nano Parser

- Start with `@screen`, `@card`, `@list`, `@action`, `@field`, `@text`.
- Implement parser and React renderer in TypeScript.
- Keep it parallel to core work; it is not a blocker for the Go loop.
