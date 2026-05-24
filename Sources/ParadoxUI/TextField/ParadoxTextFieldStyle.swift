import SwiftUI
import ParadoxTokens

/// Paradox-styled visual treatment for `TextField`, `SecureField`, and `TextEditor`.
/// Apply via the `.paradoxTextFieldStyle()` modifier on any of those.
///
/// Default visual: `surface.secondary` fill, no border at rest, 2pt `border.focus`
/// ring on focus. When a `paradoxFieldMessage(.error(...))` is attached, the focus
/// ring (and rest border) flip to `status.error`.
///
/// ```swift
/// TextField("Email", text: $email)
///     .paradoxTextFieldStyle()
///     .paradoxFieldMessage(email.isEmpty ? .error("Required") : nil)
/// ```
public struct ParadoxTextFieldStyleModifier: ViewModifier {
    @Environment(\.paradoxTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.paradoxFieldMessage) private var message
    @FocusState private var isFocused: Bool

    public func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .paradoxText(theme.typography.body)
            .foregroundStyle(theme.color.text.primary)
            .tint(theme.color.accent.primary)
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .frame(minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                    .fill(theme.color.surface.secondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.md, style: .continuous)
                    .strokeBorder(strokeColor, lineWidth: strokeWidth)
            )
            .animation(theme.motion.spring.snappy, value: isFocused)
            .animation(theme.motion.spring.snappy, value: hasError)
            .opacity(isEnabled ? 1.0 : 0.5)
    }

    private var hasError: Bool {
        message?.kind == .error
    }

    private var strokeColor: Color {
        if hasError { return theme.color.status.error }
        if isFocused { return theme.color.border.focus }
        return .clear
    }

    private var strokeWidth: CGFloat {
        (isFocused || hasError) ? 2 : 0
    }
}

public extension View {
    /// Apply the Paradox visual treatment to a text input.
    /// Works on `TextField`, `SecureField`, and `TextEditor`.
    func paradoxTextFieldStyle() -> some View {
        modifier(ParadoxTextFieldStyleModifier())
    }
}
