//
//  KakaoLoginRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/15/24.
//

import Foundation

/// 카카오 로그인 요청
struct KakaoLoginRequestEntity: Encodable {
    let email: String
    let fcm: String
}
