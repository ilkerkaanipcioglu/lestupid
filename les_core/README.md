# Les Core

Les Core is the lightweight identity, activation and event-envelope contract for
the LesTupid ecosystem.

It deliberately starts as a small tested Elixir package plus a thin Plug HTTP
surface rather than a heavy OAuth/OIDC platform. Product apps can use this
contract shape before a larger Phoenix identity provider exists.

## Current Scope

- identity status contract
- app activation contract
- channel activation contract
- standard event envelope
- private payload guard
- manifest metadata
- minimal HTTP contract endpoints

## HTTP Endpoints

- `GET /api/health`
- `GET /api/identity/status`
- `GET /api/activations`
- `GET /.well-known/lestupid-app.json`
- `GET /agent-manifest.json`

## Run

```powershell
mix deps.get
mix test
mix run --no-halt
```

The server starts on `http://127.0.0.1:4000` by default. Set `PORT` to change
it. Set `LES_CORE_START_SERVER=false` when you want the application modules
without starting the HTTP listener.

## Deferred

- full OAuth/OIDC
- refresh tokens
- billing
- notifications
- product business logic
- cross-app data storage

## Test

```powershell
mix test
```
