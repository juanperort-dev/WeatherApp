//
//  HourlyForecast+Mock.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import Foundation

extension HourlyForecast {
    static let mockArray = [
        HourlyForecast(
            time: "19:00", temp: "7 ºC", icon: "cloud.sun.fill", pop: "55 %", rainAmount: "15 mm", windSpeed: "4,3 Km/H"),
        HourlyForecast(
            time: "20:00", temp: "10 ºC", icon: "cloud.rain.fill", pop: "55 %", rainAmount: "10 mm", windSpeed: "4,3 Km/H"),
        HourlyForecast(
            time: "21:00", temp: "6 ºC", icon: "cloud.rain.fill", pop: "55 %", rainAmount: "7.5 mm", windSpeed: "4,3 Km/H"),
        HourlyForecast(
            time: "22:00", temp: "-2 ºC", icon: "cloud.fill", pop: "55 %", rainAmount: "15 mm", windSpeed: "4,3 Km/H")
    ]
}

