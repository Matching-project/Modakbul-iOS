//
//  UserEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/3/24.
//

import Foundation

struct UserEntity: Codable {
    let email, provider, name, birth, gender, nickname, job: String
    let categories: [String]
    let image: Data?
}
