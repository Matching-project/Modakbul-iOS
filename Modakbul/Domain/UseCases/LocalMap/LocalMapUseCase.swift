//
//  LocalMapUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol LocalMapUseCase {
    func fetchPlaces(on coordinate: Coordinate) async throws -> [Place]
    func fetchPlace(with keyword: String) async throws -> Place
    
    func updateLocation() async throws -> Coordinate
}

final class DefaultLocalMapUseCase {
    private let placesRepository: PlacesRepository
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}

// MARK: LocalMapUseCase Confirmation
extension DefaultLocalMapUseCase: LocalMapUseCase {
    func fetchPlaces(on coordinate: Coordinate) async throws -> [Place] {
        <#code#>
    }
    
    func fetchPlace(with keyword: String) async throws -> Place {
        <#code#>
    }
    
    func updateLocation() async throws -> Coordinate {
        <#code#>
    }
    
}
