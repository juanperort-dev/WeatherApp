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
    @Published var dailyGroups: [DailyGroup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }
    
    func getForecast(for city: String) async {
        guard !city.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let groups = try await repository.fetchHourlyListForecast(for: city)
            
            self.dailyGroups = groups
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            self.errorMessage = "No se pudo cargar el pronóstico. Revisa tu conexión."
        }
    }
}
