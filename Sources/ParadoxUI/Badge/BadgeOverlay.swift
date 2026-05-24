import SwiftUI

public extension View {
    /// Overlay a numeric `ParadoxBadge` at the top-trailing corner of this view.
    /// Defaults to the `.error` variant (red), matching the iOS notification badge convention.
    func paradoxBadge(count: Int, variant: ParadoxBadge.Variant = .error) -> some View {
        overlay(alignment: .topTrailing) {
            ParadoxBadge(count: count, variant: variant)
                .offset(x: 6, y: -6)
        }
    }

    /// Overlay a text `ParadoxBadge` at the top-trailing corner of this view.
    /// Defaults to the `.accent` variant for label-style badges ("New", "Pro").
    func paradoxBadge(_ text: String, variant: ParadoxBadge.Variant = .accent) -> some View {
        overlay(alignment: .topTrailing) {
            ParadoxBadge(text, variant: variant)
                .offset(x: 6, y: -6)
        }
    }
}
