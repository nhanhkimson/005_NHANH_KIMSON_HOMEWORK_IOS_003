import SwiftUI
struct CustomBackButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    var icon: String?
    var title: String?
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: icon ?? "arrow.left")
                Text(languageManager.localizedString(forKey: title ?? ""))
                    .font(.custom(languageManager.getFont(), size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize))
            }
        }
        .buttonStyle(CustomButtonStyle())
    }
}
