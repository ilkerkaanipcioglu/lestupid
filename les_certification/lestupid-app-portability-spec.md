# lestupid app portability spec

## Goal

Every LesTupid app must work in two modes:

- `standalone_app`: the product runs as its own app, with its own deployment,
  database, admin surface, and local user/profile records.
- `ecosystem_activated_app`: the product is opened from a shared LesTupid
  identity, and the user only activates the app and the channels they want.

The ecosystem should make activation easier, not make extraction hard.

The architecture should stay simple, fast, and flexible. Shared code should
remove repetition, not create a heavy platform that every app must obey.

## Core Rule

No app may require another LesTupid app to boot, deploy, or keep serving its
core product promise.

Cross-app features must be optional adapters. If the adapter is removed or
disabled, the product keeps working with reduced ecosystem features.

Prefer the smallest useful integration:

1. HTTP/JSON API contract.
2. App manifest discovery.
3. Tiny shared client helpers.
4. Shared UI components only when they are reused by at least two apps.
5. Platform shells only when they save real delivery time.

## Required Boundaries

Each app must own:

- its runtime service;
- its datastore or datastore schema;
- its app-specific profile and consent records;
- its public health endpoint;
- its app manifest;
- its local admin/review surface when needed;
- its deployment config and secrets.

The shared LesTupid layer may own:

- ecosystem identity;
- app activation records;
- channel activation records;
- certification registry;
- cross-app discovery;
- portability/export records;
- optional shared loyalty state.

## Adapter Pattern

Apps should integrate through explicit adapters instead of direct imports from
another app.

Recommended adapter names:

- `identity_adapter`
- `activation_adapter`
- `channel_adapter`
- `match_opportunity_adapter`
- `certification_adapter`
- `loyalty_adapter`
- `les_block_adapter`

Each adapter should have a local fallback. For example, if the LesTupid
identity service is absent, the app can use local registration while still
keeping `external_identity_id` nullable for future linking.

Adapters should be thin. They should not import another app's business logic or
force a shared monorepo build to run.

## Frontend Platform Rule

Use a progressive platform path:

| Target | Preferred first choice |
| --- | --- |
| Mobile web | Responsive web/PWA |
| Mobile app | Expo React Native when native install is needed |
| Desktop app | Web/PWA first, Tauri shell when local desktop features are needed |
| Admin/ops | Web dashboard or Phoenix LiveView |

The same product API should serve all clients. A separate native or desktop
shell should be a packaging choice, not a new product brain.

Avoid starting with a heavy super-app. Start with:

- one app shell for activation and discovery;
- per-product web/mobile screens;
- shared auth/activation/channel helpers;
- manifest-driven links between apps.

## Optional Web3 Adapter

Apps may use `les_block_adapter` for certificate proof, point proof, spending
receipts, redemption receipts, and revocation proofs.

This adapter must stay optional. Wallets, tokens, and chain proofs cannot be
required for the app's core flow.

## Manifest Requirements

Each machine-readable app manifest should declare:

- supported runtime modes;
- standalone readiness;
- whether ecosystem activation is optional or required;
- required adapters;
- optional adapters;
- extraction difficulty;
- data ownership;
- export requirements.

Example:

```json
{
  "runtime_modes": ["standalone_app", "ecosystem_activated_app"],
  "portability": {
    "standalone_ready": true,
    "ecosystem_activation_optional": true,
    "extraction_difficulty": "low",
    "data_owner": "app",
    "required_adapters": [],
    "optional_adapters": ["identity_adapter", "activation_adapter"],
    "export_required": true
  }
}
```

## Activation UX

A user can enter the ecosystem from any app.

If the user starts in Les Poke, Les Match, Les Wait, or Les Commerce:

1. create or link one LesTupid identity;
2. activate the current app;
3. show other apps as inactive but available;
4. let the user activate each app explicitly;
5. keep sensitive apps, especially Les Match, off until explicit consent.

## Separation Checklist

Before an app is certified, it must prove:

- it can run with ecosystem adapters disabled;
- it can be activated from another LesTupid app;
- its core database can be exported without unrelated apps;
- deleting or pausing another app does not break its core flows;
- cross-app events are documented as optional inputs;
- app-specific consent can be revoked without deleting the ecosystem identity.
