//
//  ChatService.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/27/24.
//

import Foundation

protocol ChatService {
    func connect(endpoint: Requestable) async throws
    func disconnect(_ reason: ChatServiceDisconnectReason) throws
    func send(message: MessageEntity) async throws
    func receive() async throws -> AsyncThrowingStream<MessageEntity, Error>
}

// TODO: 네이밍 수정하기
enum ChatServiceDisconnectReason {
    case endChatting // goingAway랑 유사한 사유로 종료
    case abnormalClosure // abnormalClosure랑 유사한 사유로 종료
    // 종료 사유 추가해도 괜찮음, 상황 별로 소켓이 닫히는 사유가 '정상', '비정상' 케이스가 많이 있을거임
}

enum ChatServiceError: Error {
    case invalidURL
    case 형식이다른수신
    case 디코딩에러
    case 소켓없음
    case 소켓이미있음ㅋ
}

final class DefaultChatService {
    private let sessionManager: NetworkSessionManager
    private let encoder: JSONEncodable
    private let decoder: JSONDecodable
    
    private weak var socket: URLSessionWebSocketTask?
    private var isActivated: Bool {
        guard let state = socket?.state else { return false }
        
        switch state {
        case .running: return true
        default: return false
        }
    }
    
    init(
        sessionManager: NetworkSessionManager,
        encoder: JSONEncodable = JSONEncoder(),
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.sessionManager = sessionManager
        self.encoder = encoder
        self.decoder = decoder
    }
    
    private func resolveDisconnectReason(_ reason: ChatServiceDisconnectReason) -> URLSessionWebSocketTask.CloseCode {
        switch reason {
        case .endChatting: return .goingAway
        case .abnormalClosure: return .abnormalClosure
        }
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data) throws -> T {
        guard let decodedData = try? decoder.decode(type, from: data) else {
            throw ChatServiceError.디코딩에러
        }
        return decodedData
    }
}

// MARK: ChatService Conformation
extension DefaultChatService: ChatService {
    func connect(endpoint: any Requestable) async throws {
        guard isActivated == false else {
            throw ChatServiceError.소켓이미있음ㅋ
        }
        
        guard let urlRequest = endpoint.asURLRequest() else {
            throw ChatServiceError.invalidURL
        }
        
        socket = sessionManager.webSocketTask(with: urlRequest)
    }
    
    func disconnect(_ reason: ChatServiceDisconnectReason) throws {
        guard isActivated else {
            throw ChatServiceError.소켓없음
        }
        
        let reason = resolveDisconnectReason(reason)
        socket?.cancel(with: reason, reason: nil)
    }
    
    func send(message: MessageEntity) async throws {
        guard isActivated else {
            throw ChatServiceError.소켓없음
        }
        
        let data = try encoder.encode(message)
        try await socket?.send(.data(data))
    }
    
    func receive() async throws -> AsyncThrowingStream<MessageEntity, Error> {
        guard isActivated else {
            throw ChatServiceError.소켓없음
        }
        
        // TODO: 에러메세지 해결하기
        return AsyncThrowingStream(bufferingPolicy: .unbounded) { continuation in
            while let socket = socket {
                do {
                    let result = try await socket.receive()
                    switch result {
                    case .data(let data):
                        let message = try decode(for: MessageEntity.self, with: data)
                        continuation.yield(message)
                    default:
                        continuation.finish(throwing: .형식이다른수신)
                        break
                    }
                } catch {
                    continuation.finish(throwing: error as? ChatServiceError)
                    break
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                socket?.cancel()
                socket = nil
            }
        }
    }
}
