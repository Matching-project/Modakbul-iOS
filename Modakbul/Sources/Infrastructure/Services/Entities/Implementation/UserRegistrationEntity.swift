//
//  UserRegistrationEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 카카오로 회원가입 요청
struct KakaoUserRegistrationRequestEntity: Encodable {
    let name, nickname, birth: String
    let gender: Gender
    let job: Job
    let categories: Set<Category>
    let email: String
    let fcm: String
    
    init(_ user: User, email: String, fcm: String) async {
        self.name = user.name
        self.nickname = user.nickname
        self.birth = await user.birth.toString(by: .yyyyMMddRaw)
        self.gender = user.gender
        self.job = user.job
        self.categories = user.categoriesOfInterest
        self.email = email
        self.fcm = fcm
    }
}

/// 애플로 회원가입 요청
struct AppleUserRegistrationRequestEntity: Encodable {
    let name, nickname, birth: String
    let gender: Gender
    let job: Job
    let categories: Set<Category>
    let authorizationCode: String
    let fcm: String
    
    init(_ user: User, authorizationCode: Data, fcm: String) async {
        self.name = user.name
        self.nickname = user.nickname
        self.birth = await user.birth.toString(by: .yyyyMMddRaw)
        self.gender = user.gender
        self.job = user.job
        self.categories = user.categoriesOfInterest
        self.authorizationCode = String(data: authorizationCode, encoding: .utf8) ?? ""
        self.fcm = fcm
    }
}

/// 로그인, 회원가입 응답
struct UserRegistrationResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result?
    
    struct Result: Decodable {
        let userId: Int64
    }
    
    func toDTO() -> Int64 {
        /// 요청 실패할 경우, 기본값인 `-1` 반환
        result?.userId ?? Int64(Constants.loggedOutUserId)
    }
}
