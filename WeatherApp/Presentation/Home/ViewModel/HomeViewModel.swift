//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation
import Combine

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
    
    init(repository: WeatherRepositoryProtocol? = nil) {
        self.repository = repository ?? WeatherRepository()
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
