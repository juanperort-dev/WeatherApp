//
//  WeatherForecastDTO.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 17/1/26.
//

import Foundation

struct WeatherForecastDTO: Decodable {
    let list: [HourlyDTO]
}

struct HourlyDTO: Decodable {
    let dt: TimeInterval
    let main: MainDTO
    let weather: [WeatherDescriptionDTO]
    let wind: WindDTO?
    let pop: Double?
    let rain: RainDTO?
    
    var date: Date { Date(timeIntervalSince1970: dt) }
}
