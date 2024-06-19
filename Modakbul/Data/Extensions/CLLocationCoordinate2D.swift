//
//  CLLocationCoordinate2D.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func toDTO() -> Coordinate {
        Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}
