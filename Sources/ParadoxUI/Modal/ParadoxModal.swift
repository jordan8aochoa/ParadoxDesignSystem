import SwiftUI
import ParadoxTokens

/// A premium modal container designed to live inside a SwiftUI `.sheet(isPresented:)`.
/// Provides a title (and optional subtitle), a content slot, and an action area
/// at the bottom (primary + optional secondary). Honors safe areas.
///
/// ```swift
/// .sheet(isPresented: $showSettings) {
///     ParadoxModal(
///         title: "Delete account",
///         subtitle: "This action can't be undone.",
///         primaryAction: .init(title: "Delete", role: .destructive) { confirm() },
///         secondaryAction: .init(title: "Cancel") { showSettings = false }
///     ) {
///         Text("All your data will be permanently removed from our servers.")
///             .paradoxText(theme.typography.body)
///     }
/// }
/// ```
public struct ParadoxModal<Content: View>: View {

    public struct Action: Sendable {
        public enum Role: Sendable, Hashable, CaseIterable {
            case primary, secondary, destructive
        }

        public let title: String
        public let role: Role
        public let handler: @MainActor () -> Void

        public init(title: String, role: Role = .primary, handler: @escaping @MainActor () -> Void) {
            self.title = title
            self.role = role
            self.handler = handler
        }
    }

    private let title: String
    private let subtitle: String?
    private let primaryAction: Action?
    private let secondaryAction: Action?
    private let content: Content

    public init(
        title: String,
        subtitle: String? = nil,
        primaryAction: Action? = nil,
        secondaryAction: Action? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.content = content()
    }

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, theme.spacing.lg)
                    .padding(.vertical, theme.spacing.md)
            }
            if primaryAction != nil || secondaryAction != nil {
                actionRow
            }
        }
        .background(theme.color.background.elevated)
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .paradoxText(theme.typography.titleMedium)
                    .foregroundStyle(theme.color.text.primary)
                    .accessibilityAddTraits(.isHeader)
                if let subtitle {
                    Text(subtitle)
                        .paradoxText(theme.typography.bodySmall)
                        .foregroundStyle(theme.color.text.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(theme.color.text.tertiary)
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close")
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.top, theme.spacing.lg)
        .padding(.bottom, theme.spacing.md)
    }

    private var actionRow: some View {
        HStack(spacing: theme.spacing.sm) {
            if let secondaryAction {
                Button(secondaryAction.title, action: secondaryAction.handler)
                    .buttonStyle(.paradoxSecondary)
                    .frame(maxWidth: .infinity)
            }
            if let primaryAction {
                Button(primaryAction.title, action: primaryAction.handler)
                    .buttonStyle(primaryAction.role == .destructive
                                 ? .paradoxDestructive
                                 : .paradoxPrimary)
                    .frame(maxWidth: .infinity)
            }
        }
        .controlSize(.large)
        .padding(.horizontal, theme.spacing.lg)
        .padding(.top, theme.spacing.md)
        .padding(.bottom, theme.spacing.lg)
        .background(
            Rectangle()
                .fill(theme.color.border.subtle)
                .frame(height: 0.5)
                .frame(maxHeight: .infinity, alignment: .top)
        )
    }
}
