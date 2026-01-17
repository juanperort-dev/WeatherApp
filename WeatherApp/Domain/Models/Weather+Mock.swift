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
