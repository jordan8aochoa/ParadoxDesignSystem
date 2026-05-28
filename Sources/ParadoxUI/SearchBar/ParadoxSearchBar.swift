import SwiftUI
import ParadoxTokens

/// A premium search input. Magnifier icon leads, clear (✕) trails when there's
/// text, and an optional "Cancel" button slides in alongside the field while
/// focused.
///
/// ```swift
/// @State var query: String = ""
/// ParadoxSearchBar(text: $query, placeholder: "Search messages")
/// ```
///
/// Show a Cancel button when focused:
///
/// ```swift
/// ParadoxSearchBar(text: $query, placeholder: "Search", showsCancel: true) {
///     // optional onCancel: clear text, dismiss keyboard
/// }
/// ```
public struct ParadoxSearchBar: View {
    @Binding private var text: String
    private let placeholder: String
    private let showsCancel: Bool
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        showsCancel: Bool = false,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showsCancel = showsCancel
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    @Environment(\.paradoxTheme) private var theme
    @FocusState private var isFocused: Bool

    public var body: some View {
        HStack(spacing: theme.spacing.sm) {
            field
            if showsCancel && isFocused {
                cancelButton
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(theme.motion.spring.snappy, value: isFocused)
    }

    private var field: some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.color.text.tertiary)
                .accessibilityHidden(true)

            TextField(placeholder, text: $text)
                .paradoxText(theme.typography.body)
                .foregroundStyle(theme.color.text.primary)
                .tint(theme.color.accent.primary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.search)
                .focused($isFocused)
                .onSubmit { onSubmit?() }
                .accessibilityLabel(placeholder)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(theme.color.text.tertiary)
                }
                .buttonStyle(.plain)
                .transition(.opacity)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .frame(height: 36)
        .background(
            RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous)
                .fill(theme.color.surface.secondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous)
                .strokeBorder(isFocused ? theme.color.border.focus : .clear,
                              lineWidth: isFocused ? 2 : 0)
        )
        .animation(theme.motion.spring.snappy, value: text.isEmpty)
    }

    private var cancelButton: some View {
        Button {
            text = ""
            isFocused = false
            onCancel?()
        } label: {
            Text("Cancel")
                .paradoxText(theme.typography.body)
                .foregroundStyle(theme.color.accent.primary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Cancel search")
    }
}
