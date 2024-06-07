//
//  UserInfo.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

struct UserDTO: Decodable {
    let Id: String
    let email: String
    let name: String
    let birth: String
    let nickname: String
    let gender: String
    let isGenderVisible: Bool
    let image: String?
    let categoryName: String
    
    func toDTO(provider: AuthenticationProvider) -> User {
        return User(
            id: Id,
            email: email,
            provider: provider,
            name: name,
            gender: Gender(string: gender),
            isGenderVisible: isGenderVisible,
            birth: birth,
            nickname: nickname,
            imageURL: image,
            category: Category(string: categoryName)
        )
    }
}
