//
//  LocalMapService.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

protocol LocalMapServiceDelegate: AnyObject {
    func suggestedResultsDidUpdate(localMapService: LocalMapService, suggestedResults: [MKLocalSearchCompletion])
}

protocol LocalMapService: NSObject, MKLocalSearchCompleterDelegate {
    var delegate: LocalMapServiceDelegate? { get set }
    
    @MainActor func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [MKMapItem]
    func updateSearchingText(by text: String)
}

final class DefaultLocalMapService: NSObject {
    private let searchCompleter: MKLocalSearchCompleter
    
    weak var delegate: LocalMapServiceDelegate?
    
    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self
    }
}

// MARK: LocalMapService Conformation
extension DefaultLocalMapService: LocalMapService {
    func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [MKMapItem] {
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
        delegate?.suggestedResultsDidUpdate(localMapService: self, suggestedResults: completer.results)
    }
}
