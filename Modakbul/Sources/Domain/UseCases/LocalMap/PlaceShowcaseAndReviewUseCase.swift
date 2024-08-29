//
//  PlaceShowcaseAndReviewUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol PlaceShowcaseAndReviewUseCase {
    func fetchLocations(with keyword: String) async throws -> [Location]
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
    
    func fetchParticipatedPlaces() async -> [Place]
    func review(on place: Place) async
}

final class DefaultPlaceShowcaseAndReviewUseCase {
    private let placesRepository: PlacesRepository
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}

// MARK: PlaceShowcaseAndReviewUseCase Conformation
extension DefaultPlaceShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase {
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
    
    func fetchParticipatedPlaces() async -> [Place] {
        // TODO: 기능 연결 전 Endpoint & Entity 뚫어야함
        []
    }
    
    func review(on place: Place) async {
        // TODO: PlacesRepository 인터페이스 추가해야하고 기능 연결 해야함
    }
}
