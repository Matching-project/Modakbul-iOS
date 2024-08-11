//
//  AuthenticationResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/10/24.
//

import Foundation

struct DefaultResponseEntity: Decodable {
    let status: Bool
    let code: Int
    let message: String
}
