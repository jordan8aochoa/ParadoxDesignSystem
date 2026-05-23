import SwiftUI
import ParadoxUI

struct MotionView: View {
    @Environment(\.paradoxTheme) private var theme
    @Environment(\.playgroundReduceMotion) private var reduceMotion
    @State private var pulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text(reduceMotion ? "Reduce Motion is ON — animations are suppressed."
                                  : "Tap a row to trigger its spring.")
                    .paradoxText(theme.typography.bodySmall)
                    .foregroundStyle(theme.color.text.secondary)

                row("snappy", theme.motion.spring.snappy)
                row("gentle", theme.motion.spring.gentle)
                row("bouncy", theme.motion.spring.bouncy)

                Text("Durations")
                    .paradoxText(theme.typography.titleSmall)
                    .foregroundStyle(theme.color.text.primary)
                    .padding(.top, theme.spacing.md)

                durationRow("fast", theme.motion.duration.fast)
                durationRow("standard", theme.motion.duration.standard)
                durationRow("slow", theme.motion.duration.slow)
            }
            .padding(theme.spacing.lg)
        }
    }

    private func row(_ name: String, _ animation: Animation) -> some View {
        Button {
            withAnimation(theme.motion.resolve(animation, reduceMotion: reduceMotion)) {
                pulse.toggle()
            }
        } label: {
            HStack {
                Text(name)
                    .paradoxText(theme.typography.body)
                    .foregroundStyle(theme.color.text.primary)
                Spacer()
                Circle()
                    .fill(theme.color.accent.primary)
                    .frame(width: 28, height: 28)
                    .scaleEffect(pulse ? 1.6 : 1.0)
            }
            .padding(theme.spacing.md)
            .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.md))
        }
        .buttonStyle(.plain)
    }

    private func durationRow(_ name: String, _ seconds: Double) -> some View {
        HStack {
            Text(name)
                .paradoxText(theme.typography.body)
                .foregroundStyle(theme.color.text.primary)
            Spacer()
            Text("\(Int(seconds * 1000)) ms")
                .paradoxText(theme.typography.caption)
                .foregroundStyle(theme.color.text.tertiary)
        }
        .padding(theme.spacing.md)
        .background(theme.color.surface.raised, in: RoundedRectangle(cornerRadius: theme.radius.md))
    }
}
