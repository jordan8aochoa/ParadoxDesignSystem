import SwiftUI
import ParadoxTokens

/// The Paradox button style. Six variants, sizing via `.controlSize`, theme-driven
/// colors, reduce-motion-aware press animation, opt-out haptics, and a built-in
/// loading state (swap label → spinner, no width jump).
///
/// Prefer the static extensions on `ButtonStyle` (`.paradoxPrimary`, etc.).
public struct ParadoxButtonStyle: ButtonStyle {
    public enum Variant: Sendable, Hashable, CaseIterable {
        case primary, secondary, tertiary, ghost, destructive, link

        var defaultHaptic: ParadoxHaptic {
            switch self {
            case .primary, .secondary: return .light
            case .destructive:         return .medium
            case .tertiary, .ghost, .link: return .none
            }
        }
    }

    public let variant: Variant

    public init(variant: Variant) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        ParadoxButtonBody(variant: variant, configuration: configuration)
    }
}

// MARK: - Body

private struct ParadoxButtonBody: View {
    let variant: ParadoxButtonStyle.Variant
    let configuration: ButtonStyle.Configuration

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.controlSize) private var controlSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.paradoxIsLoading) private var isLoading
    @Environment(\.paradoxHaptic) private var hapticOverride

    @State private var pressCount: Int = 0

    var body: some View {
        let metrics = sizeMetrics(for: controlSize, theme: theme)
        let colors  = variantColors(for: variant, theme: theme, isPressed: configuration.isPressed)

        configuration.label
            .paradoxText(metrics.textStyle)
            .foregroundStyle(colors.foreground)
            .opacity(isLoading ? 0 : 1)
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .tint(colors.foreground)
                }
            }
            .padding(.horizontal, metrics.horizontalPadding)
            .frame(minHeight: metrics.height)
            .background {
                if let bg = colors.background {
                    RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous)
                        .fill(bg)
                }
            }
            .overlay {
                if let stroke = colors.stroke {
                    RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous)
                        .strokeBorder(stroke, lineWidth: 1)
                }
            }
            .opacity(buttonOpacity)
            .animation(theme.motion.spring.snappy, value: configuration.isPressed)
            .sensoryFeedback(trigger: pressCount) { _, _ in
                effectiveHaptic.feedback
            }
            .onChange(of: configuration.isPressed) { _, newValue in
                if newValue { pressCount &+= 1 }
            }
    }

    private var buttonOpacity: Double {
        if !isEnabled { return 0.4 }
        if configuration.isPressed && !variant.isFilled { return 0.6 }
        return 1.0
    }

    private var effectiveHaptic: ParadoxHaptic {
        hapticOverride ?? variant.defaultHaptic
    }
}

// MARK: - Helpers

private struct SizeMetrics {
    let height: CGFloat
    let horizontalPadding: CGFloat
    let cornerRadius: CGFloat
    let textStyle: TextStyle
}

private func sizeMetrics(for controlSize: ControlSize, theme: any ParadoxTheme) -> SizeMetrics {
    switch controlSize {
    case .mini:
        return SizeMetrics(height: 24, horizontalPadding: theme.spacing.sm,
                           cornerRadius: theme.radius.sm, textStyle: theme.typography.caption)
    case .small:
        return SizeMetrics(height: 32, horizontalPadding: theme.spacing.md,
                           cornerRadius: theme.radius.md, textStyle: theme.typography.label)
    case .regular:
        return SizeMetrics(height: 44, horizontalPadding: theme.spacing.lg,
                           cornerRadius: theme.radius.md, textStyle: theme.typography.body)
    case .large, .extraLarge:
        return SizeMetrics(height: 52, horizontalPadding: theme.spacing.xl,
                           cornerRadius: theme.radius.lg, textStyle: theme.typography.headline)
    @unknown default:
        return SizeMetrics(height: 44, horizontalPadding: theme.spacing.lg,
                           cornerRadius: theme.radius.md, textStyle: theme.typography.body)
    }
}

private struct VariantColors {
    let background: Color?
    let foreground: Color
    let stroke: Color?
}

private func variantColors(for variant: ParadoxButtonStyle.Variant,
                           theme: any ParadoxTheme,
                           isPressed: Bool) -> VariantColors {
    switch variant {
    case .primary:
        return VariantColors(
            background: isPressed ? theme.color.accent.primaryPressed : theme.color.accent.primary,
            foreground: theme.color.text.inverse,
            stroke: nil)
    case .secondary:
        return VariantColors(
            background: theme.color.surface.secondary,
            foreground: theme.color.text.primary,
            stroke: nil)
    case .tertiary:
        return VariantColors(
            background: nil,
            foreground: theme.color.text.primary,
            stroke: nil)
    case .ghost:
        return VariantColors(
            background: nil,
            foreground: theme.color.text.primary,
            stroke: theme.color.border.default)
    case .destructive:
        return VariantColors(
            background: theme.color.status.error.opacity(isPressed ? 0.85 : 1.0),
            foreground: theme.color.text.inverse,
            stroke: nil)
    case .link:
        return VariantColors(
            background: nil,
            foreground: theme.color.text.link,
            stroke: nil)
    }
}

private extension ParadoxButtonStyle.Variant {
    var isFilled: Bool { self == .primary || self == .destructive }
}

private extension ParadoxHaptic {
    /// Converts to SwiftUI's `SensoryFeedback`. Returns `nil` for `.none` so the
    /// `.sensoryFeedback` modifier skips firing entirely.
    var feedback: SensoryFeedback? {
        switch self {
        case .none:   return nil
        case .light:  return .impact(weight: .light)
        case .medium: return .impact(weight: .medium)
        case .heavy:  return .impact(weight: .heavy)
        }
    }
}
