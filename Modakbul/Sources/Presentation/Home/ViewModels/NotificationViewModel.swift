//
//  NotificationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/16/24.
//

import SwiftUI
import Combine

final class NotificationViewModel: ObservableObject {
    @Published var notifications: [PushNotification] = []
    @Published var multiSelection = Set<Int64>()
    @Published var performedNotificationIndex: Int?
    
    private let notificationUseCase: NotificationUseCase
    
    private let notificationPerformSubject = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(notificationUseCase: NotificationUseCase) {
        self.notificationUseCase = notificationUseCase
        subscribe()
    }
    
    private func subscribe() {
        notificationPerformSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.notifications[index].isRead = true
            }
            .store(in: &cancellables)
    }
    
    func readNotification(userId: Int64,_ notification: PushNotification) {
        guard let index = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        readNotification(userId: userId, notification.id, index: index)
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
    
    func removeAllNotifications(userId: Int64) {
        removeNotifications(userId: userId, notifications.map { $0.id })
        notifications.removeAll()
    }
}

// MARK: - Interfaces for NotificationUseCase
extension NotificationViewModel {
    private func removeNotifications(userId: Int64, _ notificationIds: [Int64]) {
        // TODO: 알림 삭제 전 읽음 처리
        Task {
            do {
                try await notificationUseCase.remove(userId: userId, notificationIds)
            } catch {
                print(error)
            }
        }
    }
    
    private func readNotification(userId: Int64,_ notificationId: Int64, index: Int) {
        Task {
            do {
                try await notificationUseCase.read(userId: userId, notificationId)
                notificationPerformSubject.send(index)
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
