//
//  LocationService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: NSObject {
    func didUpdateCoordinate(coordinate: CLLocationCoordinate2D)
    func didFailWithError(error: LocationServiceError)
}

protocol LocationService: NSObject, AnyObject {
    var delegate: LocationServiceDelegate? { get set }
    
    func updateOnce()
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
    
    weak var delegate: LocationServiceDelegate?
    
    init(
        locationManager: LocationManager = CLLocationManager(),
        delegate: LocationServiceDelegate? = nil
    ) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager = locationManager
        self.delegate = delegate
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
    func updateOnce() {
        locationManager.requestLocation()
    }
}

// MARK: CLLocationManagerDelegate Confirmation
extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        delegate?.didUpdateCoordinate(coordinate: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        let error = resolveError(error)
        delegate?.didFailWithError(error: error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: locationManager.requestLocation()
        default: locationManager.stopUpdatingLocation()
        }
    }
}
