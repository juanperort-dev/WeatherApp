//
//  HourlyForecastItemDTO.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import Foundation

struct HourlyForecastItemDTO: Identifiable {
    let id = UUID()
    let time: Date
    let temp: Double
    let icon: String
    let pop: Double
    let rainAmount: Double
    let windSpeed: Double
}

struct DailyGroupDTO: Identifiable {
    let id = UUID()
    let date: String
    let hours: [HourlyForecast]
}
