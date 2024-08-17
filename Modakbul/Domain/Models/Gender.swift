//
//  Gender.swift
//  Modakbul
//
//  Created by Swain Yun on 5/23/24.
//

import Foundation

enum Gender: String, Codable {
    case female = "FEMALE"
    case male = "MALE"
    case unknown = "PRIVATE"
    
    var identifier: String {
        self.rawValue
    }
}
