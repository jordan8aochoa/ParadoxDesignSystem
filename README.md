# ParadoxDesignSystem

A premium SwiftUI design system for iOS — calm, native, timeless. Foundation for every future iOS app.

> **Status:** Phase 1 — Foundations. Tokens, theme, playground.

## Modules

| Module | Purpose | Min iOS |
|---|---|---|
| `ParadoxTokens` | Generated tokens + `ParadoxTheme` protocol. Zero dependencies. | 17 |
| `ParadoxUI` | Components, modifiers, motion. Depends on `ParadoxTokens`. | 17 |
| `ParadoxGlass` | iOS 26 Liquid Glass extensions, `#available`-gated. | 26 |

## Repo layout

```
Sources/         Swift modules
Tokens/          tokens.json (Figma export, source of truth)
Scripts/         generate-tokens + Windows↔Mac handoff
Playground/      iOS Playground app (XcodeGen) — visual regression bed
Tests/           XCTest + snapshot tests
docs/            Architecture, Figma setup, token pipeline, handoff, naming
```

## Quick start (Mac mini)

```bash
git clone <repo> && cd ParadoxDesignSystem
swift build
swift test
swift run generate-tokens         # regenerate Tokens.generated.swift from tokens.json
cd Playground/ParadoxPlayground && xcodegen generate && open *.xcodeproj
```

## Docs

- [Architecture](docs/ARCHITECTURE.md)
- [Figma setup](docs/FIGMA_SETUP.md)
- [Token pipeline](docs/TOKEN_PIPELINE.md)
- [Windows ↔ Mac handoff](docs/HANDOFF.md)
- [Naming conventions](docs/NAMING.md)

## Roadmap

1. **Foundations** *(current)* — tokens, theme, playground
2. Core primitives — Button, Card, TextField, Toggle, Badge, Avatar, ListItem
3. Navigation & chrome — NavigationBar, TabBar, SegmentedControl, SearchBar
4. Overlays — Modal, BottomSheet, Toast, ContextMenu, FAB
5. Motion + Liquid Glass (`ParadoxGlass`)
6. Adoption — DocC site, refactor Tap Out as first real consumer
