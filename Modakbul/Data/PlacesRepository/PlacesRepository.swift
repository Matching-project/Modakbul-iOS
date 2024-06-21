//
//  PlacesRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import MapKit

protocol PlacesRepository: NSObject {
    func requestLocationUpdate() async throws -> Coordinate
    func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [Place]
    func suggestResults(by keyword: String) async -> [String]
}

enum PlacesRepositoryError: Error {
    
}

final class DefaultPlacesRepository: NSObject {
    private let localMapService: LocalMapService
    private let locationService: LocationService
    private let networkService: NetworkService
    
    init(
        localMapService: LocalMapService,
        locationService: LocationService,
        networkService: NetworkService
    ) {
        self.localMapService = localMapService
        self.locationService = locationService
        self.networkService = networkService
        super.init()
    }
}

// MARK: PlacesRepository confirmation
extension DefaultPlacesRepository: PlacesRepository {
    func requestLocationUpdate() async throws -> Coordinate {
        switch await locationService.updateOnce() {
        case .success(let coordinate): return coordinate.toDTO()
        case .failure(let error): throw error
        }
    }
    
    func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [Place] {
//        let locations = try await localMapService.findPlaces(on: region, with: keyword).map {
//            return Location(name: $0.name, coordinate: $0.placemark.coordinate.toDTO())
//        }
//        let endpoint = Endpoint.fetchPlaces(locations: locations)
//        return try await networkService.request(endpoint: endpoint, for: [PlaceEntity].self).map { $0.toDTO() }
        return [
            Place(id: "mock",
                  name: "mock",
                  coordinate: Coordinate(latitude: 32.1495, longitude: 32.1495),
                  images: nil)
        ]
    }
    
    func suggestResults(by keyword: String) async -> [String] {
        return await localMapService.suggestResults(by: keyword).map { $0.title }
    }
}
