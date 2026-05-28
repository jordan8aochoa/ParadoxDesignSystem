#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxToastTests: XCTestCase {

    func test_info_light() {
        let view = ParadoxToast(model: .init(title: "Heads up", message: "Sync resumed.", variant: .info))
        assert(view: view, name: "info_light")
    }

    func test_success_light() {
        let view = ParadoxToast(model: .init(title: "Saved", variant: .success))
        assert(view: view, name: "success_light", height: 64)
    }

    func test_warning_light() {
        let view = ParadoxToast(model: .init(title: "Low battery", message: "20% remaining.", variant: .warning))
        assert(view: view, name: "warning_light")
    }

    func test_error_light() {
        let view = ParadoxToast(model: .init(title: "Couldn't save", message: "Check your connection.", variant: .error))
        assert(view: view, name: "error_light")
    }

    func test_titleOnly_light() {
        let view = ParadoxToast(model: .init(title: "Copied to clipboard", variant: .success))
        assert(view: view, name: "titleOnly_light", height: 64)
    }

    func test_success_dark() {
        let view = ParadoxToast(model: .init(title: "Saved", message: "Changes applied.", variant: .success))
            .preferredColorScheme(.dark)
        assert(view: view, name: "success_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 360, height: CGFloat = 80,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .padding(16)
            .frame(width: width)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height + 32)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
