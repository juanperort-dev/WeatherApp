//
//  HoursViewModel.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 31/1/26.
//

import Foundation
import Combine

@MainActor
class HoursViewModel: ObservableObject {
    
    // MARK: - State Definition
    enum State {
        case idle
        case loading
        case success([DailyGroup])
        case error(String)
    }
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private let repository: WeatherRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func getForecast(for city: String) async {
        guard !city.isEmpty else { return }
        
        state = .loading
        
        do {
            let groups = try await repository.fetchHourlyListForecast(for: city)
            
            if groups.isEmpty {
                state = .error("No hay datos disponibles para el pronóstico.")
            } else {
                state = .success(groups)
            }
            
        } catch {
            state = .error("No se pudo cargar el pronóstico. Revisa tu conexión.")
        }
    }
}

// MARK: - Mocks
extension HoursViewModel {
    static func mockSuccess() -> HoursViewModel {
        let vm = HoursViewModel(repository: WeatherRepository())
        
        let mockHours = HourlyForecast.mockArray
        let mockGroups = DailyGroup.mockArray
        
        vm.state = .success(mockGroups)
        return vm
    }
}
