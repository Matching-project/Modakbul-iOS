//
//  PlaceShowcaseViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/8/24.
//

import Foundation

final class PlaceShowcaseViewModel: ObservableObject {
    @Published var places: [Place] = PreviewHelper.shared.places
}

// MARK: Interfaces
extension PlaceShowcaseViewModel {
    func fetchPlaces() async {
        
    }
}
