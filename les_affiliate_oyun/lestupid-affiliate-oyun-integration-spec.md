# Les Affiliate Oyun Integration Spec

## Goal

Position the affiliate card game without mixing commerce, quests and matching
into one unsafe system.

The game is fun because cards can come from real life and real commerce, but
real money flows must stay honest, labeled and reversible through the correct
commerce surfaces.

## Ownership Boundaries

| Area | Owner |
| --- | --- |
| Card inventory, deck builder, rarity, crafting, season score | Les Affiliate Oyun |
| Product catalog, affiliate link, checkout, refund, commission ledger | Les Commerce |
| Check-in quests, city/campus drops, creator challenges | Les Poke |
| Opponent, team, sponsor, mentor, brand/creator matching | Les Match |
| Paid placement, odds, game economy certification | Les Certification |
| Optional proof receipts and season hashes | Les Block adapter |

## Event Model

```json
{
  "schema_version": "lestupid.affiliate_game_event.v1",
  "event_type": "product_card_earned",
  "product_id": "les-affiliate-oyun",
  "identity_id": "id_123",
  "card_id": "card_456",
  "source_app": "lescommerce",
  "source_ref": "listing_789",
  "reward_policy": {
    "affiliate_disclosure": true,
    "paid_placement": false,
    "cash_value": false
  },
  "proof_policy": {
    "web3_optional": true,
    "public_payload": "hash_only",
    "mint_requires_user_consent": true
  }
}
```

## Les Commerce Adapter

```ts
lesCommerceAffiliateAdapter.getProductCards(context)
lesCommerceAffiliateAdapter.createAffiliateReceipt(order)
lesCommerceAffiliateAdapter.openCheckout(card)
```

Rules:

- Every affiliate card must show merchant, price, commission policy and paid
  placement status.
- Checkout happens in Les Commerce, not in the game engine.
- Refund, cancellation and support belong to Les Commerce.
- The game can award points or cosmetic cards after a purchase, but it must not
  hide that a purchase is optional.

## Les Poke Adapter

```ts
lesPokeGameAdapter.getQuestCards(checkIn)
lesPokeGameAdapter.recordParticipationProof(quest)
```

Rules:

- Quest cards should come from public/safe contexts.
- Minor-safe places cannot create adult, dating or risky paid quests.
- Location trails are not exposed; proof can be local or hash-only.
- Creator drops must label paid access.

## Les Match Adapter

```ts
lesMatchGameAdapter.previewDuelOrTeamOpportunities(playerIntent)
```

Rules:

- People matching is always opt-in.
- Duel invites cannot punish rejection.
- Team, opponent, mentor, sponsor, creator/fan and brand campaign matches must
  explain why they appear.
- Paid campaign matching is labeled as commercial.
- Les Match handles block/report/mute decisions.

## Certification Rules

Certification should review:

- affiliate disclosure;
- paid placement labels;
- odds/rarity disclosure;
- reward split clarity;
- no forced wallet;
- no real-value asset confiscation;
- no manipulative duel rejection penalty;
- no gambling-like mechanics without legal review.

## Safe Rewrite Of Original Risk Mechanics

Original idea: if someone buys an affiliate product from a vulnerable deck, they
win the whole deck and the old owner loses all cards.

LesTupid-compatible rewrite:

- buyer can win a simulated copy, badge or challenge advantage;
- seller keeps paid/earned assets;
- original owner may get a small transparent affiliate reward;
- high-risk tournaments need explicit opt-in and no hidden real-value loss;
- real product purchase is always separate from card ownership loss.

