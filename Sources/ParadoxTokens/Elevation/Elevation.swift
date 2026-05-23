import SwiftUI

/// Elevation levels mapped to shadow specs. Tuned for both light and dark surfaces.
public struct ElevationScale: Sendable {
    public let level0: Shadow
    public let level1: Shadow
    public let level2: Shadow
    public let level3: Shadow
    public let level4: Shadow

    public init(
        level0: Shadow = Shadow(color: .clear, radius: 0, x: 0, y: 0),
        level1: Shadow = Shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1),
        level2: Shadow = Shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2),
        level3: Shadow = Shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 6),
        level4: Shadow = Shadow(color: .black.opacity(0.16), radius: 32, x: 0, y: 12)
    ) {
        self.level0 = level0; self.level1 = level1; self.level2 = level2
        self.level3 = level3; self.level4 = level4
    }

    public var allValues: [(name: String, value: Shadow)] {
        [("level0", level0), ("level1", level1), ("level2", level2), ("level3", level3), ("level4", level4)]
    }

    public struct Shadow: Sendable {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
        public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            self.color = color; self.radius = radius; self.x = x; self.y = y
        }
    }
}

public extension View {
    func paradoxShadow(_ shadow: ElevationScale.Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
