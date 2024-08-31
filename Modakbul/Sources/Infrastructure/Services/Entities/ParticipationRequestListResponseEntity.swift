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
            let id: Int64
            let nickname: String
            let imageURL: URL?
            let job: Job
            let categories: Set<Category>
            
            enum CodingKeys: String, CodingKey {
                case id, nickname, job, categories
                case imageURL = "image"
            }
        }
    }
    
    func toDTO() -> [ParticipationRequest] {
        result.map {
            let user = User(
                id: $0.user.id,
                nickname: $0.user.nickname,
                job: $0.user.job,
                categoriesOfInterest: $0.user.categories,
                imageURL: $0.user.imageURL
            )
            
            return .init(id: $0.id, participatedUser: user)
        }
    }
}
