import SwiftUI

struct PrimaryButton: View {
    @StateObject var languageManager = LanguageManager.shared
    var title: String
    var icon: String?
    var size: CGFloat? = 18
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var isInfinity: Bool = true
    var shadow: CGFloat = 2
    var cornerRadius: CGFloat = 12
    var border: Color = .clear
    var border_stroke: CGFloat = 1
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack{
                if let icon_ = icon {
                    Image(systemName: icon_)
                    Image(icon_)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                }
                Text(LanguageManager.shared.localizedString(forKey: title))
                    .font(.custom(languageManager.getFont(),
                                  size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                
            }
            .foregroundColor(textColor)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .frame(maxWidth: isInfinity ? .infinity : .none)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(radius: shadow)
            .overlay{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border, lineWidth: border_stroke)
            }
        }
        .buttonStyle(CustomButtonStyle())
    }
}
