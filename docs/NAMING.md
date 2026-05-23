# Naming Conventions

Locked for the life of the design system. Consistency outweighs personal taste here.

## Public Swift types

- All public types are prefixed `Paradox*`: `ParadoxTheme`, `ParadoxDefaultTheme`, `ParadoxGlass`.
- View modifiers are prefixed `paradox`: `.paradoxText(_:)`, `.paradoxShadow(_:)`, `.paradoxTheme(_:)`, `.paradoxAnimation(_:value:)`.
- Internal/generated namespaces are prefixed `Generated*`: `GeneratedColor`, `GeneratedSpacing`, `GeneratedRadius`. Apps should never reference these — they exist only to back `ParadoxDefaultTheme`.

## Semantic tokens

- **Always role-based**, never primitive: `theme.color.text.primary`, never `theme.color.gray100`.
- Categories are nouns (`background`, `surface`, `text`, `border`, `status`, `accent`).
- Modifiers are adjectives or states (`primary`, `secondary`, `tertiary`, `pressed`, `subtle`, `inverse`).

## Files

- One primary type per file; file name mirrors the type.
- Exception: small related types (e.g., `ColorSemantic.Background`) live in the parent file.
- Generated files end in `.generated.swift` and are committed with the warning header.

## Figma

- Variables: lowercase dot notation matching Swift property paths (`color.text.primary`, `spacing.lg`).
- Components: `Category / Component / Variant` (e.g., `Action / Button / Primary`).
- Pages: emoji prefix for scannability (`🟦 Foundations`, `🧩 Components`).

## Commits

Use the `<type>: <description>` convention from your global git workflow:

```
feat:   new public surface area
fix:    bug in existing surface
refactor: internal restructure with no API change
docs:   documentation only
test:   tests only
chore:  tooling, configs, scripts
```

Handoff commits from the Windows script auto-prefix with `handoff:`.

## DocC

- Every `public` symbol gets a `///` doc comment.
- First sentence is a one-line summary that stands alone in API listings.
- Use `## Topics` to group related symbols in catalog pages.
