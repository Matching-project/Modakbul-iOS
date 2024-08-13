//
//  PlacesSearchResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/12/24.
//

import Foundation

struct PlacesSearchResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let id: Int64
        let imageURL: URL?
        let name: String
        let meetingCount: Int
        let location: LocationEntity
        let openingHour: [OpeningHourEntity]
        let powerSocketState: PowerSocketStateEntity
        let noiseLevel: NoiseLevelEntity
        let groupSeatingState: GroupSeatingStateEntity
        
        enum CodingKeys: String, CodingKey {
            case location, id
            case openingHour = "opening_hour"
            case meetingCount = "meeting_count"
            case imageURL = "image"
            case name = "name"
            case powerSocketState = "outlet"
            case noiseLevel = "congestion"
            case groupSeatingState = "groupSeat"
        }
    }
}

struct LocationEntity: Decodable {
    let latitude, longitude: Double
    let address: String
}

struct OpeningHourEntity: Decodable {
    let dayOfWeek: DayOfWeekEntity
    let open: String
    let close: String
    let openingState: OpeningState
    
    enum CodingKeys: String, CodingKey {
        case open, close
        case dayOfWeek = "day_of_week"
        case openingState = "status"
    }
}

enum DayOfWeekEntity: String, Decodable {
    case sun = "SUNDAY"
    case mon = "MONDAY"
    case tue = "TUESDAY"
    case wed = "WEDNESDAY"
    case thr = "THURSDAY"
    case fri = "FRIDAY"
    case sat = "SATURDAY"
}

enum OpeningState: String, Decodable {
    case opened = "OPEN"
    case closed = "CLOSE"
}

enum PowerSocketStateEntity: String, Codable {
    case plenty = "MANY"
    case moderate = "SEVERAL"
    case few = "FEW"
}

enum NoiseLevelEntity: String, Codable {
    case quiet = "QUIET"
    case moderate = "NORMAL"
    case noisy = "CROWDED"
}

enum GroupSeatingStateEntity: String, Codable {
    case yes = "AVAILABLE"
    case no = "UNAVAILABLE"
    case unknown = "UNKNOWN"
}
