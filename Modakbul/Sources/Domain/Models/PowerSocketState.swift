//
//  PowerSocketState.swift
//  Modakbul
//
//  Created by Swain Yun on 8/16/24.
//

import Foundation

enum PowerSocketState: String, Selectable, Codable {
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
    
    var shortDescription: String {
        switch self {
        case .plenty: "많음"
        case .moderate: "보통"
        case .few: "적음"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case plenty = "MANY"
        case moderate = "SEVERAL"
        case few = "FEW"
    }
}
