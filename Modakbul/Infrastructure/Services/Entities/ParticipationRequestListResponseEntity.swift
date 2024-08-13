//
//  ParticipationRequestListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct ParticipationRequestListResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let id: Int64
        let user: User
    }
    
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
