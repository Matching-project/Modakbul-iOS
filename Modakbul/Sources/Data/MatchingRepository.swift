//
//  MatchingRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 9/4/24.
//

import Foundation

protocol MatchingRepository: TokenRefreshable {
    func readMatches(userId: Int64, with communityRecruitingContentId: Int64) async throws -> [ParticipationRequest]
    func requestMatch(userId: Int64, with communityRecruitingContentId: Int64) async throws
    func acceptMatchRequest(userId: Int64, with matchingId: Int64) async throws
    func rejectMatchRequest(userId: Int64, with matchingId: Int64) async throws
    func exitMatch(userId: Int64, with matchingId: Int64) async throws
    func cancelMatchRequest(userId: Int64, with matchingId: Int64) async throws
    func readMyMatches(userId: Int64) async throws -> [CommunityRelationship]
    func readMyRequestMatches(userId: Int64) async throws -> [(relationship: CommunityRelationship, matchingId: Int64, matchState: MatchState)]
}

final class DefaultMatchingRepository {
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

// MARK: MatchingRepository Conformation
extension DefaultMatchingRepository: MatchingRepository {
    func readMatches(userId: Int64, with communityRecruitingContentId: Int64) async throws -> [ParticipationRequest] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readMatches(token: token.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: ParticipationRequestListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readMatches(token: tokens.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: ParticipationRequestListResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func requestMatch(userId: Int64, with communityRecruitingContentId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.requestMatch(token: token.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.requestMatch(token: tokens.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func acceptMatchRequest(userId: Int64, with matchingId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.acceptMatchRequest(token: token.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.acceptMatchRequest(token: tokens.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func rejectMatchRequest(userId: Int64, with matchingId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.rejectMatchRequest(token: token.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.rejectMatchRequest(token: tokens.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func exitMatch(userId: Int64, with matchingId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.exitMatch(token: token.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.exitMatch(token: tokens.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func cancelMatchRequest(userId: Int64, with matchingId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.cancelMatchRequest(token: token.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.cancelMatchRequest(token: tokens.accessToken, matchingId: matchingId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readMyMatches(userId: Int64) async throws -> [CommunityRelationship] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readMyMatches(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedCommunityListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readMyMatches(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedCommunityListResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func readMyRequestMatches(userId: Int64) async throws -> [(relationship: CommunityRelationship, matchingId: Int64, matchState: MatchState)] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readMyRequestMatches(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedParticipationRequestListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readMyRequestMatches(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedParticipationRequestListResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
}
