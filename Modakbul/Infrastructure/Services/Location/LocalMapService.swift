//
//  LocalMapService.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

protocol LocalMapService: NSObject, MKLocalSearchCompleterDelegate {
    @MainActor func findPlaces(on region: MKCoordinateRegion, with keyword: String?) async throws -> [MKMapItem]
    func suggestResults(by keyword: String) async -> [MKLocalSearchCompletion]
}

final class DefaultLocalMapService: NSObject {
    private let searchCompleter: MKLocalSearchCompleter
    
    private var updateSuggestResultsTask: (([MKLocalSearchCompletion]) -> Void)?
    
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
    
    func suggestResults(by keyword: String) async -> [MKLocalSearchCompletion] {
        return await withCheckedContinuation { continuation in
            updateSuggestResultsTask = {
                continuation.resume(returning: $0)
            }
            searchCompleter.queryFragment = keyword
        }
    }
}

// MARK: MKLocalSearchCompleterDelegate Confirmation
extension DefaultLocalMapService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        updateSuggestResultsTask?(completer.results)
        updateSuggestResultsTask = nil
    }
}
