import CoreGraphics

/// Corner radius scale. `pill` evaluates to a sentinel that callers should clamp
/// (e.g., `min(height / 2, .infinity)`).
public struct RadiusScale: Sendable {
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let pill: CGFloat

    public init(
        xs: CGFloat = 4, sm: CGFloat = 6, md: CGFloat = 8, lg: CGFloat = 12,
        xl: CGFloat = 16, xxl: CGFloat = 24, pill: CGFloat = .infinity
    ) {
        self.xs = xs; self.sm = sm; self.md = md; self.lg = lg
        self.xl = xl; self.xxl = xxl; self.pill = pill
    }

    public var allValues: [(name: String, value: CGFloat)] {
        [("xs", xs), ("sm", sm), ("md", md), ("lg", lg), ("xl", xl), ("xxl", xxl), ("pill", pill)]
    }
}
