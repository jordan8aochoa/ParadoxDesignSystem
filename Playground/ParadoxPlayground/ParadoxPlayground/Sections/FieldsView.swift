import SwiftUI
import ParadoxUI

struct FieldsView: View {
    @Environment(\.paradoxTheme) private var theme
    @State private var email = ""
    @State private var password = ""
    @State private var bio = "Designer."
    @State private var errorDemo = "bad"
    @State private var helpDemo = ""
    @State private var warningDemo = "12"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                section("Default") {
                    TextField("Email", text: $email)
                        .paradoxTextFieldStyle()
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .paradoxTextFieldStyle()
                        .textContentType(.password)
                }

                section("Multi-line (TextEditor)") {
                    TextEditor(text: $bio)
                        .paradoxTextFieldStyle()
                        .frame(minHeight: 100)
                }

                section("Disabled") {
                    TextField("Locked field", text: .constant("Cannot edit"))
                        .paradoxTextFieldStyle()
                        .disabled(true)
                }

                section("With messages") {
                    TextField("Email", text: $errorDemo)
                        .paradoxTextFieldStyle()
                        .paradoxFieldMessage(.error("Please enter a valid email"))

                    TextField("Password", text: $warningDemo)
                        .paradoxTextFieldStyle()
                        .paradoxFieldMessage(.warning("Weak password — try at least 8 characters"))

                    TextField("Username", text: .constant("@jordan"))
                        .paradoxTextFieldStyle()
                        .paradoxFieldMessage(.info("@jordan is available"))

                    TextField("Recovery email", text: $helpDemo)
                        .paradoxTextFieldStyle()
                        .paradoxFieldMessage(.help("We'll never share this with anyone."))
                }
            }
            .padding(theme.spacing.lg)
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(title)
                .paradoxText(theme.typography.titleSmall)
                .foregroundStyle(theme.color.text.primary)
            VStack(spacing: theme.spacing.md) { content() }
        }
    }
}
