//
//  WeatherStore.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 4/2/26.
//

import Foundation
import Combine

class WeatherStore: ObservableObject {
    private let selectedCityKey: String = "app.selected_city"
    
    @Published var selectedCity: String {
        didSet {
            UserDefaults.standard.set(selectedCity, forKey: selectedCityKey)
        }
    }
    
    init() {
        self.selectedCity = UserDefaults.standard.string(forKey: selectedCityKey) ?? "Andorra"
    }
    
    func selectCity(_ city: String) {
        self.selectedCity = city
    }
}
