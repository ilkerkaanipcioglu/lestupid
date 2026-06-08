# spec: LesTupid All-App Demos Integration

This specification details the frontend modifications to the **LesTupid Go** PWA folder to create a fully interactive visual demonstration of all sub-programs in the ecosystem (e.g. Les Wait, Les Poke, Les Match, Les Contacts, Les Care, Les Harmonica, Les Affiliate Oyun, Les AI, Les Certification, and Les Item Otel).

## Architecture & Layout Changes

1. **Navigation Hub:** Refactor `les_go/src/main.tsx` to host a side navigation menu (or bottom navigation bar for mobile sizes) that lists all 11 views.
2. **Interactive States:** Keep local React state hooks to drive visual behaviors (e.g. countdowns, radar scans, card deck configurations, form submissions) so the demos run stand-alone immediately.
3. **Curated Styling:** Add distinct HSL color variables and micro-animations to `les_go/src/styles.css` for each app's unique dashboard.

## Simulation Spec for Each App

- **Hub Feed:** Maintains the current place check-in contextual opportunity card layout.
- **Les Wait:** Real-time queue ticking simulation. Users join a queue, see estimates, and can press a button to tick down queue progression.
- **Les Poke:** Interactive canvas/SVG map with active quests based on campus. Click quest nodes to trigger a simulated GPS completion.
- **Les Match:** Opt-in Tinder-style consent cards. Swiping or clicking "Interest" simulates a mutual match, opening a consented chat panel.
- **Les Commerce / Item Otel:** Existing custody logs, item addition, care requests, and listing managers.
- **Les Contacts:** Private CRM timeline. Users can log check-in memories to specific contexts (Work, Personal, Social, Travel) and review them in a secure log view.
- **Les Care:** Clinic availability tracker, first-aid search drawer, and secure emergency QR code generation for certified responders.
- **Les Harmonica:** Cryptographic proximity scanner. Radars scan for near devices, allow pairwise pairing, and open a temporary text message box.
- **Les Affiliate Oyun:** Mini card deck visualizer. Allows deck customization and running a round-based combat duel simulation against an automated AI player.
- **Les AI & KADRO:** Hire KADRO AI agents, converse with them in a text container, watch them output responses, and directly export results to the Living CV.
- **Les Certification:** Selective disclosure credentials manager. Toggle credentials checkboxes to dynamically alter a visual QR code (simulating zero-knowledge proof tokens).
