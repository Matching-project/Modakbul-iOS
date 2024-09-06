//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit
import Combine

final class HomeViewModel: ObservableObject {
    @Published var isMapShowing: Bool = true
    @Published var region: MKCoordinateRegion
    @Published var searchingText: String = String()
    @Published var places: [Place] = PreviewHelper.shared.places
    @Published var selectedPlace: Place?
    @Published var sortCriteria: PlaceSortCriteria = .distance
    @Published var unreadCount: Int = 0
    private var locationNeeded: Bool = true
    
    private let localMapUseCase: LocalMapUseCase
    private let notificationUseCase: NotificationUseCase
    
    private let currentCoordinateSubject = PassthroughSubject<CLLocationCoordinate2D, Error>()
    private let placesSubject = PassthroughSubject<[Place], Error>()
    private var cancellables = Set<AnyCancellable>()
    
    init(localMapUseCase: LocalMapUseCase, notificationUseCase: NotificationUseCase) {
        self.localMapUseCase = localMapUseCase
        self.notificationUseCase = notificationUseCase
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        subscribe()
    }
    
    private func subscribe() {
        currentCoordinateSubject
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print(error)
                }
            } receiveValue: { [weak self] coordinate in
                self?.region.center = coordinate
            }
            .store(in: &cancellables)
        
        placesSubject
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print(error)
                }
            } receiveValue: { [weak self] places in
                self?.places = places
            }
            .store(in: &cancellables)
        
        $searchingText
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self,
                      text.isEmpty == false
                else { return }
                
                Task { await self.findPlaces(by: text, on: self.region.center) }
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
                let newCoordinate = try await localMapUseCase.updateCoordinate()
                currentCoordinateSubject.send(newCoordinate)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func findPlaces(by keyword: String? = nil, on coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                guard let keyword = keyword else {
                    let places = try await localMapUseCase.fetchPlaces(on: coordinate, by: sortCriteria)
                    placesSubject.send(places)
                    return
                }
                
                let places = try await localMapUseCase.fetchPlaces(with: keyword, on: coordinate)
                placesSubject.send(places)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func moveCameraOnLocation(to place: Place) {
        region.center = place.location.coordinate
        findPlaces(by: place.location.name, on: place.location.coordinate)
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
