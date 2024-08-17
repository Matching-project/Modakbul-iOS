//
//  Job.swift
//  Modakbul
//
//  Created by Swain Yun on 7/21/24.
//

import Foundation

enum Job: String, Codable {
    case collegeStudent = "COLLEGE"
    case jobSeeker = "JOB_SEEKER"
    case officeWorker = "OFFICE"
    case other = "ETC"
    
    var identifier: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .collegeStudent: "대학생"
        case .jobSeeker: "취준생"
        case .officeWorker: "직장인"
        case .other: "기타"
        }
    }
    
    var identifier: String {
        String(describing: self)
    }
}
