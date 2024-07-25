//
//  AuthenticationProviderEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 7/24/24.
//

import Foundation

struct AuthenticationProviderEntity: Codable {
    let provider: String
}

extension AuthenticationProviderEntity {
    func toDTO() -> AuthenticationProvider {
        return AuthenticationProvider(rawValue: provider)!
    }
}
