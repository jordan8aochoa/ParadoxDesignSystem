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
            wrap("Buttons",    systemImage: "rectangle.and.hand.point.up.left") { ButtonsView() }
            wrap("Rows",       systemImage: "list.bullet.rectangle") { ListItemsView() }
            wrap("Cards",      systemImage: "rectangle.stack") { CardsView() }
            wrap("Fields",     systemImage: "character.cursor.ibeam") { FieldsView() }
            wrap("Toggles",    systemImage: "switch.2") { TogglesView() }
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
