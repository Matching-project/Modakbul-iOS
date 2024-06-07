//
//  AuthorizationService.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol AuthorizationService {
    func handleOpenURL(url: URL)
    func authorize(with provider: AuthenticationProvider) async throws -> (accessToken: String, refreshToken: String)
}

final class DefaultAuthorizationService {
    private let kakaoLoginManager: KakaoLoginManager
//    private let appleLoginManager:
    
    init(kakaoLoginManager: KakaoLoginManager) {
        self.kakaoLoginManager = kakaoLoginManager
    }
}

// MARK: AuthorizationService Confirmation
extension DefaultAuthorizationService: AuthorizationService {
    func handleOpenURL(url: URL) {
        kakaoLoginManager.handleOpenUrl(url: url)
    }
    
    func authorize(with provider: AuthenticationProvider) async throws -> (accessToken: String, refreshToken: String) {
        switch provider {
        case .apple:
            return ("", "")
            
        case .kakao:
            print("인증서비스 접근")
            let oAuthToken = try await kakaoLoginManager.login()
            print(oAuthToken)
            return (oAuthToken.accessToken, oAuthToken.refreshToken)
        }
    }
}
