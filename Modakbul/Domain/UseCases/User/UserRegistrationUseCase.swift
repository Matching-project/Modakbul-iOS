//
//  UserRegistrationUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 7/18/24.
//

import Foundation

protocol UserRegistrationUseCase {
    func validate(_ nickname: String) async throws -> Bool
    func register(_ user: User, encoded imageData: String) async throws
    func onOpenURL(url: URL)
    func login(with provider: AuthenticationProvider) async throws -> User
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
        <#code#>
    }
    
    func register(_ user: User, encoded imageData: String) async throws {
        <#code#>
    }
    
    func onOpenURL(url: URL) {
        socialLoginRepository.onOpenURL(url: url)
    }
    
    func login(with provider: AuthenticationProvider) async throws -> User {
        try await socialLoginRepository.login(with: provider)
    }
    
    func logout(with user: User) async {
        
    }
}
