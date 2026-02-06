//
//  PersistenceContainer.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 6/2/26.
//

import Foundation
import SwiftData

struct PersistenceContainer {
    static let shareModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteCity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
    }()
}
