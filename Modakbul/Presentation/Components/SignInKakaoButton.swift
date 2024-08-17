//
//  SignInKakaoButton.swift
//  Modakbul
//
//  Created by Swain Yun on 7/28/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

protocol KakaoAuthService {
    func handleOpenUrl(url: URL)
    func login(_ completion: @escaping (Result<OAuthToken, Error>) -> Void)
    func logout() async throws
}

typealias KakaoUser = KakaoSDKUser.User

final class DefaultKakaoAuthService {
    private let kakaoAPI: UserApi
    
    init(kakaoAPI: UserApi = .shared) {
        self.kakaoAPI = kakaoAPI
        guard let appKey = Bundle.main.getAPIKey(provider: AuthenticationProvider.kakao) else { return }
        
        KakaoSDK.initSDK(appKey: appKey)
    }
    
    private func _login(_ token: OAuthToken?, _ error: Error?, _ completion: @escaping (Result<OAuthToken, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        }
        
        if let token = token {
            completion(.success(token))
        }
    }
}

// MARK: KakaoAuthService Conformation
extension DefaultKakaoAuthService: KakaoAuthService {
    func handleOpenUrl(url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    func login(_ completion: @escaping (Result<OAuthToken, Error>) -> Void) {
        let nonce = UUID().uuidString
        
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoAPI.loginWithKakaoTalk(nonce: nonce) { [weak self] token, error in
                self?._login(token, error, completion)
            }
        } else {
            kakaoAPI.loginWithKakaoAccount(nonce: nonce) { [weak self] token, error in
                self?._login(token, error, completion)
            }
        }
    }
    
    func logout() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            kakaoAPI.logout { error in
                guard let error = error else { return continuation.resume() }
                continuation.resume(throwing: error)
            }
        }
    }
}

struct SignInKakaoButton: View {
    private let kakaoAuthService: KakaoAuthService
    private let handler: (Result<OAuthToken, Error>) -> Void
    
    init(
        kakaoAuthService: KakaoAuthService = DefaultKakaoAuthService(),
        onCompletion: @escaping (Result<OAuthToken, Error>) -> Void
    ) {
        self.kakaoAuthService = kakaoAuthService
        self.handler = onCompletion
    }
    
    var body: some View {
        Button {
            kakaoAuthService.login(handler)
        } label: {
            Image("KakaoLoginButtonImage")
                .resizable()
                .scaledToFit()
        }
        .onOpenURL { url in
            kakaoAuthService.handleOpenUrl(url: url)
        }
    }
}
