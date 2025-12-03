import Foundation
import SwiftUI
import FirebaseAuth

struct HeaderComponentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var userRoles: UserRoles
    var geometry: GeometryProxy
    @State var adminTitle = "welcom_back_admin"
    @State var adminSubtitle = "attendance_management_dashboard"
    @State var showProfile: Bool = false
    
    @State var hasLoad = false
    @State private var showNotificationView = false
    
    var user = Auth.auth().currentUser
    var body: some View {
        HStack {
            HStack {
                //                if profileViewModel.isLoading{
                //                    HStack{
                //                        SkeletonView(shape: Circle())
                //                            .frame(width: geometry.size.width * 0.13)
                //                        VStack{
                //                            SkeletonView(shape: RoundedRectangle(cornerRadius: 12))
                //                                .frame(height: 15)
                //                                .padding(.trailing, 50)
                //                            SkeletonView(shape: RoundedRectangle(cornerRadius: 12))
                //                                .frame(height: 12)
                //                                .padding(.trailing, 120)
                //                        }
                //                    }
                //                }else if let profile = profileViewModel.user{
                KFImageView(imageUrl: user?.photoURL?.absoluteString ?? "", size: geometry.size.width * 0.13)
                    .onTapGesture {
                        showProfile = true
                    }
                VStack(alignment: .leading, spacing: 5) {
                    // Name
                    Text("Welcome!")
                        .font(.custom(languageManager.getFont(),
                                      size: geometry.size.width * 0.04))
                        .fontWeight(.semibold)
                    Text(languageManager.localizedString(forKey: adminSubtitle))
                        .font(.custom(languageManager.getFont(),
                                      size: geometry.size.width * 0.035))
                }
            }
            Spacer()
            
            Button(action: {
                showNotificationView = true
            }) {
                Image(colorScheme == .dark ? "notification_white" : "notification")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.07,
                           height: geometry.size.width * 0.07)
            }
        }
    }
}

enum UserRoles {
    case admin, student, staff
}

#Preview {
    GeometryReader { geometry in
        HeaderComponentView(userRoles: .constant(.student), geometry: geometry)
    }
    .environmentObject(LanguageManager.shared)
}
