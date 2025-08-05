//
//  NetworkService.swift
//  TheMovieDB-MVVM
//
//  Created by Emre Kuru on 4.08.2025.
//
import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let baseURL: String
    private let accessToken: String
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    init(session: URLSession = .shared, baseURL: String = APIConfig.baseURL, accessToken: String = APIConfig.apiKey) {
        self.session = session
        self.baseURL = baseURL
        self.accessToken = accessToken
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
