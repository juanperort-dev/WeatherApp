//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 15/1/26.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var weatherStore = WeatherStore()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(weatherStore)
        }
    }
}
