//
//  Place.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

// TODO: 네이밍 아이디어 떠오르면 수정 예정
struct Place: Identifiable {
    struct OpeningHours {
        let open: DateComponents
        let close: DateComponents
    }
    
    enum PowerSocketState {
        case plenty
        case moderate
        case few
    }
    
    enum NoiseLevel {
        case quiet
        case moderate
        case noisy
    }
    
    /// 단체석 여부는 6인석 이상을 기준으로 합니다.
    enum GroupSeatingState {
        case yes
        case no
    }
    
    let id: String
    let location: Location
    let openingHoursOfWeek: [DayOfWeek: OpeningHours]
    let powerSocketState: PowerSocketState
    let noiseLevel: NoiseLevel
    let groupSeatingState: GroupSeatingState
    let communities: [Community]
    let images: [String]?
}
