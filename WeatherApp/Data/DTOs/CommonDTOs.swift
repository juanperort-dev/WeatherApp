//
//  CommonDTOs.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 5/2/26.
//

import Foundation

struct MainDTO: Decodable {
    let temp: Double
    let tempMax: Double?
    let tempMin: Double?
    let humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case humidity
    }
}

struct WeatherDescriptionDTO: Decodable {
    let main: String
    let description: String
    let icon: String
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
