//
//  LocationService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: NSObject {
    func didUpdateLocations(locations: [CLLocation])
    func didFailWithError(error: LocationServiceError)
}

protocol LocationService: NSObject {
    func start()
    func stop()
    func connectOnce()
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
    var delegate: LocationServiceDelegate?
    
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
}

// MARK: CLLocationManagerDelegate Confirmation
extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocations(locations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        let error = resolveError(error)
        delegate?.didFailWithError(error: error)
    }
}

// MARK: LocationService Confirmation
extension DefaultLocationService: LocationService {
    func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func connectOnce() {
        locationManager.requestLocation()
    }
}
