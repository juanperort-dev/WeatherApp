//
//  HourlyForecastItemDTO.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import Foundation

struct HourlyForecastDTO: Decodable {
    let list: [ForecastItemDTO]
}

struct ForecastItemDTO: Decodable {
    let dt: TimeInterval
    let main: MainDTO
    let weather: [WeatherDTO]
    let wind: WindDTO
    let pop: Double?
    let rain: RainDTO?

    struct MainDTO: Decodable {
        let temp: Double
    }

    struct WeatherDTO: Decodable {
        let icon: String
        let description: String
    }

    struct WindDTO: Decodable {
        let speed: Double
    }

    struct RainDTO: Decodable {
        let threeHours: Double?

        enum CodingKeys: String, CodingKey {
            case threeHours = "3h"
        }
    }
}
