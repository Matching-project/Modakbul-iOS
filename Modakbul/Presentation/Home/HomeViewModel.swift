//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit
import SwiftUI

final class HomeViewModel: ObservableObject {
    private let placesRepository: PlacesRepository
    
    @Published var searchingText: String = String() {
        willSet { placesRepository.updateSearchingText(by: newValue) }
    }
    
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion())
    var suggestedResults: [String] = []
    var places: [Place] = []
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
        self.placesRepository.delegate = self
        self.region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
    func updateLocationOnce() {
        placesRepository.requestLocationUpdate()
    }
    
    @MainActor func findPlace(by keyword: String?) {
        Task {
            do {
                try await placesRepository.findPlaces(on: region, with: keyword)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func moveCameraOnLocation(to place: Place?) {
        guard let place = place else {
            return updateLocationOnce()
        }
        findPlace(by: place.name)
    }
}

// MARK: MapControllable Confirmation
extension HomeViewModel: MapControllable {
    func coordinateDidUpdate(_ locationService: any LocationService, coordinate: Coordinate) {
        let newRegion = MKCoordinateRegion(
            center: coordinate.toCLCoordinate(),
            span: region.span
        )
        cameraPosition = .region(newRegion)
        findPlace(by: nil)
    }
    
    func suggestedResultsDidUpdate(_ localMapService: any LocalMapService, results: [String]) {
        suggestedResults = results
    }
    
    func searchResultsDidUpdate(_ localMapService: any LocalMapService, results: [Place]) {
        places = results
    }
}
