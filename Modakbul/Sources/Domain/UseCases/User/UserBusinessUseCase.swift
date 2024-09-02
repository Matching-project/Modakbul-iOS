//
//  UserBusinessUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserBusinessUseCase {
    /// 사용자 프로필 수정
    func updateProfile(user: User, image: Data?) async throws
    
    /// 사용자 프로필 조회
    func readMyProfile(userId: Int64) async throws
    
    /// 사용자(상대방) 차단
    func block(userId: Int64, opponentUserId: Int64) async throws
    
    /// 사용자(상대방) 차단 해제
    func unblock(blocked: User, blocker: User) async throws
    
    /// 차단한 사용자 목록 조회
    func readBlockedUsers(by user: User) async throws -> [BlockedUser]
    
    /// 신고 목록 조회
    func readReports(userId: Int64) async throws -> [(user: User, status: InquiryStatusType)]
    
    /// 사용자(상대방) 프로필 조회
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User
    
    /// 사용자(상대방) 프로필 신고
    func report(userId: Int64, opponentUserId: Int64, report: Report) async throws
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
    
    func readMyProfile(userId: Int64) async throws {
        <#code#>
    }
    
    func block(userId: Int64, opponentUserId: Int64) async throws {
        <#code#>
    }
    
    func unblock(blocked: User, blocker: User) async throws {
        <#code#>
    }
    
    func readBlockedUsers(by user: User) async throws -> [BlockedUser] {
        <#code#>
    }
    
    func readReports(userId: Int64) async throws -> [(user: User, status: InquiryStatusType)] {
        <#code#>
    }
    
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User {
        <#code#>
    }
    
    func report(userId: Int64, opponentUserId: Int64, report: Report) async throws {
        <#code#>
    }
}
