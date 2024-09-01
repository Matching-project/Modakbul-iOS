//
//  UserBusinessUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserBusinessUseCase {
    func updateProfile(user: User, image: Data?) async throws
    func report(userId: Int64, _ content: Report) async throws
    func block(blocked: User, blocker: User) async throws
    func fetchBlockedUsers(by user: User) async throws -> [BlockedUser]
    func unblock(blocked: User, blocker: User) async throws
    func unregister(by user: User) async throws
    
    // TODO: Work in progress
    /// 문의하기
//    func contact()
}

final class DefaultUserBusinessUseCase {
    private let userManagementRepository: UserManagementRepository
    
    init(userManagementRepository: UserManagementRepository) {
        self.userManagementRepository = userManagementRepository
    }
}

// MARK: UserBusinessUseCase Conformation
extension DefaultUserBusinessUseCase: UserBusinessUseCase {
    func updateProfile(user: User, image: Data?) async throws {
        <#code#>
    }
    
    func report(userId: Int64, _ content: Report) async throws {
        <#code#>
    }
    
    func block(blocked: User, blocker: User) async throws {
        <#code#>
    }
    
    func fetchBlockedUsers(by user: User) async throws -> [BlockedUser] {
        <#code#>
    }
    
    func unblock(blocked: User, blocker: User) async throws {
        <#code#>
    }
    
    func unregister(by user: User) async throws {
        <#code#>
    }
}
