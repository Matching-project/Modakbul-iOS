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
    let title, subtitle, type: String
    
    enum CodingKeys: String, CodingKey {
        case type, title, subtitle
        case communityRecruitingContentId = "boardId"
    }
    
    init(communityRecruitingContentId: Int64, _ pushNotification: PushNotification) {
        self.communityRecruitingContentId = communityRecruitingContentId
        self.title = pushNotification.title
        self.subtitle = pushNotification.subtitle
        self.type = pushNotification.type.description
    }
}
