//
//  DefaultResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

/// 기본 응답 형식
struct DefaultResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
}
