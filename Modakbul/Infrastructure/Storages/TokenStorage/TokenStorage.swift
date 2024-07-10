//
//  TokenStorage.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//  Modified by SeongHyeon Lim on 7/9/24.
//

import Foundation
import Security

// TODO: 이거 꼭 필요한가? -> 네스티드로 갈건지 지금 현상유지할지?
private enum TokenCommand {
    case store
    case fetch
    case delete
}

private enum TokenStorageError: Error {
    case unknown
    case failedFindToken
    case failedUnwrapToData
    case failedConvertToData
}

// TODO: Tokens 도메인 모델은 아닌 것 같음. 오타 수정
protocol TokenStorage {
    typealias Query = [String: Any]
    typealias UserID = String
    
    func store(tokens: Tokens, by userId: UserID) throws
    func fetch(TokensBy userId: UserID) throws -> Tokens
    func delete(TokensBy userId: UserID) throws
}

// MARK: CRUD Methods
final class DefaultTokenStorage {
    private let service: String = Bundle.main.bundleIdentifier.unsafelyUnwrapped
    private let encoder: JSONEncodable
    private let decoder: JSONDecodable
    
    init(
        encoder: JSONEncodable = JSONEncoder(),
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    // TODO: 외부메서드랑 내부메서드 CRUD 맞춰서 조정하다보면 해결될 수도 있음.
    private func _store(_ query: Query) throws {
        // MARK: - SecItemUpdate() 사용을 고려했으나, 새로저장과 업데이트를 한번에 처리하기 위해 해당 로직으로 작성함
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        try check(status, which: #function)
    }
    
    private func _fetch(_ query: Query) throws -> CFTypeRef? {
        var dataTypeRef: CFTypeRef? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        try check(status, which: #function)
        
        return dataTypeRef
    }
    
    private func _delete(_ query: Query) throws {
        let status = SecItemDelete(query as CFDictionary)
        try check(status, which: #function)
    }
}

// MARK: Utility Method for CRUD Methods
extension DefaultTokenStorage {
    private func makeData(from tokens: Tokens) throws -> Data {
        try encoder.encode(tokens)
    }
    
    private func makeQuery(as tokenCommand: TokenCommand,
                           from data: Data?,
                           by userId: UserID) throws -> Query {
        
        var query: Query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: userId
        ]
        
        switch tokenCommand {
        case .store:
            guard let data = data else {
                throw TokenStorageError.failedUnwrapToData
            }
            
            query.updateValue(data, forKey: kSecValueData as String)
        case .fetch:
            query.updateValue(true, forKey: kSecReturnData as String)
            query.updateValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        default: break
        }
        return query
    }
    
    // TODO: 에러 상황 자주 발생할 거 같은거 몇개만 추가도 고려해볼만 함, 일단 놔둬도 될 것 같음.
    private func check(_ status: OSStatus, which function: String) throws {
        if status == errSecItemNotFound {
            print("Error in", function, ":", SecCopyErrorMessageString(status, nil) ?? TokenStorageError.unknown)
            throw TokenStorageError.failedFindToken
        } else if status != noErr {
            print("Error in", function, ":", SecCopyErrorMessageString(status, nil) ?? TokenStorageError.unknown)
            throw TokenStorageError.unknown
        }
    }
    
    private func convertToTokens(from data: CFTypeRef?) throws -> Tokens {
        guard let data = data as? Data else {
            throw TokenStorageError.failedConvertToData
        }
        
        let tokens = try decoder.decode(Tokens.self, from: data)
        return tokens
    }
}

// MARK: TokenStorage Confirmation
extension DefaultTokenStorage: TokenStorage {
    func store(tokens: Tokens, by userId: UserID) throws {
        let data = try makeData(from: tokens)
        let query = try makeQuery(as: .store, from: data, by: userId)
        
        try _store(query)
    }
    
    func fetch(TokensBy userId: UserID) throws -> Tokens {
        let query = try makeQuery(as: .fetch, from: nil, by: userId)
        let data = try _fetch(query)
        
        return try convertToTokens(from: data)
    }
    
    func delete(TokensBy userId: UserID) throws {
        let query = try makeQuery(as: .delete, from: nil, by: userId)
        try _delete(query)
    }
}
