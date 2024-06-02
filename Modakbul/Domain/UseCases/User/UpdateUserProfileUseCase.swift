//
//  UpdateUserProfileUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/1/24.
//

import Foundation

protocol UpdateUserProfileUseCase {
    func updateProfile(user: User) async throws
}
