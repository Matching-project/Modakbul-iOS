//
//  ChatRoomCreateRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

/// 채팅방 생성 요청
struct ChatRoomCreateRequestEntity: Encodable {
    let communityRecruitingContentId: Int64
    let opponentUserId: Int64
    
    enum CodingKeys: String, CodingKey {
        case opponentUserId
        case communityRecruitingContentId = "boardId"
    }
}
