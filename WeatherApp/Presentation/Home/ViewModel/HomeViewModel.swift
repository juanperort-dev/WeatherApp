//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation
import Combine
internal import _LocationEssentials
internal import CoreLocation

@MainActor
class HomeViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case success(Weather)
        case error(String)
    }
    
    @Published var state: State = .idle
    @Published var hourlyForecast: [ForecastItem] = []
    
    private let repository: WeatherRepositoryProtocol
    private let locationManager = LocationManager()
    
    init(repository: WeatherRepositoryProtocol? = nil) {
        self.repository = repository ?? WeatherRepository()
    }
    
    func loadInitialWeather() async {
        state = .loading
        locationManager.requestLocation()
        
        while true {
            if let coords = locationManager.location {
                await getWeatherForCoordinates(lat: coords.latitude, lon: coords.longitude)
                return
            }
            
            if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                await getCityWeather(city: "Madrid")
                return
            }
            
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }
    
    func fetchLocalWeather() async {
        locationManager.requestLocation()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if let coords = locationManager.location {
            await getWeatherForCoordinates(lat: coords.latitude, lon: coords.longitude)
        }
    }
    
    private func getWeatherForCoordinates(lat: Double, lon: Double) async {
        state = .loading
        do {
            async let weatherFetch = repository.fetchWeather(lat: lat, lon: lon)
            async let forecastFetch = repository.fetchHourlyForecast(lat: lat, lon: lon)
            
            let (weather, forecast) = try await (weatherFetch, forecastFetch)
            
            self.hourlyForecast = forecast
            self.state = .success(weather)
        } catch {
            state = .error("Error al obtener el clima local.")
        }
    }
    
    func getCityWeather(city: String) async {
        guard !city.isEmpty else { return }
        
        state = .loading
        
        do {
            async let weatherFetch = try await repository.fetchCurrentWeather(for: city)
            async let forecastFetch = repository.fetchHourlyForecast(for: city)
            
            let (weather, forecast) = try await (weatherFetch, forecastFetch)
            
            self.hourlyForecast = forecast
            state = .success(weather)
        } catch {
            state = .error("No se encontró la ciudad '\(city)'")
        }
    }
    
}

// MARK: - Extensions

extension HomeViewModel {
    static func mockSuccess() -> HomeViewModel {
        let vm = HomeViewModel()
        vm.state = .success(.mock)
        vm.hourlyForecast = ForecastItem.mockArray
        return vm
    }
    
    static func mockLoading() -> HomeViewModel {
        let vm = HomeViewModel()
        vm.state = .loading
        return vm
    }
}
