//
//  UserRegistrationRequestEntity.swift
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
