#if canImport(UIKit)
import XCTest
import SwiftUI
import SnapshotTesting
@testable import ParadoxUI

@MainActor
final class ParadoxMotionTests: XCTestCase {

    // MARK: - Shimmer (visual rest state — animation is time-based and won't
    //         render deterministically in a snapshot, so we just confirm the
    //         modifier doesn't break the host shape's layout)

    func test_shimmer_appliedToCapsule_light() {
        let view = Capsule()
            .fill(.clear)
            .frame(width: 200, height: 16)
            .paradoxShimmer()
        assert(view: view, name: "shimmer_appliedToCapsule_light",
               width: 220, height: 36)
    }

    // MARK: - Pulse — also time-based; snapshot the host at rest state

    func test_pulse_appliedToDot_light() {
        let view = Circle()
            .fill(.green)
            .frame(width: 12, height: 12)
            .paradoxPulse()
        assert(view: view, name: "pulse_appliedToDot_light",
               width: 40, height: 40)
    }

    // MARK: - Stagger — verify modifier doesn't break layout for a typical list

    func test_stagger_threeRows_light() {
        let view = VStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                HStack {
                    Text("Row \(i)")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.gray.opacity(0.1))
                .paradoxStagger(index: i)
            }
        }
        assert(view: view, name: "stagger_threeRows_light",
               width: 280, height: 160)
    }

    // MARK: - Celebrate — verify the modifier wraps without breaking layout

    func test_celebrate_appliedToCheckmark_light() {
        let view = Image(systemName: "checkmark.seal.fill")
            .font(.system(size: 40))
            .foregroundStyle(.green)
            .paradoxCelebrate(trigger: 0)
        assert(view: view, name: "celebrate_appliedToCheckmark_light",
               width: 80, height: 80)
    }

    // MARK: - Phase value sanity

    func test_celebratePhase_allCasesPresent() {
        XCTAssertEqual(ParadoxCelebrateModifier<Int>.Phase.allCases.count, 3)
    }

    func test_celebratePhase_bloomScalesUp() {
        XCTAssertGreaterThan(
            ParadoxCelebrateModifier<Int>.Phase.bloom.scale,
            ParadoxCelebrateModifier<Int>.Phase.rest.scale
        )
    }

    // MARK: - Helpers

    private func assert<V: View>(view: V, name: String,
                                 width: CGFloat, height: CGFloat,
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
