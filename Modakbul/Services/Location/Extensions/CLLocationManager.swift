//
//  CLLocationManager.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import CoreLocation

protocol LocationManager: NSObject {
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestLocation()
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: LocationManager {
    
}
