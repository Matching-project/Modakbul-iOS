//
//  NotificationSendingRequestEntity.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/6/24.
//

import Foundation


/// 알림 전송
struct NotificationSendingRequestEntity: Encodable {
    let type: String
    let subtitle: String
    let opponentUserId: Int64
    
    enum CodingKeys: String, CodingKey {
        case type = "notificationType"
        // 보내는 토큰에 따라 title이 결정되므로
        case subtitle = "boardTitle"
    }
}
