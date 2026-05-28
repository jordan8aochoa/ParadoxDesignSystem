# ``ParadoxGlass``

iOS 26 Liquid Glass extensions for Paradox.

## Overview

`ParadoxGlass` adds floating, refractive glass surfaces that bend and tint the content behind them. The entire public surface is `@available(iOS 26, *)` — apps that link this module can still target iOS 17+, they just need to wrap call sites in availability checks:

```swift
if #available(iOS 26, *) {
    sidebar.paradoxGlass(radius: .lg)
} else {
    sidebar.background(theme.color.background.elevated, in: RoundedRectangle(cornerRadius: 12))
}
```

## When to use glass

Reach for glass when content **scrolls under chrome** and the chrome should feel like it's floating above:

- A navigation bar on a long-scrolling page.
- A bottom action row over photo or media content.
- A side panel over a colorful canvas.

Avoid glass for **resting flat surfaces** (a settings list, a form). Use ``ParadoxUI/ParadoxCard`` for those — it stays calm.

## Core modifier

```swift
content.paradoxGlass()                                    // default md radius
content.paradoxGlass(radius: .lg)                         // larger corner
content.paradoxGlass(tint: theme.color.accent.primary.opacity(0.15))  // tinted
```

## Card

A convenience that pads its content and applies a glass background with the `lg` radius:

```swift
ParadoxGlassCard {
    VStack(alignment: .leading, spacing: 8) {
        Text("Now playing").font(.headline)
        Text("Daft Punk — Around the World").foregroundStyle(.secondary)
    }
}
```

## Morphing groups

When multiple glass elements live near each other and should morph together as the user touches them, wrap them in a container:

```swift
ParadoxGlassContainer {
    HStack(spacing: 8) {
        Button(action: previous) { Image(systemName: "backward.fill") }
            .padding(12).paradoxGlass(radius: .pill)
        Button(action: play) { Image(systemName: "play.fill") }
            .padding(12).paradoxGlass(radius: .pill)
        Button(action: next) { Image(systemName: "forward.fill") }
            .padding(12).paradoxGlass(radius: .pill)
    }
}
```

## Floating navigation bar

A drop-in glass-backed variant of ``ParadoxUI/ParadoxNavigationBar``. Use it when the screen below scrolls under the chrome:

```swift
VStack(spacing: 0) {
    ParadoxGlassNavigationBar(title: "Discover")
    ScrollView { ... }
}
```

## Topics

### Surfaces

- ``ParadoxGlassModifier``
- ``ParadoxGlassCard``
- ``ParadoxGlassContainer``

### Chrome

- ``ParadoxGlassNavigationBar``
