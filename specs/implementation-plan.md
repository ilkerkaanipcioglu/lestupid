# Implementation Plan: Styles Consistency & Premium Visual Refactoring

This plan outlines the steps to find, clean up, and simplify legacy or demo-heavy styling patterns in [styles.css](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css) to align them with the new premium visual identity system.

## Proposed Changes

We will systematically update the following areas to ensure consistency in:
- **Border Radius**: Moving away from legacy `10px` roundings. Standardizing to `16px` for container headers/wrappers, `12px` for panels and cards, and `8px` for buttons, inputs, chips, and small items.
- **Colors**: Standardizing custom background tones to clean HSL variables (using `--surface`, `--paper`, `--teal`, `--muted`) instead of arbitrary `rgba(...)` blocks.
- **Shadows**: Replacing hardcoded box shadows with `--shadow` and `--shadow-hover`.
- **Typography**: Ensuring consistent use of `"Outfit"` for headlines and `"Plus Jakarta Sans"` for body text.

### Refactoring Catalog (by CSS sections)

#### 1. Global & Utility Panels
- **`[MODIFY]` [styles.css](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css)**
  - `.identity-card`: Change `border-radius: 10px` to `12px`.
  - `.place-home`: Change `border-radius: 10px` to `16px`. Ensure color palette consistency.

#### 2. Visual Gallery & Demos
- **`[MODIFY]` [styles.css](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css)**
  - `.visual-demo-hero`: Change `border-radius: 10px` to `16px`.
  - `.visual-map`: Change `border-radius: 10px` to `16px`.
  - `.visual-flow-card`: Change `border-radius: 10px` to `12px`.

#### 3. Commerce & Hotel Modules
- **`[MODIFY]` [styles.css](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css)**
  - `.commerce-family-hero`: Change `border-radius: 10px` to `16px`.
  - `.commerce-family-metrics div`: Change `border-radius: 10px` to `12px`.
  - `.commerce-family-card`: Change `border-radius: 10px` to `12px`.
  - `.commerce-family-contract`: Change `border-radius: 10px` to `12px`.
  - `.commerce-family-contract span`: Change `border-radius: 10px` to `12px`.

#### 4. Navigation & Main Simulator Container
- **`[MODIFY]` [styles.css](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css)**
  - `.sidebar-nav`: Change `border-radius: 10px` to `16px`.
  - `.sim-container`: Change `border-radius: 10px` to `16px`. Simplify background from legacy translucent `rgba(255,255,255,0.84)` to standard `--surface` with a clean border, or unified glassmorphism background `rgba(255, 255, 255, 0.85)` with `backdrop-filter: blur(16px)`.
  - `.mode-note`: Change `border-radius: 10px` to `12px` and use HSL variant for the info/warning color palette.

#### 5. Simulator Modules (Wait, ZKP, Contacts, etc.)
- **`[MODIFY]` [styles.css](file:///B:/DEV/HAREZM_EKOSISTEMI/LesTupid/les_go/src/styles.css)**
  - `.wait-field-grid input`: Change `border-radius: 10px` to `8px`.
  - `.wait-notice`: Change `border-radius: 10px` to `12px`.
  - `.zkp-proof-card`: Change `border-radius: 10px` to `12px`.
  - `.contacts-preview-panel`: Change `border-radius: 10px` to `12px`.
  - `.contacts-preview-card`: Change `border-radius: 10px` to `12px`.

---

## Verification Plan

### Automated Tests
- Build the project to verify styles compilation:
  ```powershell
  npm run build
  ```

### Manual Verification
- Verify that the layout remains stable. The changes are strictly stylistic (radius, colors, shadows, typography) and will not affect JS execution or DOM structure.
