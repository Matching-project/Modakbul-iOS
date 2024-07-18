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
    func fetchLocations(with keyword: String) async throws -> [Location]
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
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
        try await placesRepository.findPlaces(on: coordinate)
    }
    
    func fetchPlace(with keyword: String) async throws -> Place {
        try await placesRepository.findPlace(with: keyword)
    }
    
    func fetchLocations(with keyword: String) async throws -> [Location] {
        try await placesRepository.findLocations(with: keyword)
    }
    
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation) {
        placesRepository.startSuggestion(with: continuation)
    }
    
    func stopSuggestion() {
        placesRepository.stopSuggestion()
    }
    
    func provideSuggestions(by keyword: String) {
        placesRepository.provideSuggestions(by: keyword)
    }
    
    func updateLocation() async throws -> Coordinate {
        try await placesRepository.fetchCurrentCoordinate()
    }
}
