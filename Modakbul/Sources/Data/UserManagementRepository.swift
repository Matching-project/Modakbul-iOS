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
    func readBlockedUsers(userId: Int64) async throws -> [User]
    func unblock(userId: Int64, opponentUserId: Int64) async throws
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User
}

final class DefaultUserManagementRepository {
    let networkService: NetworkService
    let tokenStorage: TokenStorage
    
    init(
        networkService: NetworkService,
        tokenStorage: TokenStorage
    ) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
}

// MARK: UserManagementRepository Conformation
extension DefaultUserManagementRepository: UserManagementRepository {
    func readMyProfile(userId: Int64) async throws -> User {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readMyProfile(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readMyProfile(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            return response.body.toDTO()
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
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: user.id, token.refreshToken)
            
            let endpoint = Endpoint.updateProfile(token: tokens.accessToken, user: entity, image: image)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
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
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
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
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readReports(token: token.accessToken)
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
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.block(token: tokens.accessToken, opponentUserId: opponentUserId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readBlockedUsers(userId: Int64) async throws -> [User] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readBlockedUsers(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: BlockedUsersResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readBlockedUsers(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: BlockedUsersResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func unblock(userId: Int64, opponentUserId: Int64) async throws {
//        let token = tokenStorage.fetch(by: userId)
//        
//        do {
//            // TODO: 차단 해제를 위해서는 차단ID가 필요한데, 차단ID를 구할 곳이 없음
//            let endpoint = Endpoint.blo
//            let endpoint = Endpoint.unblock(token: token.accessToken, blockId: oppo)
//        } catch APIError.accessTokenExpired {
//            
//        } catch {
//            throws error
//        }
    }
    
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readOpponentUserProfile(token: token.accessToken, userId: opponentUserId)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readOpponentUserProfile(token: tokens.accessToken, userId: opponentUserId)
            let response = try await networkService.request(endpoint: endpoint, for: UserProfileResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
}
