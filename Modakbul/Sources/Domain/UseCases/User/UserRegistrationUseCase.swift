//
//  UserRegistrationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserRegistrationUseCase {
    /// 한글, 영문, 숫자 2~15자 내 닉네임인지 검사합니다.
    func validateInLocal(_ nickname: String) -> Bool
    /// 서버와 통신해 비속어 필터링을 하여 중복되지 않고 유효한 닉네임인지 검사합니다.
    func validateWithServer(_ nickname: String) async throws -> Bool
    func register(_ user: User, encoded imageData: Data?) async throws
    func login(_ token: Data, by provider: AuthenticationProvider) async -> Bool
    func logout(with user: User) async
}

final class DefaultUserRegistrationUseCase {
    private let socialLoginRepository: SocialLoginRepository
    
    init(socialLoginRepository: SocialLoginRepository) {
        self.socialLoginRepository = socialLoginRepository
    }
}

// MARK: UserRegistrationUseCase Confirmation
extension DefaultUserRegistrationUseCase: UserRegistrationUseCase {
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
    
    func validateWithServer(_ nickname: String) async throws -> Bool {
        return false
    }
    
    func register(_ user: User, encoded imageData: Data?) async throws {
        //
    }
    
    func login(_ token: Data, by provider: AuthenticationProvider) async -> Bool {
        await socialLoginRepository.login(UserCredential(authorizationCode: token, provider: provider))
    }
    
    func logout(with user: User) async {
        
    }
}
