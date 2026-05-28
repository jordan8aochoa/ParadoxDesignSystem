#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxContextMenuTests: XCTestCase {

    // SwiftUI context menus render via a transient UIKit HUD, so we can't
    // snapshot the popped menu directly. We test (a) the action factory
    // produces the expected shape, and (b) attaching the menu doesn't break
    // host layout.

    func test_actionFactory_defaultRoleIsStandard() {
        let action = ParadoxContextAction.action("Copy", systemImage: "doc.on.doc") {}
        switch action {
        case let .action(title, systemImage, role, _):
            XCTAssertEqual(title, "Copy")
            XCTAssertEqual(systemImage, "doc.on.doc")
            XCTAssertEqual(role, .standard)
        case .divider:
            XCTFail("Expected .action case")
        }
    }

    func test_actionFactory_destructiveRolePreserved() {
        let action = ParadoxContextAction.action("Delete", role: .destructive) {}
        switch action {
        case let .action(_, _, role, _):
            XCTAssertEqual(role, .destructive)
        case .divider:
            XCTFail("Expected .action case")
        }
    }

    func test_hostLayoutUnchanged_light() {
        let view = Text("Long-press me")
            .padding()
            .background(.gray.opacity(0.1))
            .paradoxContextMenu([
                .action("Share", systemImage: "square.and.arrow.up") {},
                .action("Copy",  systemImage: "doc.on.doc") {},
                .divider,
                .action("Delete", systemImage: "trash", role: .destructive) {}
            ])
        assert(view: view, name: "hostLayoutUnchanged_light")
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 200, height: CGFloat = 80,
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
