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
    let familyName: String?
    let givenName: String?
    let email: String
    let provider: AuthenticationProvider
    
    init(
        familyName: String? = nil,
        givenName: String? = nil,
        email: String,
        provider: AuthenticationProvider
    ) {
        self.familyName = familyName
        self.givenName = givenName
        self.email = email
        self.provider = provider
    }
}
