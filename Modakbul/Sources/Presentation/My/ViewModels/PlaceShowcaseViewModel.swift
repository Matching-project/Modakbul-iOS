//
//  PlaceShowcaseViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import Foundation
import Combine

final class PlaceShowcaseViewModel: ObservableObject {
    @Published var places: [Place] = []
    
    private let placesSubject = PassthroughSubject<[Place], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase
    
    init(placeShowcaseAndReviewUseCase: PlaceShowcaseAndReviewUseCase) {
        self.placeShowcaseAndReviewUseCase = placeShowcaseAndReviewUseCase
        subscribe()
    }
    
    private func subscribe() {
        placesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] places in
                self?.places = places
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension PlaceShowcaseViewModel {
    func fetchPlaces(userId: Int64) async {
        do {
            let places = try await placeShowcaseAndReviewUseCase.readPlacesForShowcaseAndReview(userId: userId)
            placesSubject.send(places)
        } catch {
            placesSubject.send([])
        }
    }
}
