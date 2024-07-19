//
//  ChatMessage.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

struct ChatMessage {
    let id: UUID = UUID()
    let from: String
    let to: String
    let text: String
    let timestamp: Date
}

extension ChatMessage {
    func toEntity() -> MessageEntity {
        MessageEntity(from: from,
                      to: to,
                      text: text,
                      timestamp: timestamp.ISO8601Format())
    }
}
