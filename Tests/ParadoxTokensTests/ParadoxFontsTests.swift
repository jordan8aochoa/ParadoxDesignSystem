import Testing
import Foundation
#if canImport(UIKit)
import UIKit
#endif
@testable import ParadoxTokens

@Suite("ParadoxFonts")
struct ParadoxFontsTests {

    @Test("font bundle contains the expected Apple Garamond .ttf files")
    func bundleContainsFonts() {
        let registered = ParadoxFonts.registerAll()
        let expected = [
            "AppleGaramond-Regular.ttf",
            "AppleGaramond-Italic.ttf",
            "AppleGaramond-Bold.ttf",
            "AppleGaramond-BoldItalic.ttf",
            "AppleGaramond-Light.ttf",
            "AppleGaramond-LightItalic.ttf"
        ]
        for name in expected {
            #expect(registered.contains(name), "missing bundled font: \(name)")
        }
    }

    #if canImport(UIKit)
    @Test("touching the registration token loads fonts so UIFont(name:) succeeds")
    func registrationTokenLoadsFonts() {
        _ = ParadoxFonts.registrationToken

        let postScriptNames = [
            ParadoxFonts.PostScript.regular,
            ParadoxFonts.PostScript.italic,
            ParadoxFonts.PostScript.bold,
            ParadoxFonts.PostScript.boldItalic,
            ParadoxFonts.PostScript.light,
            ParadoxFonts.PostScript.lightItalic
        ]
        for name in postScriptNames {
            #expect(UIFont(name: name, size: 17) != nil,
                    "UIFont(name: \"\(name)\") returned nil — PostScript name may not match the .ttf's internal name")
        }
    }
    #endif

    @Test("ParadoxDefaultTheme.init triggers font registration")
    func themeInitTriggersRegistration() {
        // Constructing the default theme touches registrationToken; the
        // bundle URLs must therefore be resolvable.
        let theme = ParadoxDefaultTheme()
        _ = theme.typography.body
        // If we got this far without crash, font construction worked.
        #expect(theme.spacing.lg == 16)
    }
}
