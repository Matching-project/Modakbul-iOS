//
//  OpeningHour.swift
//  Modakbul
//
//  Created by Swain Yun on 8/16/24.
//

import Foundation

struct OpeningHour: Hashable, Decodable {
    let dayOfWeek: DayOfWeek
    let open: String
    let close: String
    let openingState: OpeningState
    
    enum CodingKeys: String, CodingKey {
        case open, close, dayOfWeek
        case openingState = "status"
    }
}

enum OpeningState: String, Codable {
    case opened = "OPEN"
    case closed = "CLOSE"
    
    var isOpened: Bool {
        switch self {
        case .opened: true
        case .closed: false
        }
    }
}
