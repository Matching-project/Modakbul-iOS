//
//  SocialLoginRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol SocialLoginRepository: TokenRefreshable {
    func kakaoLogin(email: String, fcm: String) async throws -> Int64
    func appleLogin(authorizationCode: Data, fcm: String) async throws -> Int64
    func logout() async
    
    func validateNicknameIntegrity(_ nickname: String) async throws -> NicknameIntegrityType
    
    func register(_ user: User, encoded imageData: Data?, fcm: String, provider: AuthenticationProvider) async throws -> Int64
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws
}

fileprivate enum SocialLoginRepositoryError: Error {
    case authorizeFailed
}

final class DefaultSocialLoginRepository {
    let tokenStorage: TokenStorage
    let networkService: NetworkService
    
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
    func kakaoLogin(email: String, fcm: String) async throws -> Int64 {
        let entity = KakaoLoginRequestEntity(email: email, fcm: fcm)
        let endpoint = Endpoint.kakaoLogin(entity: entity, provider: .kakao)
        let response = try await networkService.request(endpoint: endpoint, for: UserRegistrationResponseEntity.self)
        let userId = response.body.toDTO()
        
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken
        else {
            throw SocialLoginRepositoryError.authorizeFailed
        }
        
        let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
        try tokenStorage.store(tokens, by: userId)
        return userId
    }
    
    func appleLogin(authorizationCode: Data, fcm: String) async throws -> Int64 {
        let entity = AppleLoginRequestEntity(authorizationCode: authorizationCode, fcm: fcm)
        let endpoint = Endpoint.appleLogin(entity: entity, provider: .apple)
        let response = try await networkService.request(endpoint: endpoint, for: UserRegistrationResponseEntity.self)
        let userId = response.body.toDTO()
        
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken
        else {
            throw SocialLoginRepositoryError.authorizeFailed
        }
        
        let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
        try tokenStorage.store(tokens, by: userId)
        return userId
    }
    
    func logout() async {
        
    }
    
    func validateNicknameIntegrity(_ nickname: String) async throws -> NicknameIntegrityType {
        let endpoint = Endpoint.validateNicknameIntegrity(nickname: nickname)
        let response = try await networkService.request(endpoint: endpoint, for: NicknameIntergrityResponseEntity.self)
        return response.body.toDTO()
    }
    
    func register(_ user: User, encoded imageData: Data?, fcm: String, provider: AuthenticationProvider) async throws -> Int64 {
        let entity = UserRegistrationRequestEntity(name: user.name,
                                                   nickname: user.nickname,
                                                   birth: user.birth.toString(by: .yyyyMMdd),
                                                   gender: user.gender,
                                                   job: user.job,
                                                   categories: user.categoriesOfInterest)
        let endpoint = Endpoint.register(user: entity, image: imageData, provider: provider.identifier, fcm: fcm)
        let response = try await networkService.request(endpoint: endpoint, for: UserRegistrationResponseEntity.self)
        return response.body.toDTO()
    }
    
    // TODO: 회원탈퇴 WIP
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws {
//        let token = try tokenStorage.fetch(by: userId)
//
//        do {
//            let endpoint = Endpoint
//        } catch APIError.accessTokenExpired {
//
//        } catch {
//            throw error
//        }
    }
}
