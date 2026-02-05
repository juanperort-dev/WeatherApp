//
//  DependecyContainer.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 5/2/26.
//

import Foundation

@MainActor
final class DependencyContainer {
    let networkManager: NetworkManagerProtocol
    let weatherRepository: WeatherRepositoryProtocol
    let locationManager: LocationManager
    let weatherStore: WeatherStore

    init() {
        self.networkManager = NetworkManager.shared
        self.weatherRepository = WeatherRepository(networkManager: networkManager)
        self.locationManager = LocationManager()
        self.weatherStore = WeatherStore()
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            repository: weatherRepository,
            locationManager: locationManager
        )
    }
    
    func makeHoursViewModel() -> HoursViewModel {
        return HoursViewModel(repository: weatherRepository)
    }
}
