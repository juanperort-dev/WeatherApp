//
//  WeatherResponseDTO.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

struct WeatherResponseDTO: Decodable {
    let name: String
    let main: MainDTO
    let weather: [WeatherDescriptionDTO]
    let wind: WindDTO
}

struct MainDTO: Decodable {
    let temp: Double
    let humidity: Int
}

struct WeatherDescriptionDTO: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct WindDTO: Decodable {
    let speed: Double
}
