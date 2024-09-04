//
//  SocialLoginRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol SocialLoginRepository: TokenRefreshable {
    func login(_ credential: UserCredential, fcm: String) async -> Bool
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
    func login(_ credential: UserCredential, fcm: String) async -> Bool {
        do {
            let endpoint = Endpoint.login(token: credential.authorizationCode, provider: credential.provider.identifier, fcm: fcm)
            let response = try await networkService.request(endpoint: endpoint, for: UserRegistrationResponseEntity.self)
            
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
        let endpoint = Endpoint.register(user: entity, image: imageData, fcm: fcm, provider: provider.identifier)
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
