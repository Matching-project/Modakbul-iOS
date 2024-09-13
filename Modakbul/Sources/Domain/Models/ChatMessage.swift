//
//  ChatMessage.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let chatRoomId: Int64
    let senderId: Int64
    let senderNickname: String
    let content: String
    let sendTime: Date
    let readCount: Int
}
