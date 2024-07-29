//
//  LoginViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 7/27/24.
//

import Foundation
import AuthenticationServices
import KakaoSDKUser

final class LoginViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
    func loginWithKakaoTalk(_ kakaoUser: KakaoUser) {
        Task {
            guard let email = kakaoUser.kakaoAccount?.email else {
                return print("동의항목 문제일 가능성 높음")
            }
            let credential = UserCredential(email: email, provider: .kakao)
            // TODO: 결과값 처리
            _ = await userRegistrationUseCase.login(credential)
        }
    }
    
    func loginWithApple(_ credential: ASAuthorizationCredential) {
        Task {
            guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential,
                  let familyName = appleIDCredential.fullName?.familyName,
                  let givenName = appleIDCredential.fullName?.givenName,
                  let email = appleIDCredential.email
            else {
                return print("애플 아이디로 로그인만 지원함")
            }
            
            let credential = UserCredential(familyName: familyName, givenName: givenName, email: email, provider: .apple)
            // TODO: 결과값 처리
            _ = await userRegistrationUseCase.login(credential)
        }
    }
    
    func logout() {
        Task {
            let user = User(name: "", nickname: "", email: "", provider: .kakao, gender: .male, job: .jobSeeker, categoriesOfInterest: [], isGenderVisible: true, birth: .now, imageURL: nil)
            await userRegistrationUseCase.logout(with: user)
        }
    }
}
