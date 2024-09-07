//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import SwiftUI
import MapKit
import Combine

final class HomeViewModel: ObservableObject {
    @Published var isMapShowing: Bool = true
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var searchingText: String = String()
    @Published var places: [Place] = []
    @Published var selectedPlace: Place?
    @Published var sortCriteria: PlaceSortCriteria = .distance
    @Published var unreadCount: Int = 0
    private var locationNeeded: Bool = true
    private var currentCoordinate = CLLocationCoordinate2D()
    
    private let localMapUseCase: LocalMapUseCase
    private let notificationUseCase: NotificationUseCase
    
    private let placesSubject = PassthroughSubject<[Place], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(localMapUseCase: LocalMapUseCase, notificationUseCase: NotificationUseCase) {
        self.localMapUseCase = localMapUseCase
        self.notificationUseCase = notificationUseCase
        subscribe()
    }
    
    private func subscribe() {
        placesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] places in
                self?.places = places
                self?.cameraPosition = .automatic
            }
            .store(in: &cancellables)
        
        $searchingText
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self,
                      text.isEmpty == false
                else { return }
                
                Task { await self.findPlaces(by: text, on: self.currentCoordinate) }
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces for LocalMapUseCase
extension HomeViewModel {
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
    
    @MainActor func findPlaces(by keyword: String? = nil, on coordinate: CLLocationCoordinate2D? = nil) {
        Task {
            do {
                guard let center = cameraPosition.camera?.centerCoordinate else { return }
                
                guard let keyword = keyword else {
                    let places = try await localMapUseCase.fetchPlaces(on: coordinate ?? center, by: sortCriteria)
                    placesSubject.send(places)
                    return
                }
                
                let places = try await localMapUseCase.fetchPlaces(with: keyword, on: coordinate ?? center)
                placesSubject.send(places)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Interface for NotificationUseCase
extension HomeViewModel {
    @MainActor
    func fetchUnreadNotificationCount() {
        Task {
            do {
                unreadCount = try await notificationUseCase.fetchUnreadCount()
            } catch {
                print(error)
            }
        }
    }
}
