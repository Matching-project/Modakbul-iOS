//
//  NetworkSocketManager.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/27/24.
//

import Foundation

protocol NetworkSocketManager {
    func connect(endpoint: any Requestable, sessionManager: NetworkSessionManager) throws
    func run()
    func send(message: String)
    func receive(completion: @escaping (Result<String, Error>) -> Void)
    func disconnect(by reason: Data)
}

final class DefaultNetworkSocketManager: NSObject, NetworkSocketManager {
    private weak var webSocket: URLSessionWebSocketTask?
    
    private func ping() {
        webSocket?.sendPing { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        }
    }
    
    func connect(endpoint: any Requestable, sessionManager: NetworkSessionManager) throws {
        guard let urlRequest = endpoint.asURLRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        webSocket = sessionManager.webSocketTask(with: urlRequest)
        webSocket?.delegate = self
    }
    
    func run() {
        webSocket?.resume()
    }
    
    func send(message: String) {
        webSocket?.send(.string(message)) { error in
            if let error = error {
                print("Send error: \(error)")
            } else {
                // TODO: 백엔드 서버로 보내는 코드가 필요
            }
        }
    }
    
    func receive(completion: @escaping (Result<String, Error>) -> Void) {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    completion(.success(text))
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.receive(completion: completion)
        }
    }
    
    // TODO: 경우에 따라 cancel()이 어떻게 될지 구현
    // 그에 따라 reason도 분기처리 해야함
    func disconnect(by reason: Data) {
        // case: 채팅방 나가는 경우
        // case: 네트워크 통신안되서 소켓 끊어지던가
        
        //        webSocket?.cancel(with: .goingAway, reason: reason)
        webSocket?.cancel(with: .normalClosure, reason: reason)
        webSocket?.delegate = nil
    }
}

extension DefaultNetworkSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connected")
        ping()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket closed: \(reason?.description ?? "no reason")")
    }
}
