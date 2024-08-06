//
//  Gender.swift
//  Modakbul
//
//  Created by Swain Yun on 5/23/24.
//

import Foundation

enum Gender: Selectable {
    case female, male
    
    var identifier: String {
        switch self {
        case .female: "FEMALE"
        case .male: "MALE"
        }
    }
    
    var description: String {
        switch self {
        case .female: "여성"
        case .male: "남성"
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
