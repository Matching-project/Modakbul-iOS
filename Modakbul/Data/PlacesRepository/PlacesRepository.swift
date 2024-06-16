//
//  PlacesRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import MapKit

protocol MapControllable: AnyObject {
    var region: MKCoordinateRegion { get set }
    var suggestedResults: [String] { get set }
    var searchingText: String { get set }
}

protocol PlacesRepository: NSObject {
    var delegate: MapControllable? { get set }
    
    func requestLocationUpdate()
    @MainActor func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [Place]
    func updateSearchingText(by text: String)
}

enum PlaceRepositoryError: Error {
    
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
    
    func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [Place] {
        let locations = try await localMapService.findPlaces(on: region, with: keyword).map {
            let coordinate = Coordinate(latitude: $0.placemark.coordinate.latitude, longitude: $0.placemark.coordinate.longitude)
            return Location(name: $0.name, coordinate: coordinate)
        }
        
        let endpoint = Endpoint.fetchPlaces(locations: locations)
        return try await networkService.request(endpoint: endpoint, for: [PlaceEntity].self).map { $0.toDTO() }
    }
    
    func updateSearchingText(by text: String) {
        localMapService.updateSearchingText(by: text)
    }
}

// MARK: LocationServiceDelegate Confirmation
extension DefaultPlacesRepository: LocationServiceDelegate {
    func didUpdateCoordinate(coordinate: CLLocationCoordinate2D) {
        delegate?.region.center = coordinate
    }
    
    func didFailWithError(error: LocationServiceError) {
        <#code#>
    }
}

// MARK: LocalMapServiceDelegate Confirmation
extension DefaultPlacesRepository: LocalMapServiceDelegate {
    func suggestedResultsDidUpdate(localMapService: any LocalMapService, suggestedResults: [MKLocalSearchCompletion]) {
        delegate?.suggestedResults = suggestedResults.map { $0.title }
    }
}
