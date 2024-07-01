//
//  Message.swift
//  Modakbul
//
//  Created by Swain Yun on 6/30/24.
//

import Foundation

/**
 채팅 메세지
 
 ### 프로퍼티
 - from: 메세지 송신자
 - text: 메세지의 내용
 - timestamp: 메세지 발송 시각
 */
struct MessageEntity: Codable {
    let from: String
    let to: String
    let text: String
    let timestamp: String
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
        ChatMessage(from: from,
                    to: to,
                    text: text,
                    timestamp: stringToDate())
    }
}
