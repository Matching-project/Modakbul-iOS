//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import Moya

protocol NetworkService {
    @discardableResult func request<E: TargetType, T: ResponseEntity>(endpoint: E, for type: T.Type) async throws -> HTTPResponse<T>
}

enum NetworkServiceError: Error {
    case badResponse(statusCode: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError(type: String)
    case generic(type: String)
    case requestFailed
}

enum APIError: Int, Error {
    // MARK: Invalid Data
    case invalidInputValue = 2001
    case invalidDataValue = 2002
    
    // MARK: User
    case userNotExist = 2004
    case accessDenied = 2011
    
    // MARK: Token
    case accessTokenExpired = 2401
    case refreshTokenExpired = 2403
    
    // MARK: Server & Database
    case responseError = 3000
    case databaseError = 4001
    case serverError = 4002
    
    // MARK: Unknown
    case unknownError = 9999
}

struct HTTPResponse<T: Decodable> {
    let headers: [String: String]?
    let body: T
    
    var accessToken: String? {
        headers?["Authorization"]?.replacingOccurrences(of: "Bearer ", with: "")
    }
    
    var refreshToken: String? {
        headers?["authorization_refresh"]?.replacingOccurrences(of: "Bearer ", with: "")
    }
}

final class DefaultNetworkService {
    private let decoder: JSONDecodable
    
    init(decoder: JSONDecodable = JSONDecoder()) {
        self.decoder = decoder
    }
    
    private func handleResponse(_ response: HTTPURLResponse?) throws -> [String: String] {
        guard let response = response else {
            throw NetworkServiceError.requestFailed
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkServiceError.badResponse(statusCode: response.statusCode)
        }
        
        return response.allHeaderFields as? [String: String] ?? [:]
    }
    
    private func performAPIResponse<T: ResponseEntity>(_ response: T) throws -> T {
        // TODO: 임시 코드 - APIERROR에 정의되지 않은 코드도 로그 찍기 위함
        #if DEBUG
        print(response.code)
        #endif
        
        guard (1000..<1410).contains(response.code) else {
            let error = APIError(rawValue: response.code) ?? .unknownError
            throw error
        }
        
        return response
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data?) throws -> T {
        guard let data = data else { throw NetworkServiceError.requestFailed }
        
        do {
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            if let error = error as? DecodingError {
                print(error)
            }
            throw error
        }
    }
}

// MARK: NetworkService Conformation
extension DefaultNetworkService: NetworkService {
    @discardableResult func request<E: TargetType, T: ResponseEntity>(endpoint: E, for type: T.Type) async throws -> HTTPResponse<T> {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            #if DEBUG
            print(type)
            #endif
            
            let provider = MoyaProvider<E>()
            
            provider.request(endpoint) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    do {
                        let headers = try handleResponse(response.response)
                        let decodedData = try decode(for: T.self, with: response.data)
                        let performedData = try performAPIResponse(decodedData)
                        let httpResponse = HTTPResponse(headers: headers, body: performedData)
                        continuation.resume(returning: httpResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
