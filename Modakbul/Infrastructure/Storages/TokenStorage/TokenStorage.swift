//
//  TokenStorage.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//  Modified by SeongHyeon Lim on 7/9/24.
//

import Foundation
import Security

protocol TokenTypeAlias {
    typealias Query = [String: Any]
    typealias UserID = String
    typealias Tokens = (accessToken: String, refreshToken: String)
    typealias TokensData = (accessToken: Data, refreshToken: Data)
}

protocol TokenStorage: TokenTypeAlias {
    func store(tokens: Tokens, by userId: UserID) async throws
    func fetch(TokensBy userId: UserID) async throws -> Tokens
    func delete(TokensBy userId: UserID) async
}

enum TokenCommand {
    case store
    case fetch
    case update
}

private enum TokenStorageError: Error {
    case failedConvertToDataType
    case failedAddTokens
    case failedConvertToQuery
    case failedConvertToTokensData
    case failedConvertToTokens
    case failedFetchTokensData
    case failedFetchTokens
}

final class DefaultTokenStorage {
    private let service: String = Bundle.main.bundleIdentifier.unsafelyUnwrapped
    
    private func makeDataFrom(_ tokens: Tokens) throws -> TokensData {
        guard let accessTokenData = tokens.accessToken.data(using: .utf8),
              let refreshTokenData = tokens.refreshToken.data(using: .utf8) else {
            throw TokenStorageError.failedConvertToDataType
        }
        
        return (accessTokenData, refreshTokenData)
    }
    
    private func makeQuery(by userId: UserID) -> Query {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: userId
        ]
    }
    
    private func fetch(_ query: Query) async -> (OSStatus, CFTypeRef?) {
        return await Task<(OSStatus, CFTypeRef?), Never> {
            var dataTypeRef: CFTypeRef? = nil
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            return (status, dataTypeRef)
        }.value
    }
    
    private func add(_ query: Query, tokenCommand: TokenCommand) async throws {
        Task {
            if tokenCommand == .update {
                SecItemDelete(query as CFDictionary)
            }
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != noErr {
                throw TokenStorageError.failedAddTokens
            }
        }
    }
    
    private func convertToTokens(_ status: OSStatus, _ item: CFTypeRef?) throws -> Tokens {
        if status == noErr {
            guard let existingItem = item as? Query else {
                throw TokenStorageError.failedConvertToQuery
            }
            
            guard let tokensData = existingItem[kSecValueData as String] as? TokensData else {
                throw TokenStorageError.failedConvertToTokensData
            }
            
            guard let accessToken = String(data: tokensData.accessToken, encoding: String.Encoding.utf8),
                  let refreshToken = String(data: tokensData.refreshToken, encoding: String.Encoding.utf8)
            else {
                throw TokenStorageError.failedConvertToTokens
            }
            
            return (accessToken, refreshToken)
        } else {
            throw TokenStorageError.failedFetchTokens
        }
    }
    
    private func delete(_ query: Query) async {
        Task {
            SecItemDelete(query as CFDictionary)
        }
    }
}

// MARK: TokenStorage Confirmation
extension DefaultTokenStorage: TokenStorage {
    func store(tokens: Tokens, by userId: UserID) async throws {
        let tokensData = try makeDataFrom(tokens)
        var query = makeQuery(by: userId)
        let (status, _) = await fetch(query)
        
        let tokenCommand: TokenCommand = status == errSecItemNotFound ? .store : .update
        try query.append(.store, tokensData)
        
        try await add(query, tokenCommand: tokenCommand)
    }
    
    func fetch(TokensBy userId: UserID) async throws -> Tokens {
        var query = makeQuery(by: userId)
        try query.append(.fetch, nil)
        let (status, item) = await fetch(query)
        
        return try convertToTokens(status, item)
    }
    
    func delete(TokensBy userId: UserID) async {
        let query = makeQuery(by: userId)
        await delete(query)
    }
}

extension Dictionary: TokenTypeAlias where Self == Query {
    mutating func append(_ tokenCommand: TokenCommand, _ tokensData: TokensData?) throws {
        switch tokenCommand {
        case .store:
            guard let tokensData = tokensData else {
                throw TokenStorageError.failedFetchTokensData
            }
            
            updateValue(tokensData, forKey: kSecValueData as String)
        case .fetch:
            updateValue(true, forKey: kSecReturnData as String)
            updateValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        case .update: return
        }
    }
}
