//
//  FetchUserProfileUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/1/24.
//

import Foundation

protocol FetchUserProfileUseCase {
    func fetchUserInfo() async throws -> User
}
