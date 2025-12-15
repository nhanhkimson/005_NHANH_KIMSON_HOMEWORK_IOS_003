import Foundation
import GoogleSignIn
import Firebase
import FirebaseAuth

struct Authentication {
    @MainActor
    func googleOauth() async throws {
        // ... existing implementation ...
    }
    
    @MainActor
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
}

enum AuthenticationError: Error {
    case runtimeError(String)
}
