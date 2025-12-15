import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn

@main
struct E_commerceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authVM = AuthenticationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
