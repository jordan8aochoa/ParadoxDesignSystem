# ``ParadoxUI``

A premium SwiftUI design system for iOS — calm, native, timeless.

## Overview

`ParadoxUI` ships the full component vocabulary on top of ``ParadoxTokens``. Read the active theme from the environment, then index into role-based namespaces — never hard-code colors, sizes, or animations.

```swift
import ParadoxUI

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
        .background(theme.color.surface.raised,
                    in: RoundedRectangle(cornerRadius: theme.radius.lg))
        .paradoxShadow(theme.elevation.level1)
    }
}
```

## Getting started

Add the package to your `Package.swift`:

```swift
.package(path: "../ParadoxDesignSystem")
```

Then import — `ParadoxUI` re-exports ``ParadoxTokens``, so you only need one import:

```swift
import ParadoxUI
```

At the root of your app, supply a theme:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup { RootView().paradoxTheme(ParadoxDefaultTheme()) }
    }
}
```

## Typography

The default `TypographyScale` uses **SF Pro** via `Font.system(...)` — Apple-native, free Dynamic Type, OS-managed optical sizing. Use this for ~99% of app chrome.

For an editorial hero headline, ``ParadoxTokens`` bundles **Apple Garamond** (~280KB across 6 weight/italic variants) and auto-registers it. Opt in via `Font.custom`:

```swift
Text("Welcome")
    .font(.custom(ParadoxFonts.PostScript.regular, size: 34, relativeTo: .largeTitle))
```

Apps using ``ParadoxTokens/ParadoxDefaultTheme`` get registration for free. Apps with a custom ``ParadoxTokens/ParadoxTheme`` should touch `_ = ParadoxFonts.registrationToken` at startup.

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

### Articles

- <doc:Components>
- <doc:Motion>

### Buttons

- ``ParadoxButtonStyle``
- ``ParadoxHaptic``

### Cards & lists

- ``ParadoxCard``
- ``ParadoxListItem``
- ``ParadoxAccessory``

### Inputs

- ``ParadoxTextFieldStyleModifier``
- ``ParadoxFieldMessage``
- ``ParadoxToggle``

### Badges & avatars

- ``ParadoxBadge``
- ``ParadoxAvatar``

### Navigation & chrome

- ``ParadoxNavigationBar``
- ``ParadoxTabBar``
- ``ParadoxSegmentedControl``
- ``ParadoxSearchBar``

### Overlays

- ``ParadoxModal``
- ``ParadoxBottomSheetContainer``
- ``ParadoxBottomSheetDetent``
- ``ParadoxToast``
- ``ParadoxContextAction``
- ``ParadoxFAB``

### Motion

- ``ParadoxShimmerModifier``
- ``ParadoxPulseModifier``
- ``ParadoxStaggerModifier``
- ``ParadoxCelebrateModifier``
