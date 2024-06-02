//
//  AuthenticationProvider.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

enum AuthenticationProvider {
    case apple, kakao
    
    var identifier: String {
        switch self {
        case .apple: "APPLE"
        case .kakao: "KAKAO"
        }
    }
}
