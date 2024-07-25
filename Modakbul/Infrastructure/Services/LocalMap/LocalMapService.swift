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
    
    func search(by keyword: String, on coordinate: Coordinate) async -> [Location]
    func startSuggestion(with continuation: AsyncStream<[SuggestedResult]>.Continuation)
    func stopSuggestion()
    func provideSuggestions(by keyword: String, on coordinate: Coordinate)
}

final class DefaultLocalMapService: NSObject {
    private var completer: MKLocalSearchCompleter?
    
    private var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    private var currentSearch: MKLocalSearch?
    private var resultStreamContinuation: AsyncStream<[SuggestedResult]>.Continuation?
    
    private func performSearch(_ request: MKLocalSearch.Request) async -> [Location] {
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
        
        return results.map { Location($0.placemark) }
    }
}

// MARK: LocalMapService Conformation
extension DefaultLocalMapService: LocalMapService {
    func search(by keyword: String, on coordinate: Coordinate) async -> [Location] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(center: coordinate, span: span)
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
        completer?.region = MKCoordinateRegion(center: coordinate, span: span)
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
