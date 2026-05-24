# lestupid certification and token ledger spec

> certification, community, and visible growth without manipulation.

This document defines the technical layer behind the lestupid standard. It is a certification and community platform where people learn, belong, contribute, and grow. It is not a coupon program, status game, or applause machine.

The core idea is simple: a product, service, shop, food item, app, event, learning path, or checkout flow can carry the lestupid standard if it gives honest value without hype tricks. The platform should not manipulate people; it should make their journey visible.

All Harezm ecosystem products should be reviewable. External products and merchants can apply later.

The initial Harezm product registry lives in `certification-registry.json`. The first new first-party product spec is `lestupid-waiting-app-spec.md`.

---

## 1. Positioning

lestupid says one thing:

```text
para zevke gider. markaya değil.
```

A real yogurt with no unnecessary chemicals and a sane price can be lestupid. So can a coffee, a tool, a service appointment, a software product, or a piece of clothing.

The platform rejects:

- fake scarcity
- stupid pricing
- dark patterns
- ingredient fog
- brand tax
- cute status language that feels childish or manipulative

Customer-facing language should stay dry, short, and plain:

- `lestupid certified`
- `La`
- `Le`
- `Lo`
- `Lale`
- `clean product. fair price.`
- `good value. visible journey.`
- `no hype. no trick.`

Keep public wording practical. The tokens should feel like cultural signs, not tiny ceremonies.

---

## 2. Core Concepts

### Certified Product

A product, site, service, food item, app, or venue that carries the lestupid standard.

Certification levels:

- `candidate`: submitted or discovered
- `reviewed`: checked against the standard
- `certified`: accepted as lestupid
- `featured`: certified and actively promoted
- `paused`: temporarily not eligible
- `revoked`: removed from the standard

Minimum fields:

- `certified_product_id`
- `name`
- `owner`
- `product_type`: `food`, `storefront`, `service`, `software`, `content`, `event`, `physical_product`
- `certification_status`
- `certification_level`
- `public_badge_url`
- `review_summary`
- `review_evidence`

Customer-facing label:

```text
lestupid certified
```

Agent-readable label:

```json
{
  "lestupid_certification": {
    "status": "certified",
    "level": "certified",
    "summary": "clean product, fair price, no hype mechanics"
  }
}
```

### Partner

A participating merchant, site, service provider, producer, school, community, or venue.

Partner types:

- `food_producer`
- `coffee_shop`
- `ecommerce`
- `service_provider`
- `appointment_business`
- `event`
- `education`
- `software`
- `travel`

Partner states:

- `pending_review`
- `certified`
- `paused`
- `revoked`

Minimum fields:

- `partner_id`
- `name`
- `type`
- `domain` or physical branch metadata
- `status`
- `certified_product_ids`

### Member

A person or wallet identity participating in lestupid places, learning paths, or communities.

Minimum fields:

- `member_id`
- `wallet_address`, optional
- `email` or phone, optional
- `display_name`
- `status`: `active`, `paused`, `blocked`
- `home_community_id`, optional
- `token_state`

### Token Types

The token universe:

- `La`: belonging token. "I am from this place, this community." First step into a venue, product, course, or group.
- `Le`: flow token. The natural by-product of daily participation, interaction, learning, and presence.
- `Lo`: recognition token. In Turkish street speech, "lo" means "there it is, that is it." It confirms depth, loyalty, and being known.
- `Lale`: La + Le + Lo. Full development, flowering, certification, or completed learning journey.

Implementation note:

- Tokens may start as internal ledger entries.
- NFT minting can come later for eligible La, Le, Lo, or Lale states.
- Never use the token layer to create artificial scarcity or pressure.

### Value Event

A neutral event saying something relevant happened. It does not imply a prize.

Event sources:

- product review
- POS checkout
- e-commerce checkout
- appointment completion
- course or certificate completion
- community contribution
- token mint or recognition
- refund
- manual review adjustment

### Ledger

The append-only source of truth for certification and value events.

Ledger entry types:

- `review`
- `certify`
- `join`
- `participate`
- `recognize`
- `flower`
- `mint_token`
- `pause`
- `revoke`
- `purchase`
- `refund`
- `adjustment`
- `reversal`

Never mutate old ledger entries. Add a reversal or new review.

---

## 3. Review Rules

A product is evaluated on plain criteria:

- clear ingredients or clear scope
- fair price for the value delivered
- no fake scarcity
- no manipulative checkout pattern
- no hidden fee or subscription trap
- no brand-only premium

Example review:

```json
{
  "product_type": "food",
  "name": "plain yogurt",
  "ingredients": ["milk", "starter culture"],
  "price_minor": 6500,
  "currency": "TRY",
  "review_summary": "clean yogurt, sane price, no chemical fog",
  "certification_status": "certified"
}
```

Token derivation examples:

```text
first visit to a member cafe = La
daily interaction or purchase = Le
regular recognized participation = Lo
La + Le + Lo, or completed certificate = Lale
```

---

## 4. Event Contract

Partner systems send neutral value events to lestupid.

Recommended endpoint:

```http
POST /api/lestupid/events
```

Headers:

```http
X-Lestupid-Partner-Id: food-demo-001
X-Lestupid-Signature: hmac_sha256(...)
Idempotency-Key: partner-event-unique-id
Content-Type: application/json
```

Request:

```json
{
  "event_type": "purchase_completed",
  "source": "partner_checkout",
  "partner": {
    "id": "food-demo-001",
    "branch_id": "kadikoy-01"
  },
  "product": {
    "certified_product_id": "prd_yogurt_001"
  },
  "transaction": {
    "id": "pos-20260522-0001",
    "net_amount_minor": 6500,
    "currency": "TRY",
    "occurred_at": "2026-05-22T20:15:00Z"
  },
  "metadata": {
    "channel": "in_store",
    "items_count": 1
  }
}
```

Response:

```json
{
  "data": {
    "event_id": "evt_01j...",
    "partner_id": "food-demo-001",
    "certified_product_id": "prd_yogurt_001",
    "message": "lestupid certified. good value, visible journey."
  }
}
```

Idempotency:

- Same `Idempotency-Key` from the same partner must return the same result.
- Duplicate callbacks must not create duplicate ledger entries.

---

## 5. Example Flows

### Member Cafe

1. Cafe joins as a lestupid-certified place.
2. Customer visits for the first time and joins the community.
3. Ledger records `join` and grants `La`.
4. Customer returns, buys coffee, attends a talk, or contributes.
5. Ledger records `participate` and grants `Le`.
6. Regular presence or meaningful contribution grants `Lo`.
7. La + Le + Lo can flower into `Lale`.

Good UX:

```text
La received. welcome in.
```

```text
Lale complete. you grew here.
```

### Yogurt

1. Producer submits product and ingredients.
2. Reviewer checks ingredients, price, and claims.
3. Product is marked `lestupid certified`.
4. Partner checkout can show `lestupid certified`.

Good UX:

```text
clean yogurt. fair price.
```

### diydiy

1. `diydiy` is reviewed against the standard.
2. Checkout removes hidden-cost and dark-pattern behavior.
3. Product pages show clear price and value.
4. Certified products can display `lestupid certified`.

Good UX:

```text
good purchase. no ceremony.
```

### Coffee Shop

1. Shop applies as a partner.
2. Menu items are reviewed for price, quality, and no fake scarcity.
3. POS sends neutral purchase events for audit and flow.
4. Customer can earn Le through natural participation.

Good UX:

```text
good coffee. no packaging theater.
```

---

## 6. Dukkadee / lescommerce Integration

Add these tables to each participating Phoenix backend:

- `lestupid_certified_products`
- `lestupid_partners`
- `lestupid_members`
- `lestupid_events`
- `lestupid_ledger_entries`
- `lestupid_reviews`
- `lestupid_tokens`

Add context:

- `Dukkadee.Lestupid`

Core functions:

- `submit_product(attrs)`
- `review_product(product_id, attrs)`
- `certify_product(product_id, attrs)`
- `register_member(attrs)`
- `grant_lestupid_token(member_id, token_type, attrs)`
- `derive_lale(member_id, attrs)`
- `record_lestupid_event(attrs, partner_auth)`
- `reverse_event(original_event_id, reason)`

Add API:

- `POST /api/lestupid/events`
- `GET /api/lestupid/products/:id`
- `GET /api/lestupid/products/:id/ledger`
- `GET /api/lestupid/members/:id/tokens`
- `POST /api/lestupid/reviews`

lescommerce integration areas:

- `lescommerce/diydiy`: certify DIY products, kits, services, workshops, and checkout flows.
- `lescommerce/africaecommerce`: allow merchants and marketplace products to become `candidate`, `claimed`, or `certified`.
- Storefront product pages can show `lestupid certified`, `La`, `Le`, `Lo`, or `Lale` when returned by the backend.
- Checkout can emit `purchase_completed`, `service_completed`, `course_completed`, and `community_contribution` events.
- Merchant dashboards can show what evidence is missing before certification.
- Public product JSON should include a compact `lestupid` object so crawlers and agents can understand the certification state.

Example product payload:

```json
{
  "id": "prd_123",
  "name": "plain yogurt",
  "price_minor": 6500,
  "currency": "TRY",
  "lestupid": {
    "status": "certified",
    "certificate_url": "https://lestupid.com/c/prd_123",
    "summary": "clean ingredients, fair price, no hype mechanics",
    "tokens_supported": ["La", "Le", "Lo", "Lale"]
  }
}
```

---

## 7. AgentAndBot Compatibility

lestupid should be agent-friendly by default and fit into `agentandbot/governance_core`.

AgentAndBot should be able to list lestupid as:

- an internal tool
- a public service
- an OpenAPI surface
- a skill manifest entry
- an MCP/A2A-callable certification service later

Agent-facing rules:

- Return structured JSON first; prose summaries are secondary.
- Never expose raw secrets, wallet private keys, thirdweb tokens, MCP tokens, or vault values.
- Include `schema_version` on every public response.
- Include `idempotency_key` support on event writes.
- Include `agent_policy` metadata: allowed actions, required auth, cost, rate limit, and human review requirement.
- Every AI recommendation must be labeled as a recommendation, not final authority.
- Every certificate decision must be auditable by humans and agents.

Suggested AgentAndBot skill names:

- `lookup_lestupid_certificate`
- `submit_lestupid_candidate`
- `record_lestupid_checkin`
- `review_lestupid_evidence`
- `lookup_lestupid_tokens`
- `derive_lestupid_lale`
- `invite_place_to_lestupid`

Suggested public/agent APIs:

```http
GET /api/lestupid/certificates/:id
GET /api/lestupid/entities/:id
POST /api/lestupid/candidates
POST /api/lestupid/checkins
POST /api/lestupid/events
POST /api/lestupid/reviews/ai
GET /api/lestupid/members/:id/tokens
```

Example agent-readable response:

```json
{
  "schema_version": "lestupid.agent.v1",
  "data": {
    "entity_id": "place_istanbul_001",
    "entity_type": "cafe",
    "status": "candidate",
    "claim_status": "unclaimed",
    "community_signal": "active",
    "ai_recommendation": "invite_owner",
    "human_review_required": true,
    "allowed_agent_actions": [
      "record_checkin",
      "summarize_evidence",
      "invite_place_owner"
    ]
  }
}
```

Agents can help discover and prepare certification, but they cannot silently issue or revoke certificates unless an explicit policy allows it.

---

## 8. Agent Contract

Agents should be able to answer:

- Is this product lestupid certified?
- Why was it certified?
- What evidence supports the certification?
- Does this person have La, Le, Lo, or Lale here?
- What natural event caused the token state?
- Did this event already process?
- Has the product been paused or revoked?

Suggested skill names:

- `lookup_lestupid_product`
- `review_lestupid_product`
- `record_lestupid_event`
- `get_lestupid_ledger`
- `lookup_lestupid_tokens`
- `derive_lestupid_lale`

---

## 9. MVP Build Order

1. Keep `certification-registry.json` as the initial machine-readable Harezm certificate list.
2. Certify the `lestupid waiting app` spec as the first first-party app route.
3. Certification schema and context in one backend.
4. `POST /api/lestupid/events` with idempotency.
5. Member and token ledger schema.
6. Product review admin flow.
7. Member cafe demo flow: La, Le, Lo, Lale.
8. Yogurt or coffee demo product.
9. diydiy certification pass.
10. AgentAndBot public service registry entry, OpenAPI paths, and skill manifest.
11. lescommerce product payload integration.
12. Public `lestupid certified` display.
13. Ledger audit view.

Definition of done:

- A product can be certified.
- Every Harezm ecosystem product has an initial registry row.
- A certification has evidence.
- A purchase can create a neutral value event.
- A member can receive La, Le, Lo, and Lale through natural events.
- AgentAndBot can discover the lestupid tool and call safe endpoints.
- lescommerce can display certification status in product and checkout flows.
- A duplicate event is ignored.
- A certification can be paused or revoked.
- Partner credentials are not stored in frontend code.
