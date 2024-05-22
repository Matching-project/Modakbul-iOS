//
//  NetworkSessionManager.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol NetworkSessionManager {
    func request(_ urlRequest: URLRequest) async throws -> (Data, URLResponse)
}

final class DefaultNetworkSessionManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: NetworkSessionManager Confirmation
extension DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: urlRequest)
    }
}
