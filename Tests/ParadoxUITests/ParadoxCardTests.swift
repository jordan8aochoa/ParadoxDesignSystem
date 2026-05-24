#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxCardTests: XCTestCase {

    func test_default_cozy_noElevation_light() {
        assert(view: sampleCard(), name: "default_cozy_noElevation_light")
    }

    func test_compact_padding_light() {
        assert(view: sampleCard().paradoxCardPadding(.compact),
               name: "compact_padding_light")
    }

    func test_comfortable_padding_light() {
        assert(view: sampleCard().paradoxCardPadding(.comfortable),
               name: "comfortable_padding_light")
    }

    func test_level2_elevation_light() {
        assert(view: sampleCard().paradoxCardElevation(.level2),
               name: "level2_elevation_light", height: 200)
    }

    func test_level4_elevation_light() {
        assert(view: sampleCard().paradoxCardElevation(.level4),
               name: "level4_elevation_light", height: 220)
    }

    func test_default_dark() {
        assert(view: sampleCard().preferredColorScheme(.dark),
               name: "default_dark", scheme: .dark)
    }

    // MARK: - Helpers

    private func sampleCard() -> some View {
        ParadoxCard {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome")
                    .font(.headline)
                Text("Your trip starts here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 340, height: CGFloat = 160,
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
