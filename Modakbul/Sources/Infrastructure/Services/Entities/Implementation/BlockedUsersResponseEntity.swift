//
//  BlockedUsersResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/1/24.
//

import Foundation

/// 차단된 사용자 목록 조회 응답
struct BlockedUsersResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let imageURL: URL?
        let nickname: String
        let category: Set<Category>
        let job: Job
        
        enum CodingKeys: String, CodingKey {
            case nickname, job
            case imageURL = "image"
            case category = "categoryName"
        }
    }
    
    func toDTO() -> [User] {
        result.map {
            .init(
                nickname: $0.nickname,
                job: $0.job,
                categoriesOfInterest: $0.category,
                imageURL: $0.imageURL
            )
        }
    }
}
