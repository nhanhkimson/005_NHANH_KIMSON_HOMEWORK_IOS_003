
import SwiftUI
struct TextFieldVerify: View {
    @StateObject var languageManager = LanguageManager()
    @Binding var value: String
    @Environment(\.colorScheme) var colorScheme
    public var label: String
    var body: some View{
        TextField(label, text: $value)
            .font(.custom(languageManager.getFont(), size: UIFont.labelFontSize))
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(colorScheme == .dark ? Color.gra.opacity(0.5) : Color.background)
            .cornerRadius(12)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
    }
}
