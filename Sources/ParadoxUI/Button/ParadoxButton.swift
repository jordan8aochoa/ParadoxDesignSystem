import SwiftUI

/// Convenience component for the common Button shapes — text, text+icon, icon-only.
/// Wraps SwiftUI's `Button` so apps still apply `.buttonStyle(.paradoxPrimary)` etc.
///
/// For custom labels (e.g., multi-line, badges), use SwiftUI's `Button` directly
/// with a `@ViewBuilder` label.
public struct ParadoxButton: View {
    private let kind: Kind
    private let action: () -> Void

    private enum Kind {
        case text(String)
        case textIcon(title: String, systemImage: String)
        case iconOnly(systemImage: String)
    }

    /// Text-only button.
    public init(_ title: String, action: @escaping () -> Void) {
        self.kind = .text(title)
        self.action = action
    }

    /// Text with a leading SF Symbol.
    public init(_ title: String, systemImage: String, action: @escaping () -> Void) {
        self.kind = .textIcon(title: title, systemImage: systemImage)
        self.action = action
    }

    /// Icon-only button. Renders as a square hit target whose side equals the
    /// current `.controlSize`'s height.
    public init(systemImage: String, action: @escaping () -> Void) {
        self.kind = .iconOnly(systemImage: systemImage)
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            switch kind {
            case .text(let title):
                Text(title)
            case .textIcon(let title, let systemImage):
                Label(title, systemImage: systemImage)
            case .iconOnly(let systemImage):
                Image(systemName: systemImage)
                    .accessibilityHidden(false)
            }
        }
    }
}
