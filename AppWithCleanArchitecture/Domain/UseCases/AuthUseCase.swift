protocol IAuthUseCase {
    func login(username: String, password: String) async throws -> User
    func signup(username: String, email: String, password: String) async throws -> User
}

class AuthUseCase: IAuthUseCase {
    private let repository: IAuthRepository
    
    init(repository: IAuthRepository) {
        self.repository = repository
    }
    
    func login(username: String, password: String) async throws -> User {
        return try await repository.login(username: username, password: password)
    }
    
    func signup(username: String, email: String, password: String) async throws -> User {
        return try await repository.signup(username: username, email: email, password: password)
    }
} 