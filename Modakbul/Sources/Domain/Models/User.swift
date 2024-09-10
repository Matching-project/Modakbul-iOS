//
//  User.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

/**
 사용자 정보를 나타냅니다.
 */
struct User {
    let id: Int64
    let name: String
    let nickname: String
    let gender: Gender
    let job: Job
    let categoriesOfInterest: Set<Category>
    let isGenderVisible: Bool
    let birth: Date
    let imageURL: URL?
    
    init(
        id: Int64 = Int64(Constants.loggedOutUserId),
        name: String = "이름 없음",
        nickname: String = "닉네임 없음",
        gender: Gender = .unknown,
        job: Job = .other,
        categoriesOfInterest: Set<Category> = [],
        isGenderVisible: Bool = true,
        birth: Date = .now,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.job = job
        self.categoriesOfInterest = categoriesOfInterest
        self.isGenderVisible = isGenderVisible
        self.birth = birth
        self.imageURL = imageURL
    }
}
