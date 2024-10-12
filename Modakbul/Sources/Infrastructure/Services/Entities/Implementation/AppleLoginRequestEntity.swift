//
//  AppleLoginRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/15/24.
//

import Foundation

/// 애플 로그인 요청
struct AppleLoginRequestEntity: Encodable {
    let authorizationCode: String
    let fcm: String
    
    init(authorizationCode: Data, fcm: String) {
        self.authorizationCode = String(data: authorizationCode, encoding: .utf8) ?? ""
        self.fcm = fcm
    }
}
