//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Juan José Perálvarez Ortiz on 17/1/26.
//

import Combine
import Foundation
internal import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    // MARK: - Async/Await
    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        continuation?.resume(throwing: CancellationError())
        continuation = nil
        
        return try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<CLLocationCoordinate2D, Error>) in
            guard let self = self else { return }
            
            self.continuation = continuation
            self.isLoading = true
            
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                self.isLoading = false
                continuation.resume(throwing: CLError(.denied))
                self.continuation = nil
            @unknown default:
                self.isLoading = false
                continuation.resume(throwing: CLError(.locationUnknown))
                self.continuation = nil
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.first?.coordinate else { return }
        
        self.location = lastLocation
        self.isLoading = false
        
        continuation?.resume(returning: lastLocation)
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.isLoading = false
        
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        
        if (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways) && continuation != nil {
            manager.requestLocation()
        }
    }
}
