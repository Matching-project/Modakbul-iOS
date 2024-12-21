//
//  UserRegistrationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation
import Combine

protocol UserRegistrationUseCase {
    var user: AnyPublisher<User, Never> { get }
    var credential: AnyPublisher<UserCredential, Never> { get }
    var userId: AnyPublisher<Int64, Never> { get }
    var userNickname: AnyPublisher<String, Never> { get }
    
    /// 로그인
    /// - OAuth(카카오, 애플)를 통한 로그인을 지원합니다.
    func login(_ userCredential: UserCredential) async throws
    
    /// 로그아웃
    func logout(userId: Int64) async throws
    
    /// 한글, 영문, 숫자 2~15자 내 닉네임인지 검사
    func validateInLocal(_ nickname: String) -> Bool
    
    /// 서버와 통신해 비속어 필터링을 하여 중복되지 않고 유효한 닉네임인지 검사
    func validateWithServer(_ nickname: String) async throws -> NicknameIntegrityType
    
    /// 회원가입
    /// - OAuth(카카오, 애플)를 통한 회원가입을 지원합니다.
    func register(_ user: User, encoded imageData: Data?, _ userCredential: UserCredential)  async throws
    
    /// 회원탈퇴
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws
}

final class DefaultUserRegistrationUseCase {
    var user: AnyPublisher<User, Never> { socialLoginRepository.user }
    
    var credential: AnyPublisher<UserCredential, Never> { socialLoginRepository.credential }
    
    var userId: AnyPublisher<Int64, Never> { socialLoginRepository.userId }
    
    var userNickname: AnyPublisher<String, Never> { socialLoginRepository.userNickname }
    
    private let socialLoginRepository: SocialLoginRepository
    
    init(socialLoginRepository: SocialLoginRepository) {
        self.socialLoginRepository = socialLoginRepository
    }
}

// MARK: UserRegistrationUseCase Confirmation
extension DefaultUserRegistrationUseCase: UserRegistrationUseCase {
    func login(_ userCredential: UserCredential) async throws {
        switch userCredential.provider {
        case .apple:
            try await socialLoginRepository.appleLogin(userCredential)
        case .kakao:
            try await socialLoginRepository.kakaoLogin(userCredential)
        }
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
        
    func register(_ user: User, encoded imageData: Data?, _ userCredential: UserCredential) async throws {
        switch userCredential.provider {
        case .apple:
            try await socialLoginRepository.appleRegister(user, encoded: imageData, userCredential)
        case .kakao:
            try await socialLoginRepository.kakaoRegister(user, encoded: imageData, userCredential)
        }
    }
    
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws {
        try await socialLoginRepository.unregister(userId: userId, provider: provider)
    }
}
