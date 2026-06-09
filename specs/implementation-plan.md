# Implementation Plan: Local Dev Environment Execution

This plan outlines the steps to make the local version of the ecosystem components fully operational and running on this machine.

## Proposed Changes

### 1. Environment Configuration Setup
- **`[NEW]` [les_go/.env](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/.env)**
  - Copy `les_go/.env.example` content to `les_go/.env` to configure Vite with mock adapters by default:
    ```env
    VITE_LESTUPID_API_BASE_URL=http://127.0.0.1:4000
    VITE_LES_CONTACTS_API_BASE_URL=http://127.0.0.1:4004
    VITE_LES_MATCH_API_BASE_URL=http://127.0.0.1:4002
    VITE_LES_POKE_API_BASE_URL=http://127.0.0.1:4003
    VITE_CORE_ADAPTER=mock
    VITE_OPPORTUNITY_ADAPTER=mock
    ```

### 2. Launch Local Dev Servers
We will run the main application components locally as background processes:
- **Les Go PWA Client**: Launch the Vite development server using `npm run dev` in `les_go/`.
- **Les Wait Mock API Server**: Launch the mock node server via `node dev-server.mjs` in `les_wait/`.

---

## Verification Plan

### Automated Checks
- Verify that `les_go` dev server starts without errors.
- Verify that the local ports (5174 for Vite PWA, 4010 for Les Wait) are listening.

### Manual Verification
- Access the PWA locally via browser.
