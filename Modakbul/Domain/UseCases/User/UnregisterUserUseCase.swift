//
//  UnregisterUserUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol UnregisterUserUseCase {
    func unregister(id userId: String) async throws
}
