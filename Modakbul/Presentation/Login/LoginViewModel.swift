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
    
    func loginWithKakaoTalk(_ kakaoUser: KakaoUser) {
        Task {
            guard let token = try? JSONEncoder().encode(token) else {
                return print("카카오 로그인 실패")
            }
            guard let id = kakaoUser.id else {
                return print("카카오 CI 존재하지 않음")
            }
            
            let credential = UserCredential(id: String(id), email: email, provider: .kakao)
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
            if let familyName = appleIDCredential.fullName?.familyName,
               let givenName = appleIDCredential.fullName?.givenName,
               let email = appleIDCredential.email {
                // MARK: - 최초 로그인시
                let credential = UserCredential(id: appleIDCredential.user,
                                                familyName: familyName,
                                                givenName: givenName,
                                                email: email,
                                                authorizationCode: authorizationCode,
                                                provider: .apple)
                
                _ = await userRegistrationUseCase.login(credential)
            } else {
                // MARK: - 재로그인시
                let credential = UserCredential(id: appleIDCredential.user,
                                                authorizationCode: authorizationCode,
                                                provider: .apple)
                
                _ = await userRegistrationUseCase.login(credential)
            }
        }
    }
    
    func logout() {
        
    }
}
