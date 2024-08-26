//
//  PlacesRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import CoreLocation

protocol PlacesRepository {
    typealias Coordinate = CLLocationCoordinate2D
    
    func findPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place]
    func findPlacesOrderedByDistance(on coordinate: Coordinate) async throws -> [Place]
    func findPlacesOrderedByMatchesCount(on coordinate: Coordinate) async throws -> [Place]
    func findLocations(with keyword: String) async throws -> [Location]
    func fetchCurrentCoordinate() async throws -> Coordinate
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
}

enum PlacesRepositoryError: Error {
    case fetchFailed
    case coordinateNotUpdated
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
    func findPlacesOrderedByDistance(on coordinate: Coordinate) async throws -> [Place] {
        let endpoint = Endpoint.readPlacesByDistance(lat: coordinate.latitude, lon: coordinate.longitude)
        
        do {
            let response = try await networkService.request(endpoint: endpoint, for: PlacesSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func findPlacesOrderedByMatchesCount(on coordinate: Coordinate) async throws -> [Place] {
        let endpoint = Endpoint.readPlacesByDistance(lat: coordinate.latitude, lon: coordinate.longitude)
        
        do {
            let response = try await networkService.request(endpoint: endpoint, for: PlacesSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func findPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place] {
        // TODO: 키워드로 장소검색 Endpoint 필요
        let endpoint = Endpoint.readPlaces(name: keyword, lat: coordinate.latitude, lon: coordinate.longitude)
        
        do {
            let response = try await networkService.request(endpoint: endpoint, for: PlacesSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func findLocations(with keyword: String) async throws -> [Location] {
        do {
            if let currentCoordinate = currentCoordinate {
                let locations = await localMapService.search(by: keyword, on: currentCoordinate)
                return locations
            } else {
                let coordinate = try await fetchCurrentCoordinate()
                return await localMapService.search(by: keyword, on: coordinate)
            }
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func fetchCurrentCoordinate() async throws -> Coordinate {
        switch await locationService.updateOnce() {
        case .success(let coordinate):
            currentCoordinate = coordinate
            return coordinate
        case .failure(let error):
            throw error
        }
    }
    
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation) {
        localMapService.startSuggestion(with: continuation)
    }
    
    func stopSuggestion() {
        localMapService.stopSuggestion()
    }
    
    func provideSuggestions(by keyword: String) {
        if let currentCoordinate = currentCoordinate {
            localMapService.provideSuggestions(by: keyword, on: currentCoordinate)
        }
    }
}