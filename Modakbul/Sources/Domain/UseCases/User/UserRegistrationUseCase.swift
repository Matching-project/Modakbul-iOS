//
//  UserRegistrationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserRegistrationUseCase {
    /// 카카오로 로그인
    func kakaoLogin(email: String, fcm: String) async throws -> Int64
    
    /// 애플로 로그인
    func appleLogin(authorizationCode: Data, fcm: String) async throws -> Int64
    
    /// 로그아웃
    func logout(userId: Int64) async throws
    
    /// 한글, 영문, 숫자 2~15자 내 닉네임인지 검사
    func validateInLocal(_ nickname: String) -> Bool
    
    /// 서버와 통신해 비속어 필터링을 하여 중복되지 않고 유효한 닉네임인지 검사
    func validateWithServer(_ nickname: String) async throws -> NicknameIntegrityType
    
    /// 카카오로 회원가입
    func kakaoRegister(_ user: User, encoded imageData: Data?, email: String, fcm: String, provider: AuthenticationProvider) async throws -> Int64
    
    /// 애플로 회원가입
    func appleRegister(_ user: User, encoded imageData: Data?, authorizationCode: Data, fcm: String, provider: AuthenticationProvider) async throws -> Int64
    
    /// 회원탈퇴
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws
}

final class DefaultUserRegistrationUseCase {
    private let socialLoginRepository: SocialLoginRepository
    
    init(socialLoginRepository: SocialLoginRepository) {
        self.socialLoginRepository = socialLoginRepository
    }
}

// MARK: UserRegistrationUseCase Confirmation
extension DefaultUserRegistrationUseCase: UserRegistrationUseCase {
    func kakaoLogin(email: String, fcm: String) async throws -> Int64 {
        try await socialLoginRepository.kakaoLogin(email: email, fcm: fcm)
    }
    
    func appleLogin(authorizationCode: Data, fcm: String) async throws -> Int64 {
        try await socialLoginRepository.appleLogin(authorizationCode: authorizationCode, fcm: fcm)
    }
    
    func logout(userId: Int64) async throws {
        try await socialLoginRepository.logout(userId: userId)
    }
    
    func validateInLocal(_ nickname: String) -> Bool {
        let nicknamePattern = "^[가-힣a-zA-Z0-9]+$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknamePattern)
        
        guard nicknamePredicate.evaluate(with: nickname) else {
            return false
        }
        
        guard 2 <= nickname.count && nickname.count <= 15 else {
            return false
        }
        
        return true
    }
    
    func validateWithServer(_ nickname: String) async throws -> NicknameIntegrityType {
        try await socialLoginRepository.validateNicknameIntegrity(nickname)
    }
    
    func kakaoRegister(_ user: User, encoded imageData: Data?, email: String, fcm: String, provider: AuthenticationProvider) async throws -> Int64 {
        try await socialLoginRepository.kakaoRegister(user, encoded: imageData, email: email, fcm: fcm, provider: provider)
    }
    
    func appleRegister(_ user: User, encoded imageData: Data?, authorizationCode: Data, fcm: String, provider: AuthenticationProvider) async throws -> Int64 {
        try await socialLoginRepository.appleRegister(user, encoded: imageData, authorizationCode: authorizationCode, fcm: fcm, provider: provider)
    }
    
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws {
        //
    }
}
