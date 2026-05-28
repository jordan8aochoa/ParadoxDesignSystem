#if canImport(UIKit)
import XCTest
import SwiftUI
@testable import ParadoxGlass

@MainActor
final class ParadoxGlassTests: XCTestCase {

    // Snapshot tests for glass effects only render meaningfully on iOS 26+
    // simulators against a backdrop with real content behind them. These
    // tests just verify that the module builds, the version constant is
    // correct, and the public types resolve under the @available gate.

    func test_versionString() {
        XCTAssertEqual(ParadoxGlass.version, "0.1.0")
    }

    @available(iOS 26, *)
    func test_glassModifierBuilds() {
        // Touching the type confirms the @available surface compiles on iOS 26+.
        let modifier = ParadoxGlassModifier(radius: .lg)
        _ = modifier
    }

    @available(iOS 26, *)
    func test_glassCardBuilds() {
        let card = ParadoxGlassCard { Text("Hello") }
        _ = card.body
    }

    @available(iOS 26, *)
    func test_glassContainerBuilds() {
        let container = ParadoxGlassContainer { Text("Hello") }
        _ = container.body
    }
}
#endif
