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
}

protocol LocalMapService: NSObject, MKLocalSearchCompleterDelegate {
    var delegate: LocalMapServiceDelegate? { get set }
    
    func searchPlace(on region: MKCoordinateRegion, with keyword: String?) async -> [MKMapItem]
    func fetchSuggestedResults(by text: String)
}

final class DefaultLocalMapService: NSObject {
    private let searchCompleter: MKLocalSearchCompleter
    
    var delegate: LocalMapServiceDelegate?
    
    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        searchCompleter.delegate = self
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
}

// MARK: MKLocalSearchCompleterDelegate Conformation
extension DefaultLocalMapService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        delegate?.suggestedResultsDidUpdate(localMapService: self, results: completer.results)
    }
}
