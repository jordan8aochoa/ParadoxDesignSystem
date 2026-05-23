# Figma Setup

> Plan tier: **Professional**. We use Variables + Collections (Light/Dark modes), Component Properties, and the REST API. Branching and unlimited modes (Organization+) are not required.

## Live file

**Paradox Design System** → https://www.figma.com/design/NcFzCklBQKGZBHrFiixgZw

`fileKey`: `NcFzCklBQKGZBHrFiixgZw` (also recorded in [`Tokens/tokens.json`](../Tokens/tokens.json) under `$figma`).

## File: "Paradox Design System"

| Page | Phase 1 content |
|---|---|
| 🟦 Foundations | Color, Typography, Spacing, Radius, Elevation specimens |
| 🧩 Components | Empty frames + naming skeleton (Phase 2+) |
| 📐 Patterns | Empty (Phase 4+) |
| 🔎 Inspiration | Reference boards: Linear, Arc, Raycast, Things 3, Stripe, Flighty, Apple Wallet/Fitness/Settings |
| 📜 Changelog | Versioned notes |

## Variable collections

Two-layer model — primitives → semantic. Components only reference semantic.

### `Color/Primitives` *(1 mode)*

Raw scale. Use 50, 100, 200, 300, 400, 500, 600, 700, 800, 900 steps.

- `gray.{50…900}`
- `indigo.{50…900}` (accent)
- `green.{500, 600}` (success)
- `amber.{500, 600}` (warning)
- `red.{500, 600}` (error)
- `blue.{500, 600}` (info)

### `Color/Semantic` *(2 modes: Light, Dark)*

Every variable references a primitive (`{Color/Primitives.gray.50}` etc.) per mode.

Roles mirror `Sources/ParadoxTokens/Color/SemanticColor.swift` exactly:

```
background.{primary, secondary, tertiary, elevated}
surface.{primary, secondary, raised, overlay}
text.{primary, secondary, tertiary, inverse, link, disabled}
border.{subtle, default, strong, focus}
status.{success, warning, error, info}
accent.{primary, primaryPressed, primarySubtle}
```

### `Size/Spacing` *(1 mode, number)*

`xxs=2, xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48, xxxxl=64`

### `Size/Radius` *(1 mode, number)*

`xs=4, sm=6, md=8, lg=12, xl=16, xxl=24, pill=9999`

## Naming convention

- Variables: `category.role.modifier` (e.g., `color.text.primary`).
- Components: `Category / Component / Variant` (Phase 2).
- Pages: emoji prefix for scannability.

## Export

See [TOKEN_PIPELINE.md](TOKEN_PIPELINE.md) for the Figma → `tokens.json` → Swift codegen flow.

## Quality bar

- All semantic colors must pass WCAG AA contrast against their typical background pair (verify in Figma Dev Mode).
- Spacing only from the scale — no one-off pixel values in component frames.
- Typography frames use Auto Layout with the same line-height values as `TypographyScale`.
