//
//  Gender.swift
//  Modakbul
//
//  Created by Swain Yun on 5/23/24.
//

import Foundation

enum Gender: String, Codable, Selectable {
    case female = "FEMALE"
    case male = "MALE"
    case unknown = "PRIVATE"
    
    var identifier: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .female: "여성"
        case .male: "남성"
        case .unknown: "알 수 없음"
        }
    }
}
