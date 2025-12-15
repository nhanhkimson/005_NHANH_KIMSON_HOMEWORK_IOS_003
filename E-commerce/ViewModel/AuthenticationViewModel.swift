import Foundation
import FirebaseAuth
import Firebase
@MainActor
class AuthenticationViewModel: ObservableObject{
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
        
    func loginGoogle() async{
        do{
            try await Authentication().googleOauth()
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    func logout() async{
        do{
            try await Authentication().logout()
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}

