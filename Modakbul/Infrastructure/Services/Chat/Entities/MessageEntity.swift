//
//  Message.swift
//  Modakbul
//
//  Created by Swain Yun on 6/30/24.
//

import Foundation

struct MessageEntity: Codable {
    let from: UserEntity
    let text: String
    let timestamp: String
    let isRead: Bool
    
    init(_ dto: ChatMessage) {
        self.from = .init(dto.sender)
        self.text = dto.text
        self.timestamp = dto.timestamp.toString()
        self.isRead = dto.isRead
    }
}

extension MessageEntity {
    func stringToDate() -> Date {
        let iso8601DateFormatter = ISO8601DateFormatter()

        if let date = iso8601DateFormatter.date(from: timestamp) {
            return date
        } else {
            print("ISO 8601 문자열을 Date로 변환할 수 없습니다.")
            // TODO: 테스트용 코드 수정 필요
            return Date.now
        }
    }
    
    func toDTO() -> ChatMessage {
        return ChatMessage(sender: from.toDTO(),
                           text: text,
                           timestamp: .now,
                           isRead: isRead)
    }
}
