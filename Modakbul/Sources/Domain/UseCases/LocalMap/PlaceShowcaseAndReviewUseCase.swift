//
//  PlaceShowcaseAndReviewUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation
import CoreLocation

protocol PlaceShowcaseAndReviewUseCase {
    /// MapKit 장소명으로 좌표 검색
    func fetchCoordinateOnPlace(with keyword: String) async throws -> [CLLocationCoordinate2D]
    
    /// MapKit 관심 장소 검색어 제안 시작
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    
    /// MapKit 관심 장소 검색어 제안 종료
    func stopSuggestion()
    
    /// MapKit 관심 장소 추천 기반 키워드 제공
    func provideSuggestions(by keyword: String)
    
    /// 카페 제보 및 리뷰 목록 조회
    func readPlacesForShowcaseAndReview(userId: Int64) async throws -> [Place]
    
    /// 카페 리뷰
    func reviewPlace(userId: Int64, on place: Place) async throws
    
    /// 카페 제보
    func suggestPlace(userId: Int64, on place: Place) async throws
}

final class DefaultPlaceShowcaseAndReviewUseCase {
    private let placesRepository: PlacesRepository
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}

// MARK: PlaceShowcaseAndReviewUseCase Conformation
extension DefaultPlaceShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase {
    func fetchCoordinateOnPlace(with keyword: String) async throws -> [CLLocationCoordinate2D] {
        try await placesRepository.readCoordinateOnPlace(with: keyword)
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
    
    func readPlacesForShowcaseAndReview(userId: Int64) async throws -> [Place] {
        try await placesRepository.readPlacesForShowcaseAndReview(userId: userId)
    }
    
    func reviewPlace(userId: Int64, on place: Place) async throws {
        try await placesRepository.reviewPlace(userId: userId, on: place)
    }
    
    func suggestPlace(userId: Int64, on place: Place) async throws {
        try await placesRepository.suggestPlace(userId: userId, on: place)
    }
}
