//
//  NotificationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol NotificationUseCase {
    /// 알림을 전송합니다.
    /// - Parameters:
    ///   - communityRecruitingContentId: 알림의 출처가 어떤 모집글인지 의미합니다.
    ///   - userId: 나의 아이디를 의미합니다.
    ///   - opponentUserId: 상대방의 아이디를 의미합니다.
    ///   - pushNotification: 알림 내용을 모두 담은 자료구조 입니다.
    func send(_ communityRecruitingContentId: Int64, from userId: Int64, to opponentUserId: Int64, pushNotification: PushNotification) async throws
    
    /// 알림 목록을 조회합니다.
    /// - Parameter userId: 나의 아이디를 의미합니다.
    /// - Returns: 1개 이상의 알림 배열입니다.
    func fetch(userId: Int64) async throws -> [PushNotification]

    /// 1개 이상의 알림을 삭제합니다.
    /// - Parameter userId: 나의 아이디를 의미합니다.
    /// - Parameter notificationIds: 삭제할 알림의 아이디입니다.
    func remove(userId: Int64, _ notificationIds: [Int64]) async throws
    
    /// 알림을 읽음처리 합니다.
    /// - Parameter userId: 나의 아이디를 의미합니다.
    /// - Parameter notificationIds: 읽음 처리할 알림 아이디입니다.
    func read(userId: Int64, _ notificationIds: Int64) async throws
}

final class DefaultNotificationUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
}

extension DefaultNotificationUseCase: NotificationUseCase {
    private func filter(fetchingFrom notifications: [PushNotification]) -> [PushNotification]{
        return notifications.filter { notification in
            !AppStorageKey.PushNotification.allCases.description.contains { appStorageKey in
                notification.type.description == appStorageKey.description
            }
        }
    }
    
    func send(_ communityRecruitingContentId: Int64, from userId: Int64, to opponentUserId: Int64, pushNotification: PushNotification) async throws {
        try await notificationRepository.send(communityRecruitingContentId, from: userId, to: opponentUserId, pushNotification: pushNotification)
    }
    
    func fetch(userId: Int64) async throws -> [PushNotification] {
        let notifications = try await notificationRepository.fetch(userId: userId)
        return filter(fetchingFrom: notifications)
    }
    
    func remove(userId: Int64, _ notificationIds: [Int64]) async throws {
        try await notificationRepository.remove(userId: userId, notificationIds)
    }
    
    func read(userId: Int64, _ notificationIds: Int64) async throws {
        try await notificationRepository.read(userId: userId, notificationIds)
    }
}
