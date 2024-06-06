//
//  TokenRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol TokenRepository {
    func fetchToken(by userId: String) async throws -> String
    func storeToken(by userId: String, with token: String) async throws
}
