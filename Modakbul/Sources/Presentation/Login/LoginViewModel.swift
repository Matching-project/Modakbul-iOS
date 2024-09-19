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
    
    private var fcmToken: String?
    
    private let userIdSubject = PassthroughSubject<Int64, Never>()
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
    }
    
    func loginWithKakaoTalk(_ email: String) {
        guard let fcm = fcmToken else { return }
        
        Task {
            do {
                let userId = try await userRegistrationUseCase.kakaoLogin(email: email, fcm: fcm)
                userIdSubject.send(userId)
            } catch {
                print(error)
            }
        }
    }
    
    func loginWithApple(_ authorizationCode: Data) {
        guard let fcm = fcmToken else { return }
        
        Task {
            do {
                let userId = try await userRegistrationUseCase.appleLogin(authorizationCode: authorizationCode, fcm: fcm)
                userIdSubject.send(userId)
            } catch {
                print(error)
            }
        }
    }
    
    func logout() {
        // TODO: API 나오면 연결할 것
    }
}
