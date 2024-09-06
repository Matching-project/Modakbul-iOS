//
//  PlaceReviewViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/29/24.
//

import Foundation
import Combine

final class PlaceReviewViewModel: ObservableObject {
    @Published var powerSocketState: PowerSocketState = .moderate
    @Published var groupSeatingState: GroupSeatingState = .yes
    @Published var place: Place? = nil
    @Published var searchingText: String = String()
    @Published var selectedLocation: Location?
    @Published var searchedLocations: [Location] = []
    @Published var suggestedResults: [SuggestedResult] = []
    
    let groupSeatingStateSelection: [GroupSeatingState] = [.yes, .no]
    let powerSocketStateSelection: [PowerSocketState] = PowerSocketState.allCases

    private let locationsSubject = PassthroughSubject<[Location], Never>()
    private let suggestedResultsSubject = PassthroughSubject<[SuggestedResult], Never>()
    private var cancellables = Set<AnyCancellable>()
    private var updateSuggestedResultsTask: Task<Void, Never>?

    private let placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase

    init(placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase) {
        self.placeShowcaseAndReviewUseCase = placeShowcaseAndReviewUseCase
        subscribe()
    }
    
    private func subscribe() {
        $searchingText
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { [weak self] keyword in
                self?.provideSuggestions(keyword)
            }
            .store(in: &cancellables)
        
        locationsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locations in
                self?.searchedLocations = locations
            }
            .store(in: &cancellables)
        
        suggestedResultsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.suggestedResults = results
            }
            .store(in: &cancellables)
    }

    private func provideSuggestions(_ keyword: String) {
        placeShowcaseAndReviewUseCase.provideSuggestions(by: keyword)
    }
}

// MARK: Interfaces
extension PlaceReviewViewModel {
    func searchLocation() {
        guard searchingText.isEmpty == false else { return }
        suggestedResults.removeAll()

        Task {
            do {
                let searchedLocations = try await placeShowcaseAndReviewUseCase.fetchLocations(with: searchingText)
                locationsSubject.send(searchedLocations)
            } catch {
                locationsSubject.send([])
            }
        }
    }

    func startSuggestion() {
        let suggestedResultsStream = AsyncStream<[SuggestedResult]>.makeStream()
        placeShowcaseAndReviewUseCase.startSuggestion(with: suggestedResultsStream.continuation)
        updateSuggestedResultsTask = updateSuggestedResultsTask ?? Task {
            for await suggestedResults in suggestedResultsStream.stream {
                suggestedResultsSubject.send(suggestedResults)
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
    
    func submit(isNewPlace: Bool) {
        guard let location = selectedLocation else { return }
        let place = Place(location: location,
                          powerSocketState: powerSocketState,
                          groupSeatingState: groupSeatingState)
        
        Task {
            do {
                if isNewPlace {
                    try await placeShowcaseAndReviewUseCase.suggestPlace(on: place)
                } else {
                    try await placeShowcaseAndReviewUseCase.reviewPlace(on: place)
                }
            } catch {
                print(error)
            }
        }
    }
}
