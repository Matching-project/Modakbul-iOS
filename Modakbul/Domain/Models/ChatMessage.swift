//
//  ChatMessage.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: UUID = UUID()
    let senderId: Int64
    let text: String
    let timestamp: Date
    let isRead: Bool
}
