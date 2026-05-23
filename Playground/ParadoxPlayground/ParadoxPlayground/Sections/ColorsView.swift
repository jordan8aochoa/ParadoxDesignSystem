import SwiftUI
import ParadoxUI

struct ColorsView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                group("Background") {
                    swatch("primary", theme.color.background.primary)
                    swatch("secondary", theme.color.background.secondary)
                    swatch("tertiary", theme.color.background.tertiary)
                    swatch("elevated", theme.color.background.elevated)
                }
                group("Surface") {
                    swatch("primary", theme.color.surface.primary)
                    swatch("secondary", theme.color.surface.secondary)
                    swatch("raised", theme.color.surface.raised)
                    swatch("overlay", theme.color.surface.overlay)
                }
                group("Text") {
                    swatch("primary", theme.color.text.primary)
                    swatch("secondary", theme.color.text.secondary)
                    swatch("tertiary", theme.color.text.tertiary)
                    swatch("inverse", theme.color.text.inverse)
                    swatch("link", theme.color.text.link)
                    swatch("disabled", theme.color.text.disabled)
                }
                group("Border") {
                    swatch("subtle", theme.color.border.subtle)
                    swatch("default", theme.color.border.default)
                    swatch("strong", theme.color.border.strong)
                    swatch("focus", theme.color.border.focus)
                }
                group("Status") {
                    swatch("success", theme.color.status.success)
                    swatch("warning", theme.color.status.warning)
                    swatch("error", theme.color.status.error)
                    swatch("info", theme.color.status.info)
                }
                group("Accent") {
                    swatch("primary", theme.color.accent.primary)
                    swatch("primaryPressed", theme.color.accent.primaryPressed)
                    swatch("primarySubtle", theme.color.accent.primarySubtle)
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    @ViewBuilder
    private func group<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text(title)
                .paradoxText(theme.typography.titleSmall)
                .foregroundStyle(theme.color.text.primary)
            VStack(spacing: theme.spacing.xs) { content() }
        }
    }

    private func swatch(_ name: String, _ color: Color) -> some View {
        HStack(spacing: theme.spacing.md) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .overlay(RoundedRectangle(cornerRadius: theme.radius.sm)
                    .strokeBorder(theme.color.border.subtle, lineWidth: 1))
                .frame(width: 56, height: 56)
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .paradoxText(theme.typography.body)
                    .foregroundStyle(theme.color.text.primary)
                Text("color")
                    .paradoxText(theme.typography.caption)
                    .foregroundStyle(theme.color.text.tertiary)
            }
            Spacer()
        }
        .padding(theme.spacing.sm)
        .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.md))
    }
}
