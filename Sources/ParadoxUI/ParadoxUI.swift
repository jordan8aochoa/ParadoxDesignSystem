/// `ParadoxUI` — Phase 2+ home for components, modifiers, and motion patterns.
///
/// This module is currently empty. Phase 1 ships only `ParadoxTokens` (foundations)
/// and the Playground app that consumes them. Components arrive in Phase 2.
///
/// Re-exports `ParadoxTokens` so apps only need to `import ParadoxUI` once Phase 2 lands.
@_exported import ParadoxTokens

public enum ParadoxUI {
    /// Semantic version of the design system.
    public static let version = "0.1.0-phase1"
}
