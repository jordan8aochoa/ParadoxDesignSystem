#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxTextFieldTests: XCTestCase {

    func test_empty_light() {
        let view = TextField("Email", text: .constant(""))
            .paradoxTextFieldStyle()
        assert(view: view, name: "empty_light")
    }

    func test_filled_light() {
        let view = TextField("Email", text: .constant("jordan@example.com"))
            .paradoxTextFieldStyle()
        assert(view: view, name: "filled_light")
    }

    func test_disabled_light() {
        let view = TextField("Email", text: .constant("locked"))
            .paradoxTextFieldStyle()
            .disabled(true)
        assert(view: view, name: "disabled_light")
    }

    func test_errorMessage_light() {
        let view = TextField("Email", text: .constant("bad"))
            .paradoxTextFieldStyle()
            .paradoxFieldMessage(.error("Please enter a valid email"))
        assert(view: view, name: "errorMessage_light", height: 120)
    }

    func test_warningMessage_light() {
        let view = TextField("Password", text: .constant("123"))
            .paradoxTextFieldStyle()
            .paradoxFieldMessage(.warning("Weak password"))
        assert(view: view, name: "warningMessage_light", height: 120)
    }

    func test_helpMessage_light() {
        let view = TextField("Email", text: .constant(""))
            .paradoxTextFieldStyle()
            .paradoxFieldMessage(.help("We'll never share this."))
        assert(view: view, name: "helpMessage_light", height: 120)
    }

    func test_filled_dark() {
        let view = TextField("Email", text: .constant("jordan@example.com"))
            .paradoxTextFieldStyle()
            .preferredColorScheme(.dark)
        assert(view: view, name: "filled_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 340, height: CGFloat = 80,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .padding(20)
            .frame(width: width, height: height)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
