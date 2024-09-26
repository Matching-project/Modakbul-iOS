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
    
    private let providerSubject = PassthroughSubject<AuthenticationProvider?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
        subscribe()
    }
    
    private func subscribe() {
        providerSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] provider in
                self?.provider = provider
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func unregister(for userId: Int64) {
        guard let provider = provider else { return }
        
        Task {
            do {
                try await userRegistrationUseCase.unregister(userId: userId, provider: provider)
                providerSubject.send(nil)
            } catch {
                print(error)
            }
        }
    }
}
