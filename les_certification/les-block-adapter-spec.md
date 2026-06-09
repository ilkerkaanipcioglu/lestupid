# Les Block Adapter Spec

## Goal

Les Block is the optional Web3 proof and value adapter for LesTupid apps.

It is not a standalone app yet. It is not required for signup, queue joins,
matching, commerce, certification, or basic loyalty.

The source of truth stays in the app database or LesTupid core ledger. Blockchain
records are proofs, portable receipts, and optional value events.

## What It Can Prove

- certification proof;
- review evidence hash;
- La/Le/Lo/Lale state proof;
- point balance snapshot proof;
- spend, redeem, refund, or transfer receipt;
- revocation proof;
- venue or merchant certification proof;
- pseudonymous trust credential proof;
- pairwise trust badge proof;
- app activation or channel activation proof when the user requests it.

## What It Must Not Do

- force wallet login;
- replace app databases;
- silently mint assets;
- expose private queue, health, match, or commerce data;
- expose a universal cross-app behavioral profile;
- make certification automatic;
- make participation pay-to-win.

## Adapter Contract

Recommended adapter name: `les_block_adapter`.

Each app may emit local ledger events first:

```json
{
  "schema_version": "lestupid.value_event.v1",
  "event_type": "point_earned",
  "product_id": "les-wait",
  "identity_id": "id_123",
  "subject_type": "queue",
  "subject_id": "queue_456",
  "value": {
    "unit": "Le",
    "amount": 1
  },
  "proof_policy": {
    "web3_optional": true,
    "mint_requires_user_consent": true,
    "public_payload": "hash_only"
  }
}
```

The adapter may later anchor a hash or mint a proof, but the local event remains
authoritative.

## Pseudonymous Trust Proofs

Les Block may anchor a credential hash for a trust claim issued by
Les Certification, but it must not publish the raw activity behind the claim.

Recommended public payload:

```json
{
  "schema_version": "lestupid.trust_proof.v1",
  "credential_hash": "0x...",
  "issuer": "les-certification",
  "trust_domain": "commerce_delivery",
  "holder_ref": "pairwise_pseudonymous_ref",
  "expires_at": "2026-09-01T00:00:00Z",
  "revocation_ref": "revocation_registry_pointer"
}
```

The same user should receive different pairwise holder references for different
apps, venues, merchants, or counterparties unless they explicitly reveal more.

## Initial Chain Policy

- `postgres_source_of_truth`: true
- `wallet_required`: false
- `hash_private_payloads`: true
- `mint_requires_user_consent`: true
- `revocation_required`: true
- `supported_first_targets`: Celo and thirdweb tooling

## When It Becomes An App

Create a separate `les_block` service only when at least two are true:

- third-party apps need a public proof API;
- certificate proof minting becomes routine;
- points become spendable across multiple merchants;
- settlement, refund, or transfer logic needs its own audit surface;
- wallet management becomes a product area.
