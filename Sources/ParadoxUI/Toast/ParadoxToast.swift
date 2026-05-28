import SwiftUI
import ParadoxTokens

/// A transient notification that slides in from the top of the screen, lives for
/// a few seconds, then slides out. Four variants matching the status palette.
///
/// Present via the `.paradoxToast(item:)` overlay modifier. Setting the binding
/// to a non-nil value shows the toast; passing `nil` (or letting it auto-dismiss)
/// hides it.
///
/// ```swift
/// @State var toast: ParadoxToast.Model?
/// VStack { ... }
///   .paradoxToast(item: $toast)
///
/// // Show one:
/// toast = .init(title: "Saved", variant: .success)
/// ```
public struct ParadoxToast: View {

    public struct Model: Identifiable, Equatable, Sendable {
        public let id: UUID
        public let title: String
        public let message: String?
        public let variant: Variant
        public let duration: TimeInterval

        public init(
            id: UUID = UUID(),
            title: String,
            message: String? = nil,
            variant: Variant = .info,
            duration: TimeInterval = 3.0
        ) {
            self.id = id
            self.title = title
            self.message = message
            self.variant = variant
            self.duration = duration
        }
    }

    public enum Variant: Sendable, Hashable, CaseIterable {
        case info, success, warning, error
    }

    private let model: Model

    public init(model: Model) {
        self.model = model
    }

    @Environment(\.paradoxTheme) private var theme

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(iconColor)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(model.title)
                    .paradoxText(theme.typography.label)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.color.text.primary)
                if let message = model.message {
                    Text(message)
                        .paradoxText(theme.typography.bodySmall)
                        .foregroundStyle(theme.color.text.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: theme.radius.lg, style: .continuous)
                .fill(theme.color.background.elevated)
        )
        .paradoxShadow(theme.elevation.level3)
        .accessibilityElement(children: .combine)
    }

    private var iconName: String {
        switch model.variant {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.octagon.fill"
        }
    }

    private var iconColor: Color {
        switch model.variant {
        case .info:    return theme.color.status.info
        case .success: return theme.color.status.success
        case .warning: return theme.color.status.warning
        case .error:   return theme.color.status.error
        }
    }
}

// MARK: - Overlay modifier

public extension View {
    /// Overlays a top-anchored toast above this view when `item` is non-nil.
    /// The toast auto-dismisses after `item?.duration` seconds.
    func paradoxToast(item: Binding<ParadoxToast.Model?>) -> some View {
        modifier(ParadoxToastOverlay(item: item))
    }
}

private struct ParadoxToastOverlay: ViewModifier {
    @Binding var item: ParadoxToast.Model?
    @Environment(\.paradoxTheme) private var theme

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let model = item {
                    ParadoxToast(model: model)
                        .padding(.horizontal, theme.spacing.lg)
                        .padding(.top, theme.spacing.sm)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .task(id: model.id) {
                            try? await Task.sleep(for: .seconds(model.duration))
                            guard !Task.isCancelled, item?.id == model.id else { return }
                            withAnimation(theme.motion.spring.gentle) {
                                item = nil
                            }
                        }
                }
            }
            .animation(theme.motion.spring.gentle, value: item?.id)
    }
}
