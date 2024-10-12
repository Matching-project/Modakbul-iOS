//
//  ChatViewModel.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 10/12/24.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    @Published var communityRecruitingContentTitle: String = ""
    @Published var locationName: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var textOnTextField: String = ""
    
    @Published var opponentUser: User?
    @Published var isReported: Bool = false
    @Published var isExit: Bool = false
    
    private var chatRoomId: Int64 = Constants.temporalId
    
    private let chatUseCase: ChatUseCase
    private let userBusinessUseCase: UserBusinessUseCase
    private var previousDate: Date?
    
    private var cancellables = Set<AnyCancellable>()
    private let chatHistorySubject = PassthroughSubject<ChatHistory, Never>()
    private let opponentUserSubject = PassthroughSubject<User, Never>()
    private let newMessageSubject = CurrentValueSubject<ChatMessage?, Never>(nil)
    private let exitPerformSubject = PassthroughSubject<Bool, Never>()
    
    init(
        chatUseCase: ChatUseCase,
        userBusinessUseCase: UserBusinessUseCase
    ) {
        self.chatUseCase = chatUseCase
        self.userBusinessUseCase = userBusinessUseCase
        subscribe()
    }
    
    private func subscribe() {
        chatHistorySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatHistory in
                guard let self = self else { return }
                
                communityRecruitingContentTitle = chatHistory.communityRecruitingContentTitle
                locationName = chatHistory.locationName
                // TODO: - 채팅내역 불러오기 API 변경 필요
//                let newMessages = chatHistory.messages.map { (content, timestamp) in
//                    return ChatMessage(
//                        chatRoomId: self.chatRoomId,
//                        senderId: <#T##Int64#>,
//                        senderNickname: <#T##String#>,
//                        content: content,
//                        sendTime: timestamp,
//                        unreadCount: <#T##Int#>
//                    )
//                }
                
            }
            .store(in: &cancellables)
        
        opponentUserSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.opponentUser = user
            }
            .store(in: &cancellables)
        
        newMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message {
                    self?.compare(currentMessage: message)
                }
            }
            .store(in: &cancellables)
        
        exitPerformSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isExit = result
            }
            .store(in: &cancellables)
    }
    
    func configureView(chatRoomId: Int64) {
        self.chatRoomId = chatRoomId
        self.isExit = false
    }
    
    func readChatingHistory(userId: Int64,
                            on chatRoomId: Int64,
                            with communityRecruitingContentId: Int64
    ) {
        Task {
            do {
                let chatHistory = try await chatUseCase.readChatingHistory(userId: userId,
                                                                           on: chatRoomId,
                                                                           with: communityRecruitingContentId)
                chatHistorySubject.send(chatHistory)
            } catch {
                print(error)
            }
        }
    }
    
    private func compare(currentMessage: ChatMessage) {
        //MARK: - 전체 메세지 개수가 1개면 비교하지 않습니다.
        compare(latestMessage: messages.last, currentMessage: currentMessage)
        messages.append(currentMessage)
    }
    
    /// 마지막으로 보낸 메시지와 현재 보낸 메세지를 비교합니다. 이를 통해, 날짜가 바꼈음을 알리는 시스템 메시지를 삽입합니다. senderId: -1이면 시스템 메세지로 취급하고 시간을 알려주는 용도로 사용됩니다.
    /// - Parameters:
    ///   - latestMessage: 마지막으로 보낸 메시지입니다.
    ///   - currentMessage: 현재 보낸 메세지입니다.
    private func compare(latestMessage: ChatMessage?, currentMessage: ChatMessage) {
        guard let latestMessage = latestMessage else {
            messages.append(ChatMessage(chatRoomId: currentMessage.chatRoomId,
                                        senderId: Constants.temporalId,
                                        senderNickname: "",
                                        content: "",
                                        sendTime: currentMessage.sendTime,
                                        unreadCount: 0))
            return
        }
        
        let latestMessageDate = Calendar.current.startOfDay(for: latestMessage.sendTime)
        let currentMessageDate = Calendar.current.startOfDay(for: currentMessage.sendTime)
        
        if latestMessageDate != currentMessageDate {
            messages.append(ChatMessage(chatRoomId: currentMessage.chatRoomId,
                                        senderId: Constants.temporalId,
                                        senderNickname: "",
                                        content: "",
                                        sendTime: currentMessage.sendTime,
                                        unreadCount: 0))
        }
    }
}

// MARK: Interfaces for ChatUseCase
extension ChatViewModel {
    func startChat(userId: Int64, userNickname nickname: String) async {
        let stream = AsyncThrowingStream<ChatMessage, any Error> { continuation in
            Task {
                do {
                    try await chatUseCase.startChat(userId: userId, userNickname: nickname, on: chatRoomId, continuation)
                } catch {
                    print(error)
                }
            }
        }
        
        do {
            for try await message in stream {
                messages.append(message)
            }
        } catch {
            print(error)
        }
    }
    
    func stopChat() {
        chatUseCase.stopChat(on: chatRoomId)
    }
    
    func send(userId: Int64, userNickname: String) {
        guard textOnTextField.isEmpty == false else { return }
        
        let chatMessage = ChatMessage(
            chatRoomId: chatRoomId,
            senderId: userId,
            senderNickname: userNickname,
            content: textOnTextField,
            sendTime: .now,
            unreadCount: 1
        )
            
        textOnTextField.removeAll()
        
        do {
            try chatUseCase.send(message: chatMessage)
            newMessageSubject.send(chatMessage)
        } catch {
            print("채팅메세지 전송 실패: \(error)")
        }
    }
    
    func exitChatRoom(userId: Int64, chatRoomId: Int64) {
        Task {
            do {
                try await chatUseCase.exitChatRoom(userId: userId, chatRoomId: chatRoomId)
                exitPerformSubject.send(true)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: Interfaces for UserBusinessUseCase
extension ChatViewModel {
    func fetchOpponentUserProfile(userId: Int64, opponentUserId: Int64) {
        Task {
            do {
                let opponentUser = try await userBusinessUseCase.readOpponentUserProfile(userId: userId, opponentUserId: opponentUserId)
                opponentUserSubject.send(opponentUser)
            } catch {
                print(error)
            }
        }
    }
}
