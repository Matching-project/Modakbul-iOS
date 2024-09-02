//
//  NotificationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/16/24.
//

import SwiftUI

final class NotificationViewModel: ObservableObject {
    // TODO: - UseCase 연결 필요
    //    private let notificationUseCase: NotificationUseCase
    
    @Published var notifications: [PushNotification] = PreviewHelper.shared.notifications
    @Published var multiSelection = Set<UUID>()
    
    func deleteNotification(_ notification: PushNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications.remove(at: index)
        }
    }
    
    func deleteSelectedNotifications() {
        notifications.removeAll { notification in
            multiSelection.contains(notification.id)
        }
        
        multiSelection.removeAll()
    }
    
    func deleteAllNotifications() {
        notifications.removeAll()
    }
}
