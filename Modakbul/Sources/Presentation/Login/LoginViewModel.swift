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
    
    
    // TODO: - 물어보기
    // 카카오로그인은 서버로 토큰 줄 필요 없고,
    // 애플로그인일 때만 서버로 토큰 보내야 하지 않나?
    
    func loginWithKakaoTalk(_ token: OAuthToken) {
        Task {
            guard let token = try? JSONEncoder().encode(token) else {
                return print("카카오 로그인 실패")
            }
            
            let credential = UserCredential(authorizationCode: token, provider: .kakao)
            // TODO: 결과값 처리
            _ = await userRegistrationUseCase.login(token, by: .kakao)
        }
    }
    
    func loginWithApple(_ credential: ASAuthorizationCredential) {
        Task {
            guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential,
                  let authorizationCode = appleIDCredential.authorizationCode else {
                return print("애플 아이디로 로그인만 지원함")
            }
            
            // TODO: 결과값 처리
            _ = await userRegistrationUseCase.login(authorizationCode, by: .apple)
        }
    }
    
    func logout() {
        
    }
}