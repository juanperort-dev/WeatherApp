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
    
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol? = nil) {
        self.repository = repository ?? WeatherRepository()
    }
    
    func getCityWeather(city: String) async {
        state = .loading
        
        do {
            let weather = try await repository.fetchCurrentWeather(for: city)
            state = .success(weather)
        } catch {
            state = .error("No pudimos obtener el clima: \(error.localizedDescription)")
        }
    }
}
