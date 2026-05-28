import SwiftUI
import ParadoxTokens
import ParadoxUI

/// A card with a Liquid Glass background. The glass shape uses the system
/// continuous-rounded-rect, sized to the Paradox `lg` radius.
///
/// ```swift
/// ParadoxGlassCard {
///     VStack(alignment: .leading, spacing: 8) {
///         Text("Now playing").font(.headline)
///         Text("Daft Punk — Around the World").foregroundStyle(.secondary)
///     }
/// }
/// ```
@available(iOS 26, *)
public struct ParadoxGlassCard<Content: View>: View {
    private let content: Content
    private let tint: Color?

    public init(tint: Color? = nil, @ViewBuilder content: () -> Content) {
        self.tint = tint
        self.content = content()
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        content
            .padding(theme.spacing.lg)
            .paradoxGlass(radius: .lg, tint: tint)
    }
}
