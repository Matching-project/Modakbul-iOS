//
//  AppleLoginRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/15/24.
//

import Foundation

/// 애플 로그인 요청
struct AppleLoginRequestEntity: Encodable {
    let appleCI: String
    let fcm: String
    
    init(
        appleCI: String,
        fcm: String
    ) {
        self.appleCI = appleCI
        self.fcm = fcm
    }
}
