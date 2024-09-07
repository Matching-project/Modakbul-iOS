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
    ///   - notificiation: 보낼 알림을 의미합니다.
    ///   - userId: 나의 아이디를 의미합니다.
    ///   - opponentUserId: 상대방의 아이디를 의미합니다.
    func send(_ notificiation: PushNotification, from userId: Int64, to opponentUserId: Int64) async throws
    
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
    
    private let r: NotificationRepository
    
    init(r: NotificationRepository) {
        self.r = r
    }
}

extension DefaultNotificationUseCase: NotificationUseCase {
    func send(_ notificiation: PushNotification, from userId: Int64, to opponentUserId: Int64) async throws {
        try await r.send(notificiation, from: userId, to: opponentUserId)
    }
    
    func fetch(userId: Int64) async throws -> [PushNotification] {
        return try await r.fetch(userId: userId)
    }
    
    func remove(userId: Int64, _ notificationIds: [Int64]) async throws {
        try await r.remove(userId: userId, notificationIds)
    }
    
    func read(userId: Int64, _ notificationIds: Int64) async throws {
        try await r.read(userId: userId, notificationIds)
    }
}
