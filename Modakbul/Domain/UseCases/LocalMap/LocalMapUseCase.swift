//
//  LocalMapUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation
import CoreLocation

protocol LocalMapUseCase {
    typealias Coordinate = CLLocationCoordinate2D
    
    func fetchPlaces(on coordinate: Coordinate) async throws -> [Place]
    func fetchPlace(with keyword: String) async throws -> Place
    
    func updateCoordinate() async throws -> Coordinate
}

final class DefaultLocalMapUseCase {
    private let placesRepository: PlacesRepository
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}

// MARK: LocalMapUseCase Conformation
extension DefaultLocalMapUseCase: LocalMapUseCase {
    func fetchPlaces(on coordinate: Coordinate) async throws -> [Place] {
        try await placesRepository.findPlaces(on: coordinate)
    }
    
    func fetchPlace(with keyword: String) async throws -> Place {
        try await placesRepository.findPlace(with: keyword)
    }
    
    func updateCoordinate() async throws -> Coordinate {
        try await placesRepository.fetchCurrentCoordinate()
    }
}
