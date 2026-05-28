#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxModalTests: XCTestCase {

    func test_titleOnly_light() {
        let view = ParadoxModal(title: "Settings") {
            Text("Body content")
        }
        assert(view: view, name: "titleOnly_light")
    }

    func test_titleSubtitle_light() {
        let view = ParadoxModal(title: "Delete account",
                                subtitle: "This action can't be undone.") {
            Text("All your data will be permanently removed.")
        }
        assert(view: view, name: "titleSubtitle_light")
    }

    func test_primaryOnly_light() {
        let view = ParadoxModal(
            title: "Welcome",
            primaryAction: .init(title: "Continue") {}
        ) {
            Text("Tap continue to proceed.")
        }
        assert(view: view, name: "primaryOnly_light")
    }

    func test_primarySecondary_light() {
        let view = ParadoxModal(
            title: "Confirm",
            primaryAction: .init(title: "Save") {},
            secondaryAction: .init(title: "Cancel", role: .secondary) {}
        ) {
            Text("Save your changes?")
        }
        assert(view: view, name: "primarySecondary_light")
    }

    func test_destructive_light() {
        let view = ParadoxModal(
            title: "Delete?",
            subtitle: "This can't be undone.",
            primaryAction: .init(title: "Delete", role: .destructive) {},
            secondaryAction: .init(title: "Cancel", role: .secondary) {}
        ) {
            Text("Permanent removal from servers.")
        }
        assert(view: view, name: "destructive_light")
    }

    func test_primarySecondary_dark() {
        let view = ParadoxModal(
            title: "Confirm",
            primaryAction: .init(title: "Save") {},
            secondaryAction: .init(title: "Cancel", role: .secondary) {}
        ) {
            Text("Save your changes?")
        }
        .preferredColorScheme(.dark)
        assert(view: view, name: "primarySecondary_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 390, height: CGFloat = 360,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .frame(width: width, height: height)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
