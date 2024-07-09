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
    func findLocations(with keyword: String) async throws -> [Location]
    func fetchCurrentCoordinate() async throws -> Coordinate
}

enum PlacesRepositoryError: Error {
    case fetchFailed
}

final class DefaultPlacesRepository {
    private let networkService: NetworkService
    private let localMapService: LocalMapService
    private let locationService: LocationService
    
    private var currentCoordinate: Coordinate?
    
    init(
        networkService: NetworkService,
        localMapService: LocalMapService,
        locationService: LocationService
    ) {
        self.networkService = networkService
        self.localMapService = localMapService
        self.locationService = locationService
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
    
    func findLocations(with keyword: String) async throws -> [Location] {
        do {
            if let currentCoordinate = currentCoordinate {
                let locations = try await localMapService.search(by: keyword, on: currentCoordinate)
                return locations
            } else {
                let coordinate = try await fetchCurrentCoordinate()
                return try await localMapService.search(by: keyword, on: coordinate)
            }
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func fetchCurrentCoordinate() async throws -> Coordinate {
        switch await locationService.updateOnce() {
        case .success(let coordinate):
            currentCoordinate = coordinate.toDTO()
            return coordinate.toDTO()
        case .failure(let error):
            throw error
        }
    }
}
