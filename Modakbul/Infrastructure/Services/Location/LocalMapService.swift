//
//  LocalMapService.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

protocol LocalMapServiceDelegate {
    func suggestedResultsDidUpdate(localMapService: LocalMapService, results: [MKLocalSearchCompletion])
    func didUpdateLocations(locations: [CLLocation])
    func didFailWithError(error: LocationServiceError)
}

protocol LocalMapService: NSObject, MKLocalSearchCompleterDelegate, LocationServiceDelegate {
    var delegate: LocalMapServiceDelegate? { get set }
    
    func searchPlace(on region: MKCoordinateRegion, with keyword: String?) async -> [MKMapItem]
    func fetchSuggestedResults(by text: String)
    func start()
    func stop()
    func updateOnce()
}

final class DefaultLocalMapService: NSObject {
    var delegate: LocalMapServiceDelegate?
    
    private let locationService: LocationService
    private let searchCompleter: MKLocalSearchCompleter
    
    init(
        searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter(),
        locationService: LocationService
    ) {
        self.searchCompleter = searchCompleter
        self.locationService = locationService
        super.init()
        searchCompleter.delegate = self
        locationService.delegate = self
    }
}

// MARK: LocalMapService Conformation
extension DefaultLocalMapService: LocalMapService {
    func searchPlace(on region: MKCoordinateRegion, with keyword: String?) async -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword ?? "커피숍"
        request.region = region
        
        guard let response = try? await MKLocalSearch(request: request).start() else {
            return []
        }
        return response.mapItems
    }
    
    func fetchSuggestedResults(by text: String) {
        searchCompleter.queryFragment = text
    }
    
    func start() {
        locationService.start()
    }
    
    func stop() {
        locationService.stop()
    }
    
    func updateOnce() {
        locationService.updateOnce()
    }
}

// MARK: MKLocalSearchCompleterDelegate Conformation
extension DefaultLocalMapService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        delegate?.suggestedResultsDidUpdate(localMapService: self, results: completer.results)
    }
}

// MARK: LocationServiceDelegate Conformation
extension DefaultLocalMapService: LocationServiceDelegate {
    func didUpdateLocations(locations: [CLLocation]) {
        delegate?.didUpdateLocations(locations: locations)
    }
    
    func didFailWithError(error: LocationServiceError) {
        delegate?.didFailWithError(error: error)
    }
}
