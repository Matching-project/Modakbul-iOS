//
//  Job.swift
//  Modakbul
//
//  Created by Swain Yun on 7/21/24.
//

import Foundation

enum Job: CustomStringConvertible {
    case collegeStudent
    case jobSeeker
    case officeWorker
    case other
    
    var description: String {
        switch self {
        case .collegeStudent: return "대학생"
        case .jobSeeker: return "취준생"
        case .officeWorker: return "직장인"
        case .other: return "기타"
        }
    }
    
    var identifier: String {
        String(describing: self)
    }
}
