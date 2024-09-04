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
    @Published var multiSelection = Set<Int>()
    private var cancellable: AnyCancellable?
    
    init() {
        // TODO: - API call 통해 기존 알림 목록 조회 후 알림 수신 필요
        cancellable = NotificationManager.shared.$notifications
            .assign(to: \.notifications, on: self)
    }
    
    func deleteSwipedNotification(_ notification: PushNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications.remove(at: index)
        }
    }
    
    func deleteSelectedNotifications() {
        // TODO: - 삭제할 알림 API call 필요
        
        notifications.removeAll { notification in
            multiSelection.contains(notification.id)
        }
        
        multiSelection.removeAll()
    }
    
    func deleteAllNotifications() {
        notifications.removeAll()
    }
}
