#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxAvatarTests: XCTestCase {

    // Sizes (initials, no URL)
    func test_mini_light() {
        assert(view: ParadoxAvatar(url: nil, fallback: "JA").controlSize(.mini),
               name: "mini_light", width: 40, height: 40)
    }
    func test_small_light() {
        assert(view: ParadoxAvatar(url: nil, fallback: "JA").controlSize(.small),
               name: "small_light", width: 48, height: 48)
    }
    func test_regular_light() {
        assert(view: ParadoxAvatar(url: nil, fallback: "JA"),
               name: "regular_light", width: 60, height: 60)
    }
    func test_large_light() {
        assert(view: ParadoxAvatar(url: nil, fallback: "JA").controlSize(.large),
               name: "large_light", width: 76, height: 76)
    }

    // Palette variety (same size, different initials → different colors)
    func test_palette_JA_light() { assert(view: ParadoxAvatar(url: nil, fallback: "JA"), name: "palette_JA_light") }
    func test_palette_MS_light() { assert(view: ParadoxAvatar(url: nil, fallback: "MS"), name: "palette_MS_light") }
    func test_palette_TK_light() { assert(view: ParadoxAvatar(url: nil, fallback: "TK"), name: "palette_TK_light") }
    func test_palette_AB_light() { assert(view: ParadoxAvatar(url: nil, fallback: "AB"), name: "palette_AB_light") }

    // No initials → person.fill SF Symbol fallback
    func test_noInitials_personFallback_light() {
        assert(view: ParadoxAvatar(url: nil, fallback: nil),
               name: "noInitials_personFallback_light")
    }

    // Dark
    func test_regular_dark() {
        assert(view: ParadoxAvatar(url: nil, fallback: "JA").preferredColorScheme(.dark),
               name: "regular_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 60, height: CGFloat = 60,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
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
