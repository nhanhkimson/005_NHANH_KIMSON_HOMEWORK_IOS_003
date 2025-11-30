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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    //Handle Google Oauth URL
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
