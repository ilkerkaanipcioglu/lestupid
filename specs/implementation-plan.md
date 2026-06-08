# Implementation Plan: AI Skills & Adapter Registry

This plan details the addition of **AI Skills (Agentic Tool Adapters)** across all 11 modules of the **LesTupid Go** PWA. 
AI Skills define structured interfaces (JSON schemas, parameters, required permissions, and security policies) through which KADRO workers and external agents can interact with the user's local applications.

---

## User Review Required

> [!IMPORTANT]
> - **State Integration (Simulated Execution):** Running an AI skill (either from the local app panel or the global AI Skills Directory) will *directly mutate* the corresponding application's state. For example, triggering the `wait_join_queue` skill will immediately create an active queue ticket in the "Les Wait" UI.
> - **Zero-Knowledge Consent Policy:** Each skill includes a permission boundary status (`active`, `disabled`, `needs_approval`). If a skill is disabled or needs approval, the agent execution simulation will reflect authorization blocks, illustrating how selective disclosure and user consent govern the ecosystem.
> - **Unified Security Console:** The "KADRO AI" view will be updated with a tabbed interface, separating the conversational KADRO chat console from the global **Ecosystem AI Skills Directory**, where users can audit past execution logs and toggle permission states globally.

---

## Proposed Changes

We will group the changes into the frontend files of the `les_go` application.

### [les_go](file:///b:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go)

#### [MODIFY] [types.ts](file:///b:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/types.ts)
- Add new TypeScript definitions for:
  - `AiSkillParameter`: Defines name, parameter type, options, description, and default value.
  - `AiSkill`: Defines skill details, parameter list, required permissions, status, execution count, last executed timestamp, and execution audit logs.

#### [MODIFY] [data.ts](file:///b:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/data.ts)
- Populate `mockAiSkills` array containing 1-2 rich agentic skills for each of the 11 app contexts:
  1. **Hub Feed:** `get_contextual_opportunities` (analyzes check-in history).
  2. **Les Wait (Queue):** `wait_join_queue` (joins queue), `wait_leave_queue` (leaves queue).
  3. **Les Poke (Quests):** `poke_list_quests` (lists nearby quests), `poke_verify_gps` (simulates quest completion).
  4. **Les Match (Consent):** `match_search_tags` (filters profiles), `match_submit_consent` (swipes consent).
  5. **Item Otel (Commerce):** `otel_list_inventory` (fetches custody), `otel_order_maintenance` (orders care), `otel_publish_listing` (lists item for rent/sale).
  6. **Les Contacts (CRM):** `crm_search_timeline` (filters logs), `crm_record_interaction` (adds a log).
  7. **Les Care (Health):** `care_fetch_clinic_slots` (scans clinic slots), `care_generate_emergency_qr` (generates response token).
  8. **Les Harmonica (Secure P2P):** `harmonica_scan_nodes` (scans nearby), `harmonica_pair_handshake` (establishes secure link).
  9. **Les Affiliate Oyun (Card Game):** `oyun_analyze_deck` (gets deck stats), `oyun_trigger_auto_duel` (simulates combat match).
  10. **Les AI / KADRO (AI Workers):** `ai_compile_cv_segment` (compiles check-ins into Living CV segment).
  11. **Les Certification (ZKP):** `cert_generate_zkp_proof` (generates zero-knowledge proof for age/student status).

#### [MODIFY] [main.tsx](file:///b:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/main.tsx)
- **App-level State:** Initialize `aiSkills` and `globalAuditLogs` state variables.
- **App Panels (Inline AI Skill Adapters):** Add a collapsible section titled `🔌 AI Skill Adapters` in the layout of all 11 sub-dashboards.
  - Lists the tools exposed by this app to AI.
  - Displays parameter inputs based on parameter metadata.
  - Provides a "Run Simulation" button.
  - Renders a syntax-highlighted JSON-LD output of the return value, updating local React states (e.g. actually joining queue, completing quest, adding CRM logs, changing ZKP visible fields).
- **KADRO AI View Refactoring:**
  - Introduce sub-tabs: `🤖 KADRO Workers` and `🔌 AI Skills Directory`.
  - In `AI Skills Directory`, show a grid of all available skills grouped by App.
  - Allow users to toggle status (`active` / `disabled` / `needs_approval`) which is reflected in simulated runs.
  - Display execution counts and a live scrollable **Global Audit Trail** of all simulated skill triggers.

#### [MODIFY] [styles.css](file:///b:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css)
- Add styling for the AI Skill Adapters UI:
  - Collapsible header with interactive hover effects.
  - Glassmorphic parameter forms (custom inputs, selects, toggles).
  - Terminal-like JSON block displays with neon tech highlight lines.
  - Audit log table styles with timestamp markers and success/failure indicator pills.

---

## Verification Plan

### Automated Tests
- Run TypeScript checking inside the project directory to verify syntax compliance:
  ```powershell
  npm run typecheck
  ```
- Build the Vite application to ensure zero compilation or asset errors:
  ```powershell
  npm run build
  ```

### Manual Verification
- Open the PWA at `http://127.0.0.1:5175/` and test:
  1. **Inline Skill Execution:** Go to "Les Wait", expand the AI Skill Adapters section, run the `wait_join_queue` skill, and verify that the UI updates immediately with an active ticket.
  2. **Security Controls:** Go to "KADRO AI" -> "AI Skills Directory", change a skill status to `disabled`, and then attempt to execute it in the app's adapter panel. Verify that the simulation blocks execution and records a failed authorization audit entry.
  3. **Global Audit Feed:** Verify that executing skills adds timestamped entries in the security panel.
