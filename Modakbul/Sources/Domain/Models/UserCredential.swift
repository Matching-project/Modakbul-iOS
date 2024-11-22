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
    let name: String?
    let email: String?
    /// Apple 로그인일 경우, 고유식별자를 제공합니다.
    let appleCI: String?
    let authorizationCode: Data?
    
    init(provider: AuthenticationProvider,
         fcm: String? = nil,
         name: String? = nil,
         email: String? = nil,
         appleCI: String? = nil,
         authorizationCode: Data? = nil
    ) {
        self.provider = provider
        self.fcm = fcm
        self.name = name
        self.email = email
        self.appleCI = appleCI
        self.authorizationCode = authorizationCode
    }
}
