//
//  Weather+Mock.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

extension Weather {
    static let mock = Weather(
        cityName: "Madrid",
        temperature: 22.5,
        tempMax: 12.0,
        tempMin: 2.0,
        condition: "Soleado",
        conditionIcon: "sun.max.fill",
        humidity: 40,
        windSpeed: 15.0
    )
}

extension ForecastItem {
    static let mockArray = [
        ForecastItem(hour: "12:00", temp: "22°", icon: "sun.max.fill"),
        ForecastItem(hour: "15:00", temp: "24°", icon: "cloud.sun.fill"),
        ForecastItem(hour: "18:00", temp: "20°", icon: "cloud.drizzle.fill"),
        ForecastItem(hour: "21:00", temp: "18°", icon: "moon.stars.fill"),
        ForecastItem(hour: "00:00", temp: "18°", icon: "moon.stars.fill"),
        ForecastItem(hour: "03:00", temp: "16°", icon: "moon.stars.fill"),
        ForecastItem(hour: "06:00", temp: "12°", icon: "moon.stars.fill"),
        ForecastItem(hour: "09:00", temp: "14°", icon: "sun.max.fill")
    ]
}
