//
//  NicknameOverlappedEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

struct NicknameOverlappedEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
    let result: OverlappedResult
}

struct OverlappedResult: Decodable {
    let isOverlapped: Bool
    
    enum CodingKeys: String, CodingKey {
        case isOverlapped = "is_overlapped"
    }
}
