import SwiftUI
import ParadoxTokens

/// Internal `ButtonStyle` applied when a `ParadoxListItem` has an `onTap`.
/// Provides subtle press feedback via `surface.secondary` background and
/// reduce-motion-aware spring animation.
struct ParadoxListItemPressable: ButtonStyle {
    @Environment(\.paradoxTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                if configuration.isPressed {
                    theme.color.surface.secondary
                }
            }
            .animation(theme.motion.spring.snappy, value: configuration.isPressed)
    }
}
