class AuthRepository: IAuthRepository {
    private let apiService: IAPIService
    
    init(apiService: IAPIService = APIService()) {
        self.apiService = apiService
    }
    
    func login(username: String, password: String) async throws -> User {
        let requestDTO = LoginRequestDTO(username: username, password: password)
        let responseDTO: AuthResponseDTO = try await apiService.post(
            endpoint: "/auth/login",
            body: requestDTO
        )
        return responseDTO.toDomain()
    }
    
    func signup(username: String, email: String, password: String) async throws -> User {
        let requestDTO = SignupRequestDTO(username: username, email: email, password: password)
        let responseDTO: AuthResponseDTO = try await apiService.post(
            endpoint: "/users/add",
            body: requestDTO
        )
        return responseDTO.toDomain()
    }
} 