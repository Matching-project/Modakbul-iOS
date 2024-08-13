//
//  DayOfWeek.swift
//  Modakbul
//
//  Created by Swain Yun on 7/21/24.
//

import Foundation

// TODO: - Selectable로 바꿔도 되지 않을까?
enum DayOfWeek: CaseIterable, Identifiable, CustomStringConvertible {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .mon:
            "월"
        case .tue:
            "화"
        case .wed:
            "수"
        case .thu:
            "목"
        case .fri:
            "금"
        case .sat:
            "토"
        case .sun:
            "일"
        }
    }
}
