//
//  NotificationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/16/24.
//

import SwiftUI
import Combine

final class NotificationViewModel: ObservableObject {
    // TODO: - UseCase 연결 필요
    //    private let notificationUseCase: NotificationUseCase
    
    @Published var notifications: [PushNotification] = []
    @Published var multiSelection = Set<UUID>()
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationManager.shared.$notifications
            .assign(to: \.notifications, on: self)
    }
    
    func deleteSwipedNotification(_ notification: PushNotification) {
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
