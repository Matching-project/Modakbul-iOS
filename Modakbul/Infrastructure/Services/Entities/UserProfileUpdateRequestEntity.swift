//
//  UserProfileUpdateRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct UserProfileUpdateRequestEntity: Encodable {
    let nickname: String
    let isGenderVisible: Bool
    let job: Job
    let categories: Set<Category>
    
    enum CodingKeys: String, CodingKey {
        case nickname, job, categories
        case isGenderVisible = "is_gender_visible"
    }
}
