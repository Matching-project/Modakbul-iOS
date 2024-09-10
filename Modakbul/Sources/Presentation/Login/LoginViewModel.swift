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
    private var fcmToken: String?
    
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
    }
    
    func loginWithKakaoTalk(_ token: OAuthToken) {
        guard let fcm = fcmToken else { return }
        
        Task {
            do {
                let token = try JSONEncoder().encode(token)
                let credential = UserCredential(authorizationCode: token, provider: .kakao)
                // TODO: 로그인 이후 로직 처리
                _ = try await userRegistrationUseCase.login(token, by: .kakao, fcm: fcm)
            } catch {
                
            }
        }
    }
    
    func loginWithApple(_ credential: ASAuthorizationCredential) {
        guard let fcm = fcmToken else { return }
        
        Task {
            guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential,
                  let authorizationCode = appleIDCredential.authorizationCode else {
                return print("애플 아이디로 로그인만 지원함")
            }
            
            do {
                // TODO: 로그인 이후 로직 처리
                _ = try await userRegistrationUseCase.login(authorizationCode, by: .apple, fcm: fcm)
            } catch {
                
            }
        }
    }
    
    func logout() {
        
    }
}
