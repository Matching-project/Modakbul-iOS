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
    @Published var userNickname: String?
    @Published var userCredential: UserCredential?
    
    private var fcmToken: String?
    
    /// 유저 아이디와 유저 닉네임을 의미합니다.
    private let userSubject = PassthroughSubject<(Int64, String), Never>()
    private let userCredentialSubject = PassthroughSubject<UserCredential?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let userBusinessUseCase: UserBusinessUseCase
    private let fcmManager = FcmManager.instance
    
    init(userRegistrationUseCase: UserRegistrationUseCase,
         userBusinessUseCase: UserBusinessUseCase
    ) {
        self.userRegistrationUseCase = userRegistrationUseCase
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        fcmManager.$fcmToken
            .sink { [weak self] fcmToken in
                self?.fcmToken = fcmToken
            }
            .store(in: &cancellables)
        
        userSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (userId, userNickname) in
                self?.userNickname = userNickname
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
        
        let userCredential = UserCredential(provider: provider, fcm: fcm, email: email, authorizationCode: authorizationCode)
        
        userCredentialSubject.send(userCredential)
        
        Task {
            do {
                let userId = try await userRegistrationUseCase.login(userCredential)
                let userNickname = try await userBusinessUseCase.readMyProfile(userId: userId).nickname

                userSubject.send((userId, userNickname))
            } catch {
                userSubject.send((Int64(Constants.loggedOutUserId), "닉네임 없음"))
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
