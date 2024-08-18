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
    
    func fetchPlaces(on coordinate: Coordinate, by sortCriteria: PlaceSortCriteria) async throws -> [Place]
    func fetchPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place]
    
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
    func fetchPlaces(on coordinate: Coordinate, by sortCriteria: PlaceSortCriteria) async throws -> [Place] {
        switch sortCriteria {
        case .distance: return try await placesRepository.findPlacesOrderedByDistance(on: coordinate)
        case .matchesCount: return try await placesRepository.findPlacesOrderedByMatchesCount(on: coordinate)
        }
    }
    
    func fetchPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place] {
        try await placesRepository.findPlaces(with: keyword, on: coordinate)
    }
    
    func updateCoordinate() async throws -> Coordinate {
        try await placesRepository.fetchCurrentCoordinate()
    }
}
