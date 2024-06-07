//
//  KakaoLoginManager.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

protocol KakaoLoginManager {
    func handleOpenUrl(url: URL)
    func login() async throws -> OAuthToken
}

final class DefaultKakaoLoginManager {
    private let kakaoAPI: UserApi
    
    init(kakaoAPI: UserApi = .shared) {
        self.kakaoAPI = kakaoAPI
        guard let appKey = Bundle.main.getAPIKey(provider: AuthenticationProvider.kakao) else { return }
        
        KakaoSDK.initSDK(appKey: appKey)
    }
}

// MARK: KakaoLoginManager Confirmation
extension DefaultKakaoLoginManager: KakaoLoginManager {
    func handleOpenUrl(url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    @MainActor
    func login() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                kakaoAPI.loginWithKakaoTalk { token, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    
                    if let token = token {
                        continuation.resume(returning: token)
                    }
                }
            } else {
                kakaoAPI.loginWithKakaoAccount { token, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    
                    if let token = token {
                        continuation.resume(returning: token)
                    }
                }
            }
        }
    }
}
