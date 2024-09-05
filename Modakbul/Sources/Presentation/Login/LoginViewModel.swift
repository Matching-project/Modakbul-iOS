//
//  LoginViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/27/24.
//

import Foundation
import AuthenticationServices
import KakaoSDKAuth

final class LoginViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
    func loginWithKakaoTalk(_ token: OAuthToken, fcm: String) {
        Task {
            do {
                let token = try JSONEncoder().encode(token)
                let credential = UserCredential(authorizationCode: token, provider: .kakao)
                _ = try await userRegistrationUseCase.login(token, by: .kakao, fcm: fcm)
            } catch {
                
            }
            
            
        }
    }
    
    func loginWithApple(_ credential: ASAuthorizationCredential, fcm: String) {
        Task {
            guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential,
                  let authorizationCode = appleIDCredential.authorizationCode else {
                return print("애플 아이디로 로그인만 지원함")
            }
            
            do {
                _ = try await userRegistrationUseCase.login(authorizationCode, by: .apple, fcm: fcm)
            } catch {
                
            }
        }
    }
    
    func logout() {
        
    }
}
