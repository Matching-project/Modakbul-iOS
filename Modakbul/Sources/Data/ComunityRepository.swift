//
//  ComunityRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 9/4/24.
//

import Foundation

protocol CommunityRepository: TokenRefreshable {
    func createCommunityRecruitingContent(userId: Int64, placeId: Int64, _ content: CommunityRecruitingContent) async throws
    func readCommunityRecruitingContents(userId: Int64, placeId: Int64) async throws -> [CommunityRecruitingContent]
    func readCommunityRecruitingContent(userId: Int64, with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent
    func updateCommunityRecruitingContent(userId: Int64, _ content: CommunityRecruitingContent) async throws
    func deleteCommunityRecruitingContent(userId: Int64, _ communityRecruitingContentId: Int64) async throws
    func readCommunityRecruitingContentDetail(with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent
    func completeCommunityRecruiting(userId: Int64, with communityRecruitingContentId: Int64) async throws
    func readMyCommunityRecruitingContents(userId: Int64) async throws -> [CommunityRelationship]
}

final class DefaultCommunityRepository {
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

// MARK: CommunityRepository Conformation
extension DefaultCommunityRepository: CommunityRepository {
    func createCommunityRecruitingContent(userId: Int64, placeId: Int64, _ content: CommunityRecruitingContent) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let entity = CommunityRecruitingContentEntity(content)
            let endpoint = Endpoint.createBoard(token: token.accessToken, placeId: placeId, communityRecruitingContent: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let entity = CommunityRecruitingContentEntity(content)
            let endpoint = Endpoint.createBoard(token: tokens.accessToken, placeId: placeId, communityRecruitingContent: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readCommunityRecruitingContents(userId: Int64, placeId: Int64) async throws -> [CommunityRecruitingContent] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readBoards(token: token.accessToken, placeId: placeId)
            let response = try await networkService.request(endpoint: endpoint, for: CommunityRecruitingContentListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readBoards(token: tokens.accessToken, placeId: placeId)
            let response = try await networkService.request(endpoint: endpoint, for: CommunityRecruitingContentListResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func readCommunityRecruitingContent(userId: Int64, with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readBoardForUpdate(token: token.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: CommunityRecruitingContentSearchResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readBoardForUpdate(token: tokens.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: CommunityRecruitingContentSearchResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func updateCommunityRecruitingContent(userId: Int64, _ content: CommunityRecruitingContent) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let entity = CommunityRecruitingContentEntity(content)
            let endpoint = Endpoint.updateBoard(token: token.accessToken, communityRecruitingContent: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let entity = CommunityRecruitingContentEntity(content)
            let endpoint = Endpoint.updateBoard(token: tokens.accessToken, communityRecruitingContent: entity)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func deleteCommunityRecruitingContent(userId: Int64, _ communityRecruitingContentId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.deleteBoard(token: token.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.deleteBoard(token: tokens.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readCommunityRecruitingContentDetail(with communityRecruitingContentId: Int64) async throws -> CommunityRecruitingContent {
        let endpoint = Endpoint.readBoardDetail(communityRecruitingContentId: communityRecruitingContentId)
        let response = try await networkService.request(endpoint: endpoint, for: CommunityRecruitingContentSearchDetailResponseEntity.self)
        return response.body.toDTO()
    }
    
    func completeCommunityRecruiting(userId: Int64, with communityRecruitingContentId: Int64) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.completeBoard(token: token.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.completeBoard(token: tokens.accessToken, communityRecruitingContentId: communityRecruitingContentId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readMyCommunityRecruitingContents(userId: Int64) async throws -> [CommunityRelationship] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readMyBoards(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedCommunityRecruitingContentListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readMyBoards(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: RelatedCommunityRecruitingContentListResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
}
