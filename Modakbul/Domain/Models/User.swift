//
//  User.swift
//  Modakbul
//
//  Created by Swain Yun on 5/30/24.
//

import Foundation

struct User: Identifiable {
    let id: String
    let email: String
    let provider: AuthenticationProvider
    let name: String
    let gender: Gender
    let isGenderVisible: Bool
    let birth: String
    let nickname: String
    let imageURL: String?
    let category: Category
}
