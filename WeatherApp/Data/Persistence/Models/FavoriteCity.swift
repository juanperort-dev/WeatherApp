//
//  FavouriteCity.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 6/2/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteCity {
    @Attribute(.unique) var name: String
    var createdAt: Date
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
