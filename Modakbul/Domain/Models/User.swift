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
    // MARK: 소셜 로그인을 통해 얻어지는 정보
    let email: String
    let provider: AuthenticationProvider
    
    // MARK: 회원가입시 얻어지는 정보
    let name: String
    let nickname: String
    let birth: Date
    let gender: Gender
    let job: Job
    let categoriesOfInterest: Set<Category>
    let image: Data?
    
    // MARK: 사용자 설정화면에서 설정하는 정보
    let isGenderVisible: Bool
}
