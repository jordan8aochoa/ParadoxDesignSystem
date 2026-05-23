import SwiftUI
import ParadoxUI

struct ButtonsView: View {
    @Environment(\.paradoxTheme) private var theme
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Variants") {
                    Button("Primary") {}.buttonStyle(.paradoxPrimary)
                    Button("Secondary") {}.buttonStyle(.paradoxSecondary)
                    Button("Tertiary") {}.buttonStyle(.paradoxTertiary)
                    Button("Ghost") {}.buttonStyle(.paradoxGhost)
                    Button("Destructive") {}.buttonStyle(.paradoxDestructive)
                    Button("Link") {}.buttonStyle(.paradoxLink)
                }

                section("Sizes") {
                    Button("Mini") {}.buttonStyle(.paradoxPrimary).controlSize(.mini)
                    Button("Small") {}.buttonStyle(.paradoxPrimary).controlSize(.small)
                    Button("Regular") {}.buttonStyle(.paradoxPrimary).controlSize(.regular)
                    Button("Large") {}.buttonStyle(.paradoxPrimary).controlSize(.large)
                }

                section("States") {
                    Button("Enabled") {}.buttonStyle(.paradoxPrimary)
                    Button("Disabled") {}.buttonStyle(.paradoxPrimary).disabled(true)
                    Button("Loading") { isLoading.toggle() }
                        .buttonStyle(.paradoxPrimary)
                        .paradoxLoading(isLoading)
                    Text("Tap above to toggle loading")
                        .paradoxText(theme.typography.caption)
                        .foregroundStyle(theme.color.text.tertiary)
                }

                section("With icons") {
                    ParadoxButton("Save", systemImage: "checkmark", action: {})
                        .buttonStyle(.paradoxPrimary)
                    ParadoxButton("Add", systemImage: "plus", action: {})
                        .buttonStyle(.paradoxSecondary)
                    HStack(spacing: theme.spacing.md) {
                        ParadoxButton(systemImage: "heart", action: {})
                            .buttonStyle(.paradoxGhost)
                        ParadoxButton(systemImage: "square.and.arrow.up", action: {})
                            .buttonStyle(.paradoxGhost)
                        ParadoxButton(systemImage: "trash", action: {})
                            .buttonStyle(.paradoxDestructive)
                    }
                }

                section("Haptics") {
                    Text("Tap each to feel the difference")
                        .paradoxText(theme.typography.caption)
                        .foregroundStyle(theme.color.text.tertiary)
                    Button("Primary · light (default)") {}
                        .buttonStyle(.paradoxPrimary)
                    Button("Destructive · medium (default)") {}
                        .buttonStyle(.paradoxDestructive)
                    Button("Primary · heavy (override)") {}
                        .buttonStyle(.paradoxPrimary)
                        .paradoxHaptic(.heavy)
                    Button("Primary · suppressed") {}
                        .buttonStyle(.paradoxPrimary)
                        .paradoxHaptic(.none)
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(title)
                .paradoxText(theme.typography.titleSmall)
                .foregroundStyle(theme.color.text.primary)
            VStack(alignment: .leading, spacing: theme.spacing.sm) { content() }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(theme.spacing.lg)
        .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}
