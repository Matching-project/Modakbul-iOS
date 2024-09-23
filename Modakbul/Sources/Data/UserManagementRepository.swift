//
//  UserManagementRepository.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/28/24.
//

import Foundation

protocol UserManagementRepository: TokenRefreshable {
    func readMyProfile(userId: Int64) async throws -> User
    func updateProfile(user: User, image: Data?) async throws
    func report(userId: Int64, opponentUserId: Int64, report: Report) async throws
    func readReports(userId: Int64) async throws -> [(user: User, status: InquiryStatusType)]
    func block(userId: Int64, opponentUserId: Int64) async throws
    func readBlockedUsers(userId: Int64) async throws -> [(blockId: Int64, blockedUser: User)]
    func unblock(userId: Int64, blockId: Int64) async throws
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User
}

final class DefaultUserManagementRepository {
    let tokenStorage: TokenStorage
    let networkService: NetworkService
    private var user: User?
    
    init(
        tokenStorage: TokenStorage,
        networkService: NetworkService
    ) {
        self.tokenStorage = tokenStorage
        self.networkService = networkService
    }
}

// MARK: UserManagementRepository Conformation
extension DefaultUserManagementRepository: UserManagementRepository {
    func readMyProfile(userId: Int64) async throws -> User {
        // MARK: - A user 로그인 후, B user 로그인 한 경우 대비
        if let user = user, user.id == userId {
            return user
        }
        
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readMyProfile(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            let user = response.body.toDTO()
            self.user = user
            return user
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readMyProfile(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            let user = response.body.toDTO()
            self.user = user
            return user
        } catch {
            throw error
        }
    }
    
    func updateProfile(user: User, image: Data?) async throws {
        let token = try tokenStorage.fetch(by: user.id)
        let entity = UserProfileUpdateRequestEntity(nickname: user.nickname,
                                                    isGenderVisible: user.isGenderVisible,
                                                    job: user.job,
                                                    categories: user.categoriesOfInterest)
        
        do {
            let endpoint = Endpoint.updateProfile(token: token.accessToken, user: entity, image: image)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            self.user = user
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: user.id, token.refreshToken)
            
            let endpoint = Endpoint.updateProfile(token: tokens.accessToken, user: entity, image: image)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            self.user = user
        } catch {
            throw error
        }
    }
    
    func report(userId: Int64, opponentUserId: Int64, report: Report) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.reportOpponentUserProfile(token: token.accessToken, userId: opponentUserId, report: report)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.reportOpponentUserProfile(token: tokens.accessToken, userId: opponentUserId, report: report)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readReports(userId: Int64) async throws -> [(user: User, status: InquiryStatusType)] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readReports(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: ReportsResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readReports(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: ReportsResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func block(userId: Int64, opponentUserId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.block(token: token.accessToken, opponentUserId: opponentUserId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.block(token: tokens.accessToken, opponentUserId: opponentUserId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readBlockedUsers(userId: Int64) async throws -> [(blockId: Int64, blockedUser: User)] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readBlockedUsers(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: BlockedUsersResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readBlockedUsers(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: BlockedUsersResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func unblock(userId: Int64, blockId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.unblock(token: token.accessToken, blockId: blockId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.unblock(token: tokens.accessToken, blockId: blockId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readOpponentUserProfile(token: token.accessToken, userId: opponentUserId)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readOpponentUserProfile(token: tokens.accessToken, userId: opponentUserId)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
}
