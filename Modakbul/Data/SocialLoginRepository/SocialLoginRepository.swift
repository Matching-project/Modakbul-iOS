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

// MARK: SocialLoginRepository Conformation
extension DefaultSocialLoginRepository: SocialLoginRepository {
    func onOpenURL(url: URL) {
        authorizationService.handleOpenURL(url: url)
    }
    
    func login(with provider: AuthenticationProvider) async throws -> User {
        do {
            // TODO: 소셜 로그인 전에 TokenStorage에서 토큰 정보 확인. 이 때, user.id가 필요한데 막상 로그인 전까지 user.id를 모름
            let (accessToken, refreshToken) = try await authorizationService.authorize(with: provider)
            let endpoint = Endpoint.socialLogin(accessToken: accessToken, refreshToken: refreshToken)
            let user = try await networkService.request(endpoint: endpoint, for: UserDTO.self).toDTO(provider: provider)
            let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
            try tokenStorage.store(tokens, by: user.id)
            return user
        } catch {
            throw error
        }
    }
}
