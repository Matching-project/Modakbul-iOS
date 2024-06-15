//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

final class HomeViewModel: NSObject, ObservableObject {
    private let localMapService: LocalMapService
    private let locationService: LocationService
    
    @Published var searchingText: String = String()
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var places: [MKMapItem] = []
    var searchSuggestions: [MKLocalSearchCompletion] { localMapService.suggestedResults }
    
    init(
        localMapService: LocalMapService,
        locationService: LocationService
    ) {
        self.localMapService = localMapService
        self.locationService = locationService
        super.init()
        self.locationService.delegate = self
        self.region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
    func updateLocationOnce() {
        locationService.updateOnce()
    }
    
    func stopUpdatingLocation() {
        locationService.stop()
    }
}

// MARK: LocationServiceDelegate Conformation
extension HomeViewModel: LocationServiceDelegate {
    func didUpdateLocations(locations: [CLLocation]) {
        guard let location = locations.first else { return }
        region.center = location.coordinate
    }
    
    func didFailWithError(error: LocationServiceError) {
        print(error)
    }
}
