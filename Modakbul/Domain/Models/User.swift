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
    let name: String?
    let nickname: String?
    let gender: Gender?
    let job: Job?
    let categoriesOfInterest: Set<Category>?
    let isGenderVisible: Bool?
    let birth: Date?
    let imageURL: URL?
    
    init(
        _ name: String? = nil,
        _ nickname: String? = nil,
        _ gender: Gender? = nil,
        _ job: Job? = nil,
        _ categoriesOfInterest: Set<Category>? = nil,
        _ isGenderVisible: Bool? = nil,
        _ birth: Date? = nil,
        _ imageURL: URL? = nil
    ) {
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
