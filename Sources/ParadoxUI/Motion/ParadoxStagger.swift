import SwiftUI
import ParadoxTokens

/// A staggered entry animation for list-like content. Each child is animated
/// in with a small delay based on its index, fading + sliding up from below.
/// Honors `accessibilityReduceMotion` — appears instantly when motion is reduced.
///
/// ```swift
/// VStack(spacing: 12) {
///     ForEach(items.indices, id: \.self) { index in
///         ItemRow(item: items[index])
///             .paradoxStagger(index: index)
///     }
/// }
/// ```
public struct ParadoxStaggerModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.paradoxTheme) private var theme
    @State private var hasAppeared = false

    private let index: Int
    private let stride: Double
    private let baseDelay: Double

    public init(index: Int, stride: Double = 0.05, baseDelay: Double = 0.0) {
        self.index = index
        self.stride = stride
        self.baseDelay = baseDelay
    }

    public func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
                .onAppear {
                    let delay = baseDelay + Double(max(index, 0)) * stride
                    withAnimation(theme.motion.spring.snappy.delay(delay)) {
                        hasAppeared = true
                    }
                }
        }
    }
}

public extension View {
    /// Stagger this view's entry animation by `index * stride` seconds.
    /// Use with `ForEach(items.indices, id: \.self)` for a cascading reveal.
    func paradoxStagger(
        index: Int,
        stride: Double = 0.05,
        baseDelay: Double = 0.0
    ) -> some View {
        modifier(ParadoxStaggerModifier(
            index: index,
            stride: stride,
            baseDelay: baseDelay
        ))
    }
}
