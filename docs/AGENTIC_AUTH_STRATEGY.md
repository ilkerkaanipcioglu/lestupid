# LesTupid Agentic Auth Strategy

Source idea: WorkOS `auth.md` agentic registration.

The useful part for LesTupid is not "another login screen". It is a way for an
AI agent to discover a service, ask the user for scoped consent, register itself
for that service, receive limited credentials, and get revoked later without
copy-pasted API keys.

## Product Decision

AgentAndBot is the primary agent identity and authorization surface.

KADRO is the AI worker registry and marketplace under AgentAndBot. KADRO agents
may be visible inside LesTupid apps, but they must always be labeled as AI
workers or AI personas.

LesTupid apps consume AgentAndBot/KADRO through scoped activation and task
delegation. They should not silently inherit broad user identity.

## Roles

| Role | LesTupid Mapping | Responsibility |
| --- | --- | --- |
| Agent | KADRO worker, AgentAndBot runtime, external compatible agent | Requests scoped access and performs a task. |
| Agent provider | AgentAndBot auth server | Mints or brokers identity assertions and revocation events. |
| Service/resource | Les Go, Les Match, Les Commerce, Les Poke, Les Wait, Les Care | Publishes discovery metadata and accepts scoped agent tokens. |
| User | Student, creator, buyer, merchant, venue owner, operator | Grants, denies, limits, and revokes agent delegation. |

## Discovery Surface

Every agent-compatible service should eventually expose:

- `/auth.md`
- `/.well-known/oauth-protected-resource`
- `/.well-known/oauth-authorization-server`

AgentAndBot and KADRO now expose contract-level v1 discovery. Real token minting
is intentionally not faked yet.

Current implementation status:

- AgentAndBot: `contract_only_v1`
- KADRO standalone: `contract_only_v1`, delegated to AgentAndBot auth server
- LesTupid apps: planned consumers and resources

## Scope Model

Use small, product-readable scopes instead of broad API keys.

Core scopes:

- `agents:read`
- `agents:rent`
- `tasks:assign`
- `tools:invoke`
- `credits:spend_limited`
- `kadro:hire`
- `lestupid:activate`
- `proofs:read`

Product scopes should remain explicit:

- `les_go:checkin`
- `les_match:preview`
- `les_match:contact_request`
- `les_commerce:listings_read`
- `les_commerce:purchase_intent`
- `les_poke:quest_submit`
- `les_wait:queue_join`
- `les_certification:selective_disclosure`

## Consent Rules

No agent action should be hidden behind a friendly UI label.

Explicit user approval is required for:

- hiring or assigning a KADRO agent;
- invoking a tool that changes external state;
- spending credits or creating a commerce intent;
- activating another LesTupid app;
- publishing creator/social content;
- sending external messages;
- sharing identity, match, location, trust, proof, or credential data.

Minor-safe/school-safe contexts must be limited to read-only discovery,
education, queue, quest, safety, and group recommendations. Adult, dating, and
sensitive profile scopes are disabled in that mode.

## Agent Strategy

KADRO agents should be packaged as hireable workers with:

- visible AI disclosure;
- agent card;
- skills manifest;
- auth discovery;
- scoped hire/task endpoint;
- audit trail;
- budget and tool limits;
- revocation path.

Inside Les Go, KADRO appears as a contextual worker marketplace:

- study worker after campus check-in;
- commerce creator/promoter for DIY product pages;
- travel safety helper for trip scenarios;
- local logistics helper for Item Otel and courier tasks;
- CV/application helper for student career flows.

Inside Les Match, KADRO must never appear as a human match. It can appear as:

- AI mentor;
- interview coach;
- sponsor prep assistant;
- group/project facilitator;
- safety/date planning helper.

## Implementation Roadmap

1. Keep discovery contract endpoints live and tested.
2. Add `les_core` or AgentAndBot Phoenix auth context for:
   - agent registrations;
   - claim attempts;
   - service-signed identity assertions;
   - scoped access tokens;
   - revocation records;
   - audit events.
3. Add `WWW-Authenticate` protected-resource hints to protected API endpoints.
4. Let Les Go request scoped KADRO task access instead of running mock skills
   directly.
5. Add per-product policy gates for minor-safe, commerce, match, location, and
   proof scopes.
6. Add user-facing delegation dashboard: active agents, scopes, budget, tasks,
   revoke button.

## Repository Rule

Do not store real API keys or long-lived agent credentials in app repos.

Discovery documents and skill manifests are public. Access tokens, identity
assertions, claim tokens, and revocation events are runtime data.
