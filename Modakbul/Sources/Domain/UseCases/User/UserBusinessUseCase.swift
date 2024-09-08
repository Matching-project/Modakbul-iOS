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
    func readMyProfile(userId: Int64) async throws -> User
    
    /// 사용자(상대방) 차단
    func block(userId: Int64, opponentUserId: Int64) async throws
    
    /// 사용자(상대방) 차단 해제
    func unblock(userId: Int64, blockId: Int64) async throws
    
    /// 차단한 사용자 목록 조회
    func readBlockedUsers(userId: Int64) async throws -> [(blockId: Int64, blockedUser: User)]
    
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
        try await userManagementRepository.updateProfile(user: user, image: image)
    }
    
    func readMyProfile(userId: Int64) async throws -> User {
        try await userManagementRepository.readMyProfile(userId: userId)
    }
    
    func block(userId: Int64, opponentUserId: Int64) async throws {
        try await userManagementRepository.block(userId: userId, opponentUserId: opponentUserId)
    }
    
    func unblock(userId: Int64, blockId: Int64) async throws {
        try await userManagementRepository.unblock(userId: userId, blockId: blockId)
    }
    
    func readBlockedUsers(userId: Int64) async throws -> [(blockId: Int64, blockedUser: User)] {
        try await userManagementRepository.readBlockedUsers(userId: userId)
    }
    
    func readReports(userId: Int64) async throws -> [(user: User, status: InquiryStatusType)] {
        try await userManagementRepository.readReports(userId: userId)
    }
    
    func readOpponentUserProfile(userId: Int64, opponentUserId: Int64) async throws -> User {
        try await userManagementRepository.readOpponentUserProfile(userId: userId, opponentUserId: opponentUserId)
    }
    
    func report(userId: Int64, opponentUserId: Int64, report: Report) async throws {
        try await userManagementRepository.report(userId: userId, opponentUserId: opponentUserId, report: report)
    }
}
