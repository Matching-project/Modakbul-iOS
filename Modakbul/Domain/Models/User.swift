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
    let name: String
    let nickname: String
    let email: String
    let provider: AuthenticationProvider
    let gender: Gender
    let job: Job
    let categoriesOfInterest: Set<Category>
    let isGenderVisible: Bool
    let birth: Date
    let imageURL: String?
}
