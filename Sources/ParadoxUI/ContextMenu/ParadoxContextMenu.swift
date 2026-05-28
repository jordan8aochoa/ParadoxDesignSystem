import SwiftUI
import ParadoxTokens

/// A declarative wrapper over SwiftUI's `.contextMenu`. Build the menu from an
/// array of `Action` values so apps can construct menus from data, and so the
/// menu honors destructive role + symbol + divider semantics consistently.
///
/// ```swift
/// Image(systemName: "photo")
///     .paradoxContextMenu([
///         .action("Share",   systemImage: "square.and.arrow.up") { share() },
///         .action("Copy",    systemImage: "doc.on.doc")          { copy() },
///         .divider,
///         .action("Delete",  systemImage: "trash", role: .destructive) { delete() }
///     ])
/// ```
public enum ParadoxContextAction: Sendable {

    public enum Role: Sendable, Hashable, CaseIterable {
        case standard, destructive
    }

    case action(title: String, systemImage: String?, role: Role, handler: @MainActor () -> Void)
    case divider

    /// Convenience for an action item with optional symbol + role.
    public static func action(
        _ title: String,
        systemImage: String? = nil,
        role: Role = .standard,
        handler: @escaping @MainActor () -> Void
    ) -> ParadoxContextAction {
        .action(title: title, systemImage: systemImage, role: role, handler: handler)
    }
}

public extension View {
    /// Attach a Paradox-styled context menu (long press / right click).
    func paradoxContextMenu(_ actions: [ParadoxContextAction]) -> some View {
        contextMenu {
            ParadoxContextMenuContent(actions: actions)
        }
    }
}

/// The menu body. Public so callers can compose it directly inside their own
/// `.contextMenu { }` or `Menu { }` if needed.
public struct ParadoxContextMenuContent: View {
    private let actions: [ParadoxContextAction]

    public init(actions: [ParadoxContextAction]) {
        self.actions = actions
    }

    public var body: some View {
        ForEach(Array(actions.enumerated()), id: \.offset) { _, item in
            switch item {
            case .divider:
                Divider()
            case let .action(title, systemImage, role, handler):
                Button(role: role == .destructive ? .destructive : nil, action: handler) {
                    if let systemImage {
                        Label(title, systemImage: systemImage)
                    } else {
                        Text(title)
                    }
                }
            }
        }
    }
}
