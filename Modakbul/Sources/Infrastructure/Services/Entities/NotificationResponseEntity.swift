//
//  NotificationResponseEntity.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/7/24.
//

import Foundation

/// 알림 목록 조회 요청
struct NotificationResponseEntity: ResponseEntity {
    let status: Bool
    let code: Int
    let message: String
    let result: Result
    
    struct Result: Decodable {
        let notifications: [PushNotification]
        
        struct PushNotification: Decodable {
            let id, communityRecruitingContentId: Int64
            let title, type, subtitle, timestamp: String
            let isRead: Bool
            
            enum CodingKeys: String, CodingKey {
                case id, title, type, isRead
                case communityRecruitingContentId = "boardId"
                case subtitle = "content"
                case timestamp = "createdAt"
            }
        }
    }
    
    func toDTO() -> [PushNotification] {
        result.notifications.map {
            .init(id: $0.id,
                  title: $0.title,
                  subtitle: $0.subtitle,
                  timestamp: $0.timestamp,
                  type: .init(from: $0.type,
                              communityRecruitingContentId: $0.communityRecruitingContentId))
        }
    }
}
