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
