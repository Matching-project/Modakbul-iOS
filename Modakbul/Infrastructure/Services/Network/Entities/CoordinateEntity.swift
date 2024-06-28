//
//  CoordinateEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 6/28/24.
//

import Foundation

struct CoordinateEntity: Codable {
    let latitude: Double
    let longitude: Double
    
    func toDTO() -> Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }
}
