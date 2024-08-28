//
//  GroupSeatingState.swift
//  Modakbul
//
//  Created by Swain Yun on 8/16/24.
//

import Foundation

/// 단체석 여부는 6인석 이상을 기준으로 합니다.
enum GroupSeatingState: String, Selectable, Codable {
    case yes = "AVAILABLE"
    case no = "UNAVAILABLE"
    case unknown = "UNKNOWN"
    
    var description: String {
        switch self {
        case .yes: "단체석 있음"
        case .no, .unknown: "단체석 없음"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .yes: "있음"
        case .no, .unknown: "없음"
        }
    }
}
