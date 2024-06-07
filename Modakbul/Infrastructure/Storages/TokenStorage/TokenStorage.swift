//
//  TokenStorage.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol TokenStorage {
    func fetchToken(id userId: String) async throws -> (accessToken: String, refreshToken: String)
    func storeToken(id userId: String, tokens: (accessToken: String, refreshToken: String)) async
}

fileprivate enum TokenStorageError: Error {
    case canNotFindToken
}

final class DefaultTokenStorage {
    typealias UserID = String
    typealias Tokens = (accessToken: String, refreshToken: String)
    
    private var container: [UserID: Tokens] = [:]
}

// MARK: TokenStorage Confirmation
extension DefaultTokenStorage: TokenStorage {
    func fetchToken(id userId: UserID) async throws -> Tokens {
        guard let tokens = container[userId] else {
            throw TokenStorageError.canNotFindToken
        }
        return tokens
    }
    
    func storeToken(id userId: UserID, tokens: Tokens) async {
        container[userId] = tokens
    }
}
