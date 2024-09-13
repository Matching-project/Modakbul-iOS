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
    let readCount: Int
    
    func toDTO() -> ChatMessage {
        .init(
            chatRoomId: chatRoomId,
            senderId: senderId,
            senderNickname: senderNickname,
            content: content,
            sendTime: sendTime,
            readCount: readCount
        )
    }
}
