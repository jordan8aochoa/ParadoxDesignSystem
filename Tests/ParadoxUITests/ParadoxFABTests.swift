#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxFABTests: XCTestCase {

    func test_circular_primary_light() {
        let view = ParadoxFAB.circular(systemImage: "plus", accessibilityLabel: "Create") {}
        assert(view: view, name: "circular_primary_light")
    }

    func test_circular_surface_light() {
        let view = ParadoxFAB.circular(systemImage: "plus", tone: .surface) {}
        assert(view: view, name: "circular_surface_light")
    }

    func test_extended_primary_light() {
        let view = ParadoxFAB.extended(systemImage: "plus", title: "New") {}
        assert(view: view, name: "extended_primary_light", width: 160)
    }

    func test_extended_surface_light() {
        let view = ParadoxFAB.extended(systemImage: "square.and.pencil", title: "Compose", tone: .surface) {}
        assert(view: view, name: "extended_surface_light", width: 180)
    }

    func test_circular_primary_dark() {
        let view = ParadoxFAB.circular(systemImage: "plus") {}
            .preferredColorScheme(.dark)
        assert(view: view, name: "circular_primary_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 100, height: CGFloat = 80,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .padding(12)
            .frame(width: width, height: height)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
