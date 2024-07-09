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
    
    @Published var searchingText: String = String()
    @Published var searchedLocations: [Location] = []
    
    @MainActor func searchLocation() {
        guard searchingText.isEmpty == false else { return }
        
        Task {
            do {
                searchedLocations = try await fetchPlaceUseCase.fetchLocations(with: searchingText)
            } catch {
                searchedLocations = []
            }
        }
    }
}
