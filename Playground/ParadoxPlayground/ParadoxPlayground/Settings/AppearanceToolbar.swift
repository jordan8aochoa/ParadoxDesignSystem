import SwiftUI
import ParadoxUI

/// Persistent toolbar that lets you flip appearance, Dynamic Type, and Reduce Motion
/// on every section without leaving the screen.
struct AppearanceToolbar: ToolbarContent {
    @EnvironmentObject private var appearance: AppearanceModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Appearance", selection: $appearance.appearance) {
                    ForEach(AppearanceModel.AppearanceChoice.allCases) { choice in
                        Text(choice.rawValue.capitalized).tag(choice)
                    }
                }

                Picker("Dynamic Type", selection: $appearance.dynamicType) {
                    ForEach(DynamicTypeSize.allCases, id: \.self) { size in
                        Text(label(for: size)).tag(size)
                    }
                }

                Toggle("Reduce Motion", isOn: $appearance.reduceMotion)
            } label: {
                Image(systemName: "switch.2")
            }
        }
    }

    private func label(for size: DynamicTypeSize) -> String {
        switch size {
        case .xSmall: return "xS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L (default)"
        case .xLarge: return "xL"
        case .xxLarge: return "xxL"
        case .xxxLarge: return "xxxL"
        case .accessibility1: return "AX1"
        case .accessibility2: return "AX2"
        case .accessibility3: return "AX3"
        case .accessibility4: return "AX4"
        case .accessibility5: return "AX5"
        @unknown default: return "?"
        }
    }
}
