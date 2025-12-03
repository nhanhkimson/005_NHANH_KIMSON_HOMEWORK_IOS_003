import SwiftUI

struct LinkButton: View {
    @EnvironmentObject var languageManager: LanguageManager
    var title: String
    var action: () -> Void
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        Button(action: action) {
            Text(languageManager.localizedString(forKey: title))
                .font(.custom(languageManager.getFont(),
                              size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                .customUnderline(color: Color.secon.opacity(0.5), thickness: 1, offset: 2)
                .foregroundStyle(Color.secon)
        }
        .buttonStyle(CustomButtonStyle())
    }
}
