//
//  MyViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 9/9/24.
//

import Foundation
import Combine

final class MyViewModel: ObservableObject {
    @Published var user: User?
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let userBusinessUseCase: UserBusinessUseCase
    
    private let userSubject = PassthroughSubject<User?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userRegistrationUseCase: UserRegistrationUseCase,
        userBusinessUseCase: UserBusinessUseCase
    ) {
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
        
        userRegistrationUseCase.user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
        
        userBusinessUseCase.user
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
                try await userBusinessUseCase.readMyProfile(userId: userId)
            } catch {
                print(error)
            }
        }
    }
}
