//
//  NotificationSendingRequestEntity.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/6/24.
//

import Foundation


/// 알림 전송
struct NotificationSendingRequestEntity: Encodable {
    let communityRecruitingContentId: Int64
    let subtitle, type: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case communityRecruitingContentId = "boardId"
        case subtitle = "content"
    }
}
