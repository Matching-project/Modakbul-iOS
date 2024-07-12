//
//  FetchPlacesUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/28/24.
//

import Foundation

protocol FetchPlacesUseCase {
    func fetchPlaces(on coordinate: Coordinate) async throws -> [Place]
    func fetchPlace(with keyword: String) async throws -> Place
    func fetchLocations(with keyword: String) async throws -> [Location]
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
}

final class DefaultFetchPlacesUseCase {
    private let placesRepository: PlacesRepository
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}

// MARK: FetchPlacesUseCase Conformation
extension DefaultFetchPlacesUseCase: FetchPlacesUseCase {
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
}
