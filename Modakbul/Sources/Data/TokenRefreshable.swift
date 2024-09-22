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
            try tokenStorage.delete(by: userId)
            throw APIError.refreshTokenExpired
        } catch {
            throw APIError.responseError
        }
    }
}
