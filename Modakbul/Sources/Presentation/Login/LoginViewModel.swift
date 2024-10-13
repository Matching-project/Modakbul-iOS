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
    
    private func login(provider: AuthenticationProvider, email: String? = nil, authorizationCode: Data? = nil, _ completion: @escaping (Int64, String) -> Void) {
        guard let fcm = fcmToken else { return }
        
        Task {
            let userCredential = UserCredential(provider: provider, fcm: fcm, email: email, authorizationCode: authorizationCode)
            self.userCredential = userCredential
            
            do {
                let userId = try await userRegistrationUseCase.login(userCredential)
                let userNickname = try await userBusinessUseCase.readMyProfile(userId: userId).nickname
                completion(userId, userNickname)
            } catch {
                completion(Int64(Constants.loggedOutUserId), "닉네임 없음")
            }
        }
    }
    
    func kakaoLogin(_ email: String?, _ completion: @escaping (Int64, String) -> Void) {
        guard let email = email else { return }
        
        login(provider: .kakao, email: email, completion)
    }
    
    func appleLogin(_ authorizationCode: Data?, _ completion: @escaping (Int64, String) -> Void) {
        guard let authorizationCode = authorizationCode else { return }
        
        login(provider: .apple, authorizationCode: authorizationCode, completion)
    }
}
