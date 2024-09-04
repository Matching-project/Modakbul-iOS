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
    func reissueTokens(key: Int64, _ refreshToken: String) async throws -> TokensEntity {
        let endpoint = Endpoint.reissueToken(refreshToken: refreshToken)
        let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken
        else { throw APIError.responseError }
        
        let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
        try tokenStorage.store(tokens, by: key)
        return tokens
    }
}
