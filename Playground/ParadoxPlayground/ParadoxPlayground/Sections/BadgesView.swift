import SwiftUI
import ParadoxUI

struct BadgesView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Count") {
                    badgeRow {
                        ParadoxBadge(count: 1)
                        ParadoxBadge(count: 9)
                        ParadoxBadge(count: 12)
                        ParadoxBadge(count: 99)
                        ParadoxBadge(count: 247) // → 99+
                    }
                }

                section("Text labels") {
                    badgeRow {
                        ParadoxBadge("Pro")
                        ParadoxBadge("New", variant: .success)
                        ParadoxBadge("Beta", variant: .warning)
                        ParadoxBadge("Live", variant: .error)
                        ParadoxBadge("Draft", variant: .neutral)
                    }
                }

                section("Variants (count: 3)") {
                    badgeRow {
                        labeled("neutral")  { ParadoxBadge(count: 3, variant: .neutral) }
                        labeled("accent")   { ParadoxBadge(count: 3, variant: .accent) }
                        labeled("success")  { ParadoxBadge(count: 3, variant: .success) }
                        labeled("warning")  { ParadoxBadge(count: 3, variant: .warning) }
                        labeled("error")    { ParadoxBadge(count: 3, variant: .error) }
                    }
                }

                section("Attached as overlay") {
                    HStack(spacing: theme.spacing.xl) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(theme.color.text.primary)
                            .paradoxBadge(count: 12)

                        Image(systemName: "envelope.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(theme.color.text.primary)
                            .paradoxBadge(count: 99)

                        Image(systemName: "tray.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(theme.color.text.primary)
                            .paradoxBadge(count: 247)

                        ParadoxAvatar(url: nil, fallback: "JA")
                            .controlSize(.large)
                            .paradoxBadge("Pro")
                    }
                    .padding(.vertical, theme.spacing.md)
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    @ViewBuilder
    private func badgeRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: theme.spacing.md) { content() }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(theme.spacing.md)
            .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
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
