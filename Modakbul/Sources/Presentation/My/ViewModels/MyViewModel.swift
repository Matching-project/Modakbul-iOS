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
