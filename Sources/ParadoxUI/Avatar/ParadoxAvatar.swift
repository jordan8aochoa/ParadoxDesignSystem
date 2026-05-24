import SwiftUI
import ParadoxTokens

/// Circular avatar with `AsyncImage` loading and initials fallback. Initials
/// background is deterministically hashed to one of 8 palette colors so the
/// same person always gets the same color across sessions.
///
/// Sizing honors SwiftUI `.controlSize`:
/// - `.mini` → 24pt
/// - `.small` → 32pt
/// - `.regular` (default) → 40pt
/// - `.large`, `.extraLarge` → 56pt
///
/// ```swift
/// ParadoxAvatar(url: user.imageURL, fallback: user.initials)
///     .controlSize(.large)
/// ```
public struct ParadoxAvatar: View {
    private let url: URL?
    private let fallback: String?

    public init(url: URL?, fallback: String? = nil) {
        self.url = url
        self.fallback = fallback
    }

    @Environment(\.paradoxTheme) private var theme
    @Environment(\.controlSize) private var controlSize

    public var body: some View {
        ZStack {
            Circle().fill(backgroundColor)
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty, .failure:
                        initialsView
                    @unknown default:
                        initialsView
                    }
                }
            } else {
                initialsView
            }
        }
        .frame(width: diameter, height: diameter)
        .clipShape(Circle())
        .accessibilityElement()
        .accessibilityLabel(fallback ?? "Avatar")
    }

    private var initialsView: some View {
        Group {
            if let initials, !initials.isEmpty {
                Text(initials)
                    .font(.system(size: diameter * 0.4, weight: .semibold, design: .default))
                    .foregroundStyle(foregroundColor)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: diameter * 0.55))
                    .foregroundStyle(theme.color.text.tertiary)
            }
        }
    }

    private var initials: String? {
        guard let fallback else { return nil }
        return String(fallback.prefix(2)).uppercased()
    }

    private var diameter: CGFloat {
        switch controlSize {
        case .mini:                  return 24
        case .small:                 return 32
        case .regular:               return 40
        case .large, .extraLarge:    return 56
        @unknown default:            return 40
        }
    }

    // MARK: - Hashed palette

    private static let palette: [Color] = [
        Color(red: 0.97, green: 0.44, blue: 0.44), // rose
        Color(red: 0.98, green: 0.74, blue: 0.14), // amber
        Color(red: 0.06, green: 0.72, blue: 0.50), // emerald
        Color(red: 0.07, green: 0.72, blue: 0.65), // teal
        Color(red: 0.22, green: 0.74, blue: 0.97), // sky
        Color(red: 0.39, green: 0.40, blue: 0.95), // indigo
        Color(red: 0.55, green: 0.36, blue: 0.96), // violet
        Color(red: 0.93, green: 0.28, blue: 0.60)  // pink
    ]

    private var paletteColor: Color {
        guard let initials, !initials.isEmpty else {
            return theme.color.surface.secondary
        }
        // djb2-ish: simple, deterministic, no hashing library needed
        var hash: UInt32 = 5381
        for scalar in initials.unicodeScalars {
            hash = (hash &* 33) &+ scalar.value
        }
        return Self.palette[Int(hash % UInt32(Self.palette.count))]
    }

    private var backgroundColor: Color {
        guard let initials, !initials.isEmpty else {
            return theme.color.surface.secondary
        }
        return paletteColor.opacity(0.18)
    }

    private var foregroundColor: Color {
        paletteColor
    }
}
