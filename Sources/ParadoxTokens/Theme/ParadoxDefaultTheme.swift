import SwiftUI

/// Default theme — neutral premium palette with a single restrained indigo accent.
/// Backed by `Tokens.generated.swift`. Re-skin by writing your own `ParadoxTheme` conformer.
public struct ParadoxDefaultTheme: ParadoxTheme {
    public let color: ColorSemantic
    public let typography: TypographyScale
    public let spacing: SpacingScale
    public let radius: RadiusScale
    public let motion: MotionScale
    public let elevation: ElevationScale

    public init() {
        // The default `TextStyle` uses SF Pro via `Font.system(...)`, which doesn't
        // need font registration. We touch `ParadoxFonts.registrationToken` here
        // anyway so apps that opt in to Apple Garamond for editorial headlines
        // (`Font.custom(ParadoxFonts.PostScript.regular, ...)`) don't need to call
        // a setup routine themselves. Swift's lazy static initialization makes this
        // run exactly once per process even if many themes are instantiated.
        _ = ParadoxFonts.registrationToken

        self.color = Self.makeColor()
        self.typography = Self.makeTypography()
        self.spacing = SpacingScale()
        self.radius = RadiusScale()
        self.motion = MotionScale()
        self.elevation = ElevationScale()
    }

    // MARK: - Color

    private static func makeColor() -> ColorSemantic {
        func dyn(_ pair: GeneratedColor.Pair) -> Color {
            .paradoxDynamic(light: Color(paradoxHex: pair.light), dark: Color(paradoxHex: pair.dark))
        }
        return ColorSemantic(
            background: .init(
                primary: dyn(GeneratedColor.backgroundPrimary),
                secondary: dyn(GeneratedColor.backgroundSecondary),
                tertiary: dyn(GeneratedColor.backgroundTertiary),
                elevated: dyn(GeneratedColor.backgroundElevated)
            ),
            surface: .init(
                primary: dyn(GeneratedColor.surfacePrimary),
                secondary: dyn(GeneratedColor.surfaceSecondary),
                raised: dyn(GeneratedColor.surfaceRaised),
                overlay: dyn(GeneratedColor.surfaceOverlay)
            ),
            text: .init(
                primary: dyn(GeneratedColor.textPrimary),
                secondary: dyn(GeneratedColor.textSecondary),
                tertiary: dyn(GeneratedColor.textTertiary),
                inverse: dyn(GeneratedColor.textInverse),
                link: dyn(GeneratedColor.textLink),
                disabled: dyn(GeneratedColor.textDisabled)
            ),
            border: .init(
                subtle: dyn(GeneratedColor.borderSubtle),
                default: dyn(GeneratedColor.borderDefault),
                strong: dyn(GeneratedColor.borderStrong),
                focus: dyn(GeneratedColor.borderFocus)
            ),
            status: .init(
                success: dyn(GeneratedColor.statusSuccess),
                warning: dyn(GeneratedColor.statusWarning),
                error: dyn(GeneratedColor.statusError),
                info: dyn(GeneratedColor.statusInfo)
            ),
            accent: .init(
                primary: dyn(GeneratedColor.accentPrimary),
                primaryPressed: dyn(GeneratedColor.accentPrimaryPressed),
                primarySubtle: dyn(GeneratedColor.accentPrimarySubtle)
            )
        )
    }

    // MARK: - Typography

    private static func makeTypography() -> TypographyScale {
        TypographyScale(
            display:     TextStyle(size: 34, lineHeight: 41, tracking: 0.37,  weight: .bold,     relativeTo: .largeTitle),
            titleLarge:  TextStyle(size: 28, lineHeight: 34, tracking: 0.36,  weight: .bold,     relativeTo: .title),
            titleMedium: TextStyle(size: 22, lineHeight: 28, tracking: 0.35,  weight: .semibold, relativeTo: .title2),
            titleSmall:  TextStyle(size: 20, lineHeight: 25, tracking: 0.38,  weight: .semibold, relativeTo: .title3),
            headline:    TextStyle(size: 17, lineHeight: 22, tracking: -0.43, weight: .semibold, relativeTo: .headline),
            bodyLarge:   TextStyle(size: 17, lineHeight: 22, tracking: -0.43, weight: .regular,  relativeTo: .body),
            body:        TextStyle(size: 15, lineHeight: 20, tracking: -0.24, weight: .regular,  relativeTo: .callout),
            bodySmall:   TextStyle(size: 13, lineHeight: 18, tracking: -0.08, weight: .regular,  relativeTo: .footnote),
            label:       TextStyle(size: 13, lineHeight: 18, tracking: -0.08, weight: .medium,   relativeTo: .footnote),
            caption:     TextStyle(size: 12, lineHeight: 16, tracking: 0,     weight: .regular,  relativeTo: .caption),
            micro:       TextStyle(size: 11, lineHeight: 13, tracking: 0.07,  weight: .regular,  relativeTo: .caption2)
        )
    }
}
