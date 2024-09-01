//
//  TokenStorage.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//  Modified by SeongHyeon Lim on 7/9/24.
//

import Foundation
import Security

private enum TokenStorageError: Error {
    case unknown
    case failedFindToken
    case failedUnwrapToData
    case failedEncodeToData
    case decodingError(type: String)
}

protocol TokenStorage {
    typealias Query = [String: Any]
    typealias UserId = Int64
    
    func store(_ tokens: TokensProtocol, by userId: UserId) throws
    func fetch(by userId: UserId) throws -> TokensProtocol
    func delete(by userId: UserId) throws
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
    
    private func _create(_ data: Data, in query: Query) throws {
        var query = query
        query[kSecValueData as String] = data
        
        let status = SecItemAdd(query as CFDictionary, nil)
        try check(status, which: #function)
    }
    
    private func _read(_ query: Query) throws -> CFTypeRef? {
        var query = query
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var dataTypeRef: CFTypeRef? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        try check(status, which: #function)
        
        return dataTypeRef
    }
    
    private func _update(_ data: Data, in query: Query) throws {
        let queryToUpdate: Query = [kSecValueData as String: data]

        let status = SecItemUpdate(query as CFDictionary, queryToUpdate as CFDictionary)
        try check(status, which: #function)
    }
    
    private func _delete(_ query: Query) throws {
        let status = SecItemDelete(query as CFDictionary)
        try check(status, which: #function)
    }
}

// MARK: Utility Methods for CRUD Methods
extension DefaultTokenStorage {
    private func encode<T: Encodable>(from tokens: T) throws -> Data {
        try encoder.encode(tokens)
    }
    
    private func makeQuery(by userId: UserId) throws -> Query {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: userId
        ]
    }
    
    private func check(_ status: OSStatus, which function: String) throws {
        guard status != noErr else { return }
        
        let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "\(TokenStorageError.unknown)"
        print("Error in \(function): \(errorMessage)")
        
        if status == errSecItemNotFound {
            throw TokenStorageError.failedFindToken
        } else {
            throw TokenStorageError.unknown
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: CFTypeRef?) throws -> T {
        guard let data = data else {
            throw TokenStorageError.failedUnwrapToData
        }
        
        guard let data = data as? Data else {
            throw TokenStorageError.failedEncodeToData
        }

        guard let tokens = try? decoder.decode(T.self, from: data) else {
            throw TokenStorageError.decodingError(type: String(describing: type))
        }
        return tokens
    }
}

// MARK: TokenStorage Conformation
extension DefaultTokenStorage: TokenStorage {
    func store(_ tokens: TokensProtocol, by userId: UserId) throws {
        let data = try encode(from: tokens)
        let query = try makeQuery(by: userId)
        
        do {
            if let _ =  try _read(query) {
                try _update(data, in: query)
            }
        } catch TokenStorageError.failedFindToken {
            try _create(data, in: query)
        }
    }
    
    func fetch(by userId: UserId) throws -> TokensProtocol {
        let query = try makeQuery(by: userId)
        let data = try _read(query)
        
        return try decode(TokensEntity.self, from: data)
    }
    
    func delete(by userId: UserId) throws {
        let query = try makeQuery(by: userId)
        try _delete(query)
    }
}
