# lestupid ecosystem rollout plan

> Goal: every Harezm ecosystem product becomes reviewable, certifiable, and agent-readable under the lestupid standard.

## 1. Principle

lestupid is the certification, community, and token layer for Harezm products.

It must work across:

- Harezm-owned products
- lescommerce storefronts and merchants
- agentandbot services and agents
- new lestupid apps, starting with the waiting app, Les Poke, and Les Match
- external places and sellers later

The certificate is not a badge for marketing. It is a visible proof that the product does not rely on fake scarcity, hidden costs, dirty patterns, or stupid pricing.

## 2. First Certified Scope

All Harezm ecosystem products start as `internal_candidate`.

Initial targets:

| Product | Directory | Initial certificate path |
| --- | --- | --- |
| lestupid waiting app | `les_wait/lestupid-waiting-app-spec.md` | first-party app certification |
| Les Poke | `Les_poke` | city-memory quest and loyalty-point certification |
| Les Match | `les_match` | consent-first matchmaking and explainable recommendation certification |
| agentandbot | `agentandbot/governance_core` | agent-friendly service certification |
| lescommerce diydiy | `Les_Commerce/diy-marketplace-elixir` | product, kit, workshop, checkout certification |
| lescommerce africaecommerce | `Les_Commerce/quick-commerce-elixir` | merchant and marketplace certification |
| e-any.online tools | `e-any.online` | public AI tool certification |
| e-any.com | `e-any.com` | global SaaS portal certification |
| eny.com.tr | `eny.com.tr` | SAP and e-transformation service certification |
| harezm._web | `harezm._web` | ecosystem portal certification |
| ipcioglu.com | `ipcioglu/ipcioglu.com` | knowledge and personal brand certification |

## 3. Implementation Layers

### Identity

- One LesTupid identity across the ecosystem.
- Each product uses explicit app activation instead of creating duplicate accounts.
- Activation records hold app permissions, consent version, source app, and status.
- Users can pause or revoke each app without deleting the whole ecosystem identity.
- Les Match activation must be explicit because matchmaking is a sensitive feature.

### Core

- Phoenix context: `Lestupid`
- Database tables: certificates, entities, members, events, ledger entries, reviews, tokens
- Event normalization for web, QR, SMS, WhatsApp, Telegram, USSD, AgentAndBot, lescommerce, and manual/offline channels
- AI review assistant
- Human/community review
- Web3 proof minting later

### AgentAndBot

Expose lestupid as:

- internal tool
- public service
- OpenAPI paths
- skill manifest entries
- agent-readable certificate lookup

Agents may:

- discover candidates
- summarize evidence
- detect manipulation
- invite owners
- record safe events

Agents may not silently issue or revoke final certificates unless an explicit policy allows it.

### lescommerce

Add:

- product `lestupid` payload
- checkout event emission
- merchant certification status
- storefront badge/render surface
- admin evidence checklist

### Web3

Use Web3 as proof and portability, not as the source of truth.

Recommended path:

- Celo first for global/mobile-first use
- thirdweb for early wallet, mint, and backend transaction tooling
- Postgres remains authoritative
- Chain stores certificate hashes, token proofs, and revocation state

## 4. Channel Strategy

Core event format stays the same. Channels only adapt user input.

Supported channels:

- Web and QR
- SMS
- WhatsApp
- Telegram
- USSD
- lescommerce checkout
- AgentAndBot API
- manual/offline field entry

USSD is a priority for Africa-style access, but the system must still work if USSD is unavailable.

## 5. MVP Build Order

1. Create certificate registry and rollout plan.
2. Define waiting app spec and certify it as the first first-party app candidate.
3. Add Les Poke and Les Match to the registry as first-party app candidates.
4. Add shared identity and app activation contract.
5. Add lestupid public service spec for AgentAndBot.
6. Add lescommerce product payload contract.
7. Implement core Phoenix schema and context in one backend.
8. Implement web/QR check-in and certificate lookup.
9. Add AI review assistant.
10. Add SMS/WhatsApp adapters.
11. Add USSD adapter via aggregator.
12. Add M-Pesa/Daraja adapter for Kenya.
13. Add Celo/thirdweb proof minting.

## 6. Done Criteria

- Every Harezm product has a row in `certification-registry.json`.
- A user can register once and activate or revoke each LesTupid app separately.
- Every certificate has evidence and status.
- AgentAndBot can discover and call safe lestupid APIs.
- lescommerce can render certification state.
- The waiting app has a clear product spec, event model, and certification route.
- Les Poke and Les Match have registry rows and agent-readable app manifests before production use.
- No channel is hard-coded as the only way to participate.
