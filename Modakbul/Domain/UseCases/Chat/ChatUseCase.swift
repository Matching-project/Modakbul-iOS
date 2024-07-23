//
//  ChatUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol ChatUseCase {
    associatedtype ChatRoomId
    
    func createChatRoom(participants: [User]) async -> ChatRoomId
    func deleteChatRoom(with chatRoomId: ChatRoomId) async
    func fetchChatHistory(with chatRoomId: ChatRoomId) async -> [ChatMessage]
    func fetchCommunityReqruitingContent(_ communityId: Community) async -> CommunityReqruitingContent
    func openChatRoom(with chatRoomId: ChatRoomId, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) async
    func closeChatRoom() async
}
