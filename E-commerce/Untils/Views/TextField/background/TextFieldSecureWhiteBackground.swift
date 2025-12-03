import SwiftUI
struct TextFieldSecureWhiteBackground: View {
    @StateObject var languageManager = LanguageManager()
    @Environment(\.colorScheme) var colorScheme
    var color: Color
    @Binding var value: String
    var trailingPadding: CGFloat = 16
    var label: String?
    var body: some View{
        SecureField(languageManager.localizedString(forKey: label ?? "password"), text: $value)
            .font(.custom(languageManager.getFont(), size: UIFont.labelFontSize))
            .textContentType(.password)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.leading)
            .padding(.vertical, 12)
            .padding(.trailing, trailingPadding)
            .background(colorScheme == .dark ? Color.gra.opacity(0.5) : color)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
    }
}
