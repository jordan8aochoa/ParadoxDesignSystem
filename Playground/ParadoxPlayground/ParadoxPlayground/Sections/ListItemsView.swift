import SwiftUI
import ParadoxUI

struct ListItemsView: View {
    @Environment(\.paradoxTheme) private var theme
    @State private var notifications = true
    @State private var darkMode = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Basic") {
                    VStack(spacing: 0) {
                        ParadoxListItem(title: "Title only")
                        divider
                        ParadoxListItem(title: "Title", subtitle: "With a subtitle line")
                    }
                }

                section("With leading accessories") {
                    VStack(spacing: 0) {
                        ParadoxListItem(
                            title: "Notifications",
                            subtitle: "12 unread",
                            leading: { ParadoxAccessory.icon("bell.fill") }
                        )
                        divider
                        ParadoxListItem(
                            title: "Jordan Aguirre",
                            subtitle: "homeloansbyjordan@gmail.com",
                            leading: { ParadoxAccessory.avatar(nil, fallback: "JA") }
                        )
                    }
                }

                section("With trailing accessories") {
                    VStack(spacing: 0) {
                        ParadoxListItem(
                            title: "Open Settings",
                            leading: { ParadoxAccessory.icon("gearshape.fill") },
                            onTap: {}
                        )
                        divider
                        ParadoxListItem(
                            title: "Subscription",
                            subtitle: "Renews May 30",
                            leading: { ParadoxAccessory.icon("creditcard.fill") },
                            trailing: { ParadoxAccessory.value("$9.99/mo") }
                        )
                        divider
                        ParadoxListItem(
                            title: "Push notifications",
                            leading: { ParadoxAccessory.icon("bell.badge.fill") },
                            trailing: { ParadoxAccessory.toggle($notifications) }
                        )
                        divider
                        ParadoxListItem(
                            title: "Dark mode",
                            leading: { ParadoxAccessory.icon("moon.fill") },
                            trailing: { ParadoxAccessory.toggle($darkMode) }
                        )
                    }
                }

                section("Inside a native List") {
                    Text("Get free swipe actions, edit mode, dividers")
                        .paradoxText(theme.typography.caption)
                        .foregroundStyle(theme.color.text.tertiary)
                    List {
                        ParadoxListItem(
                            title: "Inbox",
                            subtitle: "3 unread",
                            leading: { ParadoxAccessory.icon("tray.fill") },
                            onTap: {}
                        )
                        ParadoxListItem(
                            title: "Sent",
                            leading: { ParadoxAccessory.icon("paperplane.fill") },
                            onTap: {}
                        )
                    }
                    .listStyle(.plain)
                    .frame(height: 160)
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(theme.color.border.subtle)
            .frame(height: 1)
            .padding(.leading, theme.spacing.lg)
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(title)
                .paradoxText(theme.typography.titleSmall)
                .foregroundStyle(theme.color.text.primary)
            VStack(alignment: .leading, spacing: theme.spacing.sm) { content() }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, theme.spacing.md)
        .padding(.horizontal, 0)
        .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}
