//
//  UserIdentity.swift
//  Modakbul
//
//  Created by Swain Yun on 7/27/24.
//

import Foundation

/**
 사용자를 식별하고 인증하는데 사용되는 자격 증명입니다.
 
 로그인하거나 회원가입하는 과정에 사용하여 사용자의 신원을 증명할 수 있습니다.
 */
struct UserCredential {
    // TODO: - CI를 이용하는 방법 필요한가?
    // let id: String
    let familyName: String?
    let givenName: String?
    let email: String?              // Apple로 재로그인시 email 정보를 받아올 수 없으므로
    let authorizationCode: Data?    // ASAuthorizationAppleIDCredential.authorizationCode is Data?
    let provider: AuthenticationProvider
    
    init(
        // id: String,
        familyName: String? = nil,
        givenName: String? = nil,
        email: String? = nil,
        authorizationCode: Data? = nil,
        provider: AuthenticationProvider
    ) {
        // self.id = id
        self.familyName = familyName
        self.givenName = givenName
        self.email = email
        self.authorizationCode = authorizationCode
        self.provider = provider
    }
}
