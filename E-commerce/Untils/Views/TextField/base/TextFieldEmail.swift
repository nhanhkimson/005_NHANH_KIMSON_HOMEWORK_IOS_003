import SwiftUI
struct TextFieldEmail: View {
    @StateObject var languageManager = LanguageManager()
    @Environment(\.colorScheme) var colorScheme
    @Binding var value: String
    var body: some View{
        TextField(languageManager.localizedString(forKey: "email"), text: $value)
            .font(.custom(languageManager.getFont(), size: UIFont.labelFontSize))
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(colorScheme == .dark ? Color.gra.opacity(0.5) : Color.background)
            .cornerRadius(12)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
    }
}
