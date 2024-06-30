//
//  ChatRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

final class DefaultChatRepository {
    private let chatService: ChatService
    private let networkService: NetworkService
//    private let chattingStorage:
    
    @Published var messages: [MessageEntity] = []
    
    init(
        chatService: ChatService,
        networkService: NetworkService
    ) {
        self.chatService = chatService
        self.networkService = networkService
    }
    
    // TODO: 나머지 의존성 객체 완성되면 해당 로직 추가할 것
    func openChatRoom(roomID: String) async throws {
        // 그 전에 채팅기록히스토리 읽고
        // 그 다음 네트워크서비스에 요청해서 채팅기록 확보하고 어펜드 한다음 이하 계속
        
        let endpoint = Endpoint.chatRoom(chatRoomId: roomID)
        try await chatService.connect(endpoint: endpoint)
        let stream = try await chatService.receive()
        for try await message in stream {
            messages.append(message)
        }
    }
}
