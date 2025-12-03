import SwiftUI
struct TextFieldSecure: View {
    @StateObject var languageManager = LanguageManager()
    @Environment(\.colorScheme) var colorScheme
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
            .background(colorScheme == .dark ? Color.gra.opacity(0.5) : Color.background)
            .cornerRadius(10)
    }
}

#Preview{
    TextFieldSecure(value: .constant("csdcsdcsdcsdadsdcscsdsdsdscsdcsdcsdcsdsdcsd"))
}
