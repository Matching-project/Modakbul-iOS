//
//  UserInformationEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

struct UserProfileResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let nickname, job: String
        let imageURL: URL?
        let isGenderVisible: Bool
        let categories: Set<String>
        
        enum CodingKeys: String, CodingKey {
            case nickname, categories, job, isGenderVisible
            case imageURL = "image"
        }
    }
    
    func toDTO() -> User {
        User(result.nickname, result.job, result.isGenderVisible, result.categories, result.imageURL)
    }
}
