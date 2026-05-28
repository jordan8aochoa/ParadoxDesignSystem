import SwiftUI
import ParadoxTokens

/// A premium bottom sheet built on SwiftUI's native `.sheet` + `.presentationDetents`.
/// Provides three detents (small/medium/large), a drag handle, and theme-aware
/// chrome. Wrap the host view with `.paradoxBottomSheet(isPresented:detent:content:)`.
///
/// ```swift
/// @State var showFilters = false
/// VStack { ... }
///   .paradoxBottomSheet(isPresented: $showFilters, detent: .medium) {
///       FilterList()
///   }
/// ```
public enum ParadoxBottomSheetDetent: Sendable, Hashable, CaseIterable {
    case small, medium, large

    /// Maps to SwiftUI `PresentationDetent`.
    public var presentationDetent: PresentationDetent {
        switch self {
        case .small:  return .height(240)
        case .medium: return .medium
        case .large:  return .large
        }
    }
}

public extension View {
    /// Present a Paradox-styled bottom sheet. The sheet wraps `content` with a
    /// drag handle and theme background.
    func paradoxBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detent: ParadoxBottomSheetDetent = .medium,
        allowedDetents: Set<ParadoxBottomSheetDetent> = [.small, .medium, .large],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        sheet(isPresented: isPresented) {
            ParadoxBottomSheetContainer(content: content())
                .presentationDetents(Set(allowedDetents.map(\.presentationDetent)))
                .presentationDragIndicator(.hidden) // we draw our own
        }
    }
}

/// The body of a Paradox bottom sheet. Public so callers can also use it
/// inside a custom `.sheet` invocation if they need finer control.
public struct ParadoxBottomSheetContainer<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    fileprivate init(content: Content) {
        self.content = content
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        VStack(spacing: 0) {
            dragHandle
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(theme.color.background.elevated)
        .accessibilityElement(children: .contain)
    }

    private var dragHandle: some View {
        Capsule(style: .continuous)
            .fill(theme.color.border.default)
            .frame(width: 36, height: 5)
            .padding(.top, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
            .accessibilityHidden(true)
    }
}
