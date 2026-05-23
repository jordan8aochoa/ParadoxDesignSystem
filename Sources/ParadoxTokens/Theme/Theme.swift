/// The public contract every Paradox component leans on.
///
/// Apps re-skin by providing a custom `ParadoxTheme` conformer and passing it via
/// `.paradoxTheme(_:)`. The default is `ParadoxDefaultTheme`.
public protocol ParadoxTheme: Sendable {
    var color: ColorSemantic { get }
    var typography: TypographyScale { get }
    var spacing: SpacingScale { get }
    var radius: RadiusScale { get }
    var motion: MotionScale { get }
    var elevation: ElevationScale { get }
}
