//
//  PlacesRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import CoreLocation

protocol PlacesRepository: TokenRefreshable {
    typealias Coordinate = CLLocationCoordinate2D
    
    func readPlaces(with keyword: String, on coordinate: Coordinate) async throws -> [Place]
    func readPlacesOrderedByDistance(on coordinate: Coordinate) async throws -> [Place]
    func readPlacesOrderedByMatchesCount(on coordinate: Coordinate) async throws -> [Place]
    func readCoordinateOnPlace(with keyword: String) async throws -> [Coordinate]
    func readCurrentCoordinate() async throws -> Coordinate
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String)
    
    func readPlacesForShowcaseAndReview(userId: Int64) async throws -> [Place]
    func reviewPlace(userId: Int64, on place: Place) async throws
    func suggestPlace(userId: Int64, on place: Place) async throws
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
        let endpoint = Endpoint.readPlacesByMatches(lat: coordinate.latitude, lon: coordinate.longitude)
        
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
    
    func readCoordinateOnPlace(with keyword: String) async throws -> [Coordinate] {
        return await localMapService.search(by: keyword)
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
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readPlacesForShowcaseAndReview(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedPlaceListSearchResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readPlacesForShowcaseAndReview(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedPlaceListSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func reviewPlace(userId: Int64, on place: Place) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let entity = ReviewPlaceRequestEntity(powerSocketState: place.powerSocketState, groupSeatingState: place.groupSeatingState)
            let endpoint = Endpoint.reviewPlace(token: token.accessToken, placeId: place.id, review: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let entity = ReviewPlaceRequestEntity(powerSocketState: place.powerSocketState, groupSeatingState: place.groupSeatingState)
            let endpoint = Endpoint.reviewPlace(token: tokens.accessToken, placeId: place.id, review: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func suggestPlace(userId: Int64, on place: Place) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let entity = SuggestPlaceRequestEntity(place: place)
            let endpoint = Endpoint.suggestPlace(token: token.accessToken, suggest: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let entity = SuggestPlaceRequestEntity(place: place)
            let endpoint = Endpoint.suggestPlace(token: tokens.accessToken, suggest: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
}
