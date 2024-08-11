//
//  Category.swift
//  Modakbul
//
//  Created by Swain Yun on 6/1/24.
//

import Foundation

enum Category: Selectable {
    case interview
    case coding
    case design
    case selfImprovement
    case reading
    case language
    case officiary
    case extracurricularActivities
    case other
    
    var identifier: String {
        String(describing: self)
    }
    
    var description: String {
        switch self {
        case .interview: "면접"
        case .coding: "코딩"
        case .design: "디자인"
        case .selfImprovement: "자기개발"
        case .reading: "독서"
        case .language: "어학"
        case .officiary: "고시, 공무원"
        case .extracurricularActivities: "대외활동"
        case .other: "기타"
        }
    }
    
    init(string: String) {
        switch string {
        case "INTERVIEW": self = .interview
        case "CODING": self = .coding
        case "DESIGN": self = .design
        case "SELF_IMPROVEMENT": self = .selfImprovement
        case "READING": self = .reading
        case "LANGUAGE": self = .language
        case "OFFICIARY": self = .officiary
        case "EXTRACURRICULAR_ACTIVITIES": self = .extracurricularActivities
        default: self = .other
        }
    }
}
