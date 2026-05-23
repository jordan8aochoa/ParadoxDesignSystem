import SwiftUI
import ParadoxUI

struct RadiusView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: theme.spacing.md)], spacing: theme.spacing.md) {
                ForEach(theme.radius.allValues, id: \.name) { item in
                    VStack(spacing: theme.spacing.sm) {
                        RoundedRectangle(cornerRadius: clamped(item.value))
                            .fill(theme.color.accent.primarySubtle)
                            .overlay(RoundedRectangle(cornerRadius: clamped(item.value))
                                .strokeBorder(theme.color.border.subtle, lineWidth: 1))
                            .frame(height: 80)
                        VStack(spacing: 2) {
                            Text(item.name)
                                .paradoxText(theme.typography.label)
                                .foregroundStyle(theme.color.text.primary)
                            Text(item.value == .infinity ? "pill" : "\(Int(item.value)) pt")
                                .paradoxText(theme.typography.caption)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                    }
                    .padding(theme.spacing.sm)
                    .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.md))
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    private func clamped(_ r: CGFloat) -> CGFloat {
        r == .infinity ? 40 : r
    }
}
