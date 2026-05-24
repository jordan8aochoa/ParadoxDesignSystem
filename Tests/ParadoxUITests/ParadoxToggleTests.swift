#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxToggleTests: XCTestCase {

    func test_off_light() {
        assert(view: ParadoxToggle(isOn: .constant(false)), name: "off_light")
    }

    func test_on_light() {
        assert(view: ParadoxToggle(isOn: .constant(true)), name: "on_light")
    }

    func test_disabled_off_light() {
        assert(view: ParadoxToggle(isOn: .constant(false)).disabled(true),
               name: "disabled_off_light")
    }

    func test_disabled_on_light() {
        assert(view: ParadoxToggle(isOn: .constant(true)).disabled(true),
               name: "disabled_on_light")
    }

    func test_off_dark() {
        assert(view: ParadoxToggle(isOn: .constant(false)).preferredColorScheme(.dark),
               name: "off_dark", scheme: .dark)
    }

    func test_on_dark() {
        assert(view: ParadoxToggle(isOn: .constant(true)).preferredColorScheme(.dark),
               name: "on_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let width: CGFloat = 100
        let height: CGFloat = 60
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .padding(8)
            .frame(width: width, height: height)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
