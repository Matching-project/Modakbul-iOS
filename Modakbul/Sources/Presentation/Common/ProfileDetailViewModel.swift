//
//  ProfileDetailViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/10/24.
//

import Foundation

final class ProfileDetailViewModel: ObservableObject {
    @Published var user: User
    @Published var isBlocked: Bool
    @Published var isReported: Bool
    
    private let userBusinessUseCase: UserBusinessUseCase
    /// - WARNING: 하나의 `ProfileDetailViewModel`를 토대로 여러 사용자를 표시해야 하므로 `private` 키워드를 생략해야 합니다.
    
    init(user: User = User(),
         isBlocked: Bool = false,
         isReported: Bool = false,
         userBusinessUseCase: UserBusinessUseCase
    ) {
        self.user = user
        self.isBlocked = isBlocked
        self.isReported = isReported
        self.userBusinessUseCase = userBusinessUseCase
    }
}

// MARK: - interfaces for UserBusinessUseCase
extension ProfileDetailViewModel {
    private func fetchUser(from userId: Int64, about opponentUserId: Int64) async {
        do {
            user = try await userBusinessUseCase.readOpponentUserProfile(userId: userId, opponentUserId: opponentUserId)
        } catch {
            print(error)
        }
    }
    
    private func fetchIsBlocked(from userId: Int64, about opponentUserId: Int64) async {
        do {
            let blockedUsers = try await userBusinessUseCase.readBlockedUsers(userId: userId)
            isBlocked = blockedUsers.contains { $0.blockId == opponentUserId }
        } catch {
            print(error)
        }
    }
    
    private func fetchIsReported(from userId: Int64, about opponentUserId: Int64) async {
        do {
            let reportedUsers = try await userBusinessUseCase.readReports(userId: userId)
            isReported = reportedUsers.contains { $0.user.id == opponentUserId }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func block(userId: Int64, opponentUserId: Int64) {
        Task {
            do {
                try await userBusinessUseCase.block(userId: userId, opponentUserId: opponentUserId)
                isBlocked = true
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func unblock(userId: Int64, blockId: Int64) {
        Task {
            do {
                try await userBusinessUseCase.unblock(userId: userId, blockId: blockId)
                isBlocked = false
            } catch {
                print(error)
            }
        }
    }
}

extension ProfileDetailViewModel {
    func configureView(userId: Int64, opponentUserId: Int64) async {
        await fetchUser(from: userId, about: opponentUserId)
        await fetchIsBlocked(from: userId, about: opponentUserId)
        await fetchIsReported(from: userId, about: opponentUserId)
    }
}
