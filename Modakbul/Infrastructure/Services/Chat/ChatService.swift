//
//  ChatService.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/27/24.
//

import Foundation

protocol ChatService {
    func connect(endpoint: Requestable, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) throws
    func disconnect(_ closeCode: ChatServiceCloseCode?)
    func send(message: ChatMessage) async throws
}

enum ChatServiceCloseCode {
    case endChatting // goingAway랑 유사한 사유로 종료
    case abnormalClosure // abnormalClosure랑 유사한 사유로 종료
    // 종료 사유 추가해도 괜찮음, 상황 별로 소켓이 닫히는 사유가 '정상', '비정상' 케이스가 많이 있을거임
}

enum ChatServiceError: Error {
    case invalidURL
    case invalidMessageFormat
    case generic(type: String)
    case noSocket
    case socketAlreadyExists
}

final class DefaultChatService {
    private let socketManager: SocketManager
    private let encoder: JSONEncodable
    private let decoder: JSONDecodable
    
    private weak var socket: URLSessionWebSocketTask?
    private var chatStreamContinuation: AsyncThrowingStream<ChatMessage, Error>.Continuation?
    
    init(
        socketManager: SocketManager,
        encoder: JSONEncodable = JSONEncoder(),
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.socketManager = socketManager
        self.encoder = encoder
        self.decoder = decoder
    }
    
    private func resolve(_ reason: ChatServiceCloseCode?) -> URLSessionWebSocketTask.CloseCode {
        switch reason {
        case .endChatting, .none: return .goingAway
        case .abnormalClosure: return .abnormalClosure
        }
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data) throws -> T {
        guard let decodedData = try? decoder.decode(type, from: data) else {
            throw ChatServiceError.generic(type: String(describing: T.self))
        }
        return decodedData
    }
    
    private func performReceivedResult(_ result: URLSessionWebSocketTask.Message,
                                       _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) {
        do {
            switch result {
            case .data(let data):
                let message = try decode(for: MessageEntity.self, with: data)
                continuation.yield(message.toDTO())
            default:
                continuation.finish(throwing: ChatServiceError.invalidMessageFormat)
            }
        } catch {
            continuation.finish(throwing: error)
        }
    }
}

// MARK: ChatService Conformation
extension DefaultChatService: ChatService {
    func connect(endpoint: any Requestable, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) throws {
        guard let url = endpoint.asURLComponents().url else { throw ChatServiceError.invalidURL }
        let urlRequest = URLRequest(url: url)
        socket = socketManager.webSocketTask(with: urlRequest)
        chatStreamContinuation = continuation
        
        Task {
            while let socket = socket, socket.state == .running {
                do {
                    let result = try await socket.receive()
                    performReceivedResult(result, continuation)
                } catch {
                    continuation.finish(throwing: error)
                    break
                }
            }
            
            continuation.onTermination = { [weak self] _ in
                self?.disconnect(nil)
            }
        }
    }
    
    func disconnect(_ closeCode: ChatServiceCloseCode?) {
        socket?.cancel(with: resolve(closeCode), reason: nil)
        socket = nil
        chatStreamContinuation?.finish()
        chatStreamContinuation = nil
    }
    
    func send(message: ChatMessage) async throws {
        let entity: MessageEntity = .init(message)
        let data = try encoder.encode(entity)
        try await socket?.send(.data(data))
    }
}
