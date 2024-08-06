//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation
import Alamofire

protocol NetworkService {
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> HTTPResponse<T>
    func upload<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> HTTPResponse<T>
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
    let headers: HTTPHeaders?
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
    
    private func handleResponse(_ response: HTTPURLResponse?) throws -> HTTPHeaders {
        guard let response = response else {
            throw NetworkServiceError.requestFailed
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkServiceError.badResponse(statusCode: response.statusCode)
        }
        
        return response.headers
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data?) throws -> T {
        guard let data = data,
              let decodedData = try? decoder.decode(type, from: data)
        else {
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
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> HTTPResponse<T> {
        let urlComponents = endpoint.asURLComponents()
        let method = endpoint.httpMethod
        let headers = endpoint.httpHeaders
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            AF.request(
                urlComponents,
                method: method,
                headers: headers
            )
            .response {
                do {
                    let headers = try self.handleResponse($0.response)
                    let decodedData = try self.decode(for: T.self, with: $0.data)
                    let httpResponse = HTTPResponse(headers: headers, body: decodedData)
                    continuation.resume(returning: httpResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func upload<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> HTTPResponse<T> {
        let urlComponents = endpoint.asURLComponents()
        let headers = endpoint.httpHeaders
        let bodies = endpoint.httpBodies
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            AF.upload(
                multipartFormData: { formData in
                    bodies?.forEach {
                        formData.append($0, withName: "\($0)")
                    }
                },
                to: urlComponents,
                headers: headers
            )
            .response {
                do {
                    let headers = try self.handleResponse($0.response)
                    let decodedData = try self.decode(for: T.self, with: $0.data)
                    let httpResponse = HTTPResponse(headers: headers, body: decodedData)
                    continuation.resume(returning: httpResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
