//
//  ProfileDetailViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/10/24.
//

import Foundation
import Combine

final class ProfileDetailViewModel: ObservableObject {
    @Published var presentedUser: User?
    @Published var isBlocked: Bool = false
    @Published var isReported: Bool = false
    
    private var blockId: Int64?
    
    private let userSubject = PassthroughSubject<User?, Never>()
    private let blocksSubject = PassthroughSubject<[(blockId: Int64, blockedUser: User)], Never>()
    private let reportSubject = PassthroughSubject<[(user: User, status: InquiryStatusType)], Never>()
    private let blockPerformSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userBusinessUseCase: UserBusinessUseCase
    /// - WARNING: 하나의 `ProfileDetailViewModel`를 토대로 여러 사용자를 표시해야 하므로 `private` 키워드를 생략해야 합니다.
    
    init(userBusinessUseCase: UserBusinessUseCase) {
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        userSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.presentedUser = user
            }
            .store(in: &cancellables)
        
        blocksSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] blocks in
                guard let index = blocks.firstIndex(where: { $0.blockedUser.id == self?.presentedUser?.id }) else {
                    self?.blockPerformSubject.send(false)
                    self?.blockId = nil
                    return
                }
                let (blockId, _) = (blocks[index].blockId, blocks[index].blockedUser)
                self?.blockPerformSubject.send(true)
                self?.blockId = blockId
            }
            .store(in: &cancellables)
        
        reportSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] report in
                self?.isReported = report.contains(where: { $0.user.id == self?.presentedUser?.id })
            }
            .store(in: &cancellables)
        
        blockPerformSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isBlocked = result
            }
            .store(in: &cancellables)
    }
}

// MARK: - interfaces for UserBusinessUseCase
extension ProfileDetailViewModel {
    private func fetchUser(from userId: Int64, about opponentUserId: Int64) async {
        do {
            let user = try await userBusinessUseCase.readOpponentUserProfile(userId: userId, opponentUserId: opponentUserId)
            userSubject.send(user)
        } catch {
            userSubject.send(nil)
            print(error)
        }
    }
    
    private func fetchIsBlocked(from userId: Int64, about opponentUserId: Int64) async {
        do {
            let blockedUsers = try await userBusinessUseCase.readBlockedUsers(userId: userId)
            blocksSubject.send(blockedUsers)
        } catch {
            blocksSubject.send([])
            print(error)
        }
    }
    
    private func fetchIsReported(from userId: Int64, about opponentUserId: Int64) async {
        do {
            let reportedUsers = try await userBusinessUseCase.readReports(userId: userId)
            reportSubject.send(reportedUsers)
        } catch {
            reportSubject.send([])
            print(error)
        }
    }
    
    @MainActor
    func block(userId: Int64, opponentUserId: Int64) {
        Task {
            do {
                try await userBusinessUseCase.block(userId: userId, opponentUserId: opponentUserId)
                blockPerformSubject.send(true)
                await fetchIsBlocked(from: userId, about: opponentUserId)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func unblock(userId: Int64) {
        guard let blockId = blockId else { return }
        
        Task {
            do {
                try await userBusinessUseCase.unblock(userId: userId, blockId: blockId)
                blockPerformSubject.send(false)
                await fetchIsBlocked(from: userId, about: userId)
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
