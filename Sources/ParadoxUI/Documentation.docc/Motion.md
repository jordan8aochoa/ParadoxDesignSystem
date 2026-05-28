# Motion

Animation primitives that respect `accessibilityReduceMotion`.

## Overview

Paradox motion comes in two layers:

1. **Theme-level animations** on ``ParadoxTokens/MotionScale`` — springs (`snappy`, `gentle`, `bouncy`), durations (`fast`, `standard`, `slow`), and easings. Components reach for these for press states, transitions, and value changes.

2. **View modifiers** in this module for moments that don't map cleanly onto a single spring — skeleton loading, breathing pulses, staggered reveals, and celebration moments.

Every modifier honors `accessibilityReduceMotion`. With reduce-motion on, animations drop to a static fallback rather than disabling the affordance entirely.

## Skeleton shimmer

Use while content loads. Apply to placeholder shapes the size of the eventual content:

```swift
VStack(alignment: .leading, spacing: 8) {
    Capsule().fill(.clear).frame(width: 140, height: 16).paradoxShimmer()
    Capsule().fill(.clear).frame(width: 220, height: 12).paradoxShimmer()
}
```

The shimmer animates a moving highlight across the host shape. Under reduce-motion it falls back to a flat `surface.secondary` fill.

## Pulse

A slow opacity + scale loop. Default values are tuned for small status dots — a "live" indicator, a fresh notification:

```swift
Circle()
    .fill(theme.color.status.success)
    .frame(width: 8, height: 8)
    .paradoxPulse()
```

Customize the breath for larger elements:

```swift
icon.paradoxPulse(minScale: 0.85, maxScale: 1.0, minOpacity: 0.5, duration: 1.6)
```

## Stagger

A cascading entry animation for list-like content. Each child fades in and rises 8pt, delayed by `index * stride`:

```swift
VStack(spacing: 12) {
    ForEach(items.indices, id: \.self) { i in
        ItemRow(items[i])
            .paradoxStagger(index: i)
    }
}
```

Defaults: 0.05s between items. Tune `stride` for longer lists, `baseDelay` to offset the whole cascade.

## Celebrate

A three-phase phase-animator (rest → bloom → settle) triggered by a value change. Pair it with a value that increments on success — completion count, score id, etc.:

```swift
@State var completionId = 0

VStack {
    Image(systemName: "checkmark.seal.fill")
        .font(.system(size: 64))
        .foregroundStyle(theme.color.status.success)
        .paradoxCelebrate(trigger: completionId)

    Button("Complete") { completionId &+= 1 }
        .buttonStyle(.paradoxPrimary)
}
```

The bloom phase scales 1.18× with a -6° rotation. Settle returns to rest with a softer spring.

## Topics

### Modifiers

- ``ParadoxShimmerModifier``
- ``ParadoxPulseModifier``
- ``ParadoxStaggerModifier``
- ``ParadoxCelebrateModifier``
