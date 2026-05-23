import Testing
import Foundation
@testable import ParadoxTokens

@Suite("ParadoxDefaultTheme")
struct ParadoxDefaultThemeTests {

    @Test("default theme resolves expected scalars")
    func defaultThemeResolves() {
        let theme = ParadoxDefaultTheme()
        #expect(theme.spacing.lg == 16)
        #expect(theme.spacing.xxxxl == 64)
        #expect(theme.radius.md == 8)
    }

    @Test("generated colors are valid hex pairs",
          arguments: [
            GeneratedColor.backgroundPrimary,
            GeneratedColor.surfacePrimary,
            GeneratedColor.textPrimary,
            GeneratedColor.borderDefault,
            GeneratedColor.statusError,
            GeneratedColor.accentPrimary
          ] as [GeneratedColor.Pair])
    func generatedColorsAreValidHex(pair: GeneratedColor.Pair) {
        #expect(Self.isValidHex(pair.light), "invalid light hex: \(pair.light)")
        #expect(Self.isValidHex(pair.dark),  "invalid dark hex: \(pair.dark)")
    }

    @Test("spacing scale is strictly ascending")
    func spacingScaleAscending() {
        let s = SpacingScale()
        let values = s.allValues.map { $0.value }
        for i in 1..<values.count {
            #expect(values[i - 1] < values[i], "spacing must be strictly ascending")
        }
    }

    @Test("radius scale is ascending up to .pill")
    func radiusScaleAscending() {
        let r = RadiusScale()
        let bounded = r.allValues.dropLast().map { $0.value }
        for i in 1..<bounded.count {
            #expect(bounded[i - 1] < bounded[i], "radius must be ascending up to .pill")
        }
        #expect(r.pill > r.xxl)
    }

    @Test("motion returns nil when reduce-motion is enabled")
    func motionReduceMotion() {
        let motion = MotionScale()
        #expect(motion.resolve(motion.spring.snappy, reduceMotion: true) == nil)
        #expect(motion.resolve(motion.spring.snappy, reduceMotion: false) != nil)
    }

    @Test("elevation radii are non-decreasing across levels")
    func elevationLevelsIncreaseInDepth() {
        let e = ElevationScale()
        let radii = e.allValues.map { $0.value.radius }
        for i in 1..<radii.count {
            #expect(radii[i - 1] <= radii[i], "elevation radius must be non-decreasing")
        }
    }

    @Test("theme is a value type — independent instances are equal in scalars")
    func themeIsValueType() {
        let a: any ParadoxTheme = ParadoxDefaultTheme()
        let b: any ParadoxTheme = ParadoxDefaultTheme()
        #expect(a.spacing.lg == b.spacing.lg)
    }

    // MARK: - Helpers

    private static func isValidHex(_ s: String) -> Bool {
        var t = s
        if t.hasPrefix("#") { t.removeFirst() }
        guard t.count == 6 || t.count == 8 else { return false }
        let hex = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        return t.unicodeScalars.allSatisfy { hex.contains($0) }
    }
}
