//
//  UserBusinessUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserBusinessUseCase {
    func fetchUserInfo() async throws -> User
    func updateProfile(user: User) async throws
    func report(id reportedId: String, by reporterId: String, type: ReportType) async throws
    func block(id blockedId: String, by blockerId: String) async throws -> String
    func fetchBlockedUsers(by userId: String) async throws -> [BlockedUser]
    func unblock(id blockedId: String, by blockerId: String) async throws
    func unregister(id userId: String) async throws
    
    // TODO: Work in progress
    /// 문의하기
    func contact()
}
