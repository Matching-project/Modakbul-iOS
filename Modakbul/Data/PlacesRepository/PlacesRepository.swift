//
//  PlacesRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import MapKit

protocol MapControllable: AnyObject {
    @MainActor func coordinateDidUpdate(_ locationService: LocationService, coordinate: Coordinate)
    @MainActor func suggestedResultsDidUpdate(_ localMapService: LocalMapService, results: [String])
    @MainActor func searchResultsDidUpdate(_ localMapService: LocalMapService, results: [Place])
}

protocol PlacesRepository: NSObject {
    var delegate: MapControllable? { get set }
    
    func requestLocationUpdate()
    @MainActor func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws
    func updateSearchingText(by text: String)
}

enum PlacesRepositoryError: Error {
    
}

final class DefaultPlacesRepository: NSObject {
    weak var delegate: MapControllable?
    
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
        self.localMapService.delegate = self
        self.locationService.delegate = self
    }
}

// MARK: PlacesRepository confirmation
extension DefaultPlacesRepository: PlacesRepository {
    func requestLocationUpdate() {
        locationService.updateOnce()
    }
    
    @MainActor func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws {
        Task {
            let locations = try await localMapService.findPlaces(on: region, with: keyword).map {
                let coordinate = $0.placemark.coordinate.toDTO()
                return Location(name: $0.name, coordinate: coordinate)
            }
//            let endpoint = Endpoint.fetchPlaces(locations: locations)
//            let places = try await networkService.request(endpoint: endpoint, for: [PlaceEntity].self).map { $0.toDTO() }
            delegate?.searchResultsDidUpdate(localMapService, results: [Place(id: "id", 
                                                                              name: "name",
                                                                              coordinate: Coordinate(latitude: 32.3141, longitude: 32.4345),
                                                                              images: [])])
        }
    }
    
    func updateSearchingText(by text: String) {
        localMapService.updateSearchingText(by: text)
    }
}

// MARK: LocationServiceDelegate Confirmation
extension DefaultPlacesRepository: LocationServiceDelegate {
    @MainActor func didUpdateCoordinate(coordinate: CLLocationCoordinate2D) {
        delegate?.coordinateDidUpdate(locationService, coordinate: coordinate.toDTO())
    }
    
    func didFailWithError(error: LocationServiceError) {
        print(error)
    }
}

// MARK: LocalMapServiceDelegate Confirmation
extension DefaultPlacesRepository: LocalMapServiceDelegate {
    @MainActor func suggestedResultsDidUpdate(localMapService: any LocalMapService, suggestedResults: [MKLocalSearchCompletion]) {
        delegate?.suggestedResultsDidUpdate(localMapService, results: suggestedResults.map { $0.title })
    }
}
