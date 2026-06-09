# Les Commerce

Les Commerce is the business and trading layer of the LESTUPID ecosystem. It consists of multiple marketplace engines, vertical apps, and storefronts.

## Local Sub-modules

- **diy-marketplace-elixir**: Next.js storefront (Port 3006) and Elixir/Phoenix backend (Port 4003).
- **quick-commerce-elixir**: Astro storefront (Port 3005) and Elixir/Phoenix backend (Port 4005).
- **commerce-backend**: The central database and API server for all commerce logic (Dukkadee).
- **les_itemotel**: Spec and visual simulation for physical items custody.
- **books-marketplace**: Sahaf and collectible books marketplace engine.

## Local Configuration & Running

- **DIY Marketplace Backend**: Runs on Port `4003` (database: `dukkadee_dev.db`). Launch via `PowerShell -File start_diy.ps1`.
- **DIY Marketplace Storefront**: Runs on Port `3006` (Next.js dev). Launch via `npx next dev -p 3006` inside `diy-marketplace-elixir/storefront`.
- **Quick Commerce Backend**: Runs on Port `4005` (database: `dukkadee_africa.db`). Launch via `PowerShell -File start_quick.ps1`.
- **Quick Commerce Storefront**: Runs on Port `3005` (Astro dev). Launch via `npm run dev` inside `quick-commerce-elixir/storefront`.
- **Database**: All backends use SQLite databases located inside `commerce-backend/`.

## Local Conventions

- Storefront redirects inside the main PWA are configured in `les_go/src/main.tsx` and must point to these respective local server ports.
