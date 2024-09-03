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
    
    func readPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place]
    func readPlacesOrderedByDistance(on coordinate: Coordinate) async throws -> [Place]
    func readPlacesOrderedByMatchesCount(on coordinate: Coordinate) async throws -> [Place]
    func readLocations(with keyword: String) async throws -> [Location]
    func readCurrentCoordinate() async throws -> Coordinate
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
    
    func readPlacesForShowcaseAndReview(userId: Int64) async throws -> [Place]
    func reviewPlace(on place: Place) async throws
    func suggestPlace(on place: Place) async throws
}

enum PlacesRepositoryError: Error {
    case fetchFailed
    case coordinateNotUpdated
}

final class DefaultPlacesRepository {
    let networkService: NetworkService
    private let localMapService: LocalMapService
    private let locationService: LocationService
    let tokenStorage: TokenStorage
    
    private var currentCoordinate: Coordinate?
    
    init(
        networkService: NetworkService,
        localMapService: LocalMapService,
        locationService: LocationService,
        tokenStorage: TokenStorage
    ) {
        self.networkService = networkService
        self.localMapService = localMapService
        self.locationService = locationService
        self.tokenStorage = tokenStorage
    }
}

// MARK: PlacesRepository Conformation
extension DefaultPlacesRepository: PlacesRepository {
    func readPlacesOrderedByDistance(on coordinate: Coordinate) async throws -> [Place] {
        let endpoint = Endpoint.readPlacesByDistance(lat: coordinate.latitude, lon: coordinate.longitude)
        
        do {
            let response = try await networkService.request(endpoint: endpoint, for: PlacesSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func readPlacesOrderedByMatchesCount(on coordinate: Coordinate) async throws -> [Place] {
        let endpoint = Endpoint.readPlacesByDistance(lat: coordinate.latitude, lon: coordinate.longitude)
        
        do {
            let response = try await networkService.request(endpoint: endpoint, for: PlacesSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func readPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place] {
        let endpoint = Endpoint.readPlaces(name: keyword, lat: coordinate.latitude, lon: coordinate.longitude)
        
        do {
            let response = try await networkService.request(endpoint: endpoint, for: PlacesSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func readLocations(with keyword: String) async throws -> [Location] {
        do {
            if let currentCoordinate = currentCoordinate {
                let locations = await localMapService.search(by: keyword, on: currentCoordinate)
                return locations
            } else {
                let coordinate = try await readCurrentCoordinate()
                return await localMapService.search(by: keyword, on: coordinate)
            }
        } catch {
            throw PlacesRepositoryError.fetchFailed
        }
    }
    
    func readCurrentCoordinate() async throws -> Coordinate {
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
    
    func readPlacesForShowcaseAndReview(userId: Int64) async throws -> [Place] {
        do {
            let token = try tokenStorage.fetch(by: userId)
            let endpoint = Endpoint.readPlacesForShowcaseAndReview(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedPlaceListSearchResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let token = try tokenStorage.fetch(by: userId)
            let endpoint = Endpoint.reissueToken(refreshToken: token.refreshToken)
            let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            
            guard let accessToken = response.accessToken,
                  let refreshToken = response.refreshToken
            else { throw APIError.responseError }
            
            try tokenStorage.store(TokensEntity(accessToken: accessToken, refreshToken: refreshToken), by: userId)
            
            let retryEndpoint = Endpoint.readPlacesForShowcaseAndReview(token: accessToken)
            let retryResponse = try await networkService.request(endpoint: retryEndpoint, for: RelatedPlaceListSearchResponseEntity.self)
            return retryResponse.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func reviewPlace(on place: Place) async throws {
        let entity = ReviewPlaceRequestEntity(powerSocketState: place.powerSocketState, groupSeatingState: place.groupSeatingState)
        let endpoint = Endpoint.reviewPlace(placeId: place.id, review: entity)
        try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
    }
    
    func suggestPlace(on place: Place) async throws {
        let entity = SuggestPlaceRequestEntity(place: place)
        let endpoint = Endpoint.suggestPlace(suggest: entity)
        try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
    }
}
