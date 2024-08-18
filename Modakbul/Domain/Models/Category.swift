//
//  Category.swift
//  Modakbul
//
//  Created by Swain Yun on 6/1/24.
//

import Foundation

enum Category: String, Codable, Selectable {
    case interview = "INTERVIEW"
    case coding = "CODING"
    case design = "DESIGN"
    case selfImprovement = "SELF_DEVELOPMENT"
    case reading = "READING"
    case language = "LANGUAGE"
    case officiary = "EXAM"
    case extracurricularActivities = "EXTERNAL_ACTIVITY"
    case other = "ETC"
    
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
}
