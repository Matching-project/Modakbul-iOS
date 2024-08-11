//
//  Job.swift
//  Modakbul
//
//  Created by Swain Yun on 7/21/24.
//

import Foundation

enum Job: Selectable {
    case collegeStudent
    case jobSeeker
    case officeWorker
    case other
    
    var identifier: String {
        switch self {
        case .collegeStudent: return "CollegeStudent"
        case .jobSeeker: return "JobSeeker"
        case .officeWorker: return "OfficeWorker"
        case .other: return "Other"
        }
    }
    
    var description: String {
        switch self {
        case .collegeStudent: "대학생"
        case .jobSeeker: "취준생"
        case .officeWorker: "직장인"
        case .other: "기타"
        }
    }
}
