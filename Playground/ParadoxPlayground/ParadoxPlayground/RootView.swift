import SwiftUI
import ParadoxUI

struct RootView: View {
    @Environment(\.paradoxTheme) private var theme

    var body: some View {
        TabView {
            wrap("Colors",     systemImage: "paintpalette")  { ColorsView() }
            wrap("Typography", systemImage: "textformat")    { TypographyView() }
            wrap("Spacing",    systemImage: "ruler")         { SpacingView() }
            wrap("Radius",     systemImage: "square.on.circle") { RadiusView() }
            wrap("Motion",     systemImage: "waveform.path") { MotionView() }
            wrap("Elevation",  systemImage: "square.stack.3d.up") { ElevationView() }
        }
        .tint(theme.color.accent.primary)
    }

    @ViewBuilder
    private func wrap<Content: View>(_ title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        NavigationStack {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
                .toolbar { AppearanceToolbar() }
                .background(theme.color.background.primary.ignoresSafeArea())
        }
        .tabItem { Label(title, systemImage: systemImage) }
    }
}

#Preview {
    RootView()
        .environmentObject(AppearanceModel())
        .paradoxTheme(ParadoxDefaultTheme())
}
