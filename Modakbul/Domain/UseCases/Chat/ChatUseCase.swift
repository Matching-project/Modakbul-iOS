//
//  ChatUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol ChatUseCase {
    func createChatRoom(participants: [User]) async -> String
    func deleteChatRoom(with chatRoomId: String) async
    func fetchChatHistory(with chatRoomId: String) async -> [ChatMessage]
    func openChatRoom(with chatRoomId: String, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) async
    func closeChatRoom() async
}
