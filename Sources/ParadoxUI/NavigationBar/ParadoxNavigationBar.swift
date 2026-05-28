import SwiftUI
import ParadoxTokens

/// A premium top bar with a title (and optional subtitle), plus leading and
/// trailing `@ViewBuilder` accessory slots. Sits at the top of a screen above
/// the content scroll view.
///
/// Two display styles:
/// - `.compact` (default) — 44pt height, centered title
/// - `.large` — large title that lives below a 44pt chrome row
///
/// ```swift
/// ParadoxNavigationBar(
///     title: "Inbox",
///     subtitle: "12 unread",
///     leading: { Button("Cancel") {} .buttonStyle(.paradoxLink) },
///     trailing: { Image(systemName: "square.and.pencil") }
/// )
/// ```
public struct ParadoxNavigationBar<Leading: View, Trailing: View>: View {
    public enum Style: Sendable, Hashable, CaseIterable {
        case compact, large
    }

    private let title: String
    private let subtitle: String?
    private let style: Style
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String,
        subtitle: String? = nil,
        style: Style = .compact,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading()
        self.trailing = trailing()
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            chromeRow
            if style == .large {
                largeTitle
            }
        }
        .background(theme.color.background.primary)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(theme.color.border.subtle)
                .frame(height: 0.5)
        }
        .accessibilityElement(children: .contain)
    }

    private var chromeRow: some View {
        ZStack {
            if style == .compact {
                compactTitleBlock
                    .accessibilityAddTraits(.isHeader)
            }
            HStack(spacing: theme.spacing.sm) {
                leading
                    .frame(minWidth: 44, minHeight: 44, alignment: .leading)
                Spacer(minLength: 0)
                trailing
                    .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
            }
        }
        .padding(.horizontal, theme.spacing.lg)
        .frame(height: 44)
    }

    private var compactTitleBlock: some View {
        VStack(spacing: 0) {
            Text(title)
                .paradoxText(theme.typography.headline)
                .foregroundStyle(theme.color.text.primary)
                .lineLimit(1)
            if let subtitle {
                Text(subtitle)
                    .paradoxText(theme.typography.caption)
                    .foregroundStyle(theme.color.text.secondary)
                    .lineLimit(1)
            }
        }
    }

    private var largeTitle: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .paradoxText(theme.typography.display)
                .foregroundStyle(theme.color.text.primary)
                .accessibilityAddTraits(.isHeader)
            if let subtitle {
                Text(subtitle)
                    .paradoxText(theme.typography.bodySmall)
                    .foregroundStyle(theme.color.text.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, theme.spacing.lg)
        .padding(.top, theme.spacing.sm)
        .padding(.bottom, theme.spacing.md)
    }
}
