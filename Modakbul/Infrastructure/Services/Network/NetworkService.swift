//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import Moya

protocol NetworkService {
    func request<E: TargetType, T: Decodable>(endpoint: E, for type: T.Type) async throws -> HTTPResponse<T>
}

enum NetworkServiceError: Error {
    case badResponse(statusCode: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError(type: String)
    case generic(type: String)
    case requestFailed
}

struct HTTPResponse<T: Decodable> {
    let headers: [String: String]?
    let body: T
    
    var accessToken: String? {
        headers?["Authorization"]
    }
    
    var refreshToken: String? {
        headers?["Authorization_refresh"]
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
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data?) throws -> T {
        guard let data = data,
              let decodedData = try? decoder.decode(type, from: data)
        else {
            throw NetworkServiceError.decodingError(type: String(describing: type))
        }
        
        return decodedData
    }
}

// MARK: NetworkService Conformation
extension DefaultNetworkService: NetworkService {
    func request<E: TargetType, T: Decodable>(endpoint: E, for type: T.Type) async throws -> HTTPResponse<T> {
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            let provider = MoyaProvider<E>()
            
            provider.request(endpoint) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    do {
                        let headers = try handleResponse(response.response)
                        let decodedData = try decode(for: T.self, with: response.data)
                        let httpResponse = HTTPResponse(headers: headers, body: decodedData)
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
