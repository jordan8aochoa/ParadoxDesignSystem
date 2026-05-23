#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

/// Snapshot tests for `ParadoxButtonStyle`. Representative subset of the full
/// variant × size × state × scheme matrix — full coverage would be ~96 snapshots;
/// we ship ~20 strategic combinations.
///
/// On first run on a Mac, snapshots are recorded under `__Snapshots__/`. Commit
/// those references; subsequent runs verify against them.
@MainActor
final class ParadoxButtonStyleTests: XCTestCase {

    // MARK: - All variants, regular size, light mode

    func test_primary_regular_light() {
        assert(view: button("Sign in", .paradoxPrimary), name: "primary_regular_light")
    }
    func test_secondary_regular_light() {
        assert(view: button("Cancel", .paradoxSecondary), name: "secondary_regular_light")
    }
    func test_tertiary_regular_light() {
        assert(view: button("Skip", .paradoxTertiary), name: "tertiary_regular_light")
    }
    func test_ghost_regular_light() {
        assert(view: button("More", .paradoxGhost), name: "ghost_regular_light")
    }
    func test_destructive_regular_light() {
        assert(view: button("Delete", .paradoxDestructive), name: "destructive_regular_light")
    }
    func test_link_regular_light() {
        assert(view: button("Learn more", .paradoxLink), name: "link_regular_light")
    }

    // MARK: - Primary across all control sizes

    func test_primary_mini_light() {
        assert(view: button("Tap", .paradoxPrimary).controlSize(.mini),
               name: "primary_mini_light", height: 60)
    }
    func test_primary_small_light() {
        assert(view: button("Tap", .paradoxPrimary).controlSize(.small),
               name: "primary_small_light", height: 70)
    }
    func test_primary_large_light() {
        assert(view: button("Continue", .paradoxPrimary).controlSize(.large),
               name: "primary_large_light", height: 100)
    }

    // MARK: - Dark mode

    func test_primary_regular_dark() {
        assert(view: button("Sign in", .paradoxPrimary).preferredColorScheme(.dark),
               name: "primary_regular_dark", scheme: .dark)
    }
    func test_secondary_regular_dark() {
        assert(view: button("Cancel", .paradoxSecondary).preferredColorScheme(.dark),
               name: "secondary_regular_dark", scheme: .dark)
    }
    func test_destructive_regular_dark() {
        assert(view: button("Delete", .paradoxDestructive).preferredColorScheme(.dark),
               name: "destructive_regular_dark", scheme: .dark)
    }

    // MARK: - States

    func test_primary_disabled_light() {
        assert(view: button("Sign in", .paradoxPrimary).disabled(true),
               name: "primary_disabled_light")
    }
    func test_primary_loading_light() {
        assert(view: button("Sign in", .paradoxPrimary).paradoxLoading(true),
               name: "primary_loading_light")
    }

    // MARK: - Icon variants

    func test_primary_textIcon_light() {
        let view = ParadoxButton("Save", systemImage: "checkmark", action: {})
            .buttonStyle(.paradoxPrimary)
        assert(view: themed(view), name: "primary_textIcon_light")
    }
    func test_primary_iconOnly_light() {
        let view = ParadoxButton(systemImage: "plus", action: {})
            .buttonStyle(.paradoxPrimary)
        assert(view: themed(view), name: "primary_iconOnly_light", width: 120, height: 100)
    }

    // MARK: - Helpers

    private func button(_ title: String, _ style: ParadoxButtonStyle) -> some View {
        themed(Button(title, action: {}).buttonStyle(style))
    }

    private func themed<V: View>(_ v: V) -> some View {
        v.padding()
         .paradoxTheme(ParadoxDefaultTheme())
    }

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 300, height: CGFloat = 80,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let host = UIHostingController(rootView: view.frame(width: width, height: height))
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
