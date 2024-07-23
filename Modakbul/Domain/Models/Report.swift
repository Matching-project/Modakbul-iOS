//
//  Report.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

enum ReportType {
    case disparagement
    case pornography
    case commercialAdvertisement
    case fishing
    case religiousPropaganda
    case other(description: String)
    
    var description: String {
        switch self {
        case .other(let description): return description
        default: return String(describing: self)
        }
    }
}

struct Report {
    let type: ReportType
    let from: User
    let to: User
    var description: String { type.description }
}
