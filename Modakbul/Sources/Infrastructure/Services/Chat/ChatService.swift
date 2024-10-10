////
////  ChatService.swift
////  Modakbul
////
////  Created by Lim Seonghyeon on 6/27/24.
////
//
//import Foundation
//
//protocol ChatService {
//    func connect(endpoint: Requestable, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) throws
//    func disconnect(_ closeCode: ChatServiceCloseCode?)
//    func send(message: ChatMessage) async throws
//}
//

import Foundation
import SwiftStomp

protocol ChatService {
    /// 소켓 연결
    func connect(token: String, on chatRoomId: Int64, userId: Int64, userNickname nickname: String) throws
    /// 소켓 연결 해제
    func disconnect()
    /// 소켓을 통해 특정 채팅방 구독
    func subscribe(to chatRoomId: Int64, continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation)
    /// 소켓을 통해 특정 채팅방 구독 해제
    func unsubscribe(from chatRoomId: Int64)
    /// 채널(채팅방)로 메세지 전송
    func send<T: Encodable>(message: T) async throws
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
    private var stomp: SwiftStomp?
    private let encoder: JSONEncodable
    private let decoder: JSONDecodable
    
    private var chatStreamContinuation: AsyncThrowingStream<ChatMessage, Error>.Continuation?
    
    init(
        encoder: JSONEncodable = JSONEncoder(),
        decoder: JSONDecodable = JSONDecoder()
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    deinit {
        stomp?.disconnect(force: true)
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
}

// MARK: ChatService Conformation
extension DefaultChatService: ChatService {
    func connect(token: String, on chatRoomId: Int64, userId: Int64, userNickname nickname: String) throws {
        // TODO: 서버 URL 배포 예정
        guard let url = URL(string: "ws://13.209.130.215:8080/stomp") else { throw ChatServiceError.invalidURL }
        let headers = [
            "Authorization" : "Bearer \(token)",
            "chatRoomId" : "\(chatRoomId)",
            "userId" : "\(userId)",
            "nickname" : "\(nickname)"
        ]
        stomp = SwiftStomp(host: url, headers: headers)
        stomp?.delegate = self
        stomp?.connect()
    }
    
    func disconnect() {
        // Auto-Reconnect 옵션이 켜져 있을 경우, disconnect 시 자동으로 재연결 하기 때문에 수동으로 옵션을 꺼줄 것.
        stomp?.autoReconnect = false
        stomp?.disconnect()
    }
    
    func subscribe(to chatRoomId: Int64, continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) {
        chatStreamContinuation = continuation
        stomp?.subscribe(to: "/sub/public/\(chatRoomId)")
    }
    
    func unsubscribe(from chatRoomId: Int64) {
        stomp?.unsubscribe(from: "/sub/public/\(chatRoomId)")
        chatStreamContinuation?.finish()
    }
    
    func send<T: Encodable>(message: T) async throws {
        stomp?.send(body: message, to: "/pub/message")
    }
}

// MARK: SwiftStompDelegate Conformation
extension DefaultChatService: SwiftStompDelegate {
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Chat Service Connected")
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("Chat Service Disconnected")
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        guard let data = message as? Data else {
            chatStreamContinuation?.yield(with: .failure(ChatServiceError.invalidMessageFormat))
            return
        }
        
        guard let entity = try? decoder.decode(ChatEntity.self, from: data) else {
            chatStreamContinuation?.yield(with: .failure(ChatServiceError.generic(type: String(describing: data))))
            return
        }
        chatStreamContinuation?.yield(entity.toDTO())
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print(receiptId)
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        chatStreamContinuation?.finish(throwing: ChatServiceError.generic(type: briefDescription))
    }
}
