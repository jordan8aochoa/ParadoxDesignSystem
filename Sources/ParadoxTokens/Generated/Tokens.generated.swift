// MARK: - Auto-generated. Do not edit by hand.
//
// Source: Tokens/tokens.json
// Generator: swift run generate-tokens
//
// To regenerate:
//   swift run generate-tokens
//
// Light/dark pairs are stored as `(light, dark)` hex tuples and resolved
// at render time via `Color.paradoxDynamic`.

/// Generated color tokens. Internal to ParadoxTokens — apps should never reference
/// these directly. Use semantic roles on `ParadoxTheme.color` instead.
public enum GeneratedColor {
    public typealias Pair = (light: String, dark: String)

    // Background
    public static let backgroundPrimary:   Pair = ("#FFFFFF", "#0A0A0F")
    public static let backgroundSecondary: Pair = ("#F7F7F8", "#101015")
    public static let backgroundTertiary:  Pair = ("#EFEFF1", "#16161C")
    public static let backgroundElevated:  Pair = ("#FFFFFF", "#1C1C24")

    // Surface
    public static let surfacePrimary:   Pair = ("#FFFFFF", "#15151B")
    public static let surfaceSecondary: Pair = ("#F4F4F6", "#1B1B22")
    public static let surfaceRaised:    Pair = ("#FFFFFF", "#22222B")
    public static let surfaceOverlay:   Pair = ("#00000066", "#000000A8")

    // Text
    public static let textPrimary:   Pair = ("#0B0B10", "#F5F5F7")
    public static let textSecondary: Pair = ("#41414A", "#C7C7D1")
    public static let textTertiary:  Pair = ("#73737E", "#8F8F9A")
    public static let textInverse:   Pair = ("#FFFFFF", "#0B0B10")
    public static let textLink:      Pair = ("#5562EA", "#8A93F5")
    public static let textDisabled:  Pair = ("#B8B8C0", "#54545E")

    // Border
    public static let borderSubtle:  Pair = ("#ECECEF", "#1F1F27")
    public static let borderDefault: Pair = ("#DCDCE1", "#2A2A33")
    public static let borderStrong:  Pair = ("#B8B8C0", "#3D3D48")
    public static let borderFocus:   Pair = ("#5562EA", "#8A93F5")

    // Status
    public static let statusSuccess: Pair = ("#1F9D55", "#3DD68A")
    public static let statusWarning: Pair = ("#C77700", "#F2B045")
    public static let statusError:   Pair = ("#D7363B", "#FF6B6F")
    public static let statusInfo:    Pair = ("#0B79D0", "#5BB8FF")

    // Accent — neutral premium indigo. Swap out via a custom ParadoxTheme.
    public static let accentPrimary:        Pair = ("#5562EA", "#7B86F2")
    public static let accentPrimaryPressed: Pair = ("#4450C8", "#5F6BE0")
    public static let accentPrimarySubtle:  Pair = ("#EEF0FE", "#1F2240")
}
