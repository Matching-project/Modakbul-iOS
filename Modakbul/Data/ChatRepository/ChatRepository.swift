//
//  ChatRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

protocol ChatRepository {
    typealias ChatRoomId = String
    typealias CommunityId = String
    
    func createChatRoom(from: User, to: User, on communityId: CommunityId) async throws -> ChatRoomId
    func readChatHistory(on chatRoomId: ChatRoomId) async -> [ChatMessage]
    func updateChatHistory(on chatRoomId: ChatRoomId, with messages: [ChatMessage]) async
    func deleteChatHistory(on chatRoomId: ChatRoomId) async
    
    func openChatRoom(by user: User, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) throws
    func closeChatRoom()
    func send(message: ChatMessage) async throws
}

final class DefaultChatRepository {
    // MARK: - 소켓 통신은 ChatService, 소켓 통신을 제외한 통신은 NetworkService을 이용
    private let chatService: ChatService
    private let networkService: NetworkService
//    private let chattingStorage:
    
    init(
        chatService: ChatService,
        networkService: NetworkService
    ) {
        self.chatService = chatService
        self.networkService = networkService
    }
}

// MARK: ChatRepository Conformation
extension DefaultChatRepository: ChatRepository {
    func createChatRoom(from: User, to: User, on communityId: CommunityId) async throws -> ChatRoomId {
//        let endpoint = Endpoint.createChatRoom(token: <#T##String#>, communityRecruitingContentId: <#T##String#>, opponentUserId: <#T##String#>)
//        let chatRoomInfo = try await networkService.request(endpoint: endpoint, for: ChatRoomInfoEntity.self)
        return ""
    }
    
    func readChatHistory(on chatRoomId: ChatRoomId) async -> [ChatMessage] {
        // ChatStorage에서 기존 채팅기록 확인하고 가져오기
        
        // 있을 경우, 마지막 대화내용의 타임스탬프까지 서버로 전달하여 동기화 안된 부분만 채팅기록 추가 요청
        []
    }
    
    func updateChatHistory(on chatRoomId: ChatRoomId, with messages: [ChatMessage]) async {
        //
    }
    
    func deleteChatHistory(on chatRoomId: ChatRoomId) async {
        //
    }
    
    func openChatRoom(by user: User, _ continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation) throws {
        //        SocketEndpoint.sendChatMessage()
//                chatService.connect(endpoint: <#T##any Requestable#>, <#T##continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation##AsyncThrowingStream<ChatMessage, any Error>.Continuation#>)
    }
    
    func closeChatRoom() {
        //
    }
    
    func send(message: ChatMessage) async throws {
        try await chatService.send(message: message)
    }
}
