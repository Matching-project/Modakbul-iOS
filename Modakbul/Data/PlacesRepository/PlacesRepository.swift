//
//  PlacesRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation

protocol PlacesRepository {
    func findPlace(with keyword: String) async throws -> Place
    func findPlaces(on coordinate: Coordinate) async throws -> [Place]
}

enum PlacesRepositoryError: Error {
    case fetchFailed
}

final class DefaultPlacesRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: PlacesRepository Conformation
extension DefaultPlacesRepository: PlacesRepository {
    func findPlaces(on coordinate: Coordinate) async throws -> [Place] {
        let endpoint = Endpoint.findPlaces(coordinate: coordinate.toEntity())
        
        do {
            let placeEntities = try await networkService.request(endpoint: endpoint, for: [PlaceEntity].self)
            return placeEntities.map { $0.toDTO() }
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func findPlace(with keyword: String) async throws -> Place {
        let endpoint = Endpoint.findPlace(keyword: keyword)
        
        do {
            let placeEntity = try await networkService.request(endpoint: endpoint, for: PlaceEntity.self)
            return placeEntity.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
}
