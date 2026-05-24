import SwiftUI
import ParadoxUI

struct AvatarsView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Sizes (via .controlSize)") {
                    HStack(alignment: .bottom, spacing: theme.spacing.lg) {
                        labeled("mini · 24") {
                            ParadoxAvatar(url: nil, fallback: "JA")
                                .controlSize(.mini)
                        }
                        labeled("small · 32") {
                            ParadoxAvatar(url: nil, fallback: "JA")
                                .controlSize(.small)
                        }
                        labeled("regular · 40") {
                            ParadoxAvatar(url: nil, fallback: "JA")
                        }
                        labeled("large · 56") {
                            ParadoxAvatar(url: nil, fallback: "JA")
                                .controlSize(.large)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(theme.spacing.md)
                    .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
                }

                section("Hashed palette (initials → deterministic color)") {
                    let names = ["JA", "MS", "TK", "AB", "CD", "RB", "EH", "PL"]
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 56), spacing: theme.spacing.md)],
                              spacing: theme.spacing.md) {
                        ForEach(names, id: \.self) { initials in
                            VStack(spacing: 4) {
                                ParadoxAvatar(url: nil, fallback: initials)
                                    .controlSize(.large)
                                Text(initials)
                                    .paradoxText(theme.typography.micro)
                                    .foregroundStyle(theme.color.text.tertiary)
                            }
                        }
                    }
                    .padding(theme.spacing.md)
                    .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
                }

                section("Fallback when no initials provided") {
                    HStack(spacing: theme.spacing.lg) {
                        ParadoxAvatar(url: nil, fallback: nil).controlSize(.small)
                        ParadoxAvatar(url: nil, fallback: nil)
                        ParadoxAvatar(url: nil, fallback: nil).controlSize(.large)
                    }
                    .padding(theme.spacing.md)
                    .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
                }

                section("In a row (with the upgraded ListItem accessory)") {
                    VStack(spacing: 0) {
                        ParadoxListItem(
                            title: "Jordan Aguirre",
                            subtitle: "homeloansbyjordan@gmail.com",
                            leading: { ParadoxAccessory.avatar(nil, fallback: "JA") },
                            onTap: {}
                        )
                        ParadoxListItem(
                            title: "Maria Santos",
                            subtitle: "msantos@example.com",
                            leading: { ParadoxAccessory.avatar(nil, fallback: "MS") },
                            onTap: {}
                        )
                        ParadoxListItem(
                            title: "Taro Kobayashi",
                            subtitle: "taro@example.jp",
                            leading: { ParadoxAccessory.avatar(nil, fallback: "TK") },
                            onTap: {}
                        )
                    }
                    .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    @ViewBuilder
    private func labeled<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 4) {
            content()
            Text(label)
                .paradoxText(theme.typography.micro)
                .foregroundStyle(theme.color.text.tertiary)
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(title)
                .paradoxText(theme.typography.titleSmall)
                .foregroundStyle(theme.color.text.primary)
            content()
        }
    }
}
