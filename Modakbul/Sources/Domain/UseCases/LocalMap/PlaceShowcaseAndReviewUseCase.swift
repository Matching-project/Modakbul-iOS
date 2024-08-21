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
    
    // TODO: Work in progress
    func showcase() async
    func fetchParticipatedPlaces(with userId: String) async -> [Place]
    func review(on place: Place) async
}
