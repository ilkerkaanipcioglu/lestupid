# Pseudonymous Trust Credentials Spec

## Goal

LesTupid users should be able to show reliability without exposing their real
identity, full purchase history, private location trail, or app-by-app profile.

The certification layer turns repeated, consented activity into trust
credentials. Les Block can later anchor hashes or portable proofs, but the
source of truth stays in LesTupid/app ledgers until a separate proof service is
needed.

## Trust Sources

Trust can grow from normal ecosystem activity:

- queue behavior: joins, no-shows, fair cancellations, staff confirmations;
- commerce behavior: completed purchases, refunds, delivery, disputes;
- marketplace behavior: verified listings, item condition, peer reviews;
- Item Otel behavior: custody proof, delivery proof, care logs, recall history;
- place behavior: check-ins, venue certification evidence, reports;
- learning and work behavior: quests, certificates, micro-gigs, applications;
- community behavior: contributions, moderation, reports, helpful content.
- safe communication behavior: trusted contact acceptance, certified staff
  contact, guardian-approved contact, safe handoff, block/report resolution.

Sensitive content is not a trust source by default. Health, dating, minors,
adult venues, private notes and exact location trails need stricter rules and
must not be exposed through broad trust badges.

## Credential Shape

```json
{
  "schema_version": "lestupid.trust_credential.v1",
  "credential_id": "trust_abc",
  "holder_ref": "pseudonymous_pairwise_ref",
  "issuer": "les-certification",
  "trust_domain": "commerce_delivery",
  "level": "reliable",
  "evidence_summary": {
    "event_count": 18,
    "first_seen_at": "2026-01-12T10:00:00Z",
    "last_seen_at": "2026-06-01T12:00:00Z",
    "dispute_status": "none_open"
  },
  "disclosure_policy": {
    "real_identity_hidden": true,
    "pairwise_pseudonym": true,
    "public_payload": "summary_only",
    "expires_at": "2026-09-01T00:00:00Z",
    "revocable": true
  },
  "proof_policy": {
    "web3_optional": true,
    "chain_payload": "hash_only",
    "mint_requires_user_consent": true
  }
}
```

## Disclosure Modes

| Mode | What the other side sees |
| --- | --- |
| `private` | Nothing is shown. |
| `summary_badge` | A compact trust badge, level and domain only. |
| `verified_claim` | A signed claim with domain, level, issuer and expiry. |
| `selective_evidence` | A small evidence summary without raw events. |
| `reveal_to_certified_party` | More detail only to a certified venue/app and only with consent. |

## Pairwise Pseudonym Rule

The same person should not be linkable across all places and apps by default.

For each certified app, venue, merchant, or counterparty, Les Certification can
derive a pairwise pseudonymous reference. This lets the user prove "I am trusted
enough for this interaction" without showing "this is my universal identity".

## Web3 Rule

Blockchain is for proof, portability, expiry and revocation checks.

It must not store:

- real names, phone numbers, email addresses or raw identity data;
- exact location history;
- raw purchase baskets;
- health, dating, adult, minor-safe or private-note data;
- raw dispute text or reports.

It may store or anchor:

- credential hash;
- issuer id;
- trust domain;
- expiry/revocation pointer;
- optional public badge metadata when the user explicitly consents.

## Product Uses

- Les Go: show "identity-hidden trust" cards after check-in or shopping.
- Les Commerce: let buyers/sellers show delivery, refund or listing trust.
- Les Item Otel: prove custody, care, courier and recall reliability.
- Les Wait: prove fair queue behavior without exposing every queue.
- Les Match: never expose dating history; at most show safety/trust eligibility
  after explicit opt-in and with strong domain separation.
- Les Care: no broad health trust badge; only certified contributor credentials
  and source-quality signals.
- Les Harmonica: show safe-contact credentials such as trusted contact,
  guardian-approved contact, certified venue staff, emergency helper, peer
  courier contact or reliable commerce handoff without revealing the user's
  universal identity.

## Non-Goals

- No social credit score.
- No global public ranking.
- No pay-to-win credential.
- No silent blockchain minting.
- No irreversible exposure of private behavior.
- No automatic trust use in matchmaking.
