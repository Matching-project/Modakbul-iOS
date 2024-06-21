//
//  LocationService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import CoreLocation

protocol LocationService: NSObject, AnyObject {
    func updateOnce() async -> Result<CLLocationCoordinate2D, Error>
}

enum LocationServiceError: Error {
    case notAuthorized
    case network
    case headingFailure
    case locationUnknown
    case other(code: Int)
    case unknownError(generic: Error)
}

final class DefaultLocationService: NSObject {
    private let locationManager: LocationManager
    
    private var updateLocationTask: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    
    init(
        locationManager: LocationManager = CLLocationManager()
    ) {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
        self.requestAuthorization()
    }
    
    private func resolveError(_ error: Error) -> LocationServiceError {
        guard let error = error as? CLError else { return .unknownError(generic: error) }
        switch error.code {
        case .denied, .promptDeclined: return .notAuthorized
        case .headingFailure: return .headingFailure
        case .network: return .network
        case .locationUnknown: return .locationUnknown
        default: return .unknownError(generic: error)
        }
    }
    
    private func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: LocationService Confirmation
extension DefaultLocationService: LocationService {
    func updateOnce() async -> Result<CLLocationCoordinate2D, Error> {
        return await withCheckedContinuation { continuation in
            updateLocationTask = {
                continuation.resume(returning: $0)
            }
            locationManager.requestLocation()
        }
    }
}

// MARK: CLLocationManagerDelegate Confirmation
extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        updateLocationTask?(.success(coordinate))
        updateLocationTask = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        let error = resolveError(error)
        updateLocationTask?(.failure(error))
        updateLocationTask = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: locationManager.requestLocation()
        default: locationManager.stopUpdatingLocation()
        }
    }
}
