//
//  ChatRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

protocol ChatRepository: TokenRefreshable {
    typealias ChatRoomId = Int64
    typealias UserId = Int64
    typealias CommunityRecruitingContentId = Int64

    func startChat(on chatRoomId: ChatRoomId, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) async throws
    func stopChat(on chatRoomId: ChatRoomId, messages: [ChatMessage])
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration]
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId
    func deleteChat(userId: UserId, on chatRoomId: ChatRoomId) async throws
    func readChatingHistory(userId: UserId, on chatRoomId: ChatRoomId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatHistory
    func send(message: ChatMessage) throws
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws
}

final class DefaultChatRepository {
    private let chatService: ChatService
    let networkService: NetworkService
    let tokenStorage: TokenStorage
//    private let chattingStorage:
    
    init(
        chatService: ChatService,
        networkService: NetworkService,
        tokenStorage: TokenStorage
    ) {
//        self.chatService = chatService
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
}

// MARK: ChatRepository Conformation
extension DefaultChatRepository: ChatRepository {
    func startChat(on chatRoomId: ChatRoomId, _ continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation) async throws {
        <#code#>
    }
    
    func stopChat(on chatRoomId: ChatRoomId, messages: [ChatMessage]) {
        <#code#>
    }
    
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readChatrooms(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: ChatRoomListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readChatrooms(token: tokens.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: ChatRoomListResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let entity = ChatRoomConfigurationRequestEntity(communityRecruitingContentId: communityRecruitingContentId, opponentUserId: opponentUserId)
            let endpoint = Endpoint.createChatRoom(token: token.accessToken, configuration: entity)
            let response = try await networkService.request(endpoint: endpoint, for: ChatRoomConfigurationResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let entity = ChatRoomConfigurationRequestEntity(communityRecruitingContentId: communityRecruitingContentId, opponentUserId: opponentUserId)
            let endpoint = Endpoint.createChatRoom(token: tokens.accessToken, configuration: entity)
            let response = try await networkService.request(endpoint: endpoint, for: ChatRoomConfigurationResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func deleteChat(userId: UserId, on chatRoomId: ChatRoomId) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.exitChatRoom(token: token.accessToken, chatRoomId: chatRoomId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.exitChatRoom(token: tokens.accessToken, chatRoomId: chatRoomId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func readChatingHistory(userId: UserId, on chatRoomId: ChatRoomId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatHistory {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readChatHistory(token: token.accessToken, chatRoomId: chatRoomId, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: ChatHistoryResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.readChatHistory(token: tokens.accessToken, chatRoomId: chatRoomId, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: ChatHistoryResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func send(message: ChatMessage) throws {
        <#code#>
    }
    
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.reportAndExitChatRoom(token: token.accessToken, chatRoomId: chatRoomId, userId: opponentUserId, report: report)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(key: userId, token.refreshToken)
            
            let endpoint = Endpoint.reportAndExitChatRoom(token: tokens.accessToken, chatRoomId: chatRoomId, userId: opponentUserId, report: report)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
}
