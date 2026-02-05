//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 15/1/26.
//

import SwiftUI

@main
struct WeatherApp: App {
    let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            MainTabView(container: container)
                .environmentObject(container.weatherStore)
        }
    }
}
