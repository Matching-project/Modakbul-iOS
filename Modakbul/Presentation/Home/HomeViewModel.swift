//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

final class HomeViewModel: ObservableObject {
    private let placesRepository: PlacesRepository
    
    var region: MKCoordinateRegion
    
    init(placesRepository: PlacesRepository) {
        self.placesRepository = placesRepository
    }
}
