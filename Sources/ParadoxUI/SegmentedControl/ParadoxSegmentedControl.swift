import SwiftUI
import ParadoxTokens

/// A segmented selector with a sliding pill indicator. Generic over `Tag` so
/// callers can use enums, strings, or any `Hashable & Sendable` value.
///
/// Two visual densities via `.controlSize`:
/// - `.small` → 28pt height
/// - `.regular` (default) → 36pt height
///
/// ```swift
/// @State var mode: Mode = .day
/// ParadoxSegmentedControl(selection: $mode, segments: [
///     .init(tag: .day,   label: "Day"),
///     .init(tag: .week,  label: "Week"),
///     .init(tag: .month, label: "Month")
/// ])
/// ```
public struct ParadoxSegmentedControl<Tag: Hashable & Sendable>: View {

    public struct Segment: Identifiable, Sendable {
        public let id: Tag
        public let tag: Tag
        public let label: String

        public init(tag: Tag, label: String) {
            self.id = tag
            self.tag = tag
            self.label = label
        }
    }

    @Binding private var selection: Tag
    private let segments: [Segment]

    public init(selection: Binding<Tag>, segments: [Segment]) {
        self._selection = selection
        self.segments = segments
    }

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.controlSize) private var controlSize

    public var body: some View {
        let metrics = sizeMetrics(for: controlSize, theme: theme)

        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(segments) { segment in
                    segmentButton(segment, height: metrics.height)
                }
            }
            .background {
                RoundedRectangle(cornerRadius: metrics.outerCornerRadius, style: .continuous)
                    .fill(theme.color.surface.secondary)
            }
            .overlay {
                indicatorOverlay(metrics: metrics)
            }
        }
        .accessibilityElement(children: .contain)
        .animation(theme.motion.spring.snappy, value: selection)
    }

    private func segmentButton(_ segment: Segment, height: CGFloat) -> some View {
        Button {
            if selection != segment.tag {
                selection = segment.tag
            }
        } label: {
            Text(segment.label)
                .paradoxText(theme.typography.label)
                .fontWeight(selection == segment.tag ? .semibold : .regular)
                .foregroundStyle(selection == segment.tag
                                 ? theme.color.text.primary
                                 : theme.color.text.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(segment.label)
        .accessibilityAddTraits(selection == segment.tag ? [.isSelected, .isButton] : .isButton)
    }

    private func indicatorOverlay(metrics: SizeMetrics) -> some View {
        GeometryReader { proxy in
            let count = max(segments.count, 1)
            let segmentWidth = proxy.size.width / CGFloat(count)
            let index = selectedIndex
            RoundedRectangle(cornerRadius: metrics.innerCornerRadius, style: .continuous)
                .fill(theme.color.background.elevated)
                .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                .padding(2)
                .frame(width: segmentWidth)
                .offset(x: segmentWidth * CGFloat(index))
                .allowsHitTesting(false)
        }
        .frame(height: metrics.height)
    }

    private var selectedIndex: Int {
        segments.firstIndex(where: { $0.tag == selection }) ?? 0
    }
}

// MARK: - Sizing

private struct SizeMetrics {
    let height: CGFloat
    let outerCornerRadius: CGFloat
    let innerCornerRadius: CGFloat
}

private func sizeMetrics(for controlSize: ControlSize, theme: any ParadoxTheme) -> SizeMetrics {
    switch controlSize {
    case .mini, .small:
        return SizeMetrics(height: 28,
                           outerCornerRadius: theme.radius.md,
                           innerCornerRadius: theme.radius.sm)
    case .regular, .large, .extraLarge:
        return SizeMetrics(height: 36,
                           outerCornerRadius: theme.radius.lg,
                           innerCornerRadius: theme.radius.md)
    @unknown default:
        return SizeMetrics(height: 36,
                           outerCornerRadius: theme.radius.lg,
                           innerCornerRadius: theme.radius.md)
    }
}
