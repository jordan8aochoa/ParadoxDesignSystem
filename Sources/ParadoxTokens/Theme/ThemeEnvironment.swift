import SwiftUI

private struct ParadoxThemeKey: EnvironmentKey {
    static let defaultValue: any ParadoxTheme = ParadoxDefaultTheme()
}

public extension EnvironmentValues {
    /// The active Paradox theme. Defaults to `ParadoxDefaultTheme`.
    var paradoxTheme: any ParadoxTheme {
        get { self[ParadoxThemeKey.self] }
        set { self[ParadoxThemeKey.self] = newValue }
    }
}

public extension View {
    /// Set the active Paradox theme on this view hierarchy.
    func paradoxTheme(_ theme: any ParadoxTheme) -> some View {
        environment(\.paradoxTheme, theme)
    }
}
