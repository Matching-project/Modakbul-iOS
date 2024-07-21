//
//  UserBusinessUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserBusinessUseCase {
    func updateProfile(user: User) async throws
    func report(reported: User, reporter: User, type: ReportType) async throws
    func block(blocked: User, blocker: User) async throws -> String
    func fetchBlockedUsers(by user: User) async throws -> [BlockedUser]
    func unblock(blocked: User, blocker: User) async throws
    func unregister(by user: User) async throws
    
    // TODO: Work in progress
    /// 문의하기
    func contact()
}
