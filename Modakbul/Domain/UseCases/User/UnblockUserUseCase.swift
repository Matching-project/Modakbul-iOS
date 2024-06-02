//
//  UnblockUserUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol UnblockUserUseCase {
    func unblock(id blockedId: String, by blockerId: String) async throws
}
