//
//  LocationService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import CoreLocation

protocol LocationService: NSObject {
    func start()
    func stop()
}

final class DefaultLocationService: NSObject {
    private let locationManager: LocationManager
    
    init(
        locationManager: LocationManager,
        delegate: CLLocationManagerDelegate
    ) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
    }
}

// MARK: CLLocationManagerDelegate Confirmation
extension DefaultLocationService: CLLocationManagerDelegate {
    
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
}
