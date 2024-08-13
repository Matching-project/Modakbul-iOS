//
//  UserRegistrationRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct UserRegistrationRequestEntity: Encodable {
    let name, nickname, birth: String
    let gender: Gender
    let job: Job
    let categories: Set<Category>
}
