#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxBottomSheetTests: XCTestCase {

    func test_simpleContent_light() {
        let view = ParadoxBottomSheetContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Filters").font(.headline)
                Text("Choose filters to refine results.").foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        assert(view: view, name: "simpleContent_light")
    }

    func test_listContent_light() {
        let view = ParadoxBottomSheetContainer {
            VStack(spacing: 0) {
                ForEach(["Newest", "Oldest", "Most liked"], id: \.self) { row in
                    HStack {
                        Text(row)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    Divider()
                }
            }
        }
        assert(view: view, name: "listContent_light", height: 280)
    }

    func test_simpleContent_dark() {
        let view = ParadoxBottomSheetContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Filters").font(.headline)
                Text("Choose filters to refine results.").foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .preferredColorScheme(.dark)
        assert(view: view, name: "simpleContent_dark", scheme: .dark)
    }

    func test_detent_mapping() {
        XCTAssertEqual(ParadoxBottomSheetDetent.small.presentationDetent,  .height(240))
        XCTAssertEqual(ParadoxBottomSheetDetent.medium.presentationDetent, .medium)
        XCTAssertEqual(ParadoxBottomSheetDetent.large.presentationDetent,  .large)
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 390, height: CGFloat = 200,
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
