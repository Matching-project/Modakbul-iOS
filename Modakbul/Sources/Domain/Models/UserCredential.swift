//
//  UserCredential.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/19/24.
//

import Foundation

/// 로그인 및 회원가입 시 필요한 정보입니다.
/// - Warning: `fcm`이 존재한 상태에서 `email` 또는 `authorizationCode`가 필수적으로 존재해야 합니다.
struct UserCredential {
    let provider: AuthenticationProvider
    let fcm: String?
    let email: String?
    let authorizationCode: Data?
    
    init(provider: AuthenticationProvider,
         fcm: String? = nil,
         email: String? = nil,
         authorizationCode: Data? = nil
    ) {
        self.provider = provider
        self.fcm = fcm
        self.email = email
        self.authorizationCode = authorizationCode
    }
}
