import SwiftUI

/// Haptic feedback intensity for tap-driven controls.
///
/// Default per-variant haptics are set inside `ParadoxButtonStyle`. Apps override
/// at any layer with `.paradoxHaptic(_:)`. Pass `.none` to suppress entirely.
public enum ParadoxHaptic: Sendable, Hashable {
    case none, light, medium, heavy
}

private struct ParadoxHapticKey: EnvironmentKey {
    static let defaultValue: ParadoxHaptic? = nil
}

public extension EnvironmentValues {
    /// User-supplied haptic override. `nil` means "use the component's default".
    var paradoxHaptic: ParadoxHaptic? {
        get { self[ParadoxHapticKey.self] }
        set { self[ParadoxHapticKey.self] = newValue }
    }
}

public extension View {
    /// Override haptic feedback for tap-driven Paradox controls in this hierarchy.
    /// Pass `.none` to suppress haptics entirely.
    func paradoxHaptic(_ haptic: ParadoxHaptic?) -> some View {
        environment(\.paradoxHaptic, haptic)
    }
}
