# Tokens

`tokens.json` is the **source of truth** for ParadoxDesignSystem foundation tokens. Both Figma and Swift consume it.

## Layout

Simplified W3C Design Tokens shape:

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

- **Colors** always carry a `{ light, dark }` pair, even when both modes are the same.
- **Dimensions** are plain numbers in points.

## Pipeline

```
Figma Variables ──export──▶ tokens.json ──generate-tokens──▶ Sources/ParadoxTokens/Generated/Tokens.generated.swift
```

See [../docs/TOKEN_PIPELINE.md](../docs/TOKEN_PIPELINE.md) for the full workflow including Figma export commands and codegen invocation.
