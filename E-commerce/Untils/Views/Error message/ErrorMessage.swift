import SwiftUI
struct ErrorMessage: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State var message: String?
    var body: some View {
        Text(languageManager.localizedString(forKey: message ?? ""))
            .foregroundStyle(Color.error.opacity(0.8))
            .font(.custom(languageManager.getFont(),
                          size: UIFont.preferredFont(forTextStyle: .caption1).pointSize))
            .foregroundStyle(Color.error.opacity(0.8))
        
    }
}
