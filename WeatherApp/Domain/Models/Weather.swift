//
//  Weather.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

struct Weather: Identifiable {
    let id = UUID()
    let cityName: String
    let temperature: Double
    let condition: String
    let conditionIcon: String
    let humidity: Int
    let windSpeed: Double
    
    var temperatureString: String {
        return String(format: "%.1f°C", temperature)
    }
}
