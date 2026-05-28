import SwiftUI
import ParadoxTokens

/// A bottom tab bar with up to 5 items. Each item has an SF Symbol, a label,
/// and an optional badge count. Selection is driven by a binding so the host
/// owns navigation state.
///
/// ```swift
/// @State var tab: Tab = .home
/// ParadoxTabBar(selection: $tab, items: [
///     .init(tag: .home,    systemImage: "house.fill",    title: "Home"),
///     .init(tag: .search,  systemImage: "magnifyingglass", title: "Search"),
///     .init(tag: .inbox,   systemImage: "tray.fill",     title: "Inbox", badge: 12),
///     .init(tag: .profile, systemImage: "person.fill",   title: "Me"),
/// ])
/// ```
public struct ParadoxTabBar<Tag: Hashable & Sendable>: View {

    public struct Item: Identifiable, Sendable {
        public let id: Tag
        public let tag: Tag
        public let systemImage: String
        public let title: String
        public let badge: Int?

        public init(tag: Tag, systemImage: String, title: String, badge: Int? = nil) {
            self.id = tag
            self.tag = tag
            self.systemImage = systemImage
            self.title = title
            self.badge = badge
        }
    }

    @Binding private var selection: Tag
    private let items: [Item]

    public init(selection: Binding<Tag>, items: [Item]) {
        self._selection = selection
        self.items = items
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button {
                    if selection != item.tag {
                        selection = item.tag
                    }
                } label: {
                    ParadoxTabBarItemView(item: item, isSelected: selection == item.tag)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == item.tag ? [.isSelected, .isButton] : .isButton)
            }
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.top, theme.spacing.sm)
        .padding(.bottom, theme.spacing.xs)
        .background(theme.color.background.elevated)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(theme.color.border.subtle)
                .frame(height: 0.5)
        }
        .animation(theme.motion.spring.snappy, value: selection)
    }
}

private struct ParadoxTabBarItemView<Tag: Hashable & Sendable>: View {
    let item: ParadoxTabBar<Tag>.Item
    let isSelected: Bool

    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(foreground)
                    .frame(width: 28, height: 28)
                    .symbolEffect(.bounce, value: isSelected)

                if let badge = item.badge, badge > 0 {
                    ParadoxBadge(count: badge)
                        .offset(x: 10, y: -6)
                }
            }
            Text(item.title)
                .paradoxText(theme.typography.micro)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(foreground)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.spacing.xs)
        .contentShape(Rectangle())
        .accessibilityLabel(accessibilityLabel)
    }

    private var foreground: Color {
        isSelected ? theme.color.accent.primary : theme.color.text.secondary
    }

    private var accessibilityLabel: String {
        if let badge = item.badge, badge > 0 {
            return "\(item.title), \(badge) \(badge == 1 ? "item" : "items")"
        }
        return item.title
    }
}
