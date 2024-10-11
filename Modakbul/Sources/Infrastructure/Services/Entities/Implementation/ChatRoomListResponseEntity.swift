//
//  ChatRoomListResponseEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/2/24.
//

import Foundation

/// 채팅방 목록 조회 응답
struct ChatRoomListResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: [Result]
    
    struct Result: Decodable {
        let roomTitle: String
        let lastMessage: String?
        /// ISO8601 형식 문자열 시간 표현
        let lastMessageTimestamp: String
        let opponentUserImageURL: URL?
        let opponentUserId: Int64
        let id: Int64
        let communityRecruitingContentId: Int64
        let unreadMessagesCount: Int
        
        enum CodingKeys: String, CodingKey {
            case roomTitle, lastMessage
            case lastMessageTimestamp = "lastMessageTime"
            case opponentUserImageURL = "theOtherUserImage"
            case opponentUserId = "theOtherUserId"
            case id = "chatRoomId"
            case communityRecruitingContentId = "boardId"
            case unreadMessagesCount = "unreadCount"
        }
    }
    
    func toDTO() -> [ChatRoomConfiguration] {
        result.map {
            .init(
                id: $0.id,
                title: $0.roomTitle,
                lastMessage: $0.lastMessage,
                lastMessageTimestamp: DateFormat.toDate(iso8601String: $0.lastMessageTimestamp),
                opponentUserId: $0.opponentUserId,
                opponentUserImageURL: $0.opponentUserImageURL,
                relatedCommunityRecruitingContentId: $0.communityRecruitingContentId,
                unreadMessagesCount: $0.unreadMessagesCount
            )
        }
    }
}
