import SwiftUI
import ParadoxTokens

/// A slow opacity + scale breathe loop. Use to draw the eye to a single
/// element — a live indicator, a fresh notification dot, an unread marker.
/// Honors `accessibilityReduceMotion` — stays static when motion is reduced.
///
/// ```swift
/// Circle().fill(theme.color.status.success)
///     .frame(width: 8, height: 8)
///     .paradoxPulse()
/// ```
public struct ParadoxPulseModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPulsing = false

    private let minScale: CGFloat
    private let maxScale: CGFloat
    private let minOpacity: Double
    private let duration: Double

    public init(
        minScale: CGFloat = 0.92,
        maxScale: CGFloat = 1.0,
        minOpacity: Double = 0.6,
        duration: Double = 1.2
    ) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.minOpacity = minOpacity
        self.duration = duration
    }

    public func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content
                .scaleEffect(isPulsing ? maxScale : minScale)
                .opacity(isPulsing ? 1.0 : minOpacity)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: duration)
                            .repeatForever(autoreverses: true)
                    ) {
                        isPulsing = true
                    }
                }
        }
    }
}

public extension View {
    /// A subtle breathing pulse. Defaults are tuned for small status dots.
    func paradoxPulse(
        minScale: CGFloat = 0.92,
        maxScale: CGFloat = 1.0,
        minOpacity: Double = 0.6,
        duration: Double = 1.2
    ) -> some View {
        modifier(ParadoxPulseModifier(
            minScale: minScale,
            maxScale: maxScale,
            minOpacity: minOpacity,
            duration: duration
        ))
    }
}
