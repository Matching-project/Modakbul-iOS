//
//  NetworkSessionManager.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol NetworkSessionManager {
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse)
    func webSocketTask(with urlRequest: URLRequest) -> URLSessionWebSocketTask
}

final class DefaultNetworkSessionManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: NetworkSessionManager Confirmation
extension DefaultNetworkSessionManager: NetworkSessionManager {
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: urlRequest)
    }
    
    func webSocketTask(with urlRequest: URLRequest) -> URLSessionWebSocketTask {
        return session.webSocketTask(with: urlRequest)
    }
}
