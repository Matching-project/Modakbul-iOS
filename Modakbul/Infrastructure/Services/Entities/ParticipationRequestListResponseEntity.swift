//
//  ParticipationRequestListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 참여 요청 목록 조회 응답
struct ParticipationRequestListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let id: Int64
        let user: User
        
        struct User: Decodable {
            let nickname: String
            let imageURL: URL?
            let job: Job
            let categories: Set<Category>
            
            enum CodingKeys: String, CodingKey {
                case nickname, job, categories
                case imageURL = "image"
            }
        }
    }
    
    func toDTO() -> [User] {
        // TODO: 이거 id가 참여요청목록의 id인데;
        result.map {
            .init(
                id: $0.id,
                nickname: $0.user.nickname,
                job: $0.user.job,
                categoriesOfInterest: $0.user.categories,
                imageURL: $0.user.imageURL
            )
        }
    }
}