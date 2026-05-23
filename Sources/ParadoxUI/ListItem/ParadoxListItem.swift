import SwiftUI
import ParadoxTokens

/// A premium row component that works in `List`, `ScrollView`, or plain `VStack`.
///
/// Provides leading/trailing accessory slots as `@ViewBuilder` content. When
/// `onTap` is set and the trailing slot is `EmptyView`, a chevron renders
/// automatically — pass `trailing: { EmptyView() }` to suppress.
///
/// Example:
/// ```swift
/// ParadoxListItem(
///     title: "Notifications",
///     subtitle: "12 unread",
///     leading: { ParadoxAccessory.icon("bell.fill") },
///     onTap: { open() }
/// )
/// ```
public struct ParadoxListItem<Leading: View, Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let leading: Leading
    private let trailing: Trailing
    private let onTap: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading()
        self.trailing = trailing()
        self.onTap = onTap
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        if let onTap {
            Button(action: onTap) { row }
                .buttonStyle(ParadoxListItemPressable())
        } else {
            row
        }
    }

    private var row: some View {
        HStack(spacing: theme.spacing.md) {
            if Leading.self != EmptyView.self {
                leading.frame(width: 44, height: 44)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .paradoxText(theme.typography.body)
                    .foregroundStyle(theme.color.text.primary)
                if let subtitle {
                    Text(subtitle)
                        .paradoxText(theme.typography.bodySmall)
                        .foregroundStyle(theme.color.text.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if Trailing.self != EmptyView.self {
                trailing.frame(minHeight: 44)
            } else if onTap != nil {
                ParadoxAccessory.chevron.frame(minHeight: 44)
            }
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.md)
        .frame(minHeight: 44)
        .contentShape(Rectangle())
    }
}
