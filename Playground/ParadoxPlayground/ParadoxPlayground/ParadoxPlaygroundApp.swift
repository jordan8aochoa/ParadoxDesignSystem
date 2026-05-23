import SwiftUI
import ParadoxUI

@main
struct ParadoxPlaygroundApp: App {
    @StateObject private var appearance = AppearanceModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appearance)
                .preferredColorScheme(appearance.colorScheme)
                .dynamicTypeSize(appearance.dynamicType)
                .environment(\.accessibilityReduceMotion, appearance.reduceMotion)
                .paradoxTheme(ParadoxDefaultTheme())
        }
    }
}

/// User-controlled appearance overrides exposed via the AppearanceToolbar.
final class AppearanceModel: ObservableObject {
    enum AppearanceChoice: String, CaseIterable, Identifiable {
        case system, light, dark
        var id: String { rawValue }
    }

    @Published var appearance: AppearanceChoice = .system
    @Published var dynamicType: DynamicTypeSize = .large
    @Published var reduceMotion: Bool = false

    var colorScheme: ColorScheme? {
        switch appearance {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
