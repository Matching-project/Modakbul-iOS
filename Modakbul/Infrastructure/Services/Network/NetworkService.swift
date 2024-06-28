//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol WebSocketServiceProtocol {
    func openSocket(endpoint: any Requestable) throws
    func closeSocket(by reason: Data)
}

protocol DataServiceProtocol {
    func request<Response: Decodable>(endpoint: Requestable, for type: Response.Type) async throws -> Response
}

typealias NetworkService = DataServiceProtocol & WebSocketServiceProtocol

final class DefaultNetworkService: NSObject {
    private let sessionManager: NetworkSessionManager
    private let decoder: JSONDecodable
    private let socketManager: NetworkSocketManager
    
    init(
        sessionManager: NetworkSessionManager,
        decoder: JSONDecodable = JSONDecoder(),
        socketManager: NetworkSocketManager
    ) {
        self.sessionManager = sessionManager
        self.decoder = decoder
        self.socketManager = socketManager
        super.init()
    }
    
    private func handleResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkServiceError.generic(type: String(describing: response))
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkServiceError.badResponse(statusCode: response.statusCode)
        }
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

// MARK: NetworkService Confirmation
extension DefaultNetworkService: NetworkService {
    // MARK: - DataServiceProtocol
    func request<Response: Decodable>(endpoint: Requestable, for type: Response.Type) async throws -> Response {
        guard let urlRequest = endpoint.asURLRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await sessionManager.data(for: urlRequest)
            try handleResponse(response)
            let decodedData = try decode(for: type, with: data)
            return decodedData
        } catch {
            throw resolveError(error)
        }
    }
    
    // MARK: - WebSocketServiceProtocol
    func openSocket(endpoint: any Requestable) throws {
        try socketManager.connect(endpoint: endpoint, sessionManager: sessionManager)
        socketManager.run()
    }
    
    func closeSocket(by reason: Data) {
        socketManager.disconnect(by: reason)
    }
}
