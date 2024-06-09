//
//  SocialLoginRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol SocialLoginRepository {
    func onOpenURL(url: URL)
    func login(with provider: AuthenticationProvider) async throws -> User
}

fileprivate enum SocialLoginRepositoryError: Error {
    case authorizeFailed
    case authorizeCancelled
}

final class DefaultSocialLoginRepository {
    private let tokenStorage: TokenStorage
    private let authorizationService: AuthorizationService
    private let networkService: NetworkService
    
    init(
        tokenStorage: TokenStorage,
        authorizationService: AuthorizationService,
        networkService: NetworkService
    ) {
        self.tokenStorage = tokenStorage
        self.authorizationService = authorizationService
        self.networkService = networkService
    }
}

// MARK: SocialLoginRepository Confirmation
extension DefaultSocialLoginRepository: SocialLoginRepository {
    func onOpenURL(url: URL) {
        authorizationService.handleOpenURL(url: url)
    }
    
    func login(with provider: AuthenticationProvider) async throws -> User {
        do {
            let (accessToken, refreshToken) = try await authorizationService.authorize(with: provider)
            let endpoint = Endpoint.socialLogin(accessToken: accessToken, refreshToken: refreshToken)
            let user = try await networkService.request(endpoint: endpoint, for: UserDTO.self).toDTO(provider: provider)
            await tokenStorage.storeToken(id: user.id, tokens: (accessToken, refreshToken))
            return user
        } catch {
            throw error
        }
    }
}
