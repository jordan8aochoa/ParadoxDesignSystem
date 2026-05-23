import SwiftUI

private struct ParadoxIsLoadingKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

public extension EnvironmentValues {
    /// True when the current view hierarchy is in a loading state. Consumed by
    /// `ParadoxButtonStyle` to swap the label for a spinner.
    var paradoxIsLoading: Bool {
        get { self[ParadoxIsLoadingKey.self] }
        set { self[ParadoxIsLoadingKey.self] = newValue }
    }
}

public extension View {
    /// Mark this view as loading. `ParadoxButtonStyle` fades its label to 0,
    /// overlays a spinner, and blocks hit testing.
    func paradoxLoading(_ isLoading: Bool) -> some View {
        environment(\.paradoxIsLoading, isLoading)
            .allowsHitTesting(!isLoading)
    }
}
