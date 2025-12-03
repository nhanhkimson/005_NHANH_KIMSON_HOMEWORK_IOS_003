import SwiftUI
import Foundation
import FirebaseAuth
struct Profile: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Binding var isLogout: Bool
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading ,spacing: 16){
                    CircleImageGradient()
                    LoginForm()
                    LoginThirdParty()
                }
            }
            .padding(.horizontal, 16)
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("My Profile")
                        .font(.title3)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink{
                        SettingView(isLogout: $isLogout)
                            .environmentObject(authVM)
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color(.black))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}



struct LoginThirdParty: View {
    var body: some View {
        // Login with google and password
        Section(header: headerText(text: "Account Linked With")){
            VStack(alignment: .center, spacing: 14){
                primaryButtonIcon(text: "Sign Up With Facebook", iconName: "facebook", action: {
                    print("Hello")
                })
                primaryButtonIcon(text: "Sign Up with Goggle", iconName: "google", action: {
                    print("Hello")
                })
            }
        }
        // End Login with google and password
    }
}


struct LoginForm: View{
    @State var username: String = ""
    @State var email: String = ""
    var body: some View{
        // Login Form username | Email
        Form{
            VStack(alignment: .leading, spacing: 16){
                Group{
                    Section(header: headerText(text: "Username")){
                        formTextField(iconName: "person", title: "Nhanh Kimson", text: $username)
                    }
                    Section(header: headerText(text: "Email or Phone Number")){
                        formTextField(iconName: "envelope", title: "nhanhkimson.biu@gmail.com", text: $username)
                    }
                    .disabled(true)
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)  // hide row seperate
        }
        .formStyle(.columns)  // form style to columns
    }
}
