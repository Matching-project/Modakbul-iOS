//
//  ValidateUserNicknameOverlappedUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol ValidateUserNicknameOverlappedUseCase {
    func validate(_ nickname: String) async throws -> Bool
}
