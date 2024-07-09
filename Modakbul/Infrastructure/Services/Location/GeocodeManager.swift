//
//  GeocodeManager.swift
//  Modakbul
//
//  Created by Swain Yun on 7/9/24.
//

import Foundation
import CoreLocation

protocol GeocodeManager {
    func reverseGeocode(from location: CLLocation) async throws -> [CLPlacemark]
    func geocode(address: String) async throws -> [CLPlacemark]
}

final class DefaultGeocodeManager {
    private let geocoder: CLGeocoder
    
    private var isGeocoding: Bool { geocoder.isGeocoding }
    
    init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }
}

// MARK: GeocodeManager Conformation
extension DefaultGeocodeManager: GeocodeManager {
    func reverseGeocode(from location: CLLocation) async throws -> [CLPlacemark] {
        if isGeocoding {
            geocoder.cancelGeocode()
        }
        
        return try await geocoder.reverseGeocodeLocation(location, preferredLocale: .current)
    }
    
    func geocode(address: String) async throws -> [CLPlacemark] {
        if isGeocoding {
            geocoder.cancelGeocode()
        }
        
        return try await geocoder.geocodeAddressString(address)
    }
}
