//
//  BlockUserUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol BlockUserUseCase {
    func block(id blockedId: String, by blockerId: String) async throws -> String
}
