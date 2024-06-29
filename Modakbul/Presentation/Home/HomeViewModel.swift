//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private let fetchPlacesUseCase: FetchPlacesUseCase
    private let updateCoordinateUseCase: UpdateCoordinateUseCase
    
    @Published var currentCoordinate: Coordinate = Coordinate(latitude: .zero, longitude: .zero)
    @Published var searchingText: String = String()
    var places: [Place] = []
    var selectedPlace: Place?
    
    init(
        fetchPlacesUseCase: FetchPlacesUseCase,
        updateCoordinateUseCase: UpdateCoordinateUseCase
    ) {
        self.fetchPlacesUseCase = fetchPlacesUseCase
        self.updateCoordinateUseCase = updateCoordinateUseCase
    }
    
    @MainActor func updateLocationOnce() {
        Task {
            do {
                currentCoordinate = try await updateCoordinateUseCase.updateLocation()
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
                    self.places = try await fetchPlacesUseCase.fetchPlaces(on: currentCoordinate)
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
