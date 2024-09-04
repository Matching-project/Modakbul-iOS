//
//  UserRegistrationEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 회원가입 요청
struct UserRegistrationRequestEntity: Encodable {
    let name, nickname, birth: String
    let gender: Gender
    let job: Job
    let categories: Set<Category>
}

/// 로그인, 회원가입 응답
struct UserRegistrationResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let userId: Int64
    }
    
    func toDTO() -> Int64 {
        result.userId
    }
}
