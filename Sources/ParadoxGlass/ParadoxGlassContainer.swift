import SwiftUI
import ParadoxUI

/// Group multiple glass elements so they morph together as the user
/// interacts. Wrap any cluster of `.paradoxGlass()` views inside this
/// container to enable shared morphing.
///
/// ```swift
/// ParadoxGlassContainer {
///     HStack(spacing: 8) {
///         Image(systemName: "play.fill").padding(12).paradoxGlass(radius: .pill)
///         Image(systemName: "forward.fill").padding(12).paradoxGlass(radius: .pill)
///     }
/// }
/// ```
@available(iOS 26, *)
public struct ParadoxGlassContainer<Content: View>: View {
    private let spacing: CGFloat
    private let content: Content

    public init(spacing: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        GlassEffectContainer(spacing: spacing) {
            content
        }
    }
}
