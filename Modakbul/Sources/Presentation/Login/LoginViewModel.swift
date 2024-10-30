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
    var userCredential: UserCredential?
    
    private var fcmToken: String?
    
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
    }
    
    private func login(
        provider: AuthenticationProvider,
        email: String?,
        appleCI: String?,
        authorizationCode: Data?,
        _ completion: @escaping (Result<(Int64, String), APIError>) -> Void
    ) {
        guard let fcm = fcmToken else { return }
        
        Task {
            let userCredential = UserCredential(provider: provider, fcm: fcm, email: email, appleCI: appleCI, authorizationCode: authorizationCode)
            self.userCredential = userCredential
            
            do {
                let userId = try await userRegistrationUseCase.login(userCredential)
                let userNickname = try await userBusinessUseCase.readMyProfile(userId: userId).nickname
                completion(.success((userId, userNickname)))
            } catch APIError.userNotExist {
                completion(.failure(.userNotExist))
            } catch {
                completion(.failure(.serverError))
            }
        }
    }
    
    func kakaoLogin(_ email: String?, _ completion: @escaping (Result<(Int64, String), APIError>) -> Void) {
        guard let email = email else { return }
        
        login(provider: .kakao, email: email, appleCI: nil, authorizationCode: nil, completion)
    }
    
    func appleLogin(_ auth: ASAuthorization, _ completion: @escaping (Result<(Int64, String), APIError>) -> Void) {
        guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = appleIDCredential.authorizationCode else {
            return print("애플 아이디로 로그인만 지원함")
        }
        
        let appleCI = appleIDCredential.user
        
        login(provider: .apple, email: nil, appleCI: appleCI, authorizationCode: authorizationCode, completion)
    }
}
