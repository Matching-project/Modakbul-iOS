//
//  LocalMapRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/15/24.
//

import Foundation
import MapKit

protocol LocalMapRepository: LocationServiceDelegate {
    
}

enum LocalMapRepositoryError: Error {
    case missingCoordinate
}

final class DefaultLocalMapRepository: NSObject {
    private let localMapService: LocalMapService
    private let locationService: LocationService
    
    private var currentCoordinate: Coordinate?
    private 
    
    init(
        localMapService: LocalMapService,
        locationService: LocationService
    ) {
        self.localMapService = localMapService
        self.locationService = locationService
    }
}

// MARK: LocalMapRepository Conformation
extension DefaultLocalMapRepository: LocalMapRepository {
    func didUpdateCoordinate(coordinate: Coordinate) {
        <#code#>
    }
    
    func didFailWithError(error: LocationServiceError) {
        <#code#>
    }
}
