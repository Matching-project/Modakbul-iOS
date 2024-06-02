//
//  RegisterUserProfileUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol RegisterUserProfileUseCase {
    func register(_ user: User, encoded imageData: String) async throws
}
