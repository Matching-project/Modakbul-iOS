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
    @Published var cameraCenterCoordinate: CLLocationCoordinate2D = .init()
    @Published var searchingText: String = String()
    @Published var places: [Place] = []
    @Published var searchedPlaces: [Place] = []
    @Published var sortCriteria: PlaceSortCriteria = .distance
    @Published var unreadCount: Int = 0
    private var locationNeeded: Bool = true
    private var currentUsersCoordinate = CLLocationCoordinate2D()
    
    private let localMapUseCase: LocalMapUseCase
    private let notificationUseCase: NotificationUseCase
    
    private let placesSubject = PassthroughSubject<[Place], Never>()
    private let searchedPlacesSubject = PassthroughSubject<[Place], Never>()
    private let notificationsSubject = PassthroughSubject<[PushNotification], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(localMapUseCase: LocalMapUseCase, notificationUseCase: NotificationUseCase) {
        self.localMapUseCase = localMapUseCase
        self.notificationUseCase = notificationUseCase
        subscribe()
    }
    
    private func subscribe() {
        
        // TODO: - 지도 화면 이동시 장소 새로고침 지원 해야 하나?
//        $cameraCenterCoordinate
//            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
//            .sink { [weak self] center in
//                guard let self = self else { return }
//                Task { await self.findPlaces(by: nil, on: center) }
//            }
//            .store(in: &cancellables)
        
        placesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] places in
                self?.places = places
                
                #if DEBUG
                print(places.map {$0.location.name})
                #endif
            }
            .store(in: &cancellables)
        
        searchedPlacesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] places in
                self?.searchedPlaces = places
            }
            .store(in: &cancellables)
        
        notificationsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notifications in
                self?.unreadCount = notifications.filter { $0.isRead == false }.count
            }
            .store(in: &cancellables)
        
        $searchingText
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self,
                      text.isEmpty == false
                else {
                    self?.searchedPlacesSubject.send([])
                    return
                }
                
                Task { await self.findPlaces(by: text, on: self.cameraCenterCoordinate) }
            }
            .store(in: &cancellables)
        
        $sortCriteria
            .sink { _ in
                Task { await self.findPlaces( on: self.currentUsersCoordinate) }
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
            findPlaces()
        }
    }
    
    @MainActor func updateLocationOnce() {
        Task {
            do {
                currentUsersCoordinate = try await localMapUseCase.updateCoordinate()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor func findPlaces(by keyword: String? = nil, on coordinate: CLLocationCoordinate2D? = nil) {
        Task {
            do {
                // MARK: - 새로고침 버튼을 터치했을 때 장소를 불러옵니다.
                guard let keyword = keyword else {
                    let places = try await localMapUseCase.fetchPlaces(on: coordinate ?? cameraCenterCoordinate, by: sortCriteria)
                    placesSubject.send(places)
                    return
                }
                
                // MARK: - 검색어가 있을 때 장소를 불러옵니다.
                let places = try await localMapUseCase.fetchPlaces(with: keyword, on: coordinate ?? cameraCenterCoordinate)
                searchedPlacesSubject.send(places)
            } catch {
                print(error)
            }
        }
    }
    
    func selectPlace(_ place: Place) {
        let center = place.location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        cameraPosition = .region(.init(center: center, span: span))
        searchingText.removeAll()
        searchedPlacesSubject.send([])
        placesSubject.send([place])
    }
    
    func moveToUserLocation() {
        cameraPosition = .userLocation(fallback: .automatic)
    }
}

// MARK: - Interfaces for NotificationUseCase
extension HomeViewModel {
    func fetchUnreadNotificationCount(userId: Int?) async {
        guard let userId = userId else { return }
        
        do {
            let pushNotifications = try await notificationUseCase.fetch(userId: Int64(userId))
            notificationsSubject.send(pushNotifications)
        } catch {
            print(error)
        }
    }
}
