import SwiftUI
import ParadoxTokens

/// Common trailing/leading accessories for `ParadoxListItem`. Each helper returns
/// a themed view ready to drop into the slot.
public enum ParadoxAccessory {
    /// Right-pointing chevron used to indicate navigation. Auto-rendered when
    /// `ParadoxListItem` has an `onTap` and no explicit trailing slot.
    public static var chevron: some View {
        ParadoxChevronAccessory()
    }

    /// SF Symbol icon. `tint` defaults to `text.secondary`; pass an accent for emphasis.
    public static func icon(_ systemName: String, tint: Color? = nil) -> some View {
        ParadoxIconAccessory(systemName: systemName, tint: tint)
    }

    /// Native SwiftUI toggle, tinted with `accent.primary`. Use this when the row
    /// represents a boolean setting.
    public static func toggle(_ binding: Binding<Bool>) -> some View {
        ParadoxToggleAccessory(isOn: binding)
    }

    /// Right-aligned static value text (e.g., "$24.99", "Off", "12 unread").
    public static func value(_ text: String) -> some View {
        ParadoxValueAccessory(text: text)
    }

    /// Circular avatar from a URL with optional initials fallback.
    public static func avatar(_ url: URL?, fallback: String? = nil) -> some View {
        ParadoxAvatarAccessory(url: url, fallback: fallback)
    }
}

// MARK: - Internal accessory views

private struct ParadoxChevronAccessory: View {
    @Environment(\.paradoxTheme) private var theme
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(theme.color.text.tertiary)
            .accessibilityHidden(true)
    }
}

private struct ParadoxIconAccessory: View {
    let systemName: String
    let tint: Color?
    @Environment(\.paradoxTheme) private var theme
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(tint ?? theme.color.text.secondary)
    }
}

private struct ParadoxToggleAccessory: View {
    @Binding var isOn: Bool
    @Environment(\.paradoxTheme) private var theme
    var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .tint(theme.color.accent.primary)
    }
}

private struct ParadoxValueAccessory: View {
    let text: String
    @Environment(\.paradoxTheme) private var theme
    var body: some View {
        Text(text)
            .paradoxText(theme.typography.body)
            .foregroundStyle(theme.color.text.secondary)
    }
}

private struct ParadoxAvatarAccessory: View {
    let url: URL?
    let fallback: String?

    var body: some View {
        // Defer to the standalone ParadoxAvatar component so the inline-row
        // avatar inherits the hashed palette + size scale automatically.
        ParadoxAvatar(url: url, fallback: fallback)
            .controlSize(.small)
    }
}
