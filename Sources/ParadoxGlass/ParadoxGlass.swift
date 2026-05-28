/// `ParadoxGlass` — iOS 26 Liquid Glass extensions for ParadoxUI.
///
/// Every public surface here is `@available(iOS 26, *)` gated. Apps linking
/// this module can still target iOS 17+ — they just need to wrap call sites:
///
/// ```swift
/// if #available(iOS 26, *) {
///     SomeView().paradoxGlass()
/// } else {
///     SomeView().background(theme.color.background.elevated)
/// }
/// ```
@_exported import ParadoxUI

public enum ParadoxGlass {
    public static let version = "0.1.0"
}
