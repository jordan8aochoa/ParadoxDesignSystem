import SwiftUI
import ParadoxUI

struct SpacingView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                ForEach(theme.spacing.allValues, id: \.name) { item in
                    HStack(spacing: theme.spacing.md) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .paradoxText(theme.typography.body)
                                .foregroundStyle(theme.color.text.primary)
                            Text("\(Int(item.value)) pt")
                                .paradoxText(theme.typography.caption)
                                .foregroundStyle(theme.color.text.tertiary)
                        }
                        .frame(width: 80, alignment: .leading)

                        RoundedRectangle(cornerRadius: theme.radius.xs)
                            .fill(theme.color.accent.primary)
                            .frame(width: item.value, height: 24)

                        Spacer()
                    }
                    .padding(theme.spacing.sm)
                    .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.md))
                }
            }
            .padding(theme.spacing.lg)
        }
    }
}
