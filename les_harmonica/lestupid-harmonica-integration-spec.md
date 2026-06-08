# Les Harmonica Integration Spec

## Goal

Make safe communication work across LesTupid without turning every product into
one giant app.

Les Harmonica owns:

- contact invitations;
- encrypted messaging;
- trusted proximity;
- pairwise pseudonymous contact references;
- contact-level block/report state;
- local contact proofs and revocation state.

Other apps may only launch, preview, certify, or gate contact.

## Contact Types

| Type | Meaning |
| --- | --- |
| `trusted_contact` | Two parties explicitly accepted each other. |
| `guardian_safe_contact` | Parent/guardian or school-approved contact. |
| `venue_staff_contact` | Certified staff contact for a place. |
| `peer_service_contact` | Contact for delivery, Item Otel, service gig or marketplace handoff. |
| `emergency_helper_contact` | Emergency-only safe helper signal. |
| `match_handoff_contact` | Contact opened only after Les Match opt-in. |

## Minimum Event Model

```json
{
  "schema_version": "lestupid.harmonica_event.v1",
  "event_type": "contact_invite_accepted",
  "product_id": "les-harmonica",
  "holder_ref": "pairwise_ref_a",
  "counterparty_ref": "pairwise_ref_b",
  "contact_type": "trusted_contact",
  "trust_domain": "safe_contact",
  "visibility": "pairwise_only",
  "proof_policy": {
    "web3_optional": true,
    "public_payload": "hash_only",
    "mint_requires_user_consent": true,
    "revocable": true
  }
}
```

## Go Adapter

Go can request opportunity cards from Harmonica:

```ts
lesHarmonicaAdapter.getSafeContactOpportunities(checkIn, channels)
```

The card must show:

- source app: `les_harmonica`;
- why it appears;
- required activation;
- consent/safety labels;
- whether identity stays hidden;
- whether Les Match is required.

## Certification Adapter

Les Certification can issue scoped credentials:

- certified venue staff;
- trusted peer courier;
- school group contact;
- guardian-approved safe contact;
- reliable commerce handoff.

These credentials are domain-scoped and revocable.

## Match Boundary

Les Harmonica is not a dating discovery engine.

It may carry messages after Les Match creates a consented handoff. It must not
surface people from place check-ins unless Les Match is active and both sides
have compatible consent.

## Minor-Safe Boundary

For minors:

- no free-form stranger discovery;
- guardian/school-approved contacts only;
- no dating handoff;
- reports and revocation must be easy;
- emergency mode must be certified and tightly scoped.

## Standalone Boundary

Standalone Les Harmonica must still support:

- local contact invite;
- local pairwise key;
- encrypted message;
- trusted proximity alert;
- block/report;
- export/delete.

Ecosystem adapters enrich this, but they are not required.

