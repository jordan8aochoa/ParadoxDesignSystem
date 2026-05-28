#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxSearchBarTests: XCTestCase {

    func test_empty_light() {
        let view = StatefulSearch(initial: "")
        assert(view: view, name: "empty_light")
    }

    func test_withText_light() {
        let view = StatefulSearch(initial: "hello")
        assert(view: view, name: "withText_light")
    }

    func test_customPlaceholder_light() {
        let view = StatefulSearch(initial: "", placeholder: "Search messages")
        assert(view: view, name: "customPlaceholder_light")
    }

    func test_empty_dark() {
        let view = StatefulSearch(initial: "").preferredColorScheme(.dark)
        assert(view: view, name: "empty_dark", scheme: .dark)
    }

    func test_withText_dark() {
        let view = StatefulSearch(initial: "query").preferredColorScheme(.dark)
        assert(view: view, name: "withText_dark", scheme: .dark)
    }

    // MARK: - Stateful host

    private struct StatefulSearch: View {
        @State var text: String
        let placeholder: String
        init(initial: String, placeholder: String = "Search") {
            _text = State(initialValue: initial)
            self.placeholder = placeholder
        }
        var body: some View {
            ParadoxSearchBar(text: $text, placeholder: placeholder)
        }
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 360, height: CGFloat = 52,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .padding(8)
            .frame(width: width)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
