//
//  CoordinateRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/28/24.
//

import Foundation

protocol CoordinateRepository {
    func fetchCurrentCoordinate() async throws -> Coordinate
}

final class DefaultCoordinateRepository {
    private let locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
}

// MARK: LocationRepository Conformation
extension DefaultCoordinateRepository: CoordinateRepository {
    func fetchCurrentCoordinate() async throws -> Coordinate {
        switch await locationService.updateOnce() {
        case .success(let coordinate): return coordinate.toDTO()
        case .failure(let error): throw error
        }
    }
}
