//
//  NetworkService.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol WebSocketServiceProtocol: URLSessionWebSocketDelegate {
    func connect(endpoint: Requestable) throws
    func disconnect(by reason: Data)
}

protocol DataServiceProtocol {
    func request<Response: Decodable>(endpoint: Requestable, for type: Response.Type) async throws -> Response
}

typealias NetworkService = DataServiceProtocol & WebSocketServiceProtocol

fileprivate enum NetworkServiceError: Error {
    case badResponse(statusCode: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError(type: String)
    case generic(type: String)
    case requestFailed
}

final class DefaultNetworkService: NSObject {
    private let sessionManager: NetworkSessionManager
    private let decoder: JSONDecodable
    private weak var webSocket: URLSessionWebSocketTask?
    
    init(
        sessionManager: NetworkSessionManager,
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.sessionManager = sessionManager
        self.decoder = decoder
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
    func connect(endpoint: any Requestable) throws {
        guard let urlRequest = endpoint.asURLRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        webSocket = sessionManager.webSocketTask(with: urlRequest)
        webSocket?.delegate = self
        webSocket?.resume()
    }
        
    func disconnect(by reason: Data) {
        webSocket?.cancel(with: .normalClosure, reason: reason)
    }
    
    func ping() {
        webSocket?.sendPing { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        }
    }
    
    func send(message: String) {
        webSocket?.send(.string(message)) { error in
            if let error = error {
                print("Send error: \(error)")
            }
        }
    }
    
    func receive() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                
                self?.receive()
            }
        }
    }
}
