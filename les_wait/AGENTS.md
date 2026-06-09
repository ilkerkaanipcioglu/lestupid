# les_wait Module

This module contains the queue simulator, ticket generation, and waiting duration estimation workflows.

## Role & Responsibility

- Simulates active queue progression.
- Users can join mock queues (canteen, clinic, student affairs) and track their progress live.

## Local Configuration & Running

- **Mock API Server**: Serves files in the `les_wait/` directory.
- **Port**: Listens on `http://127.0.0.1:4010/waiting.html`.
- **Run Command**: `node dev-server.mjs`