//
//  ChatRoomConfiguration.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

struct ChatRoomConfiguration: Identifiable {
    let id: Int64
    let title: String?
    let lastMessage: String?
    let lastMessageTimestamp: Date?
    let opponentUserId: Int64
    let opponentUserImageURL: URL?
    let relatedCommunityRecruitingContentId: Int64
    let unreadMessagesCount: Int
}
