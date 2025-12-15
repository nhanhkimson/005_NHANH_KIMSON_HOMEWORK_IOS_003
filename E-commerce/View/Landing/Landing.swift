import SwiftUI
struct Landing: View{
    @EnvironmentObject var authVM: AuthenticationViewModel
    var pages: [AnyView] = [AnyView(LandingOne(iamge: "watchTissot")), AnyView(LandingOne(iamge: "bagboy1")), AnyView(LandingOne(iamge: "watchWoman"))]
    @State private var isLogin = UserApp.user.isLogin
    @Binding var isHome: Bool
    var body: some View{
        NavigationStack{
            VStack{
                TabView{
                    ForEach(pages.indices, id: \.self){ index in
                        pages[index]
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                VStack(spacing: 18){
                    PrimaryButton(title: "Create Account") {
                        isLogin = true
                    }
                    .navigationDestination(isPresented: $isLogin){
                        CreateAccount(isLoged: $isHome)
                            .environmentObject(authVM)
                            .navigationBarBackButtonHidden(true)
                    }
                    PrimaryButton(title: "Already have an account", backgroundColor: .clear,textColor: Color.prime, shadow: 0, border: Color.acc){
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
