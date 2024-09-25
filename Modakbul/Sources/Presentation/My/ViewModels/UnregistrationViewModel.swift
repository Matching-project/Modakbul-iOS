//
//  UnregistrationViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/25/24.
//

import Foundation
import Combine

final class UnregistrationViewModel: ObservableObject {
    @Published var provider: AuthenticationProvider?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
        subscribe()
    }
    
    private func subscribe() {
        $provider
            .receive(on: DispatchQueue.main)
            .sink { [weak self] provider in
                self?.provider = provider
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func unregister(for userId: Int64, as provider: AuthenticationProvider) {
        Task {
            do {
                try await userRegistrationUseCase.unregister(userId: userId, provider: provider)
                self.provider = nil
            } catch {
                print(error)
            }
        }
    }
}
