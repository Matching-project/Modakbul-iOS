//
//  ChatUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

//protocol ChatUseCase {
//    typealias ChatRoomId = Int64
//    
//    func startChat(from: User, to: User, with communityRecruitingContent: CommunityRecruitingContent, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) async throws -> ChatRoomConfiguration
//    func stopChat(on chatRoomId: ChatRoomId, messages: [ChatMessage])
//    func deleteChat(on chatRoomId: ChatRoomId)
//    
//    func send(message: ChatMessage) throws
//}
//
//final class DefaultChatUseCase {
//    private let chatRepository: ChatRepository
//    
//    init(chatRepository: ChatRepository) {
//        self.chatRepository = chatRepository
//    }
//}
//
//// MARK: ChatUseCase Conformation
//extension DefaultChatUseCase: ChatUseCase {
//    func startChat(from: User, to: User, with communityRecruitingContent: CommunityRecruitingContent, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) async throws -> ChatRoomConfiguration {
//        let chatRoomId = try await chatRepository.createChatRoom(from: from, to: to, on: communityRecruitingContent.id)
//        let chatHistory = await chatRepository.readChatHistory(on: chatRoomId)
//        try chatRepository.openChatRoom(by: to, continuation)
//        return ChatRoomConfiguration(id: chatRoomId, communityRecruitingContent: communityRecruitingContent, participants: [from, to])
//    }
//    
//    func stopChat(on chatRoomId: ChatRoomId, messages: [ChatMessage]) {
//        Task {
//            await chatRepository.updateChatHistory(on: chatRoomId, with: messages)
//            chatRepository.closeChatRoom()
//        }
//    }
//    
//    func deleteChat(on chatRoomId: ChatRoomId) {
//        Task {
//            await chatRepository.deleteChatHistory(on: chatRoomId)
//        }
//    }
//    
//    func send(message: ChatMessage) throws {
//        Task {
//            try await chatRepository.send(message: message)
//        }
//    }
//}
