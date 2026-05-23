import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Semantic color roles. Always reference these from app code — never primitives.
///
/// Each role resolves to the appropriate light or dark value via `Color.paradoxDynamic`,
/// which uses the current `userInterfaceStyle` at render time.
public struct ColorSemantic: Sendable {
    public let background: Background
    public let surface: Surface
    public let text: Text
    public let border: Border
    public let status: Status
    public let accent: Accent

    public init(
        background: Background,
        surface: Surface,
        text: Text,
        border: Border,
        status: Status,
        accent: Accent
    ) {
        self.background = background
        self.surface = surface
        self.text = text
        self.border = border
        self.status = status
        self.accent = accent
    }

    public struct Background: Sendable {
        public let primary: Color
        public let secondary: Color
        public let tertiary: Color
        public let elevated: Color
        public init(primary: Color, secondary: Color, tertiary: Color, elevated: Color) {
            self.primary = primary; self.secondary = secondary
            self.tertiary = tertiary; self.elevated = elevated
        }
    }

    public struct Surface: Sendable {
        public let primary: Color
        public let secondary: Color
        public let raised: Color
        public let overlay: Color
        public init(primary: Color, secondary: Color, raised: Color, overlay: Color) {
            self.primary = primary; self.secondary = secondary
            self.raised = raised; self.overlay = overlay
        }
    }

    public struct Text: Sendable {
        public let primary: Color
        public let secondary: Color
        public let tertiary: Color
        public let inverse: Color
        public let link: Color
        public let disabled: Color
        public init(primary: Color, secondary: Color, tertiary: Color, inverse: Color, link: Color, disabled: Color) {
            self.primary = primary; self.secondary = secondary; self.tertiary = tertiary
            self.inverse = inverse; self.link = link; self.disabled = disabled
        }
    }

    public struct Border: Sendable {
        public let subtle: Color
        public let `default`: Color
        public let strong: Color
        public let focus: Color
        public init(subtle: Color, default defaultColor: Color, strong: Color, focus: Color) {
            self.subtle = subtle
            self.`default` = defaultColor
            self.strong = strong
            self.focus = focus
        }
    }

    public struct Status: Sendable {
        public let success: Color
        public let warning: Color
        public let error: Color
        public let info: Color
        public init(success: Color, warning: Color, error: Color, info: Color) {
            self.success = success; self.warning = warning
            self.error = error; self.info = info
        }
    }

    public struct Accent: Sendable {
        public let primary: Color
        public let primaryPressed: Color
        public let primarySubtle: Color
        public init(primary: Color, primaryPressed: Color, primarySubtle: Color) {
            self.primary = primary
            self.primaryPressed = primaryPressed
            self.primarySubtle = primarySubtle
        }
    }
}

// MARK: - Dynamic color helper

public extension Color {
    /// Resolves to `light` or `dark` based on the current trait collection.
    /// On non-UIKit platforms falls back to `light`.
    static func paradoxDynamic(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        return light
        #endif
    }

    /// Construct a `Color` from a hex string like `#1A1A1F` or `1A1A1F`.
    init(paradoxHex hex: String) {
        var trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("#") { trimmed.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: trimmed).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}
