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
    
    @Published var searchingText: String = String()
    
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion())
    var suggestedResults: [String] = []
    var places: [Place] = []
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
        self.region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
    @MainActor func suggestResults(_ keyword: String) {
        Task {
            suggestedResults = await placesRepository.suggestResults(by: keyword)
        }
    }
    
    @MainActor func updateLocationOnce() {
        Task {
            let coordinate = try await placesRepository.requestLocationUpdate()
            let newRegion = MKCoordinateRegion(
                center: coordinate.toCLCoordinate(),
                span: region.span
            )
            cameraPosition = .region(newRegion)
            findPlace(by: nil)
        }
    }
    
    @MainActor func findPlace(by keyword: String?) {
        Task {
            do {
                places = try await placesRepository.findPlaces(on: region, with: keyword)
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
