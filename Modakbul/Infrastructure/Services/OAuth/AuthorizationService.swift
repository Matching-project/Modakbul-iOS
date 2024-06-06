//
//  AuthorizationService.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol AuthorizationService {
    func authorize(with provider: AuthenticationProvider) async throws -> String
}
