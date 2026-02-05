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
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    @Published private(set) var hourlyForecast: [ForecastItem] = []
    
    private let repository: WeatherRepositoryProtocol
    private let locationManager: LocationManager
    
    // MARK: - Init
    init(repository: WeatherRepositoryProtocol, locationManager: LocationManager) {
        self.repository = repository
        self.locationManager = locationManager
    }
    
    // MARK: - Public API
    func loadWeather(for city: String) async {
        if case .success(let current) = state, current.cityName.lowercased()    == city.lowercased() {
            return
        }
        
        await getCityWeather(city: city)
    }
    
    func fetchWeatherForLocation() async {
        state = .loading
        
        do {
            let coords = try await locationManager.getCurrentLocation()
            await getWeatherForCoordinates(lat: coords.latitude, lon: coords.longitude)
        } catch {
            await getCityWeather(city: "Madrid")
        }
    }
    
    // MARK: - Private Logic
    private func getCityWeather(city: String) async {
        guard !city.isEmpty else { return }
        state = .loading
        
        do {
            async let weatherFetch = repository.fetchCurrentWeather(for: city)
            async let forecastFetch = repository.fetchHourlyForecast(for: city)
            
            let (weather, forecast) = try await (weatherFetch, forecastFetch)
            
            self.hourlyForecast = forecast
            self.state = .success(weather)
        } catch {
            state = .error("No se pudo encontrar la ciudad '\(city)'")
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
            state = .error("Error al obtener el clima de tu ubicación.")
        }
    }
}

// MARK: - Mocks
extension HomeViewModel {
    static func mockSuccess() -> HomeViewModel {
        let vm = HomeViewModel(
            repository: WeatherRepository(),
            locationManager: LocationManager()
        )
        vm.state = .success(.mock)
        return vm
    }
}
