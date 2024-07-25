//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import CoreLocation

final class HomeViewModel: ObservableObject {
    private let localMapUseCase: LocalMapUseCase
    
    @Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var searchingText: String = String()
    var places: [Place] = []
    var selectedPlace: Place?
    
    init(localMapUseCase: LocalMapUseCase) {
        self.localMapUseCase = localMapUseCase
    }
    
    @MainActor func updateLocationOnce() {
        Task {
            do {
                currentCoordinate = try await localMapUseCase.updateCoordinate()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func findPlace(by keyword: String?) {
        Task {
            do {
                if let keyword = keyword {
                    self.selectedPlace = try await localMapUseCase.fetchPlace(with: keyword)
                } else {
                    self.places = try await localMapUseCase.fetchPlaces(on: currentCoordinate)
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
            findPlace(by: place.location.name)
        }
    }
}
