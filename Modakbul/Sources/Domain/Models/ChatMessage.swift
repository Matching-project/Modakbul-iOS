//
//  ChatMessage.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

struct ChatMessage: Identifiable, Encodable {
    let id = UUID()
    let chatRoomId: Int64
    let senderId: Int64
    let senderNickname: String
    let content: String
    let sendTime: Date
    let readCount: Int
}

enum ChatRole {
    case system
    case me
    case opponentUser
    
    init(myUserId: Int64, senderId: Int64) {
        switch senderId {
        case -1:
            self = .system
        case myUserId:
            self = .me
        default:
            self = .opponentUser
        }
    }
}
