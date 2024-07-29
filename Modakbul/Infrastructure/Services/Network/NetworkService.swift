//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> HTTPResponse<T>
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
    let headers: [AnyHashable: Any]
    let body: T
    
    var accessToken: String? {
        guard let header = headers["Authorization"] as? [String],
              let token = header.first
        else { return nil }
        
        return token
    }
    
    var refreshToken: String? {
        guard let header = headers["Authorization_refresh"] as? [String],
              let token = header.first
        else { return nil }
        
        return token
    }
}

final class DefaultNetworkService {
    private let sessionManager: NetworkSessionManager
    private let decoder: JSONDecodable
    
    init(
        sessionManager: NetworkSessionManager,
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }
    
    private func handleResponse(_ response: URLResponse) throws -> HTTPURLResponse {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkServiceError.generic(type: String(describing: response))
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkServiceError.badResponse(statusCode: response.statusCode)
        }
        
        return response
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data) throws -> T {
        guard let decodedData = try? decoder.decode(type, from: data) else {
            throw NetworkServiceError.decodingError(type: String(describing: type))
        }
        return decodedData
    }
    
    private func resolveError(_ error: Error) -> NetworkServiceError {
        if let error = error as? NetworkServiceError {
            return error
        } else {
            let code = URLError.Code(rawValue: (error as NSError).code)
            switch code {
            case .notConnectedToInternet: return .notConnectedToInternet
            case .badURL: return .invalidURL
            default: return .requestFailed
            }
        }
    }
}

// MARK: NetworkService Conformation
extension DefaultNetworkService: NetworkService {
    // MARK: - DataServiceProtocol
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> HTTPResponse<T> {
        guard let urlRequest = endpoint.asURLRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await sessionManager.data(for: urlRequest)
            let headers = try handleResponse(response).allHeaderFields
            let decodedData = try decode(for: type, with: data)
            return HTTPResponse(headers: headers, body: decodedData)
        } catch {
            throw resolveError(error)
        }
    }
}
