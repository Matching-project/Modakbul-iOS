//
//  NotificationManager.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/3/24.
//

import Foundation

final class NotificationManager {
    @Published var notifications: [PushNotification] = [] {
        didSet {
            lastNotification = notifications.isEmpty ? nil : notifications[notifications.endIndex - 1]
        }
    }
    
    @Published var lastNotification: PushNotification?
    static let shared = NotificationManager()
    
    private init() {}
}
