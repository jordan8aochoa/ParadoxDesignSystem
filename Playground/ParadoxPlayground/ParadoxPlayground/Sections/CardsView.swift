import SwiftUI
import ParadoxUI

struct CardsView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Padding tiers") {
                    ParadoxCard {
                        cardContent(title: "Compact", subtitle: "spacing.md (12pt)")
                    }
                    .paradoxCardPadding(.compact)

                    ParadoxCard {
                        cardContent(title: "Cozy (default)", subtitle: "spacing.lg (16pt)")
                    }

                    ParadoxCard {
                        cardContent(title: "Comfortable", subtitle: "spacing.xl (24pt)")
                    }
                    .paradoxCardPadding(.comfortable)
                }

                section("Elevation levels") {
                    ParadoxCard {
                        cardContent(title: "Level 0 — default, no shadow")
                    }
                    ParadoxCard {
                        cardContent(title: "Level 1 — subtle lift")
                    }
                    .paradoxCardElevation(.level1)

                    ParadoxCard {
                        cardContent(title: "Level 2 — clearly floating")
                    }
                    .paradoxCardElevation(.level2)

                    ParadoxCard {
                        cardContent(title: "Level 3 — modal-like")
                    }
                    .paradoxCardElevation(.level3)

                    ParadoxCard {
                        cardContent(title: "Level 4 — hero")
                    }
                    .paradoxCardElevation(.level4)
                }

                section("Real-world example") {
                    ParadoxCard {
                        VStack(alignment: .leading, spacing: theme.spacing.sm) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundStyle(theme.color.accent.primary)
                                Text("Subscription")
                                    .paradoxText(theme.typography.label)
                                    .foregroundStyle(theme.color.text.secondary)
                                Spacer()
                                Text("$9.99")
                                    .paradoxText(theme.typography.label)
                                    .foregroundStyle(theme.color.text.secondary)
                            }
                            Text("Pro plan, monthly")
                                .paradoxText(theme.typography.titleMedium)
                                .foregroundStyle(theme.color.text.primary)
                            Text("Renews May 30. Cancel anytime.")
                                .paradoxText(theme.typography.bodySmall)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                    }
                    .paradoxCardElevation(.level1)
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    private func cardContent(title: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .paradoxText(theme.typography.body)
                .foregroundStyle(theme.color.text.primary)
            if let subtitle {
                Text(subtitle)
                    .paradoxText(theme.typography.caption)
                    .foregroundStyle(theme.color.text.tertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(title)
                .paradoxText(theme.typography.titleSmall)
                .foregroundStyle(theme.color.text.primary)
            VStack(spacing: theme.spacing.md) { content() }
        }
    }
}
