//
//  ChatUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol ChatUseCase {
    typealias ChatRoomId = Int64
    typealias UserId = Int64
    typealias CommunityRecruitingContentId = Int64
    
    /// 채팅 시작
    func startChat(
        userId: Int64,
        userNickname nickname: String,
        on chatRoomId: ChatRoomId,
        _ continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation
    ) async throws
    
    /// 채팅 종료
    func stopChat(on chatRoomId: ChatRoomId)
    
    /// 채팅방 기접속여부 조회
    /// - Returns:
    ///     false일 경우 중복접속된 상태이므로 채팅방 접속 금지,
    ///     true일 경우 중복접속 중인 상태가 아니므로 채팅방 접속 가능을 의미합니다.
    func isConnectionAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool
    
    /// 나간 채팅방 확인
    ///
    /// 상대방이 채팅을 수신할 수 있는지 확인합니다.
    ///
    /// - Note: 상대방이 채팅방을 나갔다면 채팅을 수신할 수 없습니다. 따라서 그러한 상황이라는 것을 사용자가 잘 인식할 수 있도록 해야합니다.
    func isOpponentUserAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool
    
    /// 채팅방 목록 조회
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration]
    
    /// 채팅방 생성하기
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId
    
    /// 채팅방 나가기
    func exitChatRoom(userId: UserId, on chatRoomId: ChatRoomId) async throws
    
    /// 대화기록 불러오기
    func readChatingHistory(userId: UserId, on chatRoomId: ChatRoomId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatHistory
    
    /// 채팅메세지 전송
    func send(message: ChatMessage) throws
    
    /// 채팅방 신고하고 나가기
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws
}

final class DefaultChatUseCase {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

// MARK: ChatUseCase Conformation
extension DefaultChatUseCase: ChatUseCase {
    func startChat(
        userId: Int64,
        userNickname nickname: String,
        on chatRoomId: ChatRoomId,
        _ continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation
    ) async throws {
        try await chatRepository.startChat(userId: userId, userNickname: nickname, on: chatRoomId, continuation)
    }
    
    func stopChat(on chatRoomId: ChatRoomId) {
        chatRepository.stopChat(on: chatRoomId)
    }
    
    func isConnectionAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool {
        try await chatRepository.isConnectionAvailable(userId: userId, on: chatRoomId)
    }
    
    func isOpponentUserAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool {
        try await chatRepository.isOpponentUserAvailable(userId: userId, on: chatRoomId)
    }
    
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration] {
        try await chatRepository.readChatRooms(userId: userId)
    }
    
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId {
        try await chatRepository.createChatRoom(userId: userId, opponentUserId: opponentUserId, with: communityRecruitingContentId)
    }
    
    func exitChatRoom(userId: UserId, on chatRoomId: ChatRoomId) async throws {
        try await chatRepository.exitChatRoom(userId: userId, on: chatRoomId)
    }
    
    func readChatingHistory(userId: UserId,
                            on chatRoomId: ChatRoomId,
                            with communityRecruitingContentId: CommunityRecruitingContentId
    ) async throws -> ChatHistory {
        try await chatRepository.readChatingHistory(userId: userId, on: chatRoomId, with: communityRecruitingContentId)
    }
    
    func send(message: ChatMessage) throws {
        try chatRepository.send(message: message)
    }
    
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws {
        try await chatRepository.reportAndExitChatRoom(userId: userId, opponentUserId: opponentUserId, chatRoomId: chatRoomId, report: report)
    }
}
