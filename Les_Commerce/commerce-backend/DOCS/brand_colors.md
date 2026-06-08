# Dukkadee Platform Brand Colors Guide

This document serves as a reference for the official brand colors of the Dukkadee platform and guidance on how to use them in the platform's design.

## Primary Colors

| Color | Hex Code | Description | Usage |
|-------|----------|-------------|-------|
| Yellow | `#fddb24` | Primary brand color | Call-to-action buttons, accents, highlights |
| Light Purple | `#b7acd4` | Secondary brand color | Secondary buttons, links, form elements |
| White | `#ffffff` | Background color | Main background, cards, modals |

## Dark Gray/Black Variations

Dukkadee employs a range of dark colors for text and UI elements with subtle variations:

| Color | Hex Code | Suggested Use |
|-------|----------|---------------|
| `#272727` | Very dark gray, almost black | Main headings, critical text |
| `#282828` | Very dark gray | Secondary headings |
| `#292929` | Very dark gray | Important text elements |
| `#2a2a2a` | Very dark gray | Regular text elements |
| `#2b2b2b` | Dark gray | Secondary text elements |
| `#2c2c2c` | Dark gray | Tertiary text elements |
| `#2d2d2d` | Dark gray | Strong borders |
| `#2e2e2e` | Dark gray | Dialog headers |
| `#2f2f2f` | Dark gray | Standard text |
| `#303030` | Dark gray | Form labels |
| `#313131` | Medium dark gray | Brief instructions |
| `#323232` | Medium dark gray | Placeholders |
| `#333333` | Medium dark gray | Disabled text |
| `#343434` | Medium dark gray | Secondary borders |
| `#353535` | Medium dark gray | Subtle separators |
| `#363636` | Medium dark gray | Light borders |
| `#373737` | Medium dark gray | Very subtle UI elements |

## Implementation in the Platform

The Dukkadee platform implements these colors through:

1. CSS variables defined in `assets/css/brand_colors.css`
2. Elixir module `DukkadeeWeb.Components.BrandColors` for generating dynamic styling

## Store Customization

Each store can optionally customize their color scheme, which will override certain default colors. The Dukkadee platform maintains visual coherence by:

- Preserving layout and spacing
- Ensuring sufficient color contrast for accessibility
- Applying store colors consistently across all store pages

## Customer Portal Personalization

Customers can customize certain aspects of their portal experience, including:

- Primary color preference
- Secondary color preference
- Light/dark mode preference

These customizations are stored in user preferences and applied when the customer is logged in.

## Usage Guidelines

When implementing new components or pages:

1. Always use the predefined CSS variables rather than hardcoding color values
2. Use the semantic color assignments (e.g., `--color-primary`) rather than the specific color variables
3. Test components in both light and dark modes
4. Ensure all text meets WCAG 2.1 AA contrast requirements

## Color Accessibility

All color combinations in the default theme have been tested to ensure they meet WCAG 2.1 AA standards for contrast. When implementing new color combinations, use tools like the WebAIM Contrast Checker to verify accessibility.
