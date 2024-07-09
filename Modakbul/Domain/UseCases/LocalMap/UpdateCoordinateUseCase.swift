//
//  UpdateCoordinateUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/28/24.
//

import Foundation

protocol UpdateCoordinateUseCase {
    func updateLocation() async throws -> Coordinate
}

final class DefaultUpdateCoordinateUseCase {
    private let placesRepository: PlacesRepository
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}

// MARK: UpdateLocationUseCase Conformation
extension DefaultUpdateCoordinateUseCase: UpdateCoordinateUseCase {
    func updateLocation() async throws -> Coordinate {
        try await placesRepository.fetchCurrentCoordinate()
    }
}
