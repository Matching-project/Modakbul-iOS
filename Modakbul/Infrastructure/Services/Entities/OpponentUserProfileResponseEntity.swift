//
//  OpponentUserProfileResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 상대 사용자 프로필 조회 응답
struct OpponentUserProfileResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let id: Int64
        let nickname: String
        let imageURL: URL?
        let gender: Gender
        let job: Job
        let categories: Set<Category>
        
        enum CodingKeys: String, CodingKey {
            case id, nickname, gender, job, categories
            case imageURL = "image"
        }
    }
    
    func toDTO() -> User {
        .init(
            id: result.id,
            nickname: result.nickname,
            gender: result.gender,
            job: result.job,
            categoriesOfInterest: result.categories,
            imageURL: result.imageURL
        )
    }
}
