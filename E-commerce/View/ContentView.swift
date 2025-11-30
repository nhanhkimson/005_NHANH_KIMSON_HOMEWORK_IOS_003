import SwiftUI
import FirebaseAuth
struct ContentView: View {
    @State var isLogin: Bool = false
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
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
                        .tabItem{
                            Label("Profile", systemImage: "person.fill")
                        }
                }
                .tint(.blue)
            }else{
//                Landing(isHome: $isLogin)
                Login()
            }
        }
        .onAppear{
            //Firebase state change listeneer
            Auth.auth().addStateDidChangeListener{ auth, user in
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
