//
//  NotificationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/20/24.
//

import Foundation

protocol NotificationUseCase {
    func fetchNotifications() async -> [PushNotification]
    func fetchNotificationsCount() async -> Int
}
