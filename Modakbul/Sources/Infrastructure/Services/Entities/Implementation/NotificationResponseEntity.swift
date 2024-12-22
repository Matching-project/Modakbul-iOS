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
    let result: [Result]
    
    struct Result: Decodable {
        let id, communityRecruitingContentId: Int64
        let title, type, subtitle, timestamp: String
        let imageURL: URL?
        let isRead: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, title, type, isRead
            case imageURL = "thumbnail"
            case communityRecruitingContentId = "boardId"
            case subtitle = "content"
            case timestamp = "createdAt"
        }
    }
    
    func toDTO() async -> [PushNotification] {
        await withTaskGroup(of: PushNotification.self) { group in
            for item in result {
                group.addTask {
                    let timestamp = await item.timestamp.toDate(by: .serverDateTime2) ?? .now
                    return await PushNotification(
                        id: item.id,
                        imageURL: item.imageURL,
                        title: item.title,
                        subtitle: item.subtitle,
                        timestamp: item.timestamp,
                        type: .init(from: item.type, communityRecruitingContentId: item.communityRecruitingContentId),
                        isRead: item.isRead
                    )
                }
            }
            return await group.reduce(into: []) { $0.append($1) }
        }
    }
}
