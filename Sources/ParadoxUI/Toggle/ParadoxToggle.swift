import SwiftUI
import ParadoxTokens

/// A switch component matching iOS native UISwitch dimensions (51×31pt track,
/// 27pt knob) but themed with `accent.primary` on, `border.strong` off, and a
/// reduce-motion-aware spring slide.
///
/// Returns just the visual — no built-in label, so apps compose freely:
///
/// ```swift
/// HStack {
///     Text("Notifications")
///     Spacer()
///     ParadoxToggle(isOn: $on)
/// }
/// ```
///
/// Inside a `List` row, the auto-chevron suppression of `ParadoxListItem` makes
/// this drop-in natural.
public struct ParadoxToggle: View {
    @Binding private var isOn: Bool

    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(trackColor)
                .frame(width: 51, height: 31)

            Circle()
                .fill(Color.white)
                .frame(width: 27, height: 27)
                .padding(.horizontal, 2)
                .shadow(color: .black.opacity(0.18), radius: 2, x: 0, y: 1)
        }
        .frame(width: 51, height: 31)
        .opacity(isEnabled ? 1.0 : 0.5)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(reduceMotion ? nil : theme.motion.spring.snappy) {
                isOn.toggle()
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isOn)
        .accessibilityElement()
        .accessibilityValue(isOn ? Text("On") : Text("Off"))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction {
            isOn.toggle()
        }
    }

    private var trackColor: Color {
        isOn ? theme.color.accent.primary : theme.color.border.strong
    }
}
