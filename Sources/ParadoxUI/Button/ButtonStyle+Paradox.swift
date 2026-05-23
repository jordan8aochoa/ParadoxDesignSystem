import SwiftUI

public extension ButtonStyle where Self == ParadoxButtonStyle {
    /// Filled accent button. Default haptic: light. Foreground: text.inverse.
    /// Typical use: primary call-to-action ("Sign in", "Save", "Continue").
    static var paradoxPrimary: ParadoxButtonStyle { .init(variant: .primary) }

    /// Subtle background fill. Default haptic: light. Foreground: text.primary.
    /// Typical use: secondary actions next to a primary ("Cancel", "Skip").
    static var paradoxSecondary: ParadoxButtonStyle { .init(variant: .secondary) }

    /// Text-only, no background or border. Default haptic: none.
    /// Typical use: inline actions in a row, toolbar text buttons.
    static var paradoxTertiary: ParadoxButtonStyle { .init(variant: .tertiary) }

    /// Hollow with a 1pt border. Default haptic: none.
    /// Typical use: equal-weight choices, low-emphasis actions in dense layouts.
    static var paradoxGhost: ParadoxButtonStyle { .init(variant: .ghost) }

    /// Filled with status.error. Default haptic: medium.
    /// Typical use: destructive confirmations ("Delete", "Remove account").
    static var paradoxDestructive: ParadoxButtonStyle { .init(variant: .destructive) }

    /// Plain text colored with text.link. Default haptic: none.
    /// Typical use: inline hyperlinks ("Learn more", "Forgot password?").
    static var paradoxLink: ParadoxButtonStyle { .init(variant: .link) }
}
