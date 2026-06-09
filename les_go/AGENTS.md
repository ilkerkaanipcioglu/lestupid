# les_go PWA Client

This module contains the main React / Vite PWA shell for the LESTUPID ecosystem.

## Role & Responsibility

- Serves as the central user portal, aggregating feed notifications, opportunities, and launching standalone sub-app modules through adapters.
- Runs standalone in the browser using mock adapters when offline or when backend services are disconnected.

## Local Configuration & Running

- **Environment**: Configuration is driven by `les_go/.env`. Default mode is set to:
  ```env
  VITE_CORE_ADAPTER=mock
  VITE_OPPORTUNITY_ADAPTER=mock
  ```
- **Port**: Listens on `http://127.0.0.1:5174/` (or port configured on startup).
- **Run Command**: `npm run dev`

## UI & Design Conventions

- All panels, containers, and modules must follow the design standards defined in the root [AGENTS.md](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/AGENTS.md):
  - Fonts: `"Outfit"` for headings, `"Plus Jakarta Sans"` for body.
  - Border radii: `16px` for `.sim-container` and layouts, `12px` for cards, `8px` for inputs/buttons.
  - Shadows: use `--shadow` and `--shadow-hover` variable tokens.
