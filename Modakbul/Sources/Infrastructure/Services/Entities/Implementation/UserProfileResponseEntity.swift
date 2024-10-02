//
//  UserInformationEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

/// 사용자 프로필 조회 응답
struct UserProfileResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let id: Int64
        let nickname: String
        let job: Job
        let imageURL: URL?
        let isGenderVisible: Bool
        let categories: Set<Category>
        
        enum CodingKeys: String, CodingKey {
            case id, nickname, categories, job, isGenderVisible
            case imageURL = "image"
        }
    }
    
    func toDTO() -> User {
        .init(
            id: result.id,
            nickname: result.nickname,
            job: result.job,
            categoriesOfInterest: result.categories,
            isGenderVisible: result.isGenderVisible,
            imageURL: result.imageURL
        )
    }
}
