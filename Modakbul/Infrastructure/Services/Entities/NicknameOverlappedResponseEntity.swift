//
//  NicknameOverlappedResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

/// 닉네임 중복 확인 응답
struct NicknameOverlappedResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Bool
}
