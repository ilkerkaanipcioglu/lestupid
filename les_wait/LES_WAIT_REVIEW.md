# Les Wait Review

Review date: 2026-06-02

## Verdict

Les Wait is a strong first app candidate because it is concrete, useful without
heavy infrastructure, and naturally fits LesTupid certification.

It should stay mobile-web-first and channel-independent.

## What Is Good

- The problem is real and easy to explain.
- The product can start low-tech: paper, phone, SMS, QR, or static web.
- The event model keeps channels separate from core queue logic.
- It has natural integrations with Les Commerce appointments, Les Poke micro
  quests, Les Match queue-safe opportunities, and Les Certification place review.
- The app can run standalone without the rest of the ecosystem.

## Fixed In This Pass

- Added `les_wait/README.md`.
- Replaced the misnamed `manifest .txt` source note with
  `source-note-validebag-hospital.txt`.
- Filled `openspec/project.md` with real Les Wait context.
- Added this review file.

## Current Boundaries

Les Wait owns:

- waiting flows;
- queue state;
- join/status/notify events;
- staff override audit;
- channel normalization;
- place/service waiting evidence.

Les Wait must not own:

- matchmaking decisions;
- commerce checkout;
- city quests;
- final certification decisions;
- global identity records.

Those are optional adapters.

## MVP API Shape

When Les Wait graduates from static prototype to API, start small:

- `GET /api/health`
- `POST /api/waiting-flows`
- `POST /api/waiting-flows/:id/join`
- `GET /api/waiting-flows/:id/status/:ticket_id`
- `POST /api/waiting-events`
- `POST /api/staff/override`
- `GET /agent-manifest.json`

## Certification Criteria

Before Les Wait becomes `certified`, it needs:

- clear queue order;
- visible estimated state without false precision;
- no hidden paid priority unless clearly labeled and policy-approved;
- staff override audit;
- channel-independent event model;
- join flow without wallet or app install;
- optional Web3 proof that never exposes private waiting data;
- transparent point earning and spending rules;
- basic data minimization for health/public-service contexts.

## Next Recommended Step

Keep `waiting.html` as a prototype and add a tiny API only when a real queue
flow needs persistence. Do not start with a heavy scheduling platform.
