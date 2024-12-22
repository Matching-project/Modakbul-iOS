//
//  ChatEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/10/24.
//

import Foundation

struct ChatEntity: Codable {
    // 필수 Field
    let chatRoomId: Int64
    let senderNickname: String
    
    // 옵셔널 Field
    let senderId: Int64?
    let content: String?
    let sendTime: String?
    let unreadCount: Int?
    
    init(
        chatRoomId: Int64,
        senderId: Int64? = nil,
        senderNickname: String,
        content: String? = nil,
        sendTime: Date? = nil,
        unreadCount: Int? = .zero
    ) async {
        self.chatRoomId = chatRoomId
        self.senderId = senderId
        self.senderNickname = senderNickname
        self.content = content
        self.sendTime = await sendTime?.toString(by: .serverDateTime1) ?? String()
        self.unreadCount = unreadCount
    }
    
    init(chatMessage: ChatMessage) async {
        await self.init(
            chatRoomId: chatMessage.chatRoomId,
            senderId: chatMessage.senderId,
            senderNickname: chatMessage.senderNickname,
            content: chatMessage.content,
            sendTime: chatMessage.sendTime,
            unreadCount: chatMessage.unreadCount
        )
    }
    
    func toDTO() async -> ChatMessage {
        .init(
            chatRoomId: chatRoomId,
            senderId: senderId ?? Constants.temporalId,
            senderNickname: senderNickname,
            content: content ?? String(),
            sendTime: await sendTime?.toDate(by: .serverDateTime1) ?? .now,
            unreadCount: unreadCount ?? .zero
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case chatRoomId, senderId, senderNickname, content, sendTime
        case unreadCount = "readCount"
    }
}
