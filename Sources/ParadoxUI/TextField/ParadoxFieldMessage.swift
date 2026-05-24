import SwiftUI
import ParadoxTokens

/// A message displayed below a Paradox-styled text field. Use the static
/// constructors to pick the visual treatment.
public struct ParadoxFieldMessage: Equatable, Sendable, Hashable {
    public enum Kind: Sendable, Hashable, CaseIterable {
        case error, warning, info, help
    }

    public let kind: Kind
    public let text: String

    public init(kind: Kind, text: String) {
        self.kind = kind
        self.text = text
    }

    /// Renders in `status.error` color. Also flips the field's focus ring to error.
    public static func error(_ text: String) -> ParadoxFieldMessage {
        .init(kind: .error, text: text)
    }
    /// Renders in `status.warning` color.
    public static func warning(_ text: String) -> ParadoxFieldMessage {
        .init(kind: .warning, text: text)
    }
    /// Renders in `status.info` color.
    public static func info(_ text: String) -> ParadoxFieldMessage {
        .init(kind: .info, text: text)
    }
    /// Renders in `text.tertiary` — non-emphasized helper text ("We'll never share this.").
    public static func help(_ text: String) -> ParadoxFieldMessage {
        .init(kind: .help, text: text)
    }
}

// MARK: - Environment

private struct ParadoxFieldMessageKey: EnvironmentKey {
    static let defaultValue: ParadoxFieldMessage? = nil
}

public extension EnvironmentValues {
    /// The active field message, read by `ParadoxTextFieldStyle` to color its focus ring.
    var paradoxFieldMessage: ParadoxFieldMessage? {
        get { self[ParadoxFieldMessageKey.self] }
        set { self[ParadoxFieldMessageKey.self] = newValue }
    }
}

// MARK: - View modifier

public extension View {
    /// Attach a message below a Paradox-styled text field. Renders the message
    /// caption and (if `.error`) flips the field's focus ring color.
    ///
    /// Pass `nil` to clear.
    func paradoxFieldMessage(_ message: ParadoxFieldMessage?) -> some View {
        modifier(ParadoxFieldMessageModifier(message: message))
    }
}

private struct ParadoxFieldMessageModifier: ViewModifier {
    let message: ParadoxFieldMessage?
    @Environment(\.paradoxTheme) private var theme

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            content.environment(\.paradoxFieldMessage, message)
            if let message {
                Text(message.text)
                    .paradoxText(theme.typography.caption)
                    .foregroundStyle(color(for: message.kind))
                    .accessibilityLabel("\(message.kind.accessibilityPrefix): \(message.text)")
            }
        }
    }

    private func color(for kind: ParadoxFieldMessage.Kind) -> Color {
        switch kind {
        case .error:   return theme.color.status.error
        case .warning: return theme.color.status.warning
        case .info:    return theme.color.status.info
        case .help:    return theme.color.text.tertiary
        }
    }
}

private extension ParadoxFieldMessage.Kind {
    var accessibilityPrefix: String {
        switch self {
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        case .help: return "Help"
        }
    }
}
