# Implementation Plan: Les Commerce Local Launch & Integration

This plan outlines the steps to run all existing **Les Commerce** family components locally and update the main **Les Go PWA** to link directly to these live local instances.

## Proposed Changes

### 1. PWA Storefront Link Alignment
- **`[MODIFY]` [main.tsx](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/main.tsx)**
  - Align Quick Commerce storefront standalone URL to port `3005` (matching the Astro server configuration):
    ```diff
    - standaloneUrl: "http://127.0.0.1:4321/",
    + standaloneUrl: "http://127.0.0.1:3005/",
    ```

### 2. Launching Backends & Storefronts
We will launch the following 4 servers as background processes:
1. **Dukkadee DIY Backend** (Elixir/Phoenix):
   - Directory: `Les_Commerce/commerce-backend`
   - Command: `PowerShell.exe -File start_diy.ps1` (runs on Port 4003)
2. **Dukkadee Quick Commerce Backend** (Elixir/Phoenix):
   - Directory: `Les_Commerce/commerce-backend`
   - Command: `PowerShell.exe -File start_quick.ps1` (runs on Port 4005)
3. **DIY Marketplace Storefront** (Next.js):
   - Directory: `Les_Commerce/diy-marketplace-elixir/storefront`
   - Command: `npx next dev -p 3006` (runs on Port 3006)
4. **Quick Commerce Storefront** (Astro):
   - Directory: `Les_Commerce/quick-commerce-elixir/storefront`
   - Command: `npm run dev` (runs on Port 3005 based on `astro.config.mjs`)

---

## Verification Plan

### Port Scanning
Verify that the following local ports are active and listening:
- `3005` (Astro storefront)
- `3006` (Next.js storefront)
- `4003` (DIY Backend)
- `4005` (Quick Commerce Backend)

### Manual Verification
- Access `http://127.0.0.1:5174/` (PWA)
- Click on "Les Commerce" tab
- Verify that clicking "Open DIY storefront" opens the Next.js app at port `3006`
- Verify that clicking "Open quick storefront" opens the Astro app at port `3005`
