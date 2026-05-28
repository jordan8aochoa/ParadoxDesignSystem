import SwiftUI
import ParadoxTokens
import ParadoxUI

/// Apply iOS 26 Liquid Glass to any view, shaped to a Paradox radius.
///
/// On iOS 17–25 this is a no-op fallback to `surface.raised` so call sites
/// can compile cleanly. On iOS 26+ it routes to the native `.glassEffect`.
///
/// ```swift
/// content
///     .paradoxGlass()                    // default: continuous rounded rect, md radius
///     .paradoxGlass(radius: .lg)         // larger corner
///     .paradoxGlass(tint: theme.color.accent.primary.opacity(0.15))
/// ```
@available(iOS 26, *)
public struct ParadoxGlassModifier: ViewModifier {
    @Environment(\.paradoxTheme) private var theme

    public enum Radius: Sendable, Hashable, CaseIterable {
        case sm, md, lg, xl, pill

        func value(_ theme: any ParadoxTheme) -> CGFloat {
            switch self {
            case .sm:   return theme.radius.sm
            case .md:   return theme.radius.md
            case .lg:   return theme.radius.lg
            case .xl:   return theme.radius.xl
            case .pill: return theme.radius.pill
            }
        }
    }

    private let radius: Radius
    private let tint: Color?

    public init(radius: Radius = .md, tint: Color? = nil) {
        self.radius = radius
        self.tint = tint
    }

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius.value(theme), style: .continuous)
        return content.glassEffect(glass, in: shape)
    }

    private var glass: Glass {
        if let tint {
            return .regular.tint(tint)
        }
        return .regular
    }
}

public extension View {
    /// Liquid Glass background, shaped to a Paradox radius. iOS 26+ only.
    @available(iOS 26, *)
    func paradoxGlass(
        radius: ParadoxGlassModifier.Radius = .md,
        tint: Color? = nil
    ) -> some View {
        modifier(ParadoxGlassModifier(radius: radius, tint: tint))
    }
}
