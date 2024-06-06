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
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk() async throws -> OAuthToken
}
