//
//  SocketManager.swift
//  Modakbul
//
//  Created by Swain Yun on 5/22/24.
//

import Foundation

protocol SocketManager {
    func webSocketTask(with urlRequest: URLRequest) -> URLSessionWebSocketTask
}

final class DefaultSocketManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: SocketManager Conformation
extension DefaultSocketManager: SocketManager {
    func webSocketTask(with urlRequest: URLRequest) -> URLSessionWebSocketTask {
        return session.webSocketTask(with: urlRequest)
    }
}
