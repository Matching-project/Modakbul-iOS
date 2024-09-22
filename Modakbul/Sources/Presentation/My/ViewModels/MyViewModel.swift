//
//  MyViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation
import Combine

final class MyViewModel: ObservableObject {
    @Published var user: User
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let userBusinessUseCase: UserBusinessUseCase
    
    private let userSubject = PassthroughSubject<User, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        user: User = User(),
        userRegistrationUseCase: UserRegistrationUseCase,
        userBusinessUseCase: UserBusinessUseCase
    ) {
        self.user = user
        self.userRegistrationUseCase = userRegistrationUseCase
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        userSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
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

// MARK: - Interfaces for userBusinessUseCase
extension MyViewModel {
    @MainActor
    func readMyProfile(_ userId: Int64) {
        Task {
            do {
                let user = try await userBusinessUseCase.readMyProfile(userId: userId)
                userSubject.send(user)
            } catch {
                print(error)
            }
        }
    }
}
