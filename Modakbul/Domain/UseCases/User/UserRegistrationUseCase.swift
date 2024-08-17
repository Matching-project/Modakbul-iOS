//
//  UserRegistrationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserRegistrationUseCase {
    func validate(_ nickname: String) async throws -> Bool
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
    func validate(_ nickname: String) async throws -> Bool {
        return false
    }
    
    func register(_ user: User, encoded imageData: Data?) async throws {
        //
    }
    
    func login(_ token: Data, by provider: AuthenticationProvider) async -> Bool {
        await socialLoginRepository.login(token, by: provider)
    }
    
    func logout(with user: User) async {
        
    }
}
