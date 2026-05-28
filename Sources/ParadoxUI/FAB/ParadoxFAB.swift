import SwiftUI
import ParadoxTokens

/// A floating action button. Comes in two shapes:
/// - `.circular(systemImage:)` — 56pt circular accent button
/// - `.extended(systemImage:title:)` — pill with icon + label
///
/// Position it manually with `.overlay(alignment: .bottomTrailing)` and
/// `.padding(16)` inside your screen.
///
/// ```swift
/// ZStack {
///     content
/// }
/// .overlay(alignment: .bottomTrailing) {
///     ParadoxFAB.circular(systemImage: "plus") { create() }
///         .padding(theme.spacing.lg)
/// }
/// ```
public struct ParadoxFAB: View {

    public enum Tone: Sendable, Hashable, CaseIterable {
        case primary, surface
    }

    private enum Shape {
        case circular(systemImage: String, accessibilityLabel: String)
        case extended(systemImage: String, title: String)
    }

    private let shape: Shape
    private let tone: Tone
    private let action: @MainActor () -> Void

    private init(shape: Shape, tone: Tone, action: @escaping @MainActor () -> Void) {
        self.shape = shape
        self.tone = tone
        self.action = action
    }

    /// Circular icon-only FAB. `accessibilityLabel` describes the action since
    /// there is no visible text.
    public static func circular(
        systemImage: String,
        accessibilityLabel: String? = nil,
        tone: Tone = .primary,
        action: @escaping @MainActor () -> Void
    ) -> ParadoxFAB {
        ParadoxFAB(
            shape: .circular(systemImage: systemImage,
                             accessibilityLabel: accessibilityLabel ?? systemImage),
            tone: tone,
            action: action
        )
    }

    /// Extended pill FAB with icon + label.
    public static func extended(
        systemImage: String,
        title: String,
        tone: Tone = .primary,
        action: @escaping @MainActor () -> Void
    ) -> ParadoxFAB {
        ParadoxFAB(
            shape: .extended(systemImage: systemImage, title: title),
            tone: tone,
            action: action
        )
    }

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.paradoxHaptic) private var hapticOverride
    @State private var pressCount: Int = 0

    public var body: some View {
        Button(action: action) {
            content
                .foregroundStyle(foreground)
                .background(
                    Capsule(style: .continuous).fill(background)
                )
                .paradoxShadow(theme.elevation.level3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .sensoryFeedback(trigger: pressCount) { _, _ in
            effectiveHaptic.feedback
        }
        .simultaneousGesture(
            TapGesture().onEnded { pressCount &+= 1 }
        )
    }

    @ViewBuilder
    private var content: some View {
        switch shape {
        case .circular(let systemImage, _):
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 56, height: 56)
        case .extended(let systemImage, let title):
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .paradoxText(theme.typography.label)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, theme.spacing.lg)
            .frame(height: 52)
        }
    }

    private var background: Color {
        switch tone {
        case .primary: return theme.color.accent.primary
        case .surface: return theme.color.background.elevated
        }
    }

    private var foreground: Color {
        switch tone {
        case .primary: return theme.color.text.inverse
        case .surface: return theme.color.text.primary
        }
    }

    private var accessibilityLabel: String {
        switch shape {
        case .circular(_, let label): return label
        case .extended(_, let title): return title
        }
    }

    private var effectiveHaptic: ParadoxHaptic {
        hapticOverride ?? .light
    }
}

private extension ParadoxHaptic {
    var feedback: SensoryFeedback? {
        switch self {
        case .none:   return nil
        case .light:  return .impact(weight: .light)
        case .medium: return .impact(weight: .medium)
        case .heavy:  return .impact(weight: .heavy)
        }
    }
}
