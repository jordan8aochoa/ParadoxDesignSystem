import Foundation
#if canImport(CoreText)
import CoreText
#endif

/// One-shot registrar for Apple Garamond bundled with `ParadoxTokens`.
///
/// SPM resources are not automatically registered with the OS font manager,
/// so `Font.custom("AppleGaramond-Regular", ...)` would return a fallback
/// unless we explicitly register the .ttf files. We do that once per process
/// via lazy static initialization.
///
/// Apps generally don't need to call this directly — `ParadoxDefaultTheme.init()`
/// touches `ParadoxFonts.registrationToken` for you. If you build a custom
/// `ParadoxTheme` conformer that bypasses `ParadoxDefaultTheme`, touch the token
/// once at app startup yourself:
///
/// ```swift
/// @main
/// struct MyApp: App {
///     init() { _ = ParadoxFonts.registrationToken }
///     var body: some Scene { ... }
/// }
/// ```
public enum ParadoxFonts {
    /// PostScript names that the bundled .ttf files register under. Use these
    /// with `Font.custom(name:size:relativeTo:)` after touching `registrationToken`.
    public enum PostScript {
        public static let regular      = "AppleGaramond"
        public static let italic       = "AppleGaramond-Italic"
        public static let bold         = "AppleGaramond-Bold"
        public static let boldItalic   = "AppleGaramond-BoldItalic"
        public static let light        = "AppleGaramond-Light"
        public static let lightItalic  = "AppleGaramond-LightItalic"
    }

    /// Touch this exactly once per process to register all bundled fonts.
    /// Swift's lazy static initialization guarantees the work happens once.
    public static let registrationToken: Void = {
        _ = registerAll()
    }()

    /// Returns the list of filenames the registrar attempted to load.
    /// Use this in tests to assert the bundle is wired up correctly.
    @discardableResult
    public static func registerAll() -> [String] {
        #if canImport(CoreText)
        let bundle = Bundle.module
        let ttf = bundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []
        let otf = bundle.urls(forResourcesWithExtension: "otf", subdirectory: nil) ?? []
        let urls = ttf + otf

        guard !urls.isEmpty else { return [] }

        var errors: Unmanaged<CFArray>?
        let ok = CTFontManagerRegisterFontsForURLs(urls as CFArray, .process, &errors)
        if !ok { errors?.release() }
        // A `false` here is non-fatal: most commonly "font already registered"
        // when tests re-import the bundle. Real failures only matter at first
        // launch and would surface as Font.custom returning the system fallback.

        return urls.map { $0.lastPathComponent }
        #else
        return []
        #endif
    }
}
