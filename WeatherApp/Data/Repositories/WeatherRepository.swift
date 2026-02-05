//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let apiKey = APIConfig.apiKey
    private let baseURL = "https://api.openweathermap.org/data/2.5"

    // MARK: - Initialization
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - WeatherRepositoryProtocol Methods
    func fetchCurrentWeather(for city: String) async throws -> Weather {
        let url = try buildURL(endpoint: "/weather", queryItems: [URLQueryItem(name: "q", value: city)])
        let dto: CurrentWeatherDTO = try await networkManager.request(url: url)
        return dto.toDomain()
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> Weather {
        let url = try buildURL(endpoint: "/weather", queryItems: [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ])
        let dto: CurrentWeatherDTO = try await networkManager.request(url: url)
        return dto.toDomain()
    }

    func fetchHourlyForecast(for city: String) async throws -> [ForecastItem] {
        let url = try buildURL(endpoint: "/forecast", queryItems: [URLQueryItem(name: "q", value: city)])
        let dto: WeatherForecastDTO = try await networkManager.request(url: url)
        return dto.list.prefix(8).map { $0.toForecastItem() }
    }

    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> [ForecastItem] {
        let url = try buildURL(endpoint: "/forecast", queryItems: [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ])
        let dto: WeatherForecastDTO = try await networkManager.request(url: url)
        return dto.list.prefix(8).map { $0.toForecastItem() }
    }

    func fetchHourlyListForecast(for city: String) async throws -> [DailyGroup] {
        let url = try buildURL(endpoint: "/forecast", queryItems: [URLQueryItem(name: "q", value: city)])
        let dto: WeatherForecastDTO = try await networkManager.request(url: url)
        return WeatherMapper.groupForecastByDay(dto.list)
    }

    // MARK: - Private Helpers
    private func buildURL(endpoint: String, queryItems: [URLQueryItem]) throws -> URL {
        var components = URLComponents(string: baseURL + endpoint)
        
        let commonItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "es")
        ]
        
        components?.queryItems = commonItems + queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
