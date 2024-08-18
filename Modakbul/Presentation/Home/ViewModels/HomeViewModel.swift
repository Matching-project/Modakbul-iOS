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
    @Published var places: [Place] = PreviewHelper.shared.places
    @Published var selectedPlace: Place?
    
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
    
    @MainActor func findPlaces(by keyword: String? = nil, on coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                guard let keyword = keyword else {
                    places = try await localMapUseCase.fetchPlaces(on: coordinate)
                    return
                }
                
                places = try await localMapUseCase.fetchPlaces(with: keyword, on: coordinate)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func moveCameraOnLocation(to place: Place) {
        findPlaces(by: place.location.name, on: place.location.coordinate)
        currentCoordinate = place.location.coordinate
    }
}
