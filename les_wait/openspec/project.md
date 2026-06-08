# Project Context

## Purpose
Les Wait turns waiting, queues, appointments, service intake, and check-ins into
fair, visible, breathable flows.

## Tech Stack
- Current: static HTML prototype, Markdown specs, LesTupid app manifest.
- Future: API-first service, likely Phoenix JSON API when persistence is needed.
- Frontend target: responsive mobile web/PWA first; native or desktop shell only
  when it saves real delivery time.

## Project Conventions

### Code Style
Keep copy plain and practical. Prefer short API contracts, explicit event names,
and small adapters over a large platform.

### Architecture Patterns
- `standalone_app`: Les Wait can run alone as a queue/appointment app.
- `ecosystem_activated_app`: a user can activate Les Wait from LesTupid identity.
- Cross-app links to Les Match, Les Poke, Les Commerce, and Les Certification
  are optional adapters.
- All queue channels should normalize into the same event model.

### Testing Strategy
Validate manifests and specs first. When an API exists, add endpoint tests for
health, flow creation, queue join, status lookup, notification state, and event
recording.

### Git Workflow
Keep app changes small and separable. Do not mix Les Wait product changes with
unrelated LesTupid app refactors.

## Domain Context
The first source case is a hospital corridor where people wait in a cramped
space because they cannot safely leave while listening for their name. The app
must solve that with whatever exists: paper, phone, QR, SMS, staff tablet, web,
or offline/manual entry.

## Important Constraints
- No fake scarcity or pressure mechanics.
- People must be able to join without a wallet.
- AI may summarize or explain but not silently issue certification decisions.
- Human/staff override must be auditable.
- Sensitive flows such as health queues need minimal data and clear consent.

## External Dependencies
Optional only:

- SMS/WhatsApp/Telegram providers.
- USSD aggregator.
- LesTupid identity and activation service.
- Les Match opportunity adapter.
- Les Commerce appointments or pickup queues.
- Les Certification review adapter.
