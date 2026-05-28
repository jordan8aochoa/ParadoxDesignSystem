# ``ParadoxTokens``

The foundation layer — semantic tokens and the `ParadoxTheme` protocol that every Paradox component reads from.

## Overview

`ParadoxTokens` is intentionally zero-dependency. It defines:

- A protocol — ``ParadoxTheme`` — describing the shape of a complete design system.
- A default conformer — ``ParadoxDefaultTheme`` — generated from `Tokens/tokens.json` (the Figma source of truth).
- Semantic namespaces for color, typography, spacing, radius, motion, and elevation.
- An environment value — `\.paradoxTheme` — so any view can read the active theme.

Components in ``ParadoxUI`` and ``ParadoxGlass`` only ever talk to the theme through these protocols. That means you can re-skin any app by swapping one conformer at the root.

## Reading the theme

```swift
@Environment(\.paradoxTheme) private var theme

var body: some View {
    Text("Title")
        .paradoxText(theme.typography.titleMedium)
        .foregroundStyle(theme.color.text.primary)
        .padding(theme.spacing.lg)
}
```

## Re-skinning

Conform to ``ParadoxTheme``, override what you need, fall back to defaults for the rest:

```swift
struct TapOutTheme: ParadoxTheme {
    var color: ColorSemantic { _color }
    var typography: TypographyScale = ParadoxDefaultTheme().typography
    var spacing: SpacingScale = ParadoxDefaultTheme().spacing
    var radius: RadiusScale = ParadoxDefaultTheme().radius
    var motion: MotionScale = ParadoxDefaultTheme().motion
    var elevation: ElevationScale = ParadoxDefaultTheme().elevation

    private let _color = ColorSemantic(/* override accent.primary, etc. */)
}

@main
struct TapOutApp: App {
    var body: some Scene {
        WindowGroup { RootView().paradoxTheme(TapOutTheme()) }
    }
}
```

## Token tour

### Color

Always reference roles, never primitives:

```swift
theme.color.background.primary     // page background
theme.color.surface.raised         // a card sitting above the background
theme.color.text.primary           // body copy
theme.color.text.secondary         // supporting copy
theme.color.border.subtle          // hairline dividers
theme.color.accent.primary         // brand action color
theme.color.status.success         // green, save confirmations
```

### Typography

Eleven roles from `display` down to `micro`, each a `TextStyle` with font + tracking + line height:

```swift
Text("Hero")     .paradoxText(theme.typography.display)
Text("Headline") .paradoxText(theme.typography.headline)
Text("Body")     .paradoxText(theme.typography.body)
Text("Caption")  .paradoxText(theme.typography.caption)
```

### Spacing

8pt grid, mnemonic names:

```swift
theme.spacing.xxs   // 2pt
theme.spacing.xs    // 4pt
theme.spacing.sm    // 8pt
theme.spacing.md    // 12pt
theme.spacing.lg    // 16pt
theme.spacing.xl    // 24pt
theme.spacing.xxl   // 32pt
theme.spacing.xxxl  // 48pt
theme.spacing.xxxxl // 64pt
```

### Radius

```swift
theme.radius.sm    // 6pt   — chips, micro pills
theme.radius.md    // 8pt   — buttons, fields
theme.radius.lg    // 12pt  — cards
theme.radius.xl    // 16pt  — sheets, modals
theme.radius.xxl   // 24pt  — hero panels
theme.radius.pill  // .infinity — clamp at usage site
```

### Motion

Springs, durations, and easings ready for `withAnimation` and `.animation`:

```swift
withAnimation(theme.motion.spring.snappy) { isPressed = true }
withAnimation(theme.motion.spring.gentle) { isLoaded = true }
.animation(theme.motion.easing.emphasized, value: state)
```

### Elevation

Five shadow specs tuned for light and dark surfaces:

```swift
card.paradoxShadow(theme.elevation.level2)   // resting card
sheet.paradoxShadow(theme.elevation.level3)  // bottom sheet
fab.paradoxShadow(theme.elevation.level3)    // floating action button
```

## Token pipeline

Tokens flow Figma → JSON → Swift:

```
Figma Variables ──MCP / REST──▶ Tokens/tokens.json ──swift run generate-tokens──▶ Sources/ParadoxTokens/Generated/Tokens.generated.swift
```

See `docs/TOKEN_PIPELINE.md` in the repo for the full round-trip.

## Topics

### Protocol & default

- ``ParadoxTheme``
- ``ParadoxDefaultTheme``

### Token scales

- ``ColorSemantic``
- ``TypographyScale``
- ``TextStyle``
- ``SpacingScale``
- ``RadiusScale``
- ``MotionScale``
- ``ElevationScale``

### Fonts

- ``ParadoxFonts``
