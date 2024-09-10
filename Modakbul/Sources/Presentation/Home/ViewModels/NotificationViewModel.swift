//
//  NotificationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/16/24.
//

import SwiftUI

final class NotificationViewModel: ObservableObject {
    @Published var notifications: [PushNotification] = []
    @Published var multiSelection = Set<Int64>()
    private let notificationUseCase: NotificationUseCase
    
    init(notificationUseCase: NotificationUseCase) {
        self.notificationUseCase = notificationUseCase
    }
    
    func readNotification(userId: Int64,_ notification: PushNotification) {
        if notifications.firstIndex(where: { $0.id == notification.id }) != nil {
            readNotification(userId: userId, notification.id)
        }
    }
    
    func removeSwipedNotification(userId: Int64,_ notification: PushNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            removeNotifications(userId: userId, [notification.id])
            notifications.remove(at: index)
        }
    }
    
    func removeSelectedNotifications(userId: Int64) {
        notifications.removeAll { notification in
            multiSelection.contains(notification.id)
        }
        
        removeNotifications(userId: userId, Array(multiSelection))
        multiSelection.removeAll()
    }
    
    @MainActor func removeAllNotifications(userId: Int64) {
        removeNotifications(userId: userId, notifications.map { $0.id })
        notifications.removeAll()
    }
}

// MARK: - Interfaces for NotificationUseCase
extension NotificationViewModel {
    private func removeNotifications(userId: Int64, _ notificationIds: [Int64]) {
        Task {
            do {
                try await notificationUseCase.remove(userId: userId, notificationIds)
            } catch {
                print(error)
            }
        }
    }
    
    private func readNotification(userId: Int64,_ notificationId: Int64) {
        Task {
            do {
                try await notificationUseCase.read(userId: userId, notificationId)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func fetchNotifications(userId: Int64) {
        Task {
            do {
                try await notifications = notificationUseCase.fetch(userId: userId)
            } catch {
                print(error)
            }
        }
    }
}
