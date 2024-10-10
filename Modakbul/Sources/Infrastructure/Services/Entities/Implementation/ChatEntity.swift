//
//  ChatEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/10/24.
//

import Foundation

struct ChatEntity: Codable {
    let chatRoomId: Int64
    let senderId: Int64
    let senderNickname: String
    let content: String
    let sendTime: Date
    let unreadCount: Int
    
    init(
        chatRoomId: Int64,
        senderId: Int64,
        senderNickname: String,
        content: String,
        sendTime: Date,
        unreadCount: Int
    ) {
        self.chatRoomId = chatRoomId
        self.senderId = senderId
        self.senderNickname = senderNickname
        self.content = content
        self.sendTime = sendTime
        self.unreadCount = unreadCount
    }
    
    init(chatMessage: ChatMessage) {
        self.init(
            chatRoomId: chatMessage.chatRoomId,
            senderId: chatMessage.senderId,
            senderNickname: chatMessage.senderNickname,
            content: chatMessage.content,
            sendTime: chatMessage.sendTime,
            unreadCount: chatMessage.unreadCount
        )
    }
    
    func toDTO() -> ChatMessage {
        .init(
            chatRoomId: chatRoomId,
            senderId: senderId,
            senderNickname: senderNickname,
            content: content,
            sendTime: sendTime,
            unreadCount: unreadCount
        )
    }
}
