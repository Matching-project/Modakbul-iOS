//
//  AppleLoginRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/15/24.
//

import Foundation

/// 애플 로그인 요청
struct AppleLoginRequestEntity: Encodable {
    let authorizationCode: Data
    let fcm: String
}
