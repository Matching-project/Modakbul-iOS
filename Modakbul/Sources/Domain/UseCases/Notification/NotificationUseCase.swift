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
    ///   - userId: 보낼 상대방의 아이디를 의미합니다.
    func send(_ notificiation: PushNotification, from userId: Int64, to opponentUserId: Int64) async throws
    
    /// 알림 목록을 조회합니다.
    /// - Returns: 1개 이상의 알림 배열입니다.
    func fetch(userId: Int64) async throws -> [PushNotification]

    /// 1개 이상의 알림을 삭제합니다.
    /// - Parameter ids: 삭제할 알림의 아이디입니다.
    func remove(userId: Int64, _ notificatioIds: Int64...) async throws
    
    /// 알림을 읽음처리 합니다.
    /// - Parameter id: 읽음 처리할 알림 아이디입니다.
    func read(userId: Int64, _ notificatioIds: Int64) async throws
}

final class DefaultNotificationUseCase {
    
//    private let repo...
}

extension DefaultNotificationUseCase: NotificationUseCase {
    func send(_ notificiation: PushNotification, to userId: Int64) async throws {
        
    }
    
    func fetch() async throws -> [PushNotification] {
        
    }
    
    func fetchUnreadCount() async throws -> Int {

    }
    
    func remove(_ notificationIds: [Int]) async throws {
        
    }
    
    func read(_ notificationIds: Int) async throws {
        
    }
}
