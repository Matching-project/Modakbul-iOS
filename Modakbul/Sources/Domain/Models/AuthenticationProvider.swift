//
//  AuthenticationProvider.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

enum AuthenticationProvider: String {
    case apple = "APPLE"
    case kakao = "KAKAO"
    
    var identifier: String {
        switch self {
        case .apple: "APPLE"
        case .kakao: "KAKAO"
        }
    }
    
    var infoDictionaryKey: String {
        switch self {
        case .apple: "APPLE_NATIVE_APP_KEY"
        case .kakao: "KAKAO_NATIVE_APP_KEY"
        }
    }
}
