//
//  ChatRoomCreateRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 8/13/24.
//

import Foundation

struct ChatRoomCreateRequestEntity: Encodable {
    let communityRecruitingContentId: Int64
    let opponentUserId: Int64
    
    enum CodingKeys: String, CodingKey {
        case communityRecruitingContentId = "board_id"
        case opponentUserId = "opponent_user_id"
    }
}
