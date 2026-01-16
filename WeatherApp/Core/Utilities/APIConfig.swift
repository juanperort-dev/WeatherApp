//
//  APIConfig.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

enum APIConfig {
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}
