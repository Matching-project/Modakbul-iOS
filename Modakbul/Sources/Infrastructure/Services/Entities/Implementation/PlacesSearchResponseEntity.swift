//
//  PlacesSearchResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/12/24.
//

import Foundation
import CoreLocation

/// 장소 검색 응답
struct PlacesSearchResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let id: Int64
        let imageURL: [URL]
        let name: String
        let meetingCount: Int
        let location: LocationEntity
        let openingHour: [OpeningHour]
        let powerSocketState: PowerSocketState
        let groupSeatingState: GroupSeatingState
        
        enum CodingKeys: String, CodingKey {
            case location, id, openingHour, meetingCount, name
            case imageURL = "image"
            case powerSocketState = "outlet"
            case groupSeatingState = "groupSeat"
        }
    }
    
    func toDTO() -> [Place] {
        result.map {
            .init(
                id: $0.id,
                location: $0.location.toDTO(),
                openingHours: $0.openingHour,
                powerSocketState: $0.powerSocketState,
                groupSeatingState: $0.groupSeatingState,
                communityRecruitingContents: [],
                imageURLs: $0.imageURL
            )
        }
    }
}

struct LocationEntity: Codable {
    let latitude, longitude: Double
    let address: String
    
    func toDTO() -> Location {
        .init(coordinate: .init(latitude: latitude, longitude: longitude))
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case address = "streetAddress"
    }
}
