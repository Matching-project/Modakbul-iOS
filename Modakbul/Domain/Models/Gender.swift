//
//  Gender.swift
//  Modakbul
//
//  Created by Swain Yun on 5/23/24.
//

import Foundation

enum Gender {
    case female, male
    
    var identifier: String {
        switch self {
        case .female: "FEMALE"
        case .male: "MALE"
        }
    }
    
    init(string: String) {
        if string == "FEMALE" {
            self = .female
        } else {
            self = .male
        }
    }
}
