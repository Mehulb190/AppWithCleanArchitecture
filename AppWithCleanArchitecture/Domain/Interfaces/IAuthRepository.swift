protocol IAuthRepository {
    func login(username: String, password: String) async throws -> User
    func signup(username: String, email: String, password: String) async throws -> User
} 