import SwiftUI

/// Motion presets. All factory methods respect `accessibilityReduceMotion`
/// when called via `resolve(reduceMotion:)`.
public struct MotionScale: Sendable {
    public let spring: Springs
    public let duration: Durations
    public let easing: Easings

    public init(spring: Springs = Springs(), duration: Durations = Durations(), easing: Easings = Easings()) {
        self.spring = spring
        self.duration = duration
        self.easing = easing
    }

    public struct Springs: Sendable {
        public let snappy: Animation
        public let gentle: Animation
        public let bouncy: Animation
        public init(
            snappy: Animation = .spring(response: 0.28, dampingFraction: 0.86, blendDuration: 0),
            gentle: Animation = .spring(response: 0.45, dampingFraction: 0.9, blendDuration: 0),
            bouncy: Animation = .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
        ) {
            self.snappy = snappy; self.gentle = gentle; self.bouncy = bouncy
        }
    }

    public struct Durations: Sendable {
        public let fast: Double
        public let standard: Double
        public let slow: Double
        public init(fast: Double = 0.15, standard: Double = 0.25, slow: Double = 0.40) {
            self.fast = fast; self.standard = standard; self.slow = slow
        }
    }

    public struct Easings: Sendable {
        public let standard: Animation
        public let emphasized: Animation
        public let decelerated: Animation
        public init(
            standard: Animation = .easeInOut(duration: 0.25),
            emphasized: Animation = .timingCurve(0.2, 0, 0, 1, duration: 0.4),
            decelerated: Animation = .timingCurve(0, 0, 0.2, 1, duration: 0.3)
        ) {
            self.standard = standard; self.emphasized = emphasized; self.decelerated = decelerated
        }
    }

    /// Returns an animation that collapses to no animation when reduce-motion is on.
    public func resolve(_ animation: Animation, reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : animation
    }
}

public extension View {
    /// Apply an animation that honors `accessibilityReduceMotion`.
    func paradoxAnimation(_ animation: Animation, value: some Hashable) -> some View {
        modifier(ParadoxAnimationModifier(animation: animation, value: AnyHashable(value)))
    }
}

private struct ParadoxAnimationModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation
    let value: AnyHashable

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? nil : animation, value: value)
    }
}
