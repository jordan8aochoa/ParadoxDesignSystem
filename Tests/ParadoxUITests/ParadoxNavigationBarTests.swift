#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxNavigationBarTests: XCTestCase {

    func test_compact_titleOnly_light() {
        assert(view: ParadoxNavigationBar(title: "Inbox"),
               name: "compact_titleOnly_light", height: 44)
    }

    func test_compact_titleSubtitle_light() {
        assert(view: ParadoxNavigationBar(title: "Inbox", subtitle: "12 unread"),
               name: "compact_titleSubtitle_light", height: 44)
    }

    func test_compact_withLeadingTrailing_light() {
        let view = ParadoxNavigationBar(
            title: "Inbox",
            leading: { Image(systemName: "chevron.left") },
            trailing: { Image(systemName: "square.and.pencil") }
        )
        assert(view: view, name: "compact_withLeadingTrailing_light", height: 44)
    }

    func test_large_titleOnly_light() {
        assert(view: ParadoxNavigationBar(title: "Inbox", style: .large),
               name: "large_titleOnly_light", height: 110)
    }

    func test_large_titleSubtitle_light() {
        assert(view: ParadoxNavigationBar(title: "Inbox", subtitle: "12 unread", style: .large),
               name: "large_titleSubtitle_light", height: 120)
    }

    func test_compact_dark() {
        assert(view: ParadoxNavigationBar(title: "Inbox").preferredColorScheme(.dark),
               name: "compact_dark", height: 44, scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 390, height: CGFloat,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .frame(width: width)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
