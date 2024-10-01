//
//  LocalMapService.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import Foundation
import MapKit

protocol LocalMapService: NSObject, MKLocalSearchCompleterDelegate {
    typealias Coordinate = CLLocationCoordinate2D
    
    func search(by keyword: String) async -> [Coordinate]
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String, on coordinate: Coordinate)
}

final class DefaultLocalMapService: NSObject {
    private var completer: MKLocalSearchCompleter?
    
    private var currentSearch: MKLocalSearch?
    private var resultStreamContinuation: AsyncStream<[SuggestedResult]>.Continuation?
    
    private func performSearch(_ request: MKLocalSearch.Request) async -> [Coordinate] {
        currentSearch?.cancel()
        let search = MKLocalSearch(request: request)
        currentSearch = search
        defer { currentSearch = nil }
        
        var results: [MKMapItem] = []
        
        do {
            let response = try await search.start()
            results = response.mapItems
        } catch {
            results = []
        }
        
        return results.map { $0.placemark.coordinate }
    }
}

// MARK: LocalMapService Conformation
extension DefaultLocalMapService: LocalMapService {
    func search(by keyword: String) async -> [Coordinate] {
//        let simplifiedKeyword = keyword.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? keyword
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        return await performSearch(request)
    }
    
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation) {
        completer = MKLocalSearchCompleter()
        completer?.delegate = self
        resultStreamContinuation = continuation
    }
    
    func stopSuggestion() {
        completer = nil
        resultStreamContinuation?.finish()
        resultStreamContinuation = nil
    }
    
    func provideSuggestions(by keyword: String, on coordinate: Coordinate) {
        completer?.resultTypes = .pointOfInterest
        completer?.queryFragment = keyword
    }
}

// MARK: MKLocalSearchCompleterDelegate Confirmation
extension DefaultLocalMapService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let suggestedResults = completer.results.map { SuggestedResult($0) }
        resultStreamContinuation?.yield(suggestedResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        resultStreamContinuation?.yield([])
    }
}
