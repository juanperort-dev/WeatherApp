//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 16/1/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    case unknown
}
