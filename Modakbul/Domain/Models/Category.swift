//
//  Category.swift
//  Modakbul
//
//  Created by Swain Yun on 6/1/24.
//

import Foundation

enum Category {
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
