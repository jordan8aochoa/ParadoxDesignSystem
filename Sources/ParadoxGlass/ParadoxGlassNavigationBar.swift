import SwiftUI
import ParadoxTokens
import ParadoxUI

/// Wraps a `ParadoxNavigationBar` with a Liquid Glass background instead of
/// the opaque `background.primary` fill. Use at the top of screens where the
/// content scrolls under the nav bar and you want it to feel floating.
///
/// ```swift
/// VStack(spacing: 0) {
///     ParadoxGlassNavigationBar(title: "Discover", trailing: { ... })
///     ScrollView { ... }
/// }
/// ```
@available(iOS 26, *)
public struct ParadoxGlassNavigationBar<Leading: View, Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let style: ParadoxNavigationBar<Leading, Trailing>.Style
    private let leading: () -> Leading
    private let trailing: () -> Trailing

    public init(
        title: String,
        subtitle: String? = nil,
        style: ParadoxNavigationBar<Leading, Trailing>.Style = .compact,
        @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading
        self.trailing = trailing
    }

    public var body: some View {
        ParadoxNavigationBar(
            title: title,
            subtitle: subtitle,
            style: style,
            leading: leading,
            trailing: trailing
        )
        .background(.clear)
        .glassEffect(.regular, in: Rectangle())
    }
}
