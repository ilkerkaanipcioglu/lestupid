# Les Poke API

This directory houses the Phoenix Elixir backend for campus questing, maps, events, and location check-ins.

## Role & Responsibility

- Serves check-in creation, quest status updates, and dynamic map rendering parameters.
- Records check-ins and coordinates event logs.

## Running Locally

- **Port**: Configured to run on `http://127.0.0.1:4000` by default in `config/dev.exs`.
- **Database**: Configured to connect to SQLite or Postgres based on local variables.
- **Run Command**: `mix phx.server` (or run within the overall launcher).
