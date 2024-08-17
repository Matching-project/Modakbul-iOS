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
    
    func loginWithKakaoTalk(_ token: OAuthToken) {
        Task {
            guard let token = try? JSONEncoder().encode(token) else {
                return print("카카오 로그인 실패")
            }
            // TODO: 결과값 처리
            _ = await userRegistrationUseCase.login(token, by: .kakao)
        }
    }
    
    func loginWithApple(_ credential: ASAuthorizationCredential) {
        Task {
            guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential,
                  let token = appleIDCredential.identityToken
            else {
                return print("애플 아이디로 로그인만 지원함")
            }
            // TODO: 결과값 처리
            _ = await userRegistrationUseCase.login(token, by: .apple)
        }
    }
    
    func logout() {
        Task {
            let user = User(name: "", nickname: "", email: "", provider: .kakao, gender: .male, job: .jobSeeker, categoriesOfInterest: [], isGenderVisible: true, birth: .now, imageURL: nil)
            await userRegistrationUseCase.logout(with: user)
        }
    }
}
