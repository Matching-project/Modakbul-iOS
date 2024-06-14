//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

final class HomeViewModel: NSObject, ObservableObject {
    @Published var searchingText: String = String() {
        willSet { fetchSuggestions(with: newValue) }
    }
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var places: [MKMapItem] = []
    @Published var searchSuggestions: [MKLocalSearchCompletion] = []
    
    private let localMapService: LocalMapService
    
    init(localMapService: LocalMapService) {
        self.localMapService = localMapService
        super.init()
        self.localMapService.delegate = self
        self.region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
    private func fetchSuggestions(with keyword: String) {
        localMapService.fetchSuggestedResults(by: keyword)
    }
    
    private func _searchPlace(_ region: MKCoordinateRegion, _ keyword: String? = nil) {
        Task {
            await localMapService.searchPlace(on: region, with: keyword)
        }
    }
    
    @MainActor func searchPlace(with keyword: String) {
        _searchPlace(region, keyword)
    }
    
    func startLocationUpdating() {
        localMapService.start()
    }
    
    func stopLocationUpdating() {
        localMapService.stop()
    }
}

// MARK: LocalMapServiceDelegate Conformation
extension HomeViewModel: LocalMapServiceDelegate {
    func suggestedResultsDidUpdate(localMapService: any LocalMapService, results: [MKLocalSearchCompletion]) {
        searchSuggestions = results
    }
    
    func didUpdateLocations(locations: [CLLocation]) {
        guard let location = locations.first else { return }
        region.center = location.coordinate
    }
    
    func didFailWithError(error: LocationServiceError) {
        print(error)
    }
}
