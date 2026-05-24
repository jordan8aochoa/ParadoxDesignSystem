import SwiftUI

/// Padding tier for `ParadoxCard`. Each tier maps to a `spacing` token.
public enum ParadoxCardPadding: Sendable, Hashable, CaseIterable {
    /// `spacing.md` (12pt) — dense lists, inline cards.
    case compact
    /// `spacing.lg` (16pt) — default. Most cards.
    case cozy
    /// `spacing.xl` (24pt) — hero cards, marketing surfaces.
    case comfortable
}

/// Elevation level for `ParadoxCard`. Default `.none` renders no shadow; opt up for floating cards.
public enum ParadoxCardElevation: Sendable, Hashable, CaseIterable {
    case none, level1, level2, level3, level4
}

// MARK: - Environment plumbing

private struct ParadoxCardPaddingKey: EnvironmentKey {
    static let defaultValue: ParadoxCardPadding = .cozy
}

private struct ParadoxCardElevationKey: EnvironmentKey {
    static let defaultValue: ParadoxCardElevation = .none
}

public extension EnvironmentValues {
    var paradoxCardPadding: ParadoxCardPadding {
        get { self[ParadoxCardPaddingKey.self] }
        set { self[ParadoxCardPaddingKey.self] = newValue }
    }
    var paradoxCardElevation: ParadoxCardElevation {
        get { self[ParadoxCardElevationKey.self] }
        set { self[ParadoxCardElevationKey.self] = newValue }
    }
}

public extension View {
    /// Set the padding tier for any `ParadoxCard` in this view hierarchy.
    func paradoxCardPadding(_ padding: ParadoxCardPadding) -> some View {
        environment(\.paradoxCardPadding, padding)
    }

    /// Set the elevation level for any `ParadoxCard` in this view hierarchy.
    func paradoxCardElevation(_ elevation: ParadoxCardElevation) -> some View {
        environment(\.paradoxCardElevation, elevation)
    }
}
