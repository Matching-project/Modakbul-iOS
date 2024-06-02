//
//  LoginUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

// TODO: 문서 읽고 정리 다시 해야함
protocol LoginUseCase {
    func login(with token: String) async throws
}
