# Architecture

## Modules

```
┌─────────────────────────┐
│ ParadoxGlass            │  iOS 26+, #available-gated
│ (Liquid Glass)          │
└──────────┬──────────────┘
           │ depends on
┌──────────▼──────────────┐
│ ParadoxUI               │  Components, modifiers, motion (Phase 2+)
│                         │  Re-exports ParadoxTokens
└──────────┬──────────────┘
           │ depends on
┌──────────▼──────────────┐
│ ParadoxTokens           │  Zero deps. Generated tokens + Theme protocol.
└─────────────────────────┘
```

`ParadoxTokens` has zero external dependencies so any app can pull tokens alone for a lightweight integration.

## Theme contract

`ParadoxTheme` is the single public protocol every component reads from. The default conformer is `ParadoxDefaultTheme`. Apps re-skin by passing a custom conformer to `.paradoxTheme(_:)`.

Theme exposes six subsystems:

- `color`: `ColorSemantic` — role-based (background, surface, text, border, status, accent)
- `typography`: `TypographyScale` — 11 styles with Dynamic Type
- `spacing`: `SpacingScale` — 8pt grid (xxs…xxxxl)
- `radius`: `RadiusScale` — xs…xxl + pill
- `motion`: `MotionScale` — springs/durations/easings, reduce-motion aware
- `elevation`: `ElevationScale` — 5 shadow levels

## Primitive vs semantic

We use a two-layer token model:

1. **Primitives** (raw `gray-50…900`, `indigo-50…900`, etc.) live in Figma's `Color/Primitives` collection and in `Tokens/tokens.json` as the leaves of the JSON tree.
2. **Semantic** roles (`color.text.primary`) live in Figma's `Color/Semantic` collection (with Light/Dark modes) and reference primitives.

Components (Phase 2+) consume only semantic. Apps consume only semantic. Primitives never leak into public API.

## Folder layout

See [README.md](../README.md#repo-layout) for the full tree.

## Phase boundaries

| Phase | Adds |
|---|---|
| 1 | This document. Tokens + theme + playground + docs. |
| 2 | Core primitives in `ParadoxUI` |
| 3 | Nav & chrome |
| 4 | Overlays |
| 5 | Motion patterns + `ParadoxGlass` |
| 6 | DocC site + first real app adopting the package |
