//
//  Report.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

// TODO: - Selectable로 하는건?
enum ReportType: CaseIterable, Hashable, CustomStringConvertible {
    case disparagement
    case pornography
    case commercialAdvertisement
    case fishing
    case religiousPropaganda
    case other
    
    var description: String {
        switch self {
        case .disparagement: "욕설/비하"
        case .pornography: "음란물/불건전한 만남 및 대화"
        case .commercialAdvertisement: "상업적 광고 및 판매"
        case .fishing: "유출/사칭/사기"
        case .religiousPropaganda: "과도한 종교 활동"
        case .other: "기타"
        }
    }
}

struct Report {
    var type: ReportType
    let from: User
    let to: User
    var description: String
}
