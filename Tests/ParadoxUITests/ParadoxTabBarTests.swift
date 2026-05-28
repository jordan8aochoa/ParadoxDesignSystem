#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxTabBarTests: XCTestCase {

    private enum Tab: Hashable, Sendable { case home, search, inbox, profile }

    private func items(badge: Int? = nil) -> [ParadoxTabBar<Tab>.Item] {
        [
            .init(tag: .home,    systemImage: "house.fill",      title: "Home"),
            .init(tag: .search,  systemImage: "magnifyingglass", title: "Search"),
            .init(tag: .inbox,   systemImage: "tray.fill",       title: "Inbox", badge: badge),
            .init(tag: .profile, systemImage: "person.fill",     title: "Me")
        ]
    }

    func test_selected_home_light() {
        let view = StatefulTabBar(initial: .home, items: items())
        assert(view: view, name: "selected_home_light")
    }

    func test_selected_search_light() {
        let view = StatefulTabBar(initial: .search, items: items())
        assert(view: view, name: "selected_search_light")
    }

    func test_with_badge_light() {
        let view = StatefulTabBar(initial: .home, items: items(badge: 12))
        assert(view: view, name: "with_badge_light")
    }

    func test_selected_inbox_dark() {
        let view = StatefulTabBar(initial: .inbox, items: items(badge: 3))
            .preferredColorScheme(.dark)
        assert(view: view, name: "selected_inbox_dark", scheme: .dark)
    }

    // MARK: - Stateful host

    private struct StatefulTabBar: View {
        @State var selection: Tab
        let items: [ParadoxTabBar<Tab>.Item]
        init(initial: Tab, items: [ParadoxTabBar<Tab>.Item]) {
            _selection = State(initialValue: initial)
            self.items = items
        }
        var body: some View {
            ParadoxTabBar(selection: $selection, items: items)
        }
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 390, height: CGFloat = 64,
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
