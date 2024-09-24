//
//  LoginViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/27/24.
//

import Foundation
import AuthenticationServices
import KakaoSDKAuth
import Combine

final class LoginViewModel: ObservableObject {
    @Published var userId: Int64?
    @Published var selectedProvider: AuthenticationProvider?
    @Published var email: String?
    @Published var authorizationCode: Data?
    
    private var fcmToken: String?
    
    private let userIdSubject = PassthroughSubject<Int64, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let fcmManager = FcmManager.instance
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
        subscribe()
    }
    
    private func subscribe() {
        fcmManager.$fcmToken
            .sink { [weak self] fcmToken in
                self?.fcmToken = fcmToken
            }
            .store(in: &cancellables)
        
        userIdSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userId in
                self?.userId = userId
            }
            .store(in: &cancellables)
    }
    
    func kakaoLogin(_ email: String?) {
        guard let fcm = fcmToken,
              let email = email
        else { return }
        
        self.email = email
        self.selectedProvider = .kakao
        
        Task {
            do {
                let userId = try await userRegistrationUseCase.login(.init(provider: .kakao, fcm: fcm, email: email))
                userIdSubject.send(userId)
            } catch {
                userIdSubject.send(-1)
            }
        }
    }
    
    func appleLogin(_ authorizationCode: Data?) {
        guard let fcm = fcmToken,
              let authorizationCode = authorizationCode
        else { return }
        
        self.authorizationCode = authorizationCode
        self.selectedProvider = .apple
        
        Task {
            do {
                let userId = try await userRegistrationUseCase.login(.init(provider: .apple, fcm: fcm, email: email))
                userIdSubject.send(userId)
            } catch {
                userIdSubject.send(-1)
            }
        }
    }
    
    func logout() {
        // TODO: API 나오면 연결할 것
    }
}
