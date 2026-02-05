//
//  WeatherStore.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 4/2/26.
//

import Foundation
import Combine

class WeatherStore: ObservableObject {
    @Published var selectedCity: String = "Madrid"
}
