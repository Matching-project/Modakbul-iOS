//
//  ChatRoomConfiguration.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct ChatRoomConfiguration: Identifiable {
    let id: Int64
    /// 단체 채팅방시를 고려하여 `String`이 아닌 `String?`로 선언
    let title: String?
    let lastMessage: String?
    let lastMessageTimestamp: Date?
    let opponentUserId: Int64
    let opponentUserImageURL: URL?
    let relatedCommunityRecruitingContentId: Int64
    let unreadMessagesCount: Int
    
    init(id: Int64,
         title: String?,
         lastMessage: String? = nil,
         lastMessageTimestamp: Date? = nil,
         opponentUserId: Int64,
         opponentUserImageURL: URL? = nil,
         relatedCommunityRecruitingContentId: Int64,
         unreadMessagesCount: Int
    ) {
        self.id = id
        self.title = title
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
        self.opponentUserId = opponentUserId
        self.opponentUserImageURL = opponentUserImageURL
        self.relatedCommunityRecruitingContentId = relatedCommunityRecruitingContentId
        self.unreadMessagesCount = unreadMessagesCount
    }
}
