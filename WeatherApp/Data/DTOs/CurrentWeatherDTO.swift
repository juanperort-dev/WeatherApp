//
//  WeatherResponseDTO.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

struct CurrentWeatherDTO: Decodable {
    let name: String
    let main: MainDTO
    let weather: [WeatherDescriptionDTO]
    let wind: WindDTO
}
