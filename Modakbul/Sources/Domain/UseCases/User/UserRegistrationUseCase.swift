//
//  UserRegistrationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserRegistrationUseCase {
    /// 로그인
    func login(_ token: Data, by provider: AuthenticationProvider, fcm: String) async throws -> Bool
    
    /// 로그아웃
    func logout(userId: Int64) async
    
    /// 한글, 영문, 숫자 2~15자 내 닉네임인지 검사
    func validateInLocal(_ nickname: String) -> Bool
    
    /// 서버와 통신해 비속어 필터링을 하여 중복되지 않고 유효한 닉네임인지 검사
    func validateWithServer(_ nickname: String) async throws -> NicknameIntegrityType
    
    /// 회원가입
    func register(_ user: User, encoded imageData: Data?, provider: AuthenticationProvider, fcm: String) async throws -> Int64
    
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
    func login(_ token: Data, by provider: AuthenticationProvider, fcm: String) async throws -> Bool {
        let credential = UserCredential(authorizationCode: token, provider: provider)
        return await socialLoginRepository.login(credential, fcm: fcm)
    }
    
    func logout(userId: Int64) async {
        //
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
    
    func register(_ user: User, encoded imageData: Data?, provider: AuthenticationProvider, fcm: String) async throws -> Int64 {
        -1
    }
    
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws {
        //
    }
}
