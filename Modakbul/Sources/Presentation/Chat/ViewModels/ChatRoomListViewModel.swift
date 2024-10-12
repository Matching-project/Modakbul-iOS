//
//  ChatRoomListViewModel.swift
//  Modakbul
//
//  Created by Swain Yun on 10/8/24.
//

import Foundation
import Combine
import SwiftData

final class ChatRoomListViewModel: ObservableObject {
    @Published var configurations: [ChatRoomConfiguration] = []
    
    private let chatRoomsSubject = PassthroughSubject<[ChatRoomConfiguration], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let chatUseCase: ChatUseCase
    
    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
        subscribe()
    }
    
    private func subscribe() {
        chatRoomsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] configurations in
                self?.configurations = configurations
            }
            .store(in: &cancellables)
    }
}

// MARK: Interfaces
extension ChatRoomListViewModel {
    func readChatRooms(userId: Int64) {
        Task {
            do {
                let configurations = try await chatUseCase.readChatRooms(userId: userId)
                chatRoomsSubject.send(configurations)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteChatRoom(_ chatRoom: ChatRoom, on userId: Int64, by modelContext: ModelContext) {
        Task {
            do {
                try await chatUseCase.deleteChat(userId: userId, on: chatRoom.id)
                modelContext.delete(chatRoom)
            } catch {
                print(error)
            }
        }
    }
}
