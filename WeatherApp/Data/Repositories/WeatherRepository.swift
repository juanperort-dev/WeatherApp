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
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=es"
        let url = URL(string: urlString)
        
        let dto: WeatherResponseDTO = try await networkManager.request(url: url)
        
        return Weather(
            cityName: dto.name,
            temperature: dto.main.temp,
            tempMax: dto.main.tempMax,
            tempMin: dto.main.tempMin,
            condition: dto.weather.first?.description ?? "Unknown",
            conditionIcon: mapIcon(dto.weather.first?.icon ?? ""),
            humidity: dto.main.humidity,
            windSpeed: dto.wind.speed
        )
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=es"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let dto: WeatherResponseDTO = try await networkManager.request(url: url)
        
        return Weather(
            cityName: dto.name,
            temperature: dto.main.temp,
            tempMax: dto.main.tempMax,
            tempMin: dto.main.tempMin,
            condition: dto.weather.first?.description ?? "Sin descripción",
            conditionIcon: mapIcon(dto.weather.first?.icon ?? ""),
            humidity: dto.main.humidity,
            windSpeed: dto.wind.speed
        )
    }
    
    func fetchHourlyForecast(for city: String) async throws -> [ForecastItem] {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric&lang=es"
        
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        let dto: WeatherForecastDTO = try await networkManager.request(url: url)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return dto.list.prefix(8).map { item in
            ForecastItem(
                hour: formatter.string(from: item.date),
                temp: "\(Int(item.main.temp))°",
                icon: mapIcon(item.weather.first?.icon ?? "")
            )
        }
    }
    
    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> [ForecastItem] {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=es"
        
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        let dto: WeatherForecastDTO = try await networkManager.request(url: url)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return dto.list.prefix(8).map { item in
            ForecastItem(
                hour: formatter.string(from: item.date),
                temp: "\(Int(item.main.temp))°",
                icon: mapIcon(item.weather.first?.icon ?? "")
            )
        }
    }
    
    func fetchHourlyListForecast(for city: String) async throws -> [DailyGroup] {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric&lang=es"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        let dto: HourlyForecastDTO = try await networkManager.request(url: url)
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "es_ES")
        dayFormatter.dateFormat = "EEEE, d 'de' MMMM"
        
        var groupedDict: [String: [HourlyForecast]] = [:]
        var dayOrder: [String] = []
        
        for item in dto.list {
            let date = Date(timeIntervalSince1970: item.dt)
            let dayName = dayFormatter.string(from: date).capitalized
            
            let hourModel = HourlyForecast(
                time: hourFormatter.string(from: date),
                temp: "\(Int(item.main.temp))°",
                icon: mapIcon(item.weather.first?.icon ?? ""),
                pop: "\(Int((item.pop ?? 0) * 100))%",
                rainAmount: String(format: "%.1fmm", item.rain?.threeHours ?? 0.0),
                windSpeed: "\(Int(item.wind.speed * 3.6)) km/h"
            )
            
            if groupedDict[dayName] == nil {
                dayOrder.append(dayName)
                groupedDict[dayName] = []
            }
            groupedDict[dayName]?.append(hourModel)
        }
        
        return dayOrder.map { DailyGroup(date: $0, hours: groupedDict[$0] ?? []) }
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
