//
//  ChatMessage.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class ChatRoom: Identifiable {
    @Attribute(.unique) var id: Int64
    @Relationship(deleteRule: .cascade) var messages: [ChatMessage]
    var title: String?
    var opponentUserId: Int64
    var opponentUserImageURL: URL?
    var relatedCommunityRecruitingContentId: Int64
    
    private var _unreadMessagesCount: Int = 0
    var unreadMessagesCount: Int {
        get {
            let count = messages.filter { $0.isRead == false && $0.senderId != Constants.loggedOutUserId && $0.senderId == opponentUserId }.count
            return max(_unreadMessagesCount, count)
        }
        
        set {
            _unreadMessagesCount = newValue
        }
    }
    
    init(
        id: Int64,
        messages: [ChatMessage] = [],
        title: String?,
        opponentUserId: Int64,
        opponentuserImageURL: URL? = nil,
        relatedCommunityRecruitingContentId: Int64
    ) {
        self.id = id
        self.messages = messages
        self.title = title
        self.opponentUserId = opponentUserId
        self.opponentUserImageURL = opponentuserImageURL
        self.relatedCommunityRecruitingContentId = relatedCommunityRecruitingContentId
    }
    
    convenience init(configuration: ChatRoomConfiguration) {
        self.init(id: configuration.id,
                  messages: [],
                  title: configuration.title,
                  opponentUserId: configuration.opponentUserId,
                  opponentuserImageURL: configuration.opponentUserImageURL,
                  relatedCommunityRecruitingContentId: configuration.relatedCommunityRecruitingContentId)
    }
    
    func update(with configuration: ChatRoomConfiguration) {
        self.title = configuration.title
        self.opponentUserId = configuration.opponentUserId
        self.opponentUserImageURL = configuration.opponentUserImageURL
        self.relatedCommunityRecruitingContentId = configuration.relatedCommunityRecruitingContentId
        self.unreadMessagesCount = configuration.unreadMessagesCount
    }
}

@Model
final class ChatMessage: Identifiable {
    @Attribute(.unique) var id: UUID
    var chatRoomId: Int64
    var senderId: Int64
    var senderNickname: String
    var content: String
    var sendTime: Date
    var unreadCount: Int
    var isRead: Bool
    
    init(
        id: UUID = UUID(),
        chatRoomId: Int64,
        senderId: Int64,
        senderNickname: String,
        content: String,
        sendTime: Date,
        unreadCount: Int,
        isRead: Bool = false
    ) {
        self.id = id
        self.chatRoomId = chatRoomId
        self.senderId = senderId
        self.senderNickname = senderNickname
        self.content = content
        self.sendTime = sendTime
        self.unreadCount = unreadCount
        self.isRead = isRead
    }
}

enum ChatRole {
    case timestamp
    case onOpponentUserComingIn
    case me
    case opponentUser
    
    init(myUserId: Int64, senderId: Int64) {
        switch senderId {
        case Constants.timestampId:
            self = .timestamp
        case Constants.temporalId:
            self = .onOpponentUserComingIn
        case myUserId:
            self = .me
        default:
            self = .opponentUser
        }
    }
}
