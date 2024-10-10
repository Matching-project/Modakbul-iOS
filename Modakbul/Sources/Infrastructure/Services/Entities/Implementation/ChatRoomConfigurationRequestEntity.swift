//
//  ChatRoomConfigurationRequestEntity.swift
//  Modakbul
//
//  Created by Swain Yun on 9/2/24.
//

import Foundation

/// 채팅방 생성 요청
struct ChatRoomConfigurationRequestEntity: Encodable {
    let communityRecruitingContentId: Int64
    let opponentUserId: Int64
    
    enum CodingKeys: String, CodingKey {
        case communityRecruitingContentId = "boardId"
        case opponentUserId = "theOtherUserId"
    }
}

/// 채팅방 생성 응답
struct ChatRoomConfigurationResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    /// 채팅방 고유 식별값
    let result: Int64
    
    func toDTO() -> Int64 { result }
}
