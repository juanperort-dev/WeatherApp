//
//  HourlyItem.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import Foundation

struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: String
    let temp: String
    let icon: String
    let pop: String
    let rainAmount: String
    let windSpeed: String
}

struct DailyGroup: Identifiable {
    let id = UUID()
    let date: String
    let hours: [HourlyForecast]
}
