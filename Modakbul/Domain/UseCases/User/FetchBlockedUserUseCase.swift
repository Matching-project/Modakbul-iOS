//
//  FetchBlockedUserUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol FetchBlockedUserUseCase {
    func fetchBlockedUsers(by userId: String) async throws -> [BlockedUser]
}
