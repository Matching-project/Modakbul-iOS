//
//  UserEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 7/24/24.
//

import Foundation

struct UserEntity: Codable {
    let name: String
    let nickname: String
    let email: String
    let provider: String
    let gender: String
    let job: String
    let categoriesOfInterest: [String]
    let isGenderVisible: Bool
    let birth: String
    let imageURL: String?
    
    init(_ dto: User) {
        self.name = dto.name
        self.nickname = dto.nickname
        self.email = dto.email
        self.provider = dto.provider.identifier
        self.gender = dto.gender.identifier
        self.job = dto.job.identifier
        self.categoriesOfInterest = [String](dto.categoriesOfInterest.map({$0.identifier}))
        self.isGenderVisible = dto.isGenderVisible
        self.birth = dto.birth.toString()
        self.imageURL = dto.imageURL
    }
}

extension UserEntity {
    func toDTO() -> User {
        return User(name: name,
                    nickname: nickname,
                    email: email,
                    provider: .init(rawValue: provider)!,
                    gender: .init(string: gender),
                    job: .other,
                    categoriesOfInterest: [],
                    isGenderVisible: true,
                    birth: .now,
                    imageURL: imageURL)
    }
}
