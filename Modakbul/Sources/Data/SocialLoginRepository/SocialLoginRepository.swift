//
//  SocialLoginRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol SocialLoginRepository {
    func login(_ credential: UserCredential) async -> Bool
    func logout() async
}

fileprivate enum SocialLoginRepositoryError: Error {
    case authorizeFailed
}

final class DefaultSocialLoginRepository {
    private let tokenStorage: TokenStorage
    private let networkService: NetworkService
    
    init(
        tokenStorage: TokenStorage,
        networkService: NetworkService
    ) {
        self.tokenStorage = tokenStorage
        self.networkService = networkService
    }
}

// MARK: SocialLoginRepository Conformation
extension DefaultSocialLoginRepository: SocialLoginRepository {
    func login(_ credential: UserCredential) async -> Bool {
        do {
            let endpoint = Endpoint.login(token: credential.authorizationCode, provider: credential.provider.identifier)
            let response = try await networkService.request(endpoint: endpoint, for: UserAuthenticationResponseEntity.self)
            
            guard let accessToken = response.accessToken,
                  let refreshToken = response.refreshToken
            else { return false }
            
            let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
            try tokenStorage.store(tokens, by: response.body.result.userId)
            return true
        } catch {
            // TODO: 에러 핸들링 필요
            print(error)
            return false
        }
    }
    
    func logout() async {
        
    }
}
