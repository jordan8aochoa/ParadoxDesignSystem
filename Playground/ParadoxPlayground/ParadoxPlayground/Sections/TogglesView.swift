import SwiftUI
import ParadoxUI

struct TogglesView: View {
    @Environment(\.paradoxTheme) private var theme
    @State private var notifications = true
    @State private var darkMode = false
    @State private var sounds = true
    @State private var locked = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Standalone") {
                    HStack(spacing: theme.spacing.xl) {
                        VStack(spacing: theme.spacing.sm) {
                            ParadoxToggle(isOn: .constant(false))
                            Text("Off")
                                .paradoxText(theme.typography.caption)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                        VStack(spacing: theme.spacing.sm) {
                            ParadoxToggle(isOn: .constant(true))
                            Text("On")
                                .paradoxText(theme.typography.caption)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                        VStack(spacing: theme.spacing.sm) {
                            ParadoxToggle(isOn: .constant(false))
                                .disabled(true)
                            Text("Disabled off")
                                .paradoxText(theme.typography.caption)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                        VStack(spacing: theme.spacing.sm) {
                            ParadoxToggle(isOn: .constant(true))
                                .disabled(true)
                            Text("Disabled on")
                                .paradoxText(theme.typography.caption)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                section("Composed with labels") {
                    HStack {
                        Text("Push notifications")
                            .paradoxText(theme.typography.body)
                            .foregroundStyle(theme.color.text.primary)
                        Spacer()
                        ParadoxToggle(isOn: $notifications)
                    }
                    HStack {
                        Text("Dark mode")
                            .paradoxText(theme.typography.body)
                            .foregroundStyle(theme.color.text.primary)
                        Spacer()
                        ParadoxToggle(isOn: $darkMode)
                    }
                    HStack {
                        Text("Sounds")
                            .paradoxText(theme.typography.body)
                            .foregroundStyle(theme.color.text.primary)
                        Spacer()
                        ParadoxToggle(isOn: $sounds)
                    }
                }

                section("Inside ListItem (recap from Rows tab)") {
                    ParadoxListItem(
                        title: "Notifications",
                        leading: { ParadoxAccessory.icon("bell.fill") },
                        trailing: { ParadoxToggle(isOn: $notifications) }
                    )
                    ParadoxListItem(
                        title: "Account locked",
                        leading: { ParadoxAccessory.icon("lock.fill") },
                        trailing: { ParadoxToggle(isOn: $locked) }
                    )
                }

                Text("Tap any toggle — feel the light haptic. Reduce Motion in the toolbar disables the spring slide.")
                    .paradoxText(theme.typography.caption)
                    .foregroundStyle(theme.color.text.tertiary)
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
            VStack(spacing: theme.spacing.md) { content() }
                .padding(theme.spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.lg))
        }
    }
}
