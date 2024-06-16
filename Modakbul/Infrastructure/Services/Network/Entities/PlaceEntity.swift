//
//  Empty.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation

struct PlaceEntity: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let images: [String]?
    
    func toDTO() -> Place {
        return Place(id: id,
                     name: name,
                     coordinate: Coordinate(latitude: latitude, longitude: longitude),
                     images: images)
    }
}
