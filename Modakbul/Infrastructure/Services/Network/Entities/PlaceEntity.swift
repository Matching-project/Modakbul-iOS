//
//  Empty.swift
//  Modakbul
//
//  Created by Swain Yun on 6/17/24.
//

import Foundation
import CoreLocation

struct PlaceEntity: Decodable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let images: [String]?
    
    func toDTO() -> Place {
        return Place(id: id,
                     location: Location(name: name,
                                        address: address,
                                        coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)),
                     openingHoursOfWeek: [:],
                     powerSocketState: .moderate,
                     noiseLevel: .moderate,
                     groupSeatingState: .yes,
                     images: nil)
    }
}
