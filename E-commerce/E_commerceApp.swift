import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn

@main
struct E_commerceApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
            // Firebase initialization
            FirebaseApp.configure()
        }
    @StateObject var authVM = AuthenticationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .onOpenURL { url in
                    //Handle Google Oauth URL
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
