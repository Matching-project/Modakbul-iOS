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

    func startChat(userId: Int64, userNickname nickname: String, on chatRoomId: ChatRoomId, _ continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation) async throws
    func stopChat(on chatRoomId: ChatRoomId)
    func isConnectionAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool
    func isOpponentUserAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration]
    func createChatRoom(userId: UserId, opponentUserId: UserId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatRoomId
    func exitChatRoom(userId: UserId, on chatRoomId: ChatRoomId) async throws
    func readChatingHistory(userId: UserId, on chatRoomId: ChatRoomId, with communityRecruitingContentId: CommunityRecruitingContentId) async throws -> ChatHistory
    func send(message: ChatMessage) throws
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws
    func exitChatRoom(userId: UserId, chatRoomId: ChatRoomId) async throws
}

final class DefaultChatRepository {
    private let chatService: ChatService
    let networkService: NetworkService
    let tokenStorage: TokenStorage
    
    init(
        chatService: ChatService,
        networkService: NetworkService,
        tokenStorage: TokenStorage
    ) {
        self.chatService = chatService
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
}

// MARK: ChatRepository Conformation
extension DefaultChatRepository: ChatRepository {
    func startChat(
        userId: Int64,
        userNickname nickname: String,
        on chatRoomId: ChatRoomId,
        _ continuation: AsyncThrowingStream<ChatMessage, any Error>.Continuation
    ) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            try chatService.connect(token: token.accessToken, on: chatRoomId, userId: userId, userNickname: nickname, continuation: continuation)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            try chatService.connect(token: tokens.accessToken, on: chatRoomId, userId: userId, userNickname: nickname, continuation: continuation)
        } catch {
            throw error
        }
    }
    
    func stopChat(on chatRoomId: ChatRoomId) {
        chatService.disconnect(on: chatRoomId)
    }
    
    func isConnectionAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.isConnectionAvailable(token: token.accessToken, chatRoomId: chatRoomId)
            let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            return response.body.status
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.isConnectionAvailable(token: tokens.accessToken, chatRoomId: chatRoomId)
            let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            return response.body.status
        } catch {
            throw error
        }
    }
    
    func isOpponentUserAvailable(userId: UserId, on chatRoomId: ChatRoomId) async throws -> Bool {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.isOpponentUserAvailable(token: token.accessToken, chatRoomId: chatRoomId)
            let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            return response.body.status
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.isOpponentUserAvailable(token: tokens.accessToken, chatRoomId: chatRoomId)
            let response = try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
            return response.body.status
        } catch APIError.opponentUserHasLeft {
            return false
        } catch {
            throw error
        }
    }
    
    func readChatRooms(userId: UserId) async throws -> [ChatRoomConfiguration] {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.readChatrooms(token: token.accessToken)
            let response = try await networkService.request(endpoint: endpoint, for: ChatRoomListResponseEntity.self)
            return response.body.toDTO()
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
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
            guard let chatRoomId = response.body.toDTO() else {
                throw APIError.inactiveChatRoom
            }
            return chatRoomId
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let entity = ChatRoomConfigurationRequestEntity(communityRecruitingContentId: communityRecruitingContentId, opponentUserId: opponentUserId)
            let endpoint = Endpoint.createChatRoom(token: tokens.accessToken, configuration: entity)
            let response = try await networkService.request(endpoint: endpoint, for: ChatRoomConfigurationResponseEntity.self)
            guard let chatRoomId = response.body.toDTO() else {
                throw APIError.inactiveChatRoom
            }
            return chatRoomId
        } catch {
            throw error
        }
    }
    
    func exitChatRoom(userId: UserId, on chatRoomId: ChatRoomId) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.exitChatRoom(token: token.accessToken, chatRoomId: chatRoomId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
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
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.readChatHistory(token: tokens.accessToken, chatRoomId: chatRoomId, communityRecruitingContentId: communityRecruitingContentId)
            let response = try await networkService.request(endpoint: endpoint, for: ChatHistoryResponseEntity.self)
            return response.body.toDTO()
        } catch {
            throw error
        }
    }
    
    func send(message: ChatMessage) throws {
        Task {
            do {
                let entity = ChatEntity(chatMessage: message)
                try await chatService.send(message: entity)
            } catch {
                throw error
            }
        }
    }
    
    func reportAndExitChatRoom(userId: UserId, opponentUserId: UserId, chatRoomId: ChatRoomId, report: Report) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.reportAndExitChatRoom(token: token.accessToken, chatRoomId: chatRoomId, userId: opponentUserId, report: report)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.reportAndExitChatRoom(token: tokens.accessToken, chatRoomId: chatRoomId, userId: opponentUserId, report: report)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
    
    func exitChatRoom(userId: UserId, chatRoomId: ChatRoomId) async throws {
        let token = try tokenStorage.fetch(by: userId)
        
        do {
            let endpoint = Endpoint.exitChatRoom(token: token.accessToken, chatRoomId: chatRoomId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch APIError.accessTokenExpired {
            let tokens = try await reissueTokens(userId: userId, token.refreshToken)
            
            let endpoint = Endpoint.exitChatRoom(token: tokens.accessToken, chatRoomId: chatRoomId)
            try await networkService.request(endpoint: endpoint, for: DefaultResponseEntity.self)
        } catch {
            throw error
        }
    }
}
