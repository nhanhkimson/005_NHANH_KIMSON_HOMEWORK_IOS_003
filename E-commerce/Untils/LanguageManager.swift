import SwiftUI
class LanguageManager: ObservableObject {
    @Published var currentLocale: Locale = .init(identifier: "en") {
        didSet {
            UserDefaults.standard.set(currentLocale.identifier, forKey: "appLanguage")
        }
    }
    static let shared = LanguageManager()
    
    func setLanguage(_ code: String) {
        currentLocale = Locale(identifier: code)
        UserDefaults.standard.set(code, forKey: "appLanguage")
    }
    
    func localizedString(forKey key: String) -> String {
        guard let path = Bundle.main.path(forResource: currentLocale.identifier, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
    func getEngilshFont() -> String{
        return "NotoSans-Regular"
    }
    func getEngilshFontBold() -> String{
        return "NotoSans-Bold"
    }
    func getFont()-> String{
        switch currentLocale.identifier{
        case "km": return "KantumruyPro-Regular"   // Khmer font
        case "ko": return "NotoSansKR-Regular"     // Korean font
        default:   return "NotoSans-Regular"       // English font
        }
    }
    
    init() {
        if let saved = UserDefaults.standard.string(forKey: "appLanguage") {
            currentLocale = Locale(identifier: saved)
        }
    }
}
