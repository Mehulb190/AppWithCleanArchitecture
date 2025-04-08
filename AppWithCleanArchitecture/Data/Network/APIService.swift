import Foundation

protocol IAPIService {
    func post<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U
    func get<T: Codable>(endpoint: String) async throws -> T
    func put<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U
}

class APIService: IAPIService {
    private let baseURL = "https://dummyjson.com"
    
    func post<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(U.self, from: data)
    }
    
    func get<T: Codable>(endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Error response: \(String(data: data, encoding: .utf8) ?? "")")
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func put<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Error response: \(String(data: data, encoding: .utf8) ?? "")")
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(U.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
} 
