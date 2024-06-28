//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

final class HomeViewModel: ObservableObject {
    private let fetchPlacesUseCase: FetchPlacesUseCase
    private let updateCoordinateUseCase: UpdateCoordinateUseCase
    
    // TODO: Publishing changes from within view updates is not allowed. 보라색 문제 해결하기.
    @Published var region: MKCoordinateRegion
    @Published var places: [Place] = []
    @Published var selectedPlace: Place?
    @Published var searchingText: String = String()
    
    init(
        fetchPlacesUseCase: FetchPlacesUseCase,
        updateCoordinateUseCase: UpdateCoordinateUseCase
    ) {
        self.fetchPlacesUseCase = fetchPlacesUseCase
        self.updateCoordinateUseCase = updateCoordinateUseCase
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    @MainActor func updateLocationOnce() {
        Task {
            do {
                region.center = try await updateCoordinateUseCase.updateLocation().toCLCoordinate()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func findPlace(by keyword: String?) {
        Task {
            do {
                if let keyword = keyword {
                    self.selectedPlace = try await fetchPlacesUseCase.fetchPlace(with: keyword)
                } else {
                    self.places = try await fetchPlacesUseCase.fetchPlaces(on: region.center.toDTO())
                }
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func moveCameraOnLocation(to place: Place?) {
        Task {
            guard let place = place else {
                return updateLocationOnce()
            }
            findPlace(by: place.name)
        }
    }
}
