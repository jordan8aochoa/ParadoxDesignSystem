#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxListItemTests: XCTestCase {

    func test_titleOnly_light() {
        assert(view: ParadoxListItem(title: "Notifications"), name: "titleOnly_light")
    }

    func test_titleSubtitle_light() {
        assert(view: ParadoxListItem(title: "Notifications", subtitle: "12 unread"),
               name: "titleSubtitle_light")
    }

    func test_leadingIcon_light() {
        let view = ParadoxListItem(
            title: "Notifications",
            leading: { ParadoxAccessory.icon("bell.fill") }
        )
        assert(view: view, name: "leadingIcon_light")
    }

    func test_autoChevron_light() {
        // onTap set, no trailing → auto chevron rendered.
        let view = ParadoxListItem(
            title: "Notifications",
            leading: { ParadoxAccessory.icon("bell.fill") },
            onTap: {}
        )
        assert(view: view, name: "autoChevron_light")
    }

    func test_explicitChevron_light() {
        // No onTap, but explicit chevron trailing — should look identical to auto.
        let view = ParadoxListItem(
            title: "Notifications",
            leading: { ParadoxAccessory.icon("bell.fill") },
            trailing: { ParadoxAccessory.chevron }
        )
        assert(view: view, name: "explicitChevron_light")
    }

    func test_toggle_light() {
        let view = ParadoxListItem(
            title: "Dark Mode",
            leading: { ParadoxAccessory.icon("moon.fill") },
            trailing: { ParadoxAccessory.toggle(.constant(true)) }
        )
        assert(view: view, name: "toggle_light")
    }

    func test_value_light() {
        let view = ParadoxListItem(
            title: "Subscription",
            subtitle: "Renews May 30",
            leading: { ParadoxAccessory.icon("creditcard.fill") },
            trailing: { ParadoxAccessory.value("$9.99/mo") }
        )
        assert(view: view, name: "value_light", height: 80)
    }

    func test_avatar_light() {
        let view = ParadoxListItem(
            title: "Jordan Aguirre",
            subtitle: "homeloansbyjordan@gmail.com",
            leading: { ParadoxAccessory.avatar(nil, fallback: "JA") },
            onTap: {}
        )
        assert(view: view, name: "avatar_light", height: 80)
    }

    func test_titleSubtitle_dark() {
        let view = ParadoxListItem(
            title: "Notifications",
            subtitle: "12 unread",
            leading: { ParadoxAccessory.icon("bell.fill") },
            onTap: {}
        )
        assert(view: view.preferredColorScheme(.dark),
               name: "titleSubtitle_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 375, height: CGFloat = 64,
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
