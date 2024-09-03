//
//  UserAuthenticationResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/18/24.
//

import Foundation

struct UserAuthenticationResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let userId: Int64
    }
}
