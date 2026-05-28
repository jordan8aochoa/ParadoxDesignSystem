import SwiftUI
import ParadoxTokens

/// A skeleton-loading shimmer. Apply to placeholder shapes while content
/// fetches. Honors `accessibilityReduceMotion` — falls back to a static
/// `surface.secondary` fill when motion is reduced.
///
/// ```swift
/// RoundedRectangle(cornerRadius: 8)
///     .fill(.clear)
///     .frame(height: 16)
///     .paradoxShimmer()
/// ```
public struct ParadoxShimmerModifier: ViewModifier {
    @Environment(\.paradoxTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: CGFloat = -1

    public func body(content: Content) -> some View {
        content
            .overlay {
                if reduceMotion {
                    Rectangle().fill(theme.color.surface.secondary)
                } else {
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        LinearGradient(
                            colors: [
                                theme.color.surface.secondary,
                                theme.color.surface.raised,
                                theme.color.surface.secondary
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: width * 2)
                        .offset(x: phase * width)
                    }
                    .onAppear {
                        withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                            phase = 1
                        }
                    }
                }
            }
            .mask(content)
    }
}

public extension View {
    /// Apply a shimmer overlay while loading. Use on placeholder shapes.
    func paradoxShimmer() -> some View {
        modifier(ParadoxShimmerModifier())
    }
}
