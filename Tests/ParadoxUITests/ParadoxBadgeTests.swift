#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxBadgeTests: XCTestCase {

    // Counts
    func test_count_small_light()   { assert(view: ParadoxBadge(count: 1),   name: "count_1_light") }
    func test_count_double_light()  { assert(view: ParadoxBadge(count: 12),  name: "count_12_light") }
    func test_count_99_light()      { assert(view: ParadoxBadge(count: 99),  name: "count_99_light") }
    func test_count_overflow_light(){ assert(view: ParadoxBadge(count: 247), name: "count_overflow_light") }

    // Text
    func test_text_pro_light()      { assert(view: ParadoxBadge("Pro"),  name: "text_pro_light") }
    func test_text_new_light()      { assert(view: ParadoxBadge("New", variant: .success), name: "text_new_light") }

    // Variants
    func test_variant_neutral_light() { assert(view: ParadoxBadge(count: 3, variant: .neutral), name: "variant_neutral_light") }
    func test_variant_accent_light()  { assert(view: ParadoxBadge(count: 3, variant: .accent),  name: "variant_accent_light") }
    func test_variant_warning_light() { assert(view: ParadoxBadge(count: 3, variant: .warning), name: "variant_warning_light") }

    // Overlay
    func test_overlay_on_icon_light() {
        let view = Image(systemName: "bell.fill")
            .font(.system(size: 32))
            .paradoxBadge(count: 12)
        assert(view: view, name: "overlay_on_icon_light", width: 80, height: 80)
    }

    // Dark
    func test_count_dark() {
        assert(view: ParadoxBadge(count: 12).preferredColorScheme(.dark),
               name: "count_12_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 80, height: CGFloat = 40,
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
