//
//  PowerSocketState.swift
//  Modakbul
//
//  Created by Swain Yun on 8/16/24.
//

import Foundation

enum PowerSocketState: String, CustomStringConvertible, Codable {
    case plenty = "MANY"
    case moderate = "SEVERAL"
    case few = "FEW"
    
    var description: String {
        switch self {
        case .plenty: "콘센트 많음"
        case .moderate: "콘센트 보통"
        case .few: "콘센트 적음"
        }
    }
}
