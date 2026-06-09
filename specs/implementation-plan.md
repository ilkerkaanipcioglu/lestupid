# Implementation Plan: DOX Framework Integration

This plan outlines the integration of the **DOX framework** (Self-documenting `AGENTS.md` hierarchy) into the **LESTUPID** repository. This will ensure that all developer agents working on this project traverse a unified chain of local rules and keep documentation up-to-date.

## Proposed Changes

### 1. Root AGENTS.md Creation
- **`[NEW]` [AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/AGENTS.md)**
  - Establish the root contract using the DOX framework guidelines.
  - Map project-wide design systems (Outfit/Jakarta fonts, border-radius standards, HSL colors, no-rewrite rules).
  - Index the sub-projects pointing to their respective local `AGENTS.md` files.

### 2. Child AGENTS.md Creation for Sub-apps
Create initial local contracts indexing sub-app roles, constraints, and dependencies:
- **`[NEW]` [les_go/AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/AGENTS.md)**: Details the PWA React client, mock adapter modes, and visual assets rules.
- **`[NEW]` [Les_Commerce/AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/Les_Commerce/AGENTS.md)**: Details the marketplace engines, Astro/Next storefront configurations, and sqlite database scopes.
- **`[NEW]` [Les_poke/AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/Les_poke/AGENTS.md)**: Details the Phoenix API on port 4000.
- **`[NEW]` [les_contacts/AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_contacts/AGENTS.md)**: Details the private timeline memory module.
- **`[NEW]` [les_wait/AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_wait/AGENTS.md)**: Details the queue simulator and mock server port 4010.

---

## Verification Plan

### Manual Verification
- Review the `AGENTS.md` hierarchy locally to verify that all relative file links resolve correctly.
- Ensure the project compiles successfully with `npm run build` in `les_go`.
