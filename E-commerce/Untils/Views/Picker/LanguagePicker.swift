import SwiftUI

struct LanguagePickerModel: Identifiable{
    var id: Int
    var  languageTitle: String
    var  languageIcon: String
    let locale: Locale
    
    static let khmer = LanguagePickerModel(
            id: 0,
            languageTitle: "khmer",
            languageIcon: "Khmer",
            locale: Locale(identifier: "km")
        )
        
        static let english = LanguagePickerModel(
            id: 1,
            languageTitle: "english",
            languageIcon: "English",
            locale: Locale(identifier: "en")
        )
        
        static let korean = LanguagePickerModel(
            id: 2,
            languageTitle: "korean",
            languageIcon: "Korean",
            locale: Locale(identifier: "ko")
        )
        
        static var allLanguages: [LanguagePickerModel] {
            [.khmer, .english, .korean]
        }
}

struct LanguagePicker: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State var selectedLanguage: Int = 0
    private let languages = LanguagePickerModel.allLanguages
    @State private var currentLocale: Locale? = nil
    @Environment(\.dismiss) var dissmiss
    var body: some View {
        VStack(spacing: 16){
            ForEach(languages){ lang in
                LanguageSelectItem(languageTitle: lang.languageTitle, languageIcon: lang.languageIcon, id: lang.id, selectedId: selectedLanguage){
                    currentLocale = lang.locale
                    selectedLanguage = lang.id
                }
            }
            PrimaryButton(title: languageManager.localizedString(forKey:  "select")){
                if let locale = currentLocale{
                    languageManager.currentLocale = locale
                    dissmiss()
                }

            }
        }
        .onAppear{
            selectedLanguage = languageToIndex(lang: languageManager.currentLocale.identifier)
        }
    }
}

func languageToIndex(lang: String) -> Int{
    switch lang {
    case "km":
        return 0
    case "en":
        return 1
    case "ko":
        return 2
    default:
        return 1
    }
}




#Preview {
    LanguagePicker()
        .environmentObject(LanguageManager.shared)
}
struct LanguageSelectItem: View {
    @EnvironmentObject var languageManager: LanguageManager
    var languageTitle: String
    var languageIcon: String
    var id: Int
    var selectedId: Int
    var action: ()-> Void
    
    var body: some View {
        Button(action: action){
            HStack {
                Image(languageIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(languageManager.localizedString(forKey: languageTitle))
                    .font(.custom(languageManager.getFont(),
                                  size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                Spacer()
            }
            .foregroundStyle(Color.blac)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(id == selectedId ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(12)
        }
    }
}
