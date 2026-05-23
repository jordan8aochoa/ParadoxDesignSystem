# Token Pipeline

```
Figma Variables ──export──▶ Tokens/tokens.json ──generate-tokens──▶ Sources/ParadoxTokens/Generated/Tokens.generated.swift
```

`tokens.json` is the **source of truth**. Both Figma and Swift consume it. Both the JSON and the generated Swift file are committed so designer-driven and engineer-driven changes show up as reviewable diffs in PRs.

## Schema

Simplified W3C Design Tokens:

```json
{
  "color": {
    "background": {
      "primary": { "$type": "color", "$value": { "light": "#FFFFFF", "dark": "#0A0A0F" } }
    }
  },
  "spacing": {
    "lg": { "$type": "dimension", "$value": 16 }
  }
}
```

- Colors always carry a `{ light, dark }` pair, even when both modes are identical.
- Dimensions are plain numbers in points.
- Keys are sorted alphabetically inside each level to keep diffs stable.

## Export from Figma

### Option A — Figma MCP (preferred when available)

From a Claude Code session with the Figma MCP loaded:

```
mcp__claude_ai_Figma__get_variable_defs
  fileKey: <your file key>
```

Pipe the result into `Tokens/tokens.json` after converting Figma's variable shape into our `{light, dark}` pair format.

### Option B — Figma REST API

```bash
curl -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/<fileKey>/variables/local" \
  > .figma-export.json
```

Then a small jq/Swift transform → `Tokens/tokens.json`. We'll automate this script when the Figma file is drawn (Phase 1.5).

## Generate Swift

From repo root (on Mac mini — or Windows once Swift for Windows is installed):

```bash
swift run generate-tokens
```

Outputs `Sources/ParadoxTokens/Generated/Tokens.generated.swift` with:

- `enum GeneratedColor` — `(light, dark)` hex pairs for every color token.
- `enum GeneratedSpacing`, `enum GeneratedRadius` — `Double` for every dimension token.

Output ordering is deterministic (alphabetical), so re-running the generator without source changes yields a byte-identical file.

## Editing tokens

**Designer flow:**

1. Edit Variables in Figma.
2. Run the export (Option A or B) → `Tokens/tokens.json`.
3. Commit JSON. PR diff shows what changed.

**Engineer flow:**

1. Edit `Tokens/tokens.json` directly.
2. Run `swift run generate-tokens`.
3. Commit both files. PR diff shows JSON intent + generated Swift consequence.

Either way, Figma + Swift stay in lockstep through the single JSON file.
