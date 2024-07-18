//
//  PlaceShowcaseViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import Foundation

final class PlaceShowcaseViewModel: ObservableObject {
    private let localMapUseCase: LocalMapUseCase
    
    init(localMapUseCase: LocalMapUseCase) {
        self.localMapUseCase = localMapUseCase
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
                searchedLocations = try await localMapUseCase.fetchLocations(with: searchingText)
            } catch {
                searchedLocations = []
            }
        }
    }
    
    func startSuggestion() {
        let suggestedResultsStream = AsyncStream<[SuggestedResult]>.makeStream()
        localMapUseCase.startSuggestion(with: suggestedResultsStream.continuation)
        updateSuggestedResultsTask = updateSuggestedResultsTask ?? Task { @MainActor in
            for await suggestedResults in suggestedResultsStream.stream {
                self.suggestedResults = suggestedResults
            }
        }
    }
    
    func stopSuggestion() {
        localMapUseCase.stopSuggestion()
        searchingText.removeAll()
        searchedLocations = []
        suggestedResults = []
        updateSuggestedResultsTask?.cancel()
        updateSuggestedResultsTask = nil
    }
    
    private func provideSuggestions(_ keyword: String) {
        localMapUseCase.provideSuggestions(by: keyword)
    }
}
