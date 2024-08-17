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
    
    @Published var isMapShowing: Bool = true
    @Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var searchingText: String = String()
    var places: [Place] = PreviewHelper.shared.places
    var selectedPlace: Place?
    
    private var locationNeeded: Bool = true
    
    init(localMapUseCase: LocalMapUseCase) {
        self.localMapUseCase = localMapUseCase
    }
    
    @MainActor func updateLocationOnceIfNeeded() {
        if locationNeeded {
            updateLocationOnce()
            locationNeeded = false
        }
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
    
    @MainActor func findPlaces(on coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                places = try await localMapUseCase.fetchPlaces(on: coordinate)
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
