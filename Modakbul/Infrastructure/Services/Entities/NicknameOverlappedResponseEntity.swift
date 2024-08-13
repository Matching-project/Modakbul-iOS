//
//  NicknameOverlappedResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

struct NicknameOverlappedResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: Bool
}
