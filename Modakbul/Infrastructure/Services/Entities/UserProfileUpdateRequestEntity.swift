//
//  UserProfileUpdateRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 사용자 프로필 갱신 요청
struct UserProfileUpdateRequestEntity: Encodable {
    let nickname: String
    let isGenderVisible: Bool
    let job: Job
    let categories: Set<Category>
}
