# les_contacts Module

This Elixir module coordinates the private timeline CRM for storing user memories, contacts, and check-in logs.

## Role & Responsibility

- Allows logging check-in memory timelines (Work, Personal, Social, Travel contexts).
- Keeps all sensitive relationship mappings secure and locally isolated on the client side.

## Local Configuration & Running

- Runs as a standalone Elixir module or library integrated into the main governance core launcher.
- Port configurations, when compiled with a web adapter interface, typically resolve to `http://127.0.0.1:4004`.
