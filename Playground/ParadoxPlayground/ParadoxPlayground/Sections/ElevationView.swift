import SwiftUI
import ParadoxUI

struct ElevationView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                ForEach(theme.elevation.allValues, id: \.name) { item in
                    VStack(spacing: theme.spacing.sm) {
                        RoundedRectangle(cornerRadius: theme.radius.lg)
                            .fill(theme.color.surface.raised)
                            .frame(height: 96)
                            .paradoxShadow(item.value)
                        Text("\(item.name) · radius \(Int(item.value.radius))")
                            .paradoxText(theme.typography.caption)
                            .foregroundStyle(theme.color.text.tertiary)
                    }
                }
            }
            .padding(theme.spacing.xl)
        }
    }
}
