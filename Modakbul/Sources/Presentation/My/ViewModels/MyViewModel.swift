//
//  MyViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation

final class MyViewModel: ObservableObject {
    @Published var user: User
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    // TODO: - User() 대신 userId에 따라 회원정보 불러오는 처리 필요
    init(user: User = User(),
         userRegistrationUseCase: UserRegistrationUseCase
    ) {
        self.user = user
        self.userRegistrationUseCase = userRegistrationUseCase
    }
}

// MARK: - Interfaces for userRegistrationUseCase
extension MyViewModel {
    @MainActor
    func logout(userId: Int64) {
        Task {
            do {
                try await userRegistrationUseCase.logout(userId: userId)
            } catch {
                print(error)
            }
        }
    }
}
