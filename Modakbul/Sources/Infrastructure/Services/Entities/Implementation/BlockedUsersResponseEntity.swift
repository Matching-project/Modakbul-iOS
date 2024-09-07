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
        let blockId: Int64
        let id: Int64
        let imageURL: URL?
        let nickname: String
        let category: Set<Category>
        let job: Job
        
        enum CodingKeys: String, CodingKey {
            case nickname, job, blockId
            case id = "blockedId"
            case imageURL = "image"
            case category = "categoryName"
        }
    }
    
    func toDTO() -> [(blockId: Int64, blockedUser: User)] {
        result.map {
            let user: User = .init(
                id: $0.id,
                nickname: $0.nickname,
                job: $0.job,
                categoriesOfInterest: $0.category,
                imageURL: $0.imageURL
            )
            
            return ($0.blockId, user)
        }
    }
}
