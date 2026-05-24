import SwiftUI
import ParadoxTokens

/// A surface for grouped content. Default: `surface.raised` fill, 1pt `border.subtle`
/// outline, no shadow, `cozy` (16pt) padding, `radius.lg` (12pt) corner.
///
/// Adjust via environment modifiers — composable, no init-time API explosion:
///
/// ```swift
/// ParadoxCard {
///     VStack(alignment: .leading) {
///         Text("Welcome")
///         Text("Your trip starts here.")
///     }
/// }
/// .paradoxCardPadding(.comfortable)
/// .paradoxCardElevation(.level2)
/// ```
public struct ParadoxCard<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.paradoxCardPadding) private var paddingTier
    @Environment(\.paradoxCardElevation) private var elevationLevel

    public var body: some View {
        content
            .padding(paddingValue)
            .background(
                RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous)
                    .fill(theme.color.surface.raised)
            )
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous)
                    .strokeBorder(theme.color.border.subtle, lineWidth: 1)
            )
            .paradoxShadow(elevationShadow)
    }

    private var paddingValue: CGFloat {
        switch paddingTier {
        case .compact:     return theme.spacing.md
        case .cozy:        return theme.spacing.lg
        case .comfortable: return theme.spacing.xl
        }
    }

    private var elevationShadow: ElevationScale.Shadow {
        switch elevationLevel {
        case .none:   return theme.elevation.level0
        case .level1: return theme.elevation.level1
        case .level2: return theme.elevation.level2
        case .level3: return theme.elevation.level3
        case .level4: return theme.elevation.level4
        }
    }
}
