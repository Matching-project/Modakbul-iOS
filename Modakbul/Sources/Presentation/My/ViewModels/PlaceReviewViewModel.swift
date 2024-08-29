//
//  PlaceReviewViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/29/24.
//

import Foundation

final class PlaceReviewViewModel: ObservableObject {
    @Published var powerSocketState: PowerSocketState = .moderate
    @Published var groupSeatingState: GroupSeatingState = .yes
    @Published var place: Place? = nil
    @Published var searchingText: String = String() {
        willSet {
            if newValue.isEmpty {
                searchedLocations.removeAll()
                suggestedResults.removeAll()
            } else {
                provideSuggestions(newValue)
            }
        }
    }
    @Published var selectedLocation: Location?
    @Published var searchedLocations: [Location] = []
    @Published var suggestedResults: [SuggestedResult] = []
    
    let groupSeatingStateSelection: [GroupSeatingState] = [.yes, .no]
    let powerSocketStateSelection: [PowerSocketState] = PowerSocketState.allCases

    private var updateSuggestedResultsTask: Task<Void, Never>?

    private let placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase

    init(placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase) {
        self.placeShowcaseAndReviewUseCase = placeShowcaseAndReviewUseCase
    }

    private func provideSuggestions(_ keyword: String) {
        placeShowcaseAndReviewUseCase.provideSuggestions(by: keyword)
    }
}

// MARK: Interfaces
extension PlaceReviewViewModel {
    @MainActor func searchLocation() {
        guard searchingText.isEmpty == false else { return }
        suggestedResults.removeAll()

        Task {
            do {
                searchedLocations = try await placeShowcaseAndReviewUseCase.fetchLocations(with: searchingText)
            } catch {
                searchedLocations = []
            }
        }
    }

    func startSuggestion() {
        let suggestedResultsStream = AsyncStream<[SuggestedResult]>.makeStream()
        placeShowcaseAndReviewUseCase.startSuggestion(with: suggestedResultsStream.continuation)
        updateSuggestedResultsTask = updateSuggestedResultsTask ?? Task { @MainActor in
            for await suggestedResults in suggestedResultsStream.stream {
                self.suggestedResults = suggestedResults
            }
        }
    }

    func stopSuggestion() {
        placeShowcaseAndReviewUseCase.stopSuggestion()
        searchingText.removeAll()
        searchedLocations = []
        suggestedResults = []
        updateSuggestedResultsTask?.cancel()
        updateSuggestedResultsTask = nil
        powerSocketState = .moderate
        groupSeatingState = .yes
        place = nil
    }
}
