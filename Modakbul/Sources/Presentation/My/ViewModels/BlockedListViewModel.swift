//
//  BlockedListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 8/28/24.
//

import Foundation
import Combine

final class BlockedListViewModel: ObservableObject {
    @Published var blockedUsers: [(blockId: Int64, blockedUser: User)] = []
    
    private let usersSubject = PassthroughSubject<[(blockId: Int64, blockedUser: User)], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userBusinessUseCase: UserBusinessUseCase
    
    init(userBusinessUseCase: UserBusinessUseCase) {
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        usersSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.blockedUsers = users
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension BlockedListViewModel {
    func configureView(userId: Int64) async {
        do {
            let blockedUsers = try await userBusinessUseCase.readBlockedUsers(userId: userId)
            usersSubject.send(blockedUsers)
        } catch {
            print(error)
        }
    }
    
    func cancelBlock(userId: Int64, blockId: Int64) {
        Task {
            do {
                try await userBusinessUseCase.unblock(userId: userId, blockId: blockId)
            } catch {
                print(error)
            }
        }
    }
}
