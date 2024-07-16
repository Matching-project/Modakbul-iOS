//
//  ChatRepository.swift
//  Modakbul
//
//  Created by Swain Yun on 7/1/24.
//

import Foundation

protocol ChatRepository {
    func openChatRoom(with user: User, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) throws
    func closeChatRoom()
    func send(message: String) throws
}

final class DefaultChatRepository {
    private let chatService: ChatService
    private let networkService: NetworkService
//    private let chattingStorage:
    
    init(
        chatService: ChatService,
        networkService: NetworkService
    ) {
        self.chatService = chatService
        self.networkService = networkService
    }
}

// MARK: ChatRepository Conformation
extension DefaultChatRepository: ChatRepository {
    // TODO: 나머지 의존성 객체 완성되면 해당 로직 추가할 것
    /**
     채팅방이 열릴 때 호출하며 소켓을 엽니다.
     
     - Note:
        1. 송,수신자 이메일로 연결되어야 하는데 그 부분 어떻게 가져올 것인지? (API 명세서 도출 해야함)
        2. 채팅기록저장소 또는 서버로부터 채팅방 정보 읽어올 때 송,수신자 정보도 같이 확인해서 이 레포에서 사용 가능.
     */
    func openChatRoom(with user: User, _ continuation: AsyncThrowingStream<ChatMessage, Error>.Continuation) throws {
        // 그 전에 채팅기록히스토리 읽고
        // 그 다음 네트워크서비스에 요청해서 채팅기록 확보하고 어펜드 한다음 이하 계속
        
        let endpoint = Endpoint.chatRoom(from: "내 이메일", to: user.email)
        try chatService.connect(endpoint: endpoint, continuation)
    }
    
    // TODO: 기능 분석 및 구체화 필요.
    /**
     채팅방을 나갈 때 호출하며 소켓을 닫습니다.
     
     - Note:
        1. 채팅방 안에서 채팅방을 나가기 하는 것에 대해 대응할 코드 필요
        2. 채팅 없이 채팅방을 나왔을 때 채팅방 삭제하는 코드 필요 (회의 예정)
        3. 이 외에 추가 코드 필요한지 생각해보아야 함
     */
    func closeChatRoom() {
        chatService.disconnect(.endChatting)
    }
    
    func send(message: String) throws {
        let chatMessage = ChatMessage(from: "내 이메일", to: "상대 이메일", text: message, timestamp: .now)
        Task {
            try await chatService.send(message: chatMessage)
        }
    }
}
