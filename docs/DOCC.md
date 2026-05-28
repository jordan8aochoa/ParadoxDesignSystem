# DocC catalog

ParadoxDesignSystem ships three DocC catalogs — one per library target:

| Catalog | Location | Covers |
|---|---|---|
| `ParadoxTokens` | `Sources/ParadoxTokens/Documentation.docc/` | Theme protocol, token scales, font pipeline |
| `ParadoxUI` | `Sources/ParadoxUI/Documentation.docc/` | All shipped components + motion modifiers |
| `ParadoxGlass` | `Sources/ParadoxGlass/Documentation.docc/` | iOS 26 Liquid Glass surfaces |

`ParadoxUI` re-exports `ParadoxTokens`, so most app docs only need to reference `ParadoxUI` and `ParadoxGlass`.

## Preview locally (Mac)

DocC ships with Xcode. Two ways to open it:

### 1. Xcode → Product → Build Documentation

Open the package in Xcode (`File → Open → ParadoxDesignSystem`), select a library scheme (`ParadoxTokens`, `ParadoxUI`, or `ParadoxGlass`), then run `Product → Build Documentation` (`⌃⇧⌘D`). The DocC archive opens in Xcode's documentation window with full navigation.

### 2. swift-docc-plugin (preview server)

Add the plugin once to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.0"),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.0")
],
```

Then preview from the command line:

```bash
swift package --disable-sandbox preview-documentation --target ParadoxUI
```

The preview server prints a `http://localhost:8000` URL.

## Publish to GitHub Pages

Generate a static site and host it on the repo's `gh-pages` branch:

```bash
# 1. Generate static archives for each target
swift package --allow-writing-to-directory ./docs-site \
    generate-documentation \
    --target ParadoxTokens \
    --output-path ./docs-site/tokens \
    --hosting-base-path ParadoxDesignSystem/tokens \
    --transform-for-static-hosting

swift package --allow-writing-to-directory ./docs-site \
    generate-documentation \
    --target ParadoxUI \
    --output-path ./docs-site/ui \
    --hosting-base-path ParadoxDesignSystem/ui \
    --transform-for-static-hosting

swift package --allow-writing-to-directory ./docs-site \
    generate-documentation \
    --target ParadoxGlass \
    --output-path ./docs-site/glass \
    --hosting-base-path ParadoxDesignSystem/glass \
    --transform-for-static-hosting

# 2. Push to gh-pages
git subtree push --prefix docs-site origin gh-pages
```

GitHub Pages will serve the site at:

- `https://jordan8aochoa.github.io/ParadoxDesignSystem/tokens/documentation/paradoxtokens/`
- `https://jordan8aochoa.github.io/ParadoxDesignSystem/ui/documentation/paradoxui/`
- `https://jordan8aochoa.github.io/ParadoxDesignSystem/glass/documentation/paradoxglass/`

Wire a GitHub Actions workflow when adoption proves the docs are useful enough to deserve continuous deployment.

## Authoring conventions

- **One article per major topic.** `ParadoxUI` already ships `Components.md` (full component tour) and `Motion.md`. Add more as features land.
- **Cross-link with `` ``Type`` `` syntax.** Inside `ParadoxUI`, refer to tokens as ``ParadoxTokens/ParadoxTheme``. Inside `ParadoxGlass`, refer to ``ParadoxUI/ParadoxNavigationBar``.
- **Lead with a runnable snippet.** Every public type's doc comment should include a `Example:` block readers can paste into a playground.
- **Group by purpose, not by file.** Use `### Subheading` Topics blocks at the bottom of each article — Buttons, Inputs, Overlays, Motion, etc.
