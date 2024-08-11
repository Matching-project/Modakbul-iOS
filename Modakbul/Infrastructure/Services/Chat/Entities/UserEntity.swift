//
//  UserEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 7/24/24.
//

import Foundation

struct UserEntity: Codable {
    let email: String
    let name: String
    let nickname: String
    let provider: String
    let gender: String
    let job: String
    let categoriesOfInterest: [String]
    let isGenderVisible: Bool
    let birth: String
    let imageURL: String?
    
    init(_ dto: User) {
        self.email = dto.email
        self.name = dto.name
        self.nickname = dto.nickname
        self.provider = dto.provider.identifier
        self.gender = dto.gender.identifier
        self.job = dto.job.identifier
        self.categoriesOfInterest = [String](dto.categoriesOfInterest.map({$0.identifier}))
        self.isGenderVisible = dto.isGenderVisible
        self.birth = dto.birth.toString()
        self.imageURL = String(data: dto.image ?? Data(), encoding: .utf8) ?? ""
    }
}

extension UserEntity {
    func toDTO() -> User {
        return User(email: email,
                    provider: .init(rawValue: provider)!,
                    name: name,
                    nickname: nickname,
                    birth: .now,
                    gender: .init(string: gender),
                    job: .other,
                    categoriesOfInterest: [],
                    image: imageURL?.data(using: .utf8),
                    isGenderVisible: true)
    }
}
