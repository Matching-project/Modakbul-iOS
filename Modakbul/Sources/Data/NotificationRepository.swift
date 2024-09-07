//
//  NotificationRepository.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/7/24.
//

import Foundation

protocol NotificationRepository: TokenRefreshable {
    func send(_ notificiation: PushNotification, from userId: Int64, to opponentUserId: Int64) async throws
    func fetch(userId: Int64) async throws -> [PushNotification]
    func remove(userId: Int64, _ notificationIds: [Int64]) async throws
    func read(userId: Int64, _ notificationIds: Int64) async throws
}

final class DefaultNotificationRepository {
    let tokenStorage: TokenStorage
    let networkService: NetworkService
    
    init(
        tokenStorage: TokenStorage,
        networkService: NetworkService
    ) {
        self.tokenStorage = tokenStorage
        self.networkService = networkService
    }
}

extension DefaultNotificationRepository: NotificationRepository {
    func send(_ notificiation: PushNotification, from userId: Int64, to opponentUserId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        let entity = NotificationSendingRequestEntity(type: notificiation.type.description,
                                                      subtitle: notificiation.subtitle,
                                                      opponentUserId: opponentUserId)
        
        do {
            let endpoint = Endpoint.sendNotification(token: token.accessToken, notification: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.sendNotification(token: token.accessToken, notification: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func fetch(userId: Int64) async throws -> [PushNotification] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.fetchNotifications(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: NotificationResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.fetchNotifications(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: NotificationResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func remove(userId: Int64, _ notificationIds: [Int64]) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.removeNotifications(token: token.accessToken, notificationsIds: notificationIds)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.removeNotifications(token: token.accessToken, notificationsIds: notificationIds)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func read(userId: Int64, _ notificationId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readNotification(token: token.accessToken, notificationId: notificationId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readNotification(token: token.accessToken, notificationId: notificationId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
        
    }
    
}
