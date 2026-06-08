# Lightweight Core Activation API

This is the v1 bridge before a full OAuth/OIDC identity provider exists.

## Goal

Support the Les Go demo loop with one ecosystem identity, many app activations,
channel activations, check-ins and opportunity state.

## Minimum Resources

- `identity`: demo user id, display label, status.
- `app_activation`: product id, status, permissions.
- `interaction_channel`: channel id, status, allowed apps.
- `place_check_in`: place id, place type, privacy level, source.
- `opportunity_event`: opportunity id, source app, action, report/dismiss state.

## Minimum Endpoints

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/api/identity/status` | Return current demo/session identity. |
| `GET` | `/api/activations` | Return app and channel activation state. |
| `POST` | `/api/activations/apps/:product_id` | Activate/pause an app for the identity. |
| `POST` | `/api/activations/channels/:channel_id` | Activate/pause an interaction channel. |
| `POST` | `/api/check-ins` | Record a privacy-scoped check-in. |
| `POST` | `/api/opportunity-events` | Record open, activate, dismiss or report. |

## Defaults

- Full OAuth/OIDC is deferred.
- Tokens are signed session tokens in v1.
- Private location trails are not stored.
- Every app can still run standalone if this API is absent.
