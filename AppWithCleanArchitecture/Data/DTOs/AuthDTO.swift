struct LoginRequestDTO: Codable {
    let username: String
    let password: String
}

struct SignupRequestDTO: Codable {
    let username: String
    let email: String
    let password: String
}

struct AuthResponseDTO: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let accessToken: String
    let refreshToken: String
    
    func toDomain() -> User {
        return User(
            id: id,
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            image: image,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, firstName, lastName, gender, image
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
} 