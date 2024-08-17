//
//  DayOfWeek.swift
//  Modakbul
//
//  Created by Swain Yun on 7/21/24.
//

import Foundation

enum DayOfWeek: String, Selectable, Codable {
    case sun = "SUNDAY"
    case mon = "MONDAY"
    case tue = "TUESDAY"
    case wed = "WEDNESDAY"
    case thr = "THURSDAY"
    case fri = "FRIDAY"
    case sat = "SATURDAY"
    
    var description: String {
        switch self {
        case .sun: "일요일"
        case .mon: "월요일"
        case .tue: "화요일"
        case .wed: "수요일"
        case .thr: "목요일"
        case .fri: "금요일"
        case .sat: "토요일"
        }
    }
}
