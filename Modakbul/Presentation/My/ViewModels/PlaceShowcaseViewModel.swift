//
//  PlaceShowcaseViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import Foundation

final class PlaceShowcaseViewModel: ObservableObject {
    private let fetchPlaceUseCase: FetchPlacesUseCase
    
    init(fetchPlaceUseCase: FetchPlacesUseCase) {
        self.fetchPlaceUseCase = fetchPlaceUseCase
    }
    
    @Published var searchingText: String = String() {
        willSet {
            if newValue.isEmpty {
                searchedLocations = []
                suggestedResults = []
            } else {
                provideSuggestions(newValue)
            }
        }
    }
    @Published var selectedLocation: Location?
    @Published var searchedLocations: [Location] = []
    @Published var suggestedResults: [SuggestedResult] = []
    
    private var updateSuggestedResultsTask: Task<Void, Never>?
    
    @MainActor func searchLocation() {
        guard searchingText.isEmpty == false else { return }
        suggestedResults = []
        
        Task {
            do {
                searchedLocations = try await fetchPlaceUseCase.fetchLocations(with: searchingText)
            } catch {
                searchedLocations = []
            }
        }
    }
    
    func startSuggestion() {
        let suggestedResultsStream = AsyncStream<[SuggestedResult]>.makeStream()
        fetchPlaceUseCase.startSuggestion(with: suggestedResultsStream.continuation)
        updateSuggestedResultsTask = updateSuggestedResultsTask ?? Task { @MainActor in
            for await suggestedResults in suggestedResultsStream.stream {
                self.suggestedResults = suggestedResults
            }
        }
    }
    
    func stopSuggestion() {
        fetchPlaceUseCase.stopSuggestion()
        searchingText.removeAll()
        searchedLocations = []
        suggestedResults = []
        updateSuggestedResultsTask?.cancel()
        updateSuggestedResultsTask = nil
    }
    
    private func provideSuggestions(_ keyword: String) {
        fetchPlaceUseCase.provideSuggestions(by: keyword)
    }
}
