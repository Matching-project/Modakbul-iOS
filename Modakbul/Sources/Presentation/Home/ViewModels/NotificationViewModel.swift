//
//  NotificationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/16/24.
//

import SwiftUI

final class NotificationViewModel: ObservableObject {
    @Published var notifications: [PushNotification] = []
    @Published var multiSelection = Set<Int>()
    private let notificationUseCase: NotificationUseCase
    
    init(notificationUseCase: NotificationUseCase) {
        self.notificationUseCase = notificationUseCase
    }
    
    func readNotification(_ notification: PushNotification) {
        if notifications.firstIndex(where: { $0.id == notification.id }) != nil {
            readNotification(notification.id)
        }
    }
    
    func removeSwipedNotification(_ notification: PushNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            removeNotifications([notification.id])
            notifications.remove(at: index)
        }
    }
    
    func removeSelectedNotifications() {
        notifications.removeAll { notification in
            multiSelection.contains(notification.id)
        }
        
        removeNotifications(Array(multiSelection))
        multiSelection.removeAll()
    }
    
    @MainActor func removeAllNotifications() {
        removeNotifications(notifications.map { $0.id })
        notifications.removeAll()
    }
}

// MARK: - Interface for NotificationUseCase
extension NotificationViewModel {
    private func removeNotifications(_ notificationIds: [Int]) {
        Task {
            do {
                try await notificationUseCase.remove(notificationIds)
            } catch {
                print(error)
            }
        }
    }
    
    private func readNotification(_ notificationIds: Int) {
        Task {
            do {
                try await notificationUseCase.read(notificationIds)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func fetchNotifications() {
        Task {
            do {
                try await notifications = notificationUseCase.fetch()
            } catch {
                print(error)
            }
        }
    }
}
