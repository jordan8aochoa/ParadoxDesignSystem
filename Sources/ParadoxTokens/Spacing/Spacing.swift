import CoreGraphics

/// 8pt grid spacing scale. Prefer these over hard-coded numbers.
public struct SpacingScale: Sendable {
    public let xxs: CGFloat
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let xxxl: CGFloat
    public let xxxxl: CGFloat

    public init(
        xxs: CGFloat = 2, xs: CGFloat = 4, sm: CGFloat = 8, md: CGFloat = 12,
        lg: CGFloat = 16, xl: CGFloat = 24, xxl: CGFloat = 32,
        xxxl: CGFloat = 48, xxxxl: CGFloat = 64
    ) {
        self.xxs = xxs; self.xs = xs; self.sm = sm; self.md = md
        self.lg = lg; self.xl = xl; self.xxl = xxl
        self.xxxl = xxxl; self.xxxxl = xxxxl
    }

    /// All values in ascending order — convenient for tests and for rendering specimens.
    public var allValues: [(name: String, value: CGFloat)] {
        [
            ("xxs", xxs), ("xs", xs), ("sm", sm), ("md", md), ("lg", lg),
            ("xl", xl), ("xxl", xxl), ("xxxl", xxxl), ("xxxxl", xxxxl)
        ]
    }
}
