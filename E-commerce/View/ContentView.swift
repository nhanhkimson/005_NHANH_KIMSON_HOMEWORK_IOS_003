import SwiftUI
import FirebaseAuth
struct ContentView: View {
    @State var isLogin: Bool = false
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @State private var authListenerHandle: AuthStateDidChangeListenerHandle? = nil
    @EnvironmentObject var authVM: AuthenticationViewModel
    var body: some View {
        VStack{
            if userLoggedIn {
                TabView{
                    Home()
                        .tabItem{
                            Label("Home", systemImage: "house.fill")
                        }
                    Order()
                        .tabItem{
                            Label("Order", systemImage: "box.truck.fill")
                        }
                    Favorite()
                        .tabItem{
                            Label("Favorite", systemImage: "heart.fill")
                        }
                    Profile(isLogout: $isLogin)
                        .environmentObject(authVM)
                        .tabItem{
                            Label("Profile", systemImage: "person.fill")
                        }
                }
                .tint(.blue)
            }else{
                Landing(isHome: $isLogin)
                    .environmentObject(authVM)
            }
        }
        .onAppear{
            //Firebase state change listeneer
            authListenerHandle = Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
