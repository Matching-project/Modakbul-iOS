//
//  ContentViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 12/18/24.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var user: User = User()
    
    private let userBusinessUseCase: UserBusinessUseCase
    
    private let userSubject = PassthroughSubject<User, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(userBusinessUseCase: UserBusinessUseCase) {
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

extension ContentViewModel {
    // 서버에서 토큰 만료 여부 체크 후 로그인 여부
    // TODO: - 원한다면 로그아웃 상태 확인 후 자동으로 로그인 요청 하는 방향도 존재
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
