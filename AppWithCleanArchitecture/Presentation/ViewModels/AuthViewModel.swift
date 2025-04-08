import Combine
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    
    private let authUseCase: IAuthUseCase
    
    init(authUseCase: IAuthUseCase = AuthUseCase(repository: AuthRepository())) {
        self.authUseCase = authUseCase
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
            isAuthenticated = true
        }
    }
    
    func login(username: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let user = try await authUseCase.login(username: username, password: password)
            UserDefaults.standard.set(user.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(user.refreshToken, forKey: "refreshToken")
            isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signup(username: String, email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let user = try await authUseCase.signup(username: username, email: email, password: password)
            UserDefaults.standard.set(user.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(user.refreshToken, forKey: "refreshToken")
            isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        isAuthenticated = false
    }
}
