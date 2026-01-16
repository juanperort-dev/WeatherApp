//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(url: URL?) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(url: URL?) async throws -> T {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
