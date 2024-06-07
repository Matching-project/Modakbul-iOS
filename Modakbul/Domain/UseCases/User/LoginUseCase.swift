//
//  LoginUseCase.swift
//  Modakbul
//
//  Created by Swain Yun on 6/2/24.
//

import Foundation

protocol LoginUseCase {
    func onOpenURL(url: URL)
    func login(with provider: AuthenticationProvider) async throws -> User
}

final class DefaultLoginUseCase {
    private let socialLoginRepository: SocialLoginRepository
    
    init(socialLoginRepository: SocialLoginRepository) {
        self.socialLoginRepository = socialLoginRepository
    }
}

// MARK: LoginUseCase Confirmation
extension DefaultLoginUseCase: LoginUseCase {
    func onOpenURL(url: URL) {
        socialLoginRepository.onOpenURL(url: url)
    }
    
    func login(with provider: AuthenticationProvider) async throws -> User {
        try await socialLoginRepository.login(with: provider)
    }
}
