import SwiftUI

/// Typography scale. Each style is a SwiftUI `Font` with Dynamic Type via `relativeTo`,
/// plus accompanying line-height and tracking metadata for layout work.
public struct TypographyScale: Sendable {
    public let display: TextStyle
    public let titleLarge: TextStyle
    public let titleMedium: TextStyle
    public let titleSmall: TextStyle
    public let headline: TextStyle
    public let bodyLarge: TextStyle
    public let body: TextStyle
    public let bodySmall: TextStyle
    public let label: TextStyle
    public let caption: TextStyle
    public let micro: TextStyle

    public init(
        display: TextStyle, titleLarge: TextStyle, titleMedium: TextStyle, titleSmall: TextStyle,
        headline: TextStyle, bodyLarge: TextStyle, body: TextStyle, bodySmall: TextStyle,
        label: TextStyle, caption: TextStyle, micro: TextStyle
    ) {
        self.display = display
        self.titleLarge = titleLarge; self.titleMedium = titleMedium; self.titleSmall = titleSmall
        self.headline = headline
        self.bodyLarge = bodyLarge; self.body = body; self.bodySmall = bodySmall
        self.label = label; self.caption = caption; self.micro = micro
    }
}

/// A typography token. Use `font` directly with `.font()`; use `lineHeight` and `tracking`
/// in custom layout when you need to align to baseline grids.
public struct TextStyle: Sendable {
    public let font: Font
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let tracking: CGFloat
    public let weight: Font.Weight

    public init(
        size: CGFloat,
        lineHeight: CGFloat,
        tracking: CGFloat,
        weight: Font.Weight,
        relativeTo: Font.TextStyle
    ) {
        self.size = size
        self.lineHeight = lineHeight
        self.tracking = tracking
        self.weight = weight
        self.font = .system(size: size, weight: weight, design: .default)
            .leading(.standard)
    }
}

public extension View {
    /// Apply a Paradox `TextStyle` — font + tracking + line spacing in one call.
    func paradoxText(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(max(0, style.lineHeight - style.size))
    }
}
