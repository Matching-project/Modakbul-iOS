//
//  DefaultResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/3/24.
//

import Foundation

/// 기본 응답 형식
struct DefaultResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
}
