import SwiftUI
import ParadoxUI

struct TypographyView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                row("display", theme.typography.display)
                row("titleLarge", theme.typography.titleLarge)
                row("titleMedium", theme.typography.titleMedium)
                row("titleSmall", theme.typography.titleSmall)
                row("headline", theme.typography.headline)
                row("bodyLarge", theme.typography.bodyLarge)
                row("body", theme.typography.body)
                row("bodySmall", theme.typography.bodySmall)
                row("label", theme.typography.label)
                row("caption", theme.typography.caption)
                row("micro", theme.typography.micro)
            }
            .padding(theme.spacing.lg)
        }
    }

    private func row(_ name: String, _ style: TextStyle) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text("Premium feels like trust.")
                .paradoxText(style)
                .foregroundStyle(theme.color.text.primary)
            Text("\(name) · \(Int(style.size))/\(Int(style.lineHeight))")
                .paradoxText(theme.typography.caption)
                .foregroundStyle(theme.color.text.tertiary)
        }
        .padding(theme.spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.md))
    }
}
