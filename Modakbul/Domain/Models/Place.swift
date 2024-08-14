//
//  Place.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

struct Place: Identifiable {
    struct OpeningHours {
        let open: String
        let close: String
    }
    
    enum PowerSocketState: CustomStringConvertible {
        case plenty
        case moderate
        case few
        
        var description: String {
            switch self {
            case .plenty: return "콘센트 많음"
            case .moderate: return "콘센트 보통"
            case .few: return "콘센트 적음"
            }
        }
    }
    
    enum NoiseLevel: CustomStringConvertible {
        case quiet
        case moderate
        case noisy
        
        var description: String {
            switch self {
            case .quiet: return "조용"
            case .moderate: return "보통"
            case .noisy: return "혼잡"
            }
        }
    }
    
    /// 단체석 여부는 6인석 이상을 기준으로 합니다.
    enum GroupSeatingState: CustomStringConvertible {
        case yes
        case no
        
        var description: String {
            switch self {
            case .yes: return "단체석 있음"
            case .no: return "단체석 없음"
            }
        }
    }
    
    let id: String
    let location: Location
    let openingHoursOfWeek: [DayOfWeek: OpeningHours]
    let powerSocketState: PowerSocketState
    let noiseLevel: NoiseLevel
    let groupSeatingState: GroupSeatingState
    let images: [String]?
}
