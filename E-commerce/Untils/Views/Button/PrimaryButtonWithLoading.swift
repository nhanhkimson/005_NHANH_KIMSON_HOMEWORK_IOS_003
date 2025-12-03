import SwiftUI
struct PrimaryButtonWithLoading: View {
    @EnvironmentObject var languageManager: LanguageManager
    var title: String
    var icon: String?
    var backgroundColor: Color = .blue
        var textColor: Color = .white
    var cornerRadius: CGFloat = 12
    @Binding var whileLoading: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack{
                if let icon_ = icon {
                    Image(systemName: icon_)
                    Image(icon_)
                }
//                LoadingView(whileLoading: $whileLoading)
            }
            .foregroundColor(textColor)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(radius: 2)
        }
        .buttonStyle(CustomButtonStyle())
    }
}
