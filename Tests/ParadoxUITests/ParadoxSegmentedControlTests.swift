#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxSegmentedControlTests: XCTestCase {

    private enum Mode: Hashable, Sendable { case day, week, month }

    private var segments: [ParadoxSegmentedControl<Mode>.Segment] {
        [
            .init(tag: .day,   label: "Day"),
            .init(tag: .week,  label: "Week"),
            .init(tag: .month, label: "Month")
        ]
    }

    func test_selected_first_light() {
        let view = StatefulSegmented(initial: .day, segments: segments)
        assert(view: view, name: "selected_first_light")
    }

    func test_selected_middle_light() {
        let view = StatefulSegmented(initial: .week, segments: segments)
        assert(view: view, name: "selected_middle_light")
    }

    func test_selected_last_light() {
        let view = StatefulSegmented(initial: .month, segments: segments)
        assert(view: view, name: "selected_last_light")
    }

    func test_small_size_light() {
        let view = StatefulSegmented(initial: .week, segments: segments)
            .controlSize(.small)
        assert(view: view, name: "small_size_light", height: 36)
    }

    func test_selected_middle_dark() {
        let view = StatefulSegmented(initial: .week, segments: segments)
            .preferredColorScheme(.dark)
        assert(view: view, name: "selected_middle_dark", scheme: .dark)
    }

    // MARK: - Stateful host

    private struct StatefulSegmented: View {
        @State var selection: Mode
        let segments: [ParadoxSegmentedControl<Mode>.Segment]
        init(initial: Mode, segments: [ParadoxSegmentedControl<Mode>.Segment]) {
            _selection = State(initialValue: initial)
            self.segments = segments
        }
        var body: some View {
            ParadoxSegmentedControl(selection: $selection, segments: segments)
        }
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat = 320, height: CGFloat = 44,
                                 scheme: ColorScheme = .light,
                                 file: StaticString = #file, line: UInt = #line) {
        let wrapped = view.paradoxTheme(ParadoxDefaultTheme())
            .padding(8)
            .frame(width: width)
        let host = UIHostingController(rootView: wrapped)
        host.overrideUserInterfaceStyle = (scheme == .dark) ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: width, height: height + 16)
        assertSnapshot(of: host, as: .image, named: name, file: file, line: line)
    }
}
#endif
