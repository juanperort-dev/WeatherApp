//
//  Forecast.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 17/1/26.
//

import Foundation

struct ForecastItem: Identifiable {
    let id = UUID()
    let hour: String
    let temp: String
    let icon: String
}
