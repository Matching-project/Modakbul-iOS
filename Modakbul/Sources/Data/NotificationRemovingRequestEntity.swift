//
//  NotificationRemovingRequestEntity.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/7/24.
//

import Foundation

/// 알림 삭제 (단일, 선택, 전체) 요청
struct NotificationRemovingRequestEntity: Encodable {
    let notificationIds: [Int64]
}
