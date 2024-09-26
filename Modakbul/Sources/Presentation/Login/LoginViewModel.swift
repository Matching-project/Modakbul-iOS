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
    @Published var userCredential: UserCredential?
    
    private var fcmToken: String?
    
    private let userIdSubject = PassthroughSubject<Int64, Never>()
    private let userCredentialSubject = PassthroughSubject<UserCredential?, Never>()
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
        
        userCredentialSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] credential in
                self?.userCredential = credential
            }
            .store(in: &cancellables)
    }
    
    private func login(provider: AuthenticationProvider, email: String? = nil, authorizationCode: Data? = nil) {
        guard let fcm = fcmToken else { return }
        
        Task {
            do {
                let userCredential = UserCredential(provider: provider, fcm: fcm, email: email, authorizationCode: authorizationCode)
                let userId = try await userRegistrationUseCase.login(userCredential)
                userIdSubject.send(userId)
                userCredentialSubject.send(userCredential)
            } catch {
                userIdSubject.send(Int64(Constants.loggedOutUserId))
                userCredentialSubject.send(nil)
            }
        }
    }
    
    func kakaoLogin(_ email: String?) {
        guard let email = email else { return }
        
        login(provider: .kakao, email: email)
    }
    
    func appleLogin(_ authorizationCode: Data?) {
        guard let authorizationCode = authorizationCode else { return }
        
        login(provider: .apple, authorizationCode: authorizationCode)
    }
}
