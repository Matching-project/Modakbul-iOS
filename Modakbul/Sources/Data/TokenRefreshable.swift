//
//  TokenRefreshable.swift
//  Modakbul
//
//  Created by Swain Yun on 9/3/24.
//

import Foundation

protocol TokenRefreshable {
    var networkService: NetworkService { get }
    var tokenStorage: TokenStorage { get }
}

extension TokenRefreshable {
    func reissueTokens(userId: Int64, _ refreshToken: String) async throws -> TokensEntity {
        do {
            let endpoint = Endpoint.reissueToken(refreshToken: refreshToken)
            let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            
            guard let accessToken = response.accessToken else { throw APIError.responseError }
            
            let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
            try tokenStorage.store(tokens, by: userId)
            return tokens
        } catch APIError.refreshTokenExpired {
            // MARK: 액세스, 리프레시 토큰 둘다 만료 시 재로그인 하도록 처리
            try tokenStorage.delete(by: userId)
            UserDefaults.standard.setValue(Constants.loggedOutUserId, forKey: AppStorageKey.userId)
            throw APIError.refreshTokenExpired
        } catch {
            throw APIError.responseError
        }
    }
}
