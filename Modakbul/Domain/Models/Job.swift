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
}
