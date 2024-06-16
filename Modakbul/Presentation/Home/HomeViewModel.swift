//
//  HomeViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 6/13/24.
//

import Foundation
import MapKit

final class HomeViewModel: ObservableObject {
    private let controlLocalMapUseCase: ControlLocalMapUseCase
    
    var region: MKCoordinateRegion
    
    init(controlLocalMapUseCase: ControlLocalMapUseCase) {
        self.controlLocalMapUseCase = controlLocalMapUseCase
    }
}
