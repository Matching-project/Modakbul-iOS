//
//  LocalMapService.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

protocol LocalMapService: NSObject, MKLocalSearchCompleterDelegate {
    var suggestedResults: [MKLocalSearchCompletion] { get }
    
    func searchPlace(on region: MKCoordinateRegion, with keyword: String?) async -> [MKMapItem]
    func updateSearchingText(by text: String)
}

final class DefaultLocalMapService: NSObject {
    private let searchCompleter: MKLocalSearchCompleter
    
    @Published var suggestedResults: [MKLocalSearchCompletion] = []
    
    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self
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
    
    func updateSearchingText(by text: String) {
        searchCompleter.queryFragment = text
    }
}

// MARK: MKLocalSearchCompleterDelegate Conformation
extension DefaultLocalMapService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestedResults = completer.results
    }
}
