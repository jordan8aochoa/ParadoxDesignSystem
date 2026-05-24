import SwiftUI
import ParadoxTokens

/// A small pill for counts ("12", "99+") or short labels ("Pro", "New", "Beta").
///
/// Standalone:
/// ```swift
/// ParadoxBadge(count: 12)              // → "12" on accent.primary
/// ParadoxBadge("Pro", variant: .accent)
/// ```
///
/// As an overlay via the `.paradoxBadge(...)` modifier:
/// ```swift
/// Image(systemName: "bell")
///     .paradoxBadge(count: 12)         // red dot+number top-trailing
/// ```
public struct ParadoxBadge: View {
    public enum Variant: Sendable, Hashable, CaseIterable {
        case neutral, accent, success, warning, error
    }

    private let content: Content
    private let variant: Variant

    private enum Content {
        case count(Int)
        case text(String)
    }

    /// Numeric badge. Caps at "99+" so the pill stays compact.
    public init(count: Int, variant: Variant = .error) {
        self.content = .count(count)
        self.variant = variant
    }

    /// Text badge. Use for short labels — "Pro", "New", "Beta", "Live".
    public init(_ text: String, variant: Variant = .accent) {
        self.content = .text(text)
        self.variant = variant
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        Text(displayText)
            .paradoxText(theme.typography.micro)
            .fontWeight(.semibold)
            .foregroundStyle(foreground)
            .padding(.horizontal, theme.spacing.xs + 2)   // 6pt
            .padding(.vertical, 2)
            .frame(minWidth: 16, minHeight: 16)
            .background(
                Capsule(style: .continuous).fill(background)
            )
            .accessibilityLabel(accessibilityLabel)
    }

    private var displayText: String {
        switch content {
        case .count(let n): return n > 99 ? "99+" : "\(n)"
        case .text(let s):  return s
        }
    }

    private var background: Color {
        switch variant {
        case .neutral: return theme.color.surface.secondary
        case .accent:  return theme.color.accent.primary
        case .success: return theme.color.status.success
        case .warning: return theme.color.status.warning
        case .error:   return theme.color.status.error
        }
    }

    private var foreground: Color {
        switch variant {
        case .neutral: return theme.color.text.primary
        default:       return theme.color.text.inverse
        }
    }

    private var accessibilityLabel: String {
        switch content {
        case .count(let n): return n == 1 ? "1 item" : "\(n) items"
        case .text(let s):  return s
        }
    }
}
