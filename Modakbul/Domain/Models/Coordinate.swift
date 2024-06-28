//
//  Coordinate.swift
//  Modakbul
//
//  Created by Swain Yun on 6/15/24.
//

import Foundation
import CoreLocation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    func toCLCoordinate() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func toEntity() -> CoordinateEntity {
        CoordinateEntity(latitude: latitude, longitude: longitude)
    }
}
