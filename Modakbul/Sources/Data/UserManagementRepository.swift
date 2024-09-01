//
//  UserManagementRepository.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/28/24.
//

import Foundation

protocol UserManagementRepository {
    func updateProfile(user: User, image: Data?) async throws
    func report(userId: Int64, _ content: Report) async throws
    func block(blocked: User, blocker: User) async throws
    func fetchBlockedUsers(by user: User) async throws -> [BlockedUser]
    func unblock(blocked: User, blocker: User) async throws
    func unregister(by user: User) async throws
}

final class DefaultUserManagementRepository {
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
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
    func updateProfile(user: User, image: Data?) async throws {
        let token = try tokenStorage.fetch(by: user.id)
        let entity = UserProfileUpdateRequestEntity(nickname: user.nickname,
                                                    isGenderVisible: user.isGenderVisible,
                                                    job: user.job,
                                                    categories: user.categoriesOfInterest)
        let endpoint = Endpoint.updateProfile(token: token.accessToken, user: entity, image: image)
        let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        
        // 응답코드 2401: 액세스토큰 만료
        if response.body.code == 2401 {
            let endpoint = Endpoint.updateProfile(token: token.refreshToken, user: entity, image: image)
            _ = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        }
    }
    
    func report(userId: Int64, _ content: Report) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
    }
    
    func block(blocked: User, blocker: User) async throws {
        //
    }
    
    func fetchBlockedUsers(by user: User) async throws -> [BlockedUser] {
        []
    }
    
    func unblock(blocked: User, blocker: User) async throws {
        //
    }
    
    func unregister(by user: User) async throws {
        //
    }
}
