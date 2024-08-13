//
//  OpponentUserProfileResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct OpponentUserProfileResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let nickname: String
        let imageURL: URL?
        let gender: Gender?
        let job: Job
        let categories: Set<String>
        
        enum CodingKeys: String, CodingKey {
            case nickname, gender, job, categories
            case imageURL = "image"
        }
    }
}
