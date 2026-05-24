# ``ParadoxUI``

A premium SwiftUI design system for iOS — calm, native, timeless.

## Overview

`ParadoxUI` will host components, modifiers, and motion patterns starting in Phase 2. Phase 1 ships only the foundation layer: `ParadoxTokens`, which `ParadoxUI` re-exports.

## Typography

`ParadoxTokens` bundles **Apple Garamond** (~280KB across 6 weight/italic variants) and registers it with the OS at first use via ``ParadoxFonts/registrationToken``. `Font.custom(...)` with `relativeTo:` keeps Dynamic Type working. Apps using `ParadoxDefaultTheme` get registration for free; apps with a custom `ParadoxTheme` should touch `_ = ParadoxFonts.registrationToken` at startup.

## Getting started

Add the package to your `Package.swift`:

```swift
.package(path: "../ParadoxDesignSystem")
```

Then import:

```swift
import ParadoxUI   // re-exports ParadoxTokens
```

## Using tokens

Read the active theme from the environment, then index into role-based namespaces:

```swift
struct ProfileCard: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Jordan")
                .paradoxText(theme.typography.titleMedium)
                .foregroundStyle(theme.color.text.primary)
            Text("homeloansbyjordan@gmail.com")
                .paradoxText(theme.typography.body)
                .foregroundStyle(theme.color.text.secondary)
        }
        .padding(theme.spacing.lg)
        .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
        .paradoxShadow(theme.elevation.level1)
    }
}
```

## Re-skinning

Provide a custom conformer to ``ParadoxTokens/ParadoxTheme``:

```swift
struct TapOutTheme: ParadoxTheme { /* override color.accent.primary, etc. */ }

@main
struct TapOutApp: App {
    var body: some Scene {
        WindowGroup { RootView().paradoxTheme(TapOutTheme()) }
    }
}
```

## Topics

### Foundations

- ``ParadoxTokens/ParadoxTheme``
- ``ParadoxTokens/ParadoxDefaultTheme``
- ``ParadoxTokens/ColorSemantic``
- ``ParadoxTokens/TypographyScale``
- ``ParadoxTokens/SpacingScale``
- ``ParadoxTokens/RadiusScale``
- ``ParadoxTokens/MotionScale``
- ``ParadoxTokens/ElevationScale``
