//
//  SocialLoginRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation
import Combine

protocol SocialLoginRepository: TokenRefreshable {
    var user: AnyPublisher<User?, Never> { get }
    var credential: AnyPublisher<UserCredential, Never> { get }
    var userId: AnyPublisher<Int64, Never> { get }
    var userNickname: AnyPublisher<String, Never> { get }
    
    func kakaoLogin(_ userCredential: UserCredential) async throws
    func appleLogin(_ userCredential: UserCredential) async throws
    func logout(userId: Int64) async throws
    
    func validateNicknameIntegrity(_ nickname: String) async throws -> NicknameIntegrityType
    
    func kakaoRegister(_ user: User, encoded imageData: Data?, _ userCredential: UserCredential) async throws
    func appleRegister(_ user: User, encoded imageData: Data?, _ userCredential: UserCredential) async throws
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws
}

enum SocialLoginRepositoryError: Error {
    case authorizeFailed
}

final class DefaultSocialLoginRepository {
    private let userSubject = CurrentValueSubject<User?, Never>(nil)
    private let credentialSubject = CurrentValueSubject<UserCredential?, Never>(nil)
    private let userIdSubject = CurrentValueSubject<Int64?, Never>(nil)
    private let userNicknameSubject = CurrentValueSubject<String?, Never>(nil)
    
    var user: AnyPublisher<User?, Never> {
        userSubject
            .eraseToAnyPublisher()
    }
    
    var credential: AnyPublisher<UserCredential, Never> {
        credentialSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    var userId: AnyPublisher<Int64, Never> {
        userIdSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    var userNickname: AnyPublisher<String, Never> {
        userNicknameSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
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
    func kakaoLogin(_ userCredential: UserCredential) async throws {
        let entity = KakaoLoginRequestEntity(email: userCredential.email!, fcm: userCredential.fcm!)
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
        userIdSubject.send(userId)
    }
    
    func appleLogin(_ userCredential: UserCredential) async throws {
        let entity = AppleLoginRequestEntity(appleCI: userCredential.appleCI!, fcm: userCredential.fcm!)
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
        userIdSubject.send(userId)
    }
    
    func logout(userId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.logout(token: token.accessToken)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            UserDefaults.standard.setValue(Constants.loggedOutUserId, forKey: AppStorageKey.userId)
            try tokenStorage.delete(by: userId)
            userSubject.send(nil)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            let endpoint = Endpoint.logout(token: tokens.accessToken)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            UserDefaults.standard.setValue(Constants.loggedOutUserId, forKey: AppStorageKey.userId)
            try tokenStorage.delete(by: userId)
            userSubject.send(nil)
        } catch {
            throw error
        }
    }
    
    func validateNicknameIntegrity(_ nickname: String) async throws -> NicknameIntegrityType {
        let endpoint = Endpoint.validateNicknameIntegrity(nickname: nickname)
        let response = try await networkService.request(endpoint: endpoint, for: NicknameIntergrityResponseEntity.self)
        return response.body.toDTO()
    }
    
    func kakaoRegister(_ user: User, encoded imageData: Data?, _ userCredential: UserCredential) async throws {
        let entity = await KakaoUserRegistrationRequestEntity(user, email: userCredential.email!, fcm: userCredential.fcm!)
        let endpoint = Endpoint.kakaoRegister(user: entity, image: imageData, provider: .kakao)
        let response = try await networkService.request(endpoint: endpoint, for: UserRegistrationResponseEntity.self)
        let userId = response.body.toDTO()
        
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken
        else {
            throw SocialLoginRepositoryError.authorizeFailed
        }
        
        let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
        try tokenStorage.store(tokens, by: userId)
        
        userIdSubject.send(userId)
    }
    
    func appleRegister(_ user: User, encoded imageData: Data?, _ userCredential: UserCredential) async throws {
        let entity = await AppleUserRegistrationRequestEntity(user, authorizationCode: userCredential.authorizationCode!, fcm: userCredential.fcm!)
        let endpoint = Endpoint.appleRegister(user: entity, image: imageData, provider: .apple)
        let response = try await networkService.request(endpoint: endpoint, for: UserRegistrationResponseEntity.self)
        let userId = response.body.toDTO()
        
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken
        else {
            throw SocialLoginRepositoryError.authorizeFailed
        }
        
        let tokens = TokensEntity(accessToken: accessToken, refreshToken: refreshToken)
        try tokenStorage.store(tokens, by: userId)
        
        userIdSubject.send(userId)
    }
    
    func unregister(userId: Int64, provider: AuthenticationProvider) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.unregister(token: token.accessToken, provider: provider)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            UserDefaults.standard.setValue(Constants.loggedOutUserId, forKey: AppStorageKey.userId)
            try tokenStorage.delete(by: userId)
            userIdSubject.send(nil)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            let endpoint = Endpoint.logout(token: tokens.accessToken)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            UserDefaults.standard.setValue(Constants.loggedOutUserId, forKey: AppStorageKey.userId)
            try tokenStorage.delete(by: userId)
            userIdSubject.send(nil)
        } catch {
            throw error
        }
    }
}
