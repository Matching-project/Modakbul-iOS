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
    
    /// 장소 이름으로 조회
    func fetchPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place]
    
    /// 장소 거리순, 모임순 조회
    func fetchPlaces(on coordinate: Coordinate, by sortCriteria: PlaceSortCriteria) async throws -> [Place]
    
    /// 사용자 최근 위치 정보 갱신
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
        case .distance: return try await placesRepository.readPlacesOrderedByDistance(on: coordinate)
        case .matchesCount: return try await placesRepository.readPlacesOrderedByMatchesCount(on: coordinate)
        }
    }
    
    func fetchPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place] {
        try await placesRepository.readPlaces(with: keyword, on: coordinate)
    }
    
    func updateCoordinate() async throws -> Coordinate {
        try await placesRepository.readCurrentCoordinate()
    }
}
