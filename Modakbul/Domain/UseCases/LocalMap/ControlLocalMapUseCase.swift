//
//  ControlLocalMapUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/15/24.
//

import Foundation
import MapKit

protocol ControlLocalMapUseCase {
    func requestLocationUpdate()
    @MainActor func findPlaces(located: CLLocationCoordinate2D) async -> [MKMapItem]
    @MainActor func identifyPlaces(with places: [MKMapItem]) async -> [Place]
}
