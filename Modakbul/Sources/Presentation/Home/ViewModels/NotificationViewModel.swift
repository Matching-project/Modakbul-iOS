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
    private func removeNotifications(_ notificationIds: [Int64]) {
        Task {
            do {
                try await notificationUseCase.remove(userId: <#인트64#>, notificationIds)
            } catch {
                print(error)
            }
        }
    }
    
    private func readNotification(_ notificationId: Int64) {
        Task {
            do {
                try await notificationUseCase.read(userId: <#T##Int64#>, notificationId)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func fetchNotifications() {
        Task {
            do {
                try await notifications = notificationUseCase.fetch(userId: <#T##Int64#>)
            } catch {
                print(error)
            }
        }
    }
}
