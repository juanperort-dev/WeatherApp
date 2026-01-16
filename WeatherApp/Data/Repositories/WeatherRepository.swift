//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let apiKey = APIConfig.apiKey
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchCurrentWeather(for city: String) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        let url = URL(string: urlString)
        
        let dto: WeatherResponseDTO = try await networkManager.request(url: url)
        
        return Weather(
            cityName: dto.name,
            temperature: dto.main.temp,
            condition: dto.weather.first?.main ?? "Unknown",
            conditionIcon: mapIcon(dto.weather.first?.icon ?? ""),
            humidity: dto.main.humidity,
            windSpeed: dto.wind.speed
        )
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> Weather {
        fatalError("Implementar después")
    }
    
    private func mapIcon(_ iconCode: String) -> String {
        switch iconCode {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.stars.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d", "03n":
            return "cloud.fill"
        case "04d", "04n":
            return "smoke.fill"
        case "09d", "09n":
            return "cloud.drizzle.fill"
        case "10d":
            return "cloud.sun.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "11d", "11n":
            return "cloud.bolt.rain.fill"
        case "13d", "13n":
            return "snowflake"
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }
}
