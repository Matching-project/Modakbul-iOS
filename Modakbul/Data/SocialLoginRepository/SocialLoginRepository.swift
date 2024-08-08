//
//  SocialLoginRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol SocialLoginRepository {
    func login(_ token: Data, by provider: AuthenticationProvider) async -> Bool
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
    func login(_ token: Data, by provider: AuthenticationProvider) async -> Bool {
        true
    }
    
    func logout() async {
        
    }
}
