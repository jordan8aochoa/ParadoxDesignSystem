import SwiftUI
import ParadoxTokens

/// A short three-phase celebration animation triggered by changes to a value.
/// Phase 0: rest. Phase 1: scale up + tint. Phase 2: settle.
///
/// Use on a checkmark or score badge at the moment something succeeds.
/// Honors `accessibilityReduceMotion` — stays at rest when motion is reduced.
///
/// ```swift
/// Image(systemName: "checkmark.seal.fill")
///     .foregroundStyle(theme.color.status.success)
///     .paradoxCelebrate(trigger: completionId)
/// ```
public struct ParadoxCelebrateModifier<Value: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let trigger: Value

    public init(trigger: Value) {
        self.trigger = trigger
    }

    public enum Phase: CaseIterable, Sendable {
        case rest, bloom, settle

        var scale: CGFloat {
            switch self {
            case .rest:   return 1.0
            case .bloom:  return 1.18
            case .settle: return 1.0
            }
        }

        var rotation: Double {
            switch self {
            case .rest:   return 0
            case .bloom:  return -6
            case .settle: return 0
            }
        }
    }

    public func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content.phaseAnimator(Phase.allCases, trigger: trigger) { view, phase in
                view
                    .scaleEffect(phase.scale)
                    .rotationEffect(.degrees(phase.rotation))
            } animation: { phase in
                switch phase {
                case .rest:   return .spring(response: 0.25, dampingFraction: 0.6)
                case .bloom:  return .spring(response: 0.28, dampingFraction: 0.55)
                case .settle: return .spring(response: 0.42, dampingFraction: 0.7)
                }
            }
        }
    }
}

public extension View {
    /// Play a short celebration animation whenever `trigger` changes value.
    func paradoxCelebrate<V: Equatable>(trigger: V) -> some View {
        modifier(ParadoxCelebrateModifier(trigger: trigger))
    }
}
