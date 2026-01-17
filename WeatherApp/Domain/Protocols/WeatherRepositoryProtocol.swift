//
//  WeatherRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchCurrentWeather(for city: String) async throws -> Weather
    func fetchWeather(lat: Double, lon: Double) async throws -> Weather
    func fetchHourlyForecast(for city: String) async throws -> [ForecastItem]
    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> [ForecastItem]
}
