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
            case nickname, categories
            case imageURL = "image"
            case isGenderVisible = "is_gender_visible"
            case job = "job"
        }
    }
}
