//
//  UserInformationEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

struct UserInformationEntity: Decodable {
    let isGenderVisible: Bool
    let nickname, job: String
    let categoryName: Set<String>
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case isGenderVisible, nickname, image, job
        case categoryName = "category_name"
    }
}
