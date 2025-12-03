import SwiftUI
struct TextFieldBase: View {
    @StateObject var languageManager = LanguageManager()
    @Binding var value: String
    @Environment(\.colorScheme) var colorScheme
    var trailingPadding: CGFloat = 16
    public var label: String
    var body: some View{
        TextField(label, text: $value)
            .font(.custom(languageManager.getFont(), size: UIFont.labelFontSize))
            .padding(.leading)
            .padding(.vertical, 12)
            .padding(.trailing, trailingPadding)
            .background(colorScheme == .dark ? Color.gra.opacity(0.5) : Color.background)
            .cornerRadius(12)
    }
}
