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
    
    /// 채팅방 목록 조회
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration]
    
    /// 채팅방 생성하기
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId
    
    /// 채팅방 삭제하기
    func deleteChat(userId: UserId, on chatRoomId: ChatRoomId) async throws
    
    /// 대화기록 불러오기
    func readChatingHistory(userId: UserId, on chatRoomId: ChatRoomId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatHistory
    
    /// 채팅메세지 전송
    func send(message: ChatMessage) throws
    
    /// 채팅방 신고하고 나가기
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws
    
    /// 채팅방 나가기
    func exitChatRoom(userId: UserId, chatRoomId: ChatRoomId) async throws
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
    
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration] {
        try await chatRepository.readChatRooms(userId: userId)
    }
    
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId {
        try await chatRepository.createChatRoom(userId: userId, opponentUserId: opponentUserId, with: communityRecruitingContentId)
    }
    
    func deleteChat(userId: UserId, on chatRoomId: ChatRoomId) async throws {
        try await chatRepository.deleteChat(userId: userId, on: chatRoomId)
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
    
    func exitChatRoom(userId: UserId, chatRoomId: ChatRoomId) async throws {
        try await chatRepository.exitChatRoom(userId: userId, chatRoomId: chatRoomId)
    }
}
