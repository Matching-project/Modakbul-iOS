//
//  PlaceReviewViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/29/24.
//

import Foundation
import Combine
import CoreLocation

final class PlaceReviewViewModel: ObservableObject {
    @Published var powerSocketState: PowerSocketState = .moderate
    @Published var groupSeatingState: GroupSeatingState = .yes
    @Published var place: Place? = nil
    @Published var searchingText: String = String()
    @Published var selectedLocation: Location?
    @Published var suggestedResults: [SuggestedResult] = []
    @Published var isSubmitButtonDisabled: Bool = true
    @Published var submitCompletion: Bool = false
    
    let groupSeatingStateSelection: [GroupSeatingState] = [.yes, .no]
    let powerSocketStateSelection: [PowerSocketState] = PowerSocketState.allCases

    private let locationsSubject = PassthroughSubject<[Location], Never>()
    private let suggestedResultsSubject = PassthroughSubject<[SuggestedResult], Never>()
    private let submitCompletionSubject = PassthroughSubject<Bool, Never>()
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
                self?.selectedLocation = locations.first
            }
            .store(in: &cancellables)
        
        suggestedResultsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.suggestedResults = results
            }
            .store(in: &cancellables)
        
        $place
            .sink { [weak self] place in
                self?.isSubmitButtonDisabled = place == nil
            }
            .store(in: &cancellables)
        
        $selectedLocation
            .sink { [weak self] location in
                self?.isSubmitButtonDisabled = location == nil
            }
            .store(in: &cancellables)
    }

    private func provideSuggestions(_ keyword: String) {
        placeShowcaseAndReviewUseCase.provideSuggestions(by: keyword)
    }
}

// MARK: Interfaces
extension PlaceReviewViewModel {
    func searchLocation(title: String, subtitle: String) {
        let searchingText = subtitle + ", " + title
        suggestedResults.removeAll()

        Task {
            do {
                let locations = try await placeShowcaseAndReviewUseCase.fetchCoordinateOnPlace(with: searchingText).map {
                    Location(name: title, address: subtitle, coordinate: $0)
                }
                locationsSubject.send(locations)
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
        selectedLocation = nil
        suggestedResults = []
        updateSuggestedResultsTask?.cancel()
        updateSuggestedResultsTask = nil
        powerSocketState = .moderate
        groupSeatingState = .yes
        place = nil
        submitCompletion = false
    }
    
    func selectSuggestion(_ suggestedResult: SuggestedResult) {
        searchLocation(title: suggestedResult.title, subtitle: suggestedResult.subtitle)
    }
    
    func submit(userId: Int64, on place: Place?) {
        let isNewPlace = place == nil
        
        Task {
            do {
                if isNewPlace {
                    guard let location = selectedLocation else { return }
                    let place = Place(location: location,
                                      powerSocketState: powerSocketState,
                                      groupSeatingState: groupSeatingState)
                    try await placeShowcaseAndReviewUseCase.suggestPlace(userId: userId, on: place)
                    submitCompletionSubject.send(true)
                } else {
                    guard let place = place else { return }
                    let reviewingPlace = Place(id: place.id,
                                               location: place.location,
                                               powerSocketState: powerSocketState,
                                               groupSeatingState: groupSeatingState)
                    try await placeShowcaseAndReviewUseCase.reviewPlace(userId: userId, on: reviewingPlace)
                    submitCompletionSubject.send(true)
                }
            } catch {
                submitCompletionSubject.send(false)
                print(error)
            }
        }
    }
}
